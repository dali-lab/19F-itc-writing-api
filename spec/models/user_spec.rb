require 'rails_helper'

RSpec.describe User, type: :model do
  let(:test_profile) {
    OpenStruct.new({
          "chosen_pronoun"=>{
              "other_value"=>nil,
              "id"=>"SHE"
          },
          "legal_last_name"=>"Test",
          "last_name"=>"O'Test",
          "religion_id"=>nil,
          "dartcard_id"=>"100174581",
          "cache_date"=>"2019-06-21T18:30:04Z",
          "is_usa_citizen"=>false,
          "netid"=>"f0027k4",
          "prefix"=>nil,
          "legal_middle_name"=>"R",
          "legal_prefix"=>nil,
          "primary_affiliation"=>"Student",
          "legal_first_name"=>"Velma",
          "account_status"=>"Active",
          "is_confidential"=>false,
          "legal_name"=>"Velma R Test",
          "barcode"=>"23311001099915",
          "dartmouth_affiliation"=>"DART",
          "name"=>"Velmä R O'Test",
          "suffix"=>nil,
          "affiliations"=>[
              {
                  "name"=>"Student"
              }
          ],
          "telephone_numbers"=>[],
          "sis_person_id"=>"2787896",
          "expires_date"=>nil,
          "personal_email"=>nil,
          "addresses"=>[
              {
                  "street_line_2"=>"Student Financial Services",
                  "street_line_1"=>"McNutt Hall",
                  "country_id"=>"US",
                  "state_id"=>"NH",
                  "postal_code"=>"03755",
                  "city"=>"Hanover",
                  "address_type_id"=>"LO",
                  "to_date"=>nil,
                  "sis_id"=>"7f24a3ef-6780-4cc9-8641-fc6943c317ef",
                  "street_line_3"=>nil,
                  "from_date"=>"2014-07-16T04:00:00Z"
              }
          ],
          "citizenship_country_id"=>nil,
          "legal_suffix"=>nil,
          "middle_name"=>"R",
          "email"=>"Velma.R.O'Test.17@Dartmouth.edu",
          "legal_sex_id"=>"F",
          "campus_address"=>"Hinman Box 0070",
          "is_phi_user"=>nil,
          "created_date"=>nil,
          "chosen_gender"=>{
              "id"=>"W"
          },
          "first_name"=>"Velmä"
      })
   }

  describe "Creating a User" do

    before(:each) do
      # Bypass the IPaaS for testing - No actual calls should be made
      allow(DartService).to receive(:jwt).and_return('This would be the jwt token')
    end

    it "is not valid if given an invalid netid" do
      user = User.new(netid: '000000')

      # Mock the IPaaS calls for testing
      allow(user).to receive(:verify_person).and_return(false)
      allow(user).to receive(:get_dartservice_profile).and_return(nil)

      user.create_from_profile
      expect(user.valid?).to be false
    end

    it "does not create if given an invalid netid" do
      user = User.new(netid: '000000')

      # Mock the IPaaS calls for testing
      allow(user).to receive(:verify_person).and_return(false)
      allow(user).to receive(:get_dartservice_profile).and_return(nil)

      expect(user.save).to be false
    end

    it "is valid if given a valid netid" do
      user = User.new(netid: 'd000000')

      # Mock the IPaaS calls for testing
      allow(user).to receive(:get_dartservice_profile).and_return(test_profile)

      user.create_from_profile
      expect(user.valid?).to be true
    end

    it "creates a user record" do
      user = User.new(netid: 'd000000')

      # Mock the IPaaS calls for testing
      allow(user).to receive(:get_dartservice_profile).and_return(test_profile)

      expect { user.create_from_profile }.to change(User.all, :count).by(1)
    end

    it "uses IPaaS Service info to populate fields" do
      user = User.new(netid: 'd000000')

      # Mock the IPaaS calls for testing
      allow(user).to receive(:get_dartservice_profile).and_return(test_profile)

      user.create_from_profile

      expect(user.netid).to eq('f0027k4')
      expect(user.name).to eq("Velmä R O'Test")
      expect(user.firstname).to eq("Velmä")
      # expect(user.middle_initial).to eq("R")
      expect(user.lastname).to eq("O'Test")
      expect(user.email).to eq("Velma.R.O'Test.17@Dartmouth.edu")
      expect(user.deptclass).to eq(nil)
    end

  end
end
