#include-once


#Region AutoIt3Wrapper Directives Section
;===============================================================================================================
; Tidy Settings
;===============================================================================================================
#AutoIt3Wrapper_Run_Tidy=Y                                        ;~ (Y/N) Run Tidy before compilation. Default=N
#AutoIt3Wrapper_Tidy_Stop_OnError=Y                                ;~ (Y/N) Continue when only Warnings. Default=Y

#EndRegion AutoIt3Wrapper Directives Section


#include <ButtonConstants.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include "Link.au3"
#include "Localization.au3"
#include "ProgressBar.au3"
#include "Versioning.au3"


; #INDEX# =======================================================================================================================
; Title .........: About
; AutoIt Version : 3.3.15.0
; Description ...: About Dialog
; Author(s) .....: Derick Payne (Rizonesoft)
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $CNT_ABOUTICONS = 6
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $g_hAboutGui, $g_AboutProgIcon
Global $g_aAboutProgIcons[3] = [@ScriptFullPath, @ScriptFullPath, 1]
Global $g_aAboutIcons[$CNT_ABOUTICONS][4]
Global $g_sDlgAboutIcon = @ScriptFullPath
Global $g_hRAMLabel, $g_hRAMPRog1, $g_hRAMProg2
Global $g_hSpaceLabel, $g_hSpaceProg1, $g_hSpaceProg2
Global $g_aBuffers[4] = [0, 0, 0, 0]

