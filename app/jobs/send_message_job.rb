# frozen_string_literal: true

class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id, text, reply_to_message_id)
    bot_token = ENV.fetch('BOT_TOKEN') { Rails.application.credentials.tg[:token] }
    token = "bot#{bot_token}"
    base_url = "https://api.telegram.org/bot#{token}"
    connection = Faraday.new(base_url)
    url = "/bot#{bot_token}/sendMessage"
    body = { chat_id: chat_id, text: text, reply_to_message_id: reply_to_message_id, parse_mode: 'MarkdownV2' }
    req = connection.post do |m|
      m.url(url)
      m.headers['Content-Type'] = 'application/json'
      m.body = body.to_json
    end
  end
end
