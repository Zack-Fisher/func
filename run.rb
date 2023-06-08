#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# generated run.rb file.
# -----------------------------------------------------------------------------

require 'bash_help'

# -----------------------------------------------------------------------------

# normalize the pwd so that the script installs actually work.
Dir.chdir(__dir__)

# this spawns in the ruby pwd.
system("./build.rb nobuild noclean #{ARGV.join(' ')}")

