---
-- @Liquipedia
-- wiki=commons
-- page=Module:Icon
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute

local Class = require('Module:Class')
local Logic = require('Module:Logic')
local Lua = require('Module:Lua')

local IconData = Lua.import('Module:Icon/Data')
local Icon = {}

---@class IconProps
---@field iconName string
---@field color string?
---@field screenReaderHidden boolean?
---@field hover string?
---@field size integer|string|nil
---@field additionalClasses string[]?
---@field additionalCss table<string, string|number|nil>?
---@field attributes table<string, string>?

---@param props IconProps
---@return Html?
function Icon.makeIconHtml(props)
	local icon = IconData[(props.iconName or ''):lower()]
	if not icon then
		return
	end

	local size = props.size
	if Logic.isNumeric(size) then
		size = size .. 'px'
	end
	return mw.html.create('i')
		:addClass(icon)
		:addClass(props.color)
		:addClass(Logic.isNotEmpty(props.additionalClasses) and table.concat(props.additionalClasses, ' ') or nil)
		:attr('title', props.hover)
		:css('font-size', size)
		:css(props.additionalCss or {})
		:attr('aria-hidden', props.screenReaderHidden and 'true' or nil)
		:attr(props.attributes and props.attributes or {})
end

---@param props IconProps
---@return string?
function Icon.makeIcon(props)
	local iconHtml = Icon.makeIconHtml(props)
	return iconHtml and tostring(iconHtml) or nil
end

return Class.export(Icon)
