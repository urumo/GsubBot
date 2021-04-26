# frozen_string_literal: true

class ModifyMessageJob < ApplicationJob
  queue_as :default

  def perform(_initial_message_id, send_to, initial_text, exp, reply_id)
    caller, to_find, replace = exp.split('/')

    to_find_reg = Regexp.new(to_find)
    m = initial_text.scan(to_find_reg)
    return if m.nil?

    final_text = m.map { replace }.join
    SendMessageJob.perform_later(send_to, final_text, reply_id)
  end
end
