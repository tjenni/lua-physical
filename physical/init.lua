local current_folder = (...):gsub('%.init$', '')

-- Source: http://kiki.to/blog/2014/04/12/rule-5-beware-of-multiple-files/

local Dimension = require(current_folder .. '.dimension')
local Unit = require(current_folder .. '.unit')
local Quantity = require(current_folder .. '.quantity')
local Number = require(current_folder .. '.number')

require(current_folder .. '.definition')

local Data = require(current_folder .. '.data')

local m = {
	Dimension = Dimension,
	Unit = Unit,
	Number = Number,
	Quantity = Quantity,
	Data = Data
}

return m