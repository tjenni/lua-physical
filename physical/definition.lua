--[[
This file contains the definitions for the dimensions, the prefixes,
SI units, Imperial and US units

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
local D = require(prefix..'dimension')

-- Base Dimensions
local L = D.defineBase("L", "Length")
local M = D.defineBase("M", "Mass")
local T = D.defineBase("T", "Time")
local I = D.defineBase("I", "Electric Current")
local K = D.defineBase("θ", "Temperature")
local N = D.defineBase("N", "Amount of Substance")
local J = D.defineBase("J", "Luminous Intensity")

-- Other Dimensions
D.define("Dimensionless", D())
D.define("Area", L^2)
D.define("Volume", L^3)
D.define("Frequency", T^-1)
D.define("Density", L^-3 * M)
D.define("Velocity", L * T^-1)
D.define("Acceleration", L * T^-2)
D.define("Force", L * M * T^-2)
D.define("Energy", L^2 * M * T^-2)
D.define("Torque", L^2 * M * T^-2)
D.define("Power", L^2 * M * T^-3)
D.define("Pressure", L^-1 * M * T^-2)
D.define("Impulse", L * M * T^-1)
D.define("Absorbed Dose", L^2 * T^-2)
D.define("Heat Capacity", L^2 * M * T^-2 * K^-1)
D.define("Specific Heat Capacity", L^2 * T^-2 * K^-1)
D.define("Angular Momentum", L^2 * M * T^-1)
D.define("Moment of Inertia", L^2 * M)
D.define("Entropy", L^2 * M * T^-2 * K^-1)
D.define("Thermal Conductivity", L * M * T^-3 * K^-1)
D.define("Electric Charge", T * I)
D.define("Electric Permittivity", L^-3 * M^-1 * T^4 * I^2)
D.define("Electric Field Strength", L * M * T^-3 * I^-1)
D.define("Electric Potential", L^2 * M * T^-3 * I^-1)
D.define("Electric Resistance", L^2 * M * T^-3 * I^-2)
D.define("Electric Conductance", L^-2 * M^-1 * T^3 * I^2)
D.define("Electric Capacitance", L^-2 * M^-1 * T^4 * I^2)
D.define("Electric Inductance", L^2 * M * T^-2 * I^-2)
D.define("Magnetic Permeability", L * M * T^-2 * I^-2)
D.define("Magnetic Field Strength", L^-1 * I)
D.define("Magnetic Flux", L^2 * M * T^-2 * I^-1)
D.define("Magnetic Flux Density", M * T^-2 * I^-1)
D.define("Intensity", M * T^-3)
D.define("Reaction Rate", L^-3 * T^-1 * N)
D.define("Catalytic Activity", T^-1 * N)
D.define("Chemical Potential", L^2 * M * T^-2 * N^-1)
D.define("Molar Concentration", L^-3 * N)
D.define("Molar Heat Capacity", L^2 * M * T^-2 * K^-1 * N^-1)
D.define("Illuminance", L^-2 * J)




local Q = require(prefix..'quantity')
local U = require(prefix..'unit')


-- SI Prefixes
Q.definePrefix("Y", "yotta", 1e24)
Q.definePrefix("Z", "zetta", 1e21)
Q.definePrefix("E", "exa", 1e18)
Q.definePrefix("P", "peta", 1e15)
Q.definePrefix("T", "tera", 1e12)
Q.definePrefix("G", "giga", 1e9)
Q.definePrefix("M", "mega", 1e6)
Q.definePrefix("k", "kilo", 1e3)
Q.definePrefix("h", "hecto", 1e2)
Q.definePrefix("da","deca", 1e1)
Q.definePrefix("d", "deci", 1e-1)
Q.definePrefix("c", "centi", 1e-2)
Q.definePrefix("m", "milli", 1e-3)
Q.definePrefix("u", "micro", 1e-6)
Q.definePrefix("n", "nano", 1e-9)
Q.definePrefix("p", "pico", 1e-12)
Q.definePrefix("f", "femto", 1e-15)
Q.definePrefix("a", "atto", 1e-18)
Q.definePrefix("z", "zepto", 1e-21)
Q.definePrefix("y", "yocto", 1e-24)

local SI_prefixes = {"y","z","a","f","p","n","u","m","c","d","da","h","k","M","G","T","P","E","Z","Y"}

-- IEC Prefixes
Q.definePrefix("Yi", "yobi", 1208925819614629174706176)
Q.definePrefix("Zi", "zebi", 1180591620717411303424)
Q.definePrefix("Ei", "exbi", 1152921504606846976)
Q.definePrefix("Pi", "pebi", 1125899906842624)
Q.definePrefix("Ti", "tebi", 1099511627776)
Q.definePrefix("Gi", "gibi", 1073741824)
Q.definePrefix("Mi", "mebi", 1048576)
Q.definePrefix("Ki", "kibi", 1024)
 
local IEC_prefixes = {"Ki","Mi","Gi","Ti","Pi","Ei","Zi","Yi"}


-- Mathematical Constants
Pi 	 = 3.1415926535897932384626433832795028841971693993751
e    = 2.7182818284590452353602874713526624977572470936999

Q.define("1", "number", 1)

-- SI Base Units
Q.defineBase("m", "meter", L)
Q.defineBase("kg", "kilogram", M)
Q.defineBase("s", "second", T)
Q.defineBase("A", "ampere", I)
Q.defineBase("K", "kelvin", K)
Q.defineBase("mol", "mole", N)
Q.defineBase("cd", "candela",  J)

Q.addPrefix(SI_prefixes,{_m,_s,_A,_K,_mol,_cd})

-- SI Derived Units
Q.define("g", "gram", 0.001*_kg)
Q.define("Hz", "hertz", 1/_s)
Q.define("N", "newton", _kg*_m/_s^2)
Q.define("Pa", "pascal", _N/_m^2)
Q.define("J", "joule", _N*_m)
Q.define("W", "watt", _J/_s)

-- Remark: Don't create the unit kilogram twice
Q.addPrefix({"y","z","a","f","p","n","u","m","c","d","da","h","M","G","T","P","E","Z","Y"},{_g})
Q.addPrefix(SI_prefixes,{_Hz,_N,_Pa,_J,_W})

Q.define("C", "coulomb", _A*_s)
Q.define("V", "volt", _J/_C)
Q.define("F", "farad", _C/_V)
Q.define("Ohm", "ohm", _V/_A)
Q.define("S", "siemens", _A/_V)
Q.define("Wb", "weber", _V*_s)
Q.define("T", "tesla", _Wb/_m^2)
Q.define("H", "henry", _Wb/_A)

-- Remark: Don't create "peta siemens" because its symbol is the same for "Pferdestaerke", a common german unit for power.
Q.addPrefix({"y","z","a","f","p","n","u","m","c","d","da","h","M","G","T","E","Z","Y"},{_S})
Q.addPrefix(SI_prefixes,{_C,_V,_F,_Ohm,_Wb,_T,_H})

-- Others
Q.define("lm", "lumen", _cd*_sr)
Q.define("lx", "lux", _lm/_m^2)
Q.define("Bq", "becquerel", 1/_s)
Q.define("Gy", "gray", _J/_kg)
Q.define("Sv", "sievert", _J/_kg)
Q.define("kat", "katal", _mol/_s)

Q.addPrefix(SI_prefixes,{_lm,_lx,_Bq,_Gy,_Sv,_kat})

-- Temperature
Q.define(
	"degC", 
	"celsius",
	_K, 
	function(q)
		q.value = q.value + 273.15
		return q
	end,
	function(q)
		q.value = q.value - 273.15
		return q
	end
)




-- PHYSICAL CONSTANTS
-- ******************
-- Source: https://en.wikipedia.org/wiki/Physical_constant
-- Source: https://arxiv.org/pdf/1510.07674.pdf

local N = require(prefix..'number')

-- Universal
Q.define("c", "speedoflight", 299792458 * _m/_s)
Q.define("Gc", "gravitationalconstant", N(6.67408e-11,0.00031e-11) * _m^3/(_kg*_s^2))
Q.define("h_P", "planckconstant", N(6.626070040e-34, 0.000000081e-34 ) * _J*_s)
Q.define("h_Pbar", "reducedplanckconstant", _h_P/(2*Pi))

-- Electrodynamic
Q.define("e", "elementarycharge", N(1.6021766208e-19, 0.0000000098e-19) * _C)
Q.define("u_0", "vacuumpermeability", 4e-7*Pi * _N/_A^2)
Q.define("e_0", "vacuumpermitivity", 1/(_u_0*_c^2))
Q.define("u", "atomicmass", N(1.66053904e-27, 0.00000002e-27) * _kg)
Q.define("m_e", "electronmass", N(9.10938356e-31, 0.00000011e-31) * _kg)
Q.define("m_p", "protonmass", N(1.672621898e-27, 0.000000021e-27) * _kg)
Q.define("m_n", "neutronmass", N(1.674927471e-27, 0.000000021e-27) * _kg)

Q.define("u_B", "bohrmagneton", _e*_h_Pbar/(2*_m_e))
Q.define("u_N", "nuclearmagneton", _e*_h_Pbar/(2*_m_p))

Q.define("u_e", "electronmagneticmoment", N(-928.4764620e-26,0.0000057e-26) * _J/_T)
Q.define("u_p", "protonmagneticmoment", N(1.4106067873e-26,0.0000000097e-26) * _J/_T)
Q.define("u_n", "neutronmagneticmoment", N(-0.96623650e-26,0.00000023e-26) * _J/_T)

Q.define("alpha", "finestructureconstant", _u_0*_e^2*_c/(2*_h_P))
Q.define("Ry", "rydbergconstant", _alpha^2*_m_e*_c/(2*_h_P))

-- Thermodynamic
Q.define("N_A", "avogadronumber", N(6.022140857e23, 0.000000074e23)/_mol)
Q.define("k_B", "boltzmannconstant", N(1.38064852e-23, 0.00000079e-23) * _J/_K)
Q.define("R", "molargasconstant", N(8.3144598, 0.0000048) * _J/(_K*_mol))

-- Others
Q.define("sigma", "stefanboltzmannconstant", Pi^2*_k_B^4/(60*_h_Pbar^3*_c^2))
Q.define("g_0", "standardgravity", 9.80665 * _m/_s^2)
Q.define("r_sun", "nominalsolarradius", 695700 * _km)



-- NON-SI UNITS BUT ACCEPTED FOR USE WITH THE SI
-- *********************************************
-- Source: http://physics.nist.gov/cuu/Units/outside.html
-- http://m.convert-me.com/en/convert/area/township.html?u=township&v=1
-- https://www.nist.gov/pml/nist-guide-si-appendix-b9-factors-units-listed-kind-quantity-or-field-science

-- Volume
Q.define("L", "liter", 0.001*_m^3)
Q.define("tsp", "metricteaspoon", 0.005*_L)
Q.define("Tbsp", "metrictablespoon", 3*_tsp)

Q.addPrefix(SI_prefixes,{_L})

-- Time
Q.define("min", "minute", 60*_s)
Q.define("h", "hour", 60*_min)
Q.define("d", "day", 24*_h)
Q.define("wk", "week", 7*_d)
Q.define("a", "year", 365.25*_d)

-- Angular
Q.define("rad", "radian", 1 )
Q.define("sr", "steradian", _rad^2 )
Q.define("deg", "degree", (Pi/180)*_rad)
Q.define("arcmin", "arcminute", _deg/60)
Q.define("arcsec", "arcsecond", _arcmin/60)
Q.define("gon", "gradian", (Pi/200)*_rad)
Q.define("tr", "turn", 2*Pi*_rad)
Q.define("sp", "spat", 4*Pi*_sr)

-- Astronomical
Q.define("au", "astronomicalunit", 149597870700*_m)
Q.define("ly", "lightyear", _c*_a)
Q.define("pc", "parsec", (648000/Pi)*_au)

Q.addPrefix(SI_prefixes, {_ly,_pc})

--force
Q.define("kp", "kilopond", _kg*_g_0)

-- Pressure
Q.define("bar", "bar", 100000*_Pa)
Q.define("atm", "standardatmosphere", 101325*_Pa)
Q.define("at", "technicalatmosphere", _kp/_cm^2)
Q.define("mmHg", "millimeterofmercury", 133.322387415*_Pa)
Q.define("Torr", "torr", (101325/760)*_Pa)

Q.addPrefix({"m"}, {_bar,_Torr})

-- Heat
-- Source: https://www.nist.gov/pml/nist-guide-si-appendix-b9-factors-units-listed-kind-quantity-or-field-science
Q.define("cal", "thermochemicalcalorie", 4.184*_J)
Q.define("cal_IT", "internationalcalorie", 4.1868*_J)

Q.addPrefix({"k"}, {_cal,_cal_IT})

Q.define("g_TNT", "gramoftnt", 1e3 * _cal)
Q.addPrefix({"k","M","G","T","P"}, {_g_TNT})

Q.define("t_TNT", "tonoftnt", 1e9 * _cal)
Q.addPrefix({"u","m","k","M","G"}, {_t_TNT})

-- Electrical
Q.define("VA", "voltampere", _V * _A)
Q.define("Ah", "amperehour", _A*_h)

Q.addPrefix(SI_prefixes,{_VA,_Ah})

-- Information units
Q.define("bit", "bit", 1)
Q.define("bps", "bitpersecond", 1/_s)
Q.define("B", "byte", 8*_bit)

Q.addPrefix(IEC_prefixes,{_bit,_B,_bps})
Q.addPrefix({"k","M","G","T","P","E","Z","Y"},{_bit,_B,_bps})

-- Others
Q.define("percent", "percent", 0.01)
Q.define("permille", "permille", 0.001)
Q.define("t", "tonne", 1000*_kg)
Q.define("barn", "barn", 1e-28*_m^2)
Q.define("angstrom", "angstrom", 1e-10*_m)
Q.define("eV", "electronvolt", _e*_V)
Q.define("Wh", "watthour", _W * _h)
Q.define("PS", "metrichorsepower", 75*_g_0*_kg*_m/_s)
Q.define("Ci", "curie", 3.7e10*_Bq)
Q.define("Rad", "rad", 0.01*_Gy)
Q.define("rem", "rem", 0.01*_Sv)
Q.define("Ro", "roentgen", 2.58e-4*_C/_kg)

Q.addPrefix(SI_prefixes,{_eV, _Wh, _barn})



-- IMPERIAL UNITS
-- **************

-- Length
Q.define("in", "inch", 0.0254*_m)
Q.define("th", "thou", 0.001*_in)
Q.define("pica", "pica", _in/6)
Q.define("pt", "point", _in/72)
Q.define("hh", "hand", 4*_in)
Q.define("ft", "foot", 12*_in)
Q.define("yd", "yard", 3*_ft)
Q.define("rd", "rod", 5.5*_yd)
Q.define("ch", "chain", 4*_rd)
Q.define("fur", "furlong", 10*_ch)
Q.define("mi", "mile", 8*_fur) -- int. mile
Q.define("lea", "league", 3*_mi)

-- International Nautical Units
Q.define("nmi", "nauticalmile", 1852 * _m)
Q.define("nlea", "nauticalleague", 3*_nmi)
Q.define("cbl", "cable", _nmi/10)
Q.define("ftm", "fathom", 6*_ft)
Q.define("kn", "knot", _nmi/_h)

-- Area
Q.define("ac", "acre", 43560*_ft^2)

-- Volume
Q.define("gal", "gallon", 4.54609*_L)
Q.define("qt", "quart", _gal/4)
Q.define("pint", "pint", _qt/2)
Q.define("cup", "cup", _pint/2)
Q.define("gi", "gill", _pint/4)
Q.define("fl_oz", "fluidounce", _gi/5)
Q.define("fl_dr", "fluiddram", _fl_oz/8)

-- Mass (Avoirdupois)

Q.define("gr", "grain", 64.79891*_mg)
Q.define("lb", "pound", 7000*_gr)
Q.define("oz", "ounce", _lb/16)
Q.define("dr", "dram", _lb/256)
Q.define("st", "stone", 14*_lb)
Q.define("qtr", "quarter", 2*_st)
Q.define("cwt", "hundredweight", 4*_qtr)
Q.define("ton", "longton", 20*_cwt)

-- Mass (Troy)

Q.define("lb_t", "troypound", 5760*_gr)
Q.define("oz_t", "troyounce", _lb_t/12)
Q.define("dwt", "pennyweight", 24*_gr)

-- Mass (Other)

Q.define("fir", "firkin", 56*_lb)

-- Time
Q.define("ftn", "fortnight", 14*_d)

-- Temperature
Q.define(
	"degF", 
	"fahrenheit", 
	(5/9)*_K,
	function(q)
		q.value = (q.value + 459.67)*(5/9)
		return q
	end,
	function(q)
		q.value = (9/5)*q.value - 459.67
		return q
	end
)
Q.define("degR", "rankine", (5/9)*_K)



-- Others
Q.define("lbf", "poundforce", _lb*_g_0)
Q.define("pdl", "poundal", _lb*_ft/_s^2)
Q.define("slug", "slug", _lbf*_s^2/_ft)
Q.define("psi", "psi", _lbf/_in^2)
Q.define("BTU", "thermochemicalbritishthermalunit", (1897.83047608/1.8)*_J) -- = c_th * lb * °F
Q.define("BTU_it", "internationalbritishthermalunit", 1055.05585262*_J) -- = c_IT * lb * °F
Q.define("hp", "horsepower", 33000*_ft*_lbf/_min)



-- US CUSTOMARY UNITS
-- ******************

-- Length
Q.define("in_US", "ussurveyinch", _m/39.37)
Q.define("hh_US", "ussurveyhand", 4*_in_US)
Q.define("ft_US", "ussurveyfoot", 3*_hh_US)
Q.define("li_US", "ussurveylink", 0.66*_ft_US)
Q.define("yd_US", "ussurveyyard", 3*_ft_US)
Q.define("rd_US", "ussurveyrod", 5.5*_yd_US)
Q.define("ch_US", "ussurveychain", 4*_rd_US)
Q.define("fur_US", "ussurveyfurlong", 10*_ch_US)
Q.define("mi_US", "ussurveymile", 8*_fur_US)
Q.define("lea_US", "ussurveyleague", 3*_mi_US)
Q.define("ftm_US", "ussurveyfathom", 72*_in_US)
Q.define("cbl_US", "ussurveycable", 120*_ftm_US)

-- Area
Q.define("ac_US", "ussurveyacre", _ch_US*_fur_US)

-- Volume
Q.define("gal_US", "usgallon", 231*_in^3)
Q.define("qt_US", "usquart", _gal_US/4)
Q.define("pint_US", "uspint", _qt_US/2)
Q.define("cup_US", "uscup", _pint_US/2)
Q.define("gi_US", "usgill", _pint_US/4)
Q.define("fl_oz_US", "usfluidounce", _gi_US/4)
Q.define("Tbsp_US", "ustablespoon", _fl_oz_US/2)
Q.define("tsp_US", "usteaspoon", _Tbsp_US/3)
Q.define("fl_dr_US", "usfluiddram", _fl_oz_US/8)

-- Mass
Q.define("qtr_US", "usquarter", 25*_lb)
Q.define("cwt_US", "ushundredweight", 4*_qtr_US)
Q.define("ton_US", "uston", 20*_cwt_US)




