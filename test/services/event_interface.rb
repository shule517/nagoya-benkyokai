# encoding: utf-8
require 'test/unit'

module EventInterfaceTest
  def test_implements_interface
    assert_respond_to(@event, :event_id)
    assert_respond_to(@event, :title)
    assert_respond_to(@event, :catch)
    assert_respond_to(@event, :description)
    assert_respond_to(@event, :event_url)
    assert_respond_to(@event, :started_at)
    assert_respond_to(@event, :ended_at)
    assert_respond_to(@event, :url)
    assert_respond_to(@event, :address)
    assert_respond_to(@event, :place)
    assert_respond_to(@event, :lat)
    assert_respond_to(@event, :lon)
    assert_respond_to(@event, :limit)
    assert_respond_to(@event, :accepted)
    assert_respond_to(@event, :waiting)
    assert_respond_to(@event, :updated_at)
    assert_respond_to(@event, :hash_tag)
    assert_respond_to(@event, :place_enc)
    assert_respond_to(@event, :limit_over?)
    assert_respond_to(@event, :source)
    assert_respond_to(@event, :catch)
    assert_respond_to(@event, :group_url)
    assert_respond_to(@event, :group_id)
    assert_respond_to(@event, :group_title)
    assert_respond_to(@event, :group_logo)
    assert_respond_to(@event, :logo)
    assert_respond_to(@event, :users)
  end
end
