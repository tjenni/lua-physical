--[[
This file contains the definitions for dimensions, prefixes,
SI, Imperial and U.S. Survey units

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
local U = require(prefix..'unit')
local Q = require(prefix..'quantity')


-- define base dimensions
local L = D.defineBase("L", "Length")
local M = D.defineBase("M", "Mass")
local T = D.defineBase("T", "Time")
local I = D.defineBase("I", "Electric Current")
local K = D.defineBase("θ", "Temperature")
local N = D.defineBase("N", "Amount of Substance")
local J = D.defineBase("J", "Luminous Intensity")
local C = D.defineBase("C", "Currency")

-- define derived dimensions
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


-- define SI prefixes
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

-- define IEC prefixes
Q.definePrefix("Yi", "yobi", 1208925819614629174706176)
Q.definePrefix("Zi", "zebi", 1180591620717411303424)
Q.definePrefix("Ei", "exbi", 1152921504606846976)
Q.definePrefix("Pi", "pebi", 1125899906842624)
Q.definePrefix("Ti", "tebi", 1099511627776)
Q.definePrefix("Gi", "gibi", 1073741824)
Q.definePrefix("Mi", "mebi", 1048576)
Q.definePrefix("Ki", "kibi", 1024)
 
local IEC_prefixes = {"Ki","Mi","Gi","Ti","Pi","Ei","Zi","Yi"}


-- define mathematical constants
Pi 	 = 3.1415926535897932384626433832795028841971693993751
e    = 2.7182818284590452353602874713526624977572470936999

-- define mathematical functions
abs = Q.abs
min = Q.min
max = Q.max

sqrt = Q.sqrt
exp = Q.exp
log = Q.log

sin = Q.sin
cos = Q.cos
tan = Q.tan

asin = Q.asin
acos = Q.acos
atan = Q.atan

sinh = Q.sinh
cosh = Q.cosh
tanh = Q.tanh

asinh = Q.asinh
acosh = Q.acosh
atanh = Q.atanh

-- define dimensionless base quantity
Q.define("1", "number", Q(1))

-- define SI Base Units
Q.defineBase("m", "meter", L)
Q.defineBase("kg", "kilogram", M)
Q.defineBase("s", "second", T)
Q.defineBase("A", "ampere", I)
Q.defineBase("K", "kelvin", K)
Q.defineBase("mol", "mole", N)
Q.defineBase("cd", "candela",  J)

Q.addPrefix(SI_prefixes,{_m,_s,_A,_K,_mol,_cd})

-- define the euro as the base currency unit
Q.defineBase("EUR", "euro",  C)
Q.define("cEUR", "eurocent", 0.01*_EUR)

-- define SI derived units
Q.define("g", "gram", 0.001*_kg)
Q.define("Hz", "hertz", 1/_s)
Q.define("N", "newton", _kg*_m/_s^2)
Q.define("Pa", "pascal", _N/_m^2)
Q.define("J", "joule", _N*_m)
Q.define("W", "watt", _J/_s)

-- add prefixes
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

-- add prefixes
-- Remark: Don't create "peta siemens" because its symbol is the same for "Pferdestaerke", a common german unit for power.
Q.addPrefix({"y","z","a","f","p","n","u","m","c","d","da","h","M","G","T","E","Z","Y"},{_S})
Q.addPrefix(SI_prefixes,{_C,_V,_F,_Ohm,_Wb,_T,_H})

Q.define("lm", "lumen", _cd*_sr)
Q.define("lx", "lux", _lm/_m^2)
Q.define("Bq", "becquerel", 1/_s)
Q.define("Gy", "gray", _J/_kg)
Q.define("Sv", "sievert", _J/_kg)
Q.define("kat", "katal", _mol/_s)

-- add prefixes
Q.addPrefix(SI_prefixes,{_lm,_lx,_Bq,_Gy,_Sv,_kat})

-- define degree celsius
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
Q.define("u", "atomicmassunit", N(1.66053904e-27, 0.00000002e-27) * _kg)
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

-- Nominal Astronomical Constants
-- Source: Nominal values for selected solar and planetary quantities: IAU 2015 Resolution B3, 
-- https://arxiv.org/pdf/1605.09788.pdf
Q.define("R_sun", "nominalsolarradius", 6.957e8 * _m)
Q.define("S_sun", "nominalsolarirradiance", 1361 * _W/_m^2)
Q.define("L_sun", "nominalsolarluminosity", 3.828e26 * _W)
Q.define("T_sun", "nominalsolareffectivetemperature", 5772 * _K)
Q.define("GM_sun", "nominalsolarmassparameter", 1.3271244e20 * _m^3 * _s^-2)

Q.define("Re_E", "nominalterrestrialequatorialradius", 6.3781e6 * _m)
Q.define("Rp_E", "nominalterrestrialpolarradius", 6.3568e6 * _m)
Q.define("GM_E", "nominalterrestrialmassparameter", 3.986004e14 * _m^3 * _s^-2)

Q.define("Re_J", "nominaljovianequatorialradius", 7.1492e7 * _m)
Q.define("Rp_J", "nominaljovianpolarradius", 6.6854e7 * _m)
Q.define("GM_J", "nominaljovianmassparameter", 1.2668653e17 * _m^3 * _s^-2)





-- NON-SI UNITS BUT ACCEPTED FOR USE WITH THE SI
-- *********************************************
-- Source: http://physics.nist.gov/cuu/Units/outside.html
-- http://m.convert-me.com/en/convert/area/township.html?u=township&v=1
-- https://www.nist.gov/pml/nist-guide-si-appendix-b9-factors-units-listed-kind-quantity-or-field-science

-- Length
Q.define("angstrom", "angstrom", 1e-10*_m)
Q.define("fermi", "fermi", 1e-15*_m)

-- Area 
Q.define("barn", "barn", 1e-28*_m^2)
Q.define("are", "are", 1e2*_m^2)
Q.define("hectare", "hectare", 1e4*_m^2)

-- Volume
Q.define("L", "liter", 0.001*_m^3)
Q.define("tsp", "metricteaspoon", 0.005*_L)
Q.define("Tbsp", "metrictablespoon", 3*_tsp)

Q.addPrefix(SI_prefixes,{_L})

-- Time
Q.define("svedberg", "svedberg", 1e-13*_s)
Q.define("min", "minute", 60*_s)
Q.define("h", "hour", 60*_min)
Q.define("d", "day", 24*_h)
Q.define("wk", "week", 7*_d)
Q.define("a", "year", 365.25*_d)

-- Angular
Q.define("rad", "radian", _1 )
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
Q.define("ls", "lightsecond", _c*_s)
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
Q.define("bit", "bit", _1)
Q.define("bps", "bitpersecond", 1/_s)
Q.define("B", "byte", 8*_bit)

Q.addPrefix(IEC_prefixes,{_bit,_B,_bps})
Q.addPrefix({"k","M","G","T","P","E","Z","Y"},{_bit,_B,_bps})

-- Others
Q.define("percent", "percent", 0.01*_1)
Q.define("permille", "permille", 0.001*_1)
Q.define("ppm", "partspermillion", 1e-6*_1)
Q.define("ppb", "partsperbillion", 1e-9*_1)
Q.define("ppt", "partspertrillion", 1e-12*_1)
Q.define("ppq", "partsperquadrillion", 1e-15*_1)
Q.define("dB", "decibel", _1)
Q.define("t", "tonne", 1000*_kg)
Q.define("eV", "electronvolt", _e*_V)
Q.define("Wh", "watthour", _W * _h)
Q.define("PS", "metrichorsepower", 75*_g_0*_kg*_m/_s)
Q.define("Ci", "curie", 3.7e10*_Bq)
Q.define("Rad", "rad", 0.01*_Gy)
Q.define("rem", "rem", 0.01*_Sv)
Q.define("Ro", "roentgen", 2.58e-4*_C/_kg)
Q.define("PI", "poiseuille", _Pa * _s)

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
Q.define("sen", "sennight", 7*_d)
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



-- CURRENCIES
-- **********
-- Source: https://en.wikipedia.org/wiki/List_of_circulating_currencies
-- Exchange rates from 7.3.2019, 21:00 UTC

Q.define("LAK", "laokip", 0.00010*_EUR)
Q.define("cLAK", "laoatt", 0.01*_LAK)

Q.define("LBP", "lebanesepound", 0.00059*_EUR)
Q.define("cLBP", "lebanesepiastre", 0.01*_LBP)

Q.define("LKR", "srilankanrupee", 0.0050*_EUR)
Q.define("cLKR", "srilankancent", 0.01*_LKR)

Q.define("LRD", "liberiandollar", 0.0055*_EUR)
Q.define("cLRD", "liberiancent", 0.01*_LRD)

Q.define("LYD", "libyandinar", 0.0055*_EUR)
Q.define("mLYD", "libyandirham", 0.001*_LYD)



Q.define("MAD", "moroccandirham", 0.092*_EUR)
Q.define("cMAD", "moroccancentime", 0.01*_MAD)

Q.define("MDL", "moldovanleu", 0.052*_EUR)
Q.define("cMDL", "moldovancentime", 0.01*_MDL)

Q.define("MGA", "malagasyariary", 0.00025*_EUR)
Q.define("iMGA", "malagasyiraimbilanja", 0.2*_MGA)

Q.define("MKD", "macedoniandenar", 0.016*_EUR)
Q.define("cMKD", "macedoniandeni", 0.01*_MKD)

Q.define("MMK", "burmesekyat", 0.00058*_EUR)
Q.define("cMMK", "burmesepya", 0.01*_MMK)

Q.define("MNT", "mongoliantogrog", 0.00034*_EUR)
Q.define("cMNT", "mongolianmongo", 0.01*_MNT)

Q.define("MOP", "macanesepataca", 0.11*_EUR)
Q.define("cMOP", "macaneseavo", 0.01*_MOP)

Q.define("MRU", "mauritanianouguiya", 0.026*_EUR)
Q.define("kMRU", "mauritaniankhoums", 0.2*_MRU)

Q.define("MUR", "mauritianrupee", 0.026*_EUR)
Q.define("cMUR", "mauritiancent", 0.01*_MUR)

Q.define("MVR", "maldivianrufiyaa", 0.058*_EUR)
Q.define("cMVR", "maldivianlaari", 0.01*_MVR)

Q.define("MWK", "malawiankwacha", 0.0012*_EUR)
Q.define("cMWK", "malawiantambala", 0.01*_MWK)

Q.define("MXN", "mexicanpeso", 0.046*_EUR)
Q.define("cMXN", "mexicancentavo", 0.01*_MXN)

Q.define("MYR", "malaysianringgit", 0.22*_EUR)
Q.define("cMYR", "malaysiansen", 0.01*_MYR)

Q.define("MZN", "mozambicanmetical", 0.014*_EUR)
Q.define("cMZN", "mozambicancentavo", 0.01*_MZN)



Q.define("NAD", "namibiandollar", 0.063*_EUR)
Q.define("cNAD", "namibiancent", 0.01*_NAD)

Q.define("NGN", "nigeriannaira", 0.0024*_EUR)
Q.define("cNGN", "nigeriankobo", 0.01*_NGN)

Q.define("NIO", "nicaraguancordoba", 0.027*_EUR)
Q.define("cNIO", "nicaraguancentavo", 0.01*_NIO)

Q.define("NOK", "norwegiankrone", 0.1*_EUR)
Q.define("cNOK", "norwegianore", 0.01*_NOK)

Q.define("NPR", "nepaleserupee", 0.0079*_EUR)
Q.define("cNPR", "nepalesepaisa", 0.01*_NPR)

Q.define("NZD", "newzealanddollar", 0.61*_EUR)
Q.define("cNZD", "newzealandcent", 0.01*_NZD)



Q.define("OMR", "omanirial", 2.32*_EUR)
Q.define("mNZD", "omanibaisa", 0.001*_NZD)



Q.define("PAB", "panamanianbalboa", 0.89*_EUR)
Q.define("cPAB", "panamaniancentesimo", 0.01*_PAB)

Q.define("PEN", "peruviansol", 0.27*_EUR)
Q.define("cPEN", "peruviansolcentimo", 0.01*_PEN)

Q.define("PGK", "papauanewguineankina", 0.26*_EUR)
Q.define("cPGK", "papauanewguineantoea", 0.01*_PGK)

Q.define("PHP", "philippinepeso", 0.017*_EUR)
Q.define("cPHP", "philippinesentimo", 0.01*_PHP)

Q.define("PKR", "pakistanirupee", 0.0064*_EUR)
Q.define("cPKR", "pakistanipaisa", 0.01*_PKR)

Q.define("PLN", "polishzloty", 0.23*_EUR)
Q.define("cPLN", "polishgrosz", 0.01*_PLN)

Q.define("PRB", "transnistrianruble", 0.055*_EUR)
Q.define("cPRB", "transnistriankopek", 0.01*_PRB)

Q.define("PYG", "paraguayanguarani", 0.00014*_EUR)
Q.define("cPYG", "paraguayancentimo", 0.01*_PYG)



Q.define("QAR", "qataririyal", 0.24*_EUR)
Q.define("cQAR", "qataridirham", 0.01*_QAR)



Q.define("RON", "romanianleu", 0.21*_EUR)
Q.define("cRON", "romanianban", 0.01*_RON)

Q.define("RSD", "serbiandinar", 0.0085*_EUR)
Q.define("cRSD", "serbianpara", 0.01*_RSD)

Q.define("RUB", "russianruble", 0.013*_EUR)
Q.define("cRUB", "russiankopek", 0.01*_RUB)

Q.define("RWF", "rwandanfranc", 0.00098*_EUR)
Q.define("cRWF", "rwandancentime", 0.01*_RWF)



Q.define("SAR", "saudiriyal", 0.24*_EUR)
Q.define("cSAR", "saudihalala", 0.01*_SAR)

Q.define("SBD", "solomonislandsdollar", 0.11*_EUR)
Q.define("cSBD", "solomonislandscent", 0.01*_SBD)

Q.define("SCR", "seychelloisrupee", 0.065*_EUR)
Q.define("cSCR", "seychelloiscent", 0.01*_SCR)

Q.define("SDG", "sudanesepound", 0.019*_EUR)
Q.define("cSDG", "sudanesepiastre", 0.01*_SDG)

Q.define("SEK", "swedishkrona", 0.094*_EUR)
Q.define("cSEK", "swedishoere", 0.01*_SEK)

Q.define("SGD", "singaporedollar", 0.66*_EUR)
Q.define("cSGD", "singaporecent", 0.01*_SGD)

Q.define("SHP", "sainthelenapound", 0.86*_EUR)
Q.define("cSHP", "sainthelenapenny", 0.01*_SHP)

Q.define("SLL", "sierraleoneanleone", 0.00010*_EUR)
Q.define("cSLL", "sierraleoneancent", 0.01*_SLL)

Q.define("SLS", "somalilandshilling", 0.13*_EUR)
Q.define("cSLS", "somalilandcent", 0.01*_SLS)

Q.define("SOS", "somalishilling", 0.0015*_EUR)
Q.define("cSOS", "somalicent", 0.01*_SOS)

Q.define("SRD", "surinamesedollar", 0.12*_EUR)
Q.define("cSRD", "surinamesecent", 0.01*_SRD)

Q.define("SSP", "southsudanesepound", 0.0068*_EUR)
Q.define("cSSP", "southsudanesepiastre", 0.01*_SSP)

Q.define("STN", "saotomeandprincipedobra", 0.04*_EUR)
Q.define("cSTN", "saotomeandprincipecentimo", 0.01*_SSP)

Q.define("SYP", "syrianpound", 0.0017*_EUR)
Q.define("cSYP", "syrianpiastre", 0.01*_SYP)

Q.define("SZL", "swazililangeni", 0.062*_EUR)
Q.define("cSZL", "swazicent", 0.01*_SZL)



Q.define("THB", "thaibaht", 0.028*_EUR)
Q.define("cTHB", "thaisatang", 0.01*_THB)

Q.define("TJS", "tajikistanisomoni", 0.093*_EUR)
Q.define("cTJS", "tajikistanidiram", 0.01*_TJS)

Q.define("TMT", "turkmenistanimanat", 0.25*_EUR)
Q.define("cTMT", "turkmenistanitennesi", 0.01*_TMT)

Q.define("TOP", "tonganpaanga", 0.397*_EUR)
Q.define("cTOP", "tonganseniti", 0.01*_TOP)

Q.define("TRY", "turkishlira", 0.16*_EUR)
Q.define("cTRY", "turkishkurus", 0.01*_TRY)

Q.define("TTD", "trinidadandtobagodollar", 0.13*_EUR)
Q.define("cTTD", "trinidadandtobagocent", 0.01*_TTD)

Q.define("TVD", "tuvaluandollar", 1.597*_EUR)
Q.define("cTVD", "tuvaluancent", 0.01*_TVD)

Q.define("TWD", "newtaiwandollar", 0.029*_EUR)
Q.define("cTWD", "newtaiwancent", 0.01*_TWD)

Q.define("TZS", "tanzanianshilling", 0.00038*_EUR)
Q.define("cTZS", "tanzaniancent", 0.01*_TZS)



Q.define("UAH", "ukrainianhryvnia", 0.00038*_EUR)
Q.define("cUAH", "ukrainiankopiyka", 0.01*_UAH)

Q.define("UGX", "ugandanshilling", 0.00038*_EUR)
Q.define("cUGX", "ugandancent", 0.01*_UGX)

Q.define("USD", "usdollar", 0.89*_EUR)
Q.define("cUSD", "uscent", 0.01*_USD)

Q.define("UYU", "uruguayanpeso", 0.89*_EUR)
Q.define("cUYU", "uruguayancentesimo", 0.01*_UYU)

Q.define("UZS", "uzbekistanisom", 0.89*_EUR)
Q.define("cUZS", "uzbekistantiyin", 0.01*_UZS)


Q.define("VES", "venezuelanbolivarsoberano", 0.89*_EUR)
Q.define("cVES", "venezuelancentimo", 0.01*_VES)

Q.define("VND", "vietnamesedong", 0.89*_EUR)
Q.define("cVND", "vietnamesehao", 0.01*_VND)



Q.define("WST", "samoantala", 0.89*_EUR)
Q.define("cWST", "samoansene", 0.01*_WST)



Q.define("XAF", "centralafricanfranc", 0.0015*_EUR)
Q.define("cXAF", "centralafricancentime", 0.01*_XAF)

Q.define("XCD", "easterncaribbeandollar", 0.33*_EUR)
Q.define("cXCD", "easterncaribbeancent", 0.01*_XCD)

Q.define("XOF", "westafricanfranc", 0.0015*_EUR)
Q.define("cXOF", "westafricancentime", 0.01*_XOF)

Q.define("XPF", "cfpfranc", 0.0084*_EUR)
Q.define("cXPF", "cfpcentime", 0.01*_XPF)



Q.define("YER", "yemenirial", 0.0036*_EUR)
Q.define("cYER", "yemenifils", 0.01*_YER)


Q.define("ZAR", "southafricanrand", 0.061*_EUR)
Q.define("cZAR", "southafricancent", 0.01*_ZAR)

Q.define("ZMW", "zambiankwacha", 0.074*_EUR)
Q.define("cZMW", "zambianngwee", 0.01*_ZMW)

Q.define("ZWB", "zimbabweanbonds", 0.0025*_EUR)
Q.define("cZWB", "zimbabweancents", 0.01*_ZWB)


function defineCurrency(iso,prefix,name,unit,minorname,minorvalue)
	local u = Q.define(iso, prefix..name, unit)
	if minorname ~= nil then
		Q.define("c"..iso, prefix..minorname, minorvalue*u)
	end
end

-- variable currencies
defineCurrency("AFN", "Afghan", "Afghani", 0.012*_EUR, "Pul", 0.01)
defineCurrency("ALL", "Albanian", "Lek", 0.008*_EUR, nil, nil)
defineCurrency("AMD", "Armenian", "Dram", 0.0018*_EUR, "Luma", 0.01)
defineCurrency("AOA", "Angolan", "Kwanza", 0.0028*_EUR, "Centimo", 0.01)
defineCurrency("ARS", "Argentine", "Peso", 0.021*_EUR, "Centavo", 0.01)
defineCurrency("AUD", "Australian", "Dollar", 0.63*_EUR, "Cent", 0.01)
defineCurrency("AZN", "Azerbaijani", "Manat", 0.63*_EUR, "Qepik", 0.01)
defineCurrency("BAM", "Bosnian", "Mark", 0.51*_EUR, "Fenings", 0.01)
defineCurrency("BDT", "Bangladeshi", "Taka", 0.011*_EUR, "Poisha", 0.01)
defineCurrency("BIF", "Burundian", "Franc", 0.00049*_EUR, "Centime", 0.01)
defineCurrency("BOB", "Bolivian", "Boliviano", 0.13*_EUR, "Centavo", 0.01)
defineCurrency("BRL", "Brazilian", "Real", 0.23*_EUR, "Centavo", 0.01)
defineCurrency("BWP", "Botswana", "Pula", 0.083*_EUR, "Thebe", 0.01)
defineCurrency("BYN", "Belarusian", "Ruble", 0.42*_EUR, "Kapiejka", 0.01)
defineCurrency("CAD", "Canadian", "Dollar", 0.66*_EUR, "Cent", 0.01)
defineCurrency("CDF", "Congolese", "Franc", 0.00055*_EUR, "Centime", 0.01)
defineCurrency("CHF", "Swiss", "Franc", 0.88*_EUR, "Rappen", 0.01)
defineCurrency("CLP", "Chilean", "Peso", 0.0013*_EUR, "Centavo", 0.01)
defineCurrency("CNY", "ChineseRenminbi", "Yuan", 0.13*_EUR, "Fen", 0.01)
defineCurrency("COP", "Colombian", "Peso", 0.00028*_EUR, "Centavo", 0.01)
defineCurrency("CRC", "CostaRican", "Colon", 0.0015*_EUR, "Centimos", 0.01)
defineCurrency("CZK", "Czech", "Koruna", 0.039*_EUR, "Haler", 0.01)
defineCurrency("DKK", "Danish", "Krone", 0.13*_EUR, "Ore", 0.01)
defineCurrency("DOP", "Dominican", "Peso", 0.018*_EUR, "Centavo", 0.01)
defineCurrency("DZD", "Algerian", "Dinar", 0.0074*_EUR, "Santeem", 0.01)
defineCurrency("EGP", "Egyptian", "Pound", 0.051*_EUR, "Piastre", 0.01)
defineCurrency("ETB", "Ethiopian", "Birr", 0.031*_EUR, "Santim", 0.01)
defineCurrency("FJD", "Fijian", "Dollar", 0.42*_EUR, "Cent", 0.01)
defineCurrency("GBP", "", "PoundSterling", 1.16*_EUR, "PennySterling", 0.01)
defineCurrency("GEL", "Georgian", "Lari", 0.33*_EUR, "Tetri", 0.01)
defineCurrency("GHS", "Ghanaian", "Cedi", 0.16*_EUR, "Pesewa", 0.01)
defineCurrency("GMD", "Gambian", "Dalasi", 0.018*_EUR, "Butut", 0.01)
defineCurrency("GNF", "Guinean", "Franc", 0.000096*_EUR, "Centime", 0.01)
defineCurrency("GTQ", "Guatemalan", "Quetzal", 0.12*_EUR, "Centavo", 0.01)
defineCurrency("GYD", "Guyanese", "Dollar", 0.0043*_EUR, "Cent", 0.01)
defineCurrency("HKD", "HongKong", "Dollar", 0.11*_EUR, "Cent", 0.01)
defineCurrency("HNL", "Honduran", "Lempira", 0.036*_EUR, "Centavo", 0.01)
defineCurrency("HRK", "Croatian", "Kuna", 0.13*_EUR, "Lipa", 0.01)
defineCurrency("HTG", "Haitian", "Gourde", 0.011*_EUR, "Centime", 0.01)
defineCurrency("HUF", "Hungarian", "Forint", 0.0032*_EUR, "Filler", 0.01)
defineCurrency("IDR", "Indonesian", "Rupiah", 0.000062*_EUR, "Sen", 0.01)
defineCurrency("ILS", "IsraeliNew", "Shekel", 0.25*_EUR, "Agora", 0.01)
defineCurrency("INR", "Indian", "Rupee", 0.013*_EUR, "Paisa", 0.01)
defineCurrency("IQD", "Iraqi", "Dinar", 0.00074*_EUR, "Fils", 0.001)
defineCurrency("IRR", "Iranian", "Rial", 0.000027*_EUR, "Toman", 10)
defineCurrency("ISK", "Icelandic", "Krona", 0.0073*_EUR, nil, nil)
defineCurrency("JMD", "Jamaican", "Dollar", 0.007*_EUR, "Cent", 0.01)
defineCurrency("JPY", "Japanese", "Yen", 0.008*_EUR, nil, nil)
defineCurrency("KES", "Kenyan", "Shilling", 0.0089*_EUR, "Cent", 0.01)
defineCurrency("KGS", "Kyrgyzstani", "Som", 0.013*_EUR, "Tyiyn", 0.01)
defineCurrency("KHR", "Cambodian", "Riel", 0.00022*_EUR, nil, nil)
defineCurrency("KPW", "NorthKorean", "Won", 0.00099*_EUR, "Chon", 0.01)
defineCurrency("KRW", "SouthKorean", "Won", 0.00078*_EUR, "Jeon", 0.01)
defineCurrency("KWD", "Kuwaiti", "Dinar", 2.93*_EUR, "Fils", 0.001)
defineCurrency("KZT", "Kazakhstani", "Tenge", 0.0023*_EUR, "Tiyn", 0.01)


-- fixed exchange currencies
defineCurrency("AED", "UnitedArabEmirates", "Dirham", (1/3.6725)*_USD, "Fils", 0.01)
defineCurrency("ANG", "NetherlandsAntillean", "Guilder", (1/1.79)*_USD, "Cent", 0.01)
defineCurrency("AWG", "Aruban", "Florin", (1/1.79)*_USD, "Cent", 0.01)
defineCurrency("BBD", "Barbadian", "Dollar", 0.5*_USD, "Cent", 0.01)
defineCurrency("BGN", "Bulgarian", "Lev",  0.51129*_EUR, "Stotinka", 0.01)
defineCurrency("BHD", "Bahraini", "Dinar", (1/0.376)*_USD, "Fils", 0.001)
defineCurrency("BMD", "Bermudian", "Dollar", 1*_USD, "Cent", 0.01)
defineCurrency("BND", "Brunei", "Dollar", 1*_SGD, "Sen", 0.01)
defineCurrency("BSD", "Bahamian", "Dollar", 1*_USD, "Cent", 0.01)
defineCurrency("BTN", "Bhutanese", "Ngultrum", 1*_INR, "Chhertum", 0.01)
defineCurrency("BZD", "Belize", "Dollar", 0.5*_USD, "Cent", 0.01)
defineCurrency("CUC", "CubanoConvertible", "Peso", 1*_USD, "Centavo", 0.01)
defineCurrency("CUP", "Cuban", "Peso", (1/24)*_CUC, "Centavo", 0.01)
defineCurrency("CVE", "CapeVerdean", "Escudo", (1/110.265)*_EUR, "Centavo", 0.01)
defineCurrency("DJF", "Djiboutian", "Franc", (1/177.721)*_USD, "Centime", 0.01)
defineCurrency("ERN", "Eritrean", "Nakfa", (1/15)*_USD, "Cent", 0.01)
defineCurrency("FKP", "FalklandIslands", "Pound", 1*_GBP, "Penny", 0.01)
defineCurrency("GGP", "Guernsey", "Pound", 1*_GBP, "Penny", 0.01)
defineCurrency("GIP", "Gibraltar", "Pound", 1*_GBP, "Penny", 0.01)
defineCurrency("IMP", "Manx", "Pound", 1*_GBP, "Penny", 0.01)
defineCurrency("JEP", "Jersey", "Pound", 1*_GBP, "Penny", 0.01)
defineCurrency("JOD", "Jordanian", "Dinar", (1/0.708)*_USD, "Fils", 0.001)
defineCurrency("KID", "Kiribati", "Dollar", 1*_AUD, "Cent", 0.01)
defineCurrency("KMF", "Comorian", "franc", (1/491.96775)*_EUR, "Centime", 0.01)
defineCurrency("KYD", "CaymanIslands", "Dollar", 1.2*_USD, "Cent", 0.01)










