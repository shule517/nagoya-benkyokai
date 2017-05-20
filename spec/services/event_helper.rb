module EventHelper
  def set_event(event, param)
    param.each do |k, v|
      eval("event.#{k} = '#{v}'")
    end
    event.save
  end

  def event
    Event.first
  end

  def twitter_url
    event.twitter_list_url
  end

  def list
    twitter.list(twitter_url)
  end
end
