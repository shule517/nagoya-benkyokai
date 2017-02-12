require 'uri'
require_relative './http'
require_relative './event_base'
require_relative './connpass_user'

class ConnpassEvent < EventBase
  def source
    'connpass'
  end

  def catch
    if @catch != ''
      @catch + '<br>' + @description.gsub(/<\/?[^>]*>/, '')
    else
      @description.gsub(/<\/?[^>]*>/, '')
    end
  end

  def group_url
    series[:url]
  end

  def group_id
    series[:id]
  end

  def group_title
    series[:title]
  end

  def group_logo
    @group_logo ||= event_doc.css('.event_group_area > div.group_inner > div > a').attribute('style').value.match(%r{url\((.*)\)})[1]
  rescue
    ''
  end

  def logo
    @logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
  end

  def users
    puts "get users : #{title}"

    users = []
    participation_doc.css('.applicant_area > .participation_table_area > .common_table > tbody > tr').each do |line|
      user = line.css('.user > .user_info > .image_link')
      return [] if user.empty? # 参加者がいない場合

      id = user.attribute('href').value.gsub('https://connpass.com/user/', '').gsub('/', '')
      social_ids = {}
      name = user.css('img').attribute('alt').value
      image_url = user.css('img').attribute('src').value

      line.css('td.social > a').each do |social|
        url = social.attribute('href').value
        get_social_id(url, social_ids)
      end
      users << ConnpassUser.new(connpass_id: id, twitter_id: social_ids[:twitter_id], facebook_id: social_ids[:facebook_id], github_id: social_ids[:github_id], name: name, image_url: image_url)
    end
    users.sort_by! { |user| user.twitter_id }.reverse
  rescue => e
    p e
    []
  end

  def owners
    puts "get owners : #{title}"

    begin
      owners = []
      owner = participation_doc.css('.concerned_area > .common_table > tbody').first
      if !owner.nil? # イベント参加者ページがある場合
        owner.css('tr').each do |user|
          user_info = user.css('.user_info')
          url = user_info.css('.image_link').attribute('href').value
          id = url.gsub('https://connpass.com/user/', '').gsub('/open/', '');
          social_ids = {}
          name = user_info.css('.display_name > a').text
          image_url = user_info.css('.image_link > img').attribute('src').value
          user.css('.social > a').each do |social|
            url = social.attribute('href').value
            get_social_id(url, social_ids)
          end
          owners << ConnpassUser.new(connpass_id: id, twitter_id: social_ids[:twitter_id], facebook_id: social_ids[:facebook_id], github_id: social_ids[:github_id], name: name, image_url: image_url)
        end
      else # イベント参加者ページがない場合
        # TODO メソッド化 イベントページから参加者を取得するメソッド
        # TODO メソッド化 ユーザIDからtwitteridを取得するメソッド
        event_doc.css('.owner_list > li > .image_link').each do |user|
          url = user.attribute('href').value
          id = url.gsub('https://connpass.com/user/', '').gsub('/open/', '')
          twitter_id = '' # TODO twitterをユーザページから取得する
          img = user.css('img')
          name = img.attribute('alt').value
          image_url = img.attribute('src').value
          owners << ConnpassUser.new(connpass_id: id, twitter_id: twitter_id, name: name, image_url: image_url)
        end
      end
      owners.sort_by! { |user| user.twitter_id }.reverse
    rescue
    end
    owners
  end

private
  def get_social_id(url, social_ids)
    if url.include?('https://twitter.com/intent/user?screen_name=')
      social_ids[:twitter_id] = url.gsub('https://twitter.com/intent/user?screen_name=', '')
    elsif url.include?('https://www.facebook.com/app_scoped_user_id/')
      social_ids[:facebook_id] = url.gsub('https://www.facebook.com/app_scoped_user_id/', '')
    elsif url.include?('https://github.com/')
      social_ids[:github_id] = url.gsub('https://github.com/', '')
    else
      puts "x connpass : #{url}"
    end
  end

  def participation_doc
    if group_url.nil?
      url = 'https://connpass.com/'
    else
      url = group_url
    end
    @participation_doc ||= Shule::Http.get_document("#{url}event/#{event_id}/participation/#participants")
  rescue
    Nokogiri::HTML('')
  end

  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url)
  end

  def user_doc
    @user_doc ||= Shule::Http.get_document("http://connpass.com/user/#{owner_nickname}")
  end
end
