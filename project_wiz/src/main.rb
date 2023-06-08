#!/usr/bin/env ruby
require 'fileutils'

require 'bash_help'

require_relative 'languages/languages.rb'
require_relative 'templates.rb'

IS_STANDALONE = __FILE__ == $0

# exit with a wrapper, don't just quit out if we're being used as a library.
def die(msg, code=1)
    if IS_STANDALONE
        puts msg
        exit code
    else
        raise msg
    end
end

def project_wizard(language, project_name, base_directory=File.join(ENV['HOME'], 'Documents'))
    lang_obj = find_language_object(language)

    # if we can't find the language, then we can't continue.
    if (lang_obj == nil)
        puts "Unsupported language: #{language}"
        puts "#{return_language_name_array()}"
        puts "Supported languages: #{return_language_name_array().join(', ')}"
        die("Supported languages: #{return_language_name_array().join(', ')}")
    end


    $project_directory=File.join(base_directory, language, project_name)

    source_directory=File.join($project_directory, 'src')
    file_path=File.join(source_directory, project_name + lang_obj.extension)
    build_file_path=File.join($project_directory, 'build.rb')
    run_file_path=File.join($project_directory, 'run.rb')
    install_file_path=File.join($project_directory, 'install.rb')


    line
    ## make the source directory
    # make sure the language directory exists.
    FileUtils.mkdir_p(source_directory)
    File.open(file_path, 'w') do |f|
        f.write(lang_obj.template)
    end

    puts "Created #{file_path}"

    # just in case.
    system "chmod +x #{file_path}"

    puts "Created #{language} project: #{project_name}"

    line

    puts "Creating build.rb file..."
    File.open(build_file_path, 'w') do |f|
        f.write(make_build_string(lang_obj, project_name))
    end
    puts "Created build.rb file."

    line

    puts "Creating run.rb file..."
    File.open(run_file_path, 'w') do |f|
        f.write(RUN_TEMPLATE)
    end
    puts "Created run.rb file."

    line

    puts "Creating install.rb file..."
    File.open(install_file_path, 'w') do |f|
        f.write(make_install_string(language, project_name))
    end
    puts "Created install.rb file."

    line

    puts "Making build.rb executable..."
    # make the ruby script executable.
    system "chmod +x #{build_file_path}"
    puts "Made build.rb executable."

    puts "Making run.rb executable..."
    system "chmod +x #{run_file_path}"
    puts "Made run.rb executable."

    puts "Making install.rb executable..."
    system "chmod +x #{File.join($project_directory, 'install.rb')}"
    puts "Made install.rb executable."

    puts "Opening #{$project_directory} in VSCode..."
    line

    return $project_directory
end

# optionally run this standalone as a commandline script.
# or use the main function as a library include.
if IS_STANDALONE
    language, project_name = ARGV
    project_wizard(language, project_name)

    # only standalone automatically opens the project in the editor.
    system "#{ENV["EDITOR"]} #{$project_directory}"
end
