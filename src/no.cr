require "./no/*"
require "option_parser"

q? = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: No [opts] [args]"
  parser.on("-?", "--or", "Or what?") { q? = true }
  parser.on("-h", "--help", "Show this help") { puts parser }

  parser.unknown_args do |args|
    puts %("#{args.join(" ")}" No#{q? ? "?" : ""})
  end
end

