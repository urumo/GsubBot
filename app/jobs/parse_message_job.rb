# frozen_string_literal: true

class ParseMessageJob < ApplicationJob
  queue_as :default

  def perform(params)
    message = Tg::Message.new(JSON.parse(params, { symbolize_names: true }))
    return if message.text.nil? || message.text.empty?

    if message.text.start_with?('/make_admin')
      return execute(message.from.id, message.message_id, message.chat.id, message.reply_to_message.from,
                     :make_admin)
    end
    if message.text.start_with?('/remove_admin')
      return execute(message.from.id, message.message_id, message.chat.id, message.reply_to_message.from,
                     :remove_admin)
    end
    if message.text.start_with?('/bl')
      return execute(message.from.id, message.message_id, message.chat.id, message.reply_to_message.from,
                     :bl)
    end
    if message.text.start_with?('/unbl')
      return execute(message.from.id, message.message_id, message.chat.id, message.reply_to_message.from,
                     :unbl)
    end

    send_to = message.chat.id
    reply_id = begin
      message.reply_to_message.message_id
    rescue StandardError
      message.message_id - 1
    end
    bot = Bot.all.find do |b|
      message.text.start_with?("#{b.alias}/") || message.text.start_with?("-#{b.alias}/")
    end

    black_listed = User.find_by(tg_id: message.from.id, black_listed: true)

    unless black_listed.nil? # message.from.id == 586_461_758 # || message.from.id == 964_992_787
      return Bot.all.each do |b|
        sleep((rand * 10).round) && b.send_message(message.chat.id, GosuModel.all.sample.reply,
                                                    message.message_id)
      end
    end

    return if bot.nil?

    ModifyMessageJob.perform_later(message.message_id, send_to, message.reply_to_message.text, message.text,
                                   reply_id, message.message_id, params, bot.id)
  end

  private

  def execute(caller_id, message_id, chat_id, target, operation) = User.send(operation, caller_id, message_id, chat_id,
                                                                             target)
end
