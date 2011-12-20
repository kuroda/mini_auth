$:.push File.expand_path("../lib", __FILE__)
require "mini_auth/version"

Gem::Specification.new do |s|
  s.name        = "mini_auth"
  s.version     = MiniAuth::VERSION
  s.authors     = ["Tsutomu Kuroda"]
  s.email       = ["t-kuroda@oiax.jp"]
  s.homepage    = ""
  s.summary     = %q{A minimal authentication module for Rails}
  s.description = %q{A minimal authentication module for Rails}

  s.rubyforge_project = "mini_auth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rails", ">= 3.1.0"
  s.add_runtime_dependency "bcrypt-ruby", "~> 3.0.0"
  s.add_development_dependency "rspec-rails", "~> 2.7.0"
  s.add_development_dependency "sqlite3", "~> 1.3.4"
  s.add_development_dependency "database_cleaner", "~> 0.7.0"
end
