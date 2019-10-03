# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :db do
    desc "Empty all Model tables - ready for fresh db:seed"
    task :clean => :environment do
      conn = ActiveRecord::Base.connection
      tables = conn.tables
      tables.delete "ar_internal_metadata"
      tables.delete "schema_migrations"
      tables.each { |t| conn.execute("DELETE FROM #{t}") }
    end

    desc "Drop all tables - ready for fresh db:migrate"
    task :drop_tables => :environment do
      conn = ActiveRecord::Base.connection
      tables = conn.tables
      tables.each { |t| conn.execute("DROP TABLE #{t}") }
    end
  end
