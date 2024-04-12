# frozen_string_literal: true

module Portal
  # InstitutionsController
  class InstitutionsController < ApplicationController
    layout 'admin_detail'

    def index
      @q = Institution.order(id: :desc).ransack(params[:q])
      @pagy, @institutions = pagy(@q.result(distinct: true))
    end

    def home; end
  end
end
