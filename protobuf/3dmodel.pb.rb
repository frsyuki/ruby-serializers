require 'protobuf'

class Proto3DModelFrame < ::Protobuf::Message
  repeated ::Protobuf::Field::DoubleField, :array, 1
end

class Proto3DModel < ::Protobuf::Message
  repeated ::Protobuf::Field::DoubleField, :cube, 1
  repeated ::Protobuf::Field::DoubleField, :texcoords, 2
  repeated ::Proto3DModelFrame, :frames, 3
end

