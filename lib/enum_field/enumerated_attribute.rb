module EnumField
# Easies the inclusion of enumerations as ActiveRecord columns.
# If you have a User AR, with a role_id column, you could do:
# <tt>
# class User
#   enumerated_attribute :role
# end
# </tt>
#
# This assumes a Role class, and will define role and role= methods in User class.
# These added methods expect an object of class Role, and Role should provide a find class method.
# You could get this by using Enumerated mixin
#
# Similar to has_many :through in AR, it creates reader and writter methods to get enumerated atributes going through an
# intermediate model.
# For instance:
# <tt>
# class User
#   has_many_enumerated_attributes :roles, :through  => UserRole
# end
#
# class UserRole < ActiveRecord::Base
#   belongs_to :user
#   enumerated_attribute :role
# end
# </tt>
# This assumes a Role class, the UserRole AR class is there just to persist the one-to-many relationship.
# This will define roles, roles=, role_ids and role_ids= methods in User class



module EnumeratedAttribute
  # Define an enumerated field of the AR class
  # * +name_attribute+: the name of the field that will be added, for instance +role+
  # * +options+: Valid options are:
  #    * +id_attribute+: the name of the AR column where the enumerated id will be save. Defaults to
  #      +name_attribute+ with an +_id+ suffix.
  #    * +class+: the class that will be instantiated when +name_attribute+ method is called. Defaults to
  #      +name_attribute+ in camelcase form.
  def enumerated_attribute(name_attribute, options  = {})
    id_attribute = options[:id_attribute] || (name_attribute.to_s + '_id').to_sym
    klass = options[:class] || name_attribute.to_s.camelcase.constantize
    define_method(name_attribute) do
      (raw = read_attribute(id_attribute)) && klass.find_by_id(raw)
    end

    define_method(name_attribute.to_s + '=') do |value|
      write_attribute(id_attribute, value ? value.id : nil)
    end
  end

  # alias of enumerated_attribute
  alias belongs_to_enumerated_attribute enumerated_attribute

  # Defines a one-to-many association between an AR class and the enumerated
  # * +association+: the name of the one-to-many association, for instance +roles+
  # * +options+: Valid options are:
  #    * +through+ : the name of the AR class needed to persist the one-to-many association.
  #       Defaults to AR class in camelcase form concatenated with the enumerated class in camelcase form.
  #    * +class+:    the enumerated class, it will be instantiated +n+ times when +association+ method is called.
  #       Defaults to +association+ in singular camelcase form.
  def has_many_enumerated_attributes(association, options = {})
    enum_attr = association.to_s.singularize
    klass     = options[:class]   || enum_attr.camelcase.constantize
    through   = options[:through] || (self.name + klass.name)
    self_attribute = self.name.demodulize.underscore
    association_ids = association.to_s.singularize + '_ids'
    has_many_aux = through.demodulize.underscore.pluralize

    has_many has_many_aux, {:class_name => through, :dependent => :destroy}

    define_method(association) do
      self.send(has_many_aux).map(&enum_attr.to_sym)
    end

    define_method(association.to_s + '=') do |values|
      self.send(has_many_aux + '=', values.map{|g| through.constantize.new(self_attribute => self, enum_attr => g)})
    end

    define_method(association_ids) do
       self.send(association).map(&:id)
    end

    define_method(association_ids + '=') do |values|
      self.send(has_many_aux + '=', values.map{|g| g.to_i unless g.blank?}.compact.map{|g_id| through.constantize.new(self_attribute => self, enum_attr + '_id' => g_id) })
    end
  end
end
end
