# frozen_string_literal: true

class ParseMessageJob < ApplicationJob
  queue_as :default

  def perform(params)
    message = Tg::Message.new(JSON.parse(params, { symbolize_names: true }))
    return if message.text.nil? || message.text.empty?

    message_starts_with = message.text.split(' ').first
    case message_starts_with
    when '/make_admin'
      return start_command_execution(message, :make_admin)
    when '/remove_admin'
      return start_command_execution(message, :remove_admin)
    when '/bl'
      return start_command_execution(message, :bl)
    when '/sbl'
      return start_command_execution(message, :sbl)
    when '/unbl'
      return start_command_execution(message, :unbl)
    end

    send_to = message.chat.id
    reply_id = begin
      message.reply_to_message.message_id
    rescue StandardError
      message.message_id - 1
    end
    bot = Bot.all.find do |b|
      ["#{b.alias}/", "-#{b.alias}/"].include?(message_starts_with)
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
