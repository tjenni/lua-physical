--[[
This file contains the unit tests for the physical.Quantity class.

Copyright (c) 2023 Thomas Jenni

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
local Q = physical.Quantity

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


TestQuantity = {}

-- Quantity.new(q)
function TestQuantity:testEmptyConstructor()
   local q = Q()
   lu.assertEquals( q.value, nil )
end
function TestQuantity:testNumberConstructor()
   local q = Q(42)
   lu.assertEquals( q.value, 42 )
   lu.assertTrue( q.dimension:iszero() )
end
function TestQuantity:testCopyConstructor()
   local q = Q(73*_m)
   lu.assertEquals( q.value, 73 )
   lu.assertTrue( q.dimension == _m.dimension )
end



function TestQuantity:testToString()
   N.seperateUncertainty = true

   lu.assertEquals( tostring(5 * _m), "5 * _m" )
   lu.assertEquals( tostring(5 * _m^2), "5.0 * _m^2" )
   lu.assertEquals( tostring(5 * _km/_h), "5.0 * _km / _h" )

   lu.assertEquals( tostring( N(2.7,0.04) * _g/_cm^3), "(2.70 +/- 0.04) * _g / _cm^3" )
end


function TestQuantity:testToSIUnitX()
   N.seperateUncertainty = false
   
   lu.assertEquals( (5 * _m):tosiunitx(), "\\qty{5}{\\meter}" )
   lu.assertEquals( (5 * _m):tosiunitx("x=1"), "\\qty[x=1]{5}{\\meter}" )

   lu.assertEquals( (5 * _m):tosiunitx("x=5",1), "\\num[x=5]{5}" )
   lu.assertEquals( (5 * _m):tosiunitx("x=5",2), "\\unit[x=5]{\\meter}" )

   lu.assertEquals( (5 * _m^2):tosiunitx(), "\\qty{5.0}{\\meter\\tothe{2}}" )

   lu.assertEquals( (56 * _km):tosiunitx(), "\\qty{56}{\\kilo\\meter}" )
   lu.assertEquals( (5 * _km/_h):tosiunitx(), "\\qty{5.0}{\\kilo\\meter\\per\\hour}" )
   lu.assertEquals( (4.81 * _J / (_kg * _K) ):tosiunitx(), "\\qty{4.81}{\\joule\\per\\kilogram\\per\\kelvin}" )

   lu.assertEquals( (N(2.7,0.04) * _g/_cm^3):tosiunitx(), "\\qty{2.70(4)}{\\gram\\per\\centi\\meter\\tothe{3}}" )
end





function TestQuantity.addError()
   local l = 5*_m + 10*_s
end
function TestQuantity:testAdd()
   local l = 5*_m + 10*_m
   lu.assertEquals( l.value, 15 )
   lu.assertEquals( l.dimension, _m.dimension )

   local msg = "Error: Cannot add '5 * _m' to '10 * _s', because they have different dimensions."
   lu.assertErrorMsgContains(msg, TestQuantity.addError )
end




function TestQuantity.subtractError()
   local l = 5*_m - 10*_s
end
function TestQuantity:testSubtract()
   local l = 5*_m - 15*_m
   lu.assertEquals( l.value, -10 )
   lu.assertEquals( l.dimension, _m.dimension )

   local msg = "Error: Cannot subtract '10 * _s' from '5 * _m', because they have different dimensions."
   lu.assertErrorMsgContains(msg, TestQuantity.subtractError )
end


function TestQuantity:testUnaryMinus()
   local l = -5*_m
   lu.assertEquals( l.value, -5 )
   lu.assertEquals( l.dimension, _m.dimension )
end


function TestQuantity:testMultiply()
   local A = 5*_m * 10 * _m
   lu.assertEquals( A.value, 50 )
   lu.assertEquals( A.dimension, (_m^2).dimension )
end


function TestQuantity:testMultiplyOfTemperatures()
   local m_1 = 5 * _kg
   local m_2 = 3 * _kg
   local T_1 = 20 * _degC
   local T_2 = 40 * _degC

   -- if one multiplies a temperature by another quantity
   -- the temperature will be interpreted as a temperature difference
   local T_m = ( (m_1*T_1 + m_2*T_2) / (m_1 + m_2) ):to(_degC, false)

   lu.assertEquals( T_m.value, 27.5 )


   local m_1 = 5 * _kg
   local m_2 = 3 * _kg
   local T_1 = 20 * _degF
   local T_2 = 40 * _degF

   -- if one multiplies a temperature by another quantity
   -- the temperature will be interpreted as a temperature difference.
   local T_m = ( (m_1*T_1 + m_2*T_2) / (m_1 + m_2) ):to(_degC, false)

   lu.assertAlmostEquals( T_m.value, 15.277777777778, 1e-3 )
end


function TestQuantity:testMultiplyWithNumber()
   local one = N(1,0.1) * _1

   lu.assertEquals( one.value, N(1,0.1) )
   lu.assertEquals( one.dimension, (_1).dimension )

   local mu = ( N(1,0.1) * _u_0 ):to(_N/_A^2)
   lu.assertAlmostEquals( mu.value._dx, 1.256e-6, 1e-3 )
   lu.assertEquals( mu.dimension, (_N/_A^2).dimension )
end


function TestQuantity.divideError()
   local l = 7*_m / ((2*6 - 12)*_s)
end
function TestQuantity:testDivide()
   local v = 7*_m / (2*_s)
   lu.assertEquals( v.value, 3.5 )
   lu.assertEquals( v.dimension, (_m/_s).dimension )

   lu.assertError( divideError )
end

-- test power function
function TestQuantity:testPow()
   local V = (5*_m)^3
   lu.assertEquals( V.value, 125 )
   lu.assertEquals( V.dimension, (_m^3).dimension )
end

function TestQuantity:testPowWithQuantityAsExponent()
   local V = (5*_m)^(24*_m / (12*_m))
   lu.assertAlmostEquals( V.value, 25, 0.00001 )
   lu.assertEquals( V.dimension, (_m^2).dimension )
end

-- test isclose function
function TestQuantity:testisclose()
   local rho1 = 19.3 * _g / _cm^3
   local rho2 = 19.2 * _g / _cm^3

   lu.assertTrue( rho1:isclose(rho2,0.1) )
   lu.assertTrue( rho1:isclose(rho2,10 * _percent) )
   lu.assertFalse( rho1:isclose(rho2,0.1 * _percent) )
end

-- test min function
function TestQuantity:testMin()
   local l = Q.min(-2.5,5)
   lu.assertEquals( l.value, -2.5 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (3 * _cm):min(5 * _dm)
   lu.assertEquals( l.value, 3 )
   lu.assertEquals( l.dimension, _m.dimension )

   local q1 = 20 * _cm
   local q2 = 10 * _dm
   local q3 = 1 * _m
   lu.assertEquals( Q.min(q1,q2,q3), q1 )

   local q1 = 20 * _A
   lu.assertEquals( Q.min(q1), q1 )

   local q1 = N(10,1) * _s
   local q2 = N(9,1) * _s
   lu.assertEquals( q1:min(q2), q2 )
end

-- test max function
function TestQuantity:testMax()
   local l = Q.max(-2.5,5)
   lu.assertEquals( l.value, 5 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (3 * _m):max(5 * _m)
   lu.assertEquals( l.value, 5 )
   lu.assertEquals( l.dimension, _m.dimension )

   local q1 = 20 * _cm
   local q2 = 10 * _dm
   local q3 = 1 * _m
   lu.assertEquals( Q.max(q1,q2,q3), q2 )

   local q1 = 20 * _A
   lu.assertEquals( Q.max(q1), q1 )

   local q1 = N(10,1) * _s
   local q2 = N(9,1) * _s
   lu.assertEquals( q1:max(q2), q1 )
end

-- test absolute value function
function TestQuantity:testAbs()
   local l = Q.abs(-2.5)
   lu.assertEquals( l.value, 2.5 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (-45.3 * _m):abs()
   lu.assertEquals( l.value, 45.3 )
   lu.assertEquals( l.dimension, _m.dimension )

   local l = ( N(-233,3) * _m^2):abs()
   lu.assertEquals( l.value, N(233,3) )
   lu.assertEquals( l.dimension, (_m^2).dimension )
end

-- test square root function
function TestQuantity:testSqrt()
   local l = (103 * _cm^2):sqrt()
   lu.assertEquals( l.value, 10.148891565092219 )
   lu.assertEquals( l.dimension, _m.dimension )

   local l = (N(103,2) * _cm^2):sqrt()
   lu.assertAlmostEquals( l.value._x, 10.148891565092219, 0.0001 )
   lu.assertAlmostEquals( l.value._dx, 0.098532927816429, 0.0001 )
   lu.assertEquals( l.dimension, _m.dimension )
end

-- test logarithm function
function TestQuantity.logError()
   local l = (100 * _s):log()
end
function TestQuantity:testLog()
   lu.assertError( logError )

   local l = Q.log(2)
   lu.assertAlmostEquals( l.value, 0.693147180559945, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = Q.log(3 * _1)
   lu.assertAlmostEquals( l.value, 1.09861228866811, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = Q.log(2, 10)
   lu.assertAlmostEquals( l.value, 0.301029995663981, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = Q.log(4, 10 * _1)
   lu.assertAlmostEquals( l.value, 0.602059991327962, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = Q.log(4 * _1, 8 * _1)
   lu.assertAlmostEquals( l.value, 0.666666666666666, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (100 * _1):log()
   lu.assertAlmostEquals( l.value, 4.605170185988091, 0.0001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (600 * _m / (50000 * _cm)):log()
   lu.assertAlmostEquals( l.value, 0.182321556793955, 0.0001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = ( N(100,0) * _1 ):log()
   lu.assertAlmostEquals( l.value._x, 4.605170185988091, 0.0001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

function TestQuantity:testLogAdvanced()
   local L_I1 = N(125,0.1) * _dB
   local I_0 = 1e-12 * _W/_m^2
   local I_1 = ( I_0 * 10^(L_I1/10) ):to(_W/_m^2)

   local l = (I_1/I_0):log(10)
   lu.assertAlmostEquals( l.value._x, 12.5, 0.001 )
end

-- test exponential function
function TestQuantity.expError()
   local l = (100 * _s):log()
end
function TestQuantity:testExp()
   lu.assertError( expError )

   local l = (-2*_m/(5*_m)):exp()
   lu.assertAlmostEquals( l.value, 0.670320046035639, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = Q.exp(2)
   lu.assertAlmostEquals( l.value, 7.38905609893065, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test sine function
function TestQuantity.sinError()
   local l = (100 * _s):sin()
end
function TestQuantity:testSin()
   lu.assertError( sinError )

   local l = Q.sin(1.570796326794897)
   lu.assertAlmostEquals( l.value, 1, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (45 * _deg):sin()
   lu.assertAlmostEquals( l.value, 0.707106781186548, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test cosine function
function TestQuantity.cosError()
   local l = (100 * _s):cos()
end
function TestQuantity:testCos()
   lu.assertError( cosError )

   local l = Q.cos(0)
   lu.assertAlmostEquals( l.value, 1, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (50 * _deg):cos()
   lu.assertAlmostEquals( l.value, 0.642787609686539, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test tangens function
function TestQuantity.tanError()
   local l = (100 * _s):tan()
end
function TestQuantity:testTan()
   lu.assertError( tanError )

   local l = Q.tan(0.785398163397448)
   lu.assertAlmostEquals( l.value, 1, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
   
   local l = (50 * _deg):tan()
   lu.assertAlmostEquals( l.value, 1.19175359259421, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end


-- test asin function
function TestQuantity.asinError()
   local l = (100 * _s):asin()
end
function TestQuantity:testAsin()
   lu.assertError( asinError )

   local l = Q.asin(0.785398163397448)
   lu.assertAlmostEquals( l.value, 0.903339110766512, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.5 * _1):asin()
   lu.assertAlmostEquals( l.value, 0.523598775598299, 0.000001 )
   lu.assertEquals( l.dimension, _rad.dimension )
end


-- test acos function
function TestQuantity.acosError()
   local l = (100 * _s):acos()
end
function TestQuantity:testAcos()
   lu.assertError( acosError )

   local l = Q.acos(0.785398163397448)
   lu.assertAlmostEquals( l.value, 0.667457216028384, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.5 * _1):acos()
   lu.assertAlmostEquals( l.value, 1.047197551196598, 0.000001 )
   lu.assertEquals( l.dimension, _rad.dimension )
end


-- test atan function
function TestQuantity.atanError()
   local l = (100 * _s):atan()
end
function TestQuantity:testAtan()
   lu.assertError( atanError )

   local l = Q.atan(0.785398163397448)
   lu.assertAlmostEquals( l.value, 0.665773750028354, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.5 * _1):atan()
   lu.assertAlmostEquals( l.value, 0.463647609000806, 0.000001 )
   lu.assertEquals( l.dimension, _rad.dimension )
end

-- test sinh function
function TestQuantity.sinhError()
   local l = (100 * _s):sinh()
end
function TestQuantity:testSinh()
   lu.assertError( sinhError )

   local l = Q.sinh(2)
   lu.assertAlmostEquals( l.value, 3.626860407847019, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.75 * _1):sinh()
   lu.assertAlmostEquals( l.value, 0.82231673193583, 1e-9 )

   local l = (N(0.75,0.01) * _1):sinh()
   lu.assertAlmostEquals( l.value:__tonumber(), 0.82231673193583, 1e-9 )
end

-- test cosh function
function TestQuantity.coshError()
   local l = (100 * _s):cosh()
end
function TestQuantity:testCosh()
   lu.assertError( coshError )

   local l = Q.cosh(2)
   lu.assertAlmostEquals( l.value, 3.762195691083631, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.25 * _1):cosh()
   lu.assertAlmostEquals( l.value, 1.031413099879573, 1e-9 )

   local l = (N(0.25,0.01) * _1):cosh()
   lu.assertAlmostEquals( l.value:__tonumber(), 1.031413099879573, 1e-9 )
end

-- test tanh function
function TestQuantity.tanhError()
   local l = (100 * _s):tanh()
end
function TestQuantity:testTanh()
   lu.assertError( tanhError )

   local l = Q.tanh(2)
   lu.assertAlmostEquals( l.value, 0.964027580075817, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.5 * _1):tanh()
   lu.assertAlmostEquals( l.value, 0.46211715726001, 1e-9 )

   local l = (N(0.5,0.01) * _1):tanh()
   lu.assertAlmostEquals( l.value:__tonumber(), 0.46211715726001, 1e-9 )
end

-- test asinh function
function TestQuantity.asinhError()
   local l = (100 * _s):asinh()
end
function TestQuantity:testAsinh()
   lu.assertError( asinhError )

   local l = Q.asinh(1)
   lu.assertAlmostEquals( l.value, 0.881373587019543, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (2 * _1):asinh()
   lu.assertAlmostEquals( l.value, 1.44363547517881, 1e-9 )

   local l = (N(2,0.01) * _1):asinh()
   lu.assertAlmostEquals( l.value:__tonumber(), 1.44363547517881, 1e-9 )
end

-- test acosh function
function TestQuantity.acoshError()
   local l = (100 * _s):acosh()
end
function TestQuantity:testAcosh()
   lu.assertError( acoshError )

   local l = Q.acosh(1.5)
   lu.assertAlmostEquals( l.value, 0.962423650119207, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (1.2 * _1):acosh()
   lu.assertAlmostEquals( l.value, 0.622362503714779, 1e-9 )

   local l = (N(1.2,0.01) * _1):acosh()
   lu.assertAlmostEquals( l.value:__tonumber(), 0.622362503714779, 1e-9 )
end

-- test atanh function
function TestQuantity.atanhError()
   local l = (100 * _s):atanh()
end
function TestQuantity:testAtanh()
   lu.assertError( atanhError )

   local l = Q.atanh(0.5)
   lu.assertAlmostEquals( l.value, 0.549306144334055, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (0.9 * _1):atanh()
   lu.assertAlmostEquals( l.value, 1.47221948958322, 1e-9 )

   local l = (N(0.9,0.01) * _1):atanh()
   lu.assertAlmostEquals( l.value:__tonumber(), 1.47221948958322, 1e-9 )
end

-- test less than
function TestQuantity:testLessThan()

   local Pi = 3.1415926535897932384626433832795028841971693993751
   
   local l_D = 5 * _m
   local d_D = N(0.25,0.001) * _mm

   local d = N(5,0.01) * _cm
   local l = N(10,0.01) * _cm

   local I_max = N(1,0.001) * _A
   local B = N(0.5,0.001) * _mT

   local Nw = ( B*l/(_u_0*I_max) ):to(_1)
   local N_max = (l/d_D):to(_1)
   local l_max = (Nw*Pi*d):to(_m)

   lu.assertTrue(l_D < l_max)
end

-- test less than zero
function TestQuantity:testLessThanZero()
   lu.assertTrue(1*_1 > 0)
   lu.assertTrue(0*_1 > -1)
   lu.assertTrue(-1*_1 < 0)

   lu.assertTrue(0 < 1*_1)
   lu.assertTrue(-1 < 0*_1)
   lu.assertTrue(0 > -1*_1)
end


return TestQuantity
