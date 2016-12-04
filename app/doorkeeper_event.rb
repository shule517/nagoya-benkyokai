#coding: utf-8
require 'uri'
require_relative "./http"
require_relative './event'

class DoorkeeperEvent < Event
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
        id = user.css('div.user-name').children.text
        twitter_id = ''
        name = user.css('div.user-name').children.text
        image = user.css('img').attribute('src').value
        user.css('div.user-social > a.external-profile-link').each do |social|
          url = social.attribute('href').value
          if url.include?('twitter')
            twitter_id = url.gsub('http://twitter.com/', '')
            id = twitter_id
            break
          end
        end
        users << {id: id, twitter_id: twitter_id, name: name, image: image}
      end
      users
    rescue
      puts "no users event:#{title} / #{group_url} / #{event_id}"
      []
    end
  end

  def owners
    owners = []
    group_doc.css('.with-gutter > .row > div > .user-profile > .user-profile-details').each do |owner|
      id = ''
      name = owner.css('.user-name').text
      id = name # social登録していない人は名前を使う
      twitter_id = ''
      image = owner.css('img').attribute('src').value
      owner.css('.user-social > .external-profile-link').each do |social|
        url = social.attribute('href').value
        if url.include?('twitter')
          twitter_id = url.gsub('http://twitter.com/', '')
          id = twitter_id
          break
        end
      end
      owners << {id: id, twitter_id: twitter_id, name: name, image: image}
    end
    owners
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
