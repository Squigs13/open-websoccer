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
 * Helper functions for setting formations for the match simulation.
 * 
 * @author Ingo Hofmann
 */
class SimulationFormationHelper {
	
	/**
	 * Generates a new formation for the specified team, which will be directly stored both in the database and in the internal model.
	 * 
	 * It is a 4-4-2 formation. It always selects the freshest players of the team.
	 * 
	 * @param WebSoccer $websoccer request context.
	 * @param DbConnection $db database connection.
	 * @param SimulationTeam $team Team that needs a new formation.
	 * @param int $matchId match id.
	 */
	public static function generateNewFormationForTeam(WebSoccer $websoccer, DbConnection $db, SimulationTeam $team, $matchId) {
		
		// get all players (prefer the freshest players)
		$columns['id'] = 'id';
		$columns['position'] = 'position';
		$columns['position_main'] = 'mainPosition';
		$columns['first_name'] = 'firstName';
		$columns['last_name'] = 'lastName';
		$columns['nickname'] = 'pseudonym';
		$columns['w_strength'] = 'strength';
		$columns['w_technique'] = 'technique';
		$columns['w_stamina'] = 'stamina';
		$columns['w_fitness'] = 'freshness';
		$columns['w_morale'] = 'satisfaction';
		
		if ($websoccer->getConfig('players_aging') == 'birthday') {
			$ageColumn = 'TIMESTAMPDIFF(YEAR,birthday,CURDATE())';
		} else {
			$ageColumn = 'age';
		}
		$columns[$ageColumn] = 'age';
		
		// get players from usual team
		if (!$team->isNationalTeam) {
			$fromTable = $websoccer->getConfig('db_prefix') . '_player';
			$whereCondition = 'club_id = %d AND injured = 0 AND suspended = 0 AND status = 1 ORDER BY w_fitness DESC';
			$parameters = $team->id;
			$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters);
		} else {
			// national team: take best players of nation
			$columnsStr = '';
			
			$firstColumn = TRUE;
			foreach($columns as $dbName => $aliasName) {
				if (!$firstColumn) {
					$columnsStr = $columnsStr .', ';
				} else {
					$firstColumn = FALSE;
				}
			
				$columnsStr = $columnsStr . $dbName. ' AS '. $aliasName;
			}
			
			$nation = $db->connection->escape_string($team->name);
			$dbPrefix = $websoccer->getConfig('db_prefix');
			$queryStr = '(SELECT ' . $columnsStr . ' FROM ' . $dbPrefix . '_player WHERE nation = \''. $nation . '\' AND position = \'Goalkeeper\' ORDER BY w_strength DESC, w_fitness DESC LIMIT 1)';
			$queryStr .= ' UNION ALL (SELECT ' . $columnsStr . ' FROM ' . $dbPrefix . '_player WHERE nation = \''. $nation . '\' AND position = \'Defender\' ORDER BY w_strength DESC, w_fitness DESC LIMIT 4)';
			$queryStr .= ' UNION ALL (SELECT ' . $columnsStr . ' FROM ' . $dbPrefix . '_player WHERE nation = \''. $nation . '\' AND position = \'Midfielder\' ORDER BY w_strength DESC, w_fitness DESC LIMIT 4)';
			$queryStr .= ' UNION ALL (SELECT ' . $columnsStr . ' FROM ' . $dbPrefix . '_player WHERE nation = \''. $nation . '\' AND position = \'Forward\' ORDER BY w_strength DESC, w_fitness DESC LIMIT 2)';
			$result = $db->executeQuery($queryStr);
		}
		
		$lvExists = FALSE;
		$rvExists = FALSE;
		$lmExists = FALSE;
		$rmExists = FALSE;
		$ivPlayers = 0;
		$zmPlayers = 0;
		
		while ($playerinfo = $result->fetch_array()) {
			$position = $playerinfo['position'];
			
			// generate a 4-4-2 formation
			if ($position == PLAYER_POSITION_GOALY 
					&& isset($team->positionsAndPlayers[PLAYER_POSITION_GOALY])
					&& count($team->positionsAndPlayers[PLAYER_POSITION_GOALY]) == 1
					|| $position == PLAYER_POSITION_DEFENCE 
						&& isset($team->positionsAndPlayers[PLAYER_POSITION_DEFENCE])
						&& count($team->positionsAndPlayers[PLAYER_POSITION_DEFENCE]) >= 4
					|| $position == PLAYER_POSITION_MIDFIELD 
						&& isset($team->positionsAndPlayers[PLAYER_POSITION_MIDFIELD])
						&& count($team->positionsAndPlayers[PLAYER_POSITION_MIDFIELD]) >= 4
					|| $position == PLAYER_POSITION_STRIKER
						&& isset($team->positionsAndPlayers[PLAYER_POSITION_STRIKER])
						&& count($team->positionsAndPlayers[PLAYER_POSITION_STRIKER]) >= 2) {
				continue;
			}
			
			
			$mainPosition = $playerinfo['mainPosition'];
			//prevent double LB/RB/LM/RM
			if ($mainPosition == 'LB') {
				if ($lvExists) {
					$mainPosition = 'CB';
					$ivPlayers++;
					if ($ivPlayers == 3) {
						$mainPosition = 'RB';
						$rvExists = TRUE;
					}
				} else {
					$lvExists = TRUE;
				}
			} elseif ($mainPosition == 'RB') {
				if ($rvExists) {
					$mainPosition = 'CB';
					$ivPlayers++;
					if ($ivPlayers == 3) {
						$mainPosition = 'LB';
						$lvExists = TRUE;
					}
				} else {
					$rvExists = TRUE;
				}
			} elseif ($mainPosition == 'CB') {
				$ivPlayers++;
				if ($ivPlayers == 3) {
					if (!$rvExists) {
						$mainPosition = 'RB';
						$rvExists = TRUE;
					} else {
						$mainPosition = 'LB';
						$lvExists = TRUE;
					}
				}
			} elseif ($mainPosition == 'LM') {
				if ($lmExists) {
					$mainPosition = 'CM';
					$zmPlayers++;
				} else {
					$lmExists = TRUE;
				}
			} elseif ($mainPosition == 'RM') {
				if ($rmExists) {
					$mainPosition = 'CM';
					$zmPlayers++;
				} else {
					$rmExists = TRUE;
				}
			} elseif ($mainPosition == 'LW' || $mainPosition == 'RW') {
				$mainPosition = 'CF';
			} elseif ($mainPosition == 'CM') {
				$zmPlayers++;
				if ($zmPlayers > 2) {
					$mainPosition = 'DM';
				}
			}
			
			$player = new SimulationPlayer($playerinfo['id'], $team, $position, $mainPosition,
					5.5, $playerinfo['age'], $playerinfo['strength'], $playerinfo['technique'], $playerinfo['stamina'],
					$playerinfo['freshness'], $playerinfo['satisfaction']);
			
			if (strlen($playerinfo['pseudonym'])) {
				$player->name = $playerinfo['pseudonym'];
			} else {
				$player->name = $playerinfo['firstName'] . ' ' . $playerinfo['lastName'];
			}
			
			
			$team->positionsAndPlayers[$player->position][] = $player;
			SimulationStateHelper::createSimulationRecord($websoccer, $db, $matchId, $player);
		}
		$result->free();
	}
	
}
?>