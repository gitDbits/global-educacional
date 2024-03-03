# frozen_string_literal: true

module Portal
  # UsersController
  class UsersController < ApplicationController
    skip_before_action :authenticate_user!

    before_action :set_user, only: :voucher

    def create
      @user = User.new(user_params)
      @user.password = '123456'
      @user.password_confirmation = '123456'
      @user.payment_method = params[:payment_method]

      @event = Event.find(params.dig(:user, :event_id))

      if @user.save
        flash[:notice] = 'Sua inscrição foi realizada com sucesso, entre em contato pelo nosso  WhatsApp (69) 99272-9043 para finalizar o seu pagamento.'

        message_whatsapp = "
          🌟 Olá, realizei a minha inscrição no evento: #{@event.name} 🌟

          Aqui estão os detalhes:
          📧 E-mail: #{@user.email}
          👤 Nome: #{@user.name}
          🔢 CPF: #{@user.cpf}
          📱 Telefone: #{@user.phone}
          📍 CEP: #{@user.zipcode}
          🏠 Endereço: #{@user.address}, Nº #{@user.number_address}
          🏘 Bairro: #{@user.district}
          🌆 Cidade: #{@user.city}
          🗺 Estado: #{@user.state}
          💰 Forma de pagamento: #{params[:payment_method]}

          Gostaria de dar continuidade na minha inscrição ✨
        ".strip

        encoded_message = URI.encode_www_form_component(message_whatsapp)
        phone_number = '69992729043'
        whatsapp_url = "https://api.whatsapp.com/send?phone=55#{phone_number}&text=#{encoded_message}"

        redirect_to whatsapp_url, allow_other_host: true
      else
        flash[:error] = @user.errors.full_messages.uniq.join(', ')
        @selected_state = params[:user][:state]

        redirect_to(portal_event_checkout_pt_path(params.dig(:user, :event_id), user_params))
      end
    end

    def voucher
      respond_to do |format|
        format.pdf do
          render pdf: "solicitacao-inscricao-#{@user.id}",
                 margin: { left: 15, right: 15 },
                 footer: { right: '[page]',
                           margin: { bottom: 10 } },
                 locals: { user: @user, qrcode_for_voucher: qrcode_for_voucher(@user) }
        end
      end
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def qrcode_for_voucher(user)
      user = User.find(user.id)
      generate_qrcode("https://globaleducacional.com.br/portal/usuarios/buscar_usuario?q%5Bcpf_cont%5D=#{user.cpf}")
    end

    def user_params
      params.require(:user).permit(:name, :email, :cpf, :phone, :zipcode, :address,
                                   :number_address, :district, :complement_address,
                                   :city, :state, :password, :password_confirmation, :admin)
    end
  end
end
