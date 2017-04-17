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
 * Provides players of own team which are lended to other teams.
 */
class LentPlayersModel implements IModel {
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
		
		$teamId = $this->_websoccer->getUser()->getClubId($this->_websoccer, $this->_db);

		$columns = array(
				"P.id" => "id",
				"first_name" => "firstname",
				"last_name" => "lastname",
				"nickname" => "pseudonym",
				"position" => "position",
				"position_main" => "position_main",
				"position_second" => "position_second",
				"nation" => "player_nationality",
				"loan_matches" => "loan_matches",
				"loan_fee" => "loan_fee",
				"C.id" => "team_id",
				"C.name" => "team_name"
		);
		
		if ($this->_websoccer->getConfig('players_aging') == 'birthday') {
			$ageColumn = 'TIMESTAMPDIFF(YEAR,birthday,CURDATE())';
		} else {
			$ageColumn = 'age';
		}
		$columns[$ageColumn] = 'age';
		
		$dbPrefix = $this->_websoccer->getConfig("db_prefix");
		$fromTable = $dbPrefix . "_player P INNER JOIN " . $dbPrefix . "_club C ON C.id = P.club_id";
		$whereCondition = "P.status = 1 AND loan_owner_id = %d";
		
		$whereCondition .= " ORDER BY loan_matches ASC, position ASC, position_main ASC, last_name ASC, first_name ASC";
		
		$result = $this->_db->querySelect($columns, $fromTable, $whereCondition, $teamId, 50);
		
		$players = array();
		while ($player = $result->fetch_array()) {
			$player["position"] = PlayersDataService::_convertPosition($player["position"]);
			$players[] = $player;
		}
		$result->free();
		
		return array('lentplayers' => $players);
	}
	
}

?>