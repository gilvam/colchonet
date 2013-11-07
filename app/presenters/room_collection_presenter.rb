 class RoomCollectionPresenter
   #delegate :current_page, :num_pages, :limit_value, :total_pages, to: :@rooms
	 #attr_accessor :current_page, :num_pages, :limit_value, :total_pages

   def initialize(rooms, context)
     @rooms = rooms
     @context = context
   end

   def to_ary
     @rooms.map do |room|
       RoomPresenter.new(room, @context, false)
     end
   end
 end






	#attr_accessor :current_page, :total_pages, :limit_value
