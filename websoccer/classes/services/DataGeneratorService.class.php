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
define('FILE_CITYNAMES', BASE_FOLDER . '/admin/config/names/%s/cities.txt');
define('FILE_PREFIXNAMES', BASE_FOLDER . '/admin/config/names/%s/clubprefix.txt');
define('FILE_SUFFIXNAMES', BASE_FOLDER . '/admin/config/names/%s/clubsuffix.txt');
define('FILE_FIRSTNAMES', BASE_FOLDER . '/admin/config/names/%s/firstnames.txt');
define('FILE_LASTNAMES', BASE_FOLDER . '/admin/config/names/%s/lastnames.txt');

/**
 * Service for generating random game data records (teams, players).
 */
class DataGeneratorService {
	
	/**
	 * Generates new football teams for a specified league.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB Connection-
	 * @param int $numberOfTeams number of teams to generate.
	 * @param int $leagueId ID of league to generate teams for.
	 * @param int $budget Initial budget of each team.
	 * @param boolean $generateStadium TRUE if stadium shall be generates as well.
	 * @param string $stadiumNamePattern name of stadium with '%s' as placeholder for city name.
	 * @param int $stadiumStands number of places
	 * @param int $stadiumSeats number of places
	 * @param int $stadiumStandsGrand number of places
	 * @param int $stadiumSeatsGrand number of places
	 * @param int $stadiumVip number of places
	 * @throws Exception if generation failes.
	 */
	public static function generateTeams(WebSoccer $websoccer, DbConnection $db, $numberOfTeams, $leagueId, $budget,
			$generateStadium, $stadiumNamePattern, $stadiumStands, $stadiumSeats, $stadiumStandsGrand, $stadiumSeatsGrand, $stadiumVip) {
		
		// get country
		$result = $db->querySelect('*', $websoccer->getConfig('db_prefix') . '_league', 'id = %d', $leagueId);
		$league = $result->fetch_array();
		$result->free();
		
		if (!$league) {
			throw new Exception('illegal league ID');
		}
		
		$country = $league['country'];
		
		$cities = self::_getLines(FILE_CITYNAMES, $country);
		$prefixes = self::_getLines(FILE_PREFIXNAMES, $country);
		$suffixes = array();
		try {
			$suffixes = self::_getLines(FILE_SUFFIXNAMES, $country);
		} catch(Exception $e) {
			// no suffix file exist or is empty, so we will take only prefixes.
		}
		
		// create teams
		for ($teamNo = 1; $teamNo <= $numberOfTeams; $teamNo++) {
			$cityName = self::_getItemFromArray($cities);
			self::_createTeam($websoccer, $db, $league, $country, $cityName, $prefixes, $suffixes, $budget,
					$generateStadium, $stadiumNamePattern, $stadiumStands, $stadiumSeats, $stadiumStandsGrand, $stadiumSeatsGrand, $stadiumVip);
		}
	}
	
	/**
	 * Generates new players for a specified team.
	 * 
	 * @param WebSoccer $websoccer Application context
	 * @param DbConnection $db DB connection
	 * @param int $teamId ID of team to generate players for. If 0, then players will be generated for transfer market.
	 * @param int $age age of players in years.
	 * @param int $ageDeviation maximum deviation of age in years.
	 * @param int $salary salary per match.
	 * @param int $contractDuration contract duration in number of matches.
	 * @param array $strengths assoc. array of strength values. Keys are: strength, technique, stamina, freshness, satisfaction
	 * @param array $positions assoc array of positions and number of players to generate for each position. Key=abbreviated positions as in DB.
	 * @param int $maxDeviation maximum deviation in strength.
	 * @param sring|NULL $nationality optional. Nationality of player.If not provided, it is taken from club.
	 * @throws Exception if generation failed.
	 */
	public static function generatePlayers(WebSoccer $websoccer, DbConnection $db, $teamId, $age, $ageDeviation, $salary, $contractDuration, $strengths, $positions, $maxDeviation, $nationality = NULL) {
		
		if (strlen($nationality)) {
			$country = $nationality;
		} else {
			// get country from team
			$fromTable = $websoccer->getConfig('db_prefix') . '_club AS T';
			$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_league AS L ON L.id = T.league_id';
			$result = $db->querySelect('L.country AS country', $fromTable, 'T.id = %d', $teamId);
			$league = $result->fetch_array();
			$result->free();
			
			if (!$league) {
				throw new Exception('illegal team ID');
			}
			
			$country = $league['country'];
		}

		
		$firstNames = self::_getLines(FILE_FIRSTNAMES, $country);
		$lastNames = self::_getLines(FILE_LASTNAMES, $country);
		
		// map main position to parent position
		$mainPositions['GK'] = 'Goalkeeper';
		$mainPositions['LB'] = 'Defender';
		$mainPositions['CB'] = 'Defender';
		$mainPositions['RB'] = 'Defender';
		$mainPositions['LM'] = 'Midfielder';
		$mainPositions['CM'] = 'Midfielder';
		$mainPositions['AM'] = 'Midfielder';
		$mainPositions['DM'] = 'Midfielder';
		$mainPositions['RM'] = 'Midfielder';
		$mainPositions['LW'] = 'Forward';
		$mainPositions['CF'] = 'Forward';
		$mainPositions['RW'] = 'Forward';
		
		// create players for all positions
		foreach($positions as $mainPosition => $numberOfPlayers) {
			
			for ($playerNo = 1; $playerNo <= $numberOfPlayers; $playerNo++) {
				
				$playerAge = $age + self::_getRandomDeviationValue($ageDeviation);
				$time = strtotime('-' . $playerAge . ' years', $websoccer->getNowAsTimestamp());
				$birthday = date('Y-m-d', $time);
				
				$firstName = self::_getItemFromArray($firstNames);
				$lastName = self::_getItemFromArray($lastNames);
				self::_createPlayer($websoccer, $db, $teamId, $firstName, $lastName,
						$mainPositions[$mainPosition], $mainPosition, $strengths, $country, $playerAge, $birthday, $salary, $contractDuration, $maxDeviation);
			}

		}
		
	}
	
