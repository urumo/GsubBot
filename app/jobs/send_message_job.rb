# frozen_string_literal: true

class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id, text, reply_to_message_id, bot_token)
    token = "bot#{bot_token}"
    base_url = "https://api.telegram.org/bot#{token}"
    connection = Faraday.new(base_url)
    url = "/bot#{bot_token}/sendMessage"
    body = { chat_id: chat_id, text: text, parse_mode: 'MarkdownV2' }
    body[:reply_to_message_id] = reply_to_message_id unless reply_to_message_id.nil?
    req = connection.post do |m|
      m.url(url)
      m.headers['Content-Type'] = 'application/json'
      m.body = body.to_json
    end
    pp req.body
  end
end
