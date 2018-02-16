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
 * Fancy skin with football/soccer elements.
 * Designed by Schedio Art (http://www.schedioart.in/).
 * 
 * @author Ingo Hofmann
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
			$files[] = $dir . 'darktheme/bootstrap.css';
			$files[] = $dir . 'darktheme/darktheme.css';
			$files[] = $dir . 'websoccer.css';
			$files[] = $dir . 'bootstrap-responsive.min.css';
		} else {
			$files[] = $dir . 'schedioart/theme.min.css';
		}
		
		$files[] = '//use.fontawesome.com/releases/v5.0.6/css/all.css';
	
		return $files;
	}
}
?>