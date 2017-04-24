--[[
This file contains the unit tests for the physical.Data object.

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

local Data = physical.Data
local D = physical.Dimension
local Q = physical.Quantitiy
local N = physical.Number

local N = physical.Number
N.compact = true


TestData = {}

function TestData:testSun()
   local m_s = N(1.9884e30, 2e26) * _kg

   lu.assertEquals( tostring(Data.Astronomical.Sun.mass:to()), tostring(m_s) )
end

function TestData:testMercury()
   local m = (N(2.2031870799e13, 8.6e5) * _m^3 * _s^(-2)  / _Gc ):to()
   
   lu.assertEquals( tostring(Data.Astronomical.Mercury.mass), tostring(m) )
end

function TestData:testVenus()
   local m = Data.Astronomical.Sun.mass / N(4.08523719e5,8e-3)

   lu.assertEquals( tostring(Data.Astronomical.Venus.mass), tostring(m) )
end

function TestData:testEarth()
   local m = N("5.97220(60)e24") * _kg

   lu.assertEquals( tostring(Data.Astronomical.Earth.mass), tostring(m) )
end


function TestData:testMoon()
   local m = Data.Astronomical.Earth.mass * N(1.23000371e-2,4e-10)

   lu.assertEquals( tostring(Data.Astronomical.Moon.mass), tostring(m) )
end

function TestData:testMars()
   local m = Data.Astronomical.Sun.mass / N(3.09870359e6,2e-2)

   lu.assertEquals( tostring(Data.Astronomical.Mars.mass), tostring(m) )
end

function TestData:testJupiter()
   local m = Data.Astronomical.Sun.mass / N(1.047348644e3,1.7e-5)

   lu.assertEquals( tostring(Data.Astronomical.Jupiter.mass), tostring(m) )
end

function TestData:testSaturn()
   local m = Data.Astronomical.Sun.mass / N(3.4979018e3,1e-4)

   lu.assertEquals( tostring(Data.Astronomical.Saturn.mass), tostring(m) )
end

function TestData:testUranus()
   local m = Data.Astronomical.Sun.mass / N(2.290298e4,3e-2)

   lu.assertEquals( tostring(Data.Astronomical.Uranus.mass), tostring(m) )
end

function TestData:testNeptune()
   local m = Data.Astronomical.Sun.mass / N(1.941226e4,3e-2)

   lu.assertEquals( tostring(Data.Astronomical.Neptune.mass), tostring(m) )
end

function TestData:testPluto()
   local m = Data.Astronomical.Sun.mass / N(1.36566e8,2.8e4)

   lu.assertEquals( tostring(Data.Astronomical.Pluto.mass), tostring(m) )
end

function TestData:testEris()
   local m = Data.Astronomical.Sun.mass / N(1.191e8,1.4e6)
   lu.assertEquals( tostring(Data.Astronomical.Eris.mass), tostring(m) )
end

function TestData:testCeres()
   local m = N(4.72e-10,3e-12) * Data.Astronomical.Sun.mass
   lu.assertEquals( tostring(Data.Astronomical.Ceres.mass), tostring(m) )
end

function TestData:testPallas()
   local m = N(1.03e-10,3e-12) * Data.Astronomical.Sun.mass

   lu.assertEquals( tostring(Data.Astronomical.Pallas.mass), tostring(m) )
end

function TestData:testVesta()
   local m = N(1.35e-10,3e-12) * Data.Astronomical.Sun.mass

   lu.assertEquals( tostring(Data.Astronomical.Vesta.mass), tostring(m) )
end





function TestData:testIsotope_getByAZ()
   local o = Data.Isotopes._getByAZ(4,2)
   lu.assertEquals( o[1], 4 )
   lu.assertEquals( o[2], 2 )


   local o = Data.Isotopes._getByAZ(56,25)
   lu.assertEquals( o[1], 56 )
   lu.assertEquals( o[2], 25 )

   local o = Data.Isotopes._getByAZ(56,55)
   lu.assertEquals( o, nil )

   local o = Data.Isotopes._getByAZ(4,200)
   lu.assertEquals( o, nil )
end

function TestData:testIsotope_getByName()
   local o = Data.Isotopes._getByName("Helium-5")
   lu.assertEquals( o[1], 5 )
   lu.assertEquals( o[2], 2 )

   local o = Data.Isotopes._getByName("Helium5")
   lu.assertEquals( o, nil )

   local o = Data.Isotopes._getByName(" Helium-5")
   lu.assertEquals( o, nil )

   local o = Data.Isotopes._getByName("Heelium-5")
   lu.assertEquals( o, nil )

   local o = Data.Isotopes._getByName("5He")
   lu.assertEquals( o[1], 5 )
   lu.assertEquals( o[2], 2 )

   local o = Data.Isotopes._getByName("56Fe")
   lu.assertEquals( o[1], 56 )
   lu.assertEquals( o[2], 26 )

   local o = Data.Isotopes._getByName("5-He")
   lu.assertEquals( o, nil )

   local o = Data.Isotopes._getByName("5HeL")
   lu.assertEquals( o, nil )
end

function TestData:testIsotope_getValues()
   local I = Data.Isotopes._getValues(Data.Isotopes._getByName("Helium-5"))
   lu.assertEquals( I["Name"], "Helium" )
   lu.assertEquals( I["A"], 5 )
end

function TestData:testIsotope_getValueByKey()
   local name = Data.Isotopes._getValueByKey(Data.Isotopes._getByName("Helium-5"),"Name")
   lu.assertEquals( name, "Helium" )
end



-- http://nucleardata.nuclear.lu.se/toi/nuclide.asp?iZA=910231

function TestData:testIsotope_get()
   local name = Data.Isotopes.get("Helium-5","Name")
   lu.assertEquals( name, "Helium" )

   local ME = Data.Isotopes.get("Helium-5","MassExcess")
end

return TestData
