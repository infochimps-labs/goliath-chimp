# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infochimps/rack/version'

Gem::Specification.new do |s|
  s.name          = 'infochimps-rack'
  s.version       = Infochimps::Rack::VERSION
  s.authors       = ['Travis Dempsey']
  s.email         = ['travis@infochimps.com']
  s.homepage      = 'https://github.com/infochimps-labs/infochimps-rack'
  s.licenses      = ['Apache 2.0']
  s.summary       = 'Collection of Goliath/Rack utility classes'
  s.description   = <<-DESC.gsub(/^ {4}/, '').chomp
    Infochimps' Rack

    A collection of reusable Rack classes for use in Goliath Apis
  DESC

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(/^bin/){ |f| File.basename(f) }
  s.test_files    = s.files.grep(/spec/)
  s.require_paths = ['lib']

  s.add_dependency('goliath',    '~> 1')
  s.add_dependency('gorillib',   '~> 0.5')
  s.add_dependency('multi_json', '~> 1.8')
end
