require_relative 'defines.rb'

#### define static templates.
# templating for the inserted build.rb file into the project.

def make_run_string(lang_obj, format_struct)
  return "#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# generated run.rb file.
# -----------------------------------------------------------------------------

require 'bash_help'

# -----------------------------------------------------------------------------

# normalize the pwd so that the script installs actually work.
Dir.chdir(__dir__)

# this spawns in the ruby pwd.
system(\"./build.rb nobuild noclean #{ARGSTRING}\")
  "
end

### and then , the functions that dictate how they're programmatically formatted.
def make_build_string(lang_obj, format_struct)
  return "#!/usr/bin/env ruby
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

Dir.chdir(__dir__)

#{lang_obj.get_hook('pre_build', format_struct)}

# by default, build then clean the project.
## not doing right now, optionally #unless ARGV.include?('noclean')# and etc

puts 'Building #{format_struct.project_name}...'\n
# redirect clean stderr to null, it can be annoying and noisy.
#{lang_obj.get_hook('compile', format_struct)}

puts 'Running #{format_struct.project_name}...'\n

line

#{lang_obj.get_hook('run', format_struct)}

line

puts 'Cleaning #{format_struct.project_name}...'\n

redirect_stderr_to_null do
    #{lang_obj.get_hook('clean', format_struct)}
end
  "
end

def make_install_string(lang_obj, format_struct)
  return "#!/usr/bin/env ruby
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
  "
end
