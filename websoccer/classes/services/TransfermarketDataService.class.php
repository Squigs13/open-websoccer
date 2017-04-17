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
 * Data service for transfer market actions
 */
class TransfermarketDataService {

	public static function getHighestBidForPlayer(WebSoccer $websoccer, DbConnection $db, $playerId, $transferStart, $transferEnd) {
		$columns['B.id'] = 'bid_id';
		$columns['B.transfer_fee'] = 'amount';
		$columns['B.signing_fee'] = 'hand_money';
		$columns['B.contract_matches'] = 'contract_matches';
		$columns['B.contract_salary'] = 'contract_salary';
		$columns['B.contract_goal_bonus'] = 'contract_goalbonus';
		$columns['B.date'] = 'date';
		
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';
		
		$columns['U.id'] = 'user_id';
		$columns['U.nick'] = 'user_name';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_transfer_bid AS B';
		$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = B.club_id';
		$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_user AS U ON U.id = B.user_id';
		
		$whereCondition = 'B.player_id = %d AND B.date >= %d AND B.date <= %d ORDER BY B.date DESC';
		$parameters = array($playerId, $transferStart, $transferEnd);
		
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, 1);
		$bid = $result->fetch_array();
		$result->free();
		
		return $bid;
	}
	
	public static function getCurrentBidsOfTeam(WebSoccer $websoccer, DbConnection $db, $teamId) {
		$columns['B.transfer_fee'] = 'amount';
		$columns['B.signing_fee'] = 'hand_money';
		$columns['B.contract_matches'] = 'contract_matches';
		$columns['B.contract_salary'] = 'contract_salary';
		$columns['B.contract_goal_bonus'] = 'contract_goalbonus';
		$columns['B.date'] = 'date';
		$columns['B.ishighest'] = 'ishighest';
	
		$columns['P.id'] = 'player_id';
		$columns['P.first_name'] = 'player_firstname';
		$columns['P.last_name'] = 'player_lastname';
		$columns['P.nickname'] = 'player_pseudonym';
		$columns['P.transfer_end'] = 'auction_end';
	
		$fromTable = $websoccer->getConfig('db_prefix') . '_transfer_bid AS B';
		$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = B.club_id';
		$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_player AS P ON P.id = B.player_id';
	
		$whereCondition = 'C.id = %d AND P.transfer_end >= %d ORDER BY B.date DESC, P.transfer_end ASC';
		$parameters = array($teamId, $websoccer->getNowAsTimestamp());
	
		$bids = array();
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, 20);
		while ($bid = $result->fetch_array()) {
			if (!isset($bids[$bid['player_id']])) {
				$bids[$bid['player_id']] = $bid;
			}
		}
		$result->free();
	
		return $bids;
	}
	
	public static function getLatestBidOfUser(WebSoccer $websoccer, DbConnection $db, $userId) {
		$columns['B.transfer_fee'] = 'amount';
		$columns['B.signing_fee'] = 'hand_money';
		$columns['B.contract_matches'] = 'contract_matches';
		$columns['B.contract_salary'] = 'contract_salary';
		$columns['B.contract_goal_bonus'] = 'contract_goalbonus';
		$columns['B.date'] = 'date';
	
		$columns['P.id'] = 'player_id';
		$columns['P.first_name'] = 'player_firstname';
		$columns['P.last_name'] = 'player_lastname';
		$columns['P.transfer_end'] = 'auction_end';
	
		$fromTable = $websoccer->getConfig('db_prefix') . '_transfer_bid AS B';
		$fromTable .= ' INNER JOIN ' . $websoccer->getConfig('db_prefix') . '_player AS P ON P.id = B.player_id';
	
		$whereCondition = 'B.user_id = %d ORDER BY B.date DESC';
		$parameters = $userId;
	
		$bids = array();
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, 1);
		$bid = $result->fetch_array();
		$result->free();
	
		return $bid;
	}
	
	public static function getCompletedTransfersOfUser(WebSoccer $websoccer, DbConnection $db, $userId) {
	
		$whereCondition = 'T.buyer_user_id = %d OR T.seller_user_id = %d ORDER BY T.date DESC';
		$parameters = array($userId, $userId);
	
		return self::getCompletedTransfers($websoccer, $db, $whereCondition, $parameters);
	}
	
	public static function getCompletedTransfersOfTeam(WebSoccer $websoccer, DbConnection $db, $teamId) {
		
		$whereCondition = 'SELLER.id = %d OR BUYER.id = %d ORDER BY T.date DESC';
		$parameters = array($teamId, $teamId);
		
		return self::getCompletedTransfers($websoccer, $db, $whereCondition, $parameters);
	}
	
	public static function getCompletedTransfersOfPlayer(WebSoccer $websoccer, DbConnection $db, $playerId) {
	
		$whereCondition = 'T.player_id = %d ORDER BY T.date DESC';
		$parameters = array($playerId);
	
		return self::getCompletedTransfers($websoccer, $db, $whereCondition, $parameters);
	}
	
	public static function getLastCompletedTransfers(WebSoccer $websoccer, DbConnection $db) {
		$whereCondition = '1=1 ORDER BY T.date DESC';
		
		return self::getCompletedTransfers($websoccer, $db, $whereCondition, array());
	}
	
	private static function getCompletedTransfers(WebSoccer $websoccer, DbConnection $db, $whereCondition, $parameters) {
		$transfers = array();
		
		$columns['T.date'] = 'transfer_date';
		
		$columns['P.id'] = 'player_id';
		$columns['P.first_name'] = 'player_firstname';
		$columns['P.last_name'] = 'player_lastname';
		
		$columns['SELLER.id'] = 'from_id';
		$columns['SELLER.name'] = 'from_name';
		
		$columns['BUYER.id'] = 'to_id';
		$columns['BUYER.name'] = 'to_name';
		
		$columns['T.directtransfer_amount'] = 'directtransfer_amount';
		
		$columns['EP1.id'] = 'exchangeplayer1_id';
		$columns['EP1.nickname'] = 'exchangeplayer1_pseudonym';
		$columns['EP1.first_name'] = 'exchangeplayer1_firstname';
		$columns['EP1.last_name'] = 'exchangeplayer1_lastname';
		
		$columns['EP2.id'] = 'exchangeplayer2_id';
		$columns['EP2.nickname'] = 'exchangeplayer2_pseudonym';
		$columns['EP2.first_name'] = 'exchangeplayer2_firstname';
		$columns['EP2.last_name'] = 'exchangeplayer2_lastname';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_transfer AS T';
		$fromTable .= ' INNER JOIN ' .$websoccer->getConfig('db_prefix') . '_player AS P ON P.id = T.player_id';
		$fromTable .= ' INNER JOIN ' .$websoccer->getConfig('db_prefix') . '_club AS BUYER ON BUYER.id = T.buyer_club_id';
		$fromTable .= ' LEFT JOIN ' .$websoccer->getConfig('db_prefix') . '_club AS SELLER ON SELLER.id = T.seller_club_id';
		$fromTable .= ' LEFT JOIN ' .$websoccer->getConfig('db_prefix') . '_player AS EP1 ON EP1.id = T.directtransfer_player1';
		$fromTable .= ' LEFT JOIN ' .$websoccer->getConfig('db_prefix') . '_player AS EP2 ON EP2.id = T.directtransfer_player2';
		
		
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, 20);
		while ($transfer = $result->fetch_array()) {
			// provide column for handmoney due to backwards compatibility
			$transfer['hand_money'] = 0;
			$transfer['amount'] = $transfer['directtransfer_amount'];
			$transfers[] = $transfer;
		}
		$result->free();
		
		return $transfers;
	}
	
	public static function movePlayersWithoutTeamToTransfermarket(WebSoccer $websoccer, DbConnection $db) {
		
		$columns['unsellable'] = 0;
		$columns['loan_fee'] = 0;
		$columns['loan_owner_id'] = 0;
		$columns['loan_matches'] = 0;
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player';
		
		// select players: 
		// 1) any player who has no contract any more and are not on the market yet
		// 2) any player who has no contract any more, but still on the team list
		// 3) any player who had been added to the list before his contract ended.
		$whereCondition = 'status = 1 AND (transfer_listed != \'1\' AND (club_id = 0 OR club_id IS NULL) OR transfer_listed != \'1\' AND club_id > 0 AND contract_matches < 1 OR transfer_listed = \'1\' AND club_id > 0 AND contract_matches < 1)';
		
		// update each player, since we might also update user's inactivity
		$result = $db->querySelect('id, club_id', $fromTable, $whereCondition);
		while($player = $result->fetch_array()) {
			$team = TeamsDataService::getTeamSummaryById($websoccer, $db, $player['club_id']);
			if ($team == NULL || $team['user_id']) {
				
				if ($team['user_id']) {
					UserInactivityDataService::increaseContractExtensionField($websoccer, $db, $team['user_id']);
				}
				
				$columns['transfer_listed'] = '1';
				$columns['transfer_start'] = $websoccer->getNowAsTimestamp();
				$columns['transfer_end'] = $columns['transfer_start'] + 24 * 3600 * $websoccer->getConfig('transfermarket_duration_days');
				$columns['transfer_min_bid'] = 0;
				$columns['club_id'] = '';
				
				// do not move player out of team if team has no manager
				// (prevents shrinking of teams)
			} else {
				$columns['transfer_listed'] = '0';
				$columns['transfer_start'] = '0';
				$columns['transfer_end'] = '0';
				$columns['contract_matches'] = '5';
				$columns['club_id'] = $player['club_id'];
			}
			
			$db->queryUpdate($columns, $fromTable, 'id = %d', $player['id']);
		}
		
		$result->free();
	}
	
	public static function executeOpenTransfers(WebSoccer $websoccer, DbConnection $db) {
		
		// get ended auctions
		$columns['P.id'] = 'player_id';
		$columns['P.transfer_start'] = 'transfer_start';
		$columns['P.transfer_end'] = 'transfer_end';
		$columns['P.first_name'] = 'first_name';
		$columns['P.last_name'] = 'last_name';
		$columns['P.nickname'] = 'pseudonym';
		
		$columns['C.id'] = 'team_id';
		$columns['C.name'] = 'team_name';
		$columns['C.user_id'] = 'team_user_id';
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player AS P';
		$fromTable .= ' LEFT JOIN ' . $websoccer->getConfig('db_prefix') . '_club AS C ON C.id = P.club_id';
		
		$whereCondition = 'P.transfer_listed = \'1\' AND P.status = \'1\' AND P.transfer_end < %d';
		$parameters = $websoccer->getNowAsTimestamp();
		
		// only handle 50 per time
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters, 50);
		while ($player = $result->fetch_array()) {
			
			$bid = self::getHighestBidForPlayer($websoccer, $db, $player['player_id'], $player['transfer_start'], $player['transfer_end']);
			if (!isset($bid['bid_id'])) {
				self::extendDuration($websoccer, $db, $player['player_id']);
			} else {
				self::transferPlayer($websoccer, $db, $player, $bid);
			}
		}
		$result->free();
		
		
	}
	
	public static function getTransactionsBetweenUsers(WebSoccer $websoccer, DbConnection $db, $user1, $user2) {
		$columns = 'COUNT(*) AS number';
		$fromTable = $websoccer->getConfig('db_prefix') .'_transfer';
		$whereCondition = 'date >= %d AND (seller_user_id = %d AND buyer_user_id = %d OR seller_user_id = %d AND buyer_user_id = %d)';
	
		$parameters = array($websoccer->getNowAsTimestamp() - 30 * 3600 * 24, $user1, $user2, $user2, $user1);
	
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $parameters);
		$transactions = $result->fetch_array();
		$result->free();
	
		if (isset($transactions['number'])) {
			return $transactions['number'];
		}
	
		return 0;
	}
	
	public static function awardUserForTrades(WebSoccer $websoccer, DbConnection $db, $userId) {
	
		// count transactions of users
		$result = $db->querySelect('COUNT(*) AS hits', $websoccer->getConfig('db_prefix') . '_transfer', 
				'buyer_user_id = %d OR seller_user_id = %d', array($userId, $userId));
		$transactions = $result->fetch_array();
		$result->free();
		
		if (!$transactions || !$transactions['hits']) {
			return;
		}
		
		BadgesDataService::awardBadgeIfApplicable($websoccer, $db, $userId, 'x_trades', $transactions['hits']);
	}
	
	private function extendDuration($websoccer, $db, $playerId) {
		$fromTable = $websoccer->getConfig('db_prefix') . '_player';
		
		$columns['transfer_end'] = $websoccer->getNowAsTimestamp() + 24 * 3600 * $websoccer->getConfig('transfermarket_duration_days');
		
		$whereCondition = 'id = %d';
		
		$db->queryUpdate($columns, $fromTable, $whereCondition, $playerId);
	}
	
	private function transferPlayer(WebSoccer $websoccer, DbConnection $db, $player, $bid) {
		
		$playerName = (strlen($player['pseudonym'])) ? $player['pseudonym'] : $player['first_name'] . ' ' . $player['last_name'];
		
		// transfer without fee
		if ($player['team_id'] < 1) {
			// debit hand money
			if ($bid['hand_money'] > 0) {
				BankAccountDataService::debitAmount($websoccer, $db, $bid['team_id'], 
					$bid['hand_money'], 
					'transfer_transaction_subject_handmoney', 
					$playerName);
			}
			
		// debit / credit fee
		} else {
			BankAccountDataService::debitAmount($websoccer, $db, $bid['team_id'],
				$bid['amount'],
				'transfer_transaction_subject_fee',
				$player['team_name']);
			
			BankAccountDataService::creditAmount($websoccer, $db, $player['team_id'],
				$bid['amount'],
				'transfer_transaction_subject_fee',
				$bid['team_name']);
		}
		
		$fromTable = $websoccer->getConfig('db_prefix') . '_player';
		
		// move and update player
		$columns['transfer_listed'] = 0;
		$columns['transfer_start'] = 0;
		$columns['transfer_end'] = 0;
		$columns['club_id'] = $bid['team_id'];
		
		$columns['contract_matches'] = $bid['contract_matches'];
		$columns['contract_salary'] = $bid['contract_salary'];
		$columns['contract_goal_bonus'] = $bid['contract_goalbonus'];
		
		$whereCondition = 'id = %d';
		$db->queryUpdate($columns, $fromTable, $whereCondition, $player['player_id']);
		
		// create transfer log
		$logcolumns['player_id'] = $player['player_id'];
		$logcolumns['seller_user_id'] = $player['team_user_id'];
		$logcolumns['seller_club_id'] = $player['team_id'];
		$logcolumns['buyer_user_id'] = $bid['user_id'];
		$logcolumns['buyer_club_id'] = $bid['team_id'];
		$logcolumns['date'] = $websoccer->getNowAsTimestamp();
		$logcolumns['directtransfer_amount'] = $bid['amount'];
		
		$logTable = $websoccer->getConfig('db_prefix') . '_transfer';
		
		$db->queryInsert($logcolumns, $logTable);
		
		// notify user
		NotificationsDataService::createNotification($websoccer, $db, $bid['user_id'],
			'transfer_bid_notification_transfered', array('player' => $playerName), 'transfermarket', 'player', 'id=' . $player['player_id']);
		
		// delete old bids
		$db->queryDelete($websoccer->getConfig('db_prefix') . '_transfer_bid', 'player_id = %d', $player['player_id']);
		
		// award badges
		self::awardUserForTrades($websoccer, $db, $bid['user_id']);
		if ($player['team_user_id']) {
			self::awardUserForTrades($websoccer, $db, $player['team_user_id']);
		}
	}
	
}
?>