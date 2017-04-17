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
 * Compute and update league statistics in order to support tables of all existing seasons.
 * 
 * @author Ingo Hofmann
 */
class UpdateStatisticsJob extends AbstractJob {
	
	/**
	 * @see AbstractJob::execute()
	 */
	function execute() {
		// get some parameters for our query
		$pointsWin = 3;
		$statisticTable = $this->_websoccer->getConfig('db_prefix') . '_team_league_statistics';
		$clubTable = $this->_websoccer->getConfig('db_prefix') . '_club';
		$matchTable = $this->_websoccer->getConfig('db_prefix') . '_match';
		
		// build the monster query which fills our statistics cache
		$query = "REPLACE INTO $statisticTable
SELECT team_id, 
	season_id, 
	(home_wins * $pointsWin + home_draws + guest_wins * $pointsWin + guest_draws) AS total_points, 
	(home_goals + guest_goals) AS total_goals,
	(home_goals_conceded + guest_goals_conceded) AS total_goals_conceded,
	(home_goals + guest_goals - home_goals_conceded - guest_goals_conceded) AS total_goalsdiff,
	(home_wins + guest_wins) AS total_wins, 
	(home_draws + guest_draws) AS total_draws,
	(home_losses + guest_losses) AS total_losses, 
	(home_wins * $pointsWin + home_draws) AS home_points, 
	home_goals,
	home_goals_conceded,
	(home_goals - home_goals_conceded) AS home_goalsdiff,
	home_wins, 
	home_draws,
	home_losses, 
	(guest_wins * $pointsWin + guest_draws) AS guest_points, 
	guest_goals,
	guest_goals_conceded,
	(guest_goals - guest_goals_conceded) AS guest_goalsdiff,
	guest_wins, 
	guest_draws,
	guest_losses
FROM (SELECT C.id AS team_id, M.season_id AS season_id, 
		SUM(CASE WHEN M.home_club = C.id AND M.home_goals > M.guest_goals THEN 1 ELSE 0 END) AS home_wins, 
		SUM(CASE WHEN M.home_club = C.id AND M.home_goals < M.guest_goals THEN 1 ELSE 0 END) AS home_losses, 
		SUM(CASE WHEN M.home_club = C.id AND M.home_goals = M.guest_goals THEN 1 ELSE 0 END) AS home_draws,
		SUM(CASE WHEN M.home_club = C.id THEN M.home_goals ELSE 0 END) AS home_goals,
		SUM(CASE WHEN M.home_club = C.id THEN M.guest_goals ELSE 0 END) AS home_goals_conceded, 
		SUM(CASE WHEN M.guest_club = C.id AND M.guest_goals > M.home_goals THEN 1 ELSE 0 END) AS guest_wins, 
		SUM(CASE WHEN M.guest_club = C.id AND M.guest_goals < M.home_goals THEN 1 ELSE 0 END) AS guest_losses, 
		SUM(CASE WHEN M.guest_club = C.id AND M.home_goals = M.guest_goals THEN 1 ELSE 0 END) AS guest_draws,
		SUM(CASE WHEN M.guest_club = C.id THEN M.guest_goals ELSE 0 END) AS guest_goals,
		SUM(CASE WHEN M.guest_club = C.id THEN M.home_goals ELSE 0 END) AS guest_goals_conceded
	FROM $clubTable AS C
	INNER JOIN $matchTable AS M ON M.home_club = C.id OR M.guest_club = C.id
	WHERE M.season_id > 0 AND M.simulated = '1'
	GROUP BY C.id, M.season_id) AS matches";
		
		// query it..
		$this->_db->executeQuery($query);
		
		// update team strengths
		$strengthQuery = ' UPDATE '. $this->_websoccer->getConfig('db_prefix') .'_club c INNER JOIN (';
		$strengthQuery .= ' SELECT club_id, AVG( w_strength ) AS strength_avg';
		$strengthQuery .= ' FROM '. $this->_websoccer->getConfig('db_prefix') .'_player';
		$strengthQuery .= ' GROUP BY club_id';
		$strengthQuery .= ' ) AS r ON r.club_id = c.id';
		$strengthQuery .= ' SET c.strength = r.strength_avg';
		
		$this->_db->executeQuery($strengthQuery);
		
	}
}

?>
