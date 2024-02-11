Box2 = Entity:extend()

function Box2:new(x, y)
  self.name = "box2"
  Box2.super.new(self, x, y, "images/3 Objects/Other/Box3.png", name)
end

