# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = [ENV['GEM_NAME_PREFIX'], 'process_host'].compact.join '-'
  s.version = ENV.fetch 'GEM_VERSION'

  s.authors = ['Nathan Ladd']
  s.homepage = 'https://github.com/ntl/process-host'
  s.email = 'nathanladd+github@gmail.com'
  s.licenses = %w(MIT)
  s.summary = "Ruby library for hosting components"
  s.description = "Ruby library for hosting components composed of independent actors"

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'
  s.platform = Gem::Platform::RUBY
end
