if (Rails.env != 'production' or ENV['IS_INTEGRATION'] == 'true')
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end
