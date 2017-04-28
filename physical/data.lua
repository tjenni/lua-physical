local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local N = require(prefix..'number')


-- N class
local Data = {}
Data.__index = Data


-- return table with values
function Data._getKeys(file)
	local table = require(prefix..file)
	local keys = {}

	local n = #table.keys
	for i=1,n do
		local key = table.keys[i]

		-- skip uncertainties
		if key:sub(1,1) ~= "d" or table.keys[key:sub(2)] == nil then
			keys[#keys+1] = key
		end
	end

	return keys
end

-- get the i'th row of the datafile
function Data._getRow(file, i)
	local table = require(prefix..file)

	local result = {}
	local row = table.rows[i]

	local keys = Data._getKeys(file)
	
	local n = #keys
	for j=1,n do
		local key = keys[j]
		local x = row[j]
			
		-- number
		if type(x) == "number" then
			-- check if the number has an uncertainty
			local dx = row[dkey]
			if type(dx) == "number"  then
				row[key] = N(x,dx)
			else
				row[key] = x
			end

			-- append unit to number
			local unit = table.units[i]
			if unit ~= "" then
				row[key] = row[key] * _G["_"..unit]
			end
		
		-- string
		elseif x ~= nil and x ~= "" then
			row[key] = x
		end
	end

	return row
end







-- ASTRONOMICAL DATA
Data.Astronomical = {}

-- make the table callable
setmetatable(Data.Astronomical, {
	__call = function(class, ...)
		return Data.Astronomical.get(...)
	end
})

function Data.Astronomical.get(name, key)
	local data = require(prefix..'astronomical')

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
			local keys = {}
			for key,_ in pairs(row) do
				keys[#keys+1] = key
			end
			return keys
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
Data.Isotopes = {}

-- make the table callable
setmetatable(Data.Isotopes, {
	__call = function(class, ...)
		return Data.Isotopes.get(...)
	end
})


function Data.Isotopes.get(a,b,c)
	local data = require(prefix..'isotope')

	-- A, Z, (key)
	if type(a) == type(b) == "number" then
		local I = Data.Isotopes._getByAZ(a,b)

		if I == nil then
			return nil
		end

		if type(c) == "string" then
			return Data.Isotopes._getValueByKey(I,c)
		else
			return Data.Isotopes._getValues(I)
		end
	end

	-- name, (key)
	if type(a) == "string" then
		local I = Data.Isotopes._getByName(a)

		if I == nil then
			return nil
		end

		if type(b) == "string" then
			return Data.Isotopes._getValueByKey(I,b)
		else
			return Data.Isotopes._getValues(I)
		end
	end
end

-- return table 
function Data.Isotopes._getValueByKey(I,key)
	return Data.Isotopes._getValues(I)[key] 
end

-- return table with isotope values
function Data.Isotopes._getValues(I)
	local data = require(prefix..'isotope')

	local J = {}

	local n = #data._keys
	for i=1,n do
		
		local key = data._keys[i]
		local di = data._keys["d"..key]

		-- skip uncertainties
		if key:sub(1,1) ~= "d" then

			local x = I[i]
			
			-- number
			if type(x) == "number" then
				local dx = I[di]

				if type(dx) == "number"  then
					J[key] = N(x,dx)
				else
					J[key] = x
				end

				local unit = data._units[i]


				if unit ~= "" then
					J[key] = J[key] * _G["_"..unit]
				end
			
			-- string
			elseif x ~= nil and x ~= "" then
				J[key] = x
			end
		end
	end

	local Z_key = data._keys["Z"]
	J.Symbol = data._symbols[I[Z_key]]
	J.Name = data._names[I[Z_key]]

	return J
end

-- find isotope
-- todo: create an hash table 99_101
function Data.Isotopes._getByAZ(A,Z)
	local data = require(prefix..'isotope')

	local A_key = data._keys["A"]
	local Z_key = data._keys["Z"]

	local I

	-- find isotope
	local n = #data._data
	for i=1,n do
		I = data._data[i]
		if I[A_key] == A and I[Z_key] == Z then
			return I
		end
	end

	return nil
end

function Data.Isotopes._getByName(str)
	local data = require(prefix..'isotope')

	local name, A   = string.match(str, "^([%a]+)%-([%d]+)$")
    if A ~= nil and name ~= nil then
    	A = tonumber(A)
    	Z = data._names[name]

    	if A ~= nil and Z ~= nil then
    		return Data.Isotopes._getByAZ(A,Z)
    	end
    end

    local A,symbol   = string.match(str, "^([%d]+)([%a][%a])$")
    if A ~= nil and symbol ~= nil then
    	A = tonumber(A)
    	Z = data._symbols[symbol]

    	if A ~= nil and Z ~= nil then
    		return Data.Isotopes._getByAZ(A,Z)
    	end
    end

   	return nil
end

return Data



