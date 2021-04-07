class CharacteristicDto
  attr_accessor :name, :type

  def initialize(**args)
    @name = args[:name]
    @type = args[:type]
  end
end
