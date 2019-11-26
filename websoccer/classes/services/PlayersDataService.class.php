<?php
/******************************************************

  This file is part of OpenWebSoccer-Sim.

  OpenWebSoccer-Sim is free software: you can redistribute it 
  and/or modify it under the terms of the 
  GNU Lesser General Public License 
  as published by the Free Software Foundation, either version 3 of
  the License, or any later version.

  OpenWebSoccer-Sim is distributed in the hope that it will be
  useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public 
  License along with OpenWebSoccer-Sim.  
  If not, see <http://www.gnu.org/licenses/>.

******************************************************/

/**
 * Data service for players.
 */
class PlayersDataService {

	/**
	 * Provides players of a team, grouped by their positions.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection
	 * @param int $clubId ID of team
	 * @param string $positionSort ASC|DESC - sort order of position.
	 * @param boolean $considerBlocksForCups if TRUE, then consider only blocked matches for cups, not for league matches.
	 * @return array array with key=converted position ID, value=array of players.
	 */
	public static function getPlayersOfTeamByPosition(WebSoccer $websoccer, DbConnection $db, $clubId, $positionSort = 'ASC', $considerBlocksForCups = FALSE, $considerBlocks = TRUE) {
		$columns = array(
				'id' => 'id', 
				'first_name' => 'firstname', 
				'last_name' => 'lastname', 
				'nickname' => 'pseudonym', 
				'injured' => 'matches_injured', 
				'position' => 'position', 
				'position_main' => 'position_main', 
				'position_second' => 'position_second', 
				'w_strength' => 'strength', 
				'w_technique' => 'strength_technique', 
				'w_stamina' => 'strength_stamina', 
				'w_fitness' => 'strength_freshness', 
				'w_morale' => 'strength_satisfaction', 
				'transfer_listed' => 'transfermarket', 
				'nation' => 'player_nationality', 
				'picture' => 'picture',
				'sa_goals' => 'st_goals',
				'sa_matches' => 'st_matches',
				'sa_yellow_card' => 'st_cards_yellow',
				'sa_yellow_card_2nd' => 'st_cards_yellow_red',
				'sa_red_card' => 'st_cards_red',
				'value' => 'marketvalue'
				);
		
		if ($websoccer->getConfig('players_aging') == 'birthday') {
			$ageColumn = 'TIMESTAMPDIFF(YEAR,birthday,CURDATE())';
		} else {
			$ageColumn = 'age';
		}
		$columns[$ageColumn] = 'age';
		
		if ($considerBlocksForCups) {
			$columns['suspended_cups'] = 'matches_blocked';
		} else if ($considerBlocks) {
			$columns['suspended'] = 'matches_blocked';
		}
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player';
		$whereCondition = 'status = 1 AND club_id = %d ORDER BY position '. $positionSort . ', position_main ASC, last_name ASC, first_name ASC';
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $clubId, 50);
		
		$players = array();
		while ($player = $result->fetch_array()) {
			$player['position'] = self::_convertPosition($player['position']);
			$player['player_nationality_filename'] = self::getFlagFilename($player['player_nationality']);
			$player['marketvalue'] = self::getMarketValue($websoccer, $player, '');
			$players[$player['position']][] = $player;
		}
		$result->free();
		
