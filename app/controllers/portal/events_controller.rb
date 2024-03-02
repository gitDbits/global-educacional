# frozen_string_literal: true

module Portal
  # EventsController
  class EventsController < ApplicationController
    skip_before_action :authenticate_user!
    
    layout :resolve_layout

    before_action :set_event, only: %i[show]

    def new; end

    def index; end

    def show
      @event = Event.find(params[:id])
    end

    def create
      if @event.save
        flash[:success] = 'Evento criado com sucesso!'
        redirect_back fallback_location: root_path
      else
        flash[:error] = @event.errors.full_messages.uniq.join(', ')
        redirect_to back_url
      end
    end

    def update
      if @event.update(event_params)
        flash[:success] = 'O Evento foi alterado com sucesso'
      else
        flash[:error] = @event.errors.full_messages.uniq.join(', ')
      end

      redirect_back fallback_location: root_path
    end

    def checkout
      @event = Event.find(params[:event_id])
      @states = State.all
    end

    def destroy
      @event.destroy

      flash[:success] = 'Evento excluída com sucesso!'

      redirect_back fallback_location: root_path
    end

    private

    def event_params
      params.require(:event).permit(:name, :duration, :value, :open_subscription)
    end

    def set_event
      @event = Event.find(params[:id])
    end

    def resolve_layout
      case action_name
      when 'show'
        'portal_detail'
      when 'checkout'
        'portal_event_checkout'
      else
        'portal'
      end
    end
  end
end
