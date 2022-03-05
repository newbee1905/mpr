require 'rubygems'
require 'set'
require 'fuzzystringmatch'
require './utils.rb'
require './input_functions'
require './album.rb'
require './style_string.rb'
require './menu.rb'

# Creating menu and sub menus
$main_menu = Menu.new(
	"MAIN MENU",
	["Read in Albums", "Display Albums", "Select an Album to play", "Update an existing Album"]
)
$display_albums_menu = Menu.new(
	"DISPLAY ALBUMS",
	["Display All", "Display Genre"]
)
$select_play_album_menu = Menu.new(
	"SELECT ALBUM TO PLAY",
	["Select by ID", "Search with pattern"]
)
$select_update_album_menu = Menu.new(
	"SELECT ALBUM TO UPDATE",
	["Select by ID", "Search with pattern"]
)
$update_album_menu = Menu.new(
	"UPDATE ALBUM",
	["Update Title", "Update Artist", "Update Genre"]
)

def main
	# Setting functions for main menu
	$main_menu.set_option(1, lambda do
		file_name = read_string "#{"Enter the File you want to Read in Albums:".underline.magenta} "
		read_albums file_name
		$current_file = file_name
		puts "Backing up the album file to `#{file_name}.bk`".brown
		system "cp #{file_name} #{file_name}.bk"
		puts "File Loaded...".brown
	end)
	$main_menu.set_option(2, lambda do; clear; $display_albums_menu.run; end)
	$main_menu.set_option(3, lambda do; clear; $select_play_album_menu.run; end)
	$main_menu.set_option(4, lambda do; clear; $select_update_album_menu.run; end)
	# Reset quit actions to save the ablum if it is updated
	$main_menu.set_option(5, lambda do
		if $updated_album then
			puts "Saving...".brown
			sleep 1
			album_file = File.new $current_file, 'w'
			album_file.puts $album_list.length
			$album_list.each do |album|
				album_file.puts album.title
				album_file.puts album.artist
				album_file.puts album.genre
				album_file.puts album.tracks.length
				album.tracks.each do |track|
					album_file.puts track.name
					album_file.puts track.location
				end
			end
			album_file.close
			puts "Saved.".brown
			sleep 1.5
		end
		$main_menu.running = false
	end)

	# Setting functions for display ablums menu
	$display_albums_menu.set_option(1, lambda do; print_albums; end)
	$display_albums_menu.set_option(2, lambda do
		print_genres
		genre = read_integer "#{"Enter Genre number:".magenta.underline} "
		print_albums_by_genre genre
	end)

	# Setting functions for select ablum to play menu
	$select_play_album_menu.set_option(1, lambda do
		album = get_album_by_id
		playing_track album
	end)
	$select_play_album_menu.set_option(2, lambda do
		album = get_album_by_fuzzy_search
		if album == nil
			puts "Can't find any albums with that name".red
			return
		end
		puts "The album `#{album.title}` is selected".brown
		playing_track album
	end)

	# Setting functions for select ablum to update menu
	$select_update_album_menu.set_option(1, lambda do
		album = get_album_by_id
		puts "You select Album #{album.title} by #{album.artist}.".brown
		$update_album_menu.run album
	end)
	$select_update_album_menu.set_option(2, lambda do
		album = get_album_by_fuzzy_search
		puts "The album `#{album.title}` is selected".brown
		$update_album_menu.run album
	end)

	# Setting functions for update menu
	$update_album_menu.set_option(1, lambda do |album|
		album.title = read_string "#{"Update Title to:".brown} "
		$updated_album = true
	end)
	$update_album_menu.set_option(2, lambda do |album|
		album.artist = read_string "#{"Update Artist to:".brown} "
		$updated_album = true
	end)
	$update_album_menu.set_option(3, lambda do |album|
		print_genres
		album.genre = read_integer_in_range "#{"Update Genre to:".brown} ", 1, $genre_names.length
		$updated_album = true
	end)

	begin
		$main_menu.run
	rescue Interrupt
		puts "\nForce quit.".bold.brown
	end
end

main
