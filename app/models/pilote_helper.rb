class PiloteHelper
  GET_FAMILIES_FOR_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/familias?geografias=%282089%29"
  GET_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/geografias"

  def self.get_families
    begin
      response = Net::HTTP.get(URI.parse(GET_FAMILIES_FOR_GEOGRAPHIES_PATH ))
      JSON.parse(response)
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
end
