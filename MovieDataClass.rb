#Author: Sharat Sridhar
require_relative 'MovieClass'
require_relative 'UserClass'
require_relative 'MovieTestClass'
require 'debugger'

class MovieData

	def initialize
		@utest = Hash.new
		@mtest = Hash.new
		@users = Hash.new
		@movies = Hash.new
		filepath = filepath
		#parse(filepath, ext, k)
	end
	def parse(filepath, ext ="u.data", k = nil, user_set=@users, movie_set=@movies)
		filepath = filepath + ext
		counter = 0
		userdb = File.open(filepath, "r")
		userdb.each do |line|
			user_id = line.split("\t")[0]
			movie_id = line.split("\t")[1]
			movie_rating = (line.split("\t")[2])
   			if !user_set.has_key? user_id
    			user_set[user_id] = User.new
    		end
    		user_set[user_id].attribute(movie_id, movie_rating)
    		if !movie_set.has_key? movie_id
       			movie_set[movie_id] = Movie.new
       		end
    		movie_set[movie_id].attribute user_id, movie_rating
    		counter += 1
    		if counter == k
    			line.chomp!
    			break
    		end
	    end
        #puts user_set.length
    	#puts movie_set.length
    end
    def rating(user, movie)
    	rating = @users[user.to_s].prop[movie.to_s].to_i
    	return rating
    end
    def similar(u1, u2)
    	hash1 = @users[u1.to_s].prop
    	hash2 = @users[u2.to_s].prop
    	common_movies = Hash.new
    	sum = 0
    	common_keys = hash1.keys & hash2.keys #finds the common movies
    	if common_keys.empty?
    		common_movies[u2] = 0			#if there are none, return 0
    	else
	    	common_keys.each do |movie|
	    		sum += 5 - (hash1[movie].to_f - hash2[movie].to_f).abs
	    		#hash1[movie] + hash2[movie]
	    		#sum += (hash1[movie].to_f + hash2[movie].to_f) 
	    	end
	    	common_movies[u2] = sum / (common_keys.length)
	    end
	    return common_movies
    end
    def simlist(u)
    	simlist = []
    	@users.each do |user, object|
			simlist.push(similar(u, user))
		end
		#puts simlist
		sorted = simlist.sort_by! { |item| item.values}.reverse
		return sorted#[0...1000]
	end
	def predict(u, m) #find the user who is most similar to u and choose the value that he/she chose
		@database = Hash.new
		usermovies = Hash.new
		usermovies[u] = m
		collect = []
		most_similar = simlist(u)
		most_similar.each do |hash|
			hash.each do |user, similar|
				#collect.push(v)
				#puts "User: #{user} Movie: #{m} similar: #{similar}"
				collect.push(rating(user.to_i, m.to_i))
			end
			
		end
		#puts collect
		collect.reject! { |x| x ==0 }
		collect = collect.compact
		#puts collect.inspect
		if collect.empty?
			@database[usermovies] = 2.5
		else
			prediction = collect.inject{ |sum, x| sum.to_f + x.to_f} / collect.length
			#@database[usermovies] = prediction
		end
		return prediction
	end
	def run_test(k=20000)
		t = MovieTest.new
		array = []
		parse("/Users/sharat/mydev/pa2/ml-100k/", "u1.test", k, @utest, @mtest)
		@utest.each do |user, object|
			object.prop.each do |key, value|
				#puts "User #{user}, key #{key}, value #{value}"
				@beginning_time = Time.now
				prediction = (predict(user, key))
				@end_time = Time.now
				t.input(user.to_i, key.to_i, value.to_i, prediction)
			end
		end
		#debugger
		puts "Time elapsed #{(@end_time - @beginning_time)*1000} milliseconds"
		puts "Mean: #{t.mean}"
		puts "Standard Deviation: #{t.stddev}"
		puts "Root Mean Square: #{t.rms}"
		print "To array: #{t.to_a}"
		return t
	end



end    

z = MovieData.new#("/Users/sharat/mydev/pa2/ml-100k/", "u1.base")
z.parse("/Users/sharat/mydev/pa2/ml-100k/", "u1.base")
#puts z.rating(123, 61)
#puts z.similar(1, 2)
#puts z.simlist(1)
#puts z.predict(1, 61)
z.run_test(10)