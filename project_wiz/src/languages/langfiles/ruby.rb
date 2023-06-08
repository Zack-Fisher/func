require_relative '../lang_defines.rb'

def create_lang
    l = Language.new('ruby', '.rb',
        "puts 'Hello, World!'"
    )

    l.set_template_from_file("template.rb")

    return l
end

def custom_pre_build
end

def custom_compile
end

def custom_run
    system("ruby build.rb #{ARGV.join(' ')}")
end

def custom_clean
end
