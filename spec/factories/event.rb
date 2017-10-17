FactoryGirl.define do
  factory :event do

    source 'connpass'
    event_id 30152
    event_url 'https://jxug.connpass.com/event/30152/'
    url nil # ATNDのみ参考URLが設定される
    title 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
    catch "にゃごやでも話題の Xamarin を触ってみよう！<br>こんにちは。エクセルソフトの田淵です。\n今話題の Xamarin を名古屋でも触ってみましょう！"
    description "<p>こんにちは。エクセルソフトの田淵です。</p>\n<p>今話題の Xamarin を名古屋でも触ってみましょう！"
    logo_url 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
    started_at Time.parse('2016-05-15T13:00:00+09:00')
    ended_at Time.parse('2016-05-15T16:00:00+09:00')
    place '熱田生涯学習センター'
    address '熱田区熱田西町2-13'
    lat '35.126704400000'
    lon '136.899578500000'
    limit 38
    accepted 38
    waiting 0
    updated_at Time.parse('2016-05-12 15:27:59 +0900')
    update_time Time.parse('2016-05-12 15:27:59 +0900')
    hash_tag 'JXUG'
    group_id 1134
    group_title 'JXUG'
    group_url 'https://jxug.connpass.com/'
    group_logo_url 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'
  end
end
