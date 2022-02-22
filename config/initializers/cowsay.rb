if Rails.env.local? || Rails.env.test? || Rails.env.development?
  Cow::MAX_LINE_LENGTH = 65

  def say(object)
    cow = Cow.new(cow: "bong", face_type: Cow.faces.sample)
    (object.respond_to?(:inspect)) ? puts(cow.say(object.inspect)) : puts(cow.say(object))
  end

  def think(object)
    cow = Cow.new(cow: "bong", face_type: Cow.faces.sample)
    (object.respond_to?(:inspect)) ? puts(cow.think(object.inspect)) : puts(cow.think(object))
  end
end
