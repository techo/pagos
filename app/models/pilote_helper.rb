class PiloteHelper
  METHOD_POST = 1
  METHOD_GET = 0
  GET_FAMILIES_FOR_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/familia?asentamientos="
  GET_FAMILIES_FOR_IDS = "#{ENV["PILOTE_ROOT"]}/api/v1/familia/detalles"
  GET_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/asentamiento"
  POST_PAYMENT_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/pago"

  def self.get_families(users)
    users = [users] unless users.is_a? Array
    begin
      families_path = compose_pilote_families_path(users)
      response = JSON.parse(make_https_request(families_path).body)
      families = group_by_family(response)
      sort_families_by_geography(families)
    rescue Exception => e
      Rails.logger.error(e.backtrace)
      {:error=>false}
    end
  end

  def self.get_geographies
    begin
      response = make_https_request(GET_GEOGRAPHIES_PATH).body
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

  def self.get_families_details(families_ids)
    form_data = {"idFamilias"=>self.build_family_request_ids(families_ids) }
    response = make_https_request(GET_FAMILIES_FOR_IDS, METHOD_POST, form_data).body
    JSON.parse(response)
  end

  def self.save_pilote_payment pilote_payment
    response = make_https_request(POST_PAYMENT_PATH, METHOD_POST, pilote_payment)
    response.is_a?(Net::HTTPSuccess)
  end

  private
  def self.sort_families_by_geography(sorted_families)
    families_by_geography = {}
    sorted_families.each do |family|
      families_by_geography[family["asentamiento"]] = [] unless families_by_geography[family["asentamiento"]]
      families_by_geography[family["asentamiento"]] << family
    end
    families_by_geography
  end

  def self.group_by_family(families)
    sorted_families = families.sort_by do |family|
      family["jefe_de_familia"]
    end
  end

  def self.make_https_request(path, method = METHOD_GET, data = nil)
    uri = URI.parse(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = ENV["SSL_CERT_FILE"]

    request = method == METHOD_GET ? Net::HTTP::Get.new(uri.request_uri) : Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth(ENV['PILOTE_USERNAME'], ENV['PILOTE_PASSWORD'])
    request.set_form_data(data) if data
    http.request(request)
  end

  def self.build_family_request_ids(ids)
    "(#{ids.join(', ')})"
  end
end
