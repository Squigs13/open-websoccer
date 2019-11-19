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
 * Creates a professionall football player out of a youth player.
 */
class MoveYouthPlayerToProfessionalController implements IActionController {
	private $_i18n;
	private $_websoccer;
	private $_db;
	
	public function __construct(I18n $i18n, WebSoccer $websoccer, DbConnection $db) {
		$this->_i18n = $i18n;
		$this->_websoccer = $websoccer;
		$this->_db = $db;
	}
	
	/**
	 * (non-PHPdoc)
	 * @see IActionController::executeAction()
	 */
	public function executeAction($parameters) {
		// check if feature is enabled
		if (!$this->_websoccer->getConfig("youth_enabled")) {
			return NULL;
		}
		
		$user = $this->_websoccer->getUser();
		
		$clubId = $user->getClubId($this->_websoccer, $this->_db);
		
		// check if it is own player
		$player = YouthPlayersDataService::getYouthPlayerById($this->_websoccer, $this->_db, $this->_i18n, $parameters["id"]);
		if ($clubId != $player["team_id"]) {
			throw new Exception($this->_i18n->getMessage("youthteam_err_notownplayer"));
		}
		
		// check if old enough
		if ($player["age"] < $this->_websoccer->getConfig("youth_min_age_professional")) {
			throw new Exception($this->_i18n->getMessage("youthteam_makeprofessional_err_tooyoung", 
					$this->_websoccer->getConfig("youth_min_age_professional")));
		}
		
		// validate main position (must be in compliance with general position)
		if ($player["position"] == "Goalkeeper") {
			$validPositions = array("GK");
		} elseif ($player["position"] == "Defender") {
			$validPositions = array("LB", "CB", "RB");
		} elseif ($player["position"] == "Midfielder") {
			$validPositions = array("LM", "RM", "DM", "AM", "CM");
		} else {
			$validPositions = array("LW", "RW", "CF");
		}
		if (!in_array($parameters["mainposition"], $validPositions)) {
			throw new Exception($this->_i18n->getMessage("youthteam_makeprofessional_err_invalidmainposition"));
		}
		
		// check if team can afford salary
		$team = TeamsDataService::getTeamSummaryById($this->_websoccer, $this->_db, $clubId);
		if ($team["team_budget"] <= TeamsDataService::getTotalPlayersSalariesOfTeam($this->_websoccer, $this->_db, $clubId)) {
			throw new Exception($this->_i18n->getMessage("youthteam_makeprofessional_err_budgettooless"));
		}
		
		$this->createPlayer($player, $parameters["mainposition"]);
		
		// success message
		$this->_websoccer->addFrontMessage(new FrontMessage(MESSAGE_TYPE_SUCCESS, 
				$this->_i18n->getMessage("youthteam_makeprofessional_success"),
				""));
		
		return "myteam";
	}
	
	private function createPlayer($player, $mainPosition) {
		
		// birthday
		$time = strtotime("-". $player["age"] . " years", $this->_websoccer->getNowAsTimestamp());
		$birthday = date("Y-m-d", $time);
		
		$columns = array(
				"club_id" => $player["team_id"],
				"first_name" => $player["firstname"],
				"last_name" => $player["lastname"],
				"birthday" => $birthday,
				"age" => $player["age"],
				"position" => $player["position"],
				"position_main" => $mainPosition,
				"nation" => $player["nation"],
				"w_strength" => $player["strength"],
				"w_technique" => $this->_websoccer->getConfig("youth_professionalmove_technique"),
				"w_stamina" => $this->_websoccer->getConfig("youth_professionalmove_stamina"),
				"w_fitness" => $this->_websoccer->getConfig("youth_professionalmove_freshness"),
				"w_morale" => $this->_websoccer->getConfig("youth_professionalmove_satisfaction"),
				"contract_salary" => $this->_websoccer->getConfig("youth_salary_per_strength") * $player["strength"],
				"contract_matches" => $this->_websoccer->getConfig("youth_professionalmove_matches"),
				"contract_goal_bonus" => 0,
				"status" => "1"
				);
		
		$this->_db->queryInsert($columns, $this->_websoccer->getConfig("db_prefix") ."_player");
		
		// delete youth player
		$this->_db->queryDelete($this->_websoccer->getConfig("db_prefix") ."_youthplayer", "id = %d", $player["id"]);
	}
	
}

?>