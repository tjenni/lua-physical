--[[
This file contains the methods for accessing physical data.

Copyright (c) 2020 Thomas Jenni

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
local N = require(prefix..'physical-number')


-- N class
local Data = {}
Data.__index = Data


--
-- ASTRONOMICAL DATA
--
Data.Astronomical = {}

-- make the table callable
setmetatable(Data.Astronomical, {
	__call = function(class, ...)
		return Data.Astronomical.get(...)
	end
})

function Data.Astronomical.get(name, key)
	local data = require(prefix..'physical-astronomical')

	-- return all names
	if name == nil then
		local names = {}
		for name,_ in pairs(data) do
			names[#names+1] = name
		end
		return names
	end

	if data[name] ~= nil then
		local row = data[name]

		-- return all keys
		if key == nil then
			local result = {}
			for key,_ in pairs(row) do
				result[key] = row[key]
			end
			return result
		end
		
		if row[key] ~= nil then
			return row[key] 
		end
	end

	return nil
end



--
-- ISOTOPE DATA
--
Data.Isotope = {}

-- make the table callable
setmetatable(Data.Isotope, {
	__call = function(class, ...)
		return Data.Isotope.get(...)
	end
})

-- get isotope data
--
-- 1) Get the mass excess of Helium-5 by the following commands
-- Data.Isotope("5He","MassExcess") or
-- Data.Isotope("5-He","MassExcess") or
-- Data.Isotope("5Helium","MassExcess") or
-- Data.Isotope("5-Helium","MassExcess") or
-- Data.Isotope("He5","MassExcess") or
-- Data.Isotope("He-5","MassExcess") or
-- Data.Isotope("Helium5","MassExcess") or
-- Data.Isotope("Helium-5","MassExcess")
--
-- 2) Get the mass excess of all helium isotopes
-- Data.Isotope("He","MassExcess") or
-- Data.Isotope("Helium","MassExcess")
-- 
-- 3) Get the half life of Lithium-3
-- Data.Isotope({3,3},"HalfLife")
--
-- 4) Get the half life of all isotopes
-- Data.Isotope(nil,"HalfLife")
-- 
-- 5) Get the names of all isotopes
-- Data.Isotope(nil,nil)

function Data.Isotope.get(isotope,key)
	local data = require(prefix..'physical-isotope')

	-- match 1) and 2) or 4)
	if type(isotope) == "string" then
		return Data.Isotope.getByName(isotope, key)

	-- match 3) or 4)
	elseif type(isotope) == "table" then
		local A = isotope[1]
		local Z = isotope[2]

		if type(A) == "number" and type(Z) == "number" then
			return Data.Isotope.getByAZ(A, Z, key)
		end

	-- match 5)
	else

		local Akey = data.keys["A"]
		local Zkey = data.keys["Z"]
		
		local names = {}
		for _,row in ipairs(data.data) do
			local A = row[Akey]
			local Z = row[Zkey]

			names[#names + 1] = tostring(A)..data.symbols[Z+1]
		end
		return names 
	end

	return nil
end


-- returns isotope data by the isotope name.
function Data.Isotope.getByName(isotope, key)
	local data = require(prefix..'physical-isotope')

	-- match "Helium-5", "Helium5", "He-5" or "He5"
	local name, A   = string.match(isotope, "^([%a]+)%-?([%d]+)$")
    if name ~= nil then
    	local Z = data.names[name]
    	if Z == nil then
    		Z = data.symbols[name]
    	end

    	A = tonumber(A)

    	if A ~= nil and Z ~= nil then
    		return Data.Isotope.getByAZ(A, Z, key)
    	end
    end 

    -- match "5-Helium", "5Helium", "5-He" or "5He5"
    local A,name   = string.match(isotope, "^([%d]+)%-?([%a]+)$")
    if name ~= nil then
    	local Z = data.names[name]
    	if Z == nil then
    		Z = data.symbols[name]
    	end

    	A = tonumber(A)

    	if A ~= nil and Z ~= nil then
    		return Data.Isotope.getByAZ(A, Z, key)
    	end
    end

    local name   = string.match(isotope, "^([%a]+)$")
    if name ~= nil then
    	local Z = data.names[name]
    	if Z == nil then
    		Z = data.symbols[name]
    	end

    	if Z ~= nil then
    		return Data.Isotope.getByZ(Z, key)
    	end
    end

    return nil
end


-- return isotopes with a certain A and Z
function Data.Isotope.getByAZ(A, Z, key)
	local data = require(prefix..'physical-isotope')

	-- get row number
	local i = data.indexAZ[tonumber(tostring(A)..tostring(Z))]
	if i == nil then
		error("Isotope with (A,Z) = ("..tostring(A)..","..tostring(Z)..")  not found in 'Data.Isotope'.")
	end

	return Data.Isotope._getValues(data.data[i],key)
end


-- return all isotope data with a certain Z
function Data.Isotope.getByZ(Z, key)
	local data = require(prefix..'physical-isotope')

	local Akey = data.keys["A"]

	local result = {}
	for _, i in ipairs(data.indexZ[Z+1]) do
		local name = tostring(data.data[i][Akey])..data.symbols[Z+1]
		result[name] = Data.Isotope._getValues(data.data[i],key)
	end
	
	return result
end


-- return key value pairs from a specific row
function Data.Isotope._getValues(row, keys)
	local data = require(prefix..'physical-isotope')

	if keys == nil then
		keys = data.keys

	elseif type(keys) == "string" then
		keys = {keys}

	elseif type(keys) ~= "table" then
		error("Unknown key type '"..tostring(key).."'.")
	end

	local result = {}
	for _,key in ipairs(keys) do

		-- name and symbol
		if key == "name" then
			result["name"] =  data.names[row[data.keys["Z"]] + 1].."-"..row[data.keys["A"]]

		elseif key == "symbol" then
			result["symbol"] = row[data.keys["A"]]..data.symbols[row[data.keys["Z"]] + 1]
		
		elseif key ~= "" then

			local i = data.keys[key]
			local di = data.dkeys[key]

			local x = row[i]
			local dx = row[di]

			-- invalid key
			if x == nil then
				error("Key "..key.." not found in 'Data.Isotope'.")
			end

			-- get value
			local value = x

			-- append uncertainty
			if type(x) == "number" and type(dx) == "number" then
				value = N(x, dx)
			end

			-- append unit
			local unit = data.units[i]
			if type(x)=="number" and unit ~= "" then
				value = value * _G["_"..unit]
			end

			result[key] = value
		end
	end

	if #keys == 1 then
		return result[keys[1]]
	else
		return result
	end
end


return Data



