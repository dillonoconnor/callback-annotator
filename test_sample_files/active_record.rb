require_relative "callbacks"

module ActiveRecord
  class Base
    include Callbacks
  end
end
