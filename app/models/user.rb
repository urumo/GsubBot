# frozen_string_literal: true

class User < ApplicationRecord
  def self.make_admin(caller_id, message_id, chat_id, target)
    User.get_user(target, chat_id).update(admin: true) if User.check_caller_status(caller_id, message_id,
                                                                                   chat_id) && !user.admin
    Bot.first.delete_message(chat_id, message_id)
  end

  def self.remove_admin(caller_id, message_id, chat_id, target)
    User.get_user(target, chat_id).update(admin: false) if User.check_caller_status(caller_id, message_id, chat_id)
    Bot.first.delete_message(chat_id, message_id)
  end

  def self.bl(caller_id, message_id, chat_id, target)
    user = User.get_user(target, chat_id)
    user.update(black_listed: true) if User.check_caller_status(caller_id, message_id, chat_id) && !user.admin
    Bot.first.delete_message(chat_id, message_id)
  end

  def self.sbl(caller_id, message_id, chat_id, target)
    user = User.get_user(target, chat_id)
    user.update(super_black_list: true) if User.check_caller_status(caller_id, message_id, chat_id) && !user.admin
    Bot.first.delete_message(chat_id, message_id)
  end

  def self.unbl(caller_id, message_id, chat_id, target)
    user = User.get_user(target, chat_id)
    user.update(black_listed: false) if User.check_caller_status(caller_id, message_id, chat_id)
    Bot.first.delete_message(chat_id, message_id)
  end

  def self.check_caller_status(caller_id, message_id, chat_id)
    caller = User.find_by(tg_id: caller_id)
    if caller.black_listed || !caller.admin
      Bot.all.each do |b|
        b.send_message(chat_id, GosuModel.all.sample.reply, message_id)
      end
    end
    caller.admin
  end

  def self.get_user(target, chat_id)
    User.find_or_create_by(tg_id: target.id, user_name: target.username, chat_id: chat_id)
  end
end
