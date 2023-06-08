require_relative 'lang_structure.rb'

# can optionally define langs here instead of in their own files, if all the stuff is really small and it's not warranted.
# this will be appended onto all the defs from the langfiles dir.
SIMPLE_LANG_DEFINES = [
    Language.new('python', '.py', 
                 # use heredoc to inline stuff, optionally.
                 Template.from_doc(
                 <<-PYTHON
print("Hello, World!")
PYTHON
                 )
    )
        # set all the hooks for running and compiling the program.
        # these will be automatically injected into the project at the right places.
        .set_hook(
          "run",
          "system(\"python3 <full_name> #{ARGSTRING}\")"
        ),

#     Language.new('javascript', '.js',
#         "console.log('Hello, World!');"
#     )
#         .set_run_string("system(\"node <full_name>.js #{ARGSTRING}\")"),

#     Language.new('java', '.java', 
#     "
# public class <project_name> {
#     public static void main(String[] args) {
#         System.out.println(\"Hello, World!\");
#     }
# }
#     ")
#         .set_compile_string("system('javac ./src/*.java')")
#         # have to run java really weird.
#         .set_run_string("system(\"java -classpath <source_dir> <project_name> #{ARGSTRING}\")")
#         .set_clean_string("system('rm -rf <source_dir>/*.class')"),

#     Language.new('c', '.c', """
# int main() {
#     printf('Hello, World!\\n');
#     return 0;
# }
#     """)
#         .set_compile_string("gcc_compile '<full_name>.c' '<full_name>'")
#         .set_run_string("system(\"./<full_name> #{ARGSTRING}\")"),

#     Language.new('cpp', '.cpp', """
# #include <iostream>
# int main() {
#     std::cout << 'Hello, World!' << std::endl;
#     return 0;
# }
#     """)
#         .set_compile_string("system(\"g++ -o <full_name> <full_name>.cpp')")
#         .set_run_string("system(\"./<full_name> #{ARGSTRING}\")"),

#     Language.new('csharp', '.cs', """
# using System;

# class Program {
#     public static void Main() {
#         Console.WriteLine('Hello, World!');
#     }
# }   
#     """)
#         .set_compile_string("system(\"mcs <full_name>.cs\")")
#         .set_run_string("system(\"mono <full_name>.exe #{ARGSTRING}\")"),

#     Language.new('golang', '.go', """
# package main

# import 'fmt'

# func main() {
#     fmt.Println('Hello, World!')
# }
#     """)
#         .set_compile_string("system(\"go build <full_name>.go\")")
#         .set_run_string("system(\"./<full_name> #{ARGSTRING}\")"),

#     Language.new('haskell', '.hs', """
# main :: IO ()
# main = putStrLn \"Hello, World!\"
#     """)
#         .set_compile_string("system(\"ghc -o <full_name> <full_name>.hs\")")
#         .set_run_string("system(\"./<full_name> #{ARGSTRING}\")")
#         # using normal systems is better for cleaning ops that usually have some
#         # failing stderr.
#         .set_clean_string("system('rm **/*.hi **/*.o *.o *.hi <full_name>')"),

#     Language.new('rust', '.rs', """
# fn main() {
#     println!('Hello, World!');
# }
#     """)
#         .set_compile_string("system('rustc <full_name>.rs')")
#         .set_run_string("system(\"./<full_name> #{ARGSTRING}\")"),

#     Language.new('php', '.php', "<?php echo 'Hello, World!'; ?>")
#         .set_run_string("system(\"php <full_name>.php #{ARGSTRING}\")"),

#     Language.new('perl', '.pl', "print \"Hello, World!\\n\";")
#         .set_run_string("system(\"perl <full_name>.pl #{ARGSTRING}\")"),

#     Language.new('r', '.R', "print('Hello, World!')")
#         .set_run_string("system(\"Rscript <full_name>.R #{ARGSTRING}\")"),

#     Language.new('swift', '.swift', "print('Hello, World!')")
#         .set_run_string("system(\"swift <full_name>.swift #{ARGSTRING}\")"),

#     Language.new('kotlin', '.kt', """
# fun main(args: Array<String>) {
#     println('Hello, World!')
# }
#     """)
#         .set_compile_string("safe_system('kotlinc <full_name>.kt -include-runtime -d <full_name>.jar')")
#         .set_run_string("system(\"java -jar <full_name>.jar #{ARGSTRING}\")"),

#     Language.new('smalltalk', '.st', """
# Transcript show: 'Hello, World!'.
#     """)
#         .set_run_string("system(\"gst <full_name>.st #{ARGSTRING}\")"),

#     Language.new('lua', '.lua', """
# print('Hello, World!')
#     """)
#         .set_run_string("system(\"lua <full_name>.lua #{ARGSTRING}\")"),

#     Language.new('typescript', '.ts', """
# console.log('Hello, World!');
#     """)
#         .set_run_string("system(\"ts-node <full_name>.ts #{ARGSTRING}\")"),

#     Language.new('crystal', '.cr', """
# puts 'Hello, World!'
#     """)
#         .set_run_string("system(\"crystal <full_name>.cr #{ARGSTRING}\")"),

#     Language.new('ocaml', '.ml', """
# print_string 'Hello, World!\\n'
#     """)
#         .set_run_string("system(\"ocaml <full_name>.ml #{ARGSTRING}\")"),

#     Language.new('elixir', '.ex', """
# IO.puts 'Hello, World!'
#     """)
#         .set_run_string("system(\"elixir <full_name>.ex #{ARGSTRING}\")"),

#     Language.new('nim', '.nim', """
# echo 'Hello, World!'
#     """)
#         .set_run_string("system(\"nim compile --verbosity:0 --hints:off --run <full_name>.nim #{ARGSTRING}\")"),

#     Language.new('fsharp', '.fs', """
# printfn 'Hello, World!'
#     """)
#         .set_run_string("system(\"fsharpc <full_name>.fs && mono <full_name>.exe #{ARGSTRING}\")"),

#     Language.new('d', '.d', """
# import std.stdio;

# void main() {
#     writeln('Hello, World!');
# }
#     """)
#         .set_run_string("system(\"dmd <full_name>.d && ./<full_name> #{ARGSTRING}\")"),

#     Language.new('scheme', '.scm', """
# (display 'Hello, World!')
#     """)
#         .set_run_string("system(\"gosh <full_name>.scm #{ARGSTRING}\")"),

#     Language.new('julia', '.jl', """
# println('Hello, World!')
#     """)
#         .set_run_string("system(\"julia <full_name>.jl #{ARGSTRING}\")"),

#     Language.new('racket', '.rkt', """
# #lang racket
# (display 'Hello, World!')
#     """)
#         .set_run_string("system(\"racket <full_name>.rkt #{ARGSTRING}\")"),

]
