class NotifyService
  def call(e, text)
    trace = e.backtrace.reject { |trace| trace.include?('/app/vendor') || trace.include?('.rbenv') }.join("\n")
    Slack.chat_postMessage text: "#{text}\n#{e.class}\n#{e.message}\n#{trace}", channel: '#test-error', username: 'lambda'
  end
end
