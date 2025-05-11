---
-- @Liquipedia
-- wiki=brawlstars
-- page=Module:MatchGroup/Input/Custom
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Array = require('Module:Array')
local BrawlerNames = mw.loadData('Module:BrawlerNames')
local FnUtil = require('Module:FnUtil')
local Logic = require('Module:Logic')
local Lua = require('Module:Lua')
local String = require('Module:StringUtils')
local Table = require('Module:Table')
local Variables = require('Module:Variables')

local MatchGroupInputUtil = Lua.import('Module:MatchGroup/Input/Util')

local FIRST_PICK_CONVERSION = {
	blue = 1,
	['1'] = 1,
	red = 2,
	['2'] = 2,
}

local DEFAULT_BESTOF_MATCH = 5
local DEFAULT_BESTOF_MAP = 3

-- containers for process helper functions
local MatchFunctions = {}
local MapFunctions = {
	BREAK_ON_EMPTY = true,
}

MatchFunctions.DEFAULT_MODE = 'team'
MatchFunctions.DATE_FALLBACKS = {
	'tournament_enddate',
}

local CustomMatchGroupInput = {}

---@param match table
---@param options table?
---@return table
function CustomMatchGroupInput.processMatch(match, options)
	return MatchGroupInputUtil.standardProcessMatch(match, MatchFunctions)
end

---@param match table
---@param opponents table[]
---@return table[]
function MatchFunctions.extractMaps(match, opponents)
	local games = MatchGroupInputUtil.standardProcessMaps(match, opponents, MapFunctions)
	Array.forEach(games, function(game, gameIndex)
		game.vod = game.vod or String.nilIfEmpty(match['vodgame' .. gameIndex])
	end)
	return games
end

--
-- match related functions
--

---@param maps table[]
---@return fun(opponentIndex: integer): integer?
function MatchFunctions.calculateMatchScore(maps)
	return function(opponentIndex)
		return MatchGroupInputUtil.computeMatchScoreFromMapWinners(maps, opponentIndex)
	end
end

---@param bestofInput string|integer?
---@return integer?
function MatchFunctions.getBestOf(bestofInput)
	local bestof = tonumber(Logic.emptyOr(bestofInput, Variables.varDefault('bestof')))
	Variables.varDefine('bestof', bestof)
	return bestof or DEFAULT_BESTOF_MATCH
end

---@param match table
---@param maps table[]
---@return table
function MatchFunctions.getLinks(match, maps)
	local platforms = mw.loadData('Module:MatchExternalLinks')
	table.insert(platforms, {name = 'vod2', isMapStats = true})

	return Table.map(platforms, function (key, platform)
		if Logic.isEmpty(platform) then
			return key, nil
		end

		local makeLink = function(platform, name, match)
			local linkPrefix = platform.prefixLink or ''
			local linkMidfix = platform.midfixLink or ''
			local linkSuffix = platform.suffixLink or ''
			local tournamentID = match[platform.tournamentID] or ''
			return linkPrefix .. tournamentID .. linkMidfix .. name .. linkSuffix
		end

		local linksOfPlatform = {}
		local name = platform.name

		if match[name] then
			table.insert(linksOfPlatform, makeLink(platform, match[name], match))
		end

		if platform.isMapStats then
			Array.forEach(maps, function(map, mapIndex)
				if not map[name] then
					return
				end
				table.insert(linksOfPlatform, makeLink(platform, map[name], match), mapIndex)
			end)
		elseif platform.max then
			for i = 2, platform.max, 1 do
				if match[name .. i] then
					table.insert(linksOfPlatform, makeLink(platform, match[name .. i], match))
				end
			end
		end

		if Logic.isEmpty(linksOfPlatform) then
			return name, nil
		end
		return name, linksOfPlatform
	end)
end

---@param match table
---@param games table[]
---@param opponents table[]
---@return table
function MatchFunctions.getExtraData(match, games, opponents)
	return {
		mvp = MatchGroupInputUtil.readMvp(match, opponents),
	}
end

--
-- map related functions
--

---@param map table
---@return integer
function MapFunctions.getMapBestOf(map)
	local bestof = tonumber(Logic.emptyOr(map.bestof, Variables.varDefault('map_bestof')))
	Variables.varDefine('map_bestof', bestof)
	return bestof or DEFAULT_BESTOF_MAP
end

---@param match table
---@param map table
---@param opponents table[]
---@return table
function MapFunctions.getExtraData(match, map, opponents)
	local extradata = {
		bestof = map.bestof,
		maptype = map.maptype,
		firstpick = FIRST_PICK_CONVERSION[string.lower(map.firstpick or '')]
	}

	local bans = {}
	local getCharacterName = FnUtil.curry(MatchGroupInputUtil.getCharacterName, BrawlerNames)
	for opponentIndex = 1, #opponents do
		bans['team' .. opponentIndex] = {}
		for _, ban in Table.iter.pairsByPrefix(map, 't' .. opponentIndex .. 'b') do
			ban = getCharacterName(ban)
			table.insert(bans['team' .. opponentIndex], ban)
		end
	end

	extradata.bans = bans

	return extradata
end

---@param map table
---@param opponent table
---@param opponentIndex integer
---@return table[]
function MapFunctions.getPlayersOfMapOpponent(map, opponent, opponentIndex)
	local getCharacterName = FnUtil.curry(MatchGroupInputUtil.getCharacterName, BrawlerNames)
	local players = Array.mapIndexes(function(playerIndex)
		return map['t' .. opponentIndex .. 'p' .. playerIndex] or map['t' .. opponentIndex .. 'c' .. playerIndex]
	end)
	return MatchGroupInputUtil.parseMapPlayers(
		opponent.match2players,
		players,
		function(playerIndex)
			local player = map['t' .. opponentIndex .. 'p' .. playerIndex]
			return player and {name = player} or nil
		end,
		function(playerIndex, playerIdData)
			local brawler = map['t' .. opponentIndex .. 'c' .. playerIndex]
			return {
				player = playerIdData.name,
				brawler = getCharacterName(brawler),
			}
		end
	)
end

return CustomMatchGroupInput
