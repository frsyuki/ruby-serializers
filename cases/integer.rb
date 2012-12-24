# examples from http://oeis.org/A007318
here = File.dirname(File.expand_path(__FILE__))
require "#{here}/../measure"

sers = {}
desers = {}

obj = JSON.load File.read("#{here}/integer.js")
obj = obj * 40


### JSON
m = sers['json'] = proc { JSON.dump(obj) }
json = m.call
desers['json'] = proc { JSON.load(json) }


### Yajl
m = sers['yajl'] = proc { Yajl.dump(obj) }
yajl = m.call
desers['yajl'] = proc { Yajl.load(yajl) }


### Oj
m = sers['oj'] = proc { Oj.dump(obj) }
oj = m.call
desers['oj'] = proc { Oj.load(oj) }


### MessagePack
m = sers['msgpack'] = proc { MessagePack.dump(obj) }
msgpack = m.call
desers['msgpack'] = proc { MessagePack.load(msgpack) }


### BSON
# bson can't serialize arrays
bson_obj = {
  'array' => obj
}
m = sers['bson'] = proc { BSON.serialize(bson_obj).to_s }
bson = m.call
desers['bson'] = proc { BSON.deserialize(bson) }


### Protocol Buffers
require "#{here}/../protobuf/integer.pb"
proto = ProtoInteger.new
proto.array = obj

m = sers['protobuf'] = proc { proto.serialize_to_string }
protobuf = m.call
protoc = proto.class
desers['protobuf'] = proc { protoc.new.parse_from_string(protobuf) }


measure('integer', sers, desers, 2500)

