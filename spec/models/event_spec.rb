require 'rails_helper'

describe Event do
  describe '開催日が取得できること' do
    event = Event.new(started_at: '2016-05-15T13:00:00+09:00')
    it('開催年を取得')   { expect(event.year).to eq 2016 }
    it('開催月を取得')   { expect(event.month).to eq 5   }
    it('開催日を取得')   { expect(event.day).to eq 15    }
    it('開催曜日を取得') { expect(event.wday).to eq '日' }
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
end
