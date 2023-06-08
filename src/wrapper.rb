# make the wrapper around the actual compiled/running script that we made, that simply runs the script with extra steps.

WRAPPER_TEMPLATE = """#!/usr/bin/env ruby

raw_return = `<build_path> \#{ARGV.join(' ')}`

def extract_between_markers(string)
    start_marker = '<<<'
    end_marker = '>>>'

    result = []
    in_marker = false
    buffer = ''

    # be able to also skip a specific number of characters by setting the skip_count upwards.
    skip_count = 0
    string.chars.each_cons(start_marker.length) do |length_char|
        joined_length_char = length_char.join

        if joined_length_char == start_marker
            in_marker = true
            # skip the next length characters, which are the start marker.
            skip_count = 3
        elsif joined_length_char == end_marker
            in_marker = false
        end

        if skip_count > 0
            skip_count -= 1
            next
        end

        if in_marker
            result << length_char[0]
        end
    end

    result.join
end

def clean_string(string)
    return_str = string
    return_str = return_str.strip
    return_str
end

return_value = extract_between_markers(raw_return)
return_value = clean_string(return_value)
return_command = \"echo \'\#{return_value}\'\"

system return_command
"""

def make_wrapper_string(function_name, function_full_dir)
    base = WRAPPER_TEMPLATE
    build_path = File.join(function_full_dir, "build.rb")

    base.gsub!("<function_name>", function_name)
    base.gsub!("<build_path>", build_path)

    base
end
