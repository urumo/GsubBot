# frozen_string_literal: true

namespace :tg do
  base_url = 'https://api.telegram.org'
  bot_token = ENV.fetch('BOT_TOKEN') { Rails.application.credentials.tg[:token] }
  token = "bot#{bot_token}"
  base_self_url = ENV.fetch('TG_WEBHOOK_URL') { Rails.application.credentials.tg[:webhook_url] }
  url = "#{base_self_url}/telegram/get_updates"

  desc 'set webhook'
  task set: :environment do
    response = Faraday.get("#{base_url}/#{token}/setWebhook?url=#{url}")
    pp response.body
  end

  desc 'delete webhook'
  task unset: :environment do
    response = Faraday.get("#{base_url}/#{token}/deleteWebhook?url=#{url}")
    pp response.body
  end

  desc 'webhook status'
  task status: :environment do
    response = Faraday.get("#{base_url}/#{token}/getWebhookInfo")
    pp response.body
  end
end