If Not IsDeclared("g_hCoreGui") Then Global $g_hCoreGui
If Not IsDeclared("g_iParentState") Then Global $g_iParentState
If Not IsDeclared("g_iParent") Then Global $g_iParent
If Not IsDeclared("g_hGuiIcon") Then Global $g_hGuiIcon
If Not IsDeclared("g_sProgName") Then Global $g_sProgName
If Not IsDeclared("g_sProgShortName") Then Global $g_sProgShortName
If Not IsDeclared("g_sCompanyName") Then Global $g_sCompanyName
If Not IsDeclared("g_iAboutIconStart") Then Global $g_iAboutIconStart
If Not IsDeclared("g_sUrlCompHomePage") Then Global $g_sUrlCompHomePage
If Not IsDeclared("g_sUrlSupport") Then Global $g_sUrlSupport
If Not IsDeclared("g_sUrlDownloads") Then Global $g_sUrlDownloads
If Not IsDeclared("g_sUrlFacebook") Then Global $g_sUrlFacebook
If Not IsDeclared("g_sUrlTwitter") Then Global $g_sUrlTwitter
If Not IsDeclared("g_sUrlLinkedIn") Then Global $g_sUrlLinkedIn
If Not IsDeclared("g_sUrlRSS") Then Global $g_sUrlRSS
If Not IsDeclared("g_sUrlPayPal") Then Global $g_sUrlPayPal
If Not IsDeclared("g_sUrlGitHub") Then Global $g_sUrlGitHub
If Not IsDeclared("g_sUrlGitHubIssues") Then Global $g_sUrlGitHubIssues
If Not IsDeclared("g_sUrlSA") Then Global $g_sUrlSA
If Not IsDeclared("g_sUrlProgPage") Then Global $g_sUrlProgPage
If Not IsDeclared("g_sUrlProgForum") Then Global $g_sUrlProgForum
If Not IsDeclared("g_sAboutCredits") Then Global $g_sAboutCredits
If Not IsDeclared("g_iSizeIcon") Then Global $g_iSizeIcon
If Not IsDeclared("g_sThemesDir") Then Global $g_sThemesDir
If Not IsDeclared("g_iDialogIconStart") Then Global $g_iDialogIconStart
If Not IsDeclared("g_hTrItemAbout") Then Global $g_hTrItemAbout
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _About_ShowDialog
; _About_Contact
; _About_Facebook
; _About_GitHub
; _About_GooglePlus
; _About_HomePage
; _About_PayPal
; _About_SouthAfrica
; _About_Twitter
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Derick Payne (Rizonesoft)
; Modified.......:
; ===============================================================================================================================
Func _About_ShowDialog()

	For $xB = 0 To 3
		$g_aBuffers[$xB] = 0
	Next

	Local $abTitle, $abHome, $abSupport
	Local $abGNU, $abBtnOK

	__About_SetResources()
	_Localization_About()

	$g_iParentState = WinGetState($g_hCoreGui)

	If $g_iParentState > 0 Then
		WinSetTrans($g_hCoreGui, Default, 200)
		GUISetState(@SW_DISABLE, $g_hCoreGui)
		$g_iParent = $g_hCoreGui
	Else
		$g_iParent = 0
	EndIf

	TrayItemSetState($g_hTrItemAbout, $GUI_DISABLE)
	$g_hAboutGui = GUICreate($g_aLangAbout[0], 420, 500, -1, -1, _
			BitOR($WS_CAPTION, $WS_POPUPWINDOW), $WS_EX_TOPMOST, $g_iParent)
	GUISetFont(8.5, 400, 0, "Verdana", $g_hAboutGui, 5)
	If $g_iParentState > 0 Then GUISetIcon($g_sDlgAboutIcon, $g_iDialogIconStart + 3, $g_hAboutGui)
	GUISetOnEvent($GUI_EVENT_CLOSE, "__About_CloseDialog", $g_hAboutGui)

	$g_AboutProgIcon = GUICtrlCreateIcon($g_aAboutProgIcons[0], 99, 10, 10, $g_iSizeIcon, $g_iSizeIcon)
	GUICtrlSetCursor($g_AboutProgIcon, 0)
	GUICtrlSetOnEvent($g_AboutProgIcon, "_About_ProgramPage")

	$abTitle = GUICtrlCreateLabel($g_sProgName, $g_iSizeIcon + 22, 16, 220, 18)
	GUICtrlSetFont($abTitle, 11, 700)
	GUICtrlCreateLabel($g_aLangAbout[1] & Chr(32) & _GetProgramVersion(0), $g_iSizeIcon + 22, 40, 230, 15)
	GUICtrlCreateLabel($g_aLangAbout[2] & Chr(32) & @AutoItVersion, $g_iSizeIcon + 22, 55, 230, 15)
	GUICtrlCreateLabel($g_aLangAbout[3] & " © " & @YEAR & " " & $g_sCompanyName, $g_iSizeIcon + 22, 75, 230, 15)
	GUICtrlSetColor(-1, 0x666666)
	$g_aAboutIcons[0][0] = GUICtrlCreateIcon($g_aAboutIcons[0][1], $g_iAboutIconStart, 346, 0, 64, 64)
	GUICtrlSetTip($g_aAboutIcons[0][0], $g_aLangAbout[5], $g_aLangAbout[4], $TIP_INFOICON, $TIP_BALLOON)
	GUICtrlSetCursor($g_aAboutIcons[0][0], 0)

	GUICtrlCreateLabel("", 10, 105, 400, 1)
	GUICtrlSetBkColor(-1, 0xA0A0A0)
	GUICtrlCreateLabel("", 10, 106, 400, 1)
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	GUICtrlCreateLabel($g_aLangAbout[6] & ": ", 5, 120, 100, 15, $SS_RIGHT)
	$abHome = GUICtrlCreateLabel(_Link_Split($g_sUrlCompHomePage, 2), 110, 120, 265, 15)
	GUICtrlSetFont($abHome, 8.5, -1, 4) ;Underlined
	GUICtrlSetColor($abHome, 0x0000FF)
	GUICtrlSetCursor($abHome, 0)
	GUICtrlCreateLabel($g_aLangAbout[7] & ": ", 5, 138, 100, 15, $SS_RIGHT)
	$abGNU = GUICtrlCreateLabel("GNU General Public License 3", 110, 138, 265, 15)
	GUICtrlSetColor($abGNU, 0x666666)
	GUICtrlCreateLabel($g_aLangAbout[8] & ": ", 5, 156, 100, 15, $SS_RIGHT)
	$abSupport = GUICtrlCreateLabel(_Link_Split($g_sUrlSupport, 2), 110, 156, 265, 15)
	GUICtrlSetFont($abSupport, 8.5, -1, 4) ;Underlined
	GUICtrlSetColor($abSupport, 0x0000FF)
	GUICtrlSetCursor($abSupport, 0)

	$g_aAboutIcons[1][0] = GUICtrlCreateIcon($g_aAboutIcons[1][1], $g_iAboutIconStart + 2, 353, 165, 48, 48)
	GUICtrlSetTip($g_aAboutIcons[1][0], $g_aLangAbout[10], $g_aLangAbout[9], $TIP_INFOICON, $TIP_BALLOON)
	GUICtrlSetCursor($g_aAboutIcons[1][0], 0)

	GUICtrlCreateGroup($g_aLangAbout[11], 10, 205, 400, 125)
	GUICtrlSetFont(-1, 10, 700, 2)
	GUICtrlCreateEdit($g_sAboutCredits, 20, 230, 380, 85, BitOR($WS_VSCROLL, $ES_READONLY), $WS_EX_CLIENTEDGE)
	GUICtrlSetColor(-1, 0x333333)
	GUICtrlSetFont(-1, 8.5, -1, 2)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hRAMLabel = GUICtrlCreateLabel("", 20, 346, 380, 15)
	GUICtrlSetFont($g_hRAMLabel, 8, 700)
	GUICtrlSetColor($g_hRAMLabel, 0x333333)
	GUICtrlSetTip($g_hRAMLabel, $g_aLangAbout[18])

	GUICtrlCreateLabel("", 20, 363, 380, 15)
	GUICtrlSetBkColor(-1, 0x555555)
	GUICtrlSetTip(-1, $g_aLangAbout[18])
	GUICtrlCreateLabel("", 21, 364, 378, 13)
	GUICtrlSetBkColor(-1, 0xD3D3D3)
	GUICtrlSetTip(-1, $g_aLangAbout[18])

	$g_hRAMPRog1 = GUICtrlCreateLabel("", 22, 365, 50, 11)
	GUICtrlSetTip($g_hRAMPRog1, $g_aLangAbout[18])
	$g_hRAMProg2 = GUICtrlCreateLabel("", 23, 366, 48, 9)
	GUICtrlSetTip($g_hRAMProg2, $g_aLangAbout[18])

	$g_hSpaceLabel = GUICtrlCreateLabel("", 20, 383, 380, 15)
	GUICtrlSetFont($g_hSpaceLabel, 8, 700)
	GUICtrlSetColor($g_hSpaceLabel, 0x333333)

