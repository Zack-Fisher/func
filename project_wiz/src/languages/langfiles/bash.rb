### EXAMPLE LANGUAGE FILE ###

# include to get an idea of all the variables you can reference from the file.
require_relative '../lang_defines.rb'

## constructor.
# this is special. we use the return directly in the build script for initialization.
def create_lang
    l = Language.new('bash', '.sh',
        "echo 'Hello, World!'"
    )

    return l
end


## build hooks.
# these are called programmatically from the attached build script to the object. 
# the source itself is baked in.
# these are appended in a certain place on top of the preexisting global build scripts for every project.
# add a place for arbitrary data, so we never have to change the function sig.

# the hooks are DUMPED into the build script, so we can pass in normalized lists of constants from the build script, referencing them here.
def custom_pre_build
end

def custom_compile
end

def custom_run
    system("bash build.sh #{ARGV.join(' ')}")
end

def custom_clean
end
