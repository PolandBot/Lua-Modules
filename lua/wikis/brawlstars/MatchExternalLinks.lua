---
-- @Liquipedia
-- wiki=brawlstars
-- page=Module:MatchExternalLinks
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

-- {} represents where a dot should be placed between links in MatchSummary footer

return {
  {
		name = 'preview',
		icon = 'Preview Icon32.png',
		prefixLink = '',
		label = 'Preview',
	},
	{},
	{
		name = 'esl',
		icon = 'ESL 2019 icon lightmode.png',
		iconDark = 'ESL 2019 icon darkmode.png',
		prefixLink = 'https://play.eslgaming.com/match/',
		label = 'Matchpage and Stats on ESL Play',
		isMapStats = true
	},
	{
		name = 'faceit',
		icon = 'FACEIT-icon.png',
		prefixLink = 'https://www.faceit.com/en/match/room/',
		label = 'Match Room and Stats on FACEIT',
		isMapStats = true
	},
	{
		name = 'lpl',
		icon = 'letsplay.live 2024 icon lightmode.png',
		iconDark = 'letsplay.live 2024 icon darkmode.png',
		prefixLink = 'https://gg.letsplay.live/report-score/',
		label = 'Matchpage on letsplay.live',
	},
	{
		name = 'challengermode',
		icon = 'Challengermode icon.png',
		prefixLink = 'https://www.challengermode.com/games/',
		label = 'Matchpage on Challengermode',
		isMapStats = true
	},
	{
		name = 'matcherino',
		tournamentID = 'tournament',
		icon = 'Matcherino icon.png',
		prefixLink = 'https://matcherino.com/supercell/tournaments/',
		midfixLink = '/bracket/match-',
		label = 'Matchpage on Matcherino'
	}
}

