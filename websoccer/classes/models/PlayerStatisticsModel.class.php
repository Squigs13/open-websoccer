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
 * @author Ingo Hofmann
 */
class PlayerStatisticsModel implements IModel {
	private $_db;
	private $_i18n;
	private $_websoccer;
	
	public function __construct($db, $i18n, $websoccer) {
		$this->_db = $db;
		$this->_i18n = $i18n;
		$this->_websoccer = $websoccer;
	}
	
	/**
	 * (non-PHPdoc)
	 * @see IModel::renderView()
	 */
	public function renderView() {
		return TRUE;
	}
	
	/**
	 * (non-PHPdoc)
	 * @see IModel::getTemplateParameters()
	 */
	public function getTemplateParameters() {
		
		$playerId = (int) $this->_websoccer->getRequestParameter('id');
		if ($playerId < 1) {
			throw new Exception($this->_i18n->getMessage(MSG_KEY_ERROR_PAGENOTFOUND));
		}
		
		// query statistics
		$leagueStatistics = array();
		$cupStatistics = array();
		
		$columns = array(
			'L.name' => 'league_name',	
			'SEAS.name' => 'season_name',
			'M.cup_name' => 'cup_name',
			'COUNT(S.id)' => 'matches',
			'SUM(S.assists)' => 'assists',
			'AVG(S.rating)' => 'grade',
			'SUM(S.goals)' => 'goals',
			'SUM(S.yellow_card)' => 'yellowcards',
			'SUM(S.red_card)' => 'redcards',
			'SUM(S.shots)' => 'shots',
			'SUM(S.passes_successful)' => 'passes_successful',
			'SUM(S.passes_failed)' => 'passes_failed'
		);
		
		$fromTable = $this->_websoccer->getConfig('db_prefix') . '_match_simulation AS S';
		$fromTable .= ' INNER JOIN ' . $this->_websoccer->getConfig('db_prefix') . '_match AS M ON M.id = S.match_id';
		$fromTable .= ' LEFT JOIN ' . $this->_websoccer->getConfig('db_prefix') . '_season AS SEAS ON SEAS.id = M.season_id';
		$fromTable .= ' LEFT JOIN ' . $this->_websoccer->getConfig('db_prefix') . '_league AS L ON SEAS.league_id = L.id';
		
		$whereCondition = 'S.player_id = %d AND S.minutes_played > 0 AND ((M.matchtype = \'cupmatch\' AND M.cup_name IS NOT NULL AND M.cup_name != \'\') OR (M.matchtype = \'leaguematch\' AND SEAS.id IS NOT NULL)) GROUP BY IFNULL(M.cup_name,\'\'), SEAS.id ORDER BY L.name ASC, SEAS.id ASC, M.cup_name ASC';		
		
		// execute
		$result = $this->_db->querySelect($columns, $fromTable, $whereCondition, $playerId);
		while ($statistic = $result->fetch_array()) {
			if (strlen($statistic['league_name'])) {
				$leagueStatistics[] = $statistic;
			} else {
				$cupStatistics[] = $statistic;
			}
		}
		$result->free();
		
		return array('leagueStatistics' => $leagueStatistics, 'cupStatistics' => $cupStatistics);
	}
	
}

?>