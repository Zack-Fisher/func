require_relative 'defines.rb'

# just use the main function from the project_wiz program to create the actual generic templating for functions 
# in various languages.
require_relative '../project_wiz/src/main.rb'

require_relative 'wrapper.rb'

# the file that installs the wrapper.rb wrapper around the function.
FUNC_INSTALL_TEMPLATE = """#!/usr/bin/env ruby
require 'bash_help'

def run
    # install the wrapper around the function.
    system('sudo ln -s <wrapper_path> #{INSTALL_PATH}/<function_name>')
end

run
"""

def make_func_install_string(function_name, function_full_dir)
    base_template = FUNC_INSTALL_TEMPLATE
    full_path = File.join(function_full_dir, "wrapper.rb")

    base_template.gsub!("<function_name>", function_name)
    base_template.gsub!("<wrapper_path>", full_path)

    puts base_template

    base_template
end

# they'll be implicitly sorted by languages based on the program.
def add(language, fn_name)
    puts "FUNCTION_DIR: #{FUNCTION_DIR}"
    puts "INSTALL_PATH: #{INSTALL_PATH}"

    # add a function with the specified language and function name.
    puts "Adding function #{fn_name} in language #{language}."

    # control the editor it opens in with the $EDITOR environment variable.
    project_dir = project_wizard(language, fn_name, FUNCTION_DIR)   

    puts project_dir

    puts "Installing the function wrapper..."
    File.open("#{project_dir}/wrapper.rb", "w") do |f|
        f.write(make_wrapper_string(fn_name, project_dir))
    end

    puts "Installing the function install script..."
    File.open("#{project_dir}/func_install.rb", "w") do |f|
        f.write(make_func_install_string(fn_name, project_dir))
    end
    puts "Done."

    puts "Making both executable..."
    system "chmod +x #{project_dir}/wrapper.rb"
    system "chmod +x #{project_dir}/func_install.rb"

    puts "Running the function install script..."
    Dir.chdir(project_dir) do
        system "./func_install.rb"
    end
    puts "Done."

    puts "Opening the project directory in your $EDITOR..."
    exec "$EDITOR #{project_dir}"
end
