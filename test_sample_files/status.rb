require_relative "active_record"
require_relative "utilities"

# Dummy class
class Status < ActiveRecord::Base
  include Utilities

  before_save :method_one
  after_save :method_two
  after_transition :method_three

  def method_one; end

  def method_two; end

  def method_three; end
end
