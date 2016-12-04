#coding: utf-8
require 'uri'
require_relative "./http"
require_relative './event'

class AtndEvent < Event
  def source
    'ATND'
  end

  def catch
    if @catch != ''
      @catch + '<br>' + @description.gsub(/<\/?[^>]*>/, "")
    else
      @description.gsub(/<\/?[^>]*>/, "")
    end
  end

  def group_url
  end

  def group_id
  end

  def group_title
  end

  def group_logo
  end

  def logo
  end

  def users
    []
  end

  def owners
    []
  end

  private
  def event_doc
    @event_doc ||= Shule::Http.get_document(event_url)
  end

  def user_doc
    @user_doc ||= Shule::Http.get_document("http://connpass.com/user/#{owner_nickname}")
  end
end
