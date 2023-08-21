require "parser/current"

rel_path = File.join(__dir__, "..", "test_sample_files", "status.rb")
file = File.read(rel_path)

STATUS_AST = Parser::CurrentRuby.parse(file)
