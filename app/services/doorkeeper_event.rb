#coding: utf-8
require 'uri'
require_relative "./http"
require_relative './event_base'
require_relative './doorkeeper_user'

class DoorkeeperEvent < EventBase
  def source
    'doorkeeper'
  end

  def catch
    description.gsub(/<\/?[^>]*>/, "")
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

  def group_logo
    @group_logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
  end

  def logo
    begin
      @logo ||= event_doc.css('div.event-banner-image > img').attribute('src').value
    rescue
      @logo = group_logo
    end
  end

  def users
    begin
      users = []
      participation_doc.css('.user-profile-details').each do |user|
        twitter_id = ''
        facebook_id = ''
        github_id = ''
        linkedin_id = ''
        name = user.css('div.user-name').children.text
        image_url = user.css('img').attribute('src').value
        user.css('div.user-social > a.external-profile-link').each do |social|
          url = social.attribute('href').value
          if url.include?('http://twitter.com/')
            twitter_id = url.gsub('http://twitter.com/', '')
          elsif url.include?('https://www.facebook.com/app_scoped_user_id/')
            facebook_id = url.gsub('https://www.facebook.com/app_scoped_user_id/', '')
          elsif url.include?('https://github.com/')
            github_id = url.gsub('https://github.com/', '')
          elsif url.include?('http://www.linkedin.com/in/')
            linkedin_id = url.gsub('http://www.linkedin.com/in/', '')
          end
        end
        users << DoorkeeperUser.new({twitter_id: twitter_id, facebook_id: facebook_id, github_id: github_id, linkedin_id: linkedin_id, name: name, image_url: image_url})
      end
      users.sort_by! {|user| user.twitter_id}.reverse
    rescue
      puts "no users event:#{title} / #{group_url} / #{event_id}"
      []
    end
  end

  def owners
    owners = []
    group_doc.css('.with-gutter > .row > div > .user-profile > .user-profile-details').each do |owner|
      name = owner.css('.user-name').text
      twitter_id = ''
      facebook_id = ''
      github_id = ''
      linkedin_id = ''
      image_url = owner.css('img').attribute('src').value
      owner.css('.user-social > .external-profile-link').each do |social|
        url = social.attribute('href').value
        if url.include?('http://twitter.com/')
          twitter_id = url.gsub('http://twitter.com/', '')
        elsif url.include?('https://www.facebook.com/app_scoped_user_id/')
          facebook_id = url.gsub('https://www.facebook.com/app_scoped_user_id/', '')
        elsif url.include?('https://github.com/')
          github_id = url.gsub('https://github.com/', '')
        elsif url.include?('http://www.linkedin.com/in/')
          linkedin_id = url.gsub('http://www.linkedin.com/in/', '')
        end
      end
      owners << DoorkeeperUser.new({twitter_id: twitter_id, facebook_id: facebook_id, github_id: github_id, linkedin_id: linkedin_id, name: name, image_url: image_url})
    end
    owners.sort_by! {|user| user.twitter_id}.reverse
  end

  private
  def group_doc
    @group_doc ||= Shule::Http.get_document("#{group_url}/members")
  end

  def participation_doc
    @participation_doc ||= Shule::Http.get_document("#{group_url}/events/#{event_id}/participants")
  end

  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url)
  end
end
