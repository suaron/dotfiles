ARGV.concat [ "--readline"]

# Make gems available
require 'rubygems'

# Prompts
IRB.conf[:PROMPT][:CUSTOM] = {
    :PROMPT_N => ">> ",
    :PROMPT_I => ">> ",
    :PROMPT_S => nil,
    :PROMPT_C => " > ",
    :RETURN => "=> %s\n"
}

# Save History between irb sessions
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 200
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Set default prompt
IRB.conf[:PROMPT_MODE] = :CUSTOM

# Automatic Indentation
IRB.conf[:AUTO_INDENT] = true
 
# Load the readline module.
IRB.conf[:USE_READLINE] = true

def require_ruby_gem(gem_name)
  require gem_name
rescue Gem::LoadError
  puts "Gem #{gem_name} not found (gem install #{gem_name})"
end

# Awesome Print method
require_ruby_gem("awesome_print")
 
# Tab Completion
# Move from irb/completion => bond
if require_ruby_gem 'bond'
  Bond.start
end
 
if require_ruby_gem("wirble")
  # Wirble is a set of enhancements for irb
  # http://pablotron.org/software/wirble/README
  # Implies require 'pp', 'irb/completion', and 'rubygems'
  Wirble.init

  # Enable colored output
  Wirble.colorize
end

if require_ruby_gem("pry")
  Pry.start
  exit
end
