require "./no/*"
require "option_parser"

q? = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: No [opts] [args...]"
  parser.on("-o", "--or", "Or what?") { q? = true }
  parser.on("-h", "--help", "Show this help") { puts parser; exit }

  parser.unknown_args do |args|
    puts %["#{args.empty? ? "<nothing>" : (args.join(" "))}" No#{q? ? "?" : "."}]
  end
end

