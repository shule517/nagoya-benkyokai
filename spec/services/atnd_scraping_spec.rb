require 'rails_helper'
# include Api::Atnd

# describe AtndScraping, type: :request do
describe AtndEvent, type: :request do
  # let(:api) { AtndApi }
  let(:api) { Atnd.new }
  describe '#find' do
    # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
    let(:event) { api.find(event_id: 81945) }

    example 'イベント情報の取得できること', vcr: '#find' do
      expect(event.source).to eq 'atnd' # TODO ATND
      expect(event.event_id).to eq 81945
      expect(event.event_url).to eq 'http://atnd.org/events/81945' # TODO 'https://atnd.org/events/81945'
      expect(event.url).to eq '' # TODO nil # これ必要？
      expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
      # expect(event.catch).to start_with '【ATEAM TECHとは】 ゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。'
      expect(event.catch).to start_with "【ATEAM TECHとは】\nゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。"
      # expect(event.description).to start_with '【ATEAM TECHとは】 ゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。'
      expect(event.description).to start_with "<h2>【ATEAM TECHとは】</h2>\n<p>ゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。<br />"
      expect(event.logo).to eq 'https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731'
      # expect(event.started_at).to eq Time.parse('2016-10-11T20:00:00.000+09:00')
      expect(event.started_at).to eq '2016-10-11T20:00:00.000+09:00'
      # expect(event.ended_at).to eq Time.parse('2016-10-11T22:30:00.000+09:00')
      expect(event.ended_at).to eq '2016-10-11T22:30:00.000+09:00'
      expect(event.place).to eq 'エイチーム　本社'
      expect(event.address).to eq '〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F'
      expect(event.lat).to eq '35.1720523'
      expect(event.lon).to eq '136.8844986'
      expect(event.limit).to eq 45
      expect(event.accepted).to eq 39
      expect(event.waiting).to eq 0
      # expect(event.update_time).to eq Time.parse('2016-10-08T00:52:33.000+09:00')
      # expect(event.hash_tag).to eq 'ATEAM_TECH' # TODO 取得できていない
      expect(event.limit_over?).to eq false
      expect(event.users.count).to eq event.accepted
      expect(event.owners.count).to eq 1
      expect(event.group_id).to eq nil
      expect(event.group_title).to eq nil
      expect(event.group_url).to eq nil
      expect(event.group_logo).to eq nil
    end
  end

  describe '#users' do
    let(:users) { event.users }
    describe '参加者がいる場合', vcr: '#users-exist' do
      # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
      let(:event) { api.find(event_id: 81945) }

      it '参加者数が取得できること' do
        expect(users.count).to be > 0
        expect(users.count).to eq event.accepted
      end
    end

    context '参加者がいない場合', vcr: '#users-not_exist' do
      # 【5/22豊橋でコミュニティー価値創造セミナー】 https://atnd.org/events/86752
      let(:event) { api.find(event_id: 86752) }

      it '参加者一覧が空であること' do
        expect(users).to be_empty
      end
    end
  end

  describe '#user' do
    let(:users) { event.users }
    describe '#get_social_id' do
      context '全てのSNSが登録されているユーザの場合', vcr: '#user-sns-exist' do
        # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
        let(:event) { api.find(event_id: 81945) }
        let(:atnd_user) { users.select { |user| user.atnd_id == '259586' }.first }

        it 'SNS情報が取得できること' do
          expect(atnd_user.atnd_id).to eq '259586'
          expect(atnd_user.twitter_id).to eq 'suzukiterminal'
          expect(atnd_user.facebook_id).to eq '1800036413585884'
          expect(atnd_user.github_id).to eq '' # TODO nil
          expect(atnd_user.linkedin_id).to eq '' # TODO nil
          expect(atnd_user.name).to eq 's2terminal'
        end
      end

      context 'SNSが未登録なユーザの場合', vcr: '#user-sns-not_exist' do
        # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
        let(:event) { api.find(event_id: 81945) }
        let(:no_social_user) { users.select { |user| user.atnd_id == '260559' }.first }

        it 'SNS情報が取得できること' do
          expect(no_social_user.atnd_id).to eq '260559'
          expect(no_social_user.twitter_id).to eq '' # TODO nil
          expect(no_social_user.facebook_id).to eq '' # TODO nil
          expect(no_social_user.github_id).to eq '' # TODO nil
          expect(no_social_user.linkedin_id).to eq '' # TODO nil
          expect(no_social_user.name).to eq 'otama567'
        end
      end
    end

    describe '#image_url' do
      context '画像が設定されている場合', vcr: '#user-image_url-exist' do
        # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
        let(:event) { api.find(event_id: 81945) }
        let(:atnd_user) { users.select { |user| user.atnd_id == '259586' }.first }

        it 'ユーザロゴが取得できること' do
          expect(atnd_user.image_url).to eq 'https://pbs.twimg.com/profile_images/682491356460101632/4l54CzhH_normal.jpg'
        end
      end

      context '画像が設定されていない場合', vcr: '#user-image_url-not_exist' do
        # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
        let(:event) { api.find(event_id: 81945) }
        let(:no_social_user) { users.select { |user| user.atnd_id == '260559' }.first }

        it 'ATNDロゴが取得できること' do
          expect(no_social_user.image_url).to eq 'https://atnd.org/images/icon/default_latent.png'
        end
      end
      context 'httpsからはじまる場合'
      context 'httpsからはじまらない場合'
    end
  end

  describe '#owners' do
    let(:owners) { event.owners }
    context '主催者がいる場合', vcr: '#owners-exist' do
      # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
      let(:event) { api.find(event_id: 81945) }

      it '主催者が取得できること' do
        expect(owners.size).to eq 1
        expect(owners.first.name).to eq 'Ateam Inc.'
      end
    end

    context '主催者がいない場合', vcr: '#owners-not_exist' do
      # HULFT勉強会 in 名古屋 https://atnd.org/events/84139
      let(:event) { api.find(event_id: 84139) }

      it '主催者一覧が空であること' do
        expect(owners).to be_empty
      end
    end
  end

  describe '#owner' do
    let(:owners) { event.owners }
    describe '#get_social_id' do
      context '全てのSNSが登録されているユーザの場合', vcr: '#owner-sns-exist' do
        # 効果的な運用知識や成功事例で集客・売上増大につなぐ https://atnd.org/events/88230
        let(:event) { api.find(event_id: 88230) }
        let(:owner) { owners.select { |owner| owner.twitter_id == 'infochogenba' }.first }

        it 'SNS情報が取得できること' do
          expect(owner.atnd_id).to eq '258141'
          expect(owner.twitter_id).to eq 'infochogenba'
          expect(owner.facebook_id).to eq '258479937956641'
          expect(owner.github_id).to eq '' # TODO nil
          expect(owner.linkedin_id).to eq '' # TODO nil
          expect(owner.name).to eq 'WEB塾超現場'
        end
      end

      context 'SNSが未登録なユーザの場合', vcr: '#owner-sns-not_exist' do
        # 介護のストレスケア https://atnd.org/events/88105
        let(:event) { api.find(event_id: 88105) }
        let(:owner) { owners.select { |owner| owner.name == 'アイディア東京' }.first }

        it 'SNS情報が取得できること' do
          expect(owner.atnd_id).to eq '278790'
          expect(owner.twitter_id).to eq '' # TODO nil
          expect(owner.facebook_id).to eq '' # TODO nil
          expect(owner.github_id).to eq '' # TODO nil
          expect(owner.linkedin_id).to eq '' # TODO nil
          expect(owner.name).to eq 'アイディア東京'
        end
      end
    end

    describe '#image_url' do
      context '画像が設定されている場合', vcr: '#owner-image_url-exist' do
        # 効果的な運用知識や成功事例で集客・売上増大につなぐ https://atnd.org/events/88230
        let(:event) { api.find(event_id: 88230) }
        let(:owner) { owners.select { |owner| owner.twitter_id == 'infochogenba' }.first }

        it 'ユーザアイコンが取得できること' do
          expect(owner.image_url).to eq 'https://pbs.twimg.com/profile_images/708242876321243137/HoqV1Wf0_normal.jpg'
        end
      end

      context '画像が設定されていない場合', vcr: '#owner-image_url-not_exist' do
        # 介護のストレスケア https://atnd.org/events/88105
        let(:event) { api.find(event_id: 88105) }
        let(:owner) { owners.select { |owner| owner.name == 'アイディア東京' }.first }

        it 'ATNDロゴが取得できること' do
          expect(owner.image_url).to eq 'https://atnd.org/images/icon/default_latent.png'
        end
      end
    end
  end

  describe '#catch' do
    context 'catchが設定されている場合', vcr: '#catch-exist' do
    end

    context 'catchが設定されていない場合', vcr: '#catch-not_exist' do
      # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
      let(:event) { api.find(event_id: 81945) }
      it 'イベント詳細が取得できること' do
        # expect(event.catch).to start_with '【ATEAM TECHとは】 ゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。'
        expect(event.catch).to start_with "【ATEAM TECHとは】\nゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。"
      end
    end
  end

  describe '#logo' do
    context 'logoが設定されている場合', vcr: '#logo-exist' do
      # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
      let(:event) { api.find(event_id: 81945) }

      it 'イベントロゴが取得できること' do
        expect(event.logo).to eq 'https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731'
      end
    end

    context 'logoが設定されていない場合' do
      # NagoyaStat #6 https://atnd.org/events/88235
      let(:event) { api.find(event_id: 88235) }

      it 'ATNDロゴが取得できること', vcr: '#logo-not_exist' do
        expect(event.logo).to eq '/img/atnd.png'
      end
    end
  end

  describe '#group' do
    context '主催グループがある場合', vcr: '#group-not_exist' do
      # NagoyaStat #6 https://atnd.org/events/88235
      let(:event) { api.find(event_id: 88235) }

      xit 'グループ情報が取得できること' do
        expect(event.group_url).to eq 'https://atnd.org/groups/nagoya-stat'
        expect(event.group_id).to eq 'nagoya-stat'
        expect(event.group_title).to eq 'NagoyaStat'
        expect(event.group_logo).to eq 'https://atnd.org/images/icon/atnd_latent.png'
      end
    end

    context '主催グループがない場合', vcr: '#group-not_exist' do
      # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！ https://atnd.org/events/81945
      let(:event) { api.find(event_id: 81945) }

      it 'グループ情報が空であること' do
        expect(event.group_url).to eq nil
        expect(event.group_id).to eq nil
        expect(event.group_title).to eq nil
        expect(event.group_logo).to eq nil
      end
    end
  end
end
