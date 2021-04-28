# frozen_string_literal: true

class ParseMessageJob < ApplicationJob
  queue_as :default

  def perform(params)
    identifier = ENV.fetch('IDENTIFIER', 'd')
    message = Tg::Message.new(JSON.parse(params, { symbolize_names: true }))
    send_to = message.chat.id
    reply_id = begin
      message.reply_to_message.message_id
    rescue StandardError
      nil
    end

    case_1 = begin
      message.text.start_with?("#{identifier}/")
    rescue StandardError
      false
    end
    case_2 = begin
      message.text.start_with?("-#{identifier}/")
    rescue StandardError
      false
    end
    return unless case_1 || case_2

    return if reply_id.nil?

    ModifyMessageJob.perform_later(message.message_id, send_to, message.reply_to_message.text, message.text,
                                   reply_id, message.message_id, params)
  end
end
