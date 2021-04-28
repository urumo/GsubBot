# frozen_string_literal: true

class ModifyMessageJob < ApplicationJob
  queue_as :default

  def fail_replies = [
    'ты че ебанутый?',
    'сам сказал что понял?',
    'тупа не осилил регулярки',
    'тебе с такими регулярками не стыдно людям в глаза смотреть?'
  ]

  def perform(initial_message_id, send_to, initial_text, exp, reply_id, caller)
    flag, to_find, replace = exp.split('/')

    to_find_reg = Regexp.new(to_find, Regexp::IGNORECASE | Regexp::MULTILINE)

    final_text = initial_text.gsub(to_find_reg, replace)
    regex_groups = initial_text.match(to_find_reg)
    final_text = "#{final_text[0..197]}..." if final_text.length > 200
    return SendMessageJob.perform_later(send_to, fail_replies.sample, caller) if final_text == initial_text

    final_text.gsub!(Regexp.new('(?:\$*)[0-9999]')) do |match|
      regex_groups[match[1..].to_i] || ''
    end
    DeleteMessageJob.perform_later(send_to, initial_message_id) if flag[0] == ('-') && (final_text != initial_text)
    SendMessageJob.perform_later(send_to, final_text, reply_id)
  end
end
