MRuby::Gem::Specification.new('mruby-process-host') do |spec|
  spec.authors = ["Nathan Ladd"]
  spec.homepage = "https://github.com/esc/process-host"
  spec.licenses = ["MIT"]
  spec.summary = "Host isolated, parallel processes within a single Ruby or MRuby runtime"

  spec.mrblib_dir = 'lib'

  spec.test_rbfiles = []

  spec.add_dependency 'mruby-require', :github => 'test-bench/mruby-ruby-compat', :path => 'mrbgems/require'

  spec.add_dependency 'mruby-thread', :github => 'test-bench/mruby-ruby-compat', :path => 'mrbgems/thread'

  loader_files = ['lib/process_host.rb']

  if ENV.fetch('MRUBY_COMPILE_CONTROLS', 'on') == 'on'
    loader_files << 'lib/process_host/controls.rb'
  end

  #if ENV.fetch('MRUBY_COMPILE_FIXTURES', 'on') == 'on'
  #  loader_files << 'lib/process_host/fixtures.rb'
  #end

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

    spec.rbfiles << loader_file
  end

  compiled_features_h = File.join(__dir__, 'src', 'compiled_features.h')

  File.open(compiled_features_h, 'w') do |compiled_features|
    compiled_features.puts <<~C99
    /* Generated by #{__FILE__} */

    #ifndef MRB_#{spec.funcname.upcase}_COMPILED_FEATURES_H
    #define MRB_#{spec.funcname.upcase}_COMPILED_FEATURES_H

    #include <mruby.h>

    static const char* const mrb_#{spec.funcname}_compiled_features[] = {
    C99

    lib_dir = Pathname.new(File.join(__dir__, spec.mrblib_dir))

    spec.rbfiles.each do |file|
      feature = Pathname.new(file).relative_path_from(lib_dir).sub_ext('')

      compiled_features.puts <<~C99
      \t"#{feature}",
      C99
    end

    compiled_features.puts <<~C99
    \tNULL
    };

    static mrb_int mrb_#{spec.funcname}_compiled_features_count = #{spec.rbfiles.length};

    #endif /* MRB_#{spec.funcname.upcase}_COMPILED_FEATURES_H */

    /* Generated by #{__FILE__} */
    C99
  end
end