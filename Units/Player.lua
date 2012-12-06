require "Units/Bullet"

Player = {}

-- Constructor
function Player:new(xnew,ynew)

    local object = {					-- define our parameters here
    x = xnew,									-- x and y coordinates ( by default, left top )
    y = ynew,
	cx = 0,									-- centered x and y coordinates of the unit
	cy = 0,
	radius = 4,
	angle = math.random(360),				-- randomize initial angles
    width = 0,
    height = 0,
    state = "",
	speed = 0,
	normalSpeed = 25,
	huntingSpeed = 30,
	xSpeed = 0,
	ySpeed = 0,
	initial_direction = 1,
	attacked = 0,								-- if the unit is currently attacked, this var = 1
	shootingTimer = 0,								-- reload time (pretend he's using a hunting rifle)
	shootCoolDown = 1,						-- how long it takes to fire another shot
	color = 0,
	onCurrentTile = 0,
	neighbourTiles = {},
	bullets = {},
	animation = SpriteAnimation:new("Units/images/playerstill.png", 10, 14, 1, 1),
	legsAnim = SpriteAnimation:new("Units/images/playerlegs.png", 10, 12, 8, 1),
	LA = 0,		-- legs angle
	
	-- sounds
	gunshotSound = Sound:new(),
	emptyclipSound = Sound:new(),
	reloadSound = Sound:new(),
	
	
	-- gun stuff
	totalAmmo = 999999,
	clipAmmo = 8,
	reloadTimer = 0
	}

	setmetatable(object, { __index = Player })		
	
    return object
end

function Player:init()

	local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	
	if not self.x then self.x = math.random(self.radius * 3, map_w - self.radius * 3) end
	if not self.y then self.y = math.random(self.radius * 3, map_h - self.radius * 3) end
	
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	--------------------------               TILE CHECKS
	--print("Tile type:".. map.tiles[self.y][self.x].id)
	-- the unit must be randomized on a GROUND tile
	self.onCurrentTile = self:xyToTileType(self.cx, self.cy)
	
	while not (self.onCurrentTile == "R" or self.onCurrentTile == "G" or self.onCurrentTile == "F"  or self.onCurrentTile == "P") do
		self.x = math.random(self.radius * 3, map_w - self.radius * 3)
		self.y = math.random(self.radius * 3, map_h - self.radius * 3)
		self.cx = self.x + self.radius
		self.cy = self.y + self.radius
		self.onCurrentTile = self:xyToTileType(self.cx, self.cy)
	end
		
	self.state = "standing"
	self.speed = self.normalSpeed
	
	self.gunshotSound:init("Units/sounds/gunshot1.mp3")
	self.emptyclipSound:init("Units/sounds/emptyclip.mp3")
	self.reloadSound:init("Units/sounds/reload.mp3")
	
	self.animation:load()
	self.animation:switch(1,1,120)
	self.legsAnim:load()
	self.legsAnim:switch(1,8,70)
end

function Player:draw(i)
	love.graphics.setColor(0,255,0,50)	
	
	-- draw line for angle and targetAngle
	--if menu.debugMode then
	love.graphics.line(self.x + self.radius,self.y + self.radius, 
					   self.x + math.cos(self.angle * (math.pi/180))* 30 + self.radius , 
					   self.y + math.sin(self.angle * (math.pi/180))* 30 + self.radius)
	
	-- draw state of unit
	love.graphics.print(self.state, self.x, self.y + 15)

	-- draw bullets
	for i,_ in pairs(self.bullets) do
		self.bullets[i]:draw()
	end
	
	--draw sprite
	love.graphics.reset()	
	self.legsAnim:draw(self.cx,self.cy)
	self.animation:draw(self.cx,self.cy)
end
 
-- update function
function Player:update(dt)
	if paused == true then return end

	-- update bullets
	for i,_ in pairs(self.bullets) do
		self.bullets[i]:update(dt, paused)
		if self.bullets[i].delete then
			table.remove(self.bullets, i)
		end
	end
	
	-- update x and y speeds
	self.xSpeed = 0
	self.ySpeed = 0
	local N, E, S, W = false, false, false, false
	if love.keyboard.isDown("a")  then 
		W = true
		self.xSpeed = self.xSpeed - self.speed
	end
	if love.keyboard.isDown("d") then 
		E = true
		self.xSpeed = self.xSpeed + self.speed
	end
	if love.keyboard.isDown("w") 	 then 
		N = true
		self.ySpeed = self.ySpeed - self.speed
	end
	if love.keyboard.isDown("s")  then 
		S = true
		self.ySpeed = self.ySpeed + self.speed
	end
	-- if moving diagonally, reduce x and y speed to reflect that
	if (self.xSpeed ~= 0) and (self.ySpeed ~= 0) then 
		self.xSpeed = self.xSpeed / math.sqrt(2)
		self.ySpeed = self.ySpeed / math.sqrt(2)
	end
	-- if moving
	if (self.xSpeed ~= 0) or (self.ySpeed ~= 0) then 
		--if not already moving
		if self.state == "standing" then
			--self.legsAnim:start()
			self.legsAnim:switch(1,8,120)
			self.state = "moving"
		end
	else 
		self.state = "standing"
		--self.legsAnim:stop()
		self.legsAnim:switch(1,1,120)
	end
	
	-- get angle of legs
	if 		N then if W then self.LA = 225 elseif E then  self.LA = 315 else  self.LA = 270 end 
	elseif	S then if W then self.LA = 135 elseif E then  self.LA = 45  else  self.LA = 90 end 
	elseif 	E then self.LA = 0 elseif W then self.LA = 180 end
	
	-- update angle
	self.angle = self:angleTo(love.mouse.getX(), love.mouse.getY())
	
	-- if the Ranger is attacked, then he can't move (or could make him move very slow?)
	if self.attacked == 1 then return end
	
	-- shoot if shooting
	if self.shooting and self.shootingTimer <= 0 then
		if self:shoot() then
			self.shootingTimer = self.shootCoolDown
		else 
			self.shootingTimer = 0.3
		end
	end
	
	--updating neighbours
	--self:updateNeighbours(self)
	
	if self.state == "hunting" then
		self.speed = self.huntingSpeed
	elseif self.state == "default" then
		self.speed = self.normalSpeed				
	end

	-- checking the tile that the unit is or will be on
	local next_x = self.cx + (self.radius * self:signOf(self.xSpeed)) + (dt * self.xSpeed)
	local next_y = self.cy + (self.radius * self:signOf(self.ySpeed)) + (dt * self.ySpeed)
	
	-- check map boundaries
	if next_x < 0 or next_x > map.tileSize*map.width or next_y < 0 or next_y > map.tileSize*map.height then
		return
	end			
	
	-- check for tile collision
	local nextTileType = self:xyToTileType(next_x,next_y)
	if  not (nextTileType == "G" or nextTileType == "R" or nextTileType == "F" or nextTileType == "P") then
		self:collideWithTile(next_x,next_y)
		--return
	end
	
	-- update player's position
	self.x = self.x + (dt * self.xSpeed)
	self.y = self.y + (dt * self.ySpeed)
	
	-- update the center x and y
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	
	if self.shootingTimer > 0 then self.shootingTimer = self.shootingTimer - dt end	-- only increment shooting timer if youre shooting
	
	--update animation
	self.animation:rotate(self.angle)
	self.animation:update(dt)
	self.legsAnim:rotate(self.LA)
	self.legsAnim:update(dt)
end

function Player:mousepressed(x, y, button)
	if button == "l" then
		self.shooting = true
	end
end

function Player:mousereleased(x, y, button)
	if button == "l" then
		self.shooting = false
	end
end
 
function Player:shoot()
	if self.clipAmmo > 0 then
		self.gunshotSound:play()
		local newBullet = Bullet:new(self.cx, self.cy, self.angle)
		newBullet:init()
		table.insert(self.bullets, newBullet)
		self.clipAmmo = self.clipAmmo - 1
		return true
	else 
		self.emptyclipSound:play()
		return false
	end
end

-- gets the angle from x1,y1 through to point x2,y2
function Player:angleTo(x2,y2)
	local x1 = self.cx - view.x
	local y1 = self.cy - view.y
	local x_v, y_v = 0

	local angle = math.atan2(y2 - y1, x2 - x1)
	if angle < 0 then angle = angle + math.pi * 2 end
	
	return math.deg(angle)
end

--return sign of v
function Player:signOf(v)	
	return v > 0 and 1 or (v < 0 and -1 or 0)
end

function Player:xyToTileType(x11,y11)
	w = math.floor( x11 / map.tileSize )
	h = math.floor( y11 / map.tileSize )
	--print("x:"..x11..",y:"..y11)
	--print("w:"..w..",h:"..h)
	return map.tiles[w][h].id
end

function Player:collideWithTile(x,y)
	local currentX = math.floor(self.cx/map.tileSize)
	local currentY = math.floor(self.cy/map.tileSize)
	local nextX = math.floor(x/map.tileSize)
	local nextY = math.floor(y/map.tileSize)
	local dx = nextX - currentX
	local dy = nextY - currentY
	
	if 	   (dx == 0) and (dy == -1) then 	self.ySpeed = 0
	elseif (dx == 1) and (dy == -1) then 	self.ySpeed = 0 self.xSpeed = 0
	elseif (dx == 1) and (dy == 0) then 	self.xSpeed = 0
	elseif (dx == 1) and (dy == 1) then 	self.ySpeed = 0 self.xSpeed = 0
	elseif (dx == 0) and (dy == 1) then 	self.ySpeed = 0
	elseif (dx == -1) and (dy == 1) then 	self.ySpeed = 0 self.xSpeed = 0
	elseif (dx == -1) and (dy == 0) then 	self.xSpeed = 0
	elseif (dx == -1) and (dy == -1) then 	self.ySpeed = 0 self.xSpeed = 0 end
end