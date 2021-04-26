# frozen_string_literal: true

class TelegramController < ApplicationController
  def get_updates
    ParseMessageJob.perform_later(params[:message].to_json)
    render json: params
  end
end
