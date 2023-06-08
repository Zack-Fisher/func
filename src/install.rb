# install all of the functions on the system.

require_relative 'defines.rb'

def install
  # go through all of the folders two layers deep in the function directory.
  Dir.glob("#{FUNCTION_DIR}/*/*") do |fn|
    begin
      Dir.chdir(fn) do
        # if the function has a install.rb file, run it.
        if File.exists?("install.rb")
          system("ruby install.rb")
        end
      end
    rescue
      # if the function doesn't have a install.rb file, just skip it.
    end
  end
end
