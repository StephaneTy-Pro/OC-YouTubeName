#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <MsgBoxConstants.au3>
#include <file.au3>

; #FUNCTION# ====================================================================================================================
; Name...........: HelperLib_ReadingData
; Usage..........: Private
; Description....:
; Error..........: 1 -> File not found
; ===============================================================================================================================

Func HelperLib_ReadingData( $sFile, ByRef $sVar )

   ;ConsoleWrite("The file: " & $sFile & " id need" & @CRLF)
	If FileExists($sFile) == 0 Then
		;ConsoleWriteError("Irrecoverable Error : The file: " & $sFile & " does not exist!" & @CRLF)
		;MsgBox($MB_SYSTEMMODAL, "Fatal Error", "In HelperLib_ReadingData() An error occurred the file : " & $sFile & " does not exist!")
		;Exit
		Return SetError(1, 0, Null)
	 EndIf

   ; voir http://www.autoitscript.com/forum/topic/130782-proxy-checker/
   Local $linecount = _FileCountLines($sFile)
   ReDim $sVar[$linecount+1] ; pour coller à la norme autoit la valeur 0 est toujours la taille du tableau on devrait trouver $CLIENT[$linecount+]
   Local $iFileSize = FileGetSize($sFile) ; sert pour sortir de la boucle si on lit trop de caractere
   Local $filehnd = FileOpen($sFile)

   If $filehnd = -1 Then
	  MsgBox($MB_SYSTEMMODAL, "Fatal Error", "In HelperLib_ReadingData() An error occurred when reading the file : " & $sFile)
	  Exit
   EndIf

   $sVar[0] = $linecount
   Local $iCharCnt = 0
   ; as we could comment some line we must change the way we store data
   Local $iEndingSizeOfArray = 1
   Local $bComment = False; by default we are not in a comment line
   For $x = 1 To $linecount

	  ;ConsoleWrite($x & "/" & $linecount)
      ;ProgressSet( ($x/$linecount)*100)
      $Line = ""
	  ; attention la derniere ligne doit contenir au moins un charactere ou un CR car elle ne sera pas interpreté
	  ;... dit autrement il faut une ligne vide a la fin du tableau
      While 1                 ;Collect the entire line into a variable.
         Local $character = FileRead( $filehnd, 1)
		 $iCharCnt+=1
		 if $iCharCnt > $iFileSize Then
			;ConsoleWrite("Erreur On a quitté la boucle de lecture de "&$sFile&" car on lisait trop de caractere ("&$iCharCnt&"/"&$iFileSize&")... verifier le fichier" & @LF )
			If $bComment = False Then
			   $sVar[$iEndingSizeOfArray] = $Line
			Else
			   $iEndingSizeOfArray = $iEndingSizeOfArray -1;
			EndIf
			ExitLoop 2
		 EndIf
         If @error = -1 Then
			If StringLen($Line > 0) Then
			   $sVar[$x] = $Line ; on s'assure que le buffer est bien vidé sinon on inscrit.... ca devrait normalement planter a cause de la taille du tableau
			EndIf
			ExitLoop 2
		 EndIf
         if $character = @CR Then
			;ConsoleWrite("sortie car on recontre CR" & @LF)
			ExitLoop
		 EndIf
         if $character = @LF then
			;ConsoleWrite(" on passe car lf" & @LF)
			ContinueLoop
		 EndIf
		 if $character = "#" Then
			;ConsoleWrite("on change de ligne car on a rencontré #" & @LF)
			$bComment = True
			;ExitLoop
		 EndIf
		 ;ConsoleWrite("$character lu " & $character & @LF)
         $Line &= $character
	  WEnd
	  If $bComment = False Then
		 $sVar[$iEndingSizeOfArray] = $Line
		 $iEndingSizeOfArray = $iEndingSizeOfArray +1
	  Else
		 $bComment = False ; end of comment cause end of line
	  EndIf
   Next
   FileClose( $filehnd)
   ReDim $sVar[$iEndingSizeOfArray+1]
   $sVar[0] = $iEndingSizeOfArray
EndFunc ;==>HelperLib_ReadingData
