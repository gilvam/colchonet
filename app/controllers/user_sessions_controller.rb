class UserSessionsController < ApplicationController
	#usuario nao autenticado pode criar seu perfil
	before_action :require_no_authentication, only: [:new, :create]
	#apenas usuario autenticado pode deslogar
	before_action :can_change, only: :destroy

	def new
		@user_session = UserSession.new(session)
	end

	def create
		@user_session = UserSession.new(session, params[:user_session])
		if @user_session.authenticate
			#nao esqueca de adicionar a chave no i18n!
			redirect_to root_path, notice: t('flash.notice.signed_in')
		else
			render :new
		end
	end

	def destroy
		user_session.destroy
		redirect_to root_path, notice: t('flash.notice.signed_out')
	end

end