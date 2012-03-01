# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{enum_field}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sebasti\303\241n Bernardo Galkin"]
  s.date = %q{2009-06-23}
  s.description = %q{Enables Active Record attributes to point to enum like objects, by saving in your database only an integer ID.}
  s.email = ["sgalkin@grantaire.com.ar"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/enum_field.rb", "lib/enum_field/builder.rb", "lib/enum_field/define_enum.rb", "lib/enum_field/enumerated_attribute.rb", "lib/enum_field/exceptions.rb", "script/console", "script/destroy", "script/generate", "spec/define_enum_spec.rb", "spec/enumerated_attribute_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/paraseba/enum_field}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{enum_field}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Enables Active Record attributes to point to enum like objects, by saving in your database only an integer ID.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
