--[[
This file contains the unit tests for the physical units defined in "defition.lua".

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

local lu = require("luaunit")

package.path = "../src/?.lua;" .. package.path
local physical = require("physical")
local N = physical.Number


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         if getmetatable(v) == physical.Unit then
            s = s .. '['..k..'] = ' .. v.symbol .. ','
         else
           s = s .. '['..k..'] = ' .. dump(v) .. ','
         end
      end
      return s .. '}\n'
   else
      return tostring(o)
   end
end


TestDefinition = {} 

-- SI Derived Units
function TestDefinition:testGram()
   lu.assertTrue( 5000 * _g == 5 * _kg)
   lu.assertTrue( 5000 * _mg == 5 * _g)
   lu.assertTrue( (1200 * _ng):isclose(1.2 * _ug,1e-10))
end

function TestDefinition:testHertz()
   local f = (1.24e6*_Hz):to(_kHz)
   lu.assertTrue(f == 1.24e3 * _kHz)

   local f = (30/_s):to(_Hz)
   lu.assertTrue(f == 30*_Hz)
end

function TestDefinition:testNewton()
   local F = (30*_kg*5*_m/(2 * _s^2)):to(_N)
   lu.assertTrue(F == 75 * _N)
end

function TestDefinition:testPascal()
   local F = 400000 * _N
   local A = 2 * _m^2
   local P = (F/A):to(_Pa)
   lu.assertTrue(P == 200000 * _Pa)
end

function TestDefinition:testJoule()
   local F = 2 * _kN
   local s = 5 * _mm
   local W = (F*s):to(_J)
   lu.assertTrue(W == 10*_J)
end

function TestDefinition:testWatt()
   local W = 2 * _MJ
   local t = 2 * _h
   local P = (W/t):to(_W)
   lu.assertTrue(P:isclose(277.777777777777778 * _W, 1e-10))
end


function TestDefinition:testCoulomb()
   local I = 3.4 * _pA 
   local t = 1 * _min
   local Q = (I*t):to(_C)
   lu.assertTrue(Q:isclose(2.04e-10 * _C, 1e-10))
end

function TestDefinition:testVolt()
   local E = 45 * _J
   local Q = 4 * _C
   local U = (E/Q):to(_V)
   lu.assertTrue(U:isclose(11.25 * _V, 1e-10))
end


function TestDefinition:testFarad()
   local Q = 40 * _mC
   local U = 12 * _V
   local C = (Q/U):to(_F)
   lu.assertTrue(C:isclose(0.003333333333333 * _F, 1e-10))   
end

function TestDefinition:testOhm()
   local I = 30 * _mA
   local U = 5 * _V
   local R = (U/I):to(_Ohm)
   lu.assertTrue(R:isclose(166.666666666666667 * _Ohm, 1e-10))
end

function TestDefinition:testSiemens()
   local R = 5 * _kOhm
   local G = (1/R):to(_S)
   lu.assertTrue(G:isclose(0.0002 * _S, 1e-10))
end

function TestDefinition:testWeber()
   local B = 2.3 * _mT
   local A = 23 * _cm^2
   local Phi = (B*A):to(_Wb)
   lu.assertTrue(Phi:isclose(0.00000529 * _Wb, 1e-10))
end

function TestDefinition:testTesla()
   local Phi = 40 * _uWb
   local A = 78 * _mm^2
   local B = (Phi/A):to(_T)
   lu.assertTrue(B:isclose(0.512820512820513 * _T, 1e-10))
end

function TestDefinition:testHenry()
   local U = 45 * _mV
   local I = 20 * _mA
   local t = 100 * _ms
   local L = (U/(I/t)):to(_H)
   lu.assertTrue(L:isclose(0.225*_H, 1e-10))
end

function TestDefinition:testLumen()
   local I = 400 * _cd
   local r = 2.4 * _m
   local A = 1.2 * _m^2
   local F = (I*A/r^2):to(_lm)
   lu.assertTrue(F:isclose(83.333333333333*_lm, 1e-10))
end

function TestDefinition:testLux()
   local I = 400 * _cd
   local r = 2.4 * _m
   local A = 1.2 * _m^2
   local E = (I/r^2):to(_lx)
   lu.assertTrue(E:isclose(69.444444444444*_lx, 1e-10))
end

function TestDefinition:testBecquerel()
   local N = 12000
   local t = 6 * _s
   local A = (N/t):to(_Bq)

   lu.assertTrue(A:isclose(2000*_Bq, 1e-10))
end

function TestDefinition:testGray()
   local E = 12 * _mJ
   local m = 60 * _kg
   local D = (E/m):to(_Gy)
   lu.assertTrue(D:isclose(0.0002*_Gy, 1e-10))
end

function TestDefinition:testSievert()
   local E = 20 * _mJ
   local m = 50 * _kg
   local H = (E/m):to(_Sv)
   lu.assertTrue(H:isclose(0.0004*_Sv, 1e-10))
end

function TestDefinition:testKatal()
   local n = 20 * _mol
   local t = 34 * _min
   local a = (n/t):to(_kat)
   lu.assertTrue(a:isclose(0.0098039215686275 * _kat, 1e-10))
end

function TestDefinition:testDegreeCelsius()
   local theta = 0 * _degC
   lu.assertTrue( (theta + _degC_0):to(_K) == 273.15 * _K )

   theta = 5*_degC
   lu.assertTrue( (theta + _degC_0):to(_K) == 278.15*_K )

   theta = _degC*5
   lu.assertTrue( (theta + _degC_0):to(_K) == 278.15*_K )

   theta = 5*_degC + 3*_degC
   lu.assertTrue( (theta + _degC_0):to(_K,true) == 281.15*_K )
   
   local dT = (5 * _degC) / _cm
   lu.assertTrue( dT == 5 * _K / _cm )

   
   local T_1 = 0 * _degC
   local T_2 = 1 * _K

   local r = ((T_1 + _degC_0):to(_K)-T_2)/(T_1 + _degC_0)

   r = r:to(_percent)
   lu.assertTrue( r:isclose(99.63*_percent, 0.1) )
   
   local c = 1000 * _J/(_kg*_degC)
   local m = 1 * _g
   local dT = 20 * _degC

   local Q = ( c * m * dT ):to(_J)
   lu.assertTrue( Q == 20 * _J )


   theta_1 = 110 * _degC
   T_1 = ( theta_1 + _degC_0 ):to(_K)
   theta_1 = T_1:to(_degC) - _degC_0

   lu.assertTrue( T_1 == 383.15 * _K )
   lu.assertTrue( theta_1 == 110 * _degC )
end


-- PHYSICAL CONSTANTS
function TestDefinition:testSpeedOfLight()
   local lns = _c * 1 * _ns
   local l = lns:to(_cm)
   lu.assertTrue(l:isclose(29.9792458 * _cm, 1e-10))
end

function TestDefinition:testGravitationalConstant()
   local m_1 = 20 * _kg
   local m_2 = 40 * _kg
   local r = 2 * _m
   local F_G = (_Gc*m_1*m_2/r^2):to(_N)
   lu.assertTrue(F_G:isclose(0.0000000133482 * _N, 1e-5))
end

function TestDefinition:testGravitationalConstant()
   local m_1 = 20 * _kg
   local m_2 = 40 * _kg
   local r = 2 * _m
   local F_G = (_Gc*m_1*m_2/r^2):to(_N)
   lu.assertTrue(F_G:isclose(0.0000000133482 * _N, 1e-5))
end

function TestDefinition:testPlanckConstant()
   local p = 4.619e-23 * _kg * _m / _s
   local lambda = (_h_P/p):to(_m)
   lu.assertTrue(lambda:isclose(0.01434 * _nm, 1e-3))
end

function TestDefinition:testReducedPlanckConstant()
   local Pi = 3.1415926535897932384626433832795028841971693993751
   local hbar = _h_P/(2*Pi)
   lu.assertTrue(hbar:isclose(_h_Pbar, 1e-3))
end

function TestDefinition:testElementaryCharge()
   local N = (150 * _C / _e):to(_1)
   lu.assertTrue(N:isclose(9.3622e20*_1, 1e-4))
end

function TestDefinition:testVacuumPermeability()
   local I = 1.3 * _A
   local r = 20 * _cm
   local Pi = 3.1415926535897932384626433832795028841971693993751

   local B = (_u_0*I/(2*Pi*r)):to(_T)
   lu.assertTrue(B:isclose(1.3*_uT, 1e-4))
end

function TestDefinition:testVacuumPermitivity()
   local Q_1 = 3 * _nC
   local Q_2 = 5.5 * _uC
   local r = 20 * _cm

   local Pi = 3.1415926535897932384626433832795028841971693993751

   local F_C = (1/(4*Pi*_e_0)) * Q_1 * Q_2 / r^2
   F_C = F_C:to(_N)
   lu.assertTrue(F_C:isclose(0.003707365112549*_N, 1e-4))
end

function TestDefinition:testAtomicMass()
   local m = (12*_u):to(_yg)
   lu.assertTrue(m:isclose(19.926468 * _yg, 1e-4))
end

function TestDefinition:testElectronMass()
   local k = (_u/_m_e):to(_1)
   lu.assertTrue(k:isclose(1822.888 * _1, 1e-4))
end

function TestDefinition:testProtonMass()
   local k = (_m_p/_u):to(_1)
   lu.assertTrue(k:isclose(1.007276 * _1, 1e-4))
end

function TestDefinition:testNeutronMass()
   local k = (_m_n/_u):to(_1)
   lu.assertTrue(k:isclose(1.008665 * _1, 1e-4))
end

function TestDefinition:testBohrMagneton()
   local dE = (0.5*2*_u_B*1.2*_T):to(_eV)
   lu.assertTrue(dE:isclose(6.95e-5 * _eV, 1e-3))
end

function TestDefinition:testNuclearMagneton()
   local m_p = 0.5*_e*_h_Pbar/_u_N
   lu.assertTrue(m_p:isclose(_m_p, 1e-10))
end

function TestDefinition:testProtonmagneticmoment()
   lu.assertTrue((2.7928473508*_u_N):isclose(_u_p, 1e-6))
end

function TestDefinition:testNeutronMagneticMoment()
   lu.assertTrue((-1.91304272*_u_N):isclose(_u_n, 1e-6))
end

function TestDefinition:testFineStructureConstant()
   lu.assertTrue(_alpha:isclose(N(7.2973525664e-3,0.0000000017e-3)*_1, 1e-9))
end

function TestDefinition:testRydbergConstant()
   lu.assertTrue(_Ry:isclose(N(1.097373139e7,0.000065e7)/_m, 1e-9))
end

function TestDefinition:testAvogadrosNumber()
   lu.assertTrue(_N_A:isclose(N(6.02214076e23,0.00000001e23)/_mol, 1e-9))
end

function TestDefinition:testBoltzmannConstant()
   lu.assertTrue(_k_B:isclose(N(1.380649e-23,0.000001e-23)*_J/_K, 1e-9))
end

function TestDefinition:testGasConstant()
   lu.assertTrue(_R:isclose(N(8.3144598,0.0000048)*_J/(_K*_mol), 1e-9))
end

function TestDefinition:testStefanBoltzmannConstant()
   lu.assertTrue(_sigma:isclose(N(5.6703744191844e-8,0.000013e-8)*_W/(_m^2*_K^4), 1e-6))
end

function TestDefinition:testStandardGravity()
   lu.assertTrue(_g_0:isclose(9.80665*_m/_s^2, 1e-6))
end

function TestDefinition:testNominalSolarRadius()
   lu.assertTrue(_R_S_nom:isclose(695700*_km, 1e-6))
end



-- NON-SI UNITS BUT ACCEPTED FOR USE WITH THE SI

-- Length
function TestDefinition:testAngstrom()
   lu.assertTrue( (1e10*_angstrom):isclose(1*_m,1e-6) )
end

function TestDefinition:testFermi()
   lu.assertTrue( (23444 * _fermi):isclose(0.23444*_angstrom,1e-6) )
end

-- Area
function TestDefinition:testBarn()
   lu.assertTrue( (38940*_am^2):isclose(0.3894*_mbarn,1e-6) )
end

function TestDefinition:testAre()
   lu.assertTrue( (200*_m^2):isclose(2*_are,1e-6) )
end

function TestDefinition:testHectare()
   lu.assertTrue( (56000*_m^2):isclose(5.6*_hectare,1e-6) )
end

-- Volume
function TestDefinition:testLiter()
   lu.assertTrue((1000*_L):isclose(1*_m^3, 1e-6))
   lu.assertTrue((1*_mL):isclose(1*_cm^3, 1e-6))
end

function TestDefinition:testMetricTeaspoon()
   lu.assertTrue((_L):isclose(200*_tsp, 1e-6))
end

function TestDefinition:testMetricTablespoon()
   lu.assertTrue((3*_L):isclose(200*_Tbsp, 1e-6))
end

-- Time
function TestDefinition:testSvedberg()
   lu.assertTrue((0.56*_ns):isclose(5600*_svedberg, 1e-6))
end
function TestDefinition:testMinute()
   lu.assertTrue((60*_s):isclose(_min, 1e-6))
end

function TestDefinition:testHour()
   lu.assertTrue((60*_min):isclose(_h, 1e-6))
end

function TestDefinition:testDay()
   lu.assertTrue((24*_h):isclose(_d, 1e-6))
end

function TestDefinition:testWeek()
   lu.assertTrue((7*_d):isclose(_wk, 1e-6))
end

function TestDefinition:testYear()
   lu.assertTrue((_a):isclose(365*_d+6*_h, 1e-6))
end

-- Angular

function TestDefinition:testRadian()
   lu.assertTrue((_rad):isclose(57.295779513082321*_deg, 1e-6))
end

function TestDefinition:testSteradian()
   lu.assertTrue((_sr):isclose(_rad^2, 1e-6))
end

function TestDefinition:testGrad()
   lu.assertTrue(((5*_deg):to()):isclose(0.087266462599716*_rad, 1e-6))
end

function TestDefinition:testArcMinute()
   lu.assertTrue(((2*_deg):to(_arcmin)):isclose(120*_arcmin, 1e-6))
end

function TestDefinition:testArcSecond()
   lu.assertTrue(((2*_deg):to(_arcmin)):isclose(120*60*_arcsec, 1e-6))
end

function TestDefinition:testGon()
   lu.assertTrue((34.3*_deg):isclose(38.111111111111*_gon, 1e-6))
end

function TestDefinition:testTurn()
   lu.assertTrue((720*_deg):isclose(2*_tr, 1e-6))
end

function TestDefinition:testSpat()
   lu.assertTrue((_sp):isclose(12.566370614359173*_sr, 1e-6))
end



-- Astronomical
function TestDefinition:testAstronomicalUnit()
   lu.assertTrue((34.3*_au):isclose(5.131e9*_km, 1e-4))
end

function TestDefinition:testLightYear()
   lu.assertTrue(_ly:isclose(63241*_au, 1e-4))
end

function TestDefinition:testParsec()
   lu.assertTrue(_pc:isclose(3.262*_ly, 1e-3))
end


--force
function TestDefinition:testKiloPond()
   lu.assertTrue(_kp:isclose(9.8*_kg*_m/_s^2, 1e-2))
end


-- Pressure
function TestDefinition:testBar()
   lu.assertTrue((1013*_hPa):isclose(1.013*_bar, 1e-6))
end

function TestDefinition:testStandardAtmosphere()
   lu.assertTrue((2*_atm):isclose(2.0265*_bar, 1e-6))
end

function TestDefinition:testTechnicalAtmosphere()
   lu.assertTrue((2*_at):isclose(1.96*_bar, 1e-3))
end

function TestDefinition:testMillimeterOfMercury()
   lu.assertTrue((120*_mmHg):isclose(15999*_Pa, 1e-4))
end

function TestDefinition:testTorr()
   lu.assertTrue((120*_mmHg):isclose(120*_Torr, 1e-4))
end


-- Heat
function TestDefinition:testCalorie()
   lu.assertTrue((120*_cal):isclose(502.08*_J, 1e-6))
end

function TestDefinition:testCalorieInternational()
   lu.assertTrue((120*_cal_IT):isclose(502.416*_J, 1e-6))
end

function TestDefinition:testGramOfTNT()
   lu.assertTrue((5*_kg_TNT):isclose(2.092e7*_J, 1e-3))
end

function TestDefinition:testTonsOfTNT()
   lu.assertTrue((2*_Mt_TNT):isclose(8.368e15*_J, 1e-3))
end


-- Electrical

function TestDefinition:testVoltAmpere()
   lu.assertTrue((23*_VA):isclose(23*_W, 1e-3))
end

function TestDefinition:testAmpereHour()
   lu.assertTrue((850*_mAh):isclose(3060*_C, 1e-3))
end


-- Information units

function TestDefinition:testBit()
   lu.assertTrue( (100e12 * _bit):isclose(12500000000*_kB,1e-6) )
   lu.assertTrue( (_KiB/_s):isclose(8192*_bit/_s,1e-6) )
end

function TestDefinition:testBitsPerSecond()
   lu.assertTrue( (_MiB/_s):isclose(8388608*_bps,1e-6) )
end

function TestDefinition:testByte()
   local d = 12500000000 * _kB
   lu.assertTrue( d:isclose(12207031250*_KiB,1e-6) )
   lu.assertTrue( d:isclose(100000000000*_kbit,1e-6) )
end


-- Others

function TestDefinition:testPercent()
   local k = (80 * _percent):to()
   lu.assertEquals( k.value, 0.8)
end

function TestDefinition:testPermille()
   local k = (80 * _permille):to()
   lu.assertEquals( k.value, 0.08)
end

function TestDefinition:testTonne()
   lu.assertTrue( (2.3*_t):isclose(2.3e6*_g,1e-6) )
end

function TestDefinition:testElectronVolt()
   lu.assertTrue( (200 * _MeV):isclose(3.20435466e-11*_J,1e-6) )
end

function TestDefinition:testWattHour()
   lu.assertTrue( (20 * _mWh):isclose(20*3.6*_J,1e-6) )
end

function TestDefinition:testMetricHorsePower()
   lu.assertTrue( (200 * _PS):isclose(147100 * _W,1e-4) )
end

function TestDefinition:testCurie()
   lu.assertTrue( (3e9 * _Bq):isclose(0.081081081 * _Ci,1e-4) )
end

function TestDefinition:testRad()
   lu.assertTrue( (100 * _Rad):isclose(1 * _Gy,1e-4) )
end

function TestDefinition:testRad()
   lu.assertTrue( (100 * _rem):isclose(1 * _Sv,1e-4) )
end

function TestDefinition:testPoiseuille()
   local r = 2 * _mm 
   local l = 10 * _cm 
   local p = 400 * _Pa
   local eta = 0.0027 * _Pl

   local Pi = 3.1415926535897932384626433832795028841971693993751

   local Q = Pi*p*r^4/(8*eta*l)
   lu.assertTrue( Q:isclose(9.3084226773031 * _mL/_s,1e-4) )
end





-- IMPERIAL UNITS

-- Length
function TestDefinition:testInch()
   lu.assertTrue( (2.2*_m):isclose(86.6 * _in,1e-3) )
end

function TestDefinition:testThou()
   lu.assertTrue( (4.3*_th):isclose(0.0043 * _in,1e-3) )
end

function TestDefinition:testPica()
   lu.assertTrue( (5*_pica):isclose(0.8333 * _in,1e-3) )
end

function TestDefinition:testPoint()
   lu.assertTrue( (72*_pt):isclose(25.4 * _mm,1e-3) )
end

function TestDefinition:testHand()
   lu.assertTrue( (3*_hh):isclose(12 * _in,1e-3) )
end

function TestDefinition:testFoot()
   lu.assertTrue( (2*_ft):isclose(60.96 * _cm,1e-3) )
end

function TestDefinition:testYard()
   lu.assertTrue( (1.5*_yd):isclose(1.3716 * _m,1e-3) )
end

function TestDefinition:testRod()
   lu.assertTrue( (22*_rd):isclose(1.106 * _hm,1e-3) )
end

function TestDefinition:testChain()
   lu.assertTrue( (0.5*_ch):isclose(0.0100584 * _km,1e-3) )
end

function TestDefinition:testFurlong()
   lu.assertTrue( (69*_fur):isclose(13.88 * _km,1e-3) )
end

function TestDefinition:testMile()
   lu.assertTrue( (2*_mi):isclose(3.219 * _km,1e-3) )
end

function TestDefinition:testLeague()
   lu.assertTrue( (2.2*_lea):isclose(6.6 * _mi,1e-3) )
end


-- International Nautical Units
function TestDefinition:testNauticalMile()
   lu.assertTrue( (200*_nmi):isclose(370.4 * _km,1e-4) )
end

function TestDefinition:testNauticalLeague()
   lu.assertTrue( (200*_nlea):isclose(1111 * _km,1e-3) )
end

function TestDefinition:testCables()
   lu.assertTrue( (23*_cbl):isclose(4262 * _m,1e-3) )
end

function TestDefinition:testFathom()
   lu.assertTrue( (12*_ftm):isclose(21.95 * _m,1e-3) )
end

function TestDefinition:testKnot()
   lu.assertTrue( (24*_kn):isclose(44.45 * _km/_h,1e-3) )
end


-- Area

function TestDefinition:testAcre()
   lu.assertTrue( (300*_ac):isclose(1.214e6 * _m^2,1e-3) )
end




-- Volume

function TestDefinition:testGallon()
   lu.assertTrue( (23*_L):isclose(5.059 * _gal,1e-3) )
end

function TestDefinition:testQuart()
   lu.assertTrue( (3*_hL):isclose(264 * _qt,1e-3) )
end

function TestDefinition:testPint()
   lu.assertTrue( (2*_daL):isclose(35.2 * _pint,1e-3) )
end

function TestDefinition:testCup()
   lu.assertTrue( (5.5*_cL):isclose(0.194 * _cup,1e-2) )
end

function TestDefinition:testGill()
   lu.assertTrue( (3.4*_cL):isclose(0.239 * _gi,1e-2) )
end

function TestDefinition:testFluidOunce()
   lu.assertTrue( (23*_mL):isclose(0.8095 * _fl_oz,1e-2) )
end

function TestDefinition:testFluidDram()
   lu.assertTrue( (800*_uL):isclose(0.2252 * _fl_dr,1e-2) )
end




-- Mass (Avoirdupois)

function TestDefinition:testGrain()
   lu.assertTrue( (34*_g):isclose(524.7 * _gr,1e-3) )
end

function TestDefinition:testPound()
   lu.assertTrue( (0.5*_kg):isclose(1.102311310925 * _lb,1e-6) )
end

function TestDefinition:testOunce()
   lu.assertTrue( (0.3*_kg):isclose(10.582188584879999 * _oz,1e-6) )
end

function TestDefinition:testDram()
   lu.assertTrue( (45*_g):isclose(25.397252603684997 * _dr,1e-6) )
end

function TestDefinition:testStone()
   lu.assertTrue( (34*_kg):isclose(5.354083510212 * _st,1e-6) )
end

function TestDefinition:testQuarter()
   lu.assertTrue( (300*_kg):isclose(23.62095666267 * _qtr,1e-6) )
end

function TestDefinition:testHundredWeight()
   lu.assertTrue( (0.5*_t):isclose(9.8420652761 * _cwt,1e-6) )
end

function TestDefinition:testLongTon()
   lu.assertTrue( (45*_t):isclose(44.289293742495* _ton,1e-6) )
end


-- Mass (Troy)

function TestDefinition:testTroyPound()
   lu.assertTrue( (0.6*_kg):isclose(1.607537328432 * _lb_t,1e-6) )
end

function TestDefinition:testTroyOunce()
   lu.assertTrue( (0.2*_kg):isclose(6.43014931372 * _oz_t,1e-6) )
end

function TestDefinition:testPennyWeight()
   lu.assertTrue( (78*_g):isclose(50.155164647094004 * _dwt,1e-6) )
end


-- Mass (Others)

function TestDefinition:testFirkin()
   lu.assertTrue( (3*_kg):isclose(0.11810478331319998 * _fir,1e-6) )
end


-- Time
function TestDefinition:testSennight()
   lu.assertTrue( (3*_sen):isclose(21 * _d,1e-6) )
end

function TestDefinition:testFortnight()
   lu.assertTrue( (2*_ftn):isclose(28 * _d,1e-6) )
end

-- Temperature
function TestDefinition:testFahrenheit()
   local theta = -457.87*_degF
   lu.assertTrue(  (theta + _degF_0):to(_K):isclose(1*_K, 0.001) )

   -- the isclose function treats temperature units as differences
   local theta_1 = 32 * _degF
   local theta_2 = 0 * _degC
   lu.assertTrue( ((theta_1 + _degF_0):to(_K)):isclose((theta_2 + _degC_0):to(_K,true), 0.001) )
  
   local theta_1 = 69.8*_degF
   local theta_2 = 21*_degC
   lu.assertTrue( ((theta_1 + _degF_0):to(_K)):isclose((theta_2 + _degC_0):to(_K,true), 0.001) )
  
   local theta_1 = 98.6*_degF
   local theta_2 = 37*_degC
   lu.assertTrue( ((theta_1 + _degF_0):to(_K)):isclose((theta_2 + _degC_0):to(_K,true), 0.001) )
  

   local theta_1 = 212.0*_degF
   local theta_2 = 100*_degC
   lu.assertTrue( ((theta_1 + _degF_0):to(_K)):isclose((theta_2 + _degC_0):to(_K,true), 0.001) )
end


-- Others

function TestDefinition:testPoundForce()
   lu.assertTrue( (12*_lbf):isclose(53.3787 * _N,1e-4) )
end

function TestDefinition:testPoundal()
   lu.assertTrue( (99*_pdl):isclose(13.6872 * _N,1e-4) )
end

function TestDefinition:testSlug()
   lu.assertTrue( (0.5*_slug):isclose(7296.95 * _g,1e-4) )
end

function TestDefinition:testPsi()
   lu.assertTrue( (29.0075*_psi):isclose(2 * _bar,1e-4) )
end

function TestDefinition:testThermochemicalBritishThermalUnit()
   lu.assertTrue( (_BTU):isclose( _kcal*_lb*_degF/(_kg*_K) ,1e-8) )
end

function TestDefinition:testInternationalBritishThermalUnit()
   lu.assertTrue( (_BTU_it):isclose( _kcal_IT*_lb*_degF/(_kg*_K) ,1e-8) )
end

function TestDefinition:testHorsepower()
   lu.assertTrue( (700*_hp):isclose( 521990*_W ,1e-4) )
end


-- US CUSTOMARY UNITS
-- ******************

-- Length
function TestDefinition:testUSinch()
   lu.assertTrue( (12333*_in_US):isclose( 12333.024666*_in ,1e-6) )
end

function TestDefinition:testUShand()
   lu.assertTrue( (3*_hh_US):isclose( 12.00002400005*_in ,1e-9) )
end

function TestDefinition:testUSFoot()
   lu.assertTrue( (12*_ft_US):isclose( 144.0002880006*_in ,1e-9) )
end

function TestDefinition:testUSLink()
   lu.assertTrue( (56*_li_US):isclose( 11.265430530872*_m ,1e-7) )
end

function TestDefinition:testUSYard()
   lu.assertTrue( (3937*_yd_US):isclose( 3600*_m ,1e-9) )
end

function TestDefinition:testUSRod()
   lu.assertTrue( (74*_rd_US):isclose( 372.16154432*_m ,1e-10) )
end

function TestDefinition:testUSChain()
   lu.assertTrue( (0.5*_ch_US):isclose( 100.58420117*_dm ,1e-10) )
end

function TestDefinition:testUSFurlong()
   lu.assertTrue( (56*_fur_US):isclose( 11.265430531*_km ,1e-10) )
end

function TestDefinition:testUSMile()
   lu.assertTrue( (2.4*_mi_US):isclose( 3.8624333249*_km ,1e-10) )
end

function TestDefinition:testUSLeague()
   lu.assertTrue( (5.5*_lea_US):isclose( 26.554229108*_km ,1e-10) )
end

function TestDefinition:testUSFathom()
   lu.assertTrue( (5.5*_ftm_US):isclose( 100.58420117*_dm ,1e-10) )
end

function TestDefinition:testUSCable()
   lu.assertTrue( (45*_cbl_US):isclose( 987.55*_dam ,1e-5) )
end

-- Area
function TestDefinition:testUSAcre()
   lu.assertTrue( (45*_ac_US):isclose( 182109.26744*_m^2 ,1e-9) )
end

-- Volume
function TestDefinition:testUSGallon()
   lu.assertTrue( (2*_gal_US):isclose( 1.665348369257978 * _gal ,1e-9) )
   lu.assertTrue( (2*_gal_US):isclose( 7.570823568*_L ,1e-9) )
end

function TestDefinition:testUSQuart()
   lu.assertTrue( (78*_qt_US):isclose( 738.15529788 * _dL ,1e-9) )
end

function TestDefinition:testUSPint()
   lu.assertTrue( (46*_pint_US):isclose( 2.1766117758 * _daL ,1e-9) )
end

function TestDefinition:testUSCup()
   lu.assertTrue( (2*_cup_US):isclose( 31.5450982 * _Tbsp ,1e-9) )
end

function TestDefinition:testUSGill()
   lu.assertTrue( (45*_gi_US):isclose( 5.3232353437499995 * _L ,1e-7) )
end

function TestDefinition:testUSFluidOunce()
   lu.assertTrue( (22*_fl_oz_US):isclose( 650.617653125 * _mL ,1e-7) )
end

function TestDefinition:testUSTablespoon()
   lu.assertTrue( (10*_Tbsp_US):isclose( 147.867648438 * _mL ,1e-7) )
end

function TestDefinition:testUSTeaspoon()
   lu.assertTrue( (0.5*_tsp_US):isclose( 2464.46080729 * _uL ,1e-7) )
end

function TestDefinition:testUSFluidDram()
   lu.assertTrue( (1*_fl_dr_US):isclose( 3.6966911953125 * _mL ,1e-7) )
end

-- Mass

function TestDefinition:testUSQuarter()
   lu.assertTrue( (23*_qtr_US):isclose( 260.81561275 * _kg ,1e-7) )
end

function TestDefinition:testUSHunderdWeight()
   lu.assertTrue( (1.4*_cwt_US):isclose( 63.5029318 * _kg ,1e-7) )
end

function TestDefinition:testUSTon()
   lu.assertTrue( (2*_ton_US):isclose( 1.81436948 * _t ,1e-7) )
end

return TestDefinition



