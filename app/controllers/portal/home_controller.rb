# frozen_string_literal: true

module Portal
  # HomeController
  class HomeController < ApplicationController
    layout 'admin'

    def home
      @users = User.where(admin: nil)
    end
  end
end
