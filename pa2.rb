class MovieData
	def initialize(filepath, ext = "u.data" )
		count = 1
		filepath = filepath + ext
		userdb = File.open(filepath, "r")
		userdb.each do |line|
			user_id = line.split("\t")[0]
			movie_id = line.split("\t")[1]
			movie_rating = (line.split("\t")[2])
			#if Users.users_db.include? user_id
			#	Users.update_attribute(user_id, movie_rating.to_i, count)
			#else
			Users.create_with_attributes(user_id, movie_id,movie_rating.to_i, count)
			#end
		end
	end

	def rating(user, movie)
		Users.users_db.each do |current_user|
			if current_user.user_id == user.to_s && current_user.movie_id == movie.to_s
				puts current_user.rating
			end
		end
	end
	def movies(user)
		watched = []
		Users.users_db.each do |current_user|
			if current_user.user_id == user.to_s
				watched.push(current_user.movie_id)
			end
		end
		puts watched
	end
	def viewers(movie)
		seen = []
		Users.users_db.each do |current_user|
			if current_user.movie_id == movie.to_s
				seen.push(current_user.user_id)
			end
		end
		puts seen
	end

end

class MovieTest
end

class Users
	attr_accessor :user_id, :rating, :count, :movie_id
	@@users_db = []
	def self.users_db 
		@@users_db
	end	

	def self.users_db=(array=[])
		@@users_db = array
	end

	def self.create_with_attributes(user_id, movie_id, rating, count)
		user = self.new
		user.user_id = user_id
		user.movie_id = movie_id
		user.rating = rating
		user.count = count
		@@users_db.push(user)
		return user
	end
end

z = MovieData.new("/Users/sharat/mydev/pa2/ml-100k/", "u1.test")
#puts Users.users_db.inspect
#z.rating(1, 6)
#z.movies(1)
#z.viewers(6)


=begin
	def self.update_attribute(user_id, rating, count)
		if @@users_db.include? user_id
			@@users_db[user_id].rating += rating
			@@users_db[user_id].count += 1
		else 
			puts "not found"
		end
	end
	def initialize
	end
=end

