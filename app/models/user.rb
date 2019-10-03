class User < ApplicationRecord
  include DartServiceUser::Rails

  validates_uniqueness_of :netid, :case_sensitive => false
  validates_presence_of :netid
  validates_presence_of :name

  default_scope { order('lastname, firstname') }

  def is_admin
    'admin' == role
  end

end