	private static function _getLines($fileName, $country) {
		$filePath = sprintf($fileName, $country);
		
		if (!file_exists($filePath)) {
			self::_throwException('generator_err_filedoesnotexist', $filePath);
		}
		
		$items = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
		if (!count($items)) {
			self::_throwException('generator_err_emptyfile', $filePath);
		}
		
		return $items;
	}
	
	private static function _getItemFromArray($items) {
		$itemsCount = count($items);
		if ($itemsCount) {
			return $items[mt_rand(0, $itemsCount - 1)];
		}
		
		return FALSE;
	}
	
	private static function _throwException($messageKey, $parameter = null) {
		$websoccer = WebSoccer::getInstance();
		$i18n = I18n::getInstance($websoccer->getConfig('supported_languages'));
		throw new Exception($i18n->getMessage($messageKey, $parameter));
	}
	
	private static function _createTeam($websoccer, $db, $league, $country, $cityName, $prefixes, $suffixes, $budget,
			$generateStadium, $stadiumNamePattern, $stadiumStands, $stadiumSeats, $stadiumStandsGrand, $stadiumSeatsGrand, $stadiumVip) {
		$teamName = $cityName;
		$shortName = strtoupper(substr($cityName, 0, 3));
		
		// prefix or suffix?
		if (rand(0, 1) && count($suffixes)) {
			$teamName .= ' ' . self::_getItemFromArray($suffixes);
		} else {
			$teamName = self::_getItemFromArray($prefixes) . ' ' . $teamName;
		}
		
		// stadium
		$stadiumId = 0;
		if ($generateStadium) {
			$stadiumName = sprintf($stadiumNamePattern, $cityName);
			
			$stadiumcolumns['name'] = $stadiumName;
			$stadiumcolumns['city'] = $cityName;
			$stadiumcolumns['country'] = $country;
			$stadiumcolumns['p_standing'] = $stadiumStands;
			$stadiumcolumns['p_seat'] = $stadiumSeats;
			$stadiumcolumns['p_main_standing'] = $stadiumStandsGrand;
			$stadiumcolumns['p_main_seat'] = $stadiumSeatsGrand;
			$stadiumcolumns['p_vip'] = $stadiumVip;
			
			$fromTable = $websoccer->getConfig('db_prefix') . '_stadium';
			
			$db->queryInsert($stadiumcolumns, $fromTable);
			
			// get generated ID
			$stadiumId = $db->getLastInsertedId();
		}
		
		$teamcolumns['name'] = $teamName;
		$teamcolumns['short'] = $shortName;
		$teamcolumns['league_id'] = $league['id'];
		$teamcolumns['stadium_id'] = $stadiumId;
		$teamcolumns['finance_budget'] = $budget;
		$teamcolumns['price_stand'] = $league['price_standing'];
		$teamcolumns['price_seat'] = $league['price_seat'];
		$teamcolumns['price_main_stand'] = $league['price_standing'];
		$teamcolumns['price_main_seat'] = $league['price_seat'];
		$teamcolumns['price_vip'] = $league['price_vip'];
		$teamcolumns['status'] = '1';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_club';
		$db->queryInsert($teamcolumns, $fromTable);
		
		echo '<p>' . $teamName . ' (' . $shortName . ')</p>';
	}
	
	private static function _createPlayer($websoccer, $db, $teamId, $firstName, $lastName, $position, $mainPosition, $strengths, 
			$country, $age, $birthday, $salary, $contractDuration, $maxDeviation) {
		
		$columns['first_name'] = $firstName;
		$columns['last_name'] = $lastName;
		$columns['birthday'] = $birthday;
		$columns['age'] = $age;
		$columns['position'] = $position;
		$columns['position_main'] = $mainPosition;
		$columns['nation'] = $country;
		$columns['w_strength'] = max(1, min(100, $strengths['strength'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_technique'] = max(1, min(100, $strengths['technique'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_stamina'] = max(1, min(100, $strengths['stamina'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_fitness'] = max(1, min(100, $strengths['freshness'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_morale'] = max(1, min(100, $strengths['satisfaction'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['contract_salary'] = $salary;
		$columns['contract_matches'] = $contractDuration;
		$columns['status'] = '1';
		
		if ($teamId) {
			$columns['club_id'] = $teamId;
		} else {
			$columns['transfer_listed'] = '1';
			$columns['transfer_start'] = $websoccer->getNowAsTimestamp();
			$columns['transfer_end'] = $columns['transfer_start'] + $websoccer->getConfig('transfermarket_duration_days') * 24 * 3600;
		}
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player';
		$db->queryInsert($columns, $fromTable);
	}
	
	private static function _getRandomDeviationValue($maxDeviation) {
		if ($maxDeviation <= 0) {
			return 0;
		}
		
		return mt_rand(0 - $maxDeviation, $maxDeviation);
	}
	
}
?>