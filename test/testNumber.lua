--[[
This file contains the unit tests for the physical.Number class.

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


function defaultformat()
   N.seperateUncertainty = true
   N.omitUncertainty = false
   N.format = N.DECIMAL
end


TestNumber = {} 



-- test the default constructor
function TestNumber:testNewDefault()
   local n = N(0)
   lu.assertEquals( n._x, 0 )
   lu.assertEquals( n._dx, 0 )
end

-- test if the constructor works with one or two numbers as arguments
function TestNumber:testNewByNumber()
   local n = N(122,0.022)
   lu.assertEquals( n._x, 122 )
   lu.assertEquals( n._dx, 0.022 )

   local n = N(122,0)
   lu.assertEquals( n._x, 122 )
   lu.assertEquals( n._dx, 0 )

   local n = N(0, 0.01)
   lu.assertEquals( n._x, 0 )
   lu.assertEquals( n._dx, 0.01 )
end

-- test the copy constructor
function TestNumber:testNewCopyConstructor()
   local n = N(122,0.022)
   local m = N(n)
   lu.assertEquals( m._x, 122 )
   lu.assertEquals( m._dx, 0.022 )
end

-- test construction by string in plus minus format
function TestNumber:testNewByStringPlusMinusNotation()
   local n = N("2.2 +/- 0.3")
   lu.assertEquals( n._x, 2.2 )
   lu.assertEquals( n._dx, 0.3 )

   local n = N("2e-3 +/- 0.0003")
   lu.assertEquals( n._x, 0.002 )
   lu.assertEquals( n._dx, 0.0003 )

   local n = N("67 +/- 2e-2")
   lu.assertEquals( n._x, 67 )
   lu.assertEquals( n._dx, 0.02 )

   local n = N("15.2e-3 +/- 10.4e-6")
   lu.assertEquals( n._x, 0.0152 )
   lu.assertEquals( n._dx, 0.0000104 )
end

-- test construction by string in compact format
function TestNumber:testNewByString()
   local n = N("2.32(5)")
   lu.assertEquals( n._x, 2.32 )
   lu.assertEquals( n._dx, 0.05 )

   local n = N("2.32(51)")
   lu.assertEquals( n._x, 2.32 )
   lu.assertEquals( n._dx, 0.51 )

   local n = N("4.566(5)e2")
   lu.assertAlmostEquals( n._x, 456.6, 0.01 )
   lu.assertEquals( n._dx, 0.5 )

   local n = N("2.30(55)e3")
   lu.assertAlmostEquals( n._x, 2300, 0.1)
   lu.assertEquals( n._dx, 550 )

   local n = N("255.30(55)e6")
   lu.assertAlmostEquals( n._x, 255300000, 0.1)
   lu.assertEquals( n._dx, 550000 )
end

-- test construction by string in compact format
function TestNumber:testNewByStringNumber()
   local n = N("1")
   lu.assertEquals( n._x, 1 )
   lu.assertEquals( n._dx, 0.5 )

   local n = N("2.3")
   lu.assertEquals( n._x, 2.3 )
   lu.assertEquals( n._dx, 0.05 )

   local n = N("2.3e-2")
   lu.assertEquals( n._x, 2.3e-2 )
   lu.assertEquals( n._dx, 0.05e-2 )

   local n = N("123")
   lu.assertEquals( n._x, 123 )
   lu.assertEquals( n._dx, 0.5 )

   local n = N("123.556")
   lu.assertEquals( n._x, 123.556 )
   lu.assertEquals( n._dx, 0.0005 )
end



-- test string conversion to plus-minus format
function TestNumber:testToPlusMinusNotation()

   N.seperateUncertainty = true
   
   N.format = N.DECIMAL
   lu.assertEquals( tostring(N(1,0.5)), "(1.0 +/- 0.5)" )
   lu.assertEquals( tostring(N(7,1)), "(7.0 +/- 1.0)" )
   lu.assertEquals( tostring(N(0.005,0.0001)), "(0.00500 +/- 0.00010)" )
   lu.assertEquals( tostring(N(500,2)), "(500 +/- 2)" )
   lu.assertEquals( tostring(N(1023453838.0039,0.06)), "(1023453838.00 +/- 0.06)" )
   lu.assertEquals( tostring(N(10234.0039, 0.00000000012)), "(10234.00390000000 +/- 0.00000000012)" )
   lu.assertEquals( tostring(N(10234.0039e12, 0.00000000012e12)), "(10234003900000000 +/- 120)" )
   lu.assertEquals( tostring(N(0, 0)), "0" )
   lu.assertEquals( tostring(N(0, 0.01)), "(0.000 +/- 0.010)" )

   N.format = N.SCIENTIFIC
   lu.assertEquals( tostring(N(7,1)), "(7 +/- 1)" )
   lu.assertEquals( tostring(N(80,22)), "(8 +/- 2)e1" )
   lu.assertEquals( tostring(N(40,100)), "(4 +/- 10)e1" )
   lu.assertEquals( tostring(N(0.005,0.0001)), "(5.00 +/- 0.10)e-3" )
   lu.assertEquals( tostring(N(500,2)), "(5.00 +/- 0.02)e2" )

end

-- test string conversion to plus-minus format
function TestNumber:testToParenthesesNotation()

   N.seperateUncertainty = false
   N.omitUncertainty = false

   N.format = N.DECIMAL
   lu.assertEquals( tostring(N(1,0.5)), "1.0(5)" )
   lu.assertEquals( tostring(N(1.25,0.5)), "1.3(5)" )
   lu.assertEquals( tostring(N(100,13)), "100(13)" )
   lu.assertEquals( tostring(N(26076,45)), "26076(45)" )
   lu.assertEquals( tostring(N(26076,0.01)), "26076.000(10)" )
   lu.assertEquals( tostring(N(1234.56789, 0.00011)), "1234.56789(11)" )
   lu.assertEquals( tostring(N(15200000, 23000)), "15200000(23000)" )
   lu.assertEquals( tostring(N(5, 0.01)), "5.000(10)" )
   lu.assertEquals( tostring(N(100, 5)), "100(5)"  )
   
   N.format = N.SCIENTIFIC
   lu.assertEquals( tostring(N(15.2e-6, 2.3e-8)), "1.520(2)e-5" )
   lu.assertEquals( tostring(N(15.2e-6, 1.2e-8)), "1.5200(12)e-5" )
   lu.assertEquals( tostring(N(5, 0.01)), "5.000(10)" )
   lu.assertEquals( tostring(N(15.2e-6, 0)), "1.52e-05" )
   lu.assertEquals( tostring(N(16.25e-6, 5e-7)), "1.62(5)e-5" )

   lu.assertEquals( tostring(N(1.9884e30, 2e26)/N(1.191e8,1.4e6)), "1.67(2)e22" )
end



-- test string conversion to compact format
function TestNumber:testToOmitUncertaintyNotation()
   N.seperateUncertainty = false
   N.omitUncertainty = true

   N.format = N.DECIMAL
   lu.assertEquals( tostring(N(1, 0.5)), "1" )
   lu.assertEquals( tostring(N(1.2, 0.05)), "1.2" )
   lu.assertEquals( tostring(N(1.2, 0.005)), "1.20" )
   lu.assertEquals( tostring(N(1.25, 0.05)), "1.3" )



   N.format = N.SCIENTIFIC
   lu.assertEquals( tostring(N(1.2e27, 0.05e27)), "1.2e27" )

end


-- test string conversion from compact to plus-minus format
function TestNumber:testParseParenthesesNotation()
   defaultformat()

   local n = N("2.32(5)")
   lu.assertEquals( tostring(n), "(2.32 +/- 0.05)" )

   local n = N("2.32(51)")
   lu.assertEquals( tostring(n), "(2.3 +/- 0.5)" )

   local n = N("4.566(5)e2")
   lu.assertEquals( tostring(n), "(456.6 +/- 0.5)" )

   local n = N("2.30(55)e3")
   lu.assertEquals( tostring(n), "(2300 +/- 550)" )
end

-- test string conversion from and to plus-minus format
function TestNumber:testParsePlusMinusNotation()
   defaultformat()

   local n = N("2.2 +/- 0.3")
   lu.assertEquals( tostring(n), "(2.2 +/- 0.3)" )

   local n = N("2.2+/-0.3")
   lu.assertEquals( tostring(n), "(2.2 +/- 0.3)" )

   local n = N("2e-3 +/- 0.0003")
   lu.assertEquals( tostring(n), "(0.0020 +/- 0.0003)" )

   local n = N("67 +/- 2e-2")
   lu.assertEquals( tostring(n), "(67.00 +/- 0.02)" )
end

-- test the frexp function
function TestNumber:testfrexp()
   local m,e = N._frexp(123)

   lu.assertEquals( m, 1.23 )
   lu.assertEquals( e, 2 )
end






-- test widget
-- http://www.wolframalpha.com/widgets/gallery/view.jsp?id=ff2d5fc3ab1932df3c00308bead36006

-- article on 
-- https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3387884/

-- test addition of numbers and other physical numbers
function TestNumber:testAdd()
   defaultformat()

   local n1 = N(5, 0.5)
   local n2 = N(10, 0.2)

   lu.assertEquals( tostring(2+n2), "(12.0 +/- 0.2)" )
   lu.assertEquals( tostring(n1+3), "(8.0 +/- 0.5)" )
   lu.assertEquals( tostring(n1+n2), "(15.0 +/- 0.5)" )
end

-- test subtraction of numbers and other physical numbers
function TestNumber:testSubtract()
   defaultformat()

   local n1 = N(5, 0.5)
   local n2 = N(10, 0.2)

   lu.assertEquals( tostring(2-n2), "(-8.0 +/- 0.2)" )
   lu.assertEquals( tostring(n1-3), "(2.0 +/- 0.5)" )
   lu.assertEquals( tostring(n1-n2), "(-5.0 +/- 0.5)" )
end

-- test mixed operations
function TestNumber:testMixed()
   defaultformat()

   local d = N(5, 0.5)

   l = d - d
   m = l / d

   lu.assertEquals( tostring(m), "0.0" )
end

-- test unary minus operation
function TestNumber:testUnaryMinus()
   defaultformat()

   local n = N(5.68, 0.2)

   lu.assertEquals( tostring(-n), "(-5.7 +/- 0.2)" )
   lu.assertEquals( tostring(-(-n)), "(5.7 +/- 0.2)" )
end

-- test multiplication with numbers and other physical numbers
function TestNumber:testMultiplication()
   defaultformat()

   local n1 = N(4.52, 0.02)
   local n2 = N(2.0, 0.2)

   lu.assertEquals( tostring(4*n2), "(8.0 +/- 0.8)" )
   lu.assertEquals( tostring(n1*5), "(22.60 +/- 0.10)" )
   lu.assertEquals( tostring(n1*n2), "(9.0 +/- 0.9)" )
end


-- test division with numbers and other physical numbers
function TestNumber:testDivision()
   defaultformat()

   local n1 = N(2.0, 0.2)
   local n2 = N(3.0, 0.6)

   lu.assertEquals( tostring(5/n2), "(1.7 +/- 0.3)" )
   lu.assertEquals( tostring(n1/6), "(0.33 +/- 0.03)" )
   lu.assertEquals( tostring(n1/n2), "(0.67 +/- 0.15)" )
end


-- uncertainty calculator physics
-- http://ollyfg.github.io/Uncertainty-Calculator/
function TestNumber:testPower()
   defaultformat()

   local n1 = N(3.0, 0.2)
   local n2 = N(2.5, 0.01)

   lu.assertEquals( tostring(n1^2), "(9.0 +/- 1.2)" )
   lu.assertEquals( tostring(3^n2), "(15.59 +/- 0.17)" )
   lu.assertEquals( tostring(n1^n2), "(16 +/- 3)" )
end

-- test the absolute value function
function TestNumber:testAbs()
   defaultformat()

   local n = N(-5.0, 0.2)
   lu.assertEquals( tostring(n:abs()), "(5.0 +/- 0.2)" )

   local n = N(100, 50)
   lu.assertEquals( tostring(n:abs()), "(100 +/- 50)" )
end

-- test the logarithm function
function TestNumber:testLog()
   defaultformat()

   local n = N(5.0, 0.2)
   lu.assertEquals( tostring(n:log()), "(1.61 +/- 0.04)" )

   local n = N(0.03, 0.003)
   lu.assertEquals( tostring(n:log()), "(-3.51 +/- 0.10)" )

   local n = N(0.03, 0.003)
   lu.assertEquals( tostring(n:log(4)), "(-2.53 +/- 0.07)" )

   local n = N(5.0, 0.2)
   lu.assertEquals( tostring(n:log(10)), "(0.699 +/- 0.017)" )

   local n = N(0.03, 0.003)
   lu.assertEquals( tostring(n:log(10)), "(-1.52 +/- 0.04)" )
end

-- test the exponential function
function TestNumber:testExp()
   defaultformat()

   local n = N(7.0, 0.06)
   lu.assertEquals( tostring(n:exp()), "(1097 +/- 66)" )

   local n = N(0.2, 0.01)
   lu.assertEquals( tostring(n:exp()), "(1.221 +/- 0.012)" )
end

-- test the square root function
function TestNumber:testSqrt()
   defaultformat()

   local n = N(104.2, 0.06)
   lu.assertEquals( tostring(n:sqrt()), "(10.208 +/- 0.003)" )

   local n = N(0.0004, 0.000005)
   lu.assertEquals( tostring(n:sqrt()), "(0.02000 +/- 0.00013)" )
end



-- TRIGONOMETRIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Trigonometric_functions

function TestNumber:testSin()
   defaultformat()

   local n = N(-math.pi/6, 0.02)
   lu.assertEquals( tostring(n:sin()), "(-0.500 +/- 0.017)" )
end


function TestNumber:testCos()
   defaultformat()

   local n = N(math.pi/3, 0.01)
   lu.assertEquals( tostring(n:cos()), "(0.500 +/- 0.009)" )

   local n = N(math.pi/4, 0.1)
   lu.assertEquals( tostring(n:cos()), "(0.71 +/- 0.07)" )

   local n = N(-math.pi/6, 0.02)
   lu.assertEquals( tostring(n:cos()), "(0.87 +/- 0.01)" )
end

function TestNumber:testTan()
   defaultformat()

   local n = N(0, 0.01)
   lu.assertEquals( tostring(n:tan()), "(0.000 +/- 0.010)" )

   local n = N(math.pi/3, 0.1)
   lu.assertEquals( tostring(n:tan()), "(1.7 +/- 0.4)" )

   local n = N(-math.pi/3, 0.02)
   lu.assertEquals( tostring(n:tan()), "(-1.73 +/- 0.08)" )
end


-- INVERS TRIGONOMETRIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#arctan

function TestNumber:testArcsin()
   defaultformat()

   local n = N(0.5, 0.01)
   lu.assertEquals( tostring(n:asin()), "(0.524 +/- 0.012)" )
end


function TestNumber:testArccos()
   defaultformat()

   local n = N(0.5, 0.01)
   lu.assertEquals( tostring(n:acos()), "(1.047 +/- 0.012)" )
end

function TestNumber:testArctan()
   defaultformat()

   local n = N(0.5, 0.01)
   lu.assertEquals( tostring(n:atan()), "(0.464 +/- 0.008)" )
end


-- HYPERBOLIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Hyperbolic_function

function TestNumber:testSinh()
   defaultformat()

   local n = N(10, 0.003)
   lu.assertEquals( tostring(n:sinh()), "(11013 +/- 33)" )
end

function TestNumber:testCosh()
   defaultformat()

   local n = N(10, 0.003)
   lu.assertEquals( tostring(n:cosh()), "(11013 +/- 33)" )
end

function TestNumber:testTanh()
   defaultformat()

   local n = N(1, 0.003)
   lu.assertEquals( tostring(n:tanh()), "(0.7616 +/- 0.0013)" )
end


-- INVERS HYPERBOLIC FUNCTIONS
-- https://en.wikipedia.org/wiki/Inverse_hyperbolic_function

function TestNumber:testArcsinh()
   local n = N(1000, 5)
   lu.assertEquals( tostring(n:asinh()), "(7.601 +/- 0.005)" )
end

function TestNumber:testArccosh()
   local n = N(1000, 5)
   lu.assertEquals( tostring(n:acosh()), "(7.601 +/- 0.005)" )
end

function TestNumber:testArctanh()
   local n = N(0.2, 0.01)
   lu.assertEquals( tostring(n:atanh()), "(0.203 +/- 0.010)" )
end


return TestNumber