		return $players;
	}
	
	/**
	 * Provides players of a team.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB Connection.
	 * @param int $clubId ID of team
	 * @param boolean $nationalteam TRUE if team is a national team.
	 * @param boolean $considerBlocksForCups if TRUE, then consider only blocked matches for cups, not for league matches. Irrelevant for national teams.
	 * @return array List of players with key=Player ID, value=player info array.
	 */
	public static function getPlayersOfTeamById(WebSoccer $websoccer, DbConnection $db, $clubId, $nationalteam = FALSE, $considerBlocksForCups = FALSE, $considerBlocks = TRUE) {
		
		$columns = array(
				'id' => 'id',
				'first_name' => 'firstname',
				'last_name' => 'lastname',
				'nickname' => 'pseudonym',
				'injured' => 'matches_injured',
				'position' => 'position',
				'position_main' => 'position_main',
				'position_second' => 'position_second',
				'w_handling' => 'handling',
				'w_tackling' => 'tackling',
				'w_passing' => 'passing',
				'w_finishing' => 'finishing',
				'w_pace' => 'pace',
				'w_strength' => 'strength',
				'w_technique' => 'strength_technic',
				'w_stamina' => 'strength_stamina',
				'w_fitness' => 'strength_freshness',
				'w_morale' => 'strength_satisfaction',
				'transfer_listed' => 'transfermarket',
				'nation' => 'player_nationality',
				'picture' => 'picture',
				'sa_goals' => 'st_goals',
				'sa_matches' => 'st_matches',
				'sa_yellow_card' => 'st_cards_yellow',
				'sa_yellow_card_2nd' => 'st_cards_yellow_red',
				'sa_red_card' => 'st_cards_red',
				'value' => 'marketvalue',
				'contract_matches' => 'contract_matches',
				'contract_salary' => 'contract_salary',
				'unsellable' => 'unsellable',
				'loan_matches' => 'loan_matches',
				'loan_fee' => 'loan_fee',
				'loan_owner_id' => 'loan_owner_id',
				'transfer_listed' => 'transfermarket'
		);
		
		if ($websoccer->getConfig('players_aging') == 'birthday') {
			$ageColumn = 'TIMESTAMPDIFF(YEAR,birthday,CURDATE())';
		} else {
			$ageColumn = 'age';
		}
		$columns[$ageColumn] = 'age';
		
		if (!$nationalteam) {
			if ($considerBlocksForCups) {
				$columns['suspended_cups'] = 'matches_blocked';
			} elseif ($considerBlocks) {
				$columns['suspended'] = 'matches_blocked';
			} else {
				$columns['\'0\''] = 'matches_blocked';
			}
			
			$fromTable = $websoccer->getConfig('db_prefix') . '_player';
			$whereCondition = 'status = 1 AND club_id = %d';
		} else {
			$columns['suspended_nationalteam'] = 'matches_blocked';
			$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
			$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_nationalplayer AS NP ON NP.player_id = P.id';
			$whereCondition = 'status = 1 AND NP.team_id = %d';
		}
		
		$whereCondition .= ' ORDER BY position ASC, position_main ASC, last_name ASC, first_name ASC';
		
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $clubId, 50);
	
		$players = array();
		while ($player = $result->fetch_array()) {
			$player['position'] = self::_convertPosition($player['position']);
			$players[$player['id']] = $player;
		}
		$result->free();
	
		return $players;
	}
	
	/**
	 * Provides players who are currently available on the transfer market.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection.
	 * @param string $positionFilter position ID as in DB table.
	 * @param int $startIndex fetch start index.
	 * @param int $entries_per_page number of items to fetch.
	 * @return array list of found players or empty array.
	 */
	public static function getPlayersOnTransferList(WebSoccer $websoccer, DbConnection $db, $startIndex, $entries_per_page, $positionFilter = null) {
		
		$columns['P.id'] = 'id';
		$columns['P.first_name'] = 'firstname';
		$columns['P.last_name'] = 'lastname';
		$columns['P.nickname'] = 'pseudonym';
		$columns['P.position'] = 'position';
		$columns['P.position_main'] = 'position_main';
		
		$columns['P.contract_salary'] = 'contract_salary';
		$columns['P.contract_goal_bonus'] = 'contract_goalbonus';
		
		$columns['P.w_handling'] = 'handling';
		$columns['P.w_tackling'] = 'tackling';
		$columns['P.w_passing'] = 'passing';
		$columns['P.w_finishing'] = 'finishing';
		$columns['P.w_pace'] = 'pace';
		$columns['P.w_strength'] = 'strength';
		$columns['P.w_technique'] = 'strength_technique';
		$columns['P.w_stamina'] = 'strength_stamina';
		$columns['P.w_fitness'] = 'strength_freshness';
		$columns['P.w_morale'] = 'strength_satisfaction';
		
		$columns['P.transfer_listed'] = 'transfermarket';
		$columns['P.value'] = 'marketvalue';
		$columns['P.transfer_start'] = 'transfer_start';
		$columns['P.transfer_end'] = 'transfer_deadline';
		$columns['P.transfer_min_bid'] = 'min_bid';
		
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = P.club_id';
		
		$whereCondition = 'P.status = 1 AND P.transfer_listed = 1 AND P.transfer_end > %d';
		$parameters[] = $websoccer->getNowAsTimestamp();
		
		if ($positionFilter != null) {
			$whereCondition .= ' AND P.position = \'%s\'';
			$parameters[] = $positionFilter;
		}
		
		$whereCondition .= ' ORDER BY P.transfer_end ASC, P.last_name ASC, P.first_name ASC';
		
		$limit = $startIndex .','. $entries_per_page;
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, $limit);
	
		$players = array();
		while ($player = $result->fetch_array()) {
			$player['position'] = self::_convertPosition($player['position']);
			$player['highestbid'] = TransfermarketDataService::getHighestBidForPlayer($websoccer, $db, $player['id'], $player['transfer_start'], $player['transfer_deadline']);
			$players[] = $player;
		}
		$result->free();
	
		return $players;
	}
	
	/**
	 * Counts number of players who are currently available on the transfer market.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection.
	 * @param string $positionFilter position ID as in DB table.
	 * @return int number of found players. 0 if no players found.
	 */
	public static function countPlayersOnTransferList(WebSoccer $websoccer, DbConnection $db, $positionFilter = null) {
	
		$columns = 'COUNT(*) AS hits';
	
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
	
		$whereCondition = 'P.status = 1 AND P.transfer_listed = 1 AND P.transfer_end > %d';
		$parameters[] = $websoccer->getNowAsTimestamp();
		
		if ($positionFilter != null) {
			$whereCondition .= ' AND P.position = \'%s\'';
			$parameters[] = $positionFilter;
		}
		
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters);
		$players = $result->fetch_array();
		$result->free();
		
		if (isset($players['hits'])) {
			return $players['hits'];
		}
	
		return 0;
	}
	
	/**
	 * Provides info about player, its team and lender.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB Connection.
	 * @param int $playerId ID of player.
	 * @return array assoc. array with data about player.
	 */
	public static function getPlayerById(WebSoccer $websoccer, DbConnection $db, $playerId) {
		
		$columns['P.id'] = 'player_id';
		$columns['P.first_name'] = 'player_firstname';
		$columns['P.last_name'] = 'player_lastname';
		$columns['P.nickname'] = 'player_pseudonym';
		$columns['P.position'] = 'player_position';
		$columns['P.position_main'] = 'player_position_main';
		$columns['P.position_second'] = 'player_position_second';
		$columns['P.birthday'] = 'player_birthday';
		$columns['P.nation'] = 'player_nationality';
		$columns['P.picture'] = 'player_picture';
		
		if ($websoccer->getConfig('players_aging') == 'birthday') {
			$ageColumn = 'TIMESTAMPDIFF(YEAR,P.birthday,CURDATE())';
		} else {
			$ageColumn = 'P.age';
		}
		$columns[$ageColumn] = 'player_age';
		
		$columns['P.injured'] = 'player_matches_injured';
		$columns['P.suspended'] = 'player_matches_blocked';
		$columns['P.suspended_cups'] = 'player_matches_blocked_cups';
		$columns['P.suspended_nationalteam'] = 'player_matches_blocked_nationalteam';
		
		$columns['P.contract_salary'] = 'player_contract_salary';
		$columns['P.contract_matches'] = 'player_contract_matches';
		$columns['P.contract_goal_bonus'] = 'player_contract_goalbonus';
		
		$columns['P.w_handling'] = 'player_handling';
		$columns['P.w_tackling'] = 'player_tackling';
		$columns['P.w_passing'] = 'player_passing';
		$columns['P.w_finishing'] = 'player_finishing';
		$columns['P.w_pace'] = 'player_pace';
		$columns['P.w_strength'] = 'player_strength';
		$columns['P.w_technique'] = 'player_strength_technique';
		$columns['P.w_stamina'] = 'player_strength_stamina';
		$columns['P.w_fitness'] = 'player_strength_freshness';
		$columns['P.w_morale'] = 'player_strength_satisfaction';
		
		$columns['P.sa_goals'] = 'player_season_goals';
		$columns['P.sa_assists'] = 'player_season_assists';
		$columns['P.sa_matches'] = 'player_season_matches';
		$columns['P.sa_yellow_card'] = 'player_season_yellow';
		$columns['P.sa_yellow_card_2nd'] = 'player_season_yellow_red';
		$columns['P.sa_red_card'] = 'player_season_red';
		
		$columns['P.st_goals'] = 'player_total_goals';
		$columns['P.st_assists'] = 'player_total_assists';
		$columns['P.st_matches'] = 'player_total_matches';
		$columns['P.st_yellow_card'] = 'player_total_yellow';
		$columns['P.st_yellow_card_2nd'] = 'player_total_yellow_red';
		$columns['P.st_red_card'] = 'player_total_red';
		
		
		$columns['P.transfer_listed'] = 'player_transfermarket';
		$columns['P.value'] = 'player_marketvalue';
		
		$columns['P.transfer_start'] = 'transfer_start';
		$columns['P.transfer_end'] = 'transfer_end';
		$columns['P.transfer_min_bid'] = 'transfer_min_bid';
		
		$columns['P.history'] = 'player_history';
		
		$columns['P.unsellable'] = 'player_unsellable';
		
		$columns['P.loan_owner_id'] = 'loan_owner_id';
		$columns['L.name'] = 'loan_owner_name';
		$columns['P.loan_fee'] = 'loan_fee';
		$columns['P.loan_matches'] = 'loan_matches';
		
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';
		$columns['C.finance_budget'] = 'team_budget';
		$columns['C.user_id'] = 'team_user_id';
		
		$columns['(SELECT CONCAT(AVG(S.rating), \';\', SUM(S.assists)) FROM ' . $websoccer->getConfig('db_prefix') . '_match_simulation AS S WHERE S.player_id = P.id AND S.minutes_played > 0 AND S.rating > 0)'] = 'matches_info';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = P.club_id';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS L ON L.id = P.loan_owner_id';
		
		$whereCondition = 'P.status = 1 AND P.id = %d';
		$players = $db->queryCachedSelect($columns, $fromTable, $whereCondition, $playerId, 1);
		if (count($players)) {
			$player = $players[0];
			
			$player['player_position'] = self::_convertPosition($player['player_position']);
			$player['player_marketvalue'] = self::getMarketValue($websoccer, $player);
			$player['player_nationality_filename'] = self::getFlagFilename($player['player_nationality']);
			
			$matchesInfo = explode(';', $player['matches_info']);
			$player['player_avg_grade'] = round($matchesInfo[0], 2);
			if (isset($matchesInfo[1])) {
				$player['player_assists'] = $matchesInfo[1];
			} else {
				$player['player_assists'] = 0;
			}
			
		} else {
			$player = array();
		}

	
		return $player;
	}
	
	/**
	 * Provides players ranked by number of shot goals in the current season.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection.
	 * @param int $limit Maximum number of players to fetch.
	 * @param int|NULL $leagueId ID of league. If not provided, total top strikers will be returned.
	 * @return array list of found players or empty array if no players exist.
	 */
	public static function getTopStrikers(WebSoccer $websoccer, DbConnection $db, $limit = 20, $leagueId = null) {
		$parameters = array();
		
		$columns['P.id'] = 'id';
		$columns['P.first_name'] = 'firstname';
		$columns['P.last_name'] = 'lastname';
		$columns['P.nickname'] = 'pseudonym';
		
		$columns['P.sa_goals'] = 'goals';
		$columns['P.sa_matches'] = 'matches';
		
		$columns['P.transfer_listed'] = 'transfermarket';
		
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = P.club_id';
		
		$whereCondition = 'P.status = 1 AND P.sa_goals > 0';
		if ($leagueId != null) {
			$whereCondition .= ' AND league_id = %d';
			$parameters[] = (int) $leagueId;
		}
		$whereCondition .= ' ORDER BY P.sa_goals DESC, P.sa_matches ASC';
		
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, $limit);
		
		$players = array();
		while ($player = $result->fetch_array()) {
			$players[] = $player;
		}
		$result->free();
		
		return $players;
	}
	
	/**
	 * Provides players ranked by sum of number of shot goals and assists in the current season.
	 *
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection.
	 * @param int $limit Maximum number of players to fetch.
	 * @param int|NULL $leagueId ID of league. If not provided, total top strikers will be returned.
	 * @return array list of found players or empty array if no players exist.
	 */
	public static function getTopScorers(WebSoccer $websoccer, DbConnection $db, $limit = 20, $leagueId = null) {
		$parameters = array();
	
		$columns['P.id'] = 'id';
		$columns['P.first_name'] = 'firstname';
		$columns['P.last_name'] = 'lastname';
		$columns['P.nickname'] = 'pseudonym';
	
		$columns['P.sa_goals'] = 'goals';
		$columns['P.sa_assists'] = 'assists';
		$columns['P.sa_matches'] = 'matches';
		
		$columns['(P.sa_goals + P.sa_assists)'] = 'score';
	
		$columns['P.transfer_listed'] = 'transfermarket';
	
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';
	
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = P.club_id';
	
		$whereCondition = 'P.status = \'1\' AND (P.sa_goals + P.sa_assists) > 0';
		if ($leagueId != null) {
			$whereCondition .= ' AND league_id = %d';
			$parameters[] = (int) $leagueId;
		}
		$whereCondition .= ' ORDER BY score DESC, P.sa_assists DESC, P.sa_goals DESC, P.sa_matches ASC, P.id ASC';
	
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, $limit);
	
		$players = array();
		while ($player = $result->fetch_array()) {
			$players[] = $player;
		}
		$result->free();
	
		return $players;
	}
	
	/**
	 * Dynamic query to find players by specified criteria.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection.
	 * @param string $firstName Start of first name (case sensitive).
	 * @param string $lastName Start of last name or pseudonym (case sensitive).
	 * @param string $clubName name of team (exact match)
	 * @param string $position position ID as in DB.
	 * @param int $strengthMax Maximum strength value
	 * @param boolean $lendableOnly TRUE if only lendable players shall be returned.
	 * @param int $startIndex fetch start index.
	 * @param int $entries_per_page number of items to fetch.
	 * @return array list of found players or empty array.
	 */
	public static function findPlayers(WebSoccer $websoccer, DbConnection $db, 
			$firstName, $lastName, $clubName, $position, $strengthMax, $lendableOnly, $startIndex, $entries_per_page) {
		
		$columns['P.id'] = 'id';
		$columns['P.first_name'] = 'firstname';
		$columns['P.last_name'] = 'lastname';
		$columns['P.nickname'] = 'pseudonym';
		
		$columns['P.position'] = 'position';
		$columns['P.position_main'] = 'position_main';
		$columns['P.position_second'] = 'position_second';
		
		$columns['P.transfer_listed'] = 'transfermarket';
		$columns['P.unsellable'] = 'unsellable';
		
		$columns['P.w_handling'] = 'handling';
		$columns['P.w_tackling'] = 'tackling';
		$columns['P.w_passing'] = 'passing';
		$columns['P.w_finishing'] = 'finishing';
		$columns['P.w_pace'] = 'pace';
		$columns['P.w_strength'] = 'strength';
		$columns['P.w_technique'] = 'strength_technique';
		$columns['P.w_stamina'] = 'strength_stamina';
		$columns['P.w_fitness'] = 'strength_freshness';
		$columns['P.w_morale'] = 'strength_satisfaction';
		
		$columns['P.contract_salary'] = 'contract_salary';
		$columns['P.contract_matches'] = 'contract_matches';
		
		$columns['P.loan_owner_id'] = 'loan_owner_id';
		$columns['P.loan_fee'] = 'loan_fee';
		$columns['P.loan_matches'] = 'loan_matches';
		
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';	
		
		$limit = $startIndex .','. $entries_per_page;
		$result = self::executeFindQuery($websoccer, $db, $columns, $limit, $firstName, $lastName, $clubName, $position, $strengthMax, $lendableOnly);
		
		$players = array();
		while ($player = $result->fetch_array()) {
			$player['position'] = self::_convertPosition($player['position']);
			$players[] = $player;
			
		}
		$result->free();
		
		return $players;
		
	}
	
	/**
	 * Counts found players of dynamic query.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB connection.
	 * @param string $firstName Start of first name (case sensitive).
	 * @param string $lastName Start of last name or pseudonym (case sensitive).
	 * @param string $clubName name of team (exact match)
	 * @param string $position position ID as in DB.
	 * @param int $strengthMax Maximum strength value
	 * @param boolean $lendableOnly TRUE if only lendable players shall be returned.
	 * @return int number of found player. 0 if no players found.
	 */
	public static function findPlayersCount(WebSoccer $websoccer, DbConnection $db,
			$firstName, $lastName, $clubName, $position, $strengthMax, $lendableOnly) {
		$columns = 'COUNT(*) AS hits';
		
		$result = self::executeFindQuery($websoccer, $db, $columns, 1, 
				$firstName, $lastName, $clubName, $position, $strengthMax, $lendableOnly);
		$players = $result->fetch_array();
		$result->free();
		
		if (isset($players['hits'])) {
			return $players['hits'];
		}
		
		return 0;
	}
	
	private static function executeFindQuery(WebSoccer $websoccer, DbConnection $db, $columns, $limit,
			$firstName, $lastName, $clubName, $position, $strengthMax, $lendableOnly) {
		$whereCondition = 'P.status = 1';
		
		$parameters = array();
		
		if ($firstName != null) {
			$firstName = ucfirst($firstName);
			$whereCondition .= ' AND P.first_name LIKE \'%s%%\'';
			$parameters[] = $firstName;
		}
		
		if ($lastName != null) {
			$lastName = ucfirst($lastName);
			$whereCondition .= ' AND (P.last_name LIKE \'%s%%\' OR P.nickname LIKE \'%s%%\')';
			$parameters[] = $lastName;
			$parameters[] = $lastName;
		}
		
		if ($clubName != null) {
			$whereCondition .= ' AND C.name = \'%s\'';
			$parameters[] = $clubName;
		}
		
		if ($position != null) {
			$whereCondition .= ' AND P.position = \'%s\'';
			$parameters[] = $position;
		}
		
		if ($strengthMax != null && $websoccer->getConfig('hide_strength_attributes') !== '1') {
			$strengthMinValue = $strengthMax - 20;
			$strengthMaxValue = $strengthMax;
			
			$whereCondition .= ' AND P.w_strength > %d AND P.w_strength <= %d';
			$parameters[] = $strengthMinValue;
			$parameters[] = $strengthMaxValue;
		}
		
		if ($lendableOnly) {
			$whereCondition .= ' AND P.loan_fee > 0 AND (P.loan_owner_id IS NULL OR P.loan_owner_id = 0)';
		}
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = P.club_id';
		
		return $db->querySelect($columns, $fromTable, $whereCondition, $parameters, $limit);
	}
	
	/**
	 * Converts DB position ID into ID for view.
	 * 
	 * @param string $dbPosition Position ID as in database.
	 * @return string goaly|defense|midfield|striker
	 */
	public static function _convertPosition($dbPosition) {
		switch ($dbPosition) {
			case 'Goalkeeper':
				return 'goaly';
			case 'Defender':
				return 'defense';
			case 'Midfielder':
				return 'midfield';
			default:
				return 'striker';
		}
	
	}
	
	/**
	 * Provides market value of player. Depending on settings, either value from DB table or computed value.
	 * Computed value is configured value per strength point * weighted total strength of player.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param array $player Player info array.
	 * @param string $columnPrefix column prefix used in player array.
	 * @return int market value of player.
	 */
	public static function getMarketValue(WebSoccer $websoccer, $player, $columnPrefix = 'player_') {
		if (!$websoccer->getConfig('transfermarket_computed_marketvalue')) {
			return $player[$columnPrefix . 'marketvalue'];
		}

		switch ($player[$columnPrefix . 'position']) {
			case 'goaly':
				$totalStrength = $websoccer->getConfig('sim_weight_strength') * $player[$columnPrefix . 'handling'];
				break;
			case 'defense':
				$totalStrength = $websoccer->getConfig('sim_weight_strength') * $player[$columnPrefix . 'tackling'];
				break;
			case 'midfield':
				$totalStrength = $websoccer->getConfig('sim_weight_strength') * $player[$columnPrefix . 'passing'];
				break;
			case 'striker':
				$totalStrength = $websoccer->getConfig('sim_weight_strength') * $player[$columnPrefix . 'finishing'];
				break;
			
			default:
				# code...
				break;
		}
		
		// compute market value
		// $totalStrength = $websoccer->getConfig('sim_weight_strength') * $player[$columnPrefix . 'strength'];
		$totalStrength += $websoccer->getConfig('sim_weight_strengthTech') * $player[$columnPrefix . 'strength_technique'];
		$totalStrength += $websoccer->getConfig('sim_weight_strengthStamina') * $player[$columnPrefix . 'strength_stamina'];
		// $totalStrength += $websoccer->getConfig('sim_weight_strengthFreshness') * $player[$columnPrefix . 'strength_freshness'];
		// $totalStrength += $websoccer->getConfig('sim_weight_strengthSatisfaction') * $player[$columnPrefix . 'strength_satisfaction'];
		
		$totalStrength /= $websoccer->getConfig('sim_weight_strength') + $websoccer->getConfig('sim_weight_strengthTech')
			+ $websoccer->getConfig('sim_weight_strengthStamina'); //+ $websoccer->getConfig('sim_weight_strengthFreshness')
			// + $websoccer->getConfig('sim_weight_strengthSatisfaction');
		
		return $totalStrength * $websoccer->getConfig('transfermarket_value_per_strength');
	}
	
	/**
	 * Provides the correct flag file name for specified nationality.
	 * Removes umlauts.
	 * 
	 * @param string $nationality
	 * @return string fag file name.
	 */
	public static function getFlagFilename($nationality) {
		if (!strlen($nationality)) {
			return $nationality;
		}
		
		// remove umlauts
		$filename = str_replace('??', 'Ae', $nationality);
		$filename = str_replace('??', 'Oe', $filename);
		$filename = str_replace('??', 'Ue', $filename);
		
		$filename = str_replace('??', 'ae', $filename);
		$filename = str_replace('??', 'oe', $filename);
		$filename = str_replace('??', 'ue', $filename);
		return $filename;
	}
	
}
?>