require 'method_source'
require_relative 'simple_defines.rb'

def with_source(method_label, lang_path, &block)
    begin
        # the with_source block will be called only if the method exists.
        # otherwise we just ignore the error and skip the block no problem.
        # just use method source mostly to check for the existence of a method, should be fine. don't rely on this heavily.
        source_code = method(method_label).source
        yield(source_code)
    rescue StandardError => e
        puts "label :#{method_label} not found, skipping langfile... (#{lang_path}) \n"
    end
end

# must be passed an absolute path to the file.
# we do a scoped load with the load function, NOT the require_relative function. that doesn't work here.
# we want the methods themselves to go out of scope after we're done with them in the loop.
def define_lang_from_file(lang_path)
    ## load AND include all the modules from the file.
    require_relative lang_path

    # Load the file as a string
    file_content = File.read(lang_path)

    # Scan for module definitions
    module_names = file_content.scan(/module\s+(\w+)/).flatten

    # Include each module dynamically
    module_names.each do |module_name|
        module_object = Object.const_get(module_name)
        include module_object
    end


    lang = nil

    with_source(:create_lang, lang_path) do |source_code|
        # they're in scope, we can call the methods directly without an eval.
        lang = create_lang
    end

    with_source(:custom_pre_build, lang_path) do |source_code|
        lang.set_pre_build_string(source_code, true)
    end

    with_source(:custom_compile, lang_path) do |source_code|
        lang.set_compile_string(source_code, true)
    end

    with_source(:custom_run, lang_path) do |source_code|
        lang.set_run_string(source_code, true)
    end

    with_source(:custom_clean, lang_path) do |source_code|
        lang.set_clean_string("clean_string", source_code, true)
    end

    # if lang is nil, handle in the caller.
    return lang
end

# should return an array of the language objects that represent all the programming languages available to the user.
# iterates through all the .rb files in the ./langfiles directory and calls the methods from them to construct them. see above.
def get_languages()
    puts "Getting languages..."
    # if we've already cached the languages on THIS run of the program, just return them.
    if $cached_languages != nil
        puts "Already done, returning cached languages..."
        return $cached_languages
    end

    # Get the current directory of the script
    current_directory = File.join(File.dirname(__FILE__), 'langfiles')

    languages = []

    # # Iterate over each file in the directory
    # Dir.foreach(current_directory) do |filename|
    #     next if filename == '.' || filename == '..'

    #     # Construct the full path to the file
    #     file_path = File.join(current_directory, filename)

    #     l = define_lang_from_file(file_path)
    #     if l != nil
    #         languages.append(l)
    #     end
    # end

    $cached_languages = SIMPLE_LANG_DEFINES + languages
    return $cached_languages
end
