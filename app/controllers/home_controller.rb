# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { mamka_yuuki: true }
  end
end
