require './style_string.rb'

def err msg; abort msg.bold.red; end
def clear; printf "\033[2J\x1B[0;0f"; end
