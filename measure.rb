require 'benchmark'
require 'rbconfig'
require 'msgpack'
require 'json'
require 'yajl'
require 'oj'
require 'bson'

def measure(name, sers, desers, count=5000)
  if ENV['WEIGHT'] =~ /light/i
    count /= 10
  elsif ENV['WEIGHT'] =~ /tiny/i
    count /= 100
  end

  if ENV['ONCE'] =~ /.+/
    bm = :bm
  else
    bm = :bmbm
  end

  if exclude = ENV['EXCLUDE']
    exclude = exclude.split(",").map {|x| x.strip }
  end

  if only = ENV['ONLY']
    only = only.split(",").map {|x| x.strip }
  end

  keys = sers.keys

  base = sers['json'].call
  basesz = base.bytesize

  puts Time.now
  puts RUBY_DESCRIPTION
  puts "case #{name}: #{base[0,20]}..."

  keys.each do |key|
    bin = sers[key].call
    sz = bin.bytesize
    puts "%-10s %8s bytes  (%.2f%%)" % [key, sz, sz.to_f/basesz*100]
  end

  puts "serializing #{count} loop:"
  Benchmark.send(bm, 10) do |x|
    keys.each do |key|
      next if exclude && exclude.include?(key)
      next if only && !only.include?(key)
      ser = sers[key]
      x.report(key) { count.times(&ser); GC.start }
    end
  end

  puts "deserializing #{count} loop:"
  Benchmark.send(bm, 10) do |x|
    keys.each do |key|
      next if exclude && exclude.include?(key)
      next if only && !only.include?(key)
      deser = desers[key]
      x.report(key) { count.times(&deser); GC.start }
    end
  end
end

