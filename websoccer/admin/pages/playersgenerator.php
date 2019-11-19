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

$mainTitle = $i18n->getMessage("playersgenerator_navlabel");

echo "<h1>$mainTitle</h1>";

if (!$admin["r_admin"] && !$admin["r_demo"] && !$admin[$page["permissionrole"]]) {
	throw new Exception($i18n->getMessage("error_access_denied"));
}

$leagueid = (isset($_REQUEST["leagueid"])) ? $_REQUEST["leagueid"] : 0;
$teamid = (isset($_REQUEST["teamid"])) ? $_REQUEST["teamid"] : 0;

//********** Startseite **********
if (!$show) {
	
  ?>
  
    <form class="form-inline">
  		<label for="leagueid"><?php echo $i18n->getMessage("generator_label_league") ?></label>
  		<select name="leagueid" id="leagueid">
  			<option></option>
  			
  			<?php 
  			$columns = "id,country,name";
  			$fromTable = $website->getConfig("db_prefix") . "_league";
  			$result = $db->querySelect($columns, $fromTable, "1 ORDER BY country ASC, name ASC", array());
  			while ($league = $result->fetch_array()) {
				echo "<option value=\"". $league["id"] . "\"";
				if ($leagueid == $league["id"]) echo " selected";
				echo ">". $league["country"] . " - " . $league["name"] . "</option>";
			}
			$result->free();
  			?>
  			
  		</select>
	  	<button type="submit" class="btn btn-primary"><?php echo $i18n->getMessage("button_display") ?></button>
	  	<a href="index.php?site=<?php echo $site ?>" class="btn"><?php echo $i18n->getMessage("button_reset") ?></a>
	  	
	  	<input type="hidden" name="site" value="<?php echo $site ?>" />
	</form>
	
	<p><a href="index.php?site=<?php echo $site ?>&show=generateform&transfermarket=1" class="btn"><?php echo $i18n->getMessage("playersgenerator_generator_for_transfermarket") ?></a></p>

  <?php
  if ($leagueid > 0) {
	  $columns = array();
	  $columns["T1.id"] = "id";
	  $columns["T1.name"] = "name";
	  $columns["(SELECT COUNT(*) FROM " . $conf['db_prefix'] . "_player AS S WHERE S.club_id = T1.id)"] = "playerscount";
	  
	  $fromTable = $conf['db_prefix'] . "_club AS T1";
	  $whereCondition = "T1.league_id = %d ORDER BY T1.name ASC";
	  $result = $db->querySelect($columns, $fromTable, $whereCondition, $leagueid);
	  
	  if (!$result->num_rows) {
	  	echo "<p>" . $i18n->getMessage("playersgenerator_noteams") . "</p>";
	  } else {
	  	?>
	  	
	  	<p><a href="?site=<?php echo $site ?>&show=generateform&leagueid=<?php echo $leagueid ?>"
	  		class="btn"><?php echo $i18n->getMessage("playersgenerator_create_for_all_teams"); ?></a></p>
	  		
	  	<h4 style="margin-top:20px"><?php echo $i18n->getMessage("playersgenerator_create_for_single_teams"); ?></h4>
	    
	    <table class="table table-striped">
	    	<thead>
	    		<tr>
	    			<th><?php echo $i18n->getMessage("entity_club_name"); ?></th>
	    			<th><?php echo $i18n->getMessage("playersgenerator_head_playerscount"); ?></th>
	    		</tr>
	    	</thead>
	    	<tbody>
	    	<?php 
	  		
	  		while ($team = $result->fetch_array()) {
	  			echo "<tr>";
	  			echo "<td><a href=\"?site=". $site . "&show=generateform&teamid=". $team["id"] . "\">". $team["name"] . "</a></td>";
	  			echo "<td>". $team["playerscount"] . "</td>";
	  			echo "</tr>";
	  		}
	  		
	  	?>
	    	</tbody>
	    </table>
	    
	    <?php
	    }
	  
	    $result->free();
	}
}

