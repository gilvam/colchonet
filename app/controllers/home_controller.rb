class HomeController < ApplicationController

	def index
		#busca 3 registros no banco sem ordem determinada
		@rooms = Room.take(3)
	end

end