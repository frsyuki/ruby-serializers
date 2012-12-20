require 'protobuf/message'

class ProtoImage < ::Protobuf::Message
  required ::Protobuf::Field::StringField, :name, 1
  required ::Protobuf::Field::StringField, :user, 2
  required ::Protobuf::Field::Int32Field, :format, 3
  required ::Protobuf::Field::BytesField, :data, 4
end

