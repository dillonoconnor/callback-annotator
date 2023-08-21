require_relative "../lib/callback_annotator"
require_relative "../ast_samples/status_ast"
require_relative "../test_sample_files/status"

RSpec.describe CallbackAnnotator do
  it "has a version number" do
    expect(CallbackAnnotator::VERSION).not_to be nil
  end

  describe "#process_ast" do
    it "returns all expected Rails callbacks from a given file/ast" do
      callbacks = [
        { callback_type: :before_save, callback_method: :method_one },
        { callback_type: :after_save, callback_method: :method_two }
      ]

      expect(Annotator.new(Status).send(:process_ast, STATUS_AST)).to eq(callbacks)
    end
  end
end
