# frozen_string_literal: true

# ApplicationControlle
class ApplicationController < ActionController::Base
  protect_from_forgery

  include Pagy::Backend
  include RansackMemory::Concern

  before_action :authenticate_user!
end
