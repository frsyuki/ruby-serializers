# examples from http://fluentd.org
here = File.dirname(File.expand_path(__FILE__))
require "#{here}/../measure"

sers = {}
desers = {}

data = File.read("#{here}/image.png")
data.force_encoding('ASCII-8BIT')

obj = {
  'name' => 'fluentd',
  'user' => 'frsyuki',
  'format' => 3,
  'data' => data,
}

### JSON
# json can't serialize binaries
# this base64 encoding/decoding should be done in ser/deser
# procs to be precious.
json_obj = obj.dup
json_obj['data'] = [obj['data']].pack('m')

m = sers['json'] = proc { JSON.dump(json_obj) }
json = m.call
desers['json'] = proc { JSON.load(json) }


### Yajl
# json can't serialize binaries
m = sers['yajl'] = proc { Yajl.dump(json_obj) }
yajl = m.call
desers['yajl'] = proc { Yajl.load(yajl) }


### Oj
# json can't serialize binaries
m = sers['oj'] = proc { Oj.dump(json_obj) }
oj = m.call
desers['oj'] = proc { Oj.load(oj) }


### MessagePack
m = sers['msgpack'] = proc { MessagePack.dump(obj) }
msgpack = m.call
desers['msgpack'] = proc { MessagePack.load(msgpack) }


### BSON
# bson should be able to serialize binaries but
# this ruby binding rejects binaries
m = sers['bson'] = proc { BSON.serialize(json_obj).to_s }
bson = m.call
desers['bson'] = proc { BSON.deserialize(bson) }


### Protocol Buffers
require "#{here}/../protobuf/image.pb"

# library is broken! omg.
module Protobuf
  module Field
    class BaseField
      def warn_if_deprecated
      end
    end
  end
end

proto = ProtoImage.new
proto.name = obj['name']
proto.user = obj['user']
proto.format = obj['format']
proto.data = obj['data']

m = sers['protobuf'] = proc { proto.serialize_to_string }
protobuf = m.call
protoc = proto.class
desers['protobuf'] = proc { protoc.new.parse_from_string(protobuf) }


measure('image', sers, desers, 250000)

