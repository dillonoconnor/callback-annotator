module Callbacks
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def before_save(_method); end
    def after_save(_method); end
    def around_save(_method); end

    # Non-Rails callback
    def after_transition(_method); end
  end
end
