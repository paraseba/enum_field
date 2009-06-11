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
end

end
