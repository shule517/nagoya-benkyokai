require 'uri'
require_relative './http'
require_relative './event_base'
require_relative './atnd_user'

class AtndEvent < EventBase
  def source
    'atnd'
  end

  def catch
    if @catch != ''
      @catch + '<br>' + @description.gsub(/<\/?[^>]*>/, '')
    else
      @description.gsub(/<\/?[^>]*>/, '')
    end
  end

  def logo
    @logo ||= get_logo
  end

  def get_logo
    event_doc.css('.events-show-img > img').each do |img|
      logo = 'https://atnd.org' + img.attribute('data-original')
      return logo
    end
    return '/img/atnd.png'
  end

  def get_social_id(user_id)
    event_url = "https://atnd.org/users/#{user_id}"
    user_doc = Shule::Http.get_document(event_url, false)

    users_show_info = user_doc.css('#users-show-info')
    twitter_id = users_show_info.css('dl:nth-child(2) dd a').text
    facebook_id = users_show_info.css('dl:nth-child(3) dd').text

    twitter_id = nil if twitter_id == '-'
    facebook_id = nil if facebook_id == '-'

    { twitter_id: twitter_id, facebook_id: facebook_id }
  end

  def users
    users = []
    event_doc.css('#members-join ol li span').each do |user|
      img = user.css('img').attribute('data-original')
      image_url = ''
      if img.nil?
        image_url = 'https://atnd.org/images/icon/default_latent.png'
      else
        image_url = img.value
        image_url = 'https:' + image_url if image_url !~ /https/
      end
      a = user.css('a')
      name = a.text
      id = a.attribute('href').value.gsub('/users/', '')
      social_ids = get_social_id(id)
      users << AtndUser.new(social_ids.merge(atnd_id: id, name: name, image_url: image_url))
    end
    users.sort_by! { |user| user.twitter_id }.reverse
  end

  def owners
    owner_info = event_doc.css('#user-id')
    return [] if owner_info.empty?

    owners = []
    image = event_doc.css('.events-show-info img')
    src = image.attribute('src').value

    image_url = ''
    if src == '/images/icon/default_latent.png'
      image_url = 'https://atnd.org' + src
    else
      image_url = 'https:' + src
    end

    id = owner_info.attribute('href').value.gsub('/users/', '')
    social_ids = get_social_id(id)
    owners << AtndUser.new(atnd_id: id, twitter_id: social_ids[:twitter_id], facebook_id: social_ids[:facebook_id], github_id: nil, linkedin_id: nil, name: owner_nickname, image_url: image_url)
  end

  def group_url
    nil
  end

  def group_id
    nil
  end

  def group_title
    nil
  end

  def group_logo
    nil
  end

  private

  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url, false)
  end
end
