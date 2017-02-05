require 'test/unit'
require './app/services/atnd'
require_relative './event_interface'

class AtndTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Atnd.new
    events = api.search(['エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！'])
    assert(events.count > 0)
    @event = events.first
  end

  def test_atnd
    api = Atnd.new
    events = api.search(['エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！'])
    event = events.first
    assert_equal('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！', event.title)
    assert(event.catch.start_with?('【ATEAM TECHとは】'))
    assert_equal('2016-10-11T20:00:00.000+09:00', event.started_at)
    assert_equal('エイチーム　本社', event.place)
    assert_equal('〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F', event.address)
    assert_equal(false, event.limit_over?)
    assert_equal('https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731', event.logo)

    assert_equal(event.accepted, event.users.count)
    atnd_user = event.users.select { |user| user.atnd_id == '259586' }.first
    assert_equal('259586', atnd_user.atnd_id)
    assert_equal('suzukiterminal', atnd_user.twitter_id)
    assert_equal('1800036413585884', atnd_user.facebook_id)
    assert_equal('s2terminal', atnd_user.name)
    assert_equal('https://pbs.twimg.com/profile_images/682491356460101632/4l54CzhH_normal.jpg', atnd_user.image_url)

    no_social_user = event.users.select { |user| user.atnd_id == '260559' }.first
    assert_equal('260559', no_social_user.atnd_id)
    assert_equal('', no_social_user.twitter_id)
    assert_equal('', no_social_user.facebook_id)
    assert_equal('otama567', no_social_user.name)
    assert_equal('https://atnd.org/images/icon/default_latent.png', no_social_user.image_url)

    owners = event.owners
    assert_equal(1, owners.count)
    ateam = owners.select { |user| user.atnd_id == '224579' }.first
    assert_equal('224579', ateam.atnd_id)
    assert_equal('Ateam Inc.', ateam.name)
    assert_equal('', ateam.twitter_id)
    assert_equal('935173646549635', ateam.facebook_id)
    assert_equal('https://graph.facebook.com/935173646549635/picture?type=square', ateam.image_url)
  end

  def test_owner_no_image
    api = Atnd.new
    events = api.search(['RFC 読書会 - RFC 1034 第1回'])
    event = events.first
    owners = event.owners
    assert_equal(1, owners.count)
    tss = owners.select { |user| user.atnd_id == '10209' }.first
    assert_equal('10209', tss.atnd_id)
    assert_equal('tss_ontap', tss.name)
    assert_equal('', tss.twitter_id)
    assert_equal('', tss.facebook_id)
    assert_equal('https://atnd.org/images/icon/default_latent.png', tss.image_url)
  end

  def test_no_owner
    api = Atnd.new
    events = api.search(['HULFT勉強会 in 名古屋'])
    event = events.first
    owners = event.owners
    assert_equal(0, owners.count)
  end
end
