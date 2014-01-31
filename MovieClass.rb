class Movie
	attr_accessor :prop
	def initialize
		@prop = Hash.new
	end
	def attribute(user_id, rating)
		@prop[user_id] = rating
	end
end