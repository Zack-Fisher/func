## DEFINE THE STRUCTURE AND BASIC TEMPLATING OF A LANGFILE HERE.

# the template can either be a folder full of stuff or a simple string.
# all folderpaths will be taken relative to the templating dir.
class Template
  attr_reader :is_folder, :template_string

  def initialize
    @is_folder = false
    @template_string = ""
  end

  def self.from_folder(folder)
    instance = new
    @is_folder = true
  end

  def self.from_doc(text)
    @template_string = text
  end
end

# all the data that the formatting needs.
# non language-specific data, don't impose this stuff directly on the Language object.
# this is passed through upon GETTING the Language hook strings.
class FormatStructure
    attr_reader :project_name, :source_dir, :full_name

    def initialize(project_name, source_dir, full_name)
        @project_name = project_name
        @source_dir = source_dir
        @full_name = full_name
        return self
    end
end


####
## TEMPLATING:
## <project_name> - the project name, the one without extensions.
## <source_dir> - the source directory. usually src.
## <full_name> - <source_dir>/<project_name>
####

# the language structures are completely decoupled from the actual project creation filepaths.
class Language 
    attr_reader :name, :extension
    # need to expose these so that the set_hook method can call them with send()?
    attr_accessor :template, :compile, :run, :clean, :pre_build

    # only thing that's necessary is the language template.
    # pass in a Template object, not just a string. these can be folderpaths, too.
    def initialize(name, extension, template, compile = "", run = "", clean = "", pre_build = "")
        @name = name
        @extension = extension
        @template = template
        @compile = compile
        @run = run
        @clean = clean
        @pre_build = pre_build
        return self
    end

    # place all the weird template formatting in this function.
    def format_str(string, format_structure)
        formatted_string = string

        # replace all the template strings with the actual values.
        formatted_string.gsub!("<project_name>", format_structure.project_name)
        formatted_string.gsub!("<source_dir>", format_structure.source_dir)
        formatted_string.gsub!("<full_name>", format_structure.full_name)

        return formatted_string
    end


    def set_template(template, format_structure)
        @template = format_str(string, format_structure)
        puts @template
        puts "CHANGED TEMPLATE"
        return self
    end

    # pass the template name inside the the templates directory, and it'll grab it for you and dump it inside of templates.
    def set_template_from_file(template_name)
        set_template(File.read(File.expand_path(File.join(File.dirname(__FILE__), 'templating', template_name))))
        return self
    end


    # make the hook a proper string.
    # is_function is a boolean that determines whether or not the hook is a function hook or just a simple string arg.
    # formats differently depending on whether or not it's a function.
    def format_hook(string, format_structure)
        # tab the code in one.
        def normalize_indentation(code_string)
            # Split the code into lines
            lines = code_string.split("\n")

            # Detect the minimum indentation
            min_indent = lines.reject { |line| line.strip.empty? }
                                .map { |line| line.index(/\S/) }
                                .compact
                                .min

            # Remove the minimum indentation from the beginning of each line
            lines.map! { |line| line.gsub(/^#{' ' * min_indent}/, '') }

            # Join the lines back together into a single string
            normalized_code_string = lines.join("\n")

            normalized_code_string
        end

        # place all of the usual formatting onto the string.
        string = format_str(string, format_structure)

        return string
    end

    # setter for any lang hook.
    def set_hook(which_hook, string)
        send("#{which_hook}=", string)
        return self
    end

    # getter for any lang hook.
    # pass in the structure to format it properly, and get back the right code.
    # the data for the formatter is decided by the caller, this class should only be concerned with formatting.
    def get_hook(which_hook, format_structure)
        return format_hook(send(which_hook), format_structure)
    end
end
