# frozen_string_literal: true

class ReyController < ApplicationController
  def index
    render json: GosuModel.all.sample.reply
  end
end
