class UsersController < ApplicationController

	#usuario nao autenticado pode criar seu perfil
	before_action :require_no_authentication, only: [:new, :create]
	#apenas usuario logado pode editar seu perfil
	before_action :can_change, only: [:edit, :update]


	def new
		@user =  User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			#enviar email para confirmacao
			Signup.confirm_email(@user).deliver
			redirect_to @user, notice: 'Cadastro criado com sucesso!'
		else
			render action: :new
		end
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to @user, notice: 'Cadastro atualizado com sucesso!'
		else
			render action: :edit
		end
	end


	private

	def user_params
		# os 'pontos' no final da linha nao sao opcionais
		params.
				require(:user).
				permit(:email, :full_name, :location, :password, :password_confirmation, :bio)
	end

	# usuario logado pode apenas editar o proprio perfil
	def can_change
		unless user_signed_in? && current_user == user
			redirect_to user_path(params[:id])
		end
	end

	# se @user esta vazio, realiza a busca do @user
	def user
		@user ||= User.find(params[:id])
	end


end