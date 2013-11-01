class ApplicationController < ActionController::Base

	# usar os metodos listados de user_session.rb nos outros modelos
	delegate :current_user, :user_signed_in?, to: :user_session
	helper_method :current_user, :user_signed_in?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_action do
		I18n.locale = params[:locale] || I18n.default_locale
	end

	def default_url_options
		{ locale: I18n.locale }
	end

	def user_session
		UserSession.new(session)
	end

	# se sessao nao altenticada, usuario redirecionado para logar
	def require_authentication
		unless user_signed_in?
			redirect_to new_user_sessions_path, alert: t('flash.alert.needs_login')
		end
	end

	# se usuario nao altenticado, usuario é redirecionado para tela inicial
	def require_no_authentication
		if user_signed_in?
			redirect_to root_path, notice: t('flash.notice.already_logged_in')
		end
	end

end
