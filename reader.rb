# by Russ Olsen
# http://eloquentruby.com

class SExpressionParser
  def initialize(expression)
    function_names = '[\w\+\-\*\/]+'
    @tokens = expression.scan /[()]|#{function_names}|".*?"|'.*?'/
  end

  def peek
    @tokens.first
  end

  def next_token
    @tokens.shift
  end

  def parse
    if (token = next_token) == '('
      parse_list
    elsif token =~ /['"].+/
      token[1..-2]
    elsif token =~ /\d+/
      token.to_i
    else
      if token.respond_to?(:to_sym)
        token.to_sym
      else
        nil
      end
    end
  end

  def parse_list
    list = []
    list << parse until peek == ')'
    next_token
    list
  end
end
