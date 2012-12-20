require 'protobuf'

class ProtoInteger < ::Protobuf::Message
  repeated ::Protobuf::Field::Int32Field, :array, 1
end

