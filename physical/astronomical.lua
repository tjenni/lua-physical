--[[
Astronomical data

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
local N = require(prefix..'number')

local Astronomical = {}

Astronomical.Sun = {

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.9884e30, 0.0002e30) * _kg ,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(695700, 100) * _km,
}

Astronomical.Mercury = {
	
	-- Mazarico, E., A. Genova, S. Goossens, F. G. Lemoine, G. A. Neumann, M. T. Zuber, 
	-- D. E. Smith, and S. C. Solomon (2014), The gravity field, orientation, and 
	-- ephemeris of Mercury from MESSENGER observations after three years in orbit, 
	-- J. Geophys. Res. Planets, 119, 2417–2436, doi:10.1002/2014JE004675.
	mass = N(3.30111e23, 0.00015e23) * _kg,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(2439.7, 1.0) * _km
}

Astronomical.Venus = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(4.86728e24, 0.00049e24) * _kg,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(6051.8, 1.0) * _km
}

Astronomical.Earth = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(5.9722e24, 0.0006e24) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(6378.1366, 0.0001) * _km
}

Astronomical.Moon = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(7.34583e22, 0.00074e22) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(1737.4, 1) * _km
}

Astronomical.Mars = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(6.41688e23, 0.00065e23) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(3396.19, 0.1) * _km
}

Astronomical.Jupiter = {
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.89851e27, 0.00019e27) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(71492, 4) * _km
}

Astronomical.Saturn = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(5.6846e26, 0.0006e26) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(60268, 4) * _km
}

Astronomical.Uranus = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(8.68184e25, 0.00087e25) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(25559, 4) * _km
}

Astronomical.Neptune = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.0243e26, 0.0001e26) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(24764, 15) * _km
}

Astronomical.Pluto = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.45600e22, 0.00033e22) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	radius_eq = N(1195, 5) * _km
}

Astronomical.Eris = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(1.670e22, 0.019e22) * _kg,
	
	--Source: http://meetingorganizer.copernicus.org/EPSC-DPS2011/EPSC-DPS2011-137-8.pdf
	radius = N(1163, 6)*_km,
	density = N(2.5, 0.05) * _g/_cm^3,
	albedo = N(0.96, 0.09) * _1
}

Astronomical.Ceres = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(9.39e20, 0.060e20) * _kg
}

Astronomical.Pallas = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(2.048e20, 0.060e20) * _kg
}

Astronomical.Vesta = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	mass = N(2.684e20, 0.06e20) * _kg
}

return Astronomical
