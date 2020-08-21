# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'process_host'
  s.version = '0'

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd+github@gmail.com'
  s.homepage = 'https://github.com/esc/process-host'
  s.licenses = %w(MIT)
  s.summary = "Host isolated, parallel processes within a single Ruby or MRuby runtime"
  s.platform = Gem::Platform::RUBY

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'

  s.add_development_dependency 'test_bench'
end
