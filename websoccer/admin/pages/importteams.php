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

define('FOLDER_CLUBNAMES', BASE_FOLDER . '/admin/config/names/import/clubs');

$mainTitle = $i18n->getMessage("importteams_navlabel");

echo "<h1>$mainTitle</h1>";

if (!$admin["r_admin"] && !$admin["r_demo"] && !$admin[$page["permissionrole"]]) {
	throw new Exception($i18n->getMessage("error_access_denied"));
}

$club_files = "";
$it = new FilesystemIterator(FOLDER_CLUBNAMES);
foreach ($it as $fileinfo) {
    $club_files .= $fileinfo->getFilename() .",";
}
$filelist = substr($club_files, 0, -1);

if (!$show) {

  ?>
  
  <p><?php echo $i18n->getMessage("importteams_intro"); ?></p>

  <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post" class="form-horizontal">
    <input type="hidden" name="show" value="generate">
	<input type="hidden" name="site" value="<?php echo $site; ?>">
	
	<fieldset>
    <legend><?php echo $i18n->getMessage("import_label"); ?></legend>
    
	<?php 
	$formFields = array();
	
	$formFields["league"] = array("type" => "foreign_key", "labelcolumns" => "country,name", "jointable" => "league", "entity" => "league", "value" => "", "required" => "true");
	$formFields["importfile"] = array("type" => "select", "selection" => "$filelist", "required" => "true");
	
	foreach ($formFields as $fieldId => $fieldInfo) {
		echo FormBuilder::createFormGroup($i18n, $fieldId, $fieldInfo, $fieldInfo["value"], "import_label_");
	}	
	?>
	</fieldset>
	<div class="form-actions">
		<input type="submit" class="btn btn-primary" accesskey="s" title="Alt + s" value="<?php echo $i18n->getMessage("import_button"); ?>"> 
		<input type="reset" class="btn" value="<?php echo $i18n->getMessage("button_reset"); ?>">
	</div>    
  </form>

  <?php

}

//********** validate, generate **********
elseif ($show == "generate") {

  if (!isset($_POST['league']) || $_POST['league'] <= 0) $err[] = $i18n->getMessage("generator_validationerror_noleague");
  //if ($_POST['numberofteams'] <= 0) $err[] = $i18n->getMessage("generator_validationerror_numberofitems");
  //if ($_POST['numberofteams'] > 100) $err[] = $i18n->getMessage("generator_validationerror_numberofitems_max");
  if ($admin['r_demo']) $err[] = $i18n->getMessage("validationerror_no_changes_as_demo");

  if (isset($err)) {

    include("validationerror.inc.php");

  }
  else {

	DataImportService::generateTeams($website, $db, $_POST['league'], $_POST['importfile']);
	
	echo createSuccessMessage($i18n->getMessage("import_success"), "");

      echo "<p>&raquo; <a href=\"?site=". $site ."\">". $i18n->getMessage("back_label") . "</a></p>\n";

  }

}

?>
