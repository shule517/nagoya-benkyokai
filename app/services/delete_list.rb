require_relative './twitter_client'

twitter = TwitterClient.new

twitter.lists.each do |list|
  if list.created_at.to_s < '2017-01-20'
    puts list.name
    twitter.destroy_list(list.id)
  end
end
