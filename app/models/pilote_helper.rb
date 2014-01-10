class PiloteHelper
  GET_FAMILIES_FOR_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/familias?geografias="
  GET_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/geografias"

  
  def self.get_families(current_user)
    begin
      families_uri = self.compose_pilote_families_uri current_user.id
      response = Net::HTTP.get(families_uri)
      sorted_families = JSON.parse(response).sort_by { |family| family["jefe_de_familia"]}
      sort_families_by_geography(sorted_families)
    rescue
      JSON.parse("{}")
    end
  end

  def self.get_geographies
    begin
      response = Net::HTTP.get(URI.parse(GET_GEOGRAPHIES_PATH ))
      JSON.parse(response)
    rescue
      JSON.parse("{}")
    end
  end

  def self.compose_pilote_families_uri(current_user_id)
    current_user = User.find(current_user_id)
    volunteer = current_user.becomes(Volunteer)
    uri = "#{GET_FAMILIES_FOR_GEOGRAPHIES_PATH}(#{volunteer.geographies.map{|geography| geography.village_id}.join(',')})"
    URI.parse(uri)
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
end
