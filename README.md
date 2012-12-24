# ruby-serializers

A benchamrk suite comparing serialization libraries on Ruby.

Simply run `bundle exec rake` to run all test cases.

# options

Following environment variables control benchmark settings:

  * **LOOP=** repeat benchmark. default is 2
  * **WEIGHT=** "light": reduce count. "heavy": increase count
  * **EXCLUDE=** comma-separated name of libraries to exclude
  * **ONLY=** comma-separated name of libraries to include
  * **REPORT_DIR=** path to a directory to put report html. default is ./reports


# libraries

  * [json](https://rubygems.org/gems/json)
  * [yajl-ruby](https://rubygems.org/gems/yajl-ruby)
  * [oj](https://rubygems.org/gems/oj)
  * [msgpack](https://rubygems.org/gems/msgpack)
  * [bson](https://rubygems.org/gems/bson)
  * [protobuf](https://rubygems.org/gems/protobuf)

# test cases

## Twitter

This data is from Twitter API. It consists of mainly hash and strings. See cases/twitter.rb.

    rake run:twitter

## Image

This data consist of a binary 6KB image and a few metadata. See cases/image.rb.

    rake run:image

## Integer

This data only include integers. See cases/integer.rb

    rake run:integer

## Geo

This is geographical data from [GeoJSON](http://www.geojson.org/). It consists of hash, strings, arrays and floating points. See cases/geo.rb.

    rake run:geo

## 3D Model

This is 3D model data from [blender-webgl-exporter](http://code.google.com/p/blender-webgl-exporter/). It includes a lot of floating points. See cases/3dmodel.rb.

    rake run:3dmodel

