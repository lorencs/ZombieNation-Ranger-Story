require "utils/vector"

Car = {}

-- Constructor
function Car:new(xnew,ynew)

    local object = {					-- define our parameters here
    x = xnew,									-- x and y coordinates ( by default, left top )
    y = ynew,
	cx = 0,									-- centered x and y coordinates of the unit
	cy = 0,
	--carLocation = Vector:new(xnew,ynew),
	carHeading = 0,
	carSpeed = 0,
	steerAngle = 0,
	wheelBase = 40,
	acceleration = 100,
	frontWheelX = 0,
	frontWheelY = 0,
	backWheelX = 0,
	backWheelY = 0,
	maxSpeed = 100,
	turnSpeed = 150,
	
	canvas = love.graphics.newCanvas( 40,20 )
	}

	setmetatable(object, { __index = Car })		
	
    return object
end

function Car:init()
	--draw rectangle car
	love.graphics.setCanvas( self.canvas )
	love.graphics.setColor ( 50, 5, 50, 255 )
	love.graphics.rectangle( 'fill', 0, 0, 40,20)
	love.graphics.setCanvas( )
	
	local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	
	if not self.x then self.x = math.random(10, map_w - 10) end
	if not self.y then self.y = math.random(10, map_h - 10) end
	
	--------------------------               TILE CHECKS
	--print("Tile type:".. map.tiles[self.y][self.x].id)
	-- the unit must be randomized on a GROUND tile
	self.onCurrentTile = self:xyToTileType(self.x, self.y)
	
	while not (self.onCurrentTile == "R" or self.onCurrentTile == "G" or self.onCurrentTile == "F"  or self.onCurrentTile == "P") do
		self.x = math.random(10, map_w - 10)
		self.y = math.random(10, map_h - 10)
		self.onCurrentTile = self:xyToTileType(self.x, self.y)
	end
	
	self.frontWheelX = self.x + self.wheelBase/2 * math.cos(self.carHeading)
	self.frontWheelY = self.y + self.wheelBase/2 * math.sin(self.carHeading)

	self.backWheelX = self.x - self.wheelBase/2 * math.cos(self.carHeading)
	self.backWheelY = self.y - self.wheelBase/2 * math.sin(self.carHeading)

	self.backWheelX = self.backWheelX + self.carSpeed * math.cos(self.carHeading)
	self.backWheelY = self.backWheelY + self.carSpeed * math.sin(self.carHeading)

	self.frontWheelX = self.frontWheelX + self.carSpeed * math.cos(self.carHeading+self.steerAngle)
	self.frontWheelY = self.frontWheelY + self.carSpeed * math.sin(self.carHeading+self.steerAngle)

	self.x = (self.frontWheelX + self.backWheelX) / 2
	self.y = (self.frontWheelY + self.backWheelY) / 2
	self.cx = (self.frontWheelX + self.backWheelX) / 2
	self.cy = (self.frontWheelY + self.backWheelY) / 2
	
	self.carHeading = math.atan2( self.frontWheelY - self.backWheelY , self.frontWheelX - self.backWheelX )
end

function Car:draw()
	--love.graphics.setColor(100,100,100,255)	
	--love.graphics.line(self.backWheelX, self.backWheelY, self.frontWheelX, self.frontWheelY)
	love.graphics.draw( self.canvas,  self.x-10, self.y-20,  self.carHeading,   1.0, 1.0, 10,20 )
	
	--love.graphics.polygon("fill", self.backWheelX -(10*math.sin(self.carHeading)), self.backWheelY-(10*math.cos(self.carHeading)), 
	--							  self.frontWheelX-(10*math.sin(self.carHeading)), self.frontWheelY-(10*math.cos(self.carHeading)), 
	--							  self.frontWheelX+(10*math.sin(self.carHeading)), self.frontWheelY-(10*math.cos(self.carHeading)), 
	--							  self.backWheelX +(10*math.sin(self.carHeading)), self.backWheelY-(10*math.cos(self.carHeading)))
end
 
-- update function
function Car:update(dt)
	if paused == true then return end
	
	-- update x and y speeds
	self.xSpeed = 0
	self.ySpeed = 0
	local left, right, up, down = false, false, false, false
	if love.keyboard.isDown("a")  then 
		left = true
		if self.steerAngle > -1*(math.pi/2) then 
			self.steerAngle = self.steerAngle - (self.turnSpeed*math.pi/180)*dt
		end
	end
	if love.keyboard.isDown("d") then 
		right = true
		if self.steerAngle < math.pi/2 then 
			self.steerAngle = self.steerAngle + (self.turnSpeed*math.pi/180)*dt
		end
	end
	if love.keyboard.isDown("w") 	 then
		up = true
		if self.carSpeed < self.maxSpeed then self.carSpeed = self.carSpeed + self.acceleration*dt end
	end
	if love.keyboard.isDown("s")  then
		down = true
		if self.carSpeed > (self.maxSpeed*-1)/2 then self.carSpeed = self.carSpeed - self.acceleration*dt end
	end
	
	-- turn wheels back
	if not left and not right then
		if self.steerAngle < 0 then self.steerAngle = self.steerAngle + (self.turnSpeed*3*math.pi/180)*dt
		elseif self.steerAngle > 0 then self.steerAngle = self.steerAngle - (self.turnSpeed*3*math.pi/180)*dt end
	end
	--decellerate
	if not up and not down then
		if self.carSpeed > 0 then self.carSpeed = self.carSpeed - self.acceleration*dt end
	end

	
	self.frontWheelX = self.x + self.wheelBase/2 * math.cos(self.carHeading)
	self.frontWheelY = self.y + self.wheelBase/2 * math.sin(self.carHeading)

	self.backWheelX = self.x - self.wheelBase/2 * math.cos(self.carHeading)
	self.backWheelY = self.y - self.wheelBase/2 * math.sin(self.carHeading)

	self.backWheelX = self.backWheelX + self.carSpeed * dt * math.cos(self.carHeading)
	self.backWheelY = self.backWheelY + self.carSpeed * dt * math.sin(self.carHeading)

	self.frontWheelX = self.frontWheelX + self.carSpeed * dt * math.cos(self.carHeading+self.steerAngle)
	self.frontWheelY = self.frontWheelY + self.carSpeed * dt * math.sin(self.carHeading+self.steerAngle)

	self.x = (self.frontWheelX + self.backWheelX) / 2
	self.y = (self.frontWheelY + self.backWheelY) / 2
	self.cx = (self.frontWheelX + self.backWheelX) / 2
	self.cy = (self.frontWheelY + self.backWheelY) / 2

	self.carHeading = math.atan2( self.frontWheelY - self.backWheelY , self.frontWheelX - self.backWheelX )
end

function Car:xyToTileType(x11,y11)
	w = math.floor( x11 / map.tileSize )
	h = math.floor( y11 / map.tileSize )
	--print("x:"..x11..",y:"..y11)
	--print("w:"..w..",h:"..h)
	return map.tiles[w][h].id
end