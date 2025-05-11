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
