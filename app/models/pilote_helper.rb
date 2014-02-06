# encoding: UTF-8

class PiloteHelper
  GET_FAMILIES_FOR_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/familia?asentamientos="
  GET_FAMILIES_FOR_IDS = "#{ENV["PILOTE_ROOT"]}/api/v1/familia/detalles"
  GET_GEOGRAPHIES_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/asentamiento?pais=#{ENV["PILOTE_COUNTRY_CODE"]}"
  POST_PAYMENT_PATH = "#{ENV["PILOTE_ROOT"]}/api/v1/pago"

  def self.get_families(users)
    begin
      families_path = compose_pilote_families_path(Array(users))
      families = JSON.parse(make_https_request(families_path, Net::HTTP::Get).body)
      encode_families(families)
      group_families_by_geography(families)
    rescue Exception => e
      Rails.logger.error(e.backtrace)
      {:error=>false}
    end
  end

  def self.get_geographies
    response = make_https_request(GET_GEOGRAPHIES_PATH, Net::HTTP::Get).body
    JSON.parse(response)
  rescue Exception => e
    JSON.parse("{}")
  end

  def self.compose_pilote_families_path(users)
    geographies = ""

    users.each do |user|
      volunteer = user.becomes(Volunteer)
      volunteer_geographies_ids = volunteer.geographies.map{|geography| geography.village_id}.join(',');
      geographies += volunteer_geographies_ids
    end

    "#{GET_FAMILIES_FOR_GEOGRAPHIES_PATH}(#{geographies})&pais=#{ENV["PILOTE_COUNTRY_CODE"]}"
  end

  def self.get_families_details(families_ids)
    validates_families_details_params(families_ids)
    form_data = {"idFamilias"=>self.build_family_request_ids(families_ids), "idPais"=>"#{ENV["PILOTE_COUNTRY_CODE"]}" }
    response = make_https_request(GET_FAMILIES_FOR_IDS, Net::HTTP::Post, form_data).body
    response = JSON.parse(response)
    response = encode_families(response)
  end

  def self.save_pilote_payment pilote_payment
    response = make_https_request(POST_PAYMENT_PATH, Net::HTTP::Post, pilote_payment)
    response.is_a?(Net::HTTPCreated)
  end

  private
  def self.group_families_by_geography(families)
    grouped_families = families.group_by do |family|
      family['asentamiento']
    end
    grouped_families.each do |key, families|
      grouped_families[key] = sort_by_family_head families
    end
  end

  def self.encode_families(families)
    families.each do |family|
      encode_field(family, "jefe_de_familia")
      encode_field(family, "asentamiento")
      encode_field(family, "provincia")
      encode_field(family, "ciudad")
    end
    families
  end

  def self.encode_field(family, field)
    family[field] = EncodingHelper.encode_utf_8(family[field]) if !family[field].blank?
  end

  def self.sort_by_family_head(families)
    families.sort_by do |family|
      family["jefe_de_familia"].downcase
    end
  end

  def self.make_https_request(path, method, data = nil)
    uri = URI.parse(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = ENV["SSL_CERT_FILE"]

    request = method.new(uri.request_uri)
    request.basic_auth(ENV['PILOTE_USERNAME'], ENV['PILOTE_PASSWORD'])
    request.set_form_data(data) if data
    Rails.logger.info("Request: method: #{request.method}, url: #{path}, data: #{data}")
    response = http.request(request)
    Rails.logger.info("Response: code: #{response.code}, body: #{response.body.truncate(100)}")
    response
  end

  def self.build_family_request_ids(ids)
    "(#{ids.join(', ')})"
  end

  def self.validates_families_details_params(params)
    raise ArgumentError.new if (!params.instance_of?(Array) || params.size == 0)
  end
end
