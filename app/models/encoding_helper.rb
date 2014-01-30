class EncodingHelper
  def self.encode_utf_8(text)
    unless text.nil?
      e = text.encode("cp1252", invalid: :replace, undef: :replace).force_encoding("UTF-8")
      e.valid_encoding? ? e : text
    end
  end
end
