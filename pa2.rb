require 'statsample'

class MovieData
	def initialize(filepath, ext = "u.data" )
		@count = 0
		@ratings = Hash.new
		@users = Hash.new
		@movies = Hash.new
		filepath = filepath + ext
		parse(filepath)
	end
	def parse(filepath)
		userdb = File.open(filepath, "r")
		userdb.each do |line|
			user_id = line.split("\t")[0]
			movie_id = line.split("\t")[1]
			movie_rating = (line.split("\t")[2])
			#@ratings[user_id] = Hash.new
			rating_key = [user_id, movie_id]
			@ratings[rating_key] = movie_rating
			#@ratings.push(Rating.new(user_id, movie_id, movie_rating))
			if @users.include? user_id
				abs_rating(user_id, movie_rating)
			else
				@users[user_id] = User.new(user_id, movie_rating)
			end
			if @movies.include? movie_id
				add_rating(movie_id, movie_rating)
			else
				@movies[movie_id] = Movie.new(movie_id, movie_rating)
			end
		end
		#puts @ratings
		#puts @users
	end
	def rating(user, movie)
		final_rating = 0
		@ratings.each do |rating_key, rating_value|
			if rating_key[0]== user.to_s && rating_key[1] == movie.to_s
				final_rating = rating_value
			end
		end
		#puts final_rating
		return final_rating
	end
	def movies(user)
		watched = []
		@ratings.each do |rating_key, rating_value|
			if rating_key[0]== user.to_s
				watched.push(rating_key[1])
			end
		end
		return watched
	end

	def viewers(movie)
		seen = []
		@ratings.each do |rating_key, rating_value|
			if rating_key[1] == movie.to_s
				seen.push(rating_key[0])
			end
		end
		return seen
	end

	def add_rating(movie_id, new_rating)
		rating = @movies[movie_id.to_s].rating.to_i
		rating += new_rating.to_i
		@movies[movie_id.to_s].rating = rating
		updated = @movies[movie_id.to_s]
		return updated
	end

	def abs_rating(user_id, new_rating)
		rating = @users[user_id.to_s].rating.to_i
		rating = (rating - new_rating.to_i).abs
		@users[user_id.to_s].rating = rating
		updated = @users[user_id.to_s]
		return updated
	end

	def poplist
		@movies.each do |movie_id, object|
			@movies[movie_id] = object.rating
		end
		poplist = @movies.sort_by { |movie, popularity| popularity.to_i }.reverse
	end

	def similar(u1, u2)
		hash = Hash.new
		common = movies(u1) & movies(u2)
		#puts "U1: #{u1} U2: #{u2} Common: #{common} "
		common.each do |movie|
			@similarity = (@ratings[[u1.to_s, movie.to_s]].to_i - @ratings[[u2.to_s, movie.to_s]].to_i).abs
			#@similarity = (rating(u1, movie) - rating(u2, movie)).abs
		end
		case @similarity
		when 0
			value = 5
		when 1
			value = 4
		when 2
			value = 3
		when 3
			value = 2
		when 4
			value = 1
		else
			value = "ERROR"
		end
		hash[u2] = value
	return hash
	end

	def simlist(u)
		simlist = []
		final = []
		@users.each do |user, object|
			simlist.push(similar(u, user))
			#print @count += 1
		end
		sorted = simlist.sort_by! { |item| item.values}.reverse
		sorted.each do |hash| 
			hash.each_key do |key|
				final.push(key)
			end
		end
		#puts final.inspect
		return final[1...100]
	end
	def predict(u, m) #find the user who is most similar to u and choose the value that he/she chose
		collect = []
		most_similar = simlist(u)
		most_similar.each do |user|
			collect.push(rating(user.to_i, m.to_i))
		end
		collect.reject! { |x| x ==0 }
		return collect.inject{ |sum, x| sum.to_f + x.to_f} / collect.length
	end
	def run_test(k)
		t = MovieTest.new
		t.mean
		t.stddev
		t.rms
		t.to_a
	end
end

class MovieTest

	def initialize
		@mean = 0
		@stddev = 0
		@rms = 0
	end

	def mean(data)
		return data.mean
	end
	def stddev(mean)
		return mean.stddev
	end
	def rms
	end
	def to_a
	end
end

class Rating
	attr_accessor :user_id, :movie_id, :rating
	def initialize(uid, mid, mrating)
		@user_id = uid
		@movie_id = mid
		@rating = mrating
	end
end

class User
	attr_accessor :user_id, :rating
	def initialize(uid, mrating)
		@user_id = uid
		@rating = mrating
	end
end

class Movie
	attr_accessor :movie_id, :rating
	def initialize(mid, mrating)
		@movie_id = mid
		@rating = mrating
	end
end


z = MovieData.new("/Users/sharat/mydev/pa2/ml-100k/", "u1.test")
#t = MovieTest.new


#z.run_test
#t.mean(1, 258)
#puts z.predict(1, 258)
#puts z.similar(1, 13)
#puts z.simlist(1)
#print z.similar(1,460)
#puts z.rating(1,258)
#puts z.movies(1)
#puts z.viewers(6)
#z.update_rating(1, 3)