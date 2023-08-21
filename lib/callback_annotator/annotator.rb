# Class for annotation of models with all relevant Rails callbacks.
class Annotator
  attr_reader :klass, :arb_modules

  def initialize(klass)
    @klass = klass
    @arb_modules = ActiveRecord::Base.included_modules

    raise StandardError, "class must be a model" unless model?
  end

  def list_modules(initial_run: true, modules: [])
    if initial_run
      level_one_modules = klass.included_modules.unshift(klass) - arb_modules
      return list_modules(initial_run: false, modules: level_one_modules)
    end

    return modules if modules.empty?

    next_level_modules = modules.map(&:included_modules).reject!(&:empty?).flatten - [*arb_modules, *modules]
    modules + list_modules(initial_run: false, modules: next_level_modules)
  end

  def list_callbacks
    list_modules.reduce({}) do |acc, mod|
      module_name = mod&.name
      next acc unless module_name

      module_callbacks = parse_ast(module_name)

      module_callbacks.each do |callback_type, callback_methods|
        acc[callback_type] ||= []

        acc[callback_type] << { methods: callback_methods, via: module_name }
      end

      acc
    end
  end

  def write_to_file
    callbacks = list_callbacks
    path = file_path(klass.name)

    file_content = File.read(path)
    lines = file_content.lines
    class_line = lines.find_index { |line| line.include?("class #{klass.name}") }

    comment = ["  # === Rails Callbacks (generated by CallbackAnnotator) ==="]

    callbacks.each do |type, hooks|
      methods = hooks.map { |cb| "- #{cb[:methods].map { |meth| "#{meth} via #{cb[:via]}" }.join("\n  #  - ")}" }.join("\n  #  ")
      comment << "  # #{type}:\n  #  #{methods}"
    end

    lines.insert(class_line + 1, comment.push("  # #{'=' * 56}").join("\n") + "\n\n")

    File.open(path, 'w') do |file|
      file.write(lines.join)
    end
  end

  private

  def model?
    klass.superclass == ActiveRecord::Base
  end

  def file_path(class_or_module_name)
    Object.const_source_location(class_or_module_name).first
  end

  def parse_ast(module_name)
    path = file_path(module_name)
    return [] unless path

    file = File.read(path)
    ast = Parser::CurrentRuby.parse(file)
    process_ast(ast)
  end

  def process_ast(ast)
    processor = AstProcessor.new
    processor.process(ast)
    processor.callbacks
  end
end