# frozen_string_literal: true

# GuestController
class GuestController < ApplicationController
  skip_before_action :authenticate_user!

  def home; end
end
