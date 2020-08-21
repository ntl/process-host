MRuby::Gem::Specification.new('mruby-process-host') do |spec|
  spec.authors = ["Nathan Ladd"]
  spec.homepage = "https://github.com/esc/process-host"
  spec.licenses = ["MIT"]
  spec.summary = "Host isolated, parallel processes within a single Ruby or MRuby runtime"

  spec.mrblib_dir = 'lib'

  spec.test_rbfiles = []

  loader_files = ['lib/process_host.rb']

  if ENV.fetch('MRUBY_COMPILE_CONTROLS', 'on') == 'on'
    loader_files << 'lib/process_host/controls.rb'
  end

  loader_files.each do |loader_file|
    loader_file = File.join(__dir__, loader_file)

    require_statement_pattern = /^[[:blank:]]*require[[:blank:]]+['"](.*)['"]/

    File.read(loader_file).scan(require_statement_pattern) do |(feature)|
      file = File.join(__dir__, spec.mrblib_dir, feature)

      file << '.rb' unless file.end_with?('.rb')

      if File.exist?(file)
        spec.rbfiles << file
      end
    end
  end
end
