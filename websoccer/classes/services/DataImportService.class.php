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
define('FILE_CLUBNAMES', BASE_FOLDER . '/admin/config/names/import/clubs/%s');
define('FILE_PLAYERNAMES', BASE_FOLDER . '/admin/config/names/import/players/%s');

/**
 * Service for importing game data records from file (teams, players).
 */
class DataImportService {
	
	/**
	 * Imports new football teams for a specified league.
	 * 
	 * @param WebSoccer $websoccer Application context.
	 * @param DbConnection $db DB Connection-
	 * @param int $leagueId ID of league to generate teams for.
	 * @param string $importFile Name of the import file to retrieve data from.
	 * @throws Exception if generation fails.
	 */
	public static function generateTeams(WebSoccer $websoccer, DbConnection $db, $leagueId, $importFile) {
		
		// get country
		$result = $db->querySelect('*', $websoccer->getConfig('db_prefix') . '_liga', 'id = %d', $leagueId);
		$league = $result->fetch_array();
		$result->free();
		
		if (!$league) {
			throw new Exception('illegal league ID');
		}
		
		$country = $league['land'];
		
		$clubs = self::_getLines(FILE_CLUBNAMES, $importFile);
		
		// import teams
		foreach($clubs as $club) {
			$clubdata = explode(",", $club);
			self::_importTeam($websoccer, $db, $league, $country, $clubdata[0], $clubdata[1], $clubdata[2], $clubdata[3], $clubdata[4]);
		}
		
	}
	
	/**
	 * Generates new players for a specified team.
	 * 
	 * @param WebSoccer $websoccer Application context
	 * @param DbConnection $db DB connection
	 * @param int $leagueId ID of league to generate players for.
	 * @param string $importFile Name of the import file to retrieve data from.
	 * @throws Exception if generation fails.
	 */
	public static function generatePlayers(WebSoccer $websoccer, DbConnection $db, $leagueId, $importFile) {
		
		$players = self::_getLines(FILE_PLAYERNAMES, $importFile);
		
		foreach($players as $player) {
			$playerdata = explode(",", $player);
			$attributes['skill'] = $playerdata[7];
			$attributes['technique'] = $playerdata[8];
			$attributes['stamina'] = $playerdata[9];
			$attributes['fitness'] = $playerdata[10];
			$attributes['morale'] = $playerdata[11];
			self::_importPlayer($websoccer, $db, $playerdata[2], $playerdata[0], $playerdata[1], $playerdata[3], $playerdata[4],
			$playerdata[5], $playerdata[6], $attributes);
		}
		
		/* map main position to parent position
		$mainPositions['T'] = 'Torwart';
		$mainPositions['LV'] = 'Abwehr';
		$mainPositions['IV'] = 'Abwehr';
		$mainPositions['RV'] = 'Abwehr';
		$mainPositions['LM'] = 'Mittelfeld';
		$mainPositions['ZM'] = 'Mittelfeld';
		$mainPositions['OM'] = 'Mittelfeld';
		$mainPositions['DM'] = 'Mittelfeld';
		$mainPositions['RM'] = 'Mittelfeld';
		$mainPositions['LS'] = 'Sturm';
		$mainPositions['MS'] = 'Sturm';
		$mainPositions['RS'] = 'Sturm';
		
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
		*/
		
	}
	
	private static function _getLines($fileName, $importFile) {
		$filePath = sprintf($fileName, $importFile);
		
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
	
	private static function _importTeam($websoccer, $db, $league, $country, $teamName, $shortName, $stadiumName, $stadiumCapacity, $stadiumCity) {
		
		$generateStadium = 1;
		$sides = floor($stadiumCapacity * 0.3);
		$main = $stadiumCapacity - $sides;
		
		// stadium
		$stadiumId = 0;
		if ($generateStadium) {
			
			$stadiumcolumns['name'] = $stadiumName;
			$stadiumcolumns['stadt'] = $stadiumCity;
			$stadiumcolumns['land'] = $country;
			$stadiumcolumns['p_steh'] = 0;
			$stadiumcolumns['p_sitz'] = $sides;
			$stadiumcolumns['p_haupt_steh'] = 0;
			$stadiumcolumns['p_haupt_sitz'] = $main;
			$stadiumcolumns['p_vip'] = 0;
			
			$fromTable = $websoccer->getConfig('db_prefix') . '_stadion';
			
			$db->queryInsert($stadiumcolumns, $fromTable);
			
			// get generated ID
			$stadiumId = $db->getLastInsertedId();
		}
		
		$teamcolumns['name'] = $teamName;
		$teamcolumns['kurz'] = $shortName;
		$teamcolumns['liga_id'] = $league['id'];
		$teamcolumns['stadion_id'] = $stadiumId;
		$teamcolumns['finanz_budget'] = 5000000;
		$teamcolumns['preis_stehen'] = $league['preis_steh'];
		$teamcolumns['preis_sitz'] = $league['preis_sitz'];
		$teamcolumns['preis_haupt_stehen'] = $league['preis_steh'];
		$teamcolumns['preis_haupt_sitze'] = $league['preis_sitz'];
		$teamcolumns['preis_vip'] = $league['preis_vip'];
		$teamcolumns['status'] = '1';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_verein';
		$db->queryInsert($teamcolumns, $fromTable);
		
		echo '<p>' . $teamName . ' (' . $shortName . ')</p>';
	}
	
	private static function _importPlayer($websoccer, $db, $teamId, $firstName, $lastName, $position, $mainPosition, 
			$country, $age, $attributes) {
		
		$columns['vorname'] = $firstName;
		$columns['nachname'] = $lastName;
		//$columns['geburtstag'] = $birthday;
		$columns['age'] = $age;
		$columns['position'] = $position;
		$columns['position_main'] = $mainPosition;
		$columns['nation'] = $country;
		/*
		$columns['w_staerke'] = max(1, min(100, $strengths['strength'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_technik'] = max(1, min(100, $strengths['technique'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_kondition'] = max(1, min(100, $strengths['stamina'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_frische'] = max(1, min(100, $strengths['freshness'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_zufriedenheit'] = max(1, min(100, $strengths['satisfaction'] + self::_getRandomDeviationValue($maxDeviation)));
		*/
		$columns['w_staerke'] = max(1, min(100, $attributes['skill'] + self::_getRandomDeviationValue(3)));
		$columns['w_technik'] = max(1, min(100, $attributes['technique'] + self::_getRandomDeviationValue(3)));
		$columns['w_kondition'] = max(1, min(100, $attributes['stamina'] + self::_getRandomDeviationValue(3)));
		$columns['w_frische'] = max(1, min(100, $attributes['fitness'] + self::_getRandomDeviationValue(3)));
		$columns['w_zufriedenheit'] = max(1, min(100, $attributes['morale'] + self::_getRandomDeviationValue(3)));
		$columns['vertrag_gehalt'] = 10000;
		$columns['vertrag_spiele'] = 60;
		$columns['status'] = '1';
		
		if ($teamId) {
			$columns['verein_id'] = $teamId;
		} else {
			$columns['transfermarkt'] = '1';
			$columns['transfer_start'] = $websoccer->getNowAsTimestamp();
			$columns['transfer_ende'] = $columns['transfer_start'] + $websoccer->getConfig('transfermarket_duration_days') * 24 * 3600;
		}
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_spieler';
		$db->queryInsert($columns, $fromTable);
	}
	
	private static function _createPlayer($websoccer, $db, $teamId, $firstName, $lastName, $position, $mainPosition, $strengths, 
			$country, $age, $birthday, $salary, $contractDuration, $maxDeviation) {
		
		$columns['vorname'] = $firstName;
		$columns['nachname'] = $lastName;
		$columns['geburtstag'] = $birthday;
		$columns['age'] = $age;
		$columns['position'] = $position;
		$columns['position_main'] = $mainPosition;
		$columns['nation'] = $country;
		$columns['w_staerke'] = max(1, min(100, $strengths['strength'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_technik'] = max(1, min(100, $strengths['technique'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_kondition'] = max(1, min(100, $strengths['stamina'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_frische'] = max(1, min(100, $strengths['freshness'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['w_zufriedenheit'] = max(1, min(100, $strengths['satisfaction'] + self::_getRandomDeviationValue($maxDeviation)));
		$columns['vertrag_gehalt'] = $salary;
		$columns['vertrag_spiele'] = $contractDuration;
		$columns['status'] = '1';
		
		if ($teamId) {
			$columns['verein_id'] = $teamId;
		} else {
			$columns['transfermarkt'] = '1';
			$columns['transfer_start'] = $websoccer->getNowAsTimestamp();
			$columns['transfer_ende'] = $columns['transfer_start'] + $websoccer->getConfig('transfermarket_duration_days') * 24 * 3600;
		}
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_spieler';
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