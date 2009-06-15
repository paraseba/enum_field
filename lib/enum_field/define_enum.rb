module EnumField
  module DefineEnum
    def define_enum(&block)
      @enum_builder ||= EnumField::Builder.new(self)
      yield @enum_builder

      [:all, :find_by_id, :find, :first, :last].each do |method|
        instance_eval <<-END
          def #{method}(*args, &block)
            @enum_builder.send(:#{method}, *args, &block)
          end
        END
      end
    end
  end
end
