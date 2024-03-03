# frozen_string_literal: true

module Portal
  # HomeController
  class HomeController < ApplicationController
    layout 'admin'

    def home
      @q = User.where(admin: nil).order(id: :desc).ransack(params[:q])
      @pagy, @users = pagy(@q.result(distinct: true))
    end
  end
end
