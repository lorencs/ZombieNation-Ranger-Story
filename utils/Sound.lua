Sound = {}

-- Constructor
function Sound:new()

    local object = {					
		raw = nil,
		sources = {},
		current = 0
	}

	setmetatable(object, { __index = Sound})		
	
    return object
end

function Sound:init(filename)
   self.raw = love.sound.newSoundData(filename)
   self.sources = { love.audio.newSource(self.raw, 'static') }
   self.current = 1
end

function Sound:play()
   local start, sources = self.current, self.sources
   repeat
      if sources[self.current]:isStopped() then
         love.audio.play(sources[self.current])
         return
      end
      self.current = self.current % #sources + 1
   until self.current == start

   -- no free sources available, create a new one
   self.current = #sources + 1
   sources[self.current] = love.audio.newSource(self.raw, 'static')
   love.audio.play(sources[self.current])
end