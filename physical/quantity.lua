--[[
This file contains the quantity class

Copyright (c) 2018 Thomas Jenni (tjenni@me.com)

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

local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local D = require(prefix..'dimension')
local U = require(prefix..'unit')
local N = require(prefix..'number')

-- Quantity class
local Quantity = {}
Quantity.__index = Quantity

-- make Quantity table callable
setmetatable(Quantity, {
	__call = function(class, ...)
		return Quantity.new(...)
	end
})


-- registry for base units
Quantity._base = {}

-- registry for prefixes
Quantity._prefixes = {}


-- constructor
function Quantity.new(o)

	local q = {}
	setmetatable(q, Quantity)
	
	-- copy constructor
	if getmetatable(o) == Quantity then
		q.dimension = o.dimension
		q.value = o.value
		q.unit = o.unit

	-- create a dimensionless Quantity
	else
		q.dimension = D.new()
		q.value = o or 1
		q.unit = U.new()
	end

	return q
end


-- create base quantities
function Quantity.defineBase(symbol,name,dimension)

	if rawget(_G,"_"..symbol) ~= nil then
		error("Error: Quantity '_"..symbol.."' does already exist.")
	end

	local q = Quantity.new()
	q.value = 1
	q.dimension = dimension
	q.unit = U.new(symbol,name)

	table.insert(Quantity._base,q)
	
	rawset(_G, "_"..symbol, q)

	return q
end


-- create derived quantities
function Quantity.define(symbol, name, o, tobase, frombase)

	-- check if quantity does already exist
	if rawget(_G,"_"..symbol) ~= nil then
		error("Error: Quantity '_"..symbol.."' does already exist.")
	end

	-- check if given value is a quantity
	if getmetatable(o) ~= Quantity then
		error("Error: No quantity given in the definition of '"..name.."'.")
	end

	local q = Quantity.new() 
	q.value = 1
	q.dimension = o.dimension
	q.unit = U.new(symbol, name, o.unit, tobase, frombase) 
	q.unit.basefactor = q.unit.basefactor * o.value

	rawset(_G, "_"..symbol, q)

	return q
end

-- define a prefix
function Quantity.definePrefix(symbol,name,factor)

	-- check if prefix does already exist
	if Quantity._prefixes[symbol] ~= nil then
		error("Error: Prefix '"..symbol.."' does already exist.")
	end

	-- append prefix to the _prefixes table
	Quantity._prefixes[symbol] = {
		symbol=symbol,
		name=name, 
		factor=factor
	}
end


-- create prefixed versions of the given units
function Quantity.addPrefix(prefixes, units)
	-- todo: what if prefixes and units are no lists?

	for i=1,#prefixes do
		local prefix = Quantity._prefixes[prefixes[i]]

		for j=1,#units do
			local unit = units[j]

			local q = Quantity.new(unit)

			q.value = unit.value
			q.dimension = unit.dimension
			q.unit = U.new(unit.unit.symbol, unit.unit.name)
			q.unit.basefactor = unit.unit.basefactor
			q.unit.prefix = prefix
			q.unit.prefixfactor = prefix.factor

			-- assert that unit does not exist
			local symbol = "_"..prefix.symbol..unit.unit.symbol
			if rawget(_G,symbol) ~= nil then
				error("Error: Cannot create prefixed Quantity, because '"..symbol.."' does already exist.")
			end

			-- set unit as a global variable
			rawset(_G, symbol, q)
		end
	end
end




-- Add two quantities
function Quantity.__add(o1, o2)
	
	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)
	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end

	if o1.dimension ~= o2.dimension then
		error("Error: Cannot add "..o2.." to "..o1..".")
	end

	-- convert o1 to o2 units
	local q = o1:to(o2)
	q.value =  q.value + o2.value

	return 	q
end

-- subtract a dimension from another one
function Quantity.__sub(o1, o2)

	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)
	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end

	if o1.dimension ~= o2.dimension then
		error("Error: Cannot subtract "..o2.." from "..o1..".")
	end

	-- convert o1 to o2 units
	local q = o1:to(o2)
	q.value =  q.value - o2.value

	return 	q
end

-- unary minus
function Quantity.__unm(o)
	local q = Quantity.new(o)
	
	q.value = -q.value

	return q
end


-- multiply a dimension by a number
function Quantity.__mul(o1, o2)

	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)

	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end
	
	local q = Quantity.new()
	q.dimension = o1.dimension * o2.dimension
	q.unit = o1.unit * o2.unit
	q.value = o1.value * o2.value

	if o1.unit.tobase ~= nil and o2.dimension:iszero() then
		q.unit.tobase = o1.unit.tobase
		q.unit.frombase = o1.unit.frombase
		
	elseif o2.unit.tobase ~= nil and o1.dimension:iszero() then
		q.unit.tobase = o2.unit.tobase
		q.unit.frombase = o2.unit.frombase

	end

	return q
end


-- divide a quantity / number by a quantity / number
function Quantity.__div(o1, o2)
	
	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)
	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end

	local q = Quantity.new()
	q.dimension = o1.dimension / o2.dimension
	q.unit = o1.unit / o2.unit
	q.value = o1.value / o2.value

	if o1.unit.tobase ~= nil and o2.dimension:iszero() then
		q.unit.tobase = o1.unit.tobase
		q.unit.frombase = o1.unit.frombase
	end

	return q
end

-- power
function Quantity.__pow(o1,o2)

	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)
	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end

	if not o2.dimension:iszero() then
		error("Error: Cannot take the power, because the exponent "..o2.." is not dimensionless.")
	end

	local q = Quantity.new()
	local e = o2:to()

	q.value = o1.value^e.value

	e = e:__tonumber()
	q.dimension = o1.dimension^e
	q.unit = o1.unit^e
	
	return q
end

-- test if two quantities are equal
function Quantity.__eq(o1,o2)

	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)
	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end
	
	local q = o1:to(o2)

	if q.value ~= o2.value then
		return false

	elseif q.dimension ~= o2.dimension then
		return false

	elseif q.unit ~= o2.unit then
		return false
	end

	return true
end

-- check if this quantity is less than another one
function Quantity.__lt(o1,o2)

	if getmetatable(o1) ~= Quantity then
		o1 = Quantity.new(o1)
	elseif getmetatable(o2) ~= Quantity then
		o2 = Quantity.new(o2)
	end

	if o1.unit.dimension ~= o2.unit.dimension then
		error("Error: Cannot compare "..o1.." to "..o2..".")
	end

	return o1:to().value < o2:to().value
end




-- convert quantity to another unit
function Quantity:to(o, usefunction)

	usefunction = false or usefunction

	local q = Quantity.new()

	-- convert to base units
	q.dimension = self.dimension
	q.value = self.value * self.unit.prefixfactor
	
	-- call convertion function
	if type(self.unit.tobase) == "function" and usefunction then
		q = self.unit.tobase(q)
	else
		q.value = q.value * self.unit.basefactor
	end

	-- convert to target units
	if o ~= nil then
		if self.dimension ~= o.dimension then
			error("Error: Cannot convert '"..tostring(self).."' to '"..tostring(o).."'.")
		end

		-- call convertion function
		if type(o.unit.frombase) == "function" and usefunction then
			q = o.unit.frombase(q)
		else
			q.value = q.value / o.unit.basefactor
		end

		q.value = q.value / o.unit.prefixfactor
		q.unit = o.unit
	
	-- convert to base units
	else
		local unit = U.new()
		local base = Quantity._base

		for i=1,#base do
			unit = unit * base[i].unit^self.dimension[i]
		end

		q.unit = unit
	end
	return q
end





-- convert quantity to a number
function Quantity:__tonumber()
	if type(self.value) == "number" then
		return self.value
	else
		return self.value:__tonumber()
	end
end


-- convert quantity to a string
function Quantity:__tostring()
	return tostring(self.value)..tostring(self.unit)
end

-- convert quantity to an siunitx expression
function Quantity:tosiunitx(param)

	local str = "\\SI"

	if param ~= nil then
		str = str.."["..param.."]"
	end

	if type(self.value) == "number" or getmetatable(self.value) == N then
		str = str.."{"..tostring(self.value).."}{"..self.unit:tosiunitx().."}"
	else
		error("Can not convert quantity to an siunitx command.")
	end

	return str
end

-- convert quantity to an siunitx si expression
function Quantity:tosiunitxsi(param)

	local str = "\\si"

	if param ~= nil then
		str = str.."["..param.."]"
	end

	str = str.."{"..self.unit:tosiunitx().."}"
	
	return str
end


-- convert quantity to an siunitx num expression
function Quantity:tosiunitxnum(param)

	local str = "\\num"

	if param ~= nil then
		str = str.."["..param.."]"
	end

	if type(self.value) == "number" or getmetatable(self.value) == N then
		str = str.."{"..tostring(self.value).."}"
	else
		error("Can not convert quantity to an siunitx command.")
	end

	return str
end

-- check if this quantity is close to another one. r is the maximal relative deviation.
function Quantity:isclose(o, r)

	if getmetatable(o) ~= Quantity then
		o = Quantity.new(o)
	end

	if self.dimension ~= o.dimension then
		error("Error: Cannot compare '"..tostring(self).."' to '"..tostring(o).."'.")
	end
	
	local q1 = self:to()
	local q2 = o:to()
	
	local delta = Quantity.abs(q1 - q2):__tonumber()
	local min = Quantity.min(Quantity.abs(q1),Quantity.abs(q2)):__tonumber()
	return  (delta / min) < r
