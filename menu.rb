require './style_string.rb'
require './utils.rb'

class Menu
	attr_accessor :title, :options, :actions, :num_options, :running
	private :num_options, :actions

	def initialize title, options
		@title = title
		@options = options
		# Always adding quit option
		case @options.last
		when 'Exit', 'Quit', 'Stop', 'Abort', 'Back', 'exit', 'quit', 'stop', 'abort', 'back'
		else
			@options << 'Exit'
		end
		@num_options = @options.length
		@actions = Array.new @num_options, nil
		# Setting value for quitting functions
		@actions[@num_options - 1] = lambda do |*args|
			@running = false
		end
		@running = false
	end

	def print
		puts "\t#{@title.bold.blue}"
		@num_options.times do |i|
			puts "#{"#{i + 1} -".bold} #{options[i].underline}".cyan
		end
	end

	def set_option option_id, fn
		@actions[option_id - 1] = fn
	end

	def run_option option_id, *args
		if @actions[option_id - 1] == nil
			err "The function for option `#{option_id}` of menu `#{@title}` has not been set"
		end
		clear
		@actions[option_id - 1].call *args
		read_string "Press Enter to continue.".underline.magenta if option_id != options.length
		clear
	end

	def run *args
		@running = true
		while @running do
			self.print
			input_option = read_integer_in_range "#{"Option:".underline.magenta} ", 1, @num_options
			self.run_option input_option, *args
		end
		puts "Quitting...".bold.brown
	end

end
