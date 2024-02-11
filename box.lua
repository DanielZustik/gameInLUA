Box = Entity:extend()

function Box:new(x, y, name)
  Box.super.new(self, x, y, "images/3 Objects/Other/Box1.png", name)
end
