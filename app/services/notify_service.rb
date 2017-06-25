class NotifyService
  def call(e, text)
    trace = e.backtrace.reject { |trace| trace.include?('/app/vendor') || trace.include?('.rbenv') }.join("\n")
    Slack.chat_postMessage text: "#{text}\n#{e.class}\n#{e.message}\n#{trace}", channel: ENV['SLACK_ERROR_CHANNEL'], username: 'lambda'
  end

  def send_message(text)
    Slack.chat_postMessage text: text, channel: ENV['SLACK_ERROR_CHANNEL'], username: 'lambda'
  end
end
