--[[
This file contains the quantity class

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

local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''

-- Quantity class
local Unit = {}
Unit.__index = Unit

-- make Quantity callable
setmetatable(Unit, {
	__call = function(class, ...)
		return Unit.new(...)
	end
})

-- constructor
function Unit.new(...)
	local arg = {...}

	local u = {}
	setmetatable(u, Unit)

	-- copy constructor
	if #arg == 1 then
		local o = arg[1]
		u.basefactor = o.basefactor
		u.prefixfactor = o.prefixfactor
		u.tobase = o.tobase
		u.frombase = o.frombase
		u._term = o._term

	-- Unit.new(symbol, name, o, tobase, frombase)
	else

		if #arg > 1 then
			u.symbol = arg[1]
			u.name = arg[2]
			u._term = {{{u,1}},{}}
		else
			u._term = {{},{}}
		end

		if #arg > 2 then
			u.prefixfactor = arg[3].prefixfactor
			u.basefactor = arg[3].basefactor
		else
			u.prefixfactor = 1
			u.basefactor = 1
		end

		if #arg > 3 then
			u.tobase = arg[4]
			u.frombase = arg[5]
		end
	end

	return u
end


function Unit.__eq(o1,o2)
	if o1.basefactor ~= o2.basefactor then
		return false
	elseif o1.prefixfactor ~= o2.prefixfactor then
		return false
	end

	return true
end

function Unit.__mul(o1,o2)
	local u = Unit.new()

	u.prefixfactor = o1.prefixfactor * o2.prefixfactor
	u.basefactor = o1.basefactor * o2.basefactor

	u:_append(o1)
	u:_append(o2)

	if o1.tobase ~= nil and o1.frombase ~= nil then
		u.tobase = o1.tobase
		u.frombase = o1.frombase
	elseif o2.tobase ~= nil and o2.frombase ~= nil then
		u.tobase = o2.tobase
		u.frombase = o2.frombase
	end

	return u
end

function Unit.__div(o1,o2)
	local u = Unit.new()
	
	u.prefixfactor = o1.prefixfactor / o2.prefixfactor
	u.basefactor = o1.basefactor / o2.basefactor
	
	u:_append(o1)
	u:_append(o2, true)

	return u
end

function Unit.__pow(o,n)
	local u = Unit.new()
	
	u.prefixfactor = o.prefixfactor^n
	u.basefactor = o.basefactor^n

	-- invert the term
	if n < 0 then
		u:_append(o,true)
		n = -n
	else
		u:_append(o)
	end

	-- multiply term by factor n
	for i=1,2 do
		local part = u._term[i]
		for j=1,#part do
			part[j][2] = part[j][2] * n
		end
	end

	return u
end

--copy units from an other quantity
function Unit:_append(u, inversed)
	
	local s = {1,2}
	if inversed then
		s = {2,1}
	end

	for i=1,2 do
		local part = u._term[s[i]]
		local term = self._term[i]

		for j=1,#part do
			local unit = part[j][1]
			local exponent = part[j][2]

			term[#term + 1] = {unit, exponent}
		end
	end
end



-- convert quantity to a string
function Unit:__tostring()

	-- assemble unit strings
	local u = {{},{}}

	for i=1,2 do
		local units = self._term[i]

		for j=1,#units do
			local unit = units[j]
			local exponent = unit[2]

			if exponent ~= 0 then
				local symbol = unit[1].symbol

				local s = "_"

				if unit[1].prefix ~= nil then
					s = s..unit[1].prefix.symbol
				end

				if symbol ~= nil then
					s = s..symbol
				end

				if exponent ~= 1 then
					s = s.."^"..exponent
				end

				table.insert(u[i], s)
			end
		end
	end

	local str = ""

	-- write enumerator
	if #u[1] > 0 then
		str = str.." * "..table.concat(u[1], " * ")
	end

	-- write division sign
	if #u[2] > 0 then
		str = str.." / "
	end

	-- write denominator
	if #u[2] > 1 then
		str = str.."("..table.concat(u[2], " * ")..")"
	else
		str = str..table.concat(u[2], " * ")
	end

	return str
end



function Unit:tosiunitx()

	-- assemble unit strings
	local s = ""

	for i=1,2 do
		local units = self._term[i]

		for j=1,#units do
			local unit = units[j]
			local exponent = unit[2]

			if exponent ~= 0 then
				local name = unit[1].name
				--local prefix = unit[1]._prefix_symbol

				if i == 2 then
					s = s.."\\per"
				end

				--if prefix ~= nil then
				--	s = s.."\\"..Quantity._prefixes[prefix].name
				--end

				s = s.."\\"..name

				if exponent ~= 1 then
					s = s.."\\tothe{"..exponent.."}"
				end
			end
		end
	end

	return s
end


return Unit





