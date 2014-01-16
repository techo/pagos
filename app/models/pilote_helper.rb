class PiloteHelper
  GET_FAMILIES_FOR_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/familias?geografias="
  GET_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/geografias"

  def self.get_families(users)
    begin
      families_path = compose_pilote_families_path(users)
      response = JSON.parse(make_https_request(families_path))
      families = group_by_family(response)
      sort_families_by_geography(families)
    rescue Exception => e
      JSON.parse("{}")
    end
  end

  def self.get_geographies
    begin
      response = make_https_request(GET_GEOGRAPHIES_PATH)
      JSON.parse(response)
    rescue Exception => e
      JSON.parse("{}")
    end
  end

  def self.compose_pilote_families_path(users)
    geographies = ""

    users.each do |user|
      volunteer = user.becomes(Volunteer)
      volunteer_geographies_ids = volunteer.geographies.map{|geography| geography.village_id}.join(',');
      geographies += volunteer_geographies_ids
    end

    "#{GET_FAMILIES_FOR_GEOGRAPHIES_PATH}(#{geographies})"
  end

  private
  def self.sort_families_by_geography(sorted_families)
    families_by_geography = {}
    sorted_families.each do |family|
      families_by_geography[family["geografia"]] = [] unless families_by_geography[family["geografia"]]
      families_by_geography[family["geografia"]] << family
    end
    families_by_geography
  end

  def self.group_by_family(families)
    sorted_families = families.sort_by do |family|
      family["jefe_de_familia"]
    end
  end

  def self.make_https_request(path)
    uri = URI.parse(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['PILOTE_USERNAME'], ENV['PILOTE_PASSWORD'])
    http.request(request).body
  end
end
