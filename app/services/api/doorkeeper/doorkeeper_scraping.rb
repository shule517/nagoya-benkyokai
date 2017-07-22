module Api
  module Doorkeeper
    module DoorkeeperScraping
      def group_url
        event_doc.css('//meta[property="og:url"]/@content').text.gsub(/events.*/, '')
      end

      def group_title
        event_doc.css('//meta[property="og:site_name"]/@content').text
      end

      def logo_url
        event_doc.css('//meta[property="og:image"]/@content').text
      end

      def group_logo_url
        event_doc.css('div.community-profile-picture > a > img/@src').first.text
      end

      def users
        participation_doc.css('.user-profile-details').map { |user|
          social_ids = {}
          user.css('div.user-social > a.external-profile-link/@href').each do |social_url|
            get_social_id(social_url.text, social_ids)
          end

          name = user.css('div.user-name').children.text
          image_url = user.css('img/@src').text
          DoorkeeperUser.new(social_ids.merge(name: name, image_url: image_url))
        }.sort_by { |user| user.twitter_id }.reverse
      rescue
        puts "no users event:#{title} / #{group_url} / #{event_id}"
        []
      end

      def owners
        group_doc.css('.with-gutter > .row > div > .user-profile > .user-profile-details').map { |owner|
          social_ids = {}
          owner.css('.user-social > .external-profile-link/@href').each do |social_url|
            get_social_id(social_url.text, social_ids)
          end

          name = owner.css('.user-name').text
          image_url = owner.css('img/@src').text
          DoorkeeperUser.new(social_ids.merge(name: name, image_url: image_url))
        }.sort_by { |user| user.twitter_id }.reverse
      end

      private

      def get_social_id(url, social_ids)
        if url.include?('http://twitter.com/')
          social_ids[:twitter_id] = url.gsub('http://twitter.com/', '')
        elsif url.include?('https://www.facebook.com/app_scoped_user_id/')
          social_ids[:facebook_id] = url.gsub('https://www.facebook.com/app_scoped_user_id/', '').gsub('/', '')
        elsif url.include?('http://www.facebook.com/profile.php?id=')
          social_ids[:facebook_id] = url.gsub('http://www.facebook.com/profile.php?id=', '').gsub('/', '')
        elsif url.include?('https://www.facebook.com/')
          social_ids[:facebook_id] = url.gsub('https://www.facebook.com/', '').gsub('/', '')
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
        @group_doc ||= Api::Http.get_document("#{group_url}members")
      end

      def participation_doc
        @participation_doc ||= Api::Http.get_document("#{group_url}events/#{event_id}/participants")
      end

      def event_doc
        @event_doc ||= Api::Http.get_document(event_url)
      end
    end
  end
end
