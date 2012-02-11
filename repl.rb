# by Russ Olsen
# http://eloquentruby.com

require 'readline'
require 'lithp'
require 'reader'

lisp = Lisp.new

loop do
  line = Readline.readline("> ", true)
  exit if line =~ /^exit$/i
  begin
    s_expression = SExpressionParser.new(line).parse
    p lisp.eval(s_expression)
  rescue Exception => error
    # ANSI escaped red
    puts "\e[31m#{error}\e[0m"
  end
end
