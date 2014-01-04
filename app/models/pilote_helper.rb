class PiloteHelper
  GET_FAMILIES_FOR_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/familias?geografias="
  GET_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/geografias"

  
  def self.get_families(current_user)
    begin
      families_uri = self.compose_pilote_families_uri current_user.id
      response = Net::HTTP.get(families_uri)
      JSON.parse(response).sort_by { |family| family["jefe_de_familia"]}
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
end
