class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def unblank?
    !blank?
  end
end
