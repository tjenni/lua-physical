--[[
This file contains the unit tests for the physical.Quantity class.

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

local lu = require("luaunit")

package.path = "../?.lua;" .. package.path
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


TestQuantity = {}

function TestQuantity:testToString()
   lu.assertEquals( tostring(5 * _m), "5 * _m" )
   lu.assertEquals( tostring(5 * _m^2), "5 * _m^2" )
   lu.assertEquals( tostring(5 * _km/_h), "5 * _km / _h" )

   lu.assertEquals( tostring( N(2.7,0.04) * _g/_cm^3), "(2.70 +/- 0.04) * _g / _cm^3" )
end


function TestQuantity:testToSIUnitX()
   lu.assertEquals( (5 * _m):tosiunitx(), "\\SI{5}{\\meter}" )
   lu.assertEquals( (5 * _m^2):tosiunitx(), "\\SI{5}{\\meter\\tothe{2}}" )

   lu.assertEquals( (56 * _km):tosiunitx(), "\\SI{56}{\\kilo\\meter}" )
   lu.assertEquals( (5 * _km/_h):tosiunitx(), "\\SI{5}{\\kilo\\meter\\per\\hour}" )
   lu.assertEquals( (4.81 * _J / (_kg * _K) ):tosiunitx(), "\\SI{4.81}{\\joule\\per\\kilogram\\per\\kelvin}" )

   lu.assertEquals( (N(2.7,0.04) * _g/_cm^3):tosiunitx(), "\\SI{2.70(4)}{\\gram\\per\\centi\\meter\\tothe{3}}" )
end





function TestQuantity.addError()
   local l = 5*_m + 10*_s
end
function TestQuantity:testAdd()
   local l = 5*_m + 10*_m
   lu.assertEquals( l.value, 15 )
   lu.assertEquals( l.dimension, _m.dimension )

   lu.assertError( addError )
end


function TestQuantity.subtractError()
   local l = 5*_m - 10*_s
end
function TestQuantity:testSubtract()
   local l = 5*_m - 15*_m
   lu.assertEquals( l.value, -10 )
   lu.assertEquals( l.dimension, _m.dimension )

   lu.assertError( subtractError )
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
end

-- test absolute value function
function TestQuantity:testAbs()
   local l = (-45.3 * _m):abs()
   lu.assertEquals( l.value, 45.3 )
   lu.assertEquals( l.dimension, _m.dimension )

   local l = (N(-233,3) * _m^2):abs()
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

-- test exponential function
function TestQuantity.expError()
   local l = (100 * _s):log()
end
function TestQuantity:testExp()
   lu.assertError( expError )

   local l = (-2*_m/(5*_m)):exp()
   lu.assertAlmostEquals( l.value, 0.670320046035639, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test sine function
function TestQuantity.sinError()
   local l = (100 * _s):sin()
end
function TestQuantity:testSin()
   lu.assertError( sinError )

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

   local l = (0.9 * _1):atanh()
   lu.assertAlmostEquals( l.value, 1.47221948958322, 1e-9 )

   local l = (N(0.9,0.01) * _1):atanh()
   lu.assertAlmostEquals( l.value:__tonumber(), 1.47221948958322, 1e-9 )
end

return TestQuantity