// form
elseif ($show == "generateform") {
	?>
	
  <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post" class="form-horizontal">
    <input type="hidden" name="show" value="generate">
	<input type="hidden" name="site" value="<?php echo $site; ?>">
	<input type="hidden" name="teamid" value="<?php echo $teamid; ?>">
	<input type="hidden" name="leagueid" value="<?php echo $leagueid; ?>">
	
	<fieldset>
    <legend><?php echo $i18n->getMessage("generator_label"); ?></legend>
    
	<?php 
	$formFields = array();
	
	if (isset($_REQUEST["transfermarket"]) && $_REQUEST["transfermarket"]) {
		$formFields["entity_player_nation"] = array("type" => "text", "value" => "Deutschland");
	}
	
	$formFields["player_age"] = array("type" => "number", "value" => 25);
	
	$formFields["player_age_deviation"] = array("type" => "number", "value" => 3);
	
	$formFields["entity_player_contract_salary"] = array("type" => "number", "value" => 10000);
	$formFields["entity_player_contract_matches"] = array("type" => "number", "value" => 60);
	
	$formFields["entity_player_w_strength"] = array("type" => "percent", "value" => 50);
	$formFields["entity_player_w_technique"] = array("type" => "percent", "value" => 50);
	$formFields["entity_player_w_stamina"] = array("type" => "percent", "value" => 70);
	$formFields["entity_player_w_fitness"] = array("type" => "percent", "value" => 80);
	$formFields["entity_player_w_morale"] = array("type" => "percent", "value" => 80);
	
	$formFields["playersgenerator_label_deviation"] = array("type" => "percent", "value" => 10);
	
	$formFields["option_GK"] = array("type" => "number", "value" => 2);
	$formFields["option_LB"] = array("type" => "number", "value" => 2);
	$formFields["option_CB"] = array("type" => "number", "value" => 4);
	$formFields["option_RB"] = array("type" => "number", "value" => 2);
	$formFields["option_LM"] = array("type" => "number", "value" => 2);
	$formFields["option_DM"] = array("type" => "number", "value" => 2);
	$formFields["option_CM"] = array("type" => "number", "value" => 1);
	$formFields["option_AM"] = array("type" => "number", "value" => 2);
	$formFields["option_RM"] = array("type" => "number", "value" => 2);
	$formFields["option_LW"] = array("type" => "number", "value" => 1);
	$formFields["option_CF"] = array("type" => "number", "value" => 2);
	$formFields["option_RW"] = array("type" => "number", "value" => 1);
	
	foreach ($formFields as $fieldId => $fieldInfo) {
		echo FormBuilder::createFormGroup($i18n, $fieldId, $fieldInfo, $fieldInfo["value"], "");
	}	
	?>
	</fieldset>
	<div class="form-actions">
		<input type="submit" class="btn btn-primary" accesskey="s" title="Alt + s" value="<?php echo $i18n->getMessage("generator_button"); ?>"> 
		<input type="reset" class="btn" value="<?php echo $i18n->getMessage("button_reset"); ?>">
	</div>    
  </form>
	
	<?php

}

//********** validate, generate **********
elseif ($show == "generate") {

  if ($admin['r_demo']) $err[] = $i18n->getMessage("validationerror_no_changes_as_demo");

  //##### Evtl. Fehler ausgeben #####
  if (isset($err)) {

    include("validationerror.inc.php");

  }
  //##### Abspeichern #####
  else {

	$strengths["strength"] = $_POST['entity_player_w_strength'];
	$strengths["technique"] = $_POST['entity_player_w_technique'];
	$strengths["stamina"] = $_POST['entity_player_w_stamina'];
	$strengths["freshness"] = $_POST['entity_player_w_fitness'];
	$strengths["satisfaction"] = $_POST['entity_player_w_morale'];
	
	$positions["GK"] = $_POST["option_GK"];
	$positions["LB"] = $_POST["option_LB"];
	$positions["CB"] = $_POST["option_CB"];
	$positions["RB"] = $_POST["option_RB"];
	$positions["LM"] = $_POST["option_LM"];
	$positions["CM"] = $_POST["option_CM"];
	$positions["RM"] = $_POST["option_RM"];
	$positions["DM"] = $_POST["option_DM"];
	$positions["AM"] = $_POST["option_AM"];
	$positions["LW"] = $_POST["option_LW"];
	$positions["CF"] = $_POST["option_CF"];
	$positions["RW"] = $_POST["option_RW"];

	// generate for specific team
	if ($teamid > 0) {
		DataGeneratorService::generatePlayers($website, $db, $teamid, $_POST['player_age'], $_POST['player_age_deviation'],
$_POST['entity_player_contract_salary'], $_POST['entity_player_contract_matches'], $strengths, $positions, $_POST["playersgenerator_label_deviation"]);
	} elseif ($leagueid > 0) {
		// generate for all teams of league
		
		$columns = "id";
		$fromTable = $conf['db_prefix'] . "_club";
		$whereCondition = "league_id = %d";
		$result = $db->querySelect($columns, $fromTable, $whereCondition, $leagueid);
		while ($team = $result->fetch_array()) {
			DataGeneratorService::generatePlayers($website, $db, $team["id"], $_POST['player_age'], $_POST['player_age_deviation'],
$_POST['entity_player_contract_salary'], $_POST['entity_player_contract_matches'], $strengths, $positions, $_POST["playersgenerator_label_deviation"]);
		}
		$result->free();

	} else {
		// generate for transfer market
		DataGeneratorService::generatePlayers($website, $db, 0, $_POST['player_age'], $_POST['player_age_deviation'],
$_POST['entity_player_contract_salary'], $_POST['entity_player_contract_matches'], $strengths, $positions, $_POST["playersgenerator_label_deviation"], $_POST['entity_player_nation']);
	}

	echo createSuccessMessage($i18n->getMessage("generator_success"), "");

      echo "<p>&raquo; <a href=\"?site=". $site ."&leagueid=". $leagueid . "\">". $i18n->getMessage("back_label") . "</a></p>\n";

  }

}

?>
