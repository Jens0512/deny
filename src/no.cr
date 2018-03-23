require "./no/*"
require "option_parser"

class No
  @@to_print = nil
  @@q?       = false
  @@surr     = '"'
  @@denial   = "No"
  @@end_s    = '.'
  @@a_end_s  = '?'
  @@join_s   = ' '
  @@test     = false
  @@times    = 1
  @@nothing  = "<Nothing>"
  @@split?   = true
  @@regex    = /\s+/

  def self.run(io : IO)

  end

  def self.run(args : Array(String))
    begin
      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: No [opts] [args...]"

        parser.on("-o", "--or", "Or what? Use alternate end instead of end") { @@q? = true }
        parser.on("-e", "--end", "Specify end (default: '#{end_s}'") { |in|; @@end_s = in }
        parser.on("-a", "--alternate-end", "Specify alternate end (-o flag) (default: '#{a_end_s}'") { |in|; @@a_end_s = in }
        parser.on("-s SURROUND", "--surround=SURROUND", "Sets what to surround the args with (default: #{surr})") { |in|; @@surr = in }
        parser.on("-d DENIAL", "--delimeter=DENIAL", "Sets how the joined args are denied (default: #{denial})") { |in|; @@denial = in }
        parser.on("-j JOIN", "--join=JOIN", "Specify what to join the args with (default: '#{join_s}')") { |in|; @@join_s = in }
        parser.on("-n NOTHING", "--on-nothing=NOTHING", "Specify what to print, when no args are received (default: #{nothing})") { |in|; @@nothing = in }
        parser.on("-q", "--question", "Do not print anything, only return the exit code for input") { @@test = true }
        parser.on("-t TIMES", "--times TIMES", "Prints TIMES times (default: #{@@times})")  { |in|; self.set_times(in) }
        parser.on("-v", "--version", "Prints version") { self.version }
        parser.on("--no-split", "Do not split the args, to be joined with JOIN afterwards") { @@split? = false}
        parser.on("-r", "--split-regex", "Specify the regex in which to \
          decide how to split the args to afterwards be joined (default: #{@@regex})") { |in|; self.set_regex(in) }

        parser.on("-h", "--help", "Show this help") { puts parser; exit }

        parser.unknown_args do |args|
          processed = args
          processed.map!(&.split(@@regex)) if @@split?
          to_print = %[#{@@surr}#{args.empty? ? @@nothing : processed.join(@@join_s)}#{@@surr} #{@@denial}#{@@q? ? @@a_end_s : @@end_s}]
        end
      end
    rescue
      exit 1
    end

    to_print || exit 1

    @@times.times { print to_print } unless @@test 
  end

  def self.set_times(times)
    if t = times.to_i?
      @@times = t.abs
    else
      STDERR.puts %["#{times}" is not a valid amount of times (number)]
      exit 1
    end
  end

  def self.set_regex(regex : String)
    @@regex = Regex.new regex
  end

  def self.version
    puts "No v#{VERSION}"
    exit 0
  end
end

No.run ARGV ARGF.read.split /\s+/