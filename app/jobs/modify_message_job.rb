# frozen_string_literal: true

class ModifyMessageJob < ApplicationJob
  queue_as :default

  def fail_replies = [
    'ты че ебанутый?',
    'сам сказал что понял?',
    'тупа не осилил регулярки',
    'тебе с такими регулярками не стыдно людям в глаза смотреть?'
  ]

  def perform(initial_message_id, send_to, initial_text, exp, reply_id, caller, params, bot_id)
    bot = Bot.find(bot_id)
    message = Tg::Message.new(JSON.parse(params, { symbolize_names: true }))

    flag, to_find, replace = exp.split('/')

    to_find_reg = Regexp.new(to_find, Regexp::IGNORECASE | Regexp::MULTILINE)

    text = initial_text.gsub(to_find_reg, replace)
    regex_groups = initial_text.match(to_find_reg) || []
    text = "#{text[0..197]}..." if text.length > 200

    if regex_groups.length.positive?
      text = text.gsub(Regexp.new('(?:\$+)[0-9]')) do |match|
        regex_groups[match[1..].to_i] || ''
      end
    end

    final_text = parse_macros(text, message)
    return bot.send_message(send_to, fail_replies.sample, caller) if final_text == initial_text

    bot.delete_message(send_to, initial_message_id) if flag[0] == ('-') && (final_text != initial_text)
    bot.send_message(send_to, final_text, reply_id)
  rescue StandardError => e
    bot.send_message(send_to, e.message, caller) unless Rails.env == 'production'
  end

  private

  def parse_macros(text, message)
    text.gsub(Regexp.new('%([a-z]{3})%')) do |match|
      match = begin
        match.downcase
      rescue StandardError
        next
      end
      case match
      when '%unm%'
        "@#{message.reply_to_message.from.username || ''}"
      when '%mun%'
        "@#{message.from.username || ''}"
      when '%dym%'
        'ты хотел сказать: '
      when '%fnm%'
        (message.reply_to_message.from.first_name || '').to_s
      when '%mfn%'
        (message.from.first_name || '').to_s
      when '%mfc%'
        GosuModel.all.sample.reply
      else
        ''
      end
    end
  end
end
