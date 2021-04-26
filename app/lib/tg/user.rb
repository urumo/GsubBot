# frozen_string_literal: true

module Tg
  class User
    attr_reader :id, :is_bot, :first_name, :last_name, :username, :language_code

    def initialize(params)
      @id = params[:id]
      @is_bot = params[:is_bot]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @username = params[:username]
      @language_code = params[:language_code]
    end
  end
end
