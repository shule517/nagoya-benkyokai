module Api
  module Techplay
    class TechplayApi
      def search(keyword = nil)
        doc = Api::Http.get_document(request_url(keyword))
        scraping_tags(doc)
      end

      def search_all_tags
        tags.flat_map do |tag|
          search(tag)
        end
      end

      private
      def scraping_tags(doc)
        doc.css('#main-content .eventlist .eventlist-right .title').map do |event_doc|
          title = event_doc.css('a').first.text
          tags = event_doc.css('.tags > a').map do |a|
            id = a.attribute('href').text.gsub('https://techplay.jp/tag/', '')
            { id: id, name: a.text }
          end
          [title, tags]
        end
      end

      def request_url(keyword)
        keyword = URI.escape(keyword) if keyword.present?
        url = "https://techplay.jp/event/search?keyword=#{keyword}&pref=23&tag=&from=&to=&sort=started_asc"
      end

      def tags
        %w(.NET 3D a-blog\ cms A/Bテスト ActionScript Adobe\ Analytics Aerospike Agda AgriTech Akka AMP Android\ Studio Android AngularJS Ansible Apache\ Cordova Apache\ Drill Apache\ Mesos Apache\ Spark Apache API AppGoat Appium AR Arduino asm.js Atom Avro AWS\ Lambda AWS Azure\ Functions Azure BaaS Babel Backbone.js bash BASIC batman.js BI BigData BigQurey BigTable Blender Block\ chain Bluemix Bot Boundary Broke.js Bullet C# C++ Cacti CAD CAE CakePHP Camping Capistrano Cardboard Cassandra Catalyst CDN CentOS Chainer ChatOps Chef CherryPy Choregraphe Chrome CircleCI Cisco CivicTech CleanTech Click Clojure Cloud\ Foundry CloudStack CMS COBOL Cocoa Cocos2d-js Cocos2d-x CodeIgniter CoffeeScript Compass concrete5 Coq Corona\ SDK Couchbase CouchDB Crate.IO CreateJS CSS CSS3 CUDA Cylon.js C言語 D3.js Dart Datadog DB2 Debian Deep\ Learning Deis Delphi DeployGate Derby DevOps DevRel Django DNS Docker Domo Drone Dropwizard Drupal D言語 E2D3 Eclipse EdTech EFO ElasticSearch Electron Elixir Emacs Ember.js Embulk Emmet Emscripten enchant.js Erlang ERP Ethna ExtJS eyeballs.js F# FaaS Fabric FashionTech fastlane Fedora FIDO FileMaker Fintech Firebase Firefox\ OS Flask Flatiron Flex Fluentd flynn FoodTech FPGA FreeBSD FuelPHP Geb Geeklog GIS Git GitHub GlusterFS Go Google\ Analytics Google\ App\ Engine Google\ BigQuery Google\ Cloud\ Functions Google\ Cloud\ Platform GPU Gradle GraphQL Groonga Groovy GrowthForecast Gulp Hack Hadoop Haml Haskell HBase HealthTech Heroku HHVM Hive HoloLens Homekit HRTech HTML HTML5 Hyper-V Hypertable IaaS iBeacon IIS Impala Infrastructure\ as\ Code Intel\ Edison Intel\ Joule IntelliJ\ IDEA iOS IoT IPython Java JavaScript Jenkins Jimdo JMeter jQuery JSF Jubatus Julia JUnit Jupyter Kali\ Linux Kibana Kinect kintone Knockout.JS Koa Kohana Kotlin Kubernetes Kumofs KVM Lapis Laravel LeanAnalytics LeanUX Less Lift Limonade Linux Lisp Lithium Live2D LogStash LPO Lua Mackerel Mahout MapR MariaDB Matador MBaaS MeCab Meetup Merb MESH Meteor MHA Milkcocoa Mithril.js Monaca MongoDB MovableType MQTT Mroonga Munin MySQL Nagios Neo4j New\ Relic NFC Nginx NixOS Node-RED Node.js Norikra NoSQL Objective-C OCaml Oculus\ Rift OpenBSD OpenCL OpenCV OpenGL openHAB OpenID OpenNI OpenStack OpenStreetMap OpenWhisk Oracle OrientDB OS OSS OSv OWASP PaaS Pascal Pentaho Pepper Perl Phalcon PhoneGap Photon PHP PhpStorm Pig Pinoco Play\ Framework Plone plotly.js Polymer PostgreSQL PowerShell Presto Processing Prolog Pulse\ CMS Puppet Pyramid Python QML Qt RAD\ Studio Rancher Raspberry\ Pi RDB React\ Native React.js ReactiveX Realm Redis Redmine Redux RESAS RethinkDB Riak Riot.js Ruby\ on\ Rails Ruby RubyMotion Rust R言語 SaaS Salesforce SAS Sass Scala Scratch SDN SDSoC Seasar Selenium Sencha\ Touch Sensu SEO Serverless Serverspec Shark Shell Sinatra Slim Smalltalk SoftLayer Solaris Solr SORACOM Sota Sphinx SportTech Spring SQL SQLite SQLServer Sqoop SRE Stan Struts Sublime\ Text SuperCollider Swift Symfony Tableau TDD TensorFlow ThingSpeak three.js TiDD Titanium tmux Tomcat TouchDesigner Travis\ CI Treasure\ Data Twilio TypeScript Ubuntu UIUX Unity Unreal\ Engine Vagrant Vim VirtualBox Viscuit Visual\ Basic Visual\ Studio Vitess VMware VR VstoneMagic Vue.js Vyatta Watson Waves Web\ Components WebAssembly WebGL webpack WebRTC WebStorm Webサーバ Webデザイン Webマーケティング Web制作 Wicket Windows Wireshark WordPress Xamarin Xcode Xen Xojo Yeoman Yesod Yii Zabbix Zend\ Framework Zope Zsh もくもく会 アイデアソン アクセシビリティ アクセス解析 アジャイル アセンブラ アドテク アルゴリズム アーキテクチャ インフラ オムニチャネル オープンイノベーション オープンデータ ガジェット キッズ キャリア クラウドサービス クラウドソフトウェア グラフィック グラフィックデザイン グロースハック ゲーム コンテスト コードリーディング サーバーサイド サーバ構成管理 サーバ監視 スクラム スタートアップ スマートフォン開発 セキュリティ ソフトウェアテスト チームビルディング テキストエディタ テスト テストツール テストマネジメント テスト設計 デジタルマーケティング データベース データマイニング データ可視化 データ解析 ドメイン駆動 ネットワーク ハッカソン ハッキング ハンズオン パケットキャプチャ ビッグデータ フロントエンド プログラミング プログラム プロトタイピング マネタイズ マーケット マーケティング ユーザビリティ ライトニングトーク ライフスタイル リーンスタートアップ リーン開発 ロボット ワークショップ 交流会 人工知能 仮想化ソフトウェア 全文検索エンジン 分散ファイルシステム 初心者 動画 女子部 形態素解析 探索的テスト 数学 機械学習 機能テスト 自然言語処理 読書会 開発サポート 開発ツール 開発手法 電子工作 非機能テスト)
      end
    end
  end
end
