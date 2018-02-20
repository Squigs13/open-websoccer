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
 * Dark skin.
 * 
 * @author James Quigley
 */
class DarkThemeSkin extends DefaultBootstrapSkin {
	
	/**
	 * @see ISkin::getTemplatesSubDirectory()
	 */
	public function getTemplatesSubDirectory() {
		return 'darktheme';
	}
	
	/**
	 * @see ISkin::getCssSources()
	 */
	public function getCssSources() {
	
		$dir = $this->_websoccer->getConfig('context_root') . '/css/';
		
		if (true) {
			$files[] = '//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css';
			// $files[] = $dir . 'darktheme/bootstrap.css';
			$files[] = $dir . 'darktheme/darktheme.css';
			$files[] = $dir . 'websoccer.css';
			// $files[] = $dir . 'bootstrap-responsive.min.css';
		} else {
			$files[] = $dir . 'schedioart/theme.min.css';
		}
		
		$files[] = '//use.fontawesome.com/releases/v5.0.6/css/all.css';
	
		return $files;
	}
	
		/**
	 * @see ISkin::getJavaScriptSources()
	 */
	public function getJavaScriptSources() {
		$dir = $this->_websoccer->getConfig('context_root') . '/js/';
		$files[] = '//code.jquery.com/jquery-3.3.1.min.js';
		
		if (true) {
			$files[] = '//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js';
			$files[] = $dir . 'jquery.blockUI.js';
			// $files[] = $dir . 'wsbase.js';
		} else {
			$files[] = $dir . 'websoccer.min.js';
		}
		
		return $files;
	}
}
?>