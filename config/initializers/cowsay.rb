Cow::MAX_LINE_LENGTH = 65
COWS = %w[bong udder mutilated small sodomized flaming-sheep head-in skeleton moose three-eyes vader satanic]

def say(object)
  cow = Cow.new(cow: COWS.sample, face_type: Cow.faces.sample)
  (object.respond_to?(:inspect)) ? puts(cow.say(object.inspect)) : puts(cow.say(object))
end

def think(object)
  cow = Cow.new(cow: COWS.sample, face_type: Cow.faces.sample)
  (object.respond_to?(:inspect)) ? puts(cow.think(object.inspect)) : puts(cow.think(object))
end
