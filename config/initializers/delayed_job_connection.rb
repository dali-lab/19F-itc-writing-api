Delayed::Job.class_eval do
  establish_connection ActiveRecord::Base.configurations["#{Rails.env}"]
end
