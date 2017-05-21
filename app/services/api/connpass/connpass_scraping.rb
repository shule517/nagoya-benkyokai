module Api
  module Connpass
    module ConnpassScraping
      def logo
        @logo ||= event_doc.css('//meta[property="og:image"]/@content').to_s
      end

      def group_logo
        @group_logo ||= event_doc.css('.event_group_area > div.group_inner > div > a').attribute('style').value.match(%r{url\((.*)\)})[1]
      rescue
        ''
      end

      def users
        puts "get users : #{self.title}"

        users = []
        participation_doc.css('.applicant_area > .participation_table_area > .common_table > tbody > tr').each do |line|
          user = line.css('.user > .user_info > .image_link')
          return [] if user.empty? # 参加者がいない場合

          id = user.attribute('href').value.gsub('https://connpass.com/user/', '').gsub('/', '')
          name = user.css('img').attribute('alt').value
          image_url = user.css('img').attribute('src').value

          social_ids = {}
          line.css('td.social > a').each do |social|
            url = social.attribute('href').value
            get_social_id(url, social_ids)
          end

          user_info = { connpass_id: id, name: name, image_url: image_url }
          user_info.merge!(social_ids)
          users << ConnpassUser.new(user_info)
        end
        users.sort_by! { |user| user.twitter_id }.reverse
      rescue => e
        p e
        raise
      end

      def owners
        puts "get owners : #{self.title}"

        begin
          owners = []
          owner = participation_doc.css('.concerned_area > .common_table > tbody').first
          unless owner.nil? # イベント参加者ページがある場合
            owner.css('tr').each do |user|
              user_info = user.css('.user_info')
              url = user_info.css('.image_link').attribute('href').value

              id = url.gsub('https://connpass.com/user/', '').gsub('/open/', '');
              name = user_info.css('.display_name > a').text
              image_url = user_info.css('.image_link > img').attribute('src').value

              social_ids = {}
              user.css('.social > a').each do |social|
                url = social.attribute('href').value
                get_social_id(url, social_ids)
              end

              user_info = { connpass_id: id, name: name, image_url: image_url }
              user_info.merge!(social_ids)
              owners << ConnpassUser.new(user_info)
            end
          else # イベント参加者ページがない場合
            Slack.chat_postMessage text: "イベント参加者ページがない場合:\nparticipation_url:#{participation_url}\nself.event_url:#{self.event_url}", channel: '#test-error', username: 'lambda'
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
        rescue => e
          p e
          raise
        end
        owners
      end

      private

      def remove_word(url, word)
        url.gsub(word, '') if url.include?(word)
      end

      def get_social_id(url, social_ids)
        social_ids[:twitter_id] ||= remove_word(url, 'https://twitter.com/intent/user?screen_name=')
        social_ids[:facebook_id] ||= remove_word(url, 'https://www.facebook.com/app_scoped_user_id/')&.gsub('/', '')
        social_ids[:github_id] ||= remove_word(url, 'https://github.com/')
      end

      def event_doc
        @event_doc ||= Shule::Http.get_document(self.event_url)
      end

      def participation_url
        if group_url
          url = "https://#{URI.parse(self.group_url).host}/"
        else
          url = 'https://connpass.com/'
        end
        "#{url}event/#{self.event_id}/participation/#participants"
      end

      def participation_doc
        @participation_doc ||= Shule::Http.get_document(participation_url)
      rescue
        Nokogiri::HTML('')
      end

      def user_doc
        @user_doc ||= Shule::Http.get_document("http://connpass.com/user/#{owner_nickname}")
      end
    end
  end
end
