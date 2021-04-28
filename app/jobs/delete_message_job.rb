# frozen_string_literal: true

class DeleteMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id, message_id)
    bot_token = ENV.fetch('BOT_TOKEN') { Rails.application.credentials.tg[:token] }
    token = "bot#{bot_token}"
    base_url = "https://api.telegram.org/bot#{token}"
    connection = Faraday.new(base_url)
    url = "/bot#{bot_token}/deleteMessage"
    body = { chat_id: chat_id, message_id: message_id }
    req = connection.post do |m|
      m.url(url)
      m.headers['Content-Type'] = 'application/json'
      m.body = body.to_json
    end
    pp req.body
  end
end
