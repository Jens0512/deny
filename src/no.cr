require "./no/*"
require "option_parser"

q? = false
surr = '"'
denial = "No"

OptionParser.parse! do |parser|
  parser.banner = "Usage: No [opts] [args...]"

  parser.on("-o", "--or", "Or what? Appends '?' to the output") { q? = true }
  parser.on("-s SURROUND", "--surround=SURROUND", "Sets what to surround the args with (default: #{surr})") { |in|; surr = in }
  parser.on("-d DENIAL", "--delimeter=DENIAL", "Sets how the joined args are denied (default: #{denial})") { |in|; denial = in }
  parser.on("-h", "--help", "Show this help") { puts parser; exit }

  parser.unknown_args do |args|
    puts %[#{surr}#{args.empty? ? %(<nothing>) : (args.join(' '))}#{surr} #{denial}#{q? ? '?' : '.'}]
  end
end

