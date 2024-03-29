--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012 Kenny Shields --
--]]------------------------------------------------

-- button class
button = class("button", base)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function button:initialize()
	
	self.type           = "button"
	self.text           = "Button"
	self.width          = 80
	self.height         = 25
	self.internal       = false
	self.down           = false
	self.clickable      = true
	self.enabled        = true
	self.OnClick        = nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function button:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	self:CheckHover()
	
	local hover       = self.hover
	local down        = self.down
	local hoverobject = loveframes.hoverobject
	local parent      = self.parent
	local base        = loveframes.base
	local update      = self.Update
	
	if not hover then
		self.down = false
	else
		if hoverobject == self then
			self.down = true
		end
	end
	
	if not down and hoverobject == self then
		self.hover = true
	end
	
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
function button:draw()
	
	local visible = self.visible
	
	if not visible then
		return
	end

	local skins	        = loveframes.skins.available
	local skinindex	    = loveframes.config["ACTIVESKIN"]
	local defaultskin   = loveframes.config["DEFAULTSKIN"]
	local selfskin      = self.skin
	local skin          = skins[selfskin] or skins[skinindex]
	local drawfunc      = skin.DrawButton or skins[defaultskin].DrawButton
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
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function button:mousepressed(x, y, button)

	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	
	if hover and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	
		self.down = true
		loveframes.hoverobject = self
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function button:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover     = self.hover
	local down      = self.down
	local clickable = self.clickable
	local enabled   = self.enabled
	local onclick   = self.OnClick
	
	if hover and down and clickable and button == "l" then
		if enabled then
			if onclick then
				onclick(self, x, y)
			end
		end
	end
	
	self.down = false

end

--[[---------------------------------------------------------
	- func: keypressed(key)
	- desc: called when the player presses a key
--]]---------------------------------------------------------
function button:keypressed(key, unicode)
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local selectedobject = loveframes.selectedobject
	local onclick        = self.OnClick
	
	if key == "return" and selectedobject == self then
		onclick(self, 0, 0)
	end

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function button:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function button:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object can be clicked or not
--]]---------------------------------------------------------
function button:SetClickable(bool)

	self.clickable = bool
	
end

--[[---------------------------------------------------------
	- func: GetClickable(bool)
	- desc: gets whether the object can be clicked or not
--]]---------------------------------------------------------
function button:GetClickable()

	return self.clickable
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object is enabled or not
--]]---------------------------------------------------------
function button:SetEnabled(bool)

	self.enabled = bool
	
end

--[[---------------------------------------------------------
	- func: GetEnabled()
	- desc: gets whether the object is enabled or not
--]]---------------------------------------------------------
function button:GetEnabled()

	return self.enabled
	
end