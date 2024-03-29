--[[
This file contains the quantity class

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

local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local D = require(prefix..'physical-dimension')
local U = require(prefix..'physical-unit')
local N = require(prefix..'physical-number')

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

-- modes for the function tosiunitx()
Quantity.SIUNITX_qty = 0
Quantity.SIUNITX_num = 1
Quantity.SIUNITX_unit = 2


-- constructor
function Quantity.new(q)

	local p = {}
	setmetatable(p, Quantity)
	
	-- copy constructor
	if getmetatable(q) == Quantity then
		p.dimension = q.dimension
		p.value = q.value
		p.basefactor = q.basefactor
		p.unit = U(q.unit)

	-- create a dimensionless Quantity
	else
		p.dimension = D.new()
		p.value = q
		p.basefactor = 1
		p.unit = U()
	end
	
	return p
end


-- create base quantities
function Quantity.defineBase(symbol,name,dimension)

	if rawget(_G,"_"..symbol) ~= nil then
		error("Error: Quantity '_"..symbol.."' does already exist.")
	end

	local p = Quantity.new()
	p.value = 1
	p.dimension = dimension
	p.unit = U.new(symbol,name)

	table.insert(Quantity._base,p)
	
	rawset(_G, "_"..symbol, p)

	return p
end


-- create derived quantities
function Quantity.define(symbol, name, q)

	-- check if quantity does already exist
	if rawget(_G,"_"..symbol) ~= nil then
		error("Error: Quantity '_"..symbol.."' does already exist.")
	end

	-- check if given value is a quantity
	if getmetatable(q) ~= Quantity then
		error("Error: No quantity given in the definition of '"..name.."'.")
	end
	
	local p = Quantity.new(q)
	
	if name ~= nil then
		p.value = 1
		p.basefactor = q.basefactor * q.value
		p.unit = U.new(symbol, name)
	else
		local p = Quantity.new(q)
	end

	rawset(_G, "_"..symbol, p)

	return p
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
function Quantity.addPrefix(prefixes, qs)
	
	-- todo: what if prefixes and units are no lists?

	for i=1,#prefixes do
		local prefix = Quantity._prefixes[prefixes[i]]

		for j=1,#qs do
			local q = qs[j]

			local p = Quantity.new(q)
			p.unit = U.new(q.unit.symbol, q.unit.name, prefix.symbol, prefix.name)
			p.basefactor = p.basefactor*prefix.factor

			-- assert that unit does not exist
			local symbol = "_"..prefix.symbol..q.unit.symbol
			if rawget(_G,symbol) ~= nil then
				error("Error: Cannot create prefixed Quantity, because '"..symbol.."' does already exist.")
			end

			-- set unit as a global variable
			rawset(_G, symbol, p)
		end
	end
end


-- Add two quantities
function Quantity.__add(q1, q2)
	
	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end

	if q1.dimension ~= q2.dimension then
		error("Error: Cannot add '"..tostring(q1).."' to '"..tostring(q2).."', because they have different dimensions.")
	end

	-- convert o1 to q2 units
	local p = q1:to(q2)
	p.value =  p.value + q2.value

	return 	p
end


-- subtract a dimension from another one
function Quantity.__sub(q1, q2)

	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end

	if q1.dimension ~= q2.dimension then
		error("Error: Cannot subtract '"..tostring(q2).."' from '"..tostring(q1).."', because they have different dimensions.")
	end

	-- convert q1 to q2 units
	local p = q1:to(q2)
	p.value =  p.value - q2.value

	return 	p
end


-- unary minus
function Quantity.__unm(q)
	local p = Quantity.new(q)
	p.value = -p.value
	return p
end


-- multiply a dimension by a number
function Quantity.__mul(q1, q2)

	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end
	
	local p = Quantity.new()

	p.dimension = q1.dimension * q2.dimension
	p.value = q1.value * q2.value
	p.basefactor = q1.basefactor * q2.basefactor
	p.unit = q1.unit * q2.unit

	return p
end


-- divide a quantity / number by a quantity / number
function Quantity.__div(q1, q2)
	
	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end
	
	local p = Quantity.new()
	
	p.dimension = q1.dimension / q2.dimension
	p.value = q1.value / q2.value
	p.basefactor = q1.basefactor / q2.basefactor
	p.unit = q1.unit / q2.unit

	return p
end

-- power
function Quantity.__pow(q1,q2)

	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end

	if not q2.dimension:iszero() then
		error("Error: Cannot take the power of '"..tostring(q1).."', because the exponent '"..tostring(q2).."' is not dimensionless.")
	end

	local p = Quantity.new()
	local e = q2:to()

	p.value = q1.value^e.value
	
	e = e:__tonumber()
	p.dimension = q1.dimension^e
	p.basefactor = q1.basefactor^e
	p.unit = q1.unit^e
	
	return p
end

-- test if two quantities are equal
function Quantity.__eq(q1,q2)

	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end
	
	local p = q1:to(q2)

	if p.value ~= q2.value then
		return false
	elseif p.dimension ~= q2.dimension then
		return false
	elseif p.basefactor ~= q2.basefactor then
		return false
	end

	return true
end

-- check if this quantity is less than another one
function Quantity.__lt(q1,q2)

	if getmetatable(q1) ~= Quantity then
		q1 = Quantity.new(q1)
	end
	if getmetatable(q2) ~= Quantity then
		q2 = Quantity.new(q2)
	end

	if q1.dimension ~= q2.dimension then
		error("Error: Cannot compare '"..tostring(q1).."' to '"..tostring(q2).."', because they have different dimensions.")
	end

	return q1:to().value < q2:to().value
end

-- check if this quantity is close to another one. r is the maximal relative deviation.
function Quantity:isclose(q, r)

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	if getmetatable(r) ~= Quantity then
		r = Quantity.new(r)
	end

	if self.dimension ~= q.dimension then
		error("Error: Cannot compare '"..tostring(self).."' to '"..tostring(q)..", because they have different dimensions.")
	end
	if not r.dimension:iszero() then
		error("Error. The argument '"..tostring(r).."' of the isclose function is not unitless.")
	end
	
	local q1 = self:to():__tonumber()
	local q2 = q:to():__tonumber()
	local r = r:to():__tonumber()
	
	local delta = math.abs(q1 - q2)
	local min = math.min(math.abs(q1),math.abs(q2))
	return  (delta / min) <= r
end


-- convert quantity to another unit
function Quantity:to(q)

	local p = Quantity.new()

	-- convert to base units
	p.dimension = self.dimension
	p.value = self.value * self.basefactor

	-- convert to target units
	if q ~= nil then
		if getmetatable(q) ~= Quantity then
			q = Quantity.new(q)
		end

		if self.dimension ~= q.dimension then
			error("Error: Cannot convert '"..tostring(self).."' to '"..tostring(q).."', because they have different dimensions.")
		end

		p.value = p.value / q.basefactor
		p.basefactor = q.basefactor
		p.unit = U(q.unit)
	
	-- convert to base units
	else
		local unit = U.new()
		local base = Quantity._base

		for i=1,#base do
			unit = unit * base[i].unit^self.dimension[i]
		end
		
		p.unit = unit
	end

	return p
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
function Quantity:tosiunitx(param,mode)

	mode = mode or self.SIUNITX_qty
	param = param or ""

	if param ~= "" then
		param = "["..param.."]"
	end

	if mode == Quantity.SIUNITX_qty then
		if type(self.value) == "number" then
			return "\\qty"..param.."{"..tostring(self.value).."}".."{"..self.unit:tosiunitx().."}"
		else
			return "\\qty"..param.."{"..self.value:tosiunitx().."}".."{"..self.unit:tosiunitx().."}"
		end

	elseif mode == Quantity.SIUNITX_num then
		if type(self.value) == "number" then
			return "\\num"..param.."{"..tostring(self.value).."}"
		else
			return "\\num"..param.."{"..self.value:tosiunitx().."}"
		end

	elseif mode == Quantity.SIUNITX_unit then
		return "\\unit"..param.."{"..self.unit:tosiunitx().."}"

	else
		error("Error: Unknown mode '"..tostring(mode).."'.")
	end

end


-- minimum value
function Quantity.min(q,...)
	
	for _,p in ipairs({...}) do
		if p < q then
			q = p
		end
    end

    return Quantity.new(q)
end


-- maximum value
function Quantity.max(q,...)
	
	for _,p in ipairs({...}) do
		if p > q then
			q = p
		end
    end

    return Quantity.new(q)
end


-- absolute value
function Quantity.abs(q)
	
	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	if q.value < 0 then
		return -q
	else
		return q
	end
end


-- square root
function Quantity.sqrt(q)

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	return q^0.5
end


-- logarithm
function Quantity.log(q, base)

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the logarithm function is not unitless.")
	end

	
	local b = nil
	if base ~= nil then
		if getmetatable(base) ~= Quantity then
			base = Quantity.new(base)
		end

		b = base:to():__tonumber()
	end


	local p = Quantity.new()

	if type(q.value) == "number" then
		p.value = math.log(q:to().value, b)
	else
		p.value = q:to().value:log(b)
	end

	return p
end


-- exponential function
function Quantity.exp(q)

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the sine function is not unitless.")
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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the cosine function is not unitless.")
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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

	if not q.dimension:iszero() then
		error("Error. The argument '"..tostring(q).."' of the tangent function is not unitless.")
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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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

	if getmetatable(q) ~= Quantity then
		q = Quantity.new(q)
	end

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