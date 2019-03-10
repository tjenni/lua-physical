--[[
This file contains the unit tests for the physical.Unit class.

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

local D = physical.Dimension
local U = physical.Unit


TestUnit = {}

function TestUnit:testNewDefault()
   local u = U.new()
   lu.assertEquals(u._term, {{},{}})
end

function TestUnit:testNewBaseUnit()
   local _m = U.new("m","meter")
   lu.assertEquals(_m.symbol, "m")
   lu.assertEquals(_m.name, "meter")
end

function TestUnit:testMultiply()
   local _m = U.new("m","meter")

   local _m2 = _m * _m

   lu.assertEquals(_m2.symbol, nil)
   lu.assertEquals(_m2.name, nil)
   lu.assertEquals(_m2._term[1][1][1], _m)
   lu.assertEquals(_m2._term[1][1][2], 1)
   lu.assertEquals(_m2._term[1][2][1], _m)
   lu.assertEquals(_m2._term[1][2][2], 1)
end

function TestUnit:testDivide()
   local _m = U.new("m","meter")

   local _m2 = _m / _m

   lu.assertEquals(_m2.symbol, nil)
   lu.assertEquals(_m2.name, nil)
   lu.assertEquals(_m2._term[1][1][1], _m)
   lu.assertEquals(_m2._term[1][1][2], 1)
   lu.assertEquals(_m2._term[2][1][1], _m)
   lu.assertEquals(_m2._term[2][1][2], 1)
end

function TestUnit:testPower()
   local _m = U.new("m","meter")

   local _m2 = _m^4

   lu.assertEquals(_m2.symbol, nil)
   lu.assertEquals(_m2.name, nil)
   lu.assertEquals(_m2._term[1][1][1], _m)
   lu.assertEquals(_m2._term[1][1][2], 4)
end

function TestUnit:testNewDerivedUnit()
   local _m = U.new("m","meter")
   local _m2 = U.new("m2","squaremeter", _m*_m)

   lu.assertEquals(_m2.symbol, "m2")
   lu.assertEquals(_m2.name, "squaremeter")
   lu.assertEquals(_m2._term[1][1][1], _m2)
   lu.assertEquals(_m2._term[1][1][2], 1)
end

function TestUnit:testNewDerivedUnit()
   local _m = U.new("m","meter")
   local _m2 = U.new("m2","squaremeter", _m*_m)

   lu.assertEquals(_m2.symbol, "m2")
   lu.assertEquals(_m2.name, "squaremeter")
   lu.assertEquals(_m2._term[1][1][1], _m2)
   lu.assertEquals(_m2._term[1][1][2], 1)
end

return TestUnit
