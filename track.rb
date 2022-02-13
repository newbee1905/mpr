class Track
	attr_accessor :name, :location, :id
	
	def initialize name, location, id
		@name = name
		@location = location
		@id = id
	end
end

# Reads in and returns a single track from the given file

def read_track music_file, id
	track_title = music_file.gets.chomp
	track_location = music_file.gets.chomp
	Track.new track_title, track_location, id
end

# Returns an array of tracks read from the given file

def read_tracks music_file
	count = music_file.gets.to_i
	tracks = Set.new

	count.times do |i|
		tracks << read_track(music_file, i + 1)
	end

	tracks
end

# Takes an array of tracks and prints them to the terminal

def print_tracks tracks
	for track in tracks do
		print_track track
	end
end

# Takes a single track and prints it to the terminal
def print_track track
	# puts "Track title is:  #{track.name}"
	# puts "Track file location is: #{track.location}"
	puts "#{"#{track.id}".bold.blue} #{"#{track.name}".underline.blue}"
end


def playing_track album
	print_tracks album.tracks
	track_id = read_integer_in_range "#{"Enter Track ID to play:".underline.magenta} ", 1, album.tracks.length
	system "mpv --no-video '#{album.tracks.to_a[track_id - 1].location}'"
end
