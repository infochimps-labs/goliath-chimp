# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goliath/chimp/version'

Gem::Specification.new do |s|
  s.name          = 'goliath-chimp'
  s.version       = Goliath::Chimp::VERSION
  s.authors       = ['Travis Dempsey']
  s.email         = ['travis@infochimps.com']
  s.homepage      = 'https://github.com/infochimps-labs/goliath-chimp'
  s.licenses      = ['Apache 2.0']
  s.summary       = 'Collection of Chimp-inspired Goliath/Rack utility classes'
  s.description   = <<-DESC.gsub(/^ {4}/, '').chomp
    Goliath Chimp

    A collection of reusable Rack classes and other goodies
    for use in Goliath APIs.
  DESC

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(/^bin/){ |f| File.basename(f) }
  s.test_files    = s.files.grep(/^spec/)
  s.require_paths = ['lib']

  s.add_dependency('goliath',    '~> 1')
  s.add_dependency('gorillib',   '~> 0.5')
  s.add_dependency('multi_json', '~> 1.8')
end
