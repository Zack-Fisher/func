# Func
This is a Ruby command-line tool for the easy creation of portable functions in various languages.
It's intended to generate boilerplate to turn code into something executable by a Linux shell.

## Installation
First, ensure Ruby is installed on your system and in the PATH. Then,
```bash
./install.rb
```

## Generating code
```bash
func <language> <function_name>
```
eg,
```bash
func haskell add_numbers
```
or
```bash
func python ask_gpt
```
will create the corresponding template, and automatically link the executable wrapper to ~/.func/installs. Ensure that this is in your $PATH.
The executable will by default be named after the function_name you pass.

## How to use
Currently, placing any standard output inside ^^% %^^ delimiters will include it in the standard output. This allows functions to potentially be run both standalone and inside of a pipe.

## Use example
Make a function with 
```bash
func java MyFunction
```
then, in the generated MyFunction.java file, write:
```java
public class MyFunction {
    public static void main(String[] args) {
        System.out.println("garbage output^^%Hello, World!^^%more garbage output");
    }
}
```
and simply running
```bash
MyFunction
```
in your shell should output "Hello, World!".
