# frozen_string_literal: true

class ErrorGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_error
    path = "app/errors/#{file_path}_error.rb"
    template('error.template', path)
  end
end
