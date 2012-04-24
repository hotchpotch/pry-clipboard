# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pry-clipboard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yuichi Tateno"]
  gem.email         = ["hotchpotch@gmail.com"]
  gem.summary       = gem.description   = %q{pry clipboard utility}
  gem.homepage      = "https://github.com/hotchpotch/pry-clipboard"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pry-clipboard"
  gem.require_paths = ["lib"]
  gem.version       = PryClipboard::VERSION

  gem.add_dependency 'pry'
  gem.add_dependency 'clipboard'
end