;~ ProgressBar Background
	GUICtrlCreateLabel("", 20, 400, 380, 15)
	GUICtrlSetBkColor(-1, 0x555555)
	GUICtrlCreateLabel("", 21, 401, 378, 13)
	GUICtrlSetBkColor(-1, 0xD3D3D3)
;~ ProgressBar
	$g_hSpaceProg1 = GUICtrlCreateLabel("", 22, 402, 50, 11)
	$g_hSpaceProg2 = GUICtrlCreateLabel("", 23, 403, 48, 9)

	$abBtnOK = GUICtrlCreateButton($g_aLangAbout[16], 260, 450, 150, 38, $BS_DEFPUSHBUTTON)
	GUICtrlSetFont($abBtnOK, 9)

	$g_aAboutIcons[2][0] = GUICtrlCreateIcon($g_aAboutIcons[2][1], $g_iAboutIconStart + 4, 20, 455, 32, 32)
	GUICtrlSetTip($g_aAboutIcons[2][0], $g_aLangAbout[12])
	GUICtrlSetCursor($g_aAboutIcons[2][0], 0)
	$g_aAboutIcons[3][0] = GUICtrlCreateIcon($g_aAboutIcons[3][1], $g_iAboutIconStart + 6, 55, 455, 32, 32)
	GUICtrlSetTip($g_aAboutIcons[3][0], $g_aLangAbout[13])
	GUICtrlSetCursor($g_aAboutIcons[3][0], 0)
	$g_aAboutIcons[4][0] = GUICtrlCreateIcon($g_aAboutIcons[4][1], $g_iAboutIconStart + 8, 90, 455, 32, 32)
	GUICtrlSetTip($g_aAboutIcons[4][0], $g_aLangAbout[14])
	GUICtrlSetCursor($g_aAboutIcons[4][0], 0)
	$g_aAboutIcons[5][0] = GUICtrlCreateIcon($g_aAboutIcons[5][1], $g_iAboutIconStart + 10, 125, 455, 32, 32)
	GUICtrlSetTip($g_aAboutIcons[5][0], $g_aLangAbout[15])
	GUICtrlSetCursor($g_aAboutIcons[5][0], 0)

	GUICtrlSetOnEvent($abBtnOK, "__About_CloseDialog")
	GUICtrlSetOnEvent($abHome, "_About_HomePage")
	GUICtrlSetOnEvent($abSupport, "_About_Support")
	GUICtrlSetOnEvent($g_aAboutIcons[0][0], "_About_PayPal")
	GUICtrlSetOnEvent($g_aAboutIcons[1][0], "_About_SouthAfrica")
	GUICtrlSetOnEvent($g_aAboutIcons[2][0], "_About_Facebook")
	GUICtrlSetOnEvent($g_aAboutIcons[3][0], "_About_Twitter")
	GUICtrlSetOnEvent($g_aAboutIcons[4][0], "_About_GooglePlus")
	GUICtrlSetOnEvent($g_aAboutIcons[5][0], "_About_GitHub")

	GUISetState(@SW_SHOW, $g_hAboutGui)
	__About_SetMemoryStats()
	__About_SetDriveSpaceStats()

	AdlibRegister("__About_OnIconsHover", 50)
	AdlibRegister("__About_SetMemoryStats", 3000)
	AdlibRegister("__About_SetDriveSpaceStats", 5000)

