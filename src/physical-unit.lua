--[[
This file contains the unit class. It task is keeping 
track of the unit terms.

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

-- Unit class
local Unit = {}
Unit.__index = Unit

-- make Unit callable
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

	-- Unit.new()
	if #arg == 0 then
		u._term = {{},{}}
		u.prefixsymbol = nil
		u.prefixname = nil

	-- copy constructor
	elseif #arg == 1 then
		local o = arg[1]

		-- check if given object is a unit
		if getmetatable(o) ~= Unit then
			error("Error: Cannot create a copy of the object, because it's not a unit.")
		end

		u.prefixsymbol = o.prefixsymbol
		u.prefixname = o.prefixname
		u._term = o._term

	-- Unit.new(symbol, name)
	elseif #arg == 2 then
		u.symbol = arg[1]
		u.name = arg[2]
		u._term = {{{u,1}},{}}

	-- Unit.new(symbol, name, prefixsymbol, prefixname)
	elseif #arg == 4 then
		u.symbol = arg[1]
		u.name = arg[2]
		u.prefixsymbol = arg[3]
		u.prefixname = arg[4]
		u._term = {{{u,1}},{}}

	else
		error("Cannot create physical.Unit. Wrong number of arguments.")
		return nil
	end

	return u
end

function Unit.__mul(o1,o2)
	local u = Unit.new()

	u:_append(o1)
	u:_append(o2)

	return u
end

function Unit.__div(o1,o2)
	local u = Unit.new()

	u:_append(o1)
	u:_append(o2, true)

	return u
end

function Unit.__pow(o,n)
	local u = Unit.new()

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

				if unit[1].prefixsymbol ~= nil then
					s = s..unit[1].prefixsymbol
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

-- convert the unit to a unit string which can be read from the latex package siunitx.
function Unit:tosiunitx()

	local s = ""

	for i=1,2 do
		local units = self._term[i]

		for j=1,#units do
			local unit = units[j]
			local e = unit[2]

			if e ~= 0 then
				
				if i == 2 then
					s = s.."\\per"
				end

				if unit[1].prefixname ~= nil then
					s = s.."\\"..unit[1].prefixname
				end

				s = s.."\\"..unit[1].name

				if e ~= 1 then
					s = s.."\\tothe{"..e.."}"
				end
			end
		end
	end

	return s
end


return Unit





