require "./deny/*"
require "option_parser"

module Deny
  extend self  

  alias InType = String | Char

  @@output   : IO = STDOUT
  @@errput   : IO = STDERR

  @@end_s    : InType = '.'
  @@a_end_s  : InType = '?'
  @@join_s   : InType = ' '
  @@surr     : InType = '"'
  
  @@split    = true
  @@q        = false
  @@test     = false
  @@debug    = false
  @@denyonly = true

  @@denial   = "No"
  @@nothing  = "<Nothing>"

  @@times    = 1
  @@to_print = nil
  @@regex    = /\s+/

  GITHUB_REPO_LINK = "https://github.com/Jens0512/deny"

  def run(args : Array(String), @@output : IO = @@output)
    begin
      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: Deny [opts] [args...]"

        parser.on("-o", "--or", 
          "Or what? Use alternate end instead of end")\
            { @@q = true }

        parser.on("-N", "--deny-nothing",
          "Denies NOTHING when no args are passed")\
            { @@denyonly = false }

        parser.on("-e", "--end", 
          "Specify end (default: '#{@@end_s}'")\
            { |in|; @@end_s = in }

        parser.on("-a", "--alternate-end", 
          "Specify alternate end (-o flag) (default: '#{@@a_end_s}'")\
            { |in|; @@a_end_s = in }

        parser.on("-s SURROUND", "--surround=SURROUND",
          "Sets what to surround the args with (default: #{@@surr})")\
            { |in|; @@surr = in }

        parser.on("-d DENIAL", "--delimeter=DENIAL",
         "Sets how the joined args are denied (default: #{@@denial})")\
            { |in|; @@denial = in }

        parser.on("-j JOIN", "--join=JOIN",
          "Specify what to join the args with (default: '#{@@join_s}')")\
            { |in|; @@join_s = in }

        parser.on("-n NOTHING", "--on-nothing=NOTHING",
          "Specify what to print, when no args are received (default: #{@@nothing})")\
            { |in|; @@nothing = in }

        parser.on("-q", "--question",
          "Do not print anything, only return the exit code for input")\
            { @@test = true }

        parser.on("-t TIMES", "--times TIMES",
          "Prints TIMES times (default: #{@@times})")\
            { |in|; set_times(in) }

        parser.on("-v", "--version",
          "Prints version")\
            { version ? exit : err!("Failed to print version.") } 

        parser.on("--no-split", 
          "Do not split the args, to be joined with JOIN afterwards")\
            { @@split = false}

        parser.on("-r", "--split-regex",
          "Specify the regex used to split the args (default: #{@@regex})")\
            { |in|; set_regex(in) }

        parser.on("--debug", "")\
            { puts "Ran with args #{args}"
            @@debug = true }

        parser.on("-h", "--help", 
          "Show this help")\
            { puts parser; exit }

        parser.unknown_args do |args|
          processed = args
          processed = processed.map(&.split(@@regex)).flatten if @@split
          processed.reject &.empty?

          if processed.empty?
            if @@denyonly
              @@to_print = @@denial
            else
              @@to_print = "#{@@surr}#{@@nothing}#{@@surr} #{@@denial}#{@@q ? @@a_end_s : @@end_s}"
            end
          else
            @@to_print = "#{@@surr}#{processed.join(@@join_s)}#{@@surr} #{@@denial}#{@@q ? @@a_end_s : @@end_s}"
          end
        end
      end      
    rescue e
      err! e
    end

    @@to_print || err! "Deny@@to_print is nil!"

    if @@times < 0
      @@to_print = @@to_print.not_nil!.reverse 
    end

    unless @@test 
      @@times.times do
        @@output.puts @@to_print
      end
    end
  end

  def set_times(times)
    if t = times.to_i?
      @@times = t
    else
      fail! %["#{times}" is not a valid amount of times (number)] 
    end
  end

  def set_regex(regex : String)
    @@regex = Regex.new regex
    debug_puts "Regex set to #{@@regex}"
  end

  def debug_puts(msg)
    @@output.puts msg if @@debug
  end

  def version
    @@output.puts "Deny v#{VERSION}"
  end

  def fail!(message, exit_status = 1)
    debug_puts "Program failed!"
    @@errput.puts message unless @@test
    exit exit_status
  end

  def err!(message = nil)
    mem = IO::Memory.new
    mem << message if message
    mem << "You have found a error! The dev sucks. Please open an issue here: #{GITHUB_REPO_LINK}/issues/new, including steps to reproduce"
    fail! mem, 2
  end  
end
