--[[
This file contains the unit tests for the physical.Dimension class.

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

local D = physical.Dimension

local L = D("L")
local M = D("M")
local T = D("T")
local I = D("I")
local K = D("K")
local N = D("N")
local J = D("J")


TestDimension = {} --class


-- Dimension.new(o=nil)
function TestDimension:testEmptyConstructor()
   local d = D()
   lu.assertTrue( d:iszero() )
end

function TestDimension:testConstructorByString()
   local d = D("Dimensionless")
   lu.assertTrue( d:iszero() )
end

function TestDimension:testCopyConstructor()
   local d1, d2

   d1 = D("Energy")
   lu.assertEquals( d1, M*L^2/T^2 )

   d2 = D(d1)
   lu.assertEquals( d2, M*L^2/T^2 )
end




function TestDimension:testDefine()
   local i1 = D("Force")^4
   local i2 = D.define("Insanity",i1)
   local i3 = D("Insanity")
   lu.assertEquals( i1, L^4 * M^4 * T^-8)
   lu.assertEquals( i2, L^4 * M^4 * T^-8)
   lu.assertEquals( i3, L^4 * M^4 * T^-8)
end

function TestDimension:testToString()
   local d = D("Force")
   lu.assertEquals( tostring(d), "[Force]" )

   local d = D(L^-1 * T * I^2 * K^3 * N^4 * J^5)
   lu.assertEquals( tostring(d), "[L]^-1 [T] [I]^2 [K]^3 [N]^4 [J]^5" )
end

function TestDimension:testEqual()
   local d1 = D("Energy")
   local d2 = D("Force")
   local d3 = D("Torque")

   lu.assertEquals( d1==d2, false)
   lu.assertEquals( d1==d3, true)
end

function TestDimension:testMultiply()
   local d1 = D("Force")
   local d2 = D("Energy")

   local d3 = d1 * d2
   local d4 = d2 * d1

   lu.assertEquals( d3, L^3 * M^2 * T^-4)
   lu.assertEquals( d3, d4)
end

function TestDimension:testDivide()
   local d1 = D("Force")
   local d2 = D("Energy")

   lu.assertEquals( d1, {1,1,-2,0,0,0,0,0,0})
   lu.assertEquals( d2, {2,1,-2,0,0,0,0,0,0})
   
   local d3 = d1 / d2
   local d4 = d2 / d1

   lu.assertEquals( d3, {-1,0,0,0,0,0,0,0,0})
   lu.assertNotEquals( d3, d4)
end

function TestDimension:testPow()
   local d = D("Length")^3
   lu.assertEquals( d, L^3)
end

function TestDimension:isequal()
   local d = D("Length")^3
   lu.assertTrue( d == L^3)

   local d = D("Force")
   lu.assertTrue( d == L * M / T^2)
end


-- Test Dimension Definitions

function TestDimension:testLength()
   lu.assertEquals(D("Length"), L)
   lu.assertEquals(D("L"), L)
end

function TestDimension:testMass()
   lu.assertEquals(D("Mass"), M)
   lu.assertEquals(D("M"), M)
end

function TestDimension:testTime()
   lu.assertEquals(D("Time"), T)
   lu.assertEquals(D("T"), T)
end

function TestDimension:testCreateByNameForce()
   lu.assertTrue( D("Force") == M*L/T^2 )
end

function TestDimension:testArea()
   lu.assertEquals(D("Area"), L^2)
end

function TestDimension:testVolume()
   lu.assertEquals(D("Volume"), L^3)
end

function TestDimension:testFrequency()
   lu.assertEquals(D("Frequency"), T^-1)
end

function TestDimension:testFrequency()
   lu.assertEquals(D("Frequency"), T^-1)
end

function TestDimension:testDensity()
   lu.assertEquals(D("Density"), M / D("Volume"))
end

function TestDimension:testVelocity()
   lu.assertEquals(D("Velocity"), L / T)
end

function TestDimension:testAcceleration()
   lu.assertEquals(D("Acceleration"), D("Velocity") / T)
end

function TestDimension:testForce()
   lu.assertEquals(D("Force"), M * D("Acceleration"))
end

function TestDimension:testEnergy()
   lu.assertEquals(D("Energy"),  D("Force") * L)
end

function TestDimension:testPower()
   lu.assertEquals(D("Power"), D("Energy") / T)
end

function TestDimension:testPower()
   lu.assertEquals(D("Power"), D("Energy") / T)
end

function TestDimension:testTorque()
   lu.assertEquals(D("Energy"), D("Torque"))
end

function TestDimension:testTorque()
   lu.assertEquals(D("Pressure"), D("Force") / D("Area"))
end

function TestDimension:testImpulse()
   lu.assertEquals(D("Impulse"), M * D("Velocity"))
end

function TestDimension:testSpecificAbsorbedDose()
   lu.assertEquals(D("Absorbed Dose"), D("Energy") / M)
end

function TestDimension:testHeatCapacity()
   lu.assertEquals(D("Heat Capacity"), D("Energy") / K)
end

function TestDimension:testSpecificHeatCapacity()
   lu.assertEquals(D("Specific Heat Capacity"), D("Energy") / (M * K) )
end

function TestDimension:testAngularMomentum()
   lu.assertEquals(D("Angular Momentum"), L * D("Impulse") )
end

function TestDimension:testAngularMomentofInertia()
   lu.assertEquals(D("Moment of Inertia"), D("Torque") * T^2 )
end

function TestDimension:testEntropy()
   lu.assertEquals(D("Entropy"), D("Energy") / K )
end

function TestDimension:testThermalConductivity()
   lu.assertEquals(D("Thermal Conductivity"), D("Power") / (L*K) )
end

function TestDimension:testElectricCharge()
   lu.assertEquals(D("Electric Charge"), D("Electric Current") * T )
end

function TestDimension:testElectricPermittivity()
   lu.assertEquals(D("Electric Permittivity"), D("Electric Charge")^2 / ( D("Force") * D("Area") ) )
end

function TestDimension:testElectricFieldStrength()
   lu.assertEquals(D("Electric Field Strength"), D("Force") / D("Electric Charge") )
end

function TestDimension:testElectricPotential()
   lu.assertEquals(D("Electric Potential"), D("Energy") / D("Electric Charge") )
end

function TestDimension:testElectricResistance()
   lu.assertEquals(D("Electric Resistance"), D("Electric Potential") / D("Electric Current") )
end

function TestDimension:testElectricConductance()
   lu.assertEquals(D("Electric Conductance"), 1 / D("Electric Resistance") )
end

function TestDimension:testElectricCapacitance()
   lu.assertEquals(D("Electric Capacitance"), D("Electric Charge") / D("Electric Potential")  )
end

function TestDimension:testElectricInductance()
   lu.assertEquals(D("Inductance"), D("Electric Potential") * T / D("Electric Current")  )
end

function TestDimension:testMagneticFluxDensity()
   lu.assertEquals(D("Magnetic Flux Density"), D("Force") / (D("Electric Charge") * D("Velocity"))  )
end

function TestDimension:testMagneticFlux()
   lu.assertEquals(D("Magnetic Flux"), D("Magnetic Flux Density") * D("Area")  )
end

function TestDimension:testMagneticPermeability()
   lu.assertEquals(D("Magnetic Permeability"), D("Magnetic Flux Density") * L / D("Electric Current")  )
end

function TestDimension:testMagneticFieldStrength()
   lu.assertEquals(D("Magnetic Field Strength"), D("Magnetic Flux Density") / D("Magnetic Permeability")  )
end

function TestDimension:testIntensity()
   lu.assertEquals(D("Intensity"), D("Power") / D("Area")  )
end

function TestDimension:testReactionRate()
   lu.assertEquals(D("Reaction Rate"), N / (T * D("Volume"))  )
end

function TestDimension:testCatalyticActivity()
   lu.assertEquals(D("Catalytic Activity"), N / T  )
end

function TestDimension:testChemicalPotential()
   lu.assertEquals(D("Chemical Potential"), D("Energy") / N  )
end

function TestDimension:testMolarConcentration()
   lu.assertEquals(D("Molar Concentration"), N / D("Volume")  )
end

function TestDimension:testMolarHeatCapacity()
   lu.assertEquals(D("Molar Heat Capacity"), D("Energy") / (K * N)  )
end

function TestDimension:testIlluminance()
   lu.assertEquals(D("Illuminance"), J / D("Area")  )
end

return TestDimension
