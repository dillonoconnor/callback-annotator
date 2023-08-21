# Traverse the abstract syntax tree (AST)
class AstProcessor < Parser::AST::Processor
  RAILS_CALLBACK_PATTERNS = /^(before|after|around)_(commit|create|destroy|save|rollback|update|validation)$/.freeze
  attr_reader :callbacks

  def initialize
    @callbacks = {}

    super
  end

  def on_send(node)
    _receiver, callback_type, sexp_node = node.children.first(3)
    return super if !sexp_node.is_a?(Parser::AST::Node) || !callback_type.match?(RAILS_CALLBACK_PATTERNS)

    _type, callback_method = sexp_node.deconstruct

    callbacks[callback_type] ||= []
    callbacks[callback_type] << callback_method

    super
  end
end
