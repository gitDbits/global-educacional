# frozen_string_literal: true

# Users::SessionsController
class Users::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action :verify_signed_out_user, only: :destroy
  prepend_before_action(only: [:create, :destroy]) { request.env["devise.skip_timeout"] = true }

  layout 'login'

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate(auth_options)

    if resource.blank?
      flash[:error] = 'Verifique seu e-mail e senha e tente novamente.'
      redirect_to new_user_session_pt_path and return
    end

    unless resource.admin?
      sign_out
      flash[:error] = t('devise.failure.not_admin')
      redirect_to new_user_session_pt_path and return
    end

    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to after_sign_in_path_for(resource)
    else
      flash[:error] = t('devise.failure.invalid', authentication_keys: resource_class.authentication_keys.join(', '))
      redirect_to new_user_session_pt_path
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  protected

  def after_sign_in_path_for(resource)
    portal_home_pt_path
  end

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new", locale: I18n.locale }
  end

  def translation_scope
    'devise.sessions'
  end

  private

  def verify_signed_out_user
    if all_signed_out?
      set_flash_message! :notice, :already_signed_out

      respond_to_on_destroy
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }

    users.all?(&:blank?)
  end

  def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status }
    end
  end
end
