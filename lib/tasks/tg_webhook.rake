# frozen_string_literal: true

namespace :tg do
  desc 'set webhook'
  task set: :environment do
    base_self_url = ENV['TG_WEBHOOK_URL']
    raise TelegramWebhookUrlError, 'TG_WEBHOOK_URL unspecified' if base_self_url.nil?

    url = "#{base_self_url}/telegram/get_updates"
    base_url = 'https://api.telegram.org'
    Bot.all.each do |bot|
      response = Faraday.get("#{base_url}/bot#{bot.token}/setWebhook?url=#{url}")
      pp response.body
    end
  end

  desc 'delete webhook'
  task unset: :environment do
    base_self_url = ENV['TG_WEBHOOK_URL']
    raise TelegramWebhookUrlError, 'TG_WEBHOOK_URL unspecified' if base_self_url.nil?

    url = "#{base_self_url}/telegram/get_updates"
    base_url = 'https://api.telegram.org'
    Bot.all.each do |bot|
      response = Faraday.get("#{base_url}/bot#{bot.token}/deleteWebhook?url=#{url}")
      pp response.body
    end
  end

  desc 'webhook status'
  task status: :environment do
    base_url = 'https://api.telegram.org'
    Bot.all.each do |bot|
      response = Faraday.get("#{base_url}/bot#{bot.token}/getWebhookInfo")
      pp response.body
    end
  end
end
