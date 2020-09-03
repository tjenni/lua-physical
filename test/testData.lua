--[[
This file contains the unit tests for the physical.Data object.

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

package.path = "../?.lua;" .. package.path

local physical = require("physical")

local Data = physical.Data
local D = physical.Dimension
local Q = physical.Quantitiy
local N = physical.Number

local N = physical.Number
N.compact = true

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         if getmetatable(v) == physical.Unit then
            s = s .. '['..k..'] = ' .. tostring(v) .. ','
         else
           s = s .. '['..k..'] = ' .. dump(v) .. ','
         end
      end
      return s .. '}\n'
   else
      return tostring(o)
   end
end


local function contains(table, val)
   for i=1,#table do
      if table[i] == val then 
         return true
      end
   end
   return false
end

local function count(table)
   local n = 0
   for k,v in pairs(table) do 
      n = n + 1
   end
   return n
end


TestData = {}


-- Test astronomical data

function TestData:testAstronomicalBodies()
   local bodies = Data.Astronomical()
   lu.assertTrue( contains(bodies,"Sun") )
   lu.assertTrue( contains(bodies,"Earth") )
   lu.assertTrue( contains(bodies,"Ceres") )
end

function TestData:testAstronomicalKeys()
   local keys = Data.Astronomical("Earth")

   lu.assertTrue( keys["Mass"] ~= nil )
   lu.assertTrue( keys["EquatorialRadius"] ~= nil )
end

function TestData:testSun()
   local m_s = N(1.9884e30, 2e26) * _kg
   lu.assertEquals( tostring(Data.Astronomical("Sun","Mass")), tostring(m_s) )
end

function TestData:testMercury()
   local m = (N(2.2031870799e13, 8.6e5) * _m^3 * _s^(-2)  / _Gc ):to()
   
   lu.assertEquals( tostring(Data.Astronomical("Mercury","Mass")), tostring(m) )
end

function TestData:testVenus()
   local m = Data.Astronomical("Sun","Mass") / N(4.08523719e5,8e-3)
   lu.assertEquals( tostring(Data.Astronomical("Venus","Mass")), tostring(m) )
end

function TestData:testEarth()
   local m = N("5.97220(60)e24") * _kg
   lu.assertEquals( tostring(Data.Astronomical("Earth","Mass")), tostring(m) )
end

function TestData:testMoon()
   local m = Data.Astronomical("Earth","Mass") * N(1.23000371e-2,4e-10)
   lu.assertEquals( tostring(Data.Astronomical("Moon","Mass")), tostring(m) )
end

function TestData:testMars()
   local m = Data.Astronomical("Sun","Mass") / N(3.09870359e6,2e-2)

   lu.assertEquals( tostring(Data.Astronomical("Mars","Mass")), tostring(m) )
end

function TestData:testJupiter()
   local m = Data.Astronomical("Sun","Mass") / N(1.047348644e3,1.7e-5)

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Jupiter","Mass")) )
end

function TestData:testSaturn()
   local m = Data.Astronomical("Sun","Mass") / N(3.4979018e3,1e-4)

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Saturn","Mass")) )
end

function TestData:testUranus()
   local m = Data.Astronomical("Sun","Mass") / N(2.290298e4,3e-2)

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Uranus","Mass")) )
end

function TestData:testNeptune()
   local m = Data.Astronomical("Sun","Mass") / N(1.941226e4,3e-2)

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Neptune","Mass")) )
end

function TestData:testPluto()
   local m = Data.Astronomical("Sun","Mass") / N(1.36566e8,2.8e4)

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Pluto","Mass")) )
end

function TestData:testEris()
   local m = Data.Astronomical("Sun","Mass") / N(1.191e8,1.4e6)
   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Eris","Mass")) )
end

function TestData:testCeres()
   local m = N(4.72e-10,3e-12) * Data.Astronomical("Sun","Mass")
   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Ceres","Mass")) )
end

function TestData:testPallas()
   local m = N(1.03e-10,3e-12) * Data.Astronomical("Sun","Mass")

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Pallas","Mass")) )
end

function TestData:testVesta()
   local m = N(1.35e-10,3e-12) * Data.Astronomical("Sun","Mass")

   lu.assertEquals(tostring(m), tostring(Data.Astronomical("Vesta","Mass")) )
end



-- Test isotope data
function TestQuantity.isotopeGetByAZError()
   local Z = Data.Isotope({56,55},"Z")
end
function TestData:testIsotopeGetByAZ()
   lu.assertEquals( Data.Isotope({4,2},"A"), 4 )
   lu.assertEquals( Data.Isotope({4,2},"Z"), 2 )

   lu.assertTrue( (28667 * _keV):isclose(Data.Isotope({3,3},"MassExcess"),1e-9) )

   lu.assertEquals( Data.Isotope({56,25},"A"), 56 )
   lu.assertEquals( Data.Isotope({56,25},"Z"), 25 )
  
   lu.assertTrue( (-2267 * _keV):isclose(Data.Isotope({3,3},"BindingEnergyPerNucleon"),1e-9) )

   lu.assertError( TestQuantity.isotopeGetByAZError )
end

function TestData:testIsotopeGetAllKeys()
   local row = Data.Isotope({4,2})
   lu.assertTrue( row["MassExcess"] ~= nil )
end


function TestData:testIsotopeGetByIsotopeName()
   lu.assertEquals( Data.Isotope("Helium-5","A"), 5 )

   
   lu.assertEquals( Data.Isotope("Helium-5","Z"), 2 )
   
   lu.assertEquals( Data.Isotope("Lithium5","A"), 5 )
   lu.assertEquals( Data.Isotope("Lithium5","Z"), 3 )

   lu.assertEquals( Data.Isotope("5He","A"), 5 )
   lu.assertEquals( Data.Isotope("5He","Z"), 2 )
end

function TestData:testIsotopeGetByElementName()
   local list = Data.Isotope("Fe","symbol")

   lu.assertEquals( count(list), 31 )
   lu.assertTrue( list["47Fe"] ~= nil )
   lu.assertTrue( list["56Fe"] ~= nil )
   lu.assertTrue( list["66Fe"] ~= nil )

   --print(dump(Data.Isotope("He",{"DecayModes","DecayModesIntensity"})))
end

function TestData:testIsotopeGetAll()
   local isotopes = Data.Isotope()

   lu.assertTrue( contains(isotopes,"6He") )
   lu.assertTrue( contains(isotopes,"55K") )
   lu.assertTrue( contains(isotopes,"209Rn") )
   lu.assertTrue( contains(isotopes,"295Ei") )
end


return TestData
