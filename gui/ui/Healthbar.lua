Healthbar = {}

function Healthbar:new(_x,_y,w,h)
	local object = {
		x = _x,
		y = _y,
		width = w,
		height = h,
		health = 100
	}
	setmetatable(object, { __index = Healthbar })
	return object
end

function Healthbar:update(player)
	if player.health ~= nil then
		self.health = player.health
	end
end

function Healthbar:draw()	
	
	-- draw outline
	love.graphics.setColor(0,0,0, 150)
	love.graphics.rectangle("fill", self.x, self.y, self.width+4, self.height+4)
	
	-- draw healthbar
	love.graphics.setColor(180,0,0, 150)
	local healthHeight = (self.health * self.height) / 100
	love.graphics.rectangle("fill", self.x+2, self.y+(self.height-healthHeight)+2, self.width, healthHeight)
	
	-- draw cross icon
	--love.graphics.setColor(250,250,250, 250)
	--love.graphics.rectangle("fill", self.x+self.width/2 - 2, self.y+(self.height*0.2) -1, 8,2)
	--love.graphics.rectangle("fill", self.x+self.width/2+1, self.y+(self.height*0.2) -4, 2,8)
end