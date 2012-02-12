# by Russ Olsen
# http://eloquentruby.com

require 'readline'
require 'lithp'
require 'reader'

# Exit gracefully with ctrl-c
stty_save = `stty -g`.chomp
trap('INT') { system('stty', stty_save); exit }
lisp = Lisp.new

loop do
  line = Readline.readline("> ", true)
  exit if line =~ /^exit$/i
  begin
    s_expression = SExpressionParser.new(line).parse
    p lisp.eval(s_expression)
  rescue => error
    # ANSI escaped red
    print "\e[31m"
    puts "on #{error.backtrace.pop}: #{error.message}"
    puts error.backtrace.map { |line| "\tfrom:#{line} " }
    # Clear ANSI escapes
    print "\e[0m"
  end
end
