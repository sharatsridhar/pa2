class User
	attr_accessor :prop
	def initialize
		@prop = Hash.new
	end
	def attribute(movie_id, rating)
		@prop[movie_id] = rating
	end
end