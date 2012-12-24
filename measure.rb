require 'benchmark'
require 'fileutils'
require 'erb'
require 'rbconfig'

require 'msgpack'
require 'json'
require 'yajl'
require 'oj'
require 'bson'

# for ERB
def h(s)
  require 'cgi'
  CGI.escapeHTML(s.to_s)
end

def e(s)
  require 'cgi'
  CGI.escape(s.to_s)
end

def measure(name, sers, desers, count=5000)
  if ENV['WEIGHT'] =~ /light/i
    count /= 10
  elsif ENV['WEIGHT'] =~ /heavy/i
    count *= 10
  elsif !ENV['WEIGHT'].to_s.empty?
    raise "unknown WEIGHT setting: #{ENV['WEIGHT'].dump}"
  end

  n = 2
  if nloop = ENV['LOOP']
    n = nloop.to_i
  end

  if exclude = ENV['EXCLUDE']
    exclude = exclude.split(",").map {|x| x.strip }
  end

  if only = ENV['ONLY']
    only = only.split(",").map {|x| x.strip }
  end

  keys = sers.keys.reject do |key|
    (exclude && exclude.include?(key)) or (only && !only.include?(key))
  end

  # report
  here = File.dirname(File.expand_path(__FILE__))
  report_dir = ENV['REPORT_DIR'] || File.join(here, 'reports')
  FileUtils.mkdir_p(report_dir)

  template = ENV['REPORT_TEMPLATE'] || File.join(here, 'report.rbhtml')
  erb = ERB.new(File.read(template))

  report = lambda do |sizes,sers,desers|
    File.open("#{File.join(report_dir, name)}.html", 'wb') {|f|
      f.write erb.result(binding)
    }
  end

  base = sers['json'].call
  basesz = base.bytesize

  time = Time.now
  rbver = RUBY_DESCRIPTION
  sample = "#{base[0,20]}..."
  puts time
  puts rbver
  puts "case #{name}: #{sample}"

  report_sizes = {}
  report_sers = {}
  report_desers = {}

  keys.each do |key|
    bin = sers[key].call
    sz = bin.bytesize
    puts "%-10s %8s bytes  (%.2f%%)" % [key, sz, sz.to_f/basesz*100]
    report_sizes[key] = sz
  end

  n.times do |i|
    puts "serializing #{count} loop #{i+1}/#{n}:"
    Benchmark.bm(10) do |x|
      keys.each do |key|
        ser = sers[key]
        report_sers[key] = x.report(key) { count.times(&ser); GC.start }
      end
    end
  end

  n.times do |i|
    puts "deserializing #{count} loop #{i+1}/#{n}:"
    Benchmark.bm(10) do |x|
      keys.each do |key|
        deser = desers[key]
        report_desers[key] = x.report(key) { count.times(&deser); GC.start }
      end
    end
  end

  if report
    report.call(report_sizes, report_sers, report_desers)
  end
end

