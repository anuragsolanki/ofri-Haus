# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{magent}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Cuadrado"]
  s.date = %q{2010-09-06}
  s.default_executable = %q{magent}
  s.description = %q{Simple job queue system based on mongodb}
  s.email = ["krawek@gmail.com"]
  s.executables = ["magent"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "bin/magent", "examples/comm/run.rb", "examples/comm/worker.rb", "examples/error/error.rb", "examples/simple/bot.rb", "examples/stats/stats.rb", "lib/magent.rb", "lib/magent/actor.rb", "lib/magent/channel.rb", "lib/magent/generic_channel.rb", "lib/magent/processor.rb", "lib/magent/push.rb", "lib/magent/utils.rb", "magent.gemspec", "script/console", "test/test_helper.rb", "test/test_magent.rb"]
  s.homepage = %q{http://github.com/dcu/magent}
  s.post_install_message = %q{}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{magent}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple job queue system based on mongodb}
  s.test_files = ["test/test_helper.rb", "test/test_magent.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<uuidtools>, [">= 2.0.0"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<mongo>, [">= 0.1.0"])
      s.add_dependency(%q<uuidtools>, [">= 2.0.0"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<mongo>, [">= 0.1.0"])
    s.add_dependency(%q<uuidtools>, [">= 2.0.0"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
