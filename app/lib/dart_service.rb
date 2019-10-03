require 'httpx'

class DartService

  DKEY = Rails.configuration.dartmouth_api_key
  DHOST = Rails.configuration.dartmouth_api_host

  DSCOPES = [Rails.configuration.dartmouth_api_people_scope]


  def self.get_confid_info
    @confid_info ||= retrieve_data("#{DHOST}/agreement_types/confid")
  end

  def self.confid_accepted?(netid)
    agreement = get_confid_agreement(netid)
    return agreement['is_accepted'] if agreement
    return false
  end

  def self.accept_confid(netid)
    agreement = get_confid_agreement(netid)
    payload = {}
    payload['is_accepted'] = true
    if agreement
      patch_data("#{DHOST}/agreements/#{agreement['id']}", payload.to_json)
    else
      payload['agreement_type_id'] = 'confid'
      payload['netid'] = netid
      post_data("#{DHOST}/agreements", payload.to_json)
    end
  end

  def self.get_person(netid)
    retrieve_data("#{DHOST}/people/#{netid}")
  end

  def self.get_student(netid)
    retrieve_data("#{DHOST}/students/#{netid}")
  end

  def self.student_status(status_id)
    return nil if status_id.nil?
    status = nil
    student_statuses.each {|h1| status = h1['name'] if h1['id'] == status_id}
    status
  end

  def self.personal_pronoun(pronoun_id)
    return nil if pronoun_id.nil?
    pronoun = nil
    personal_pronouns.each {|h1| pronoun = h1['name'] if h1['id'] == pronoun_id}
    pronoun
  end

  def self.get_photo_metadata(netid)
    photos = retrieve_data("#{DHOST}/people/#{netid}/photos")
    if photos
      photos.each {|photo| return photo if photo["metadata"]["type"] == "identification"}
    end
    # "identification" photo not found, return nil
    nil
  end

  def self.get_photo(asset_url)
    retrieve_data(asset_url, false)
  end


private
  def self.get_confid_agreement(netid)
    agreements = retrieve_data("#{DHOST}/agreements?netid=#{netid}")
    agreements.each do |agreement|
      if agreement['agreement_type_id'] == 'confid'
        return agreement
      end
    end
    return nil
  end

  def self.get_student_statuses
    retrieve_data("#{DHOST}/student_statuses")
  end

  def self.student_statuses
    @student_statuses ||= get_student_statuses
  end

  def self.get_personal_pronouns
    retrieve_data("#{DHOST}/personal_pronouns")
  end

  def self.personal_pronouns
    @personal_pronouns||= get_personal_pronouns
  end

  def self.jwt()
    if Rails.configuration.dartmouth_api_jwt.empty?
      puts("Acquiring JWT")
    else
      seconds_remaining = ((Rails.configuration.dartmouth_api_jwt_expiration - DateTime.now) * 24 * 60 * 60).to_i
      if seconds_remaining >= 30
        # current_jwt has at least 30 seconds before expiration
        puts("Reusing JWT")
        return Rails.configuration.dartmouth_api_jwt
      else
        puts("Refreshing JWT")
      end
    end

    url = "#{DHOST}/jwt"
    response = HTTPX.post(url, params: { "scope": DSCOPES.join(" ") }, ssl: {verify_mode: OpenSSL::SSL::VERIFY_NONE}, headers: { "Authorization": DKEY})
    case response.status
    when 200
      payload = JSON.parse(response.body)
      Rails.configuration.dartmouth_api_jwt = payload["jwt"]
      Rails.configuration.dartmouth_api_jwt_expiration = Time.at(payload["payload"]["exp"]).to_datetime
      puts payload["jwt"]
      return Rails.configuration.dartmouth_api_jwt
    when 403
      # puts('invalid key: '+DKEY)
      raise response.body
    else
      # puts('invalid key: '+DKEY)
      puts('status: '+response.status.to_s)
      raise response.body
    end
  end


  def self.auth_header
    headers = {'Authorization': 'Bearer '+jwt,'Content-Type':'application/json'}
  end


  def self.retrieve_data(url, json_format=true)
    response = HTTPX.get(url, ssl: {verify_mode: OpenSSL::SSL::VERIFY_NONE}, headers: auth_header)
    # puts('retrieve_data: '+url)
    case response.status
    when 200
      if json_format
        JSON.parse(response.body)
      else
        response.body
      end
    when 404
      nil
    else
      raise response.body
    end
  end


  def self.patch_data(url, payload)
    response = HTTPX.patch(url, ssl: {verify_mode: OpenSSL::SSL::VERIFY_NONE}, headers: auth_header, body: payload)
    # puts('patchj_data: '+url)
    case response.status
    when 200
      JSON.parse(response.body)
    when 404
      nil
    else
      raise response.body
    end
  end


  def self.post_data(url, payload)
    response = HTTPX.post(url, ssl: {verify_mode: OpenSSL::SSL::VERIFY_NONE}, headers: auth_header, body: payload)
    # puts('post_data: '+url)
    case response.status
    when 200, 201
      JSON.parse(response.body)
    else
      raise response.body
    end
  end


end