--[[
The Dimension class keeps track of the dimenionality of a physical quantity.
It can be used to perform validity checks on mathematical operations such as 
addition and subtraction.

Copyright (c) 2021 Thomas Jenni

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
function Dimension.new(d)

	-- string
	if type(d) == "string" then
		return Dimension._index[d]
	end

	local e = {}
	setmetatable(e, Dimension)
	
	-- copy constructor
	if getmetatable(d) == Dimension then
		for i=1, #Dimension._base do
			e[i] = d[i] or 0
		end

	-- create zero dimension
	else
		for i=1, #Dimension._base do
			e[i] = 0
		end
	end
	
	return e
end


-- define a base new dimension
function Dimension.defineBase(symbol, name)

	local index = Dimension._index

	if index[name] ~= nil then
		error("Error: Base dimension '"..name.."' does already exist.")

	elseif index[symbol] ~= nil then
		error("Error: Base dimension '"..symbol.."' does already exist.")

	end

	-- create new dimension
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

	elseif getmetatable(o) ~= Dimension then
		error("Error. Object in definition of '"..name.."' is no dimension.")

	end

	index[name] = o

	return o
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


-- test if two dimensions are equal
function Dimension.__eq(d1, d2)
	for i=1, #Dimension._base do
		if d1[i] ~= d2[i] then
			return false
		end
	end

	return true
end


-- add two dimensions
function Dimension.__add(d1,d2)
	error("Error: Cannot add dimension objects.")
end


-- subtract two dimensions
function Dimension.__sub(d1,d2)
	error("Error: Cannot subtract dimension objects.")
end


-- multiply two dimensions
function Dimension.__mul(d1,d2)
	local d = Dimension.new(d1)

	for i=1, #Dimension._base do
		d[i] = d1[i] + d2[i]
	end

	return d
end


-- divide two dimensions
function Dimension.__div(d1,d2)
	local d = Dimension.new(d1)

	if type(d1) == "number" then
		for i=1, #Dimension._base do
			d[i] = 0 - d2[i]
		end
	else
		for i=1, #Dimension._base do
			d[i] = d1[i] - d2[i]
		end
	end

	return d
end


-- raise a dimension to the power 
function Dimension:__pow(n)
	if type(n) ~= "number" then
		error("Error: The exponent of the power operation has to be a number.")
	end

	local d = Dimension.new()

	for i=1, #Dimension._base do
		d[i] = self[i] * n
	end

	return d
end


-- convert dimension to a string
function Dimension:__tostring()

	local result = {}

	-- search for the name of the dimension
	for name,d in pairs(Dimension._index) do
		if d == self then
			result[#result + 1] = name
		end
	end

	if #result ~= 0 then
		return "["..table.concat(result,",").."]"
	end

	-- assemble dimension from base dimensions
	local base = Dimension._base
	for i=1,#base do
		if self[i] ~= 0 then
			local dim = "["..base[i].symbol.."]"

			if self[i] ~= 1 then
				dim = dim.."^"..self[i]
			end

			result[#result + 1]= dim
		end
	end

	return table.concat(result," ")

end

return Dimension