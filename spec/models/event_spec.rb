require 'rails_helper'

describe Event do
  describe '開催日が取得できること' do
    event = Event.new(started_at: '2016-05-15T13:00:00+09:00')
    it { expect(event.year).to eq 2016 }
    it { expect(event.month).to eq 5 }
    it { expect(event.day).to eq 15 }
    it { expect(event.wday).to eq '日' }
  end
end
