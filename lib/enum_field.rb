$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'enum_field/define_enum'
require 'enum_field/exceptions'
require 'enum_field/builder'
require 'enum_field/enumerated_attribute'
require 'active_record'

Module.send(:include, EnumField::DefineEnum)
ActiveRecord::Base.send(:extend, EnumField::EnumeratedAttribute)

module EnumField
  VERSION = '0.1.1'

end
