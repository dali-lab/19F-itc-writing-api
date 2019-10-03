ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
# only required for Oracle
ENV['NLS_LANG'] ||= 'AMERICAN_AMERICA.UTF8'

require 'bundler/setup' # Set up gems listed in the Gemfile.
