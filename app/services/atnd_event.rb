require 'uri'
require_relative './http'
require_relative './event_base'
require_relative './atnd_user'

class AtndEvent < EventBase
  def source
    'atnd'
  end

  def catch
    if @catch.present?
      @catch + '<br>' + @description.gsub(/<\/?[^>]*>/, '')
    else
      @description.gsub(/<\/?[^>]*>/, '')
    end
  end

  def logo
    @logo ||= get_logo
  end

  def get_logo
    event_doc.css('.events-show-img > img/@data-original').each do |img|
      return "https://atnd.org#{img}"
    end
    '/img/atnd.png'
  end

  def users
    users = []
    event_doc.css('#members-join ol li span').each do |user|
      img = user.css('img/@data-original')
      image_url = ''
      if img.present?
        image_url = "https:#{img}" if img !~ /https/
      else
        image_url = 'https://atnd.org/images/icon/default_latent.png'
      end
      id = user.css('a/@href').text.gsub('/users/', '')
      name = user.css('a').text
      social_ids = get_social_id(id)
      users << AtndUser.new(social_ids.merge(atnd_id: id, name: name, image_url: image_url))
    end
    users.sort_by! { |user| user.twitter_id }.reverse
  end

  def owners
    owner_info = event_doc.css('#user-id')
    return [] if owner_info.empty?

    src = event_doc.css('.events-show-info img/@src').text
    image_url = (src == '/images/icon/default_latent.png') ? "https://atnd.org#{src}" : "https:#{src}"

    id = owner_info.attribute('href').value.gsub('/users/', '')
    social_ids = get_social_id(id)

    [AtndUser.new(social_ids.merge(atnd_id: id, name: owner_nickname, image_url: image_url))]
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

  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url, false)
  end
end
