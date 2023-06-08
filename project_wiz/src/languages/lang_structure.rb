## DEFINE THE STRUCTURE AND BASIC TEMPLATING OF A LANGFILE HERE.

# all the data that the formatting needs.
# non language-specific data, don't impose this stuff directly on the Language object.
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
    attr_reader :name, :extension, :template, :compile_string, :run_string, :clean_string, :pre_build_string

    def initialize(name, extension, template = "", compile_string = "", run_string = "", clean_string = "", pre_build_string = "")
        @name = name
        @extension = extension
        @template = template
        @compile_string = compile_string
        @run_string = run_string
        @clean_string = clean_string
        @pre_build_string = pre_build_string
        return self
    end

    # place all the weird template formatting in this function.
    def format_str(string, format_structure)
        formatted_string = string
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
    def format_hook(string, format_structure, is_function)
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

        if is_function
            # trim the function sig
            lines = string.lines
            lines.shift
            lines.pop

            string = lines.join

            # clean up the weird tabs and spaces errors we might get in the scripts.
            string = normalize_indentation(string)
        end

        # place all of the usual formatting onto the string.
        string = format_str(string, format_structure)

        return string
    end

    ## setters for the lang hooks.
    def set_hook_string(which_hook, string, format_structure, is_function = false)
        string = format_hook(string, format_structure, is_function)
        # set the method with a message call at runtime.
        send("#{which_hook}=", string)
        return self
    end
end