EndFunc   ;==>_About_ShowDialog


Func _About_Support()
	ShellExecute(_Link_Split($g_sUrlSupport))
EndFunc   ;==>_About_Support


Func _About_Downloads()
	ShellExecute(_Link_Split($g_sUrlDownloads))
EndFunc   ;==>_About_Downloads


Func _About_Facebook()
	ShellExecute(_Link_Split($g_sUrlFacebook))
EndFunc   ;==>_About_Facebook


Func _About_GitHub()
	ShellExecute(_Link_Split($g_sUrlGitHub))
EndFunc   ;==>_About_GitHub


Func _About_GitHubIssues()
	ShellExecute(_Link_Split($g_sUrlGitHubIssues))
EndFunc   ;==>_About_GitHubIssues


Func _About_GooglePlus()
	ShellExecute(_Link_Split($g_sUrlLinkedIn))
EndFunc   ;==>_About_GooglePlus


Func _About_HomePage()
	ShellExecute(_Link_Split($g_sUrlCompHomePage))
EndFunc   ;==>_About_HomePage


Func _About_PayPal()
	ShellExecute(_Link_Split($g_sUrlPayPal))
EndFunc   ;==>_About_PayPal


Func _About_ProgramPage()
	ShellExecute(_Link_Split($g_sUrlProgPage))
EndFunc   ;==>_About_ProgramPage


Func _About_SouthAfrica()
	ShellExecute(_Link_Split($g_sUrlSA))
EndFunc   ;==>_About_SouthAfrica


Func _About_Twitter()
	ShellExecute(_Link_Split($g_sUrlTwitter))
EndFunc   ;==>_About_Twitter


Func __About_CloseDialog()

	AdlibUnRegister("__About_OnIconsHover")
	AdlibUnRegister("__About_SetMemoryStats")
	AdlibUnRegister("__About_SetDriveSpaceStats")

	If $g_iParentState > 0 Then
		WinSetTrans($g_hCoreGui, Default, 255)
		GUISetState(@SW_ENABLE, $g_hCoreGui)
	EndIf
	GUIDelete($g_hAboutGui)
	TrayItemSetState($g_hTrItemAbout, $GUI_ENABLE)

EndFunc   ;==>__About_CloseDialog


Func __About_OnIconsHover()

	Local $iCursorAbout = GUIGetCursorInfo()
	If Not @err�Y���Y�Appe�0D
