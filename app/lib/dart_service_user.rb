module DartServiceUser
  module Rails

    def self.included(model)
      model.send(:include, Filters)
      model.send(:include, PublicMethods)
      model.send(:include, ProtectedMethods)
    end

    module Filters
      def self.included(model)
        model.class_eval do
          validate :verify_person, :on => :create
        end
      end
    end

    module PublicMethods

      def profile
        @profile ||= get_dartservice_profile
      end

      def create_from_profile(can_exist = false)
        return self unless new_record?
        # If our :netid field is set, look for an existing record
        exists = User.find_by_netid(self.netid)
        if exists.nil? # Either no netid, or we didn't find a matching record
          return nil unless profile # no unique websvcs match
          exists = User.find_by_netid(profile.netid)
        end
        return(can_exist ? exists : self) if exists
        save and return self
      end
    end

    module ProtectedMethods
      protected

      # Standard set of fields to pull from the dartservice with corresponding user attribute names
      def profile_fields
        { netid: "netid",
          name: "name",
          first_name: "firstName",
          last_name: "lastName",
          email: "email"
        }
      end

      # Helper method to map the fields of the profile to the model attributes that
      # share the same (downcased) name.
      def profile_to_attributes
        profile_fields.each do |key, value|
          setter_name = value.downcase+'='
          attr_name = value.downcase.to_sym
          if self.respond_to?(setter_name)
            self[attr_name] = profile[key.to_s]
          end
        end
      end

      # Helper method for performing the dartservice find operation. Returns nil if no match on the netid was found.
      def get_dartservice_profile
        return nil if !self.netid
        person = DartService.get_person(self.netid)
        puts person.inspect
        person
      end

      # This is the active record filter/callback, which is performed prior to a
      # new record being saved to the database. This allows us to hook into the
      # dartservice and peform a check to make sure we're adding a unique netid.
      def verify_person
        if name.nil? || netid.nil? # We haven't already performed a dartservice lookup
          return false unless profile # false unless there's a single dartservice match
          profile_to_attributes # populate our attributes
        end
        return unique_netid? # false if the profile netid is already in the table
      end
    end

    # We also need to make sure that the netid of the found profile hasn't already
    # been saved to our User table. We pass back a -true- if our netid is unique.
    def unique_netid?
      if User.find_by_netid(netid)
        return false
      else
        return true
      end
    end

  end
end
