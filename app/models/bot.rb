# frozen_string_literal: true

class Bot < ApplicationRecord
  def send_message(chat_id, message, reply_id) = SendMessageJob.perform_later(chat_id, Regexp.escape(message),
                                                                              reply_id, token)

  def delete_message(chat_id, message_id) = DeleteMessageJob.perform_later(chat_id, message_id, token)
end
