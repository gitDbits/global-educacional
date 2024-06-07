# frozen_string_literal: true

module Portal
  # UsersController
  class UsersController < ApplicationController
    before_action :authenticate_user!, only: %i[show voucher]

    before_action :set_user, only: %i[show edit update voucher]

    layout :resolve_layout

    def show; end

    def edit
      @states = State.all
    end

    def update
      if @user.update(user_params)
        flash[:success] = 'Os dados foram atualizados com sucesso'
        redirect_to portal_home_pt_path(cancel_filter: true)
      else
        flash[:error] = 'Não foi possível atualizar os dados'
        render :edit, status: :unprocessable_entity
      end
    end

    def create; end

    def report_participants
      @event = Event.first

      @users_by_city = User.where(admin: nil).group_by(&:city).transform_values do |users|
        users.sort_by { |user| user.name }
      end

      respond_to do |format|
        format.pdf do
          render pdf: "lista-participante-#{@event.name}",
                 margin: { left: 15, right: 15, top: 15, bottom: 15 },
                 orientation: 'Landscape',
                 show_as_html: params.key?('debug'),
                 footer: { right: '[page]',
                           margin: { bottom: 10 } },
                 locals: { users: @users }
        end
      end
    end

    def report_list_presence
      @event = Event.first
      @event_date = params[:event_date]
      @start_time = params[:start_time]
      @end_time = params[:end_time]

      @users_by_city = User.where(admin: nil).group_by(&:city).transform_values do |users|
        users.sort_by { |user| user.name }
      end

      respond_to do |format|
        format.pdf do
          render pdf: "lista-participante-#{@event.name}",
                 margin: { left: 15, right: 15, bottom: 15 },
                 orientation: 'Landscape',
                 show_as_html: params.key?('debug'),
                 footer: { right: '[page]',
                           margin: { bottom: 10 } },
                 locals: { users: @users, event_date: @event_date, start_time: @start_time, end_time: @end_time}
        end
      end
    end

    def report_id_paper
      @users = User.where(admin: nil)

      respond_to do |format|
        format.pdf do
          render pdf: "etiqueta-participantes",
                 margin:  { left: 5, right: 5, top: 5, bottom: 5 },
                 show_as_html: params.key?('debug'),
                 locals: { users: @users }
        end
      end
    end

    def award
      @award_user = User.where(admin: nil)
    end

    private

    def set_user
      @user = if params[:action] == 'show' || params[:action] == 'update' || params[:action] == 'edit'
                User.friendly.find(params[:id])
              else
                @user = User.friendly.find(params[:user_id])
              end
    end

    def qrcode_for_voucher(user)
      user = User.find(user.id)
      generate_qrcode("https://globaleducacional.com.br/portal/usuarios/buscar_usuario?q%5Bcpf_cont%5D=#{user.cpf}")
    end

    def resolve_layout
      case params[:action]
      when 'show'
        'admin_detail'
      when 'edit'
        'admin_detail'
      when 'award'
        'admin_detail'
      else
        'admin'
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :cpf, :phone, :zipcode, :address,
                                   :number_address, :district, :complement_address,
                                   :city, :state, :password, :password_confirmation, :admin,
                                   :paid, :paid_note, :payment_status, :institution, :payment_method)
    end
  end
end
