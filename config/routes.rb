# frozen_string_literal: true

Rails.application.routes.draw do
  get 'rey/index'
  root 'home#index'
  post 'telegram/get_updates'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
