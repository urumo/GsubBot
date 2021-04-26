# frozen_string_literal: true

module Tg
  class Chat
    attr_reader :id, :title, :type

    def initialize(params)
      @id = params[:id]
      @title = params[:title]
      @type = params[:type]
    end
  end
end
