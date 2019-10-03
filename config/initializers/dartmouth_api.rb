Rails.configuration.dartmouth_api_key =
  case Rails.env
  when 'development', 'test'
    ENV['DARTMOUTH_API_KEY']
  else
    begin IO.read(ENV['DARTMOUTH_API_KEY']).chomp rescue "" end
  end
Rails.configuration.dartmouth_api_host = "https://#{ENV['DARTMOUTH_API_HOST']}/api/"
Rails.configuration.dartmouth_api_people_scope = 'urn:dartmouth:people:read.sensitive'
Rails.configuration.dartmouth_api_jwt = ''
Rails.configuration.dartmouth_api_jwt_expiration = DateTime.now

