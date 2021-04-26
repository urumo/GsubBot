# frozen_string_literal: true

module Tg
  class Message
    attr_reader :reply_to_message, :chat, :from, :message_id, :date, :text

    def initialize(params)
      @message_id = params[:message_id]
      @from = Tg::User.new(params[:from])
      @chat = Tg::Chat.new(params[:chat])
      @reply_to_message = if params[:reply_to_message].nil?
                            nil
                          else
                            Tg::Message.new(params[:reply_to_message])
                          end
      @date = params[:date]
      @text = params[:text]
    end
  end
end
