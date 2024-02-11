Money = Entity:extend()

function Money:new(x, y)
  Money.super.new(self, x, y, "images/3 Objects/Other/Box3.png", name)
  self.name = "money"

end
