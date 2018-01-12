
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "trizetto/api/version"

Gem::Specification.new do |spec|
  spec.name          = "trizetto-api"
  spec.version       = Trizetto::Api::VERSION
  spec.authors       = ["John Naegle"]
  spec.email         = ["john.naegle@goodmeasures.com"]

  spec.summary       = "Ruby wrapper for the Trizetto APIs"
  spec.description   = "Ruby wrapper for the Trizetto APIs"
  spec.homepage      = "https://github.com/GoodMeasuresLLC/trizetto-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"

  spec.add_dependency "savon", "~> 2.0"
  spec.add_dependency "savon-multipart", "~> 2.0"
end