g�i=��'�dy4�)g[�nu��`�p�	�,5���<utP���k�.#�"�מ�A�e�1�jL��b��Ϡ�.��b_�T���k�g�����N׳���y�d�ﯢ��������e ���t�4��R��<͘���{�Gv^ n��Z��uO��v�gX�U�ٚEq�&�0���fʻ�ov6K#m��1�9�O'���7=H��:d�}�G�	D���wi+>�B�Č�6>�7Tl	Ԧ�_5T��/�D���Ld����KZ����ĭU֓L�id���*��Y�N��n랠[��3|�x��A�#���F�7
[{���9�Ydh��b(��2)gRT���b���ՠ׃
��g����mt���<�GMq@|�d�r��Is"����J������ô�ӊ`��Pt[�7���|��an��鳨[����yM_;6�$�.^Ԯ���@��~#z���j���o%�K@G:�1dZ�ZV�M��_�v�5�@����޿�n������r�4c�jg^������{i��Ҁ�1��w�ᷧ�Vi	�Y�inI�� ���3�۔�JRN���-��MO������b�����H���Z�ZL8��� ,��(��IJe�2N(�����7��!�,G��M����3��CR�l���(��@R^}xj�"����4�W^�˙?�`�!�{T޳����pv1�}َ��{|�@����_q��8x���u$wdr�(�GԐ���;8��9B�~��r�O$D��T��z�aۻČ��b*b�8��9I-ƍ?X�;W��J{��J6͂TJ
`�؎���"|FՇNz�9OQ@R;�쐫P�@��~��'c��pėt��M�5D�~��X�^R�}�(��8 �����х�]mca=M��8.�;��7N���Z��.�ٽ�ó��ӊ�U�n�� �[�g�>���e��]��e�W_��b���>�[��]I��&�����n�TTt�m#o���"D@䅬Y��S�������N3=��y4�aF��ȗdAz}c1O�e�3�S�[�kK����[D�3�0�i�?��{�; 8������Ѧ��hCi���x8��џ����y�-^T1`R���A8��I<�X����O7��Ԋ��7�5�^��e~��-��e~��'ȂA�z�^ *C�%��#]�
��y⨴K�sC.v�F��Ҹ��Y�q�g�G,6k�PfA�rƧ����ia��o��kC��DV\����1;i�u�&�_�|k
	h�w=�9�G2������BCҘ6��s	�g.��IIf�<�7� Ĺ M�2��<9r�$��a����W	`��o�#*"��:b�/9��do 2�w7O�/%\�)�UD�P�H���/}��(3D�1��q�O�RR^��^W&K��D���F��`!��b� �ݸ�U���G��3����5:�/NHM���}�m`��p�Q���Ed����e}�|��٨o�o���-�z��7-%���b�����EI�����.5w:�{,��R�0��R�W_W�wa����;���	ȳ��I�1����Gn<���A�d5[曕EO�l;�ӗ������U�՞���/^���H���Xd�{/G�@�oN'~�*K��ğ��D`r��B��,��>�vC�?�ҖE��o�p�%	�a�J�a�z��͏m]r��ݧ�^��B6l�Z���G�0�]��8��J���{�.~W��ug;�縓����ʬ��Ѵ�?�loSz�)f�`�o�`"+xǟ��^]�� *Wg���d���)la�Pڎ��+֐
�wܪp7���Ep��ʵ�=�PJ�D��r	y+�=d�xj�
�Ub2f�DF�AK�{}J���:�Y���CCw�ر��Ĵ�+�SP��;v`�Q�<-l�2���co�\u���ꢹ-KM��o������~�
p�����k��|6�nBj@ohIL�����LE&L#t��goae�ʱ��C���ڱ$S�s�'���qDB8�%'>��fo��ҙuhb��~G�Za�T��8�_/�"�e^���
 ]�ҠkVS��9�ѴQ�wU�Qp����֊h�K3�>�7��W#�z[G�x��ƍ���c�=���3���"�Hn���%�mUM�9$H�!G�}rc�8� ]s8���Ff�P6�@Cn?rF�R�u�$
�ix߿��~���ސ=�F�>�} ����>��4(%n�񉦇̅Ń�,�y�@�}l7�'���X��+҇���r���&�_b^T&�K���7�Tz핔�v�X�IW�,9M }�����I�$G�C�'g�ɄUBNR����t�\@�黒r�
2�'�HĽ	^��Ͽ��a�g�Ѫ��ƙ�Y���*vd���5|� ���I���]�j�E�	|�G��*�P<��U�ނ�@
n��A��f12rY�1���D�L�i��[�G�9?8���h�����#B��J��QYf��KʽO�"� �ս|q����k���đJ;�, �Zi��r>�_x3��0� �+���2�nX���
.q�9�K�qϡsa�$<�����2ݔ�$7x�R\��H�!�{�)2}�`D��-���i5'�o�uk%"���/��8ڌ�7ɼw�T�Bna�|?6�5��XT/ٰ�2��i�(��<tXHq����0�&Z��~d�"������0�"�󂭅���P�x�͇�����Uɖsh���	X�o*Dq�׿�a�z؅/��Cn�)2�=i�����y�ƾY�Ϲ��(�T�wH?��V�O���1Kh'��g�V���c�\��\ZTF�?Z^�Y���#|���2'��v;Y�}��(�Ғ8>�e	�m��p�<�G����!���Eth`Y7�u�h'˞�ط�s�P�$=��ۚu��6Z����mPǯ�|�;l)��1�92��;�&���n� �
��9�f��j��L�?v�]d@o���-�X0��Dxn�y�Ä��V�]t�vt�D��;L�ݕ���ƈ��B���E�S�9[�d�6��~���
�Z���}
�A03��7�g�Y�R.�7fx�^I�C��X��K,�7Y�#;B��g-�WT��O��z��#��&�/� �%p'D�3������5¾���DT#�m��?]Cï�?�r7��u����ϲN�n��YT/����Yf�����t���Ƿ��:���ݑ�RÈ[�ά$]7b��CA�$�D�Q��t���=)�5Ȑy1��C�=��K�~��i!��2 k�~^Be.'��zj�bc�}�)�5�r�U����b����!
������j`� [!�v��d����"����3e�/�dW��{�����o�����Ep�-�����]�����:��*���\�i�Y�g1$���U�8�P����ۉ@Lț|�E����t N����a���/����N��M̒5#k��7\�M���?�����֭+��B��A�+���(�	��x�W���2���yf�r�Qlۗo�L�����G���9�Ju.S�����h�n."�g�k���	��7�$4u�f#9���dO�͚�P�>�F�}5< l���a���#
`64��}���,(ƃa5�����R�U2�m���Z��?ٴw�,U~��9#�~�8ˉ�.Y�;{L���k��Z !�ōN03;�=p�u�f�l*�V� v=IWy�	�/]���JOGz=�l��w#* �HYa}
)�W��Ý`9q�X��ܬU�G�EI�ů�[�+{1�vN�GTߦ�*���(y�%C���	<��ɘC��2( UDFޱ1�nffؐ���W��v�K���? Qo����GIďR����q%$<!��Z%�-Q*6�v'|�� ��� �:�n(�����aM,���&^�!_�c�.�w�򗈐��q��&E�쪃�+~���0Uު�Ί�))aNjC�qo�[!܈m7���Wv&Q?w4����8��s�E�G�d�wS$��U_�� ��V�Hkco���?����HO��ُ�b::�㹷��:f�.��$D���=���:��o6e�Ͱ�RA�u�Y�R�$4�C�:�O<��(��Ι��G��T���t�~�)S�� ��xH��@�M�96U��N�|!�9�+D�/J���"ֵ��7�`���p��?,�> �=�j�á��DO��_�s����]�IK��� �yV�R����і����s��4Hɫ�¾���[{�^j��5�=�G�X�b_�Wr��En����N����?�آ�툛7���Az�W�JnI�7��#���u��
��� ��&�=��=���ڥ��%nT���(#����NV�j�W���&���=��ћֵ������m���)̓����ҬC�~�e�4w�ڭ��FL�%�����Ǧ� ��-Ԥ6I��U�F�=�����qm�o��S�n �`����=K���G#���N�ϵ��{]W�SE�{�P�b��\"��;���HY��:{M+����:��u�c�mЛ)n$�3g�pr��MnK�*!�I>�u��Ux����귨�ʠ��E�t��]ix~E��(m��s��p��$���G����c�|���t�M�i�Q�g{KI�r�e��'��^4t|�R5��u
F2�Qq��T�-��ùm���8��|��1����<��ZUM�~I��Q