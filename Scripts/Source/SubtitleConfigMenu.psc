Scriptname SubtitleConfigMenu extends SKI_ConfigBase
; SexLab Subtitles MCM�R���t�B�O���j���[

secondSubtitleTextHUD property ssHUD auto ; ���������j���[HUD
secondSubtitleText property SSC auto ; �����̃R���g���[��
SubtitleSetSetting property SSetting auto ; �����̃Z�b�e�B���O

int _csdefault = 0 ; �f�t�H���g�{�^���őI������鎚���Z�b�g�i�����l�u������\�����Ȃ��v�j

Event OnConfigInit()
	ModName = "$MCM_modName"
	Pages     = new string[2]
	Pages[0]  = "$MCM_page1_subtitleSetting"
	Pages[1]  = "$MCM_page2_commonSubtitleSetting"
EndEvent

event OnGameReload()
	parent.OnGameReload()
	Quest hudQuest = Game.GetFormFromFile(0x1829, "SexLabSubtitles.esp") as Quest
	Quest SControlQuest = Game.GetFormFromFile(0x12C4, "SexLabSubtitles.esp") as Quest

	ssHUD = hudQuest as secondSubtitleTextHUD
	SSC = SControlQuest as secondSubtitleText
	SSetting = SControlQuest as SubtitleSetSetting
endEvent

int function GetVersion()
	return ssubtitletextUtil.GetVersion()
endFunction

Event OnVersionUpdate(int a_version)
	debug.trace("# [SexLab Subtitles] - Update - ver." + CurrentVersion + " >> ver." + a_version)
	If CurrentVersion > 0 && CurrentVersion < 20
		; debug.trace("# ver1.1�ȉ�����̃A�b�v�f�[�g����")
		ModName = "$MCM_modName"
		Pages     = new string[2]
		Pages[0]  = "$MCM_page1_subtitleSetting"
		Pages[1]  = "$MCM_page2_commonSubtitleSetting"
	elseIf CurrentVersion == 20
		; debug.trace("# ver2.0��ver2.1�A�b�v�f�[�g����")
		SSC.CommonSetInit()
	elseIf CurrentVersion == 21
		; debug.trace("# v2.1��v2.2�A�b�v�f�[�g����")
		SSC.CommonSetInitUpdate22()
	endIf
EndEvent

; ==============================================
event OnPageReset(string page)
	; �\��
	if page == ""
		SetTitleText("$MCM_modCatchCopy")
		LoadCustomContent("exported/Widgets/obachan/S_Subtitles_Logo.swf", 95, 30)
		return
	endIf
	UnloadCustomContent()
	; 1�y�[�W��
	if page == "$MCM_page1_subtitleSetting"
		Page1Settings()
	endif
	; 2�y�[�W��
	if page == "$MCM_page2_commonSubtitleSetting"
		Page2Settings()
	endif
endEvent
; ==============================================
Event OnConfigOpen()
endEvent
Event OnConfigClose()
	; ����SEX���ғ����Ȃ玚�����X�V����
	If SSC.isRunningSubtitle ;����sex�ғ����̏ꍇ
		; debug.trace("# [Subtitles MCM] - �����ғ��� -MCM�̕ύX��K�p���܂�...")
		int situation = SSC.situation
		int sstage = SSC.getSubtitleStageNow()
		string[] SSet = SSetting.getCSsetBySituation(situation, sstage) ; �ύX��̎���
		string sname = SSetting.getNameCSname(situation)

		If sname == "$SMENU_disble" ; ������\����I��ł����ꍇ
			SSC.repeatUpdate = false
		else
			If SSC.SSet == SSet ; ���s���̎����ƕύX��̎����������ꍇ
				; debug.trace("# [MCM]  - ���ݎ��s���̎����ɕύX�͂���܂���ł���")
			else
				SSC.SSet = SSet
				SSC.Temp = 0
				SSC.repeatUpdate = true
				SSC.ShowSubtitlesAuto()
			endif
		endIf
	endif
EndEvent

;/---------------------------------------------------------------------------
	1�y�[�W�ڂ̐ݒ�i����Mod�S�̂̐ݒ�j
/;
	Function Page1Settings()
		SetTitleText("$MCM_page1info")
		SetCursorFillMode(TOP_TO_BOTTOM)

		int flags
		if ssHUD.isControlFin
			flags = OPTION_FLAG_DISABLED
		else
			flags = OPTION_FLAG_NONE
		endIf

		AddHeaderOption("$MCM_page1head1")
		AddKeyMapOptionST("keymap_menuKey", "$MCM_page1menukey", ssHUD.menuKey, flags)
		AddSliderOptionST("slider_interval","$MCM_page1interval", ssHUD.interval, "$MCM_Seconds", flags)
		AddToggleOptionST("toggle_randommode","$MCM_page1randommode", SSC.repeatRandom, flags) ; v2.2 added
		AddEmptyOption()

		AddHeaderOption("$MCM_page1head2")
		AddToggleOptionST("toggle_smode","$MCM_page1smode", ssHUD.SMode, flags)
		AddTextOptionST("text_uninstall", "$MCM_page1shutdown", "$MCM_page1valth", flags)

		if ssHUD.isControlFin
			AddTextOptionST("text_reset", "$MCM_page1reset", "$MCM_shareAction")
		else
			AddTextOptionST("text_reset", "$MCM_page1reset", "$MCM_shareAction", OPTION_FLAG_DISABLED)
		endIf

	EndFunction
	; ----------------------------------------------------------------------
	; �����Z�b�g�ύX���j���[�̌Ăяo���L�[
	state keymap_menuKey
		event OnHighlightST()
			SetInfoText("$MCM_page1menukeyInfo")
		endEvent
		event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
			if !KeyConflict(newKeyCode, conflictControl, conflictName)
				ssHUD.UnregisterForKey(ssHUD.menuKey)
				ssHUD.menuKey = newKeyCode
				ssHUD.RegisterForKey(ssHUD.menuKey)
				SetKeyMapOptionValueST(ssHUD.menuKey)
			endIf
		endEvent
		event OnDefaultST()
			ssHUD.UnregisterForKey(ssHUD.menuKey)
			ssHUD.menuKey = 48 ; �f�t�H���g�uB�v
			ssHUD.RegisterForKey(ssHUD.menuKey)
			SetKeyMapOptionValueST(ssHUD.menuKey)
		endEvent
	endState
	; �L�[���J�u�������̏���
	bool function KeyConflict(int newKeyCode, string conflictControl, string conflictName)
		bool continue = true
		if (conflictControl != "")
			string msg
			if (conflictName != "")
				msg = "$MCM_page1menukeyWarn1{$" + conflictName + "}{$" + conflictControl + "}"
			else
				msg = "$MCM_page1menukeyWarn2{$" + conflictControl + "}"
			endIf
			continue = ShowMessage(msg, true, "$Yes", "$No")
		endIf
		return !continue
	endFunction
	; ���蓖�Ă��L�[��MCM�ɓo�^�i�������b�Z�[�W�p�j
	String Function GetCustomControl(int keyCode)
		if(keyCode == ssHUD.menuKey)
			return "$MCM_page1menukeyMessage"
		endIf
	EndFunction
	; ----------------------------------------------------------------------
	; �����\���̊Ԋu�̒���
	state slider_interval
		event OnHighlightST()
			SetInfoText("$MCM_page1intervalInfo")
		endEvent
		event OnSliderOpenST()
			SetSliderDialogStartValue(ssHUD.interval)
			SetSliderDialogDefaultValue(6)
			SetSliderDialogRange(4, 8)
			SetSliderDialogInterval(1)
		endEvent
		event OnSliderAcceptST(float value)
			ssHUD.interval = value
			SetSliderOptionValueST(ssHUD.interval, "$MCM_Seconds")
		endEvent
		event OnDefaultST()
			ssHUD.interval = 6.0
			SetToggleOptionValueST(ssHUD.interval, "$MCM_Seconds")
		endEvent
	endState
	; ----------------------------------------------------------------------
	; �����@�\�S�̂̃I���E�I�t
	state toggle_smode
		event OnHighlightST()
			SetInfoText("$MCM_page1smodeInfo")
		endEvent
		event OnSelectST()
			ssHUD.SMode = !(ssHUD.SMode)
			SetToggleOptionValueST(ssHUD.SMode)
		endEvent
		event OnDefaultST()
			ssHUD.SMode = true
			SetToggleOptionValueST(ssHUD.SMode)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; ���������_���\���̃I���E�I�t
	state toggle_randommode
		event OnHighlightST()
			SetInfoText("$MCM_page1randommodeInfo")
		endEvent
		event OnSelectST()
			SSC.repeatRandom = !(SSC.repeatRandom)
			SetToggleOptionValueST(SSC.repeatRandom)
		endEvent
		event OnDefaultST()
			SSC.repeatRandom = false
			SetToggleOptionValueST(SSC.repeatRandom)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; Mod���O���ꍇ
	state text_uninstall
		event OnHighlightST()
			SetInfoText("$MCM_page1shutdownInfo")
		endEvent
		event OnSelectST()
			ssHUD.stopSubtitleControl()
			ForcePageReset()
		endEvent
	endState
	; ----------------------------------------------------------------------
	; Mod�̎蓮���Z�b�g
	state text_reset
		event OnHighlightST()
			SetInfoText("$MCM_page1resetInfo")
		endEvent
		event OnSelectST()
			ssHUD.resetSubtitleControl()
			ForcePageReset()
		endEvent
	endState
	; ----------------------------------------------------------------------
	; �����̃C���|�[�g
	state text_importAgain
		event OnHighlightST()
			SetInfoText("$MCM_page1importAgainInfo")
		endEvent
		event OnSelectST()
			bool importOK = SSetting.importSubtitleSetInit() ; �����Z�b�g�̏����ƃC���|�[�g
			int i = 0
			while !(importOK) && (i < 10)
				utility.wait(0.1)
				i += 1
			endwhile
			ssHUD.SetMenuInit() ; HUD���j���[�̏����i�Z�b�g���̓o�^�j
			int len = (SSetting.IS_name).length
			ShowMessage("$MCM_page1importMessage{" + len + "}", false, "$Yes")
			SSetting.CSetAgain()
			ForcePageReset()
		endEvent
	endState
;/---------------------------------------------------------------------------
	2�y�[�W�ڂ̐ݒ�i�ėp�����̊��蓖�āj
/;
	Function Page2Settings()
		SetTitleText("$MCM_page2info")
		SetCursorFillMode(LEFT_TO_RIGHT)

		int flags
		if ssHUD.isControlFin
			flags = OPTION_FLAG_DISABLED
		else
			flags = OPTION_FLAG_NONE
		endIf
		AddHeaderOption("$MCM_page2head1")
		AddHeaderOption("$MCM_page1head3")


		AddMenuOptionST("menu_cmode_default", "$CMODE_default", ssHUD.SetMenu[_csdefault], flags)
		AddTextOptionST("text_importAgain", "$MCM_page1importAgain", "$MCM_shareAction", flags)

		AddTextOptionST("text_forcedAll", "$CMODE_forcedall", "$CMODE_forcedall_btn", flags)
		AddEmptyOption()

		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$MCM_page2head2")
		AddEmptyOption()

		AddMenuOptionST("menu_cmode0", "$CMODE_0", SSetting.common_setname[0], flags)
		AddMenuOptionST("menu_cmode1", "$CMODE_1", SSetting.common_setname[1], flags)
		AddMenuOptionST("menu_cmode2", "$CMODE_2", SSetting.common_setname[2], flags)
		AddMenuOptionST("menu_cmode3", "$CMODE_3", SSetting.common_setname[3], flags)
		AddMenuOptionST("menu_cmode4", "$CMODE_4", SSetting.common_setname[4], flags)
		AddMenuOptionST("menu_cmode5", "$CMODE_5", SSetting.common_setname[5], flags)
		AddMenuOptionST("menu_cmode6", "$CMODE_6", SSetting.common_setname[6], flags)
		AddMenuOptionST("menu_cmode7", "$CMODE_7", SSetting.common_setname[7], flags)
		AddMenuOptionST("menu_cmode8", "$CMODE_8", SSetting.common_setname[8], flags)
		AddMenuOptionST("menu_cmode9", "$CMODE_9", SSetting.common_setname[9], flags)
		AddMenuOptionST("menu_cmode10", "$CMODE_10", SSetting.common_setname[10], flags)
		AddMenuOptionST("menu_cmode11", "$CMODE_11", SSetting.common_setname[11], flags)
		AddMenuOptionST("menu_cmode12", "$CMODE_12", SSetting.common_setname[12], flags)
		;v2.2 added
		AddMenuOptionST("menu_cmode13", "$CMODE_13", SSetting.common_setname[13], flags)
		AddMenuOptionST("menu_cmode14", "$CMODE_14", SSetting.common_setname[14], flags)
		AddMenuOptionST("menu_cmode15", "$CMODE_15", SSetting.common_setname[15], flags)
		AddMenuOptionST("menu_cmode16", "$CMODE_16", SSetting.common_setname[16], flags)
		AddMenuOptionST("menu_cmode17", "$CMODE_17", SSetting.common_setname[17], flags)
		AddMenuOptionST("menu_cmode18", "$CMODE_18", SSetting.common_setname[18], flags)
		AddMenuOptionST("menu_cmode19", "$CMODE_19", SSetting.common_setname[19], flags)
		AddMenuOptionST("menu_cmode20", "$CMODE_20", SSetting.common_setname[20], flags)
	EndFunction
	; ----------------------------------------------------------------------
	; �f�t�H���g�̎����Z�b�g�̐ݒ�
	state menu_cmode_default
		event OnHighlightST()
			SetInfoText("$MCM_cmode_default_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(_csdefault)
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
				SetMenuOptionValueST(ssHUD.SetMenu[_csdefault])
			else
				_csdefault = i
				If _csdefault == 0
					SetMenuOptionValueST("$SMENU_disble")
				else
					debug.trace("# setname��" + SSetting.IS_name)
					string changename = SSetting.IS_name[_csdefault - 1]
					SetMenuOptionValueST(changename)
				endif
			endIf
		endEvent
		event OnDefaultST()
			SetMenuOptionValueST(ssHUD.SetMenu[_csdefault])
		endEvent
	endState
	; ----------------------------------------------------------------------
	; �f�t�H���g�̎�����S�ẴV�`���G�[�V�����ɓK�p����
	state text_forcedAll
		event OnHighlightST()
			SetInfoText("$MCM_cmode_farcedall_info")
		endEvent
		event OnSelectST()
			If _csdefault == 0
				int num = 0
				while (num < 13)
					SSetting.setNameCSname(num, "$SMENU_disble")
					num += 1
				endwhile
			else
				int choicemode = _csdefault - 1 ; ���ۂ̑I���͔�\���̕��𔲂�����
				string setname = SSetting.IS_name[choicemode] ;�I�������Z�b�g��
				int setindex = SSetting.IS_index[choicemode] ;�I�������Z�b�g�̃C���|�[�g���iver2.1�j
				;�I�������Z�b�g
				string[] set1 = SSetting.getSSetByIndex(choicemode, 1)
				string[] set2 = SSetting.getSSetByIndex(choicemode, 2)
				string[] set3 = SSetting.getSSetByIndex(choicemode, 3)
				string[] set4 = SSetting.getSSetByIndex(choicemode, 4)
				string[] set5 = SSetting.getSSetByIndex(choicemode, 5)
				;�I�������Z�b�g��S�ẴV�`���G�[�V�����̔ėp�����Ƃ��ăZ�b�g
				int num2 = 0
				while (num2 < 21)
					 SSetting.intoSSetToCS(num2, set1, set2, set3, set4, set5)
					 SSetting.intoCSindex(num2, setindex)
					 SSetting.setNameCSname(num2, setname)
					num2 += 1
				endwhile
			endIf
			ForcePageReset()
		endEvent
	endState
	; ----------------------------------------------------------------------
	; �I�����������ɕύX���鏈���ichoice�͑I�����������̃��j���[���Acmode�͔ėp�����V�`���G�[�V�����ԍ��j
	Function changeCmode(int choice, int cmode)
		; debug.trace("# ���j���[�I�v�V����" + ssHUD.SetMenu[choice] + "���I�΂�܂���")
		string sname
		If choice < 1 ; ������\���̏ꍇ
			sname = "$SMENU_disble"
			SSetting.intoCSempty(cmode)
			SSetting.intoCSindex(cmode, 0)
		else
			int choicemode = choice - 1 ; ���ۂ̑I���͔�\���̕��𔲂������ɂȂ�
			sname = SSetting.IS_name[choicemode] ;�I�������Z�b�g��
			int setindex = SSetting.IS_index[choicemode] ;�I�������Z�b�g�̃C���|�[�g���iver2.1�j
			;�I�������Z�b�g
			string[] set1 = SSetting.getSSetByIndex(choicemode, 1)
			string[] set2 = SSetting.getSSetByIndex(choicemode, 2)
			string[] set3 = SSetting.getSSetByIndex(choicemode, 3)
			string[] set4 = SSetting.getSSetByIndex(choicemode, 4)
			string[] set5 = SSetting.getSSetByIndex(choicemode, 5)
			;�I�������Z�b�g�����݂̃V�`���G�[�V�����̔ėp�����Ƃ��ăZ�b�g
			 SSetting.intoSSetToCS(cmode, set1, set2, set3, set4, set5)
			 SSetting.intoCSindex(cmode, setindex)
		endIf
		;�I�������Z�b�g�̖��O�����݂̃V�`���G�[�V�����̎������Ƃ��ăZ�b�g
		SSetting.setNameCSname(cmode, sname)
		SetMenuOptionValueST(sname) ; ���j���[�ɔ��f
	EndFunction
	; ----------------------------------------------------------------------
	; cmode0 �N���[�`���[�p
	state menu_cmode0
		event OnHighlightST()
			SetInfoText("$MCM_cmode0_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[0])) ;���݂̑I����
			SetMenuDialogDefaultIndex(_csdefault) ; �f�t�H���g�̑I�����̏���
			SetMenuDialogOptions(ssHUD.SetMenu) ;�\������I�����̔z��
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
				changeCmode(_csdefault, 0)
			else
				changeCmode(i, 0)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 0) ; �f�t�H���g��I�񂾏ꍇ
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode1 �V�b�N�X�i�C��
	state menu_cmode1
		event OnHighlightST()
			SetInfoText("$MCM_cmode1_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[1]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 1)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 1)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode2 ��ň���
	state menu_cmode2
		event OnHighlightST()
			SetInfoText("$MCM_cmode2_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[2]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 2)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 2)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode3 ���ň���
	state menu_cmode3
		event OnHighlightST()
			SetInfoText("$MCM_cmode3_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[3]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 3)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 3)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode4 ���ň���
	state menu_cmode4
		event OnHighlightST()
			SetInfoText("$MCM_cmode4_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[4]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 4)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 4)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode5 �}�X�^�[�x�[�V����
	state menu_cmode5
		event OnHighlightST()
			SetInfoText("$MCM_cmode5_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[5]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 5)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 5)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode6 �t�B�X�g�t�@�b�N
	state menu_cmode6
		event OnHighlightST()
			SetInfoText("$MCM_cmode6_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[6]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 6)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 6)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode7 �R���
	state menu_cmode7
		event OnHighlightST()
			SetInfoText("$MCM_cmode7_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[7]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 7)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 7)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode8 �O�Y
	state menu_cmode8
		event OnHighlightST()
			SetInfoText("$MCM_cmode8_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[8]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 8)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 8)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode9 �����̃t�F���`�I
	state menu_cmode9
		event OnHighlightST()
			SetInfoText("$MCM_cmode9_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[9]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 9)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 9)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode10 �t�F���`�I
	state menu_cmode10
		event OnHighlightST()
			SetInfoText("$MCM_cmode10_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[10]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 10)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 10)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode11 ����
	state menu_cmode11
		event OnHighlightST()
			SetInfoText("$MCM_cmode11_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[11]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 11)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 11)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode12 ���
	state menu_cmode12
		event OnHighlightST()
			SetInfoText("$MCM_cmode12_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[12]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 12)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 12)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode13 �����A�i��
	state menu_cmode13
		event OnHighlightST()
			SetInfoText("$MCM_cmode13_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[13]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 13)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 13)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode14 �A�i��
	state menu_cmode14
		event OnHighlightST()
			SetInfoText("$MCM_cmode14_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[14]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 14)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 14)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode15 ����-�����I�[����
	state menu_cmode15
		event OnHighlightST()
			SetInfoText("$MCM_cmode15_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[15]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 15)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 15)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode16 ����-�I�[����
	state menu_cmode16
		event OnHighlightST()
			SetInfoText("$MCM_cmode16_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[16]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 16)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 16)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode17 ����-�����A�i��
	state menu_cmode17
		event OnHighlightST()
			SetInfoText("$MCM_cmode17_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[17]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 17)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 17)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode18 ����-�A�i��
	state menu_cmode18
		event OnHighlightST()
			SetInfoText("$MCM_cmode18_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[18]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 18)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 18)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode19 ����-����
	state menu_cmode19
		event OnHighlightST()
			SetInfoText("$MCM_cmode19_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[19]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 19)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 19)
		endEvent
	endState
	; ----------------------------------------------------------------------
	; cmode20 ����-���
	state menu_cmode20
		event OnHighlightST()
			SetInfoText("$MCM_cmode20_info")
		endEvent
		event OnMenuOpenST()
			SetMenuDialogStartIndex(ssHUD.SetMenu.Find(SSetting.common_setname[20]))
			SetMenuDialogDefaultIndex(_csdefault)
			SetMenuDialogOptions(ssHUD.SetMenu)
		endEvent
		event OnMenuAcceptST(int i)
			if i < 0
			else
				changeCmode(i, 20)
			endIf
		endEvent
		event OnDefaultST()
			changeCmode(_csdefault, 20)
		endEvent
	endState
