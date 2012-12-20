require 'fileutils'
here = File.dirname(File.expand_path(__FILE__))

namespace :run do
  all = Dir["#{here}/cases/*.rb"].map do |path|
    name = File.basename(path, ".rb").to_sym
    task name do |t|
      load path
    end
    name
  end

  task :all => all
end

task :default => 'run:all'

