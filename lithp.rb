# by Fogus
# http://joyofclojure.com

require 'helper'

class Lisp
  def initialize
    @env = { 
      :label => lambda { |(name,val), _| @env[name] = val },
      :quote => lambda { |sexpr, _| sexpr[0] },
      :car   => lambda { |(list), _| list[0] },
      :cdr   => lambda { |(list), _| list.drop 1 },
      :"+"   => lambda { |list, _| list.inject(:"+") },
      :"-"   => lambda { |list, _| list.inject(:"-") },
      :"*"   => lambda { |list, _| list.inject(:"*") },
      :"/"   => lambda { |list, _| list.inject(:"/") },
      :cons  => lambda { |(e,cell), _| [e] + cell },
      :eq    => lambda { |(l,r), _| l == r },
      # do any menbers of list respond true to blank?
      :blank => lambda { |(list), ctx| Array[list].map { |item| eval(item, ctx).blank? }.include?(true) },
      :if    => lambda { |(cond, thn, els), ctx|
        # is cond unblank?
        if eval(cond, ctx).unblank?
          # does the thn clause exist? then evalute thn.
          thn ? eval(thn, ctx) : true
          # return true if thn doesn't exist
          # example: (if (eq 1 1)) evaluates to true
        else
          # does the els clause exist? then evalute els.
          els ? eval(els, ctx) : false
          # return true if els doesn't exist
          # example: (if (eq 1 2)) evaluates to false
        end
      },
      :atom  => lambda { |(sexpr), _| (sexpr.is_a? Symbol) or (sexpr.is_a? Numeric) },
      :env   => lambda { |_, __| @env.keys }
    }
  end

  def apply fn, args, ctx=@env
    return @env[fn].call(args, ctx) if @env[fn].respond_to? :call
    self.eval @env[fn][2], Hash[*(@env[fn][1].zip args).flatten(1)]
  end

  def eval sexpr, ctx=@env
    return if sexpr.blank?

    if @env[:atom].call [sexpr], ctx
      return ctx[sexpr] if ctx[sexpr]
      return sexpr
    end

    fn = sexpr[0]
    args = (sexpr.drop 1)
    args = args.map { |a| self.eval(a, ctx) } if not [:quote, :if].member? fn
    apply(fn, args, ctx)
  end
end

