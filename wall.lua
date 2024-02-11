Wall = Entity:extend()

function Wall:new(x, y, tile_type)
  
  walls_images = {}
  for i=1, 83 do
    table.insert(walls_images, "images/1 Tiles/Tile_" .. i .. ".png")
  end
  
  local image_path  = walls_images[tile_type]
  
  Wall.super.new(self, x, y, image_path)
  self.strength = 100
  
  self.weight = 0
end

