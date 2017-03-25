--[[
This file contains the number class which allows to do 
calcualtions with uncertainties.

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

-- Number class
local Number = {}
Number.__index = Number

-- make the table callable
setmetatable(Number, {
	__call = function(class, ...)
		return Number.new(...)
	end
})

-- convert to compact string, i.e. 5.67(8)
-- if false, the plus-minus notation is used, i.e. 5.67 +/- 0.08
Number.compact = true

-- number of digits of the uncertainty in the compact notation
-- i.e. 5.67(67) has two digits
Number.udigits = 2

-- uncertainty if an integer is given as a string
Number.integer_uncertainty = 0.5


-- constructor
function Number.new(x, dx)

	local n = {}
	setmetatable(n, Number)
	
	-- pure number without uncertainty
	if type(x) == "number" then
		n._x = x
		n._dx = dx or 0

		return n

	-- copy constructor
	elseif type(x) == "table" and getmetatable(x) == Number then
		n._x = x._x
		n._dx = x._dx

		return n

	-- number from string
	elseif type(x) == "string" then

		-- parse string of the form "3.4e-3"
		local m = tonumber(x)
		if  m ~= nil  then
			n._x = m

			local m1, m2, e = string.match(x,"^([^%s%.]*)%.?([^%seE]*)[eE]?([^%s]*)$")
			
			-- get exponent
			if e ~= "" then
				e = tonumber(e)
			else
				e = 0
			end

			-- calculate uncertainty
			n._dx = Number.integer_uncertainty * 10^e
			if m2 ~= "" then
				n._dx = n._dx * 10^(-string.len(m2))
			end
			
			return n
		end

		-- parse string of the form "5.4e-3 +/- 2.4e-6"
		local m1, m2 = string.match(x,"^([^%s]*)%s*%+%/%-%s*([^%s]*)$")
		if  m1 ~= nil  and m2 ~= nil then
			n._x = tonumber(m1)
			n._dx = tonumber(m2)
			
			return n
		end

		-- parse string of the form "5.45(7)e-23"
		local m1, m2, u, e = string.match(x,"^([^%s%.]*)%.?([^%seE]*)%(([0-9]+)%)[eE]?([^%s]*)$")
		if m1 ~= nil then

			n._x = tonumber(m1.."."..m2)
			n._dx = u * 10^(-string.len(m2))

			-- exponent
			if e ~= "" then
				n._x = n._x * 10^e
				n._dx = n._dx * 10^e
			end

			return n
		end

		print("Error: The string '".._x.."' cannot be converted to a physical.Number.")

		return nil

	-- default
	else
		n._x = 0
		n._dx = 0

		return n
	end

end




-- get mantissa and exponent in scientific notation
function Number._frexp(x)
	if x == 0 then
		return 0,0
	end

	local s = (x < 0 and -1) or 1
	local m = s * x
	local exp = math.floor(math.log(m,10))
	m = s * m / 10^exp

	return m, exp
end

-- convert number to a number
function Number:__tonumber()
	return self._x
end

-- convert number to a string
function Number:__tostring(compact,udigits)

	-- if the uncertainty is zero, print the exact number
	if self._dx == 0 then
		return tostring(self._x)
	end 

	if compact == nil then
		compact = Number.compact
	end
	if udigits == nil then
		udigits = Number.udigits
	end

	local dm, de = self._frexp(self._dx)

	-- parentheses notation, i.e. 5.45(7)e-23
	-- Source: http://physics.nist.gov/cgi-bin/cuu/Info/Constants/definitions.html
	if compact == true then
		local m, e = self._frexp(self._x)
		local digits = -(de-e-udigits+1)

		local str = string.format("%."..math.abs(digits).."f",m)

		if udigits > 0 then
			str = str.."("..string.format("%.0f",dm*10^(udigits-1))..")"
		end

		if e ~= 0 then
			str = str.."e"..e
		end

		return str

	-- +/- notation, i.e. 5.4e-3 +/- 2.4e-6
	else
		local digits = de
		if math.floor(dm) == 1 then
			digits = digits - 1
		end

		if digits >= 0 then
			return string.format("%.0f",self._x).." +/- "..string.format("%.0f",self._dx)
		else
			digits = -digits
			return string.format("%."..digits.."f",self._x).." +/- "..string.format("%."..digits.."f",self._dx)
		end
	end 
end


-- equal
-- Two physical numbers are equal if they have the same value and uncertainty
function Number.__eq(n1,n2)
	return n1._x == n2._x and n1._dx == n2._dx
end

-- less than
function Number.__lt(n1,n2)
	if getmetatable(n1) ~= Number then
		return n1 < n2._x

	elseif getmetatable(n2) ~= Number then
		return n1._x < n2

	else
		return n1._x < n2._x
	end
end

-- less equal
function Number.__le(n1,n2)

	if getmetatable(n1) ~= Number then
		return n1 <= n2._x

	elseif getmetatable(n2) ~= Number then
		return n1._x <= n2

	else
		return n1._x <= n2._x
	end

end


-- add two numbers
function Number.__add(n1,n2)
	local m = Number.new()

	if type(n1) == "number" then
		m._x = n1 + n2._x
		m._dx = n2._dx

	elseif type(n2) == "number" then
		m._x = n1._x + n2
		m._dx = n1._dx

	-- n1 an object
	elseif getmetatable(n1) ~= Number then
		return n1.__add(n1,n2)

	-- n2 an object
	elseif getmetatable(n2) ~= Number then
		return n2.__add(n1,n2)

	else
		m._x = n1._x + n2._x
		m._dx = (n1._dx^2 + n2._dx^2)^0.5
	end

	return m
end

-- subtract two numbers
function Number.__sub(n1,n2)
	local m = Number.new()

	if type(n1) == "number" then
		m._x = n1 - n2._x
		m._dx = n2._dx

	elseif type(n2) == "number" then
		m._x = n1._x - n2
		m._dx = n1._dx

	-- n1 an object
	elseif getmetatable(n1) ~= Number then
		return n1.__sub(n1,n2)

	-- n2 an object
	elseif getmetatable(n2) ~= Number then
		return n2.__sub(n1,n2)

	else
		m._x = n1._x - n2._x
		m._dx = (n1._dx^2 + n2._dx^2)^0.5
	end

	return m
end


-- unary minus
function Number.__unm(n1)
	local m = Number.new()

	m._x = -n1._x
	m._dx = n1._dx

	return m
end

-- multiplication
function Number.__mul(n1,n2)
	local m = Number.new()

	-- n1 float , n2 number
	if type(n1) == "number" then
		m._x = n1 * n2._x
		m._dx = n1 * n2._dx

	-- n1 number , o2 float
	elseif type(n2) == "number" then
		m._x = n1._x * n2
		m._dx = n1._dx * n2

	-- n1 an object
	elseif getmetatable(n1) ~= Number then
		return n1.__mul(n1,n2)

	-- n2 an object
	elseif getmetatable(n2) ~= Number then
		return n2.__mul(n1,n2)

	-- o1 number , o2 number
	else
		m._x = n1._x * n2._x
		m._dx = m._x * ((n1._dx/n1._x)^2 + (n2._dx/n2._x)^2)^0.5

	end

	return m
end


-- division
function Number.__div(n1,n2)
	local m = Number.new()

	-- n1 float , n2 number
	if type(n1) == "number" then
		m._x = n1 / n2._x
		m._dx = n2._dx * n1 / n2._x^2

	-- n1 number , o2 float
	elseif type(n2) == "number" then
		m._x = n1._x / n2
		m._dx = n1._dx / n2

	-- n1 an object
	elseif getmetatable(n1) ~= Number then
		return n1.__div(n1,n2)

	-- n2 an object
	elseif getmetatable(n2) ~= Number then
		return n2.__div(n1,n2)

	-- o1 number , o2 number
	else
		m._x = n1._x / n2._x
		m._dx = m._x * ((n1._dx/n1._x)^2 + (n2._dx/n2._x)^2)^0.5
	end

	return m
end


-- division
function Number.__pow(n1,n2)
	local m = Number.new()

	-- n1 float , n2 number
	if type(n1) == "number" then
		m._x = n1^n2._x
		m._dx = n2._dx * math.abs(math.log(n1)*n1^n2._x)

	-- n1 number , o2 float
	elseif type(n2) == "number" then
		m._x = n1._x^n2
		m._dx = n1._dx * math.abs(n2 * n1._x^(n2-1))

	-- n1 an object
	elseif getmetatable(n1) ~= Number then
		return n1.__pow(n1,n2)

	-- n2 an object
	elseif getmetatable(n2) ~= Number then
		return n2.__pow(n1,n2)

	-- o1 number , o2 number
	else
		m._x = n1._x^n2._x
		m._dx = n1._dx*math.abs(n2._x*n1._x^(n2._x-1)) + n2._dx*math.abs(math.log(n1._x)*n1._x^n2._x)
	end

	return m
end






-- calculate the absolute value
function Number.abs(n)
	local m = Number.new()

	m._x = math.abs(n._x)
	m._dx = n._dx

	return m
end

-- calculate the square root
function Number.sqrt(n)
	local m = Number.new()

	m._x = math.sqrt(n._x)
	m._dx = n._dx / (2*math.sqrt(n._x))

	return m
end

-- calculate the natural logarithm
function Number.log(n,base)
	local m = Number.new()

	if base == nil then
		m._x = math.log(n._x)
		m._dx = n._dx / math.abs(n._x)
	else
		m._x = math.log(n._x,base)
		m._dx = n._dx / math.abs(n._x*math.log(base))
	end

	return m
end


-- calculate the exponential function
function Number.exp(n)
	local m = Number.new()

	m._x = math.exp(n._x)
	m._dx = n._dx * math.exp(n._x)

	return m
end


-- TRIGONOMETRIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Trigonometric_functions

-- sine
function Number.sin(n)
	local m = Number.new()

	m._x = math.sin(n._x)
	m._dx = n._dx * math.abs(math.cos(n._x))

	return m
end

-- cosine
function Number.cos(n)
	local m = Number.new()

	m._x = math.cos(n._x)
	m._dx = n._dx * math.abs(math.sin(n._x))

	return m
end

-- tangent
function Number.tan(n)
	local m = Number.new()

	m._x = math.tan(n._x)
	m._dx = n._dx * math.abs(1/math.cos(n._x)^2)

	return m
end


-- INVERS TRIGONOMETRIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#arctan

-- invers sine
function Number.asin(n)
	local m = Number.new()

	m._x = math.asin(n._x)
	m._dx = n._dx * 1 / math.sqrt(1 - n._x^2)

	return m
end

-- inverse cosine
function Number.acos(n)
	local m = Number.new()

	m._x = math.acos(n._x)
	m._dx = n._dx * 1 / math.sqrt(1 - n._x^2)
	
	return m
end

-- inverse tangent
function Number.atan(n)
	local m = Number.new()

	m._x = math.atan(n._x)
	m._dx = n._dx / (1 + n._x^2)
	
	return m
end


-- HYPERBOLIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Hyperbolic_function

-- hyperbolic sine
function Number.sinh(n)
	local m = Number.new()

	m._x = 0.5 * math.exp(n._x) - 0.5 / math.exp(n._x)
	m._dx = n._dx * (0.5 * math.exp(n._x) + 0.5 / math.exp(n._x))

	return m
end

-- hyperbolic cosine
function Number.cosh(n)
	local m = Number.new()

	m._x = 0.5 * math.exp(n._x) + 0.5 / math.exp(n._x)
	m._dx = n._dx * (0.5 * math.exp(n._x) - 0.5 / math.exp(n._x))

	return m
end

-- hyperbolic tangent
function Number.tanh(n)
	local m = Number.new()

	m._x = (math.exp(n._x) - math.exp(-n._x)) / (math.exp(n._x) + math.exp(-n._x))
	m._dx = n._dx / (0.5 * math.exp(n._x) + 0.5 / math.exp(n._x))^2

	return m
end


-- INVERS HYPERBOLIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Inverse_hyperbolic_function

-- inverse hyperbolic sine
-- (-inf < n < +inf)
function Number.asinh(n)
	local m = Number.new()

	m._x = math.log(n._x + math.sqrt(n._x^2 + 1))
	m._dx = n._dx / math.sqrt(n._x^2 + 1)

	return m
end

-- inverse hyperbolic cosine
-- (1 < n)
function Number.acosh(n)
	local m = Number.new()

	m._x = math.log(n._x + math.sqrt(n._x^2 - 1))
	m._dx = n._dx / math.sqrt(n._x^2 - 1)

	return m
end

-- inverse hyperbolic tangent
-- (-1 < n < 1)
function Number.atanh(n)
	local m = Number.new()

	m._x = 0.5 * math.log((1 + n._x)/(1 - n._x))
	m._dx = n._dx / math.abs(n._x^2 - 1)

	return m
end



return Number


