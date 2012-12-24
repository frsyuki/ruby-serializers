require 'fileutils'
require 'rbconfig'
ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
here = File.dirname(File.expand_path(__FILE__))

case_names = []

namespace :run do
  all = Dir["#{here}/cases/*.rb"].map do |path|
    name = File.basename(path, ".rb").to_sym
    task name do |t|
      sh ruby, path
    end
    name
  end

  if names = ENV['CASE']
    case_names = names.split(",").map {|x| x.strip.to_sym }
  else
    case_names = all
  end

  task :all => case_names
end

task :report => 'run:all' do
  require 'erb'

  report_dir = ENV['REPORT_DIR'] || 'reports'
  reports = case_names.map {|name|
    path = File.join(report_dir, "#{name}.html")
    File.read(path)
  }

  erb = ERB.new(File.read('frame.rbhtml'))
  data = erb.result(binding)

  File.open(File.join(report_dir, 'index.html'), 'wb') {|f|
    f.write data
  }
end

task :default => :report

