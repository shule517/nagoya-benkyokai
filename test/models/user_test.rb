require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    #connpass
    User.create(name: 'user1', connpass_id: '1', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: '')
    User.create(name: 'user2', connpass_id: '2', twitter_id: 'twitter1', facebook_id: '', github_id: '', linkedin_id: '')
    User.create(name: 'user3', connpass_id: '3', twitter_id: '', facebook_id: 'facebook1', github_id: '', linkedin_id: '')
    User.create(name: 'user4', connpass_id: '4', twitter_id: '', facebook_id: '', github_id: 'github1', linkedin_id: '')

    #atnd
    User.create(name: 'user5', atnd_id: '1', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: '')
    User.create(name: 'user6', atnd_id: '2', twitter_id: 'twitter2', facebook_id: '', github_id: '', linkedin_id: '')
    User.create(name: 'user7', atnd_id: '3', twitter_id: '', facebook_id: 'facebook2', github_id: '', linkedin_id: '')
    User.create(name: 'user8', atnd_id: '4', twitter_id: '', facebook_id: '', github_id: 'github2', linkedin_id: '')

    #Doorkeeper
    User.create(name: 'user9', twitter_id: 'twitter3', facebook_id: '', github_id: '', linkedin_id: '')
    User.create(name: 'user10', twitter_id: '', facebook_id: 'facebook3', github_id: '', linkedin_id: '')
    User.create(name: 'user11', twitter_id: '', facebook_id: '', github_id: 'github3', linkedin_id: '')
    User.create(name: 'user12', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: 'linkedin3')
  end

  test "find_connpass" do
    assert_equal 'user1', User.find_connpass('1', '', '', '').name
    assert_equal 'user2', User.find_connpass('', 'twitter1', '', '').name
    assert_equal 'user3', User.find_connpass('', '', 'facebook1', '').name
    assert_equal 'user4', User.find_connpass('', '', '', 'github1').name
  end

  test "find_atnd" do
    assert_equal 'user5', User.find_atnd('1', '', '').name
    assert_equal 'user6', User.find_atnd('', 'twitter2', '').name
    assert_equal 'user7', User.find_atnd('', '', 'facebook2').name
  end

  test "find_doorkeeper" do
    assert_equal 'user9', User.find_doorkeeper('twitter3', '', '').name
    assert_equal 'user10', User.find_doorkeeper('', 'facebook3', '').name
    assert_equal 'user11', User.find_doorkeeper('', '', 'github3').name
    assert_equal 'user12', User.find_doorkeeper('', '', '', 'linkedin3').name
  end

  test "find_social" do
    assert_equal 'user9', User.find_social('twitter3', '', '').name
    assert_equal 'user10', User.find_social('', 'facebook3', '').name
    assert_equal 'user11', User.find_social('', '', 'github3').name
    assert_equal 'user12', User.find_social('', '', '', 'linkedin3').name
  end
end
