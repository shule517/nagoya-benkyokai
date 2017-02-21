require 'uri'
require_relative './http'
require_relative './event_base'
require_relative './doorkeeper_user'

class DoorkeeperEvent < EventBase
  def source
    'doorkeeper'
  end

  def catch
    description.gsub(/<\/?[^>]*>/, '')
  end

  def group_url
    @group_url ||= event_doc.css('//meta[property="og:url"]/@content').to_s.gsub(/events.*/, '')
  end

  def group_id
    data[:group]
  end

  def group_title
    @group_title ||= event_doc.css('//meta[property="og:site_name"]/@content').to_s
  end

  def logo
    @logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
  end

  def group_logo
    @group_logo ||= event_doc.css('div.community-profile-picture > a > img').attribute('src').value
  end

  def users
    users = []
    participation_doc.css('.user-profile-details').each do |user|
      social_ids = {}
      name = user.css('div.user-name').children.text
      image_url = user.css('img').attribute('src').value
      user.css('div.user-social > a.external-profile-link').each do |social|
        url = social.attribute('href').value
        get_social_id(url, social_ids)
      end
      users << DoorkeeperUser.new(twitter_id: social_ids[:twitter_id], facebook_id: social_ids[:facebook_id], github_id: social_ids[:github_id], linkedin_id: social_ids[:linkedin_id], name: name, image_url: image_url)
    end
    users.sort_by! { |user| user.twitter_id }.reverse
  rescue
    puts "no users event:#{title} / #{group_url} / #{event_id}"
    []
  end

  def owners
    owners = []
    group_doc.css('.with-gutter > .row > div > .user-profile > .user-profile-details').each do |owner|
      name = owner.css('.user-name').text
      social_ids = {}
      image_url = owner.css('img').attribute('src').value
      owner.css('.user-social > .external-profile-link').each do |social|
        url = social.attribute('href').value
        get_social_id(url, social_ids)
      end
      owners << DoorkeeperUser.new(twitter_id: social_ids[:twitter_id], facebook_id: social_ids[:facebook_id], github_id: social_ids[:github_id], linkedin_id: social_ids[:linkedin_id], name: name, image_url: image_url)
    end
    owners.sort_by! { |user| user.twitter_id }.reverse
  end

private
  def get_social_id(url, social_ids)
    if url.include?('http://twitter.com/')
      social_ids[:twitter_id] = url.gsub('http://twitter.com/', '')
    elsif url.include?('https://www.facebook.com/app_scoped_user_id/')
      social_ids[:facebook_id] = url.gsub('https://www.facebook.com/app_scoped_user_id/', '')
    elsif url.include?('http://www.facebook.com/profile.php?id=')
      social_ids[:facebook_id] = url.gsub('http://www.facebook.com/profile.php?id=', '')
    elsif url.include?('https://www.facebook.com/')
      social_ids[:facebook_id] = url.gsub('https://www.facebook.com/', '')
    elsif url.include?('https://github.com/')
      social_ids[:github_id] = url.gsub('https://github.com/', '')
    elsif url.include?('http://www.linkedin.com/in/')
      social_ids[:linkedin_id] = url.gsub('http://www.linkedin.com/in/', '')
    elsif url.include?('https://www.linkedin.com/in/')
      social_ids[:linkedin_id] = url.gsub('https://www.linkedin.com/in/', '')
    elsif url.include?('http://www.linkedin.com/pub/')
      social_ids[:linkedin_id] = url.gsub('http://www.linkedin.com/pub/', '')
    else
      puts "x doorkeeper : #{url}"
    end
  end

  def group_doc
    @group_doc ||= Shule::Http.get_document("#{group_url}members")
  end

  def participation_doc
    @participation_doc ||= Shule::Http.get_document("#{group_url}events/#{event_id}/participants")
  end

  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url)
  end
end
