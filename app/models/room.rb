class Room < ActiveRecord::Base

	has_many :reviews, dependent: :destroy
	belongs_to :user

	validates_presence_of :title, :location
	validates_length_of :description, minimun: 30, allow_blank: false

	def complete_name
		"#{title}, #{location}"
	end

	# se confirmed_at esta nil, o email de confirmacao ainda nao foi feito
	scope :confirmed, -> {where.not(confirmed_at: nil)}

	# dos mais antigos aos mais recentes
	scope :most_recent, -> {all.reverse}

	def self.search(query)
		if query.present?
			where(['location LIKE :query OR
              title LIKE :query OR
              description LIKE :query', query: "%#{query}%"])

		#se não tem resultado da busca, continua com o resultado antigo
		else
			scoped
		end
	end


end
