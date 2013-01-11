#!/usr/bin/env ruby
# encoding: UTF-8
require 'bundler'
Bundler.require

require 'docopt'
require 'scrypt'
require 'nacl'
require 'securerandom'
require 'readline'
begin
  require 'pry'
  require 'ruby-debug'
rescue LoadError => e
  puts "Error loading ruby-debug: #{e}"
end

libdir = File.join(File.dirname(__FILE__), '..', 'lib')
$: << libdir unless $:.include?(libdir)
require 'vinz'

doc=<<EOD
Usage: #{File.basename(__FILE__)} [options] <arguments>...

Options:
  -h --help              show this help message and exit
  --version              show version and exit
  -v --verbose           print extra debugging messages
  -q --quiet             terse output
  -f NAME --file=NAME    use file instead of default .vinzdb
EOD

begin
  options = Docopt::docopt(doc, :version => VINZ::VERSION)
rescue Docopt::Exit => e
    puts e.message
end

password = ''
shell_prompt = 'vinz> '
vinz = Vinz.new

def show_help(cmds, args='')
  puts "Commands: "
  cmds.keys.each { |ck| puts " #{ck.names[0]}" }
  ''
end

cmds = {
  /^(?<quit>quit)\s*(?<args>.*)/     => Proc.new { puts; exit 0 },
  /^(?<help>help)\s*(?<args>.*)/     => -> args='' { show_help(cmds, args) },
  /^(?<debug>debug)\s*(?<args>.*)/     => -> args='' { debugger },
  /^(?<save>save)\s*(?<args>.*)/     => -> args='' { vinz.save },
  /^(?<load>load)\s*(?<args>.*)/     => -> args='' { vinz.load },
  /^(?<add>add)\s*(?<args>.*)/       => -> args='' { 
                                              puts vinz.add(args[0], args[1..-1]) },
  /^(?<lookup>lookup)\s*(?<args>.*)/ => -> args='' { puts vinz.lookup(args) }
}

repl = -> prompt {
  begin
    result = ''
    handled = nil
    cmd = (Readline.readline(prompt, true) || 'quit').chomp
    cmds.keys.each { |ck|
      if cmd =~ ck
        result = cmds[ck].call($~[:args])
        handled = true
      end
    }
      result = eval(cmd)  unless handled
    unless handled
      puts "'#{cmd}' not an known command, trying it as plain ruby:"
      result = eval(cmd)
    end
    result ||= 'nil'
    puts("=> %s" % result)
  rescue SyntaxError => e
    puts "WYTAW?! #{e}"
  rescue => e
    puts "Durp: #{e}"
  end
}

loop {
  begin
    repl[shell_prompt]
  #rescue => e
  #  puts("=> Error: #{e}")
  end
}
