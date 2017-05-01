module Api
  module Atnd
    module AtndScraping
      def logo
        event_doc.css('.events-show-img > img').each do |img|
          return 'https://atnd.org' + img.attribute('data-original')
        end
        '/img/atnd.png'
      end

      def catch
        desc = self.description.gsub(/<\/?[^>]*>/, '')
        if self.catch?
          "#{self.catch}<br>#{desc}"
        else
          desc
        end
      end

      def users
        event_doc.css('#members-join ol li span').map do |user|
          a = user.css('a')
          id = a.attribute('href').value.gsub('/users/', '')
          name = a.text

          img = user.css('img').attribute('data-original')
          image_url = ''
          if img.nil?
            image_url = 'https://atnd.org/images/icon/default_latent.png'
          else
            image_url = "https:#{img.value}" if img.value !~ /https/
          end

          user_info = { atnd_id: id, name: name, image_url: image_url }
          user_info.merge!(get_social_id(id))
          AtndUser.new(user_info)
        end.sort_by { |user| user.twitter_id }.reverse
      end

      def owners
        event_doc.css('#user-id').map do |owner_info|
          id = owner_info.attribute('href').value.gsub('/users/', '')

          image = event_doc.css('.events-show-info img')
          src = image.attribute('src').value

          image_url = ''
          if src == '/images/icon/default_latent.png'
            image_url = "https://atnd.org#{src}"
          else
            image_url = "https:#{src}"
          end

          user_info = { atnd_id: id, name: self.owner_nickname, image_url: image_url }
          user_info.merge!(get_social_id(id))
          AtndUser.new(user_info)
        end.sort_by { |user| user.twitter_id }.reverse
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
        { twitter_id: twitter_id, facebook_id: facebook_id, github_id: nil, linkedin_id: nil }
      end

      def event_doc
        @event_doc ||= Shule::Http.get_document(self.event_url, false)
      end
    end
  end
end
