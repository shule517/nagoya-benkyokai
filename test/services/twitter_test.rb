require 'test/unit'
require './app/services/twitter_client'

class TwitterTest < Test::Unit::TestCase
  def setup
    @twitter = TwitterClient.new
    @list_name = create_twitter_list
  end

  def shutdown
    destroy_twitter_list
  end

  def create_twitter_list
    now = Time.now.strftime('%Y%m%d-%H%M%S')
    list_name = "test-#{now}"
    description = "今日は#{now}。 テストだよ。"
    list = @twitter.create_list(list_name, description)
    assert(@twitter.list_exists?(list.name))
    assert_equal(list_name, list.name)
    assert_equal(description, list.description)
    list_name
  end

  def destroy_twitter_list
    @twitter.destroy_list(@list_name)
    assert(!@twitter.list_exists?(@list_name))
  end

  test 'ツイッターリストにメンバーを追加' do
    user_id = 'shule517'
    @twitter.add_list_member(@list_name, user_id)
    members = @twitter.list_members(@list_name)
    assert(@twitter.list_members(@list_name).any? { |v| v.screen_name == user_id})
  end

  test 'ツイッターリストを更新' do
    title = 'ついったーりすと名＠日本語'
    description = 'ついったーしょうさい＠日本語'
    list = @twitter.update_list(@list_name, title, description)
    assert_equal(title, list.name)
    assert_equal(description, list.description)
    @list_name = list.name
  end

  test 'ツイッターリスト名の生成' do
    list_name = @twitter.create_list_name('3月25日のCoderDojo天白ーーーメンターさん対象')
    assert_equal('-3月25日のCoderDojo天白ーーーメンター', list_name)
  end

  test 'ツイッターリスト名にtwitterが含まれる場合' do
    list = @twitter.create_list('豊橋開催／Twitterのビジネス活用セミナー', '詳細：豊橋開催／Twitterのビジネス活用セミナー')
    assert_equal('豊橋開催／', list.name) # TODO もうちょっといい感じにしたい
    @twitter.destroy_list(list.slug)
  end
end
