class ConnpassEvent < Hashie::Mash
  include EventFindable

  def source
    'connpass'
  end

  def catch
    desc = self[:description].gsub(/<\/?[^>]*>/, '')
    if self[:catch].present?
      "#{self[:catch]}<br>#{desc}"
    else
      desc
    end
  end

  def update_time
    self[:updated_at]
    # Time.parse(self[:updated_at])
  end

  def series
    self[:series] || {}
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
    @group_logo ||= event_doc.css('.event_group_area > div.group_inner > div > a/@style').text.match(%r{url\((.*)\)})[1]
  rescue
    ''
  end

  def logo
    @logo ||= event_doc.css('//meta[property="og:image"]/@content').text
  end

  def users
    puts "get users : #{title}"

    users = []
    participation_doc.css('.applicant_area > .participation_table_area > .common_table > tbody > tr').each do |line|
      user = line.css('.user > .user_info > .image_link')
      return [] if user.empty? # 参加者がいない場合

      social_ids = {}
      line.css('td.social > a/@href').each do |social_url|
        get_social_id(social_url.text, social_ids)
      end

      id = user.attribute('href').value.gsub('https://connpass.com/user/', '').gsub('/', '')
      name = user.css('img/@alt').text
      image_url = user.css('img/@src').text

      users << ConnpassUser.new(social_ids.merge(connpass_id: id, name: name, image_url: image_url))
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
      if owner # イベント参加者ページがある場合
        owner.css('tr').each do |user|
          user_info = user.css('.user_info')
          url = user_info.css('.image_link/@href').text
          id = url.gsub('https://connpass.com/user/', '').gsub('/open/', '');
          social_ids = {}
          name = user_info.css('.display_name > a').text
          image_url = user_info.css('.image_link > img/@src').text
          user.css('.social > a/@href').each do |social_url|
            get_social_id(social_url.text, social_ids)
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
      social_ids[:facebook_id] = url.gsub('https://www.facebook.com/app_scoped_user_id/', '')&.gsub('/', '')
    elsif url.include?('https://github.com/')
      social_ids[:github_id] = url.gsub('https://github.com/', '')
    else
      puts "x connpass : #{url}"
    end
  end

  def participation_url
    domain = group_url ? "https://#{URI.parse(group_url).host}/" : 'https://connpass.com/'
    "#{domain}event/#{event_id}/participation/#participants"
  end

  def participation_doc
    @participation_doc ||= Shule::Http.get_document(participation_url)
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
