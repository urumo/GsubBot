# frozen_string_literal: true

class ModifyMessageJob < ApplicationJob
  queue_as :default

  def perform(_initial_message_id, send_to, initial_text, exp, reply_id)
    caller, to_find, replace = exp.split('/')

    to_find_reg = Regexp.new(to_find)

    final_text = initial_text.gsub(to_find_reg, replace)
    final_text = "#{final_text[0..247]}..." if final_text.length > 250

    SendMessageJob.perform_later(send_to, final_text, reply_id)
  end
end
