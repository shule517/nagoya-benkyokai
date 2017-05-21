module Api
  module Doorkeeper
    module DoorkeeperScraping
      def group_url
        event_doc.css('//meta[property="og:url"]/@content').to_s.gsub(/events.*/, '')
      end

      def group_title
        event_doc.css('//meta[property="og:site_name"]/@content').to_s
      end

      def logo
        event_doc.css('//meta[property="og:image"]/@content').to_s
      end

      def group_logo
        event_doc.css('div.community-profile-picture > a > img').attribute('src').value
      end

      def users
        users = participation_doc.css('.user-profile-details').map do |user|
          DoorkeeperUser.new(user_info(user))
        end
        users.sort_by! { |user| user.twitter_id }.reverse
      rescue
        puts "no users event:#{title} / #{group_url} / #{self.id}"
        []
      end

      def owners
        owners = group_doc.css('.with-gutter > .row > div > .user-profile > .user-profile-details').map do |owner|
          DoorkeeperUser.new(user_info(owner))
        end
        owners.sort_by! { |user| user.twitter_id }.reverse
      end

      private

      def user_info(user)
        name = user.css('.user-name').text
        image_url = user.css('img').attribute('src').value

        social_ids = { twitter_id: nil, facebook_id: nil, github_id: nil, linkedin_id: nil }
        user.css('.user-social > .external-profile-link').each do |social|
          url = social.attribute('href').value
          get_social_id(url, social_ids)
        end

        user_info = { name: name, image_url: image_url }
        user_info.merge!(social_ids)
      end

      def get_social_id(url, social_ids)
        if url.include?('http://twitter.com/')
          social_ids[:twitter_id] = url.gsub('http://twitter.com/', '')
        elsif url.include?('https://www.facebook.com/app_scoped_user_id/')
          social_ids[:facebook_id] = url.gsub('https://www.facebook.com/app_scoped_user_id/', '')&.gsub('/', '')
        elsif url.include?('http://www.facebook.com/profile.php?id=')
          social_ids[:facebook_id] = url.gsub('http://www.facebook.com/profile.php?id=', '')&.gsub('/', '')
        elsif url.include?('https://www.facebook.com/')
          social_ids[:facebook_id] = url.gsub('https://www.facebook.com/', '')&.gsub('/', '')
        elsif url.include?('https://github.com/')
          social_ids[:github_id] = url.gsub('https://github.com/', '')
        elsif url.include?('http://www.linkedin.com/in/')
          social_ids[:linkedin_id] = url.gsub('http://www.linkedin.com/in/', '').gsub(/\/.*/, '')
        elsif url.include?('https://www.linkedin.com/in/')
          social_ids[:linkedin_id] = url.gsub('https://www.linkedin.com/in/', '').gsub(/\/.*/, '')
        elsif url.include?('http://www.linkedin.com/pub/')
          social_ids[:linkedin_id] = url.gsub('http://www.linkedin.com/pub/', '').gsub(/\/.*/, '')
        else
          puts "x doorkeeper : #{url}"
        end
      end

      def group_doc
        @group_doc ||= Shule::Http.get_document("#{group_url}members")
      end

      def participation_doc
        @participation_doc ||= Shule::Http.get_document("#{group_url}events/#{self.id}/participants")
      end

      def event_doc
        @event_doc ||= Shule::Http.get_document(self.public_url)
      end
    end
  end
end
