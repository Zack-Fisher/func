require_relative '../defines.rb'
require_relative 'lang_parser.rb'

def return_language_array
    return get_languages()
end

def return_language_name_array
    return_language_array().map { |lang| lang.name }
end

def find_language_object(name)
    return_language_array().each do |lang|
        if lang == nil
            next
        end

        if lang.name == name
            return lang
        end
    end
    return nil
end
