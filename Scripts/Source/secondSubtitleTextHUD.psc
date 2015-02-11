ScriptName secondSubtitleTextHUD Extends Quest
{ SexLab�p ���������j���[HUD }

Quest Property SubtitletextControl auto ; �ėp�����N�G�X�g
secondSubtitleText SSC ; �ėp�����R���g���[���X�N���v�g
SubtitleSetSetting SSetting ; �����Z�b�g�̐ݒ�
float Property interval = 6.0 auto ; �ėp�����\���̊Ԋu
int Property menuKey = 48 auto ; ���j���[�̌Ăяo���L�[�@�f�t�H���g�uB�v
string[] Property SetMenu auto ; �����̃Z�b�g���̃��X�g
bool Property isControlFin = false auto ; �ėp�����N�G�X�g�����S�I���������ꍇ�AON�ɂ���

Function SetMenuInit() ; ���j���[���X�g�̓o�^
	; debug.trace("# SetMenuInit�J�n")
	SSetting = SubtitletextControl as SubtitleSetSetting
	SSC = SubtitletextControl as secondSubtitleText
	string[] emptySet
	SetMenu = emptySet
	int len
	If (SSetting.IS_name) == emptySet
		; debug.trace("# �C���|�[�g�p�̎����t�@�C�������݂��܂���")
		len = 0
	else
		len = (SSetting.IS_name).length
		; debug.trace("# �C���|�[�g���������t�@�C���̐���" + len)
	endif
	SetMenu =	PapyrusUtil.StringArray(len + 1)
	SetMenu[0]  = "$SMENU_disble" ; ������\�����Ȃ�
	If len > 0
		int i = 1
		while (i < (len + 1))
			SetMenu[i] = SSetting.IS_name[ i - 1]
			; debug.trace("# SetMenu[" + i + "]��" + SetMenu[i] + "�ł�")
			i += 1
		endwhile
	endIf
EndFunction

; �������j���[���X�g���\�����ꂽ���̏���
Event OnKeyDown(Int KeyCode)
	If KeyCode == menuKey
;		debug.trace("# Subtitle HUD - OnKeyDown - ���j���[�p�̃L�[��������܂����I")
		If (!Utility.isinmenumode()) && SSC.isRunningSubtitle
			int situation = SSC.situation ; �ғ�����SEX�̃V�`���G�[�V����
			string currentsetname = SSetting.getNameCSname(situation) ; ���ݓK�p����Ă��鎚���Z�b�g��
			int currentnum = SetMenu.find(currentsetname)
			string currentSituation = SSetting.common_situation[situation] ; ���݂̃V�`���G�[�V�����̔ėp��
			string info = "$SMENU_info"
			string shead = "$SMENU_SHead"
			string chead = "$SMENU_CHead"
			int choice = ShowMenuList(info, shead, currentSituation, chead, SetMenu, currentnum, 0)
			; debug.trace("# choice��" + choice)
			If choice == 0
				SSC.repeatUpdate = false
				SSetting.setNameCSname(situation, "$SMENU_disble")
				SSetting.intoCSempty(situation)
				SSetting.intoCSindex(situation, 0)
			else
				choice = choice - 1 ; ���ۂ̑I���͔�\���̑I�����̕��𔲂������ɂȂ�
				string setname = SSetting.IS_name[choice] ;�I�������Z�b�g��
				; debug.trace("# setname��" + setname)
				;�I�������Z�b�g
				string[] set1 = SSetting.getSSetByIndex(choice, 1)
				string[] set2 = SSetting.getSSetByIndex(choice, 2)
				string[] set3 = SSetting.getSSetByIndex(choice, 3)
				string[] set4 = SSetting.getSSetByIndex(choice, 4)
				string[] set5 = SSetting.getSSetByIndex(choice, 5)
				;�I�������Z�b�g�����݂̃V�`���G�[�V�����̔ėp�����Ƃ��ăZ�b�g
				 SSetting.intoSSetToCS(situation, set1, set2, set3, set4, set5)
				;�I�������Z�b�g�̃C���|�[�g���ԍ���ۊǁiver2.1�j
				 SSetting.intoCSindex(situation, SSetting.IS_index[choice])
				 ; debug.trace("# " + SSetting.common_situation[situation] + "��importSet" + SSetting.IS_index[choice] +"��" + setname +"���Z�b�g���܂���")
				 ;�I�������Z�b�g�̖��O�����݂̃V�`���G�[�V�����̎������Ƃ��ăZ�b�g
				 SSetting.setNameCSname(situation, setname)

				 ;�����\���̍X�V
				int ssstage = SSC.getSubtitleStageNow()
				string[] SSet = SSetting.getCSsetBySituation(situation, ssstage)
				SSC.SSet = SSet
				SSC.Temp = 0
				SSC.repeatUpdate = true
				SSC.ShowSubtitlesAuto()
			endIf
		endif
	EndIf
EndEvent

; �ėp�����\���R���g���[���N�G�X�g�̏I���iMod�̃A���C���X�g�[���p�j
Function stopSubtitleControl()
	_sMode = false
	isControlFin = true
	SubtitletextControl.stop()
	; debug.trace("# SubtitlesHUD - �ėp���������N�G�X�g�����S�I�������܂���")
EndFunction

; �ėp�����\���֘A�̃��Z�b�g
Function resetSubtitleControl()
	_sMode = true
	isControlFin = false
	SubtitletextControl.start()
	; If (SubtitletextControl as Quest).isrunning()
	; 	; debug.trace("# SubtitlesHUD - �ėp���������N�G�X�g���ĊJ���܂���")
	; endif
EndFunction

; ---------------------------------------------------------------------------------
bool _sMode = true ; SubtitlesMod�̎����\���̃I���I�t�i�O��Mod�p�j
bool Property SMode
	bool function get()
		return _sMode
	endFunction
	function set(bool a_val)
		If !a_val
			If SubtitletextControl.isrunning()
				(SubtitletextControl as secondSubtitleText).repeatUpdate = false
				; debug.trace("# SubtitlesHUD - �ėp�����������I�t�ɂ��܂���")
			endif
			UnregisterForKey(menuKey)
		else
			RegisterForKey(menuKey)
		endif
		_sMode = a_val
	endFunction
endProperty
; �����G���A�̕\���E��\��
bool _visible	 = true
bool Property Visible
	bool function get()
		return _visible
	endFunction
	function set(bool a_val)
		_visible = a_val
		UI.SetBool("HUD Menu", "_root.HUDMovieBaseInstance.SS.SsubtitleTextArea._visible", _visible)
	endFunction
endProperty
Int _iMode = 0 ; v2.0�ȍ~�s�g�p
Int Property IMode
	int function get()
		return _iMode
	endFunction
	function set(int a_val)
		_iMode = a_val
	endFunction
endProperty

;/ ===============================================
	�����Z�b�g�̑I�����j���[�̏���
/;
Bool bMenuOpen
String sTitle
String situationHead
String situationM
String commonHead
String sInitialText
String sInput
String[] sOptions
Int iStartIndex
Int iDefaultIndex
Int iInput

; ���j���[���X�g�̕\��
Int Function ShowMenuList(String asTitle = "", String asSituHead, String asSitu, String asCommonHead, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex)
	If(bMenuOpen)
		Return -1
	EndIf
	bMenuOpen = True
	iInput = -1
	sTitle = asTitle
	situationHead = asSituHead
	situationM = asSitu
	commonHead = asCommonHead
	sOptions = asOptions
	iStartIndex = aiStartIndex
	iDefaultIndex = aiDefaultIndex
	SubtitleMenuList_Open(Self as Form)
	While(bMenuOpen)
		Utility.WaitMenuMode(0.1)
	EndWhile
	SubtitleMenuList_Release(Self)
	Return iInput
EndFunction

Function SubtitleMenuList_Open(Form akClient) Global
	akClient.RegisterForModEvent("SubtitleMenuList_Open", "OnSubtitleMenuListOpen")
	akClient.RegisterForModEvent("SubtitleMenuList_Close", "OnSubtitleMenuListClose")
	; UI.OpenCustomMenu("exported/Widgets/obachan/SubtitleMenuList")
	; ver1.1 �C��
	UI.OpenCustomMenu("skyui/SubtitleMenuList")
EndFunction

Function SubtitleMenuList_SetData(String asTitle = "", String asSituHead, String asSitu, String asCommonHead, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex) Global
	UI.InvokeNumber("CustomMenu", "_root.SubtitleMenuList.setPlatform", (Game.UsingGamepad() as Int))
	UI.InvokeStringA("CustomMenu", "_root.SubtitleMenuList.initListData", asOptions)
	Int iHandle = UICallback.Create("CustomMenu", "_root.SubtitleMenuList.initListParams")
	If(iHandle)
		UICallback.PushString(iHandle, asTitle)
		UICallback.PushString(iHandle, asSituHead)
		UICallback.PushString(iHandle, asSitu)
		UICallback.PushString(iHandle, asCommonHead)
		UICallback.PushInt(iHandle, aiStartIndex)
		UICallback.PushInt(iHandle, aiDefaultIndex)
		UICallback.Send(iHandle)
	EndIf
EndFunction

Function SubtitleMenuList_Release(Form akClient) Global
	akClient.UnregisterForModEvent("SubtitleMenuList_Open")
	akClient.UnregisterForModEvent("SubtitleMenuList_Close")
EndFunction

Event OnSubtitleMenuListOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "SubtitleMenuList_Open")
		SubtitleMenuList_SetData(sTitle, situationHead, situationM, commonHead, sOptions, iStartIndex, iDefaultIndex)
	EndIf
EndEvent

Event OnSubtitleMenuListClose(String asEventName, String asStringArg, Float afInput, Form akSender)
	If(asEventName == "SubtitleMenuList_Close")
		iInput = afInput as Int
		bMenuOpen = False
	EndIf
EndEvent

;/ ==============================================
	�����G���AHUD �̏���
/;
; �G���A1�@�e�L�X�g�̂ݕ\���i���m�点���I�Ɏg���j
Function ShowSubtitle(String asMessage, String asColor = "#FFFFFF")
	If(!Subtitle_Prepare())
		Return
	EndIf
	Int iHandle = UICallback.Create("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.SsubtitleTextArea.ShowSubtitle")
	If(iHandle)
		UICallback.PushString(iHandle, asMessage)
		UICallback.PushString(iHandle, asColor)
		UICallback.Send(iHandle)
	EndIf
EndFunction

; �G���A1�@�����\���i�l���̖��O����j
Function ShowSubtitleWithName(String asName, String asMessage)
	If(!Subtitle_Prepare())
		Return
	EndIf
	Int iHandle = UICallback.Create("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.SsubtitleTextArea.ShowSubtitleWithName")
	If(iHandle)
		UICallback.PushString(iHandle, asName)
		UICallback.PushString(iHandle, asMessage)
		UICallback.Send(iHandle)
	EndIf
EndFunction

; �G���A�Q�i���i�j�̃e�L�X�g�̂ݕ\��
Function ShowSubtitle2(String asMessage, String asColor = "#FFFFFF")
	If(!Subtitle_Prepare())
		Return
	EndIf
	Int iHandle = UICallback.Create("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.SsubtitleTextArea.ShowSubtitle2")
	If(iHandle)
		UICallback.PushString(iHandle, asMessage)
		UICallback.PushString(iHandle, asColor)
		UICallback.Send(iHandle)
	EndIf
EndFunction

; �G���A�Q�i���i�j�̎����\��
Function ShowSubtitleWithName2(String asName, String asMessage)
	If(!Subtitle_Prepare())
		Return
	EndIf
	Int iHandle = UICallback.Create("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.SsubtitleTextArea.ShowSubtitleWithName2")
	If(iHandle)
		UICallback.PushString(iHandle, asName)
		UICallback.PushString(iHandle, asMessage)
		UICallback.Send(iHandle)
	EndIf
EndFunction

; �G���A1�X�[�p�[�@�e�L�X�g�擪��#u�A#s�Ŗ��O����������
Function ShowSubtitleSuper(String asName1, String asName2, String asMessage)
	If(!Subtitle_Prepare())
		Return
	EndIf
	Int iHandle = UICallback.Create("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.SsubtitleTextArea.ShowSubtitleSuper")
	If(iHandle)
		UICallback.PushString(iHandle, asName1)
		UICallback.PushString(iHandle, asName2)
		UICallback.PushString(iHandle, asMessage)
		UICallback.Send(iHandle)
	EndIf
EndFunction

; �����\���̏���
Bool Function Subtitle_Prepare() global
	Int iVersion = UI.GetInt("HUD Menu", "_global.oba.SsubtitleTextArea.SS_VERSION")
	If(iVersion == 0)
		Int iHandle = UICallback.Create("HUD Menu", "_root.HUDMovieBaseInstance.createEmptyMovieClip")
		If(!iHandle)
			Return False
		EndIf
		UICallback.PushString(iHandle, "ss_container")
		UICallback.PushInt(iHandle, -16380)
		If(!UICallback.Send(iHandle))
			Return False
		EndIf
		UI.InvokeString("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.loadMovie", "obachan/SsubtitleTextArea.swf")
		Utility.Wait(0.5)
		iVersion = UI.GetInt("HUD Menu", "_global.oba.SsubtitleTextArea.SS_VERSION")
		If(iVersion == 0)
			UI.InvokeString("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.loadMovie", "exported/obachan/SsubtitleTextArea.swf")
			Utility.Wait(0.5)
			iVersion = UI.GetInt("HUD Menu", "_global.oba.SsubtitleTextArea.SS_VERSION")
			If(iVersion == 0)
				Debug.Trace("@ SSubtitleText - HUD�̕֏�Ɏ��s���܂���")
				Return False
			EndIf
			UI.InvokeString("HUD Menu", "_root.HUDMovieBaseInstance.ss_container.SetRootPath", "exported/")
		EndIf
	EndIf
	Return True
EndFunction

