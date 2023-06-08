#!/bin/env ruby

require 'fileutils'

require_relative 'add.rb'
require_relative 'build.rb'
require_relative 'defines.rb'

def init
    # make sure all the stuff exists.
    FileUtils.mkdir_p(FUNCTION_DIR)
    FileUtils.mkdir_p(INSTALL_PATH)

    puts "Make sure that #{INSTALL_PATH} is in your PATH, or else you won't be able to use functions from BASH."
end

def help
    puts "Usage: ./main.rb [add <language> <function_name>] [build <function_name>] [help]"
end

def main
    if ARGV.any? { |arg| ["help", "-h", "--help"].include?(arg) }
        help
        exit
    end

    init

    if ARGV.include?("add")
        # add a function with the specified language and function name.
        _, language, fn_name = ARGV

        if language == nil
            puts "Please specify a language."
            exit
        end

        if fn_name == nil
            puts "Please specify a function name."
            exit
        end

        add(language, fn_name)
    end

    # function source is included with the bundle, so the user can see the source and build off it, or just use it as is.
    if ARGV.include?("build")
        # build the function with the specified name.
        _, fn_name = ARGV

        if fn_name == nil
            puts "Please specify a function name."
            exit
        end

        build(fn_name)
    end
end

main
