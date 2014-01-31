
class MovieTest
	attr_accessor :results
	def initialize
		@results = []
	end
	def input(u, m, r, p)
		@results.push [u, m, r, p]
	end
	def mean
		sum = 0
		@results.each do |u, m, r, p|
			diff = (r - p).abs
			sum += diff.to_f
		end
		#puts @results.length
		return sum/@results.length
	end
	def stddev
		#debugger
		sum = 0
		avg = mean
		@results.each do |u, m, r, p|
			diff = r - p
			sum += (diff - avg.to_f)**2
		end
		#puts sum
		return Math.sqrt(sum / (@results.length))
	end
	def rms
		sum = 0
		@results.each do |u, m, r, p|
			diff = (r - p)
			sum += (diff.to_f**2)
		end
		return Math.sqrt(sum / @results.length)
	end
	def to_a
		return @results
	end
end

