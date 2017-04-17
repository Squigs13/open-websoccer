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
 * Alters the club's budget when creating new money transactions.
 * 
 * @author Ingo Hofmann
 */
class MoneyTransactionConverter implements IConverter {
	private $_i18n;
	private $_websoccer;
	
	public function __construct($i18n, $websoccer) {
		$this->_i18n = $i18n;
		$this->_websoccer = $websoccer;
	}
	
	/**
	 * @see IConverter::toHtml()
	 */
	public function toHtml($value) {
		return $this->toText($value);
	}
	
	/**
	 * @see IConverter::toText()
	 */
	public function toText($value) {
		return $value;
	}
	
	/**
	 * @see IConverter::toDbValue()
	 */
	public function toDbValue($value) {

		$amount = (int) $value;
		
		if (isset($_POST['club_id']) && $_POST['club_id']) {
			
			// get current team budget
			$db = DbConnection::getInstance();
			$columns = 'finance_budget';
			$fromTable = $this->_websoccer->getConfig('db_prefix') .'_club';
			$whereCondition = 'id = %d';
			$result = $db->querySelect($columns, $fromTable, $whereCondition, $_POST['club_id'], 1);
			$team = $result->fetch_array();
			$result->free();
			
			// update budget in DB
			$budget = $team['finance_budget'] + $amount;
			$updatecolumns = array('finance_budget' => $budget);
			$db->queryUpdate($updatecolumns, $fromTable, $whereCondition, $_POST['club_id']);
		}
		
		return $amount;
	}
	
	
}

?>