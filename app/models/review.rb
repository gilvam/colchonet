class Review < ActiveRecord::Base
	# array de 5 elementos, ao invés de range
  POINTS = (1..5).to_a

	belongs_to :user
  belongs_to :room, counter_cache: true

	# o user_id pode repetir se room_id diferente
	validates_uniqueness_of :user_id, scope: :room_id
	validates_presence_of :points, :user_id, :room_id
	validates_inclusion_of :points, in: POINTS

	#pega média e o resultado é aredondado se existir
	def self.stars
		(average(:points) || 0).round
	end

end
