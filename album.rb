require './track.rb'
require './genre.rb'

$album_list = Set.new []
$updated_album = false
$current_file = nil

class Album
	attr_accessor :title, :artist, :genre, :tracks, :id

	def initialize title, artist, genre, tracks, id
		@title = title
		@artist = artist
		@genre = genre
		@tracks = tracks
		@id = id
	end

	def print
		puts "Album ID: #{id}".bold.green.underline
		puts "\t==#{$genre_names[@genre]}==".bold.blue
		puts "\t> #{@title} by #{@artist}".bold.blue
		puts "\tTracks: #{@tracks.length}\n".cyan
	end

	def print_tracks
		print_tracks self.tracks
	end
end

def read_album music_file, id
	album_title = music_file.gets.chomp
	album_artist = music_file.gets.chomp
	album_genre = music_file.gets.chomp.to_i

	Album.new album_title, album_artist, album_genre, read_tracks(music_file), id
end

def read_albums file_name
	begin
		album_file = File.new file_name, 'r'	
	rescue Errno::ENOENT
		puts "Back to the menu. There is no suck file".red
	else	
		num_album = album_file.gets.chomp.to_i
		num_album.times do |i|
			$album_list << read_album(album_file, i + 1)
		end
		album_file.close
	end
end

def print_albums
	for album in $album_list do
		album.print
	end
end

def print_albums_by_genre genre
	for album in $album_list do
		album.print if album.genre == genre
	end
end

def get_album_by_id
	album_id = read_integer_in_range "#{"Album ID:".magenta.underline} ", 1, $album_list.length
	$album_list.to_a[album_id - 1]
end

def get_album_by_fuzzy_search
	input = read_string "#{"Enter pattern:".magenta.underline} "
	max_dist = 0.0
	max_album = nil
	for album in $album_list do
		dist = jarow.getDistance(album.title, input)
		if dist > max_dist then
			max_dist = dist
			max_album = album
		end
	end
	max_album
end
