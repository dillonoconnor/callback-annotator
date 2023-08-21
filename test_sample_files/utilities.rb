require_relative "callbacks"

# Dummy module
module Utilities
  include Callbacks

  around_save :fixup

  def fixup; end
end
