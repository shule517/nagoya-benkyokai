[名古屋勉強会らむだ](https://nagoya-benkyokai.com/)
=======================================================
[![Build Status](https://travis-ci.org/shule517/nagoya-benkyokai.svg?branch=master)](https://travis-ci.org/shule517/nagoya-benkyokai)

## 環境設定
環境変数(export / heroku config)に設定しておくこと
- TwitterAPIキー(参加者ツイッターリストの作成先のアカウント)
  - TWITTER_CONSUMER_KEY
  - TWITTER_CONSUMER_SECRET
  - TWITTER_ACCESS_TOKEN
  - TWITTER_ACCESS_TOKEN_SECRET
  - TWITTER_DEBUG_MODE： true(ツイッターリストを非公開で作成) / false(ツイッターリストを公開で作成)
  ※trueにしないと参加者全員にツイッター通知することになるので注意！！！！

- DoorkeeperAPIキー
  - DOORKEEPER_TOKEN

- エラー通知先のSlackアカウント
  - SLACK_WEBHOOKURL
  - SLACK_TOKEN

## タスク
- `rake event:update`
  - 勉強会情報を更新し、参加者のツイッターリストを作成する
- `rake event:tweet`
  - 明日開かれる勉強会をツイートする
- `rkae event:delete_list`
  - 終わった勉強会のツイッターリストを削除する
