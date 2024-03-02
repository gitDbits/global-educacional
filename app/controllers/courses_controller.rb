# frozen_string_literal: true

# CoursesController
class CoursesController < ApplicationController
  skip_before_action :authenticate_user!
  
  layout 'course'
  
  def show
  end
end