end

-- minimum value
function Quantity.min(o1,o2)

	local q1 = Quantity.new(o1)
	local q2 = Quantity.new(o2)

	local value1, value2
	if type(q1.value) == "number" then
		value1 = q1.value
	else
		value1 = o1:__tonumber()
	end

	if type(q2.value) == "number" then
		value2 = q2.value
	else
		value2 = o2:__tonumber()
	end

	if value1 < value2 then
		return q1
	else
		return q2
	end
end

-- minimum value
function Quantity.max(o1,o2)

	local q1 = Quantity.new(o1)
	local q2 = Quantity.new(o2)

	local value1, value2
	if type(q1.value) == "number" then
		value1 = q1.value
	else
		value1 = o1:__tonumber()
	end

	if type(q2.value) == "number" then
		value2 = q2.value
	else
		value2 = o2:__tonumber()
	end

	if value1 > value2 then
		return q1
	else
		return q2
	end
end


-- absolute value
function Quantity.abs(q)
	p = Quantity.new(q)
	if p.value < 0 then
		return -p
	else
		return p
	end
end

-- square root
function Quantity.sqrt(q)
	return q^0.5
end

-- logarithm
function Quantity.log(q, base)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the logarithm function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		if base == nil then
			p.value = math.log(q:to().value)
		else
			p.value = math.log(q:to().value,base)
		end
	else
		p.value = q:to().value:log(base)
	end

	return p
end


-- exponential function
function Quantity.exp(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the exponential function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.exp(q:to().value)
	else
		p.value = q:to().value:exp()
	end

	return p
end


-- TRIGONOMETRIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Trigonometric_functions

-- sine
function Quantity.sin(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the sine function is not unitless nor an angle.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.sin(q:to().value)
	else
		p.value = q:to().value:sin()
	end

	return p
end

-- cosine
function Quantity.cos(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the cosine function is not unitless nor an angle.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.cos(q:to().value)
	else
		p.value = q:to().value:cos()
	end

	return p
end

-- tangent
function Quantity.tan(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the tangent function is not unitless nor an angle.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.tan(q:to().value)
	else
		p.value = q:to().value:tan()
	end
	
	return p
end


-- arcus sine
function Quantity.asin(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the arcus sine function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.asin(q:to().value)
	else
		p.value = q:to().value:asin()
	end
	
	return p
end

-- arcus cosine
function Quantity.acos(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the arcus cosine function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.acos(q:to().value)
	else
		p.value = q:to().value:acos()
	end
	
	return p
end

-- arcus tangent
function Quantity.atan(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the arcus tangent function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.atan(q:to().value)
	else
		p.value = q:to().value:atan()
	end
	
	return p
end



-- HYPERBOLIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Hyperbolic_function

-- hyperbolic sine
function Quantity.sinh(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the sine hyperbolicus function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = 0.5 * math.exp(q.value) - 0.5 / math.exp(q.value)
	else
		p.value = q:to().value:sinh()
	end
	
	return p
end

-- hyperbolic cosine
function Quantity.cosh(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the cosine hyperbolicus function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = 0.5 * math.exp(q.value) + 0.5 / math.exp(q.value)
	else
		p.value = q:to().value:cosh()
	end
	
	return p
end

-- hyperbolic tangent
function Quantity.tanh(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the tangent hyperbolicus function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = (math.exp(q.value) - math.exp(-q.value)) / (math.exp(q.value) + math.exp(-q.value))
	else
		p.value = q:to().value:tanh()
	end
	
	return p
end


-- INVERS HYPERBOLIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Inverse_hyperbolic_function

-- inverse hyperbolic sine
-- (-inf < q < +inf)
function Quantity.asinh(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the inverse sine hyperbolicus function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.log(q.value + math.sqrt(q.value^2 + 1))
	else
		p.value = q:to().value:asinh()
	end
	
	return p
end

-- inverse hyperbolic cosine
-- (1 < q)
function Quantity.acosh(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the inverse cosine hyperbolicus function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.log(q.value + math.sqrt(q.value^2 - 1))
	else
		p.value = q:to().value:acosh()
	end
	
	return p
end

-- inverse hyperbolic tangent
-- (-1 < q < 1)
function Quantity.atanh(q)
	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the inverse tangent hyperbolicus function is not unitless.")
	end

	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = 0.5 * math.log((1 + q.value)/(1 - q.value))
	else
		p.value = q:to().value:atanh()
	end
	
	return p
end




return Quantity

