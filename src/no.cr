require "./no/*"
require "option_parser"

to_print = nil
q?       = false
surr     = '"'
denial   = "No"
end_s    = '.'
a_end_s  = '?'
join_s   = ' ' 
test     = false
nothing  = "<Nothing>"

begin
  OptionParser.parse(args) do |parser|
    parser.banner = "Usage: No [opts] [args...]"

    parser.on("-o", "--or", "Or what? Use alternate end instead of end") { q? = true }
    parser.on("-e", "--end", "Specify end (default: '#{end_s}'") { |in|; end_s = in }
    parser.on("-a", "--alternate-end", "Specify alternate end (-o flag) (default: '#{a_end_s}'") { |in|; a_end_s = in }
    parser.on("-s SURROUND", "--surround=SURROUND", "Sets what to surround the args with (default: #{surr})") { |in|; surr = in }
    parser.on("-d DENIAL", "--delimeter=DENIAL", "Sets how the joined args are denied (default: #{denial})") { |in|; denial = in }
    parser.on("-j JOIN", "--join=JOIN", "Specify what to join the args with (default: '#{join_s}')") { |in|; join_s = in }
    parser.on("-n NOTHING", "--on-nothing=NOTHING", "Specify what to print, when no args are received (default: #{nothing})") { |in|; nothing = in }
    parser.on("-q", "--question", "Do not print anything, only return the exit code for input") { test = true }

    parser.on("-h", "--help", "Show this help") { puts parser; exit }

    parser.unknown_args do |args|
      to_print = %[#{surr}#{args.empty? ? nothing : (args.join(join_s))}#{surr} #{denial}#{q? ? a_end_s : end_s}]
    end
  end
rescue
  exit 1
end

to_print || exit 1

print to_print unless test