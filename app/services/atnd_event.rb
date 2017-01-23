# encoding: utf-8
require 'uri'
require_relative "./http"
require_relative './event_base'

class AtndEvent < EventBase
  def source
    'atnd'
  end

  def catch
    if @catch != ''
      @catch + '<br>' + @description.gsub(/<\/?[^>]*>/, "")
    else
      @description.gsub(/<\/?[^>]*>/, "")
    end
  end

  def logo
    @logo ||= get_logo
  end

  def get_logo
    event_doc.css('.events-show-img > img').each do |img|
      logo = 'https://atnd.org' + img.attribute('data-original')
      return logo
    end
    return '/img/atnd.png'
  end

  def users
    []
  end

  def owners
    []
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
  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url, false)
  end
end
