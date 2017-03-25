local prefix = ... and (...):match '(.-%.?)[^%.]+$' or ''
local N = require(prefix..'number')


-- N class
local Data = {}
Data.__index = Data

-- ASTRONOMICAL DATA
Data.Astronomical = {}

Data.Astronomical.Sun = {

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.9884e30, 0.0002e30) * _kg ,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(695700, 100) * _km,
}

Data.Astronomical.Mercury = {
	
	-- Mazarico, E., A. Genova, S. Goossens, F. G. Lemoine, G. A. Neumann, M. T. Zuber, 
	-- D. E. Smith, and S. C. Solomon (2014), The gravity field, orientation, and 
	-- ephemeris of Mercury from MESSENGER observations after three years in orbit, 
	-- J. Geophys. Res. Planets, 119, 2417–2436, doi:10.1002/2014JE004675.
	mass = N(3.30111e23, 0.00015e23) * _kg,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(2439.7, 1.0) * _km
}

Data.Astronomical.Venus = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(4.86728e24, 0.00049e24) * _kg,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(6051.8, 1.0) * _km
}

Data.Astronomical.Earth = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(5.9722e24, 0.0006e24) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(6378.1366, 0.0001) * _km
}

Data.Astronomical.Moon = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(7.34583e22, 0.00074e22) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(1737.4, 1) * _km
}

Data.Astronomical.Mars = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(6.41688e23, 0.00065e23) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(3396.19, 0.1) * _km
}

Data.Astronomical.Jupiter = {
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.89851e27, 0.00019e27) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(71492, 4) * _km
}

Data.Astronomical.Saturn = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(5.68455e26, 0.00057e26) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(60268, 4) * _km
}

Data.Astronomical.Uranus = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(8.68184e25, 0.00087e25) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(25559, 4) * _km
}

Data.Astronomical.Neptune = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.0243e26, 0.0001e26) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(24764, 15) * _km
}

Data.Astronomical.Pluto = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.45600e22, 0.00033e22) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(1195, 5) * _km
}

Data.Astronomical.Eris = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.670e22, 0.020e22) * _kg,
	
	--Source: http://meetingorganizer.copernicus.org/EPSC-DPS2011/EPSC-DPS2011-137-8.pdf
	radius = N(1163, 6)*_km,
	density = N(2.5, 0.05) * _g/_cm^3,
	albedo = N(0.96, 0.09) * _1
}

Data.Astronomical.Ceres = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(9.385e20, 0.060e20) * _kg
}

Data.Astronomical.Pallas = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(2.048e20, 0.060e20) * _kg
}

Data.Astronomical.Vesta = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(2.684e20, 0.06e20) * _kg
}





--
-- ISOTOPE DATA
--
Data.Isotopes = {}


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



