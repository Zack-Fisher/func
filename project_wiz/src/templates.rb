require_relative 'defines.rb'

#### define static templates.
# templating for the inserted build.rb file into the project.
BUILD_TEMPLATE = """#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# generated build.rb file.
# -----------------------------------------------------------------------------

require 'bash_help'

# -----------------------------------------------------------------------------

def redirect_stderr_to_null
    # Open /dev/null to redirect stderr
    dummy_file = File.open('/dev/null', 'w')
    # Save the original stderr for later restoration
    original_stderr = $stderr
    # Redirect stderr to the dummy file
    $stderr.reopen(dummy_file)

    # Execute the block
    yield

    # Restore stderr to its original state
    $stderr.reopen(original_stderr)
    # Close the dummy file
    dummy_file.close
end

"""

RUN_TEMPLATE = """#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# generated run.rb file.
# -----------------------------------------------------------------------------

require 'bash_help'

# -----------------------------------------------------------------------------

# normalize the pwd so that the script installs actually work.
Dir.chdir(__dir__)

# this spawns in the ruby pwd.
system(\"./build.rb nobuild noclean #{ARGSTRING}\")

"""


### defines for the install.rb file
INSTALL_TEMPLATE = """#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# generated install.rb file. installs the run.rb file as a command. 
# by default, it installs to /usr/local/bin.
# can also override this path with the first argument.
# -----------------------------------------------------------------------------

require 'bash_help'

# -----------------------------------------------------------------------------

install_path = '/usr/local/bin'

if ARGV.length == 1
    install_path = ARGV[0]
end

# as a base, just run the build.rb file as the script for the actual program.
# every program will have a thin ruby wrapper like this.
system(\"sudo ln -s $(realpath build.rb) \#{install_path}\")
"""

### and then , the functions that dictate how they're programmatically formatted.
def make_build_string(lang_obj, project_name)
    starter = BUILD_TEMPLATE

    starter += "EXTENSION = '#{lang_obj.extension}'\n"
    starter += "PROJECT_NAME = '#{project_name}'\n"
    starter += "PROJECT_DIRECTORY = '#{$project_directory}'\n"

    starter += "\n"
    starter += "\n"

    starter += "

Dir.chdir(__dir__)

# by default, build then clean the project.

## not doing right now, optionally #unless ARGV.include?('noclean')# and etc

puts 'Building #{project_name}...'\n
# redirect clean stderr to null, it can be annoying and noisy.
#{lang_obj.compile_string}

puts 'Running #{project_name}...'\n

line

#{lang_obj.run_string}

line

puts 'Cleaning #{project_name}...'\n

redirect_stderr_to_null do
    #{lang_obj.clean_string}
end

    "
end

def make_install_string(language, project_name)
    INSTALL_TEMPLATE.gsub('<file>', project_name)
end
