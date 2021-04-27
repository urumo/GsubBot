# frozen_string_literal: true

class ModifyMessageJob < ApplicationJob
  queue_as :default

  def fail_replies = ['ты че ебанутый?', 'сам сказал что понял?', 'тупа не осилил регулярки',
                      'тебе с такими регулярками не стыдно людям в глаза смотреть?']

  def perform(_initial_message_id, send_to, initial_text, exp, reply_id, caller)
    flag, to_find, replace = exp.split('/')

    to_find_reg = Regexp.new(to_find)

    final_text = initial_text.gsub(to_find_reg, replace)
    final_text = "#{final_text[0..197]}..." if final_text.length > 200
    SendMessageJob.perform_later(send_to, fail_replies.sample, caller) if final_text == initial_text
    SendMessageJob.perform_later(send_to, final_text, reply_id)
  end
end
