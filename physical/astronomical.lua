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
	
	-- http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(1.9884e30, 0.0002e30) * _kg,

	-- Andrej Prsa, Petr Harmanec, Guillermo Torres et al.
	-- Nominal values for selected solar and planetary quantities: IAU 2015 Resolution B3, 
	-- The Astronomical Journal, 2016, Vol. 152, No. 2, Page 41
	-- https://arxiv.org/pdf/1605.09788.pdf
	Radius = N(695658, 100) * _km,

	-- https://sites.google.com/site/mamajeksstarnotes/basic-astronomical-data-for-the-sun
	MeanRadiativeLuminosity = N(3.8275,0.0014) * 1e26 * _W,

	EffectiveTemperature = N(5772.0,0.8) * _K,

	SpectralType = "G2V",

	-- https://ssd.jpl.nasa.gov/?constants#pc
	MassParameter = N(1.32712440018e20,8e9) * _m^3 * _s^-2,
}

Astronomical.Mercury = {
	
	-- Mohr et al. 2016
	Mass = N(3.301110e23, 0.00015e23) * _kg,

	-- Perry et al. 2015
	AverageRadius = N(2439.36, 0.02) * _km,

	Density = N(5429.30, 0.28) * _kg/_m^3
}

Astronomical.Venus = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(4.86728e24, 0.00049e24) * _kg,

	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(6051.8, 1.0) * _km
}

Astronomical.Earth = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(5.9722e24, 0.0006e24) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(6378.1366, 0.0001) * _km
}

Astronomical.Moon = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(7.34583e22, 0.00074e22) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(1737.4, 1) * _km
}

Astronomical.Mars = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(6.41688e23, 0.00065e23) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(3396.19, 0.1) * _km
}

Astronomical.Jupiter = {
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(1.89851e27, 0.00019e27) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(71492, 4) * _km
}

Astronomical.Saturn = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(5.6846e26, 0.0006e26) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(60268, 4) * _km
}

Astronomical.Uranus = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(8.68184e25, 0.00087e25) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(25559, 4) * _km
}

Astronomical.Neptune = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(1.0243e26, 0.0001e26) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(24764, 15) * _km
}

Astronomical.Pluto = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(1.45600e22, 0.00033e22) * _kg,
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	EquatorialRadius = N(1195, 5) * _km
}

Astronomical.Eris = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(1.670e22, 0.019e22) * _kg,
	
	--Source: http://meetingorganizer.copernicus.org/EPSC-DPS2011/EPSC-DPS2011-137-8.pdf
	Radius = N(1163, 6)*_km,
	Density = N(2.5, 0.05) * _g/_cm^3,
	Albedo = N(0.96, 0.09) * _1
}

Astronomical.Ceres = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(9.39e20, 0.060e20) * _kg
}

Astronomical.Pallas = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(2.048e20, 0.060e20) * _kg
}

Astronomical.Vesta = {
	
	--Source: http://asa.usno.navy.mil/static/files/2014/Astronomical_Constants_2014.pdf
	Mass = N(2.684e20, 0.06e20) * _kg
}

return Astronomical
