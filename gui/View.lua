View = {}

function View:new(h, map)
	local object = {
		height = h,
		--x = love.graphics.getWidth() / 2,
		--y = love.graphics.getHeight() / 2,
		x = 0,
		y = 0,
		
		xmin = 0,
		xmax = (map.width * map.tileSize) - love.graphics.getWidth(),
		ymin = 0,
		ymax = (map.height * map.tileSize) -  h 	
	}
	setmetatable(object, { __index = View })
	return object
end

function View:update(player)
	-- viewpoint movement - arrow keys
	self.x = math.clamp(player.cx-width/2, self.xmin, self.xmax)
	self.y = math.clamp(player.cy-height/2, self.ymin, self.ymax)
end