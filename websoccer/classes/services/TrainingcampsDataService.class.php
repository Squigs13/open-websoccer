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
 * Data service for training camps data
 */
class TrainingcampsDataService {
	
	public static function getCamps(WebSoccer $websoccer, DbConnection $db) {
		$fromTable = $websoccer->getConfig("db_prefix") . "_training_camp";
	
		// where
		$whereCondition = "1=1 ORDER BY name ASC";
	
		$camps = array();
		$result = $db->querySelect(self::_getColumns(), $fromTable, $whereCondition);
		while ($camp = $result->fetch_array()) {
			$camps[] = $camp;
		}
		$result->free();
		
		return $camps;
	}
	
	public static function getCampBookingsByTeam(WebSoccer $websoccer, DbConnection $db, $teamId) {
		$fromTable = $websoccer->getConfig("db_prefix") . "_training_camp_booking AS B";
		$fromTable .= " INNER JOIN " . $websoccer->getConfig("db_prefix") . "_training_camp AS C ON C.id = B.camp_id";
		
		$columns["B.id"] = "id";
		$columns["B.date_start"] = "date_start";
		$columns["B.date_end"] = "date_end";
		$columns["C.name"] = "name";
		$columns["C.country"] = "country";
		$columns["C.price_player_day"] = "costs";
		$columns["C.p_strength"] = "effect_strength";
		$columns["C.p_technique"] = "effect_strength_technique";
		$columns["C.p_stamina"] = "effect_strength_stamina";
		$columns["C.p_fitness"] = "effect_strength_freshness";
		$columns["C.p_morale"] = "effect_strength_satisfaction";
		
		// where
		$whereCondition = "B.club_id = %d ORDER BY B.date_start DESC";
	
		$camps = array();
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $teamId);
		while ($camp = $result->fetch_array()) {
			$camps[] = $camp;
		}
		$result->free();
	
		return $camps;
	}
	
	public static function getCampById(WebSoccer $websoccer, DbConnection $db, $campId) {
		$fromTable = $websoccer->getConfig("db_prefix") . "_training_camp";
	
		// where
		$whereCondition = "id = %d";
	
		$result = $db->querySelect(self::_getColumns(), $fromTable, $whereCondition, $campId);
		$camp = $result->fetch_array();
		$result->free();
	
		return $camp;
	}
	
	public static function executeCamp(WebSoccer $websoccer, DbConnection $db, $teamId, $bookingInfo) {
		
		$players = PlayersDataService::getPlayersOfTeamById($websoccer, $db, $teamId);
		if (count($players)) {
			
			$playerTable = $websoccer->getConfig("db_prefix") . "_player";
			$updateCondition = "id = %d";
			$duration = round(($bookingInfo["date_end"] - $bookingInfo["date_start"]) / (24 * 3600));
			
			// update players
			foreach ($players as $player) {
				if ($player["matches_injured"] > 0) {
					continue;
				}
				
				$columns = array();
				
				$columns["w_strength"] = min(100, max(1, $bookingInfo["effect_strength"] *  $duration + $player["strength"]));
				$columns["w_technique"] = min(100, max(1, $bookingInfo["effect_strength_technique"] *  $duration + $player["strength_technic"]));
				$columns["w_stamina"] = min(100, max(1, $bookingInfo["effect_strength_stamina"] *  $duration + $player["strength_stamina"]));
				$columns["w_fitness"] = min(100, max(1, $bookingInfo["effect_strength_freshness"] *  $duration + $player["strength_freshness"]));
				$columns["w_morale"] = min(100, max(1, $bookingInfo["effect_strength_satisfaction"] *  $duration + $player["strength_satisfaction"]));
				
				$db->queryUpdate($columns, $playerTable, $updateCondition, $player["id"]);
			}
			
		}
		
		// delete booking
		$db->queryDelete($websoccer->getConfig("db_prefix") . "_training_camp_booking", "id = %d", $bookingInfo["id"]);
	}
	
	private static function _getColumns() {
		$columns["id"] = "id";
		$columns["name"] = "name";
		$columns["country"] = "country";
		$columns["price_player_day"] = "costs";
		$columns["p_strength"] = "effect_strength";
		$columns["p_technique"] = "effect_strength_technique";
		$columns["p_stamina"] = "effect_strength_stamina";
		$columns["p_fitness"] = "effect_strength_freshness";
		$columns["p_morale"] = "effect_strength_satisfaction";
		
		return $columns;
	}
	
}
?>