# frozen_string_literal: true

class ParseMessageJob < ApplicationJob
  queue_as :default

  def perform(params)
    message = Tg::Message.new(JSON.parse(params, { symbolize_names: true }))
    return if message.text.nil? || message.text.empty?

    return start_command_execution(message, :make_admin) if message.text.start_with?('/make_admin')
    return start_command_execution(message, :remove_admin) if message.text.start_with?('/remove_admin')
    return start_command_execution(message, :bl) if message.text.start_with?('/bl')
    return start_command_execution(message, :sbl) if message.text.start_with?('/sbl')
    return start_command_execution(message, :unbl) if message.text.start_with?('/unbl')

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

    unless black_listed.nil?
      return Bot.all.each do |b|
        b.send_message(message.chat.id, GosuModel.all.sample.reply,
                       message.message_id, (rand * 10).round * 6)
      end
    end

    return if bot.nil?

    ModifyMessageJob.perform_later(message.message_id, send_to, message.reply_to_message.text, message.text,
                                   reply_id, message.message_id, params, bot.id)
  end

  private

  def execute(caller_id, message_id, chat_id, target, operation) = User.send(operation, caller_id, message_id, chat_id,
                                                                             target)

  def start_command_execution(message, command)
    if message.reply_to_message.nil?
      execute(message.from.id, message.message_id, message.chat.id, message.from, command)
    else
      execute(message.from.id, message.message_id, message.chat.id, message.reply_to_message.from, command)
    end
  end
end
