# frozen_string_literal: true

module Portal
  class SubscriptionEventsController < ApplicationController
    skip_before_action :authenticate_user!, except: %i[index search_subscription_event update clear_filters]
    before_action :set_subscription_event, only: %i[voucher update]

    layout 'admin'

    def new
      @subscription_event = SubscriptionEvent.new
      @event = Event.find(params[:event_id])
    end

    def index
      if params[:action] == 'subscription_event'
        @event = Event.find(params.dig(:q, :event_id))
      else
        @event = Event.find(params[:event_id])
      end


      @q = SubscriptionEvent.where(event: @event).order(id: :desc).ransack(params[:q])
      @pagy, @subscription_events = pagy(@q.result(distinct: true))
    end

    def create
      @user = User.find_or_initialize_by(cpf: CPF.new(params[:subscription_event][:cpf]).stripped)

      if SubscriptionEvent.find_by(user: @user, event_id: params.dig(:subscription_event, :event_id)).present?
        flash[:error] = 'Atenção este CPF já está cadastrado neste evento, caso tenha alguma dúvida entre em contato (69) 99272-9043'
        @selected_state = params[:subscription_event][:state]

        return redirect_to event_checkout_pt_path(params.dig(:subscription_event, :event_id), user_params)
      end

      if @user.new_record?
        @user.assign_attributes(
          name: params[:subscription_event][:name],
          email: params[:subscription_event][:email],
          phone: params[:subscription_event][:phone],
          zipcode: params[:subscription_event][:zipcode],
          address: params[:subscription_event][:address],
          number_address: params[:subscription_event][:number_address],
          district: params[:subscription_event][:district],
          complement_address: params[:subscription_event][:complement_address],
          state: params[:subscription_event][:state],
          city: params[:subscription_event][:city],
          password: '123456',
          password_confirmation: '123456'
        )
      else
        @user.update(
          name: params[:subscription_event][:name],
          email: params[:subscription_event][:email],
          phone: params[:subscription_event][:phone],
          zipcode: params[:subscription_event][:zipcode],
          address: params[:subscription_event][:address],
          number_address: params[:subscription_event][:number_address],
          district: params[:subscription_event][:district],
          complement_address: params[:subscription_event][:complement_address],
          state: params[:subscription_event][:state],
          city: params[:subscription_event][:city]
        )
      end

      if @user.save
        @subscription_event = SubscriptionEvent.new(subscription_event_params)
        @subscription_event.user = @user
        @subscription_event.payment_status = 'pendente'

        if @subscription_event.save
          flash[:notice] = 'Sua inscrição foi realizada com sucesso, entre em contato pelo nosso WhatsApp (69) 99272-9043 para finalizar o seu pagamento.'
          message_whatsapp = "
        🌟 Olá, realizei a minha inscrição no evento: #{@subscription_event.event.name} 🌟

        Segue os detalhes da minha solicitação de inscrição:
        📧 E-mail: #{@subscription_event.user.email}
        👤 Nome: #{@subscription_event.user.name}
        🔢 CPF: #{params[:subscription_event][:cpf]}
        📱 Telefone: #{@subscription_event.user.phone}
        📍 CEP: #{@subscription_event.user.zipcode}
        🏠 Endereço: #{@subscription_event.user.address}, Nº #{@subscription_event.user.number_address}
        🏘 Bairro: #{@subscription_event.user.district}
        🌆 Cidade: #{@subscription_event.user.city}
        🗺 Estado: #{@subscription_event.user.state}
        💰 Forma de pagamento: #{@subscription_event.payment_type}

        🖨️ Seu comprovante da solicitação de Inscrição está disponível em: https://globaleducacional.com.br/portal/inscricao_evento/#{@subscription_event.id}/voucher.pdf

        Gostaria de dar continuidade para a minha participação no evento ✨
      ".strip

          encoded_message = URI.encode_www_form_component(message_whatsapp)
          phone_number = '69992729043'
          whatsapp_url = "https://api.whatsapp.com/send?phone=55#{phone_number}&text=#{encoded_message}"

          redirect_to whatsapp_url, allow_other_host: true
        else
          flash[:error] = @subscription_event.errors.full_messages.uniq.join(', ')
          @selected_state = params[:subscription_event][:state]
          redirect_to event_checkout_pt_path(params.dig(:subscription_event, :event_id), user_params)
        end
      else
        flash[:error] = @user.errors.full_messages.uniq.join(', ')
        @selected_state = params[:subscription_event][:state]
        redirect_to event_checkout_pt_path(params.dig(:subscription_event, :event_id), user_params)
      end
    end

    def update
      if @subscription_event.update(subscription_event_params)
        flash[:success] = 'Os dados foram atualizados com sucesso'
        redirect_to portal_subscription_events_pt_path(event_id: params.dig(:subscription_event, :event_id))
      else
        flash[:error] = 'Não foi possível atualizar os dados'
        render :edit, status: :unprocessable_entity
      end
    end

    def voucher
      respond_to do |format|
        format.pdf do
          render pdf: "solicitacao-inscricao-#{@subscription_event.event.slug}",
                 show_as_html:  params.key?('debug'),
                 margin: { left: 15, right: 15 },
                 footer: { right: '[page]',
                           margin: { bottom: 10 } },
                 locals: { subscription_event: @subscription_event,
                           qrcode_for_voucher: qrcode_for_voucher(@subscription_event) }
        end
      end
    end

    def qrcode_for_voucher(subscription_event)
      generate_qrcode("https://globaleducacional.com.br/portal/inscricao_evento/#{subscription_event.id}")
    end

    def subscription_event
      index
      render(:index)
    end

    def clear_filters
      redirect_to portal_subscription_events_pt_path(event_id: params[:event_id])
    end

    def award
      @event = Event.friendly.find(params[:subscription_event_id])

      @award_user =  User.joins(:subscription_events).where(subscription_events: { event_id: @event.id })
    end

    def report_list_presence
      @event = Event.find(params[:event_id])
      @event_date = params[:event_date]
      @start_time = params[:start_time]
      @end_time = params[:end_time]

      @users = SubscriptionEvent.where(event: @event).pluck(:user_id)

      @users_by_city = User.where(id: @users ).group_by(&:city).transform_values do |users|
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
                 locals: { users: @users, event: @event, event_date: @event_date,
                           start_time: @start_time, end_time: @end_time }
        end
      end
    end

    private

    def subscription_event_params
      params.require(:subscription_event).permit(:event_id, :payment_type, :payment_status, :paid_note)
    end

    def user_params
      params.require(:subscription_event).permit(:email, :name, :cpf, :phone, :zipcode, :address, :number_address, :district, :complement_address, :state, :city)
    end

    def set_subscription_event
      if params[:action] == 'update'
        @subscription_event = SubscriptionEvent.find(params[:id])
      else
        @subscription_event = SubscriptionEvent.find(params[:subscription_event_id])
      end
    end
  end
end