--[[
The Dimension class keeps track of the dimenionality of a physical quantity.
It can be used to perform validity checks on mathematical operations such as 
addition and subtraction.

Copyright (c) 2017 Thomas Jenni (tjenni@me.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local Dimension = {}
Dimension.__index = Dimension

-- make the table callable
setmetatable(Dimension, {
	__call = function(class, ...)
		return Dimension.new(...)
	end
})

-- index for the dimension names
Dimension._index = {}

-- registry for base dimensions
Dimension._base = {}

-- constructor
function Dimension.new(o)

	--string
	if type(o) == "string" then
		return Dimension._index[o]
	end

	local d = {}
	setmetatable(d, Dimension)
	
	-- copy constructor
	if getmetatable(o) == Dimension then
		for i=1, #Dimension._base do
			d[i] = o[i] or 0
		end

	-- create zero dimension
	else
		for i=1, #Dimension._base do
			d[i] = 0
		end
	end

	return d
end

-- define a base new dimension
function Dimension.defineBase(symbol, name)

	if Dimension._index[name] ~= nil then
		error("Error: Base dimension '"..name.."' does already exist.")
	end


	local base = Dimension._base

	local n = #base + 1
	local d = Dimension.new()
	d[n] = 1
	d.symbol = symbol

	-- add to registry
	base[n] = d

	-- resize all other base dimension vectors
	for i=1, n-1 do
		base[i][n] = 0
	end
	
	-- create index entry
	local index = Dimension._index
	if index[symbol] ~= nil or index[name] ~= nil then
		error("Error: Base dimension '"..name.."' does already exist.")
	end

	-- update index
	index[symbol] = d
	index[name] = d

	return d
end

-- define a new derived dimension
function Dimension.define(name, o)

	local index = Dimension._index

	if index[name] ~= nil then
		error("Error. Dimension '"..name.."' is already defined.")
	end

	index[name] = o

	return o
end

-- multiply two dimensions
function Dimension.__mul(o1,o2)
	local d = Dimension.new(o1)

	for i=1, #Dimension._base do
		d[i] = o1[i] + o2[i]
	end

	return d
end


-- divide two dimensions
function Dimension.__div(o1,o2)
	local d = Dimension.new(o1)

	if type(o1) == "number" then
		for i=1, #Dimension._base do
			d[i] = 0 - o2[i]
		end
	else
		for i=1, #Dimension._base do
			d[i] = o1[i] - o2[i]
		end
	end

	return d
end


-- raise a dimension to the power 
function Dimension.__pow(o, n)
	if type(n) ~= "number" then
		error("Error: The exponent of the power operation has to be a number.")
	end

	local d = Dimension.new()

	for i=1, #Dimension._base do
		d[i] = o[i] * n
	end

	return d
end

-- test if two dimensions are equal
function Dimension.__eq(o1, o2)
	for i=1, #Dimension._base do
		if o1[i] ~= o2[i] then
			return false
		end
	end

	return true
end

-- check if the dimension vector has length zero
function Dimension.iszero(o)
	for i=1,#Dimension._base do
		if o[i] ~= 0 then
			return false
		end
	end
	
	return true
end

-- convert dimension to a string
function Dimension.__tostring(o)

	local result = {}

	-- search for the name of the dimension
	for name,d in pairs(Dimension._index) do
		if d == o then
			result[#result + 1] = name
		end
	end

	if #result ~= 0 then
		return "["..table.concat(result,",").."]"
	end

	-- assemble dimension from base dimensions
	local base = Dimension._base
	for i=1,#base do
		if o[i] ~= 0 then
			local dim = "["..base[i].symbol.."]"

			if o[i] ~= 1 then
				dim = dim.."^"..o[i]
			end

			result[#result + 1]= dim
		end
	end

	return table.concat(result," ")

end

return Dimension