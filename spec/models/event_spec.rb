# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  title             :string
#  catch             :string
#  description       :string
#  event_url         :string
#  url               :string
#  address           :string
#  place             :string
#  updated_at        :datetime         not null
#  hash_tag          :string
#  place_enc         :string
#  source            :string
#  group_url         :string
#  group_title       :string
#  group_logo_url    :string
#  logo_url          :string
#  created_at        :datetime         not null
#  tweeted_new       :boolean          default(FALSE), not null
#  tweeted_tomorrow  :boolean          default(FALSE), not null
#  twitter_list_name :string
#  twitter_list_url  :string
#  event_id          :integer
#  limit             :integer
#  accepted          :integer
#  waiting           :integer
#  group_id          :integer
#  started_at        :datetime
#  ended_at          :datetime
#  update_time       :datetime
#  lat               :decimal(17, 14)
#  lon               :decimal(17, 14)
#

require 'rails_helper'

describe Event do
  describe '開催日が取得できること' do
    let(:event) { Event.new(started_at: '2016-05-15T13:00:00+09:00') }
    it '開催年を取得' do
      expect(event.year).to eq 2016
    end
    it '開催月を取得' do
      expect(event.month).to eq 5
    end
    it '開催日を取得' do
      expect(event.day).to eq 15
    end
    it '開催曜日を取得' do
      expect(event.wday).to eq '日'
    end
  end

  describe '#delete' do
    it 'Eventが削除できること' do
      event = Event.create
      event.participant_users << User.create
      event.save
      expect { event.destroy }.to change(Event, :count).by(-1)
    end
    it 'Eventを削除したらParticipantも削除されること' do
      event = Event.create
      event.participant_users << User.create
      event.save
      expect { event.destroy }.to change(Participant, :count).by(-1)
    end
  end

  describe '#scheduled' do
    context '今日開催の勉強会の場合' do
      it '取得できること' do
        Event.create(started_at: Time.now)
        expect(Event.scheduled.count).to eq 1
      end
    end

    context '開催週量した勉強会の場合' do
      it '取得されないこと' do
        Event.create(started_at: Time.now.yesterday)
        expect(Event.scheduled.count).to eq 0
      end
    end
  end

  describe '#ended' do
    context '今日開催の勉強会の場合' do
      it '取得されないこと' do
        Event.create(started_at: Time.now)
        expect(Event.ended.count).to eq 0
      end
    end

    context '開催週量した勉強会の場合' do
      it '取得されること' do
        Event.create(started_at: Time.now.yesterday)
        expect(Event.ended.count).to eq 1
      end
    end
  end
end
