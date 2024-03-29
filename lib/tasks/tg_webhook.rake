# frozen_string_literal: true

namespace :tg do
  desc 'set webhook'
  task set: :environment do
    base_self_url = ENV['TG_WEBHOOK_URL']
    raise TelegramWebhookUrlError, 'TG_WEBHOOK_URL unspecified' if base_self_url.nil?

    url = "#{base_self_url}/telegram/get_updates"
    base_url = 'https://api.telegram.org'
    bot = Bot.first
    response = Faraday.get("#{base_url}/bot#{bot.token}/setWebhook?url=#{url}")
    pp response.body
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

  desc 'abuse super black listed users'
  task abuse: :environment do
    should_abuse = (rand * 10).round.even?
    if should_abuse
      User.where(super_black_list: true).each do |user|
        next if user.user_name.nil? || user.user_name.empty?

        text = "@#{user.user_name} #{GosuModel.all.sample.reply}"
        Bot.all.each do |b|
          delay = (rand * 3600).round
          b.send_message(user.chat_id, text, nil, delay)
          puts "bot #{b.alias} is sending message in #{delay} seconds"
        end
      end
    end
  end
end
