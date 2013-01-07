#!/usr/bin/env ruby
# encoding: UTF-8
require 'bundler'
Bundler.require
require 'docopt'
require 'scrypt'
require 'readline'

libdir = File.join(File.dirname(__FILE__), '..', 'lib')
$: << libdir unless $:.include?(libdir)
require 'vinz'

begin
  require 'ruby-debug'
rescue LoadError
end

doc=<<EOD
Usage: #{File.basename(__FILE__)} [options] <arguments>...

Options:
  -h --help            show this help message and exit
  --version            show version and exit
  -v --verbose         print extra debugging messages
  -q --quiet           terse output
EOD

begin
  options = Docopt::docopt(doc, :version => VINZ::VERSION)
rescue Docopt::Exit => e
    puts e.message
end

password = ''
prompt = 'vinz> '

def show_help(cmds, args='')
  puts "Commands: "
  cmds.keys.each { |ck| puts " #{ck.names[0]}" }
  ''
end

cmds = {
  /^(?<quit>quit)\s*(?<args>.*)/ => Proc.new {puts; exit 0},
  /^(?<help>help)\s*(?<args>.*)/ => -> args='' { show_help(cmds, args) },
  /^(?<unlock>unlock)\s*(?<args>.*)/ => -> args='' { password = SCrypt::Password.create(args) }
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
    repl[prompt]
  #rescue => e
  #  puts("=> Error: #{e}")
  end
}
