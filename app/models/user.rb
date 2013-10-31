class User < ActiveRecord::Base

	EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

	validates_presence_of :email, :full_name, :location
	validates_length_of :bio, minimun: 30, allow_blank: false
	validates_format_of :email, with: EMAIL_REGEXP

	# o has_secure_password faz todas as validacoes de senha
	has_secure_password

	#gerar tokens aleatorios para confirmar cadastro via email
	before_create do |user|
		user.confirmation_token = SecureRandom.urlsafe_base64
	end

	# se confirmed_at esta nil, o email de confirmacao ainda nao foi feito
	scope :confirmed, -> {where.not(confirmed_at: nil)}

	def self.authenticate(email, password)
		user = confirmed.
				find_by(email: email).
				try(:authenticate, password)

				#OBS: o try é o mesm oque:
				#if user.present?
				#	user.authenticate(password)
				#end
	end

	# marca o campo confirmed_at com a hora corrente e limpa o token
	def confirm!
		return if confirmed?

		self.confirmed_at = Time.current
		self.confirmation_token = ''
		save!
	end

	# retorna true se campo confirmed_at esta vazio
	def confirmed?
		confirmed_at.present?
	end

end