local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local N = require(prefix..'number')


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
Data.Isotope = {}

-- make the table callable
setmetatable(Data.Isotope, {
	__call = function(class, ...)
		return Data.Isotope.get(...)
	end
})


-- return table with values
function Data.Isotope.getKeys()
	local data = require(prefix..'isotope')

	local keys = {}

	local n = #data.keys
	for i=1,n do
		local key = data.keys[i]

		-- skip uncertainties
		if key:sub(1,1) ~= "d" or data.keys[key:sub(2)] == nil then
			keys[#keys+1] = key
		end
	end

	return keys
end


function Data.Isotope.getByName(isotope, key)
	local data = require(prefix..'isotope')

	local name, A   = string.match(isotope, "^([%a]+)%-([%d]+)$")
    if A ~= nil and name ~= nil then
    	A = tonumber(A)
    	Z = data.names[name]

    	if A ~= nil and Z ~= nil then
    		return Data.Isotope.getByAZ(A, Z, key)
    	end
    end

    local A,symbol   = string.match(isotope, "^([%d]+)([%a][%a])$")
    if A ~= nil and symbol ~= nil then
    	A = tonumber(A)
    	Z = data.symbols[symbol]

    	if A ~= nil and Z ~= nil then
    		return Data.Isotope.getByAZ(A, Z, key)
    	end
    end

    error("Isotope '"..isotope.."' not found in 'Data.Isotope'.")
end

function Data.Isotope.getByAZ(A, Z, key)
	local data = require(prefix..'isotope')

	-- get row number
	local i = data.index[tostring(A)..tostring(Z)]

	if i == nil then
		error("Isotope with (A,Z) = ("..tostring(A)..","..tostring(Z)..")  not found in 'Data.Isotope'.")
	end

	-- get all keys
	if key == nil then
		return Data.Isotope.getKeys()
	
	elseif key == "name" then
		if Z==0 then
			return "Neutronium-"..A
		else
			return data.names[Z].."-"..A
		end
	
	elseif key == "symbol" then
		if Z==0 then
			return "n-"..A
		else
			return data.symbols[Z].."-"..A
		end
	
	end

	-- other keys
	local row = data.data[i]

	local column = data.keys[key]
	local dcolumn = data.keys["d"..key] -- uncertainty

	if row[column] == nil then
		error("Key "..key.." not found in 'Data.Isotope'.")
	end

	-- assemble value
	local value = row[column]
	if dcolumn ~= nil  then
		value = N(row[column], row[dcolum])
	end

	local unit = data.units[column]
	if unit ~= "" then
		value = value * _G["_"..unit]
	end

	return value
end

function Data.Isotope.get(isotope,key)
	local data = require(prefix..'isotope')


	if type(isotope) == "string" then
		return Data.Isotope.getByName(isotope, key)

	elseif type(isotope) == "table" then
		local A = isotope[1]
		local Z = isotope[2]

		if type(A) == type(Z) and type(A) == "number" then
			return Data.Isotope.getByAZ(A, Z, key)
		end

	else

		local Akey = data.keys["A"]
		local Zkey = data.keys["Z"]
		
		local names = {}
		for _,row in ipairs(data.data) do
			local A = row[Akey]
			local Z = row[Zkey]

			if Z == 0 then
				names[#names+1] = tostring(A).."n"
			else
				names[#names+1] = tostring(A)..data.symbols[Z]
			end
		end
		return names 
	end

	return nil
end

return Data



