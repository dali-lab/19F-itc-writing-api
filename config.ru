# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

env = ENV['RAILS_ENV'] ||= 'development'

unless %w{development test}.include?(env.downcase)
  use Rack::Static, :urls => Dir.glob('public/*').map { |f| f.sub(/^public/,'') }, :root => "public"
end

run Rails.application
