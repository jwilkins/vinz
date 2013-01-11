# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
$:.push File.expand_path("../config", __FILE__)
require "vinz/version"

Gem::Specification.new do |s|
  s.name        = "vinz"
  s.version     = VINZ::VERSION
  s.authors     = ["Jonathan Wilkins"]
  s.email       = ["jwilkins@bitland.net"]
  s.homepage    = ""
  s.summary     = %q{Password Vault library}
  s.description = %q{Vinz - Keymaster - Secure password storage and management}

  s.rubyforge_project = "vinz"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "docopt"
  s.add_runtime_dependency "rake"
  s.add_runtime_dependency "scrypt"
  s.add_runtime_dependency "nacl"
  #s.add_runtime_dependency "bootlace"
  #s.add_runtime_dependency "standalone_migrations"
  #s.add_runtime_dependency "plist"
  #s.add_runtime_dependency "json"
  #s.add_runtime_dependency "mechanize"
  #s.add_runtime_dependency "pony"
  #s.add_runtime_dependency "sinatra"
  #s.add_runtime_dependency "sqlite3"
  #s.add_runtime_dependency "capybara"
  #s.add_runtime_dependency "capybara-webkit"
  #s.add_runtime_dependency "settingslogic"
  #s.add_runtime_dependency "state_machine"
  #s.add_runtime_dependency "thin"
  #s.add_runtime_dependency "validates_email_format_of"
  #s.add_runtime_dependency "oj"
  #s.add_runtime_dependency "grape"
  #s.add_runtime_dependency "primer"

  ##s.add_runtime_dependency "periscope"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "method_info"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-doc"
  s.add_development_dependency "pry-debugger"
  s.add_development_dependency "pry-stack_explorer"
  #s.add_development_dependency "ruby-graphviz"
  if RUBY_VERSION =~ /1.9/
  s.add_development_dependency "ruby-debug19"
  else
  s.add_development_dependency "ruby-debug"
  end
end
