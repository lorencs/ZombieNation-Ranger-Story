--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012 Kenny Shields --
--]]------------------------------------------------

-- progressbar class
image = class("image", base)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function image:initialize()

	self.type           = "image"
	self.width          = 0
	self.height         = 0
	self.orientation    = 0
	self.scalex         = 1
	self.scaley         = 1
	self.offsetx        = 0
	self.offsety        = 0
	self.shearx         = 0
	self.sheary         = 0
	self.internal       = false
	self.image          = nil
	self.imagecolor     = nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function image:update(dt)

	local visible      = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	local parent = self.parent
	local base   = loveframes.base
	local update = self.Update
	
	-- move to parent if there is a parent
	if parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if update then
		update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function image:draw()
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local skins         = loveframes.skins.available
	local skinindex     = loveframes.config["ACTIVESKIN"]
	local defaultskin   = loveframes.config["DEFAULTSKIN"]
	local selfskin      = self.skin
	local skin          = skins[selfskin] or skins[skinindex]
	local drawfunc      = skin.DrawImage or skins[defaultskin].DrawImage
	local draw          = self.Draw
	local drawcount     = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
end

--[[---------------------------------------------------------
	- func: SetImage(image)
	- desc: sets the object's image
--]]---------------------------------------------------------
function image:SetImage(image)

	if type(image) == "string" then
		self.image = love.graphics.newImage(image)
	else
		self.image = image
	end
	
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
		
end

--[[---------------------------------------------------------
	- func: GetImage()
	- desc: gets the object's image
--]]---------------------------------------------------------
function image:GetImage()

	return self.image
	
end

--[[---------------------------------------------------------
	- func: SetColor(table)
	- desc: sets the object's color 
--]]---------------------------------------------------------
function image:SetColor(data)

	self.imagecolor = data
	
end

--[[---------------------------------------------------------
	- func: GetColor()
	- desc: gets the object's color 
--]]---------------------------------------------------------
function image:GetColor()

	return self.imagecolor
	
end

--[[---------------------------------------------------------
	- func: SetOrientation(orientation)
	- desc: sets the object's orientation
--]]---------------------------------------------------------
function image:SetOrientation(orientation)

	self.orientation = orientation
	
end

--[[---------------------------------------------------------
	- func: GetOrientation()
	- desc: gets the object's orientation
--]]---------------------------------------------------------
function image:GetOrientation()

	return self.orientation
	
end

--[[---------------------------------------------------------
	- func: SetScaleX(scalex)
	- desc: sets the object's x scale
--]]---------------------------------------------------------
function image:SetScaleX(scalex)

	self.scalex = scalex
	
end

--[[---------------------------------------------------------
	- func: GetScaleX()
	- desc: gets the object's x scale
--]]---------------------------------------------------------
function image:GetScaleX()

	return self.scalex
	
end

--[[---------------------------------------------------------
	- func: SetScaleY(scaley)
	- desc: sets the object's y scale
--]]---------------------------------------------------------
function image:SetScaleY(scaley)

	self.scaley = scaley
	
end

--[[---------------------------------------------------------
	- func: GetScaleY()
	- desc: gets the object's y scale
--]]---------------------------------------------------------
function image:GetScaleY()

	return self.scaley
	
end

--[[---------------------------------------------------------
	- func: SetScale(scalex, scaley)
	- desc: sets the object's x and y scale
--]]---------------------------------------------------------
function image:SetScale(scalex, scaley)

	self.scalex = scalex
	self.scaley = scaley
	
end

--[[---------------------------------------------------------
	- func: GetScale()
	- desc: gets the object's x and y scale
--]]---------------------------------------------------------
function image:GetScale()

	return self.scalex, self.scaley
	
end

--[[---------------------------------------------------------
	- func: SetOffsetX(x)
	- desc: sets the object's x offset
--]]---------------------------------------------------------
function image:SetOffsetX(x)

	self.offsetx = x
	
end

--[[---------------------------------------------------------
	- func: GetOffsetX()
	- desc: gets the object's x offset
--]]---------------------------------------------------------
function image:GetOffsetX()

	return self.offsetx
	
end

--[[---------------------------------------------------------
	- func: SetOffsetY(y)
	- desc: sets the object's y offset
--]]---------------------------------------------------------
function image:SetOffsetY(y)

	self.offsety = y
	
end

--[[---------------------------------------------------------
	- func: GetOffsetY()
	- desc: gets the object's y offset
--]]---------------------------------------------------------
function image:GetOffsetY()

	return self.offsety
	
end

--[[---------------------------------------------------------
	- func: SetOffset(x, y)
	- desc: sets the object's x and y offset
--]]---------------------------------------------------------
function image:SetOffset(x, y)

	self.offsetx = x
	self.offsety = y
	
end

--[[---------------------------------------------------------
	- func: GetOffset()
	- desc: gets the object's x and y offset
--]]---------------------------------------------------------
function image:GetOffset()

	return self.offsetx, self.offsety
	
end

--[[---------------------------------------------------------
	- func: SetShearX(shearx)
	- desc: sets the object's x shear
--]]---------------------------------------------------------
function image:SetShearX(shearx)

	self.shearx = shearx
	
end

--[[---------------------------------------------------------
	- func: GetShearX()
	- desc: gets the object's x shear
--]]---------------------------------------------------------
function image:GetShearX()

	return self.shearx
	
end

--[[---------------------------------------------------------
	- func: SetShearY(sheary)
	- desc: sets the object's y shear
--]]---------------------------------------------------------
function image:SetShearY(sheary)

	self.sheary = sheary
	
end

--[[---------------------------------------------------------
	- func: GetShearY()
	- desc: gets the object's y shear
--]]---------------------------------------------------------
function image:GetShearY()

	return self.sheary
	
end

--[[---------------------------------------------------------
	- func: SetShear(shearx, sheary)
	- desc: sets the object's x and y shear
--]]---------------------------------------------------------
function image:SetShear(shearx, sheary)

	self.shearx = shearx
	self.sheary = sheary
	
end

--[[---------------------------------------------------------
	- func: GetShear()
	- desc: gets the object's x and y shear
--]]---------------------------------------------------------
function image:GetShear()

	return self.shearx, self.sheary
	
end