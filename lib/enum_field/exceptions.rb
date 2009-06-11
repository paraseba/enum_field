module EnumField
  class BadId < StandardError
    def initialize(repeated_id)
      @repeated_id = repeated_id
    end
    attr_reader :repeated_id
  end

  class RepeatedId < StandardError; end
  class InvalidId < StandardError; end

  class InvalidOptions < StandardError
  end

  class ObjectNotFound < StandardError
  end

end

