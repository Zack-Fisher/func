#!/usr/bin/env ruby
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

EXTENSION = '.rb'
PROJECT_NAME = 'func'
PROJECT_DIRECTORY = '/home/zack/Documents/ruby/func'
FILE_PATH = '/home/zack/Documents/ruby/func/src/func.rb'
BUILD_FILE_PATH = '/home/zack/Documents/ruby/func/build.rb'




Dir.chdir(__dir__)

# by default, build then clean the project.

## not doing right now, optionally #unless ARGV.include?('noclean')# and etc

puts 'Building func...'

# redirect clean stderr to null, it can be annoying and noisy.


puts 'Running func...'


line

safe_system('ruby src/func.rb #{ARGV.join(' ')}')

line

puts 'Cleaning func...'


redirect_stderr_to_null do
    
end

    