#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#Region Header
Local Const $sIniPath = @ScriptDir & "/cfg.ini"
Local $sPrefix =""

Global $PARCOURS[1]
Global $PROJET[1]
#EndRegion Header

#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <GuiComboBox.au3>

#include "./libs/Helper.lib.au3"


If FileExists($sIniPath) Then
	$sPrefix = IniRead($sIniPath, "name", "prefix", $sPrefix  );
Else
	IniWrite($sIniPath, "name", "prefix", $sPrefix);
EndIf

; lancer l'ui

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


#Region ### START Koda GUI section ### Form=C:\sttDev\Autoit\OpenClassrooms_NomSession\Form1.kxf
$Form1 = GUICreate("Form1", 615, 437, 192, 124)
$Input1 = GUICtrlCreateInput("Input1", 136, 48, 209, 21)
$Input2 = GUICtrlCreateInput("Input2", 136, 88, 209, 21)
$hComboParcours = GUICtrlCreateCombo("Combo1", 136, 128, 209, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$hComboProjets = GUICtrlCreateCombo("Combo2", 136, 168, 209, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$Button1 = GUICtrlCreateButton("Copier dans presse papier", 40, 352, 153, 25)
$Input3 = GUICtrlCreateInput("Input3", 32, 288, 545, 21)
$Label1 = GUICtrlCreateLabel("Nom", 64, 48, 26, 17)
$Label2 = GUICtrlCreateLabel("Prénom", 64, 88, 40, 17)
$Label3 = GUICtrlCreateLabel("Parcours", 64, 128, 46, 17)
$Label4 = GUICtrlCreateLabel("Projet", 72, 168, 31, 17)
$Label5 = GUICtrlCreateLabel("Résultat", 40, 240, 43, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###





populate_parcours()




While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $hComboParcours
			Local $iIndex = _GUICtrlComboBox_GetCurSel($hComboParcours)
			ConsoleWrite("line ~" & @ScriptLineNumber & " value of $hComboParcours " & _GUICtrlComboBox_GetCurSel($hComboParcours) & @CRLF)
			$spl = StringSplit($PARCOURS[$iIndex+1], ";", 1) ; index of gui starts from 0 but index of $parcours starts from 1
			populate_projet(StringFormat("%s.txt",$spl[1] ))
			update_res()

		Case $hComboProjets
			ConsoleWrite("line ~" & @ScriptLineNumber & " value of $hComboProjets is modified " & @CRLF)
			update_res()



	EndSwitch
WEnd

Func populate_parcours()
	HelperLib_ReadingData(@ScriptDir & "/parcours.txt", $PARCOURS)
	_GUICtrlComboBox_ResetContent ($hComboParcours)
	_GUICtrlComboBox_BeginUpdate ($hComboParcours)
			Local $k
			Local $LastLine = "Aucune ligne lue"
			For $k = 1 To UBound($PARCOURS) - 1
				$spl = StringSplit($PARCOURS[$k], ";", 1)

				if UBound($spl) < 4 Then
					ConsoleWrite("line ~" & @ScriptLineNumber & " manque un element (définit par un ;) dans la ligne qui suit celle ci :" & $LastLine & @CRLF)
					Exit
				EndIf
				;ConsoleWrite("line ~" & @ScriptLineNumber & " reading " & $spl[1] & "|" & $spl[2] & "|" & $spl[3] & @CRLF)
				_GUICtrlComboBox_AddString ( $hComboParcours, $spl[3] )
				$LastLine = $PARCOURS[$k];
			Next

			_GUICtrlComboBox_EndUpdate($hComboParcours)
			;_GUICtrlStatusBar_SetText($StatusBar1,...)
EndFunc

Func populate_projet($sFileName)
	HelperLib_ReadingData(@ScriptDir & "/" & $sFileName, $PROJET)
	ConsoleWrite("line ~" & @ScriptLineNumber & " reading " & @ScriptDir & "/" & $sFileName & @CRLF)
	_GUICtrlComboBox_ResetContent ($hComboProjets)
	_GUICtrlComboBox_BeginUpdate ($hComboProjets)
			Local $k
			For $k = 1 To UBound($PROJET) - 1
				$spl = StringSplit($PROJET[$k], ";", 1)
				_GUICtrlComboBox_AddString ( $hComboProjets, $spl[1] )
			Next

			_GUICtrlComboBox_EndUpdate($hComboProjets)
			;_GUICtrlStatusBar_SetText($StatusBar1,...)
EndFunc

Func update_res()
	Local $iIndex = _GUICtrlComboBox_GetCurSel($hComboParcours)
	;ConsoleWrite("line ~" & @ScriptLineNumber & " cherche index parcours :" & $iIndex & @CRLF)
	$saParcours = StringSplit($PARCOURS[$iIndex+1], ";", 1) ; index of gui starts from 0 but index of $parcours starts from 1
	$iIndex = _GUICtrlComboBox_GetCurSel($hComboProjets)
	If $iIndex > -1 Then
		;ConsoleWrite("line ~" & @ScriptLineNumber & " cherche index projet :" & $iIndex & @CRLF)
		$saProjet = StringSplit($PROJET[$iIndex+1], ";", 1) ; index of gui starts from 0 but index of $parcours starts from 1
		$sChaineRes = StringFormat("%s%s %s_%s_%s", $sPrefix, GUICtrlRead($Input1) , GUICtrlRead($Input2) , $saParcours[2], $saProjet[2] )
	Else
		$sChaineRes = StringFormat("%s%s %s_%s_%s", $sPrefix, GUICtrlRead($Input1), GUICtrlRead($Input2), $saParcours[2], "inconnu" )
	EndIf

	GUICtrlSetData($Input3, $sChaineRes )
EndFunc

