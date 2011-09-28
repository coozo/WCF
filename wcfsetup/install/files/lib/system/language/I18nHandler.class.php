<?php
namespace wcf\system\language;
use wcf\system\database\util\PreparedStatementConditionBuilder;
use wcf\system\exception\SystemException;
use wcf\system\language\LanguageFactory;
use wcf\system\SingletonFactory;
use wcf\system\WCF;

/**
 * Provides internationalization support for input fields.
 *
 * @author	Alexander Ebert
 * @copyright	2001-2011 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.woltlab.wcf
 * @subpackage	system.language
 * @category 	Community Framework
 */
class I18nHandler extends SingletonFactory {
	/**
	 * list of element ids
	 * @var	array<string>
	 */
	protected $elementIDs = array();
	
	/**
	 * list of plain values for elements
	 * @var	array<string>
	 */
	protected $plainValues = array();
	
	/**
	 * i18n values for elements
	 * @var	array<array>
	 */
	protected $i18nValues = array();
	
	/**
	 * element options
	 * @var	array<array>
	 */
	protected $elementOptions = array();
	
	/**
	 * Registers a new element id, returns false if element id is already set.
	 * 
	 * @param	string		elementID
	 * @return	boolean
	 */
	public function register($elementID) {
		if (in_array($elementID, $this->elementIDs)) {
			return false;
		}
		
		$this->elementIDs[] = $elementID;
		return true;
	}
	
	/**
	 * Reads plain and i18n values from request data.
	 */
	public function readValues() {
		foreach ($this->elementIDs as $elementID) {
			if (isset($_POST[$elementID])) {
				$this->plainValues[$elementID] = $_POST[$elementID];
				continue;
			}
			
			$i18nElementID = $elementID . '_i18n';
			if (isset($_POST[$i18nElementID]) && is_array($_POST[$i18nElementID])) {
				$this->i18nValues[$elementID] = array();
				
				foreach ($_POST[$i18nElementID] as $languageID => $value) {
					$this->i18nValues[$elementID][$languageID] = $value;
				}
				
				continue;
			}
			
			throw new SystemException("Missing expected value for element id '".$elementID."'");
		}
	}
	
	/**
	 * Returns true, if given element has disabled i18n functionality.
	 * 
	 * @param	string		elementID
	 * @return	boolean
	 */
	public function isPlainValue($elementID) {
		if (isset($this->plainValues[$elementID])) {
			return true;
		}
		
		return false;
	}
	
	/**
	 * Returns true, if given element has enabled i18n functionality.
	 */
	public function hasI18nValues($elementID) {
		if (isset($this->i18nValues[$elementID])) {
			return true;
		}
		
		return false;
	}
	
	/**
	 * Returns plain value for given element.
	 * 
	 * @param	string		elementID
	 * @return	string
	 * @see		wcf\system\language\I18nHandler::isPlainValue()
	 */
	public function getValue($elementID) {
		return $this->plainValues[$elementID];
	}
	
	/**
	 * Returns false, if element value is not empty.
	 * 
	 * @param	string		$elementID
	 * @return	boolean
	 */
	public function validateValue($elementID) {
		if ($this->isPlainValue($elementID)) {
			if ($this->getValue($elementID) == '') {
				return false;
			}
		}
		else if (!isset($this->i18nValues[$elementID]) || empty($this->i18nValues[$elementID])) {
			return false;
		}
		else {
			foreach ($this->i18nValues[$elementID] as $value) {
				if (empty($value)) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	/**
	 * Saves language variable for i18n. Given package id must match the associated
	 * packages, using PACKAGE_ID is highly discouraged as this breaks the ability
	 * to delete unused language items on package uninstallation using foreign keys.
	 * 
	 * @param	string		$elementID
	 * @param	string		$languageVariable
	 * @param	string		$languageCategory
	 * @param	integer		$packageID
	 */
	public function save($elementID, $languageVariable, $languageCategory, $packageID) {
		// get language category id
		$sql = "SELECT	languageCategoryID
			FROM	wcf".WCF_N."_language_category
			WHERE	languageCategory = ?";
		$statement = WCF::getDB()->prepareStatement($sql);
		$statement->execute(array($languageCategory));
		$row = $statement->fetchArray();
		$languageCategoryID = $row['languageCategoryID'];
		
		$languageIDs = array_keys($this->i18nValues[$elementID]);
		
		$conditions = new PreparedStatementConditionBuilder();
		$conditions->add("languageID IN (?)", array($languageIDs));
		$conditions->add("languageItem = ?", array($languageVariable));
		$conditions->add("packageID = ?", array($packageID));
		
		$sql = "SELECT	languageItemID, languageID
			FROM	wcf".WCF_N."_language_item
			".$conditions;
		$statement = WCF::getDB()->prepareStatement($sql);
		$statement->execute($conditions->getParameters());
		$languageItemIDs = array();
		while ($row = $statement->fetchArray()) {
			$languageItemIDs[$row['languageID']] = $row['languageItemID'];
		}
		
		$insertLanguageIDs = $updateLanguageIDs = array();
		foreach ($languageIDs as $languageID) {
			if (isset($languageItemIDs[$languageID])) {
				$updateLanguageIDs[] = $languageID;
			}
			else {
				$insertLanguageIDs[] = $languageID;
			}
		}
		
		// insert language items
		if (count($insertLanguageIDs)) {
			$sql = "INSERT INTO	wcf".WCF_N."_language_item
						(languageID, languageItem, languageItemValue, languageCategoryID, packageID)
				VALUES		(?, ?, ?, ?, ?)";
			$statement = WCF::getDB()->prepareStatement($sql);
			
			foreach ($insertLanguageIDs as $languageID) {
				$statement->execute(array(
					$languageID,
					$languageVariable,
					$this->i18nValues[$elementID][$languageID],
					$languageCategoryID,
					$packageID
				));
			}
		}
		
		// update language items
		if (count($updateLanguageIDs)) {
			$sql = "UPDATE	wcf".WCF_N."_language_item
				SET	languageItemValue = ?
				WHERE	languageItemID = ?";
			$statement = WCF::getDB()->prepareStatement($sql);
			
			foreach ($updateLanguageIDs as $languageID) {
				$statement->execute(array(
					$this->i18nValues[$elementID][$languageID],
					$languageItemIDs[$languageID]
				));
			}
		}
		
		// reset language cache
		LanguageFactory::getInstance()->deleteLanguageCache();
	}
	
	/**
	 * Removes previously created i18n language variables.
	 * 
	 * @param	string		$languageVariable
	 * @param	integer		$packageID
	 */
	public function remove($languageVariable, $packageID) {
		$sql = "DELETE FROM	wcf".WCF_N."_language_item
			WHERE		languageItem = ?
					AND packageID = ?";
		$statement = WCF::getDB()->prepareStatement($sql);
		$statement->execute(array(
			$languageVariable,
			$packageID
		));
		
		// reset language cache
		LanguageFactory::getInstance()->deleteLanguageCache();
	}
	
	/**
	 * Sets additional options for elements, required if updating values.
	 * 
	 * @param	integer		$elementID
	 * @param	string		$value
	 * @param	string		$pattern
	 */
	public function setOptions($elementID, $packageID, $value, $pattern) {
		$this->elementOptions[$elementID] = array(
			'packageID' => $packageID,
			'pattern' => $pattern,
			'value' => $value
		);
	}
	
	/**
	 * Assigns element values to template. Using request data once reading
	 * initial database data is explicitly disallowed.
	 * 
	 * @param	boolean		$useRequestData
	 */
	public function assignVariables($useRequestData = true) {
		$elementValues = array();
		$elementValuesI18n = array();
		
		foreach ($this->elementIDs as $elementID) {
			$value = '';
			$i18nValues = array();
			
			// use POST values instead of querying database
			if ($useRequestData) {
				if ($this->isPlainValue($elementID)) {
					$value = $this->getValue($elementID);
				}
				else {
					if ($this->hasI18nValues($elementID)) {
						$i18nValues = $this->i18nValues[$elementID];
					}
					else {
						$i18nValues = array();
					}
				}
			}
			else {
				if (preg_match('~^'.$this->elementOptions[$elementID]['pattern'].'$~', $this->elementOptions[$elementID]['value'])) {
					// use i18n values from language items
					$sql = "SELECT	languageID, languageItemValue
						FROM	wcf".WCF_N."_language_item
						WHERE	languageItem = ?
							AND packageID = ?";
					$statement = WCF::getDB()->prepareStatement($sql);
					$statement->execute(array(
						$this->elementOptions[$elementID]['value'],
						$this->elementOptions[$elementID]['packageID']
					));
					while ($row = $statement->fetchArray()) {
						$i18nValues[$row['languageID']] = $row['languageItemValue'];
					}
				}
				else {
					// use data provided by setOptions()
					$value = $this->elementOptions[$elementID]['value'];
				}
			}
			
			$elementValues[$elementID] = $value;
			$elementValuesI18n[$elementID] = $i18nValues;
		}
		
		WCF::getTPL()->assign(array(
			'availableLanguages' => LanguageFactory::getInstance()->getLanguages(),
			'i18nPlainValues' => $elementValues,
			'i18nValues' => $elementValuesI18n
		));
	}
}
