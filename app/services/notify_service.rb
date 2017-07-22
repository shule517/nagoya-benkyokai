class NotifyService
  def call(e, text)
    trace = e.backtrace.reject { |trace| trace.include?('/app/vendor') || trace.include?('.rbenv') }.join("\n")
    Slack.chat_postMessage text: "#{text}\n#{e.class}\n#{e.message}\n#{trace}", channel: error_channel, username: 'lambda' if error_channel
  end

  def send_message(text)
    Slack.chat_postMessage text: text, channel: error_channel, username: 'lambda' if error_channel
  end

  def error_channel
    ENV['SLACK_ERROR_CHANNEL']
  end
end
