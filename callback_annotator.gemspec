require_relative 'lib/callback_annotator/version'

Gem::Specification.new do |spec|
  spec.name          = "callback_annotator"
  spec.version       = CallbackAnnotator::VERSION
  spec.authors       = ["Dillon O'Connor"]
  spec.email         = ["dillon@pingboard.com"]

  spec.summary       = "Annotate models with Rails callbacks from all included modules" 
  spec.description   = "Consolidate callbacks from multiple files into model comments"
  spec.homepage      = "https://www.github.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com"
  spec.metadata["changelog_uri"] = "https://www.github.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
