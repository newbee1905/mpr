module Genre
	POP, CLASSIC, JAZZ, ROCK, COUNTRY_POP, HIP_HOP = *1..6
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock', "Country Pop", "Hip Hop"]

def print_genres
	$genre_names.each_with_index do |genre, id|
		puts "#{"#{id} -".bold} #{genre.underline}".cyan
	end
end
