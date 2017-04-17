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
 * Data service for sponsors.
 */
class SponsorsDataService {

	public static function getSponsorinfoByTeamId(WebSoccer $websoccer, DbConnection $db, $clubId) {
		
		$columns["T.sponsor_matches"] = "matchdays";
		$columns["S.id"] = "sponsor_id";
		$columns["S.name"] = "name";
		$columns["S.b_match"] = "amount_match";
		$columns["S.b_home_match"] = "amount_home_bonus";
		$columns["S.b_win"] = "amount_win";
		$columns["S.b_championship"] = "amount_championship";
		$columns["S.image"] = "picture";
		
		$fromTable = $websoccer->getConfig("db_prefix") . "_sponsor AS S";
		$fromTable .= " INNER JOIN " . $websoccer->getConfig("db_prefix") . "_club AS T ON T.sponsor_id = S.id";
		$whereCondition = "T.id = %d AND T.sponsor_matches > 0";
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $clubId, 1);
		$sponsor = $result->fetch_array();
		$result->free();
		
		return $sponsor;
	}
	
	public static function getSponsorOffers(WebSoccer $websoccer, DbConnection $db, $teamId) {
		
		$team = TeamsDataService::getTeamSummaryById($websoccer, $db, $teamId);
		$teamRank = TeamsDataService::getTableRankOfTeam($websoccer, $db, $teamId);
	
		$columns["S.id"] = "sponsor_id";
		$columns["S.name"] = "name";
		$columns["S.b_match"] = "amount_match";
		$columns["S.b_home_match"] = "amount_home_bonus";
		$columns["S.b_win"] = "amount_win";
		$columns["S.b_championship"] = "amount_championship";
	
		$fromTable = $websoccer->getConfig("db_prefix") . "_sponsor AS S";
		$whereCondition = "S.league_id = %d AND (S.min_place = 0 OR S.min_place >= %d)"
							. " AND (S.max_teams <= 0 OR S.max_teams > (SELECT COUNT(*) FROM " . $websoccer->getConfig("db_prefix") . "_club AS T WHERE T.sponsor_id = S.id AND T.sponsor_matches > 0))"
							. " ORDER BY S.b_match DESC";
		$parameters = array($team["team_league_id"], $teamRank);
		
		return $db->queryCachedSelect($columns, $fromTable, $whereCondition, $parameters, 20);
	}
	
}
?>