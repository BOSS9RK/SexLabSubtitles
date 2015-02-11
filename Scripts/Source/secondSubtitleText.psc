Scriptname secondSubtitleText extends Quest
{sexLab�p �ėp�����R���g���[���X�N���v�g}

SexLabFramework Property SexLab auto ; SexLab�l
secondSubtitleTextHUD Property SS auto ; ����HUD
SubtitleSetSetting Property SSetting auto ; �����Z�b�g�̃C���|�[�g�A�ėp�����̐ݒ�Ȃ�

; �ėp�����\���̏�ԃv���p�e�B�i�O������̃A�N�Z�X�p�j
bool Property isRunningSubtitle auto; �����\�����Ă���Sex�V�[�������݉ғ������ǂ���
int Property currentStage auto; ���݉ғ����̃A�j���[�V�����̃X�e�[�W
int Property maxStage auto; ���݉ғ����̃A�j���[�V�����̑��X�e�[�W��
int Property situation = 12 auto ; ���݂̃A�j���[�V�����̎����̃V�`���G�[�V����

string sexlabID ; ���݉ғ�����Sex�V�[����ID
bool IsAggressive ; �������ǂ���

Actor Player ; �v���C���[
Actor Uke ; ����̃A�N�^�[
Actor Seme ; �U���̃A�N�^�[
string name_Uke ; ��̖��O
string name_Seme ; �U�̖��O
bool _samesex ; ��ƍU���������ǂ����iv2.2�j
int _temp_r ; �����_���\���̍Đ��ԍ��iv2.2�j

int _temp = 0 ; �����\���̏��Ԃ��L�����Ă���
int Property Temp ; �O���A�N�Z�X�p
	int function get()
		return _temp
	endFunction
	function set(int a_val)
		_temp = a_val
	endFunction
endProperty

float stageChangeTime = 0.0 ; �O��X�e�[�W���؂�ւ��������
string[] _sset ; �\�������鎚���Z�b�g
string[] Property SSet ; �O���A�N�Z�X�p
	string[] function get()
		return _sset
	endFunction
	function set(string[] a_val)
		_sset = a_val
	endFunction
endProperty

bool property repeatUpdate = false auto ; true���̂�OnUpdate��������\������
bool property repeatRandom = false auto ; true���̓����_���Ŏ����\�� (v2.2)

;/======================================================/;

Function Initialize() ; �Q�[�������[�h����邽�тɌĂяo��
	sexlabID = ""
	Player = Game.GetPlayer()
	SSetting = (self as Quest) as SubtitleSetSetting
	registerEvent()
EndFunction

Function CommonSetInit() ; �ėp�����̏����iMod�������񁕍X�V���j
	SSetting.commonSetInit() ; �V�`���G�[�V�����̃Z�b�g
	bool importOK = SSetting.importSubtitleSetInit() ; �����Z�b�g�̏����ƃC���|�[�g
	int i = 0
	while !(importOK) && (i < 10)
		utility.wait(0.1)
		i += 1
	endwhile
	SSetting.defaultSSet() ; �������ݒ�
	SS.SetMenuInit() ; HUD���j���[�̏����i�Z�b�g���̓o�^�j
EndFunction

Function CommonSetInitUpdate22() ; �ėp�����̏����iv2.1��v2.2�X�V�p�j
	SSetting.commonSetInitUpdate22() ; �V�`���G�[�V�����̒ǉ�
	bool importOK = SSetting.importSubtitleSetInit() ; �����Z�b�g�̏����ƃC���|�[�g
	int i = 0
	while !(importOK) && (i < 10)
		utility.wait(0.1)
		i += 1
	endwhile
	SSetting.defaultSSetUpdate22() ; v2.1��v2.2�X�V����ݒ�
	SS.SetMenuInit() ; HUD���j���[�̏����i�Z�b�g���̓o�^�j
EndFunction

Function RegisterMenukey() ; �������j���[���X�g�Ăяo���L�[�̓o�^
	SS.Registerforkey(SS.menuKey)
EndFunction

Function UnregisterSubtitles() ; �֘A�����̓o�^���폜
	unregisterEvent()
	SS.Unregisterforkey(SS.menuKey)
EndFunction

;/======================================================
	SexLab�p�C�x���g
/;
	Function registerEvent()
		RegisterForModEvent("AnimationStart", "startAnim")
		RegisterForModEvent("AnimationEnd", "endAnim")
		RegisterForModEvent("StageStart", "startStage")
		RegisterForModEvent("AnimationChange", "startStage")
		RegisterForModEvent("StageEnd", "endStage")
		RegisterForModEvent("OrgasmStart", "startStage")
		RegisterForModEvent("OrgasmEnd", "endStage")
	EndFunction
	Function unregisterEvent()
		UnregisterForModEvent("AnimationStart")
		UnregisterForModEvent("AnimationChange")
		UnregisterForModEvent("AnimationEnd")
		UnregisterForModEvent("StageStart")
		UnregisterForModEvent("StageEnd")
		UnregisterForModEvent("OrgasmStart")
		UnregisterForModEvent("OrgasmEnd")
	EndFunction

	;SexLab�A�j���J�n���̏��� -------------------------------------
	event startAnim(string eventName, string argString, float argNum, form sender)
		sslThreadController controller = SexLab.HookController(argString)
		bool hasplayer = controller.HasPlayer

		If hasplayer && SS.SMode ; �v���C���[�������ł��āA���ėp�����V�X�e�����L���̏ꍇ
			isRunningSubtitle = true
			IsAggressive = controller.IsAggressive
			_temp = 0
			situation = 12
			sexlabID = argString
			Actor[] member = controller.Positions
			If (member.length == 1)
				Uke = member[0]
				Seme = member[0]
			else
				Uke = member[0]
				Seme = member[1]
			endIf
			; ver2.2 �f�B�X�v���C�l�[����D��I�Ɏ擾�iNPC�̂݁j
			string dn_Uke = ""
			string dn_Seme = ""
			string n_Uke = ""
			string n_Seme = ""
			If Uke == Player
				name_Uke = Uke.getactorbase().getName()
			else
				dn_Uke = (Uke as objectreference).GetDisplayName()
				n_Uke = Uke.getactorbase().getName()
				If !(dn_Uke == "")
					name_Uke = dn_Uke
				else
					If !(n_Uke == "")
						name_Uke = n_Uke
					else
						name_Uke = "$unknown"
					endIf
				endif
			endif
			If Seme == Player
				name_Seme = Seme.getactorbase().getName()
			else
				dn_Seme = (Seme as objectreference).GetDisplayName()
				n_Seme = Seme.getactorbase().getName()
				If !(dn_Seme == "")
					name_Seme = dn_Seme
				else
					If !(n_Seme == "")
						name_Seme = n_Seme
					else
						name_Seme = "$unknown"
					endIf
				endif
			endif
			; ���ʂ̎擾
			If  (Uke.getactorbase().GetSex() == Seme.getactorbase().GetSex())
				_samesex = true
				; Debug.Trace("# �U�Ǝ�͓����ł�")
			else
				_samesex = false
				; Debug.Trace("# �U�Ǝ�ِ͈��ł�")
			endIf
			; debug.trace("# SexLab Subtitles - �A�j���J�n - �X���b�hID : " + sexlabID)
		endif
	endEvent

	; �X�e�[�W���̊J�n���̏���
	event startStage(string eventName, string argString, float argNum, form sender)
		If (argString == sexlabID) && SS.SMode
			currentStage = SexLab.HookStage(argString)
			sslBaseAnimation animation = SexLab.HookAnimation(argString)
			maxStage = animation.StageCount
			string animname = animation.name
			bool isCreture = animation.IsCreature
			; debug.trace("# SexLab Subtitles - �X���b�h:" + sexlabID + "�X�e�[�W" + currentStage + "�X�^�[�g")
			; debug.trace("# �y" + animname + "�z�Đ��� - �ŏI�X�e�[�W��" + maxStage + "�A�N���[�`���[��" + isCreture)

			string currentTag
			If animation.HasTag("Handjob")
				currentTag = "Handjob"
			elseIf animation.HasTag("Footjob")
				currentTag = "Footjob"
			elseIf animation.HasTag("Boobjob")
				currentTag = "Boobjob"
			elseIf animation.HasTag("Masturbation")
				currentTag = "Masturbation"
			elseIf animation.HasTag("Fisting")
				currentTag = "Fisting"
			elseIf animation.HasTag("Cowgirl")
				currentTag = "Cowgirl"
			elseIf animation.HasTag("Foreplay")
				currentTag = "Foreplay"
			elseIf animation.HasTag("Oral")
				currentTag = "Oral"
			elseIf animation.HasTag("Anal")
				currentTag = "Anal"
			else
				currentTag = ""
			endif
			; debug.trace("# ���݂̃A�j���[�V�����̃^�O���ނ�" + currentTag)

			; �Z���t�̕\���ԍ������Z�b�g���邩�ǂ����̔���
			float now = utility.getcurrentrealtime()
			If (now - stageChangeTime) < (SS.interval * 1.2)
				; debug.trace("# �O�񂩂�" + ((now - stageChangeTime) as int) + "�b�����o���Ă��Ȃ����߃Z���t�����Z�b�g���܂���")
			else
				_temp = 0
			endIf
			stageChangeTime = now ; �����̍X�V

			; ���݂̃V�`���G�[�V������situation�ɃZ�b�g
			getSituation(animname, currentTag, IsAggressive, isCreture)

			If SSetting.isCSdisable(situation) ; ��������\���̏ꍇ
				repeatUpdate = false
				; debug.trace("# ������\�����܂���")
			else
				int ssstage = getSubtitleStageNow()
				_sset = SSetting.getCSsetBySituation(situation, ssstage)
				repeatUpdate = true
				ShowSubtitlesAuto()
			endif
		endIf
	endEvent

	; �X�e�[�W�I�����̏���
	event endStage(string eventName, string argString, float argNum, form sender)
		If (argString == sexlabID)
			repeatUpdate = false
		endif
	endEvent
	;SexLab�A�j���S�̊������̏���
	event endAnim(string eventName, string argString, float argNum, form sender)
		If (argString == sexlabID)
			repeatUpdate = false
			_temp = 0
			sexlabID = ""
			situation = 12
			Uke = none
			Seme = none
			name_Uke = ""
			name_Seme = ""
			isRunningSubtitle = false
			_samesex = false
		endif
	endEvent

;/======================================================
	�����\���֘A�̏���
/;

; �A�j�����A�^�O������V�`���G�[�V�����ԍ�������o���Asituation�v���p�e�B�ɃZ�b�g����
Function getSituation(string animname, string tagname, bool aggressivesex, bool creaturesex)
	If creaturesex
		situation = 0
	elseIf animname == "Arrok 69"
		situation = 1
	elseIf tagname == "Handjob"
		situation = 2
	elseIf tagname == "Footjob"
		situation = 3
	elseIf tagname == "Boobjob"
		situation = 4
	elseIf tagname == "Masturbation"
		situation = 5
	elseIf tagname == "Fisting"
		situation = 6
	elseIf tagname == "Cowgirl"
		situation = 7
	elseIf tagname == "Foreplay"
		situation = 8
	elseIf (tagname == "Oral") && (_samesex)
		If aggressivesex
			situation = 15
		else
			situation = 16
		endIf
	elseIf tagname == "Oral"
		If aggressivesex
			situation = 9
		else
			situation = 10
		endIf
	elseIf (tagname == "Anal") && (_samesex)
		If aggressivesex
			situation = 17
		else
			situation = 18
		endIf
	elseIf tagname == "Anal"
		If aggressivesex
			situation = 13
		else
			situation = 14
		endIf
	elseIf (_samesex)
		If aggressivesex
			situation = 19
		else
			situation = 20
		endif
	else
		If aggressivesex
			situation = 11
		else
			situation = 12
		endif
	endif
EndFunction

; ���݂̃X�e�[�W����K�p���鎚���̃X�e�[�W��Ԃ��i5�X�e�[�W�ȏ゠��A�j���[�V�����Ή��j
int Function getSubtitleStageNow()
	If currentStage == 1
		return 1
	elseif currentStage == 2
		return 2
	elseif currentStage == maxStage
		return 5
	elseif currentStage == (maxStage - 1)
		return 4
	else
		return 3
	endif
EndFunction

; �����\���Ɏg���֐�
Function ShowSuper(String n_uke, String n_seme, String asMessage)
	SS.ShowSubtitleSuper(n_uke, n_seme, asMessage)
EndFunction

; �����Z�b�g�̕\��
Function ShowSubtitlesAuto()
	ShowSubtitles(_sset)
EndFunction

Function ShowSubtitles(string[] subtitleSet)
	; debug.trace("# ShowSubtitles�����J�n")
	int len = subtitleSet.length

	If repeatRandom ; �����_�����[�h
		If len == 1
			ShowSuper(name_Uke, name_Seme, subtitleSet[0])
			_temp_r = 0
			If repeatUpdate
				registerforsingleupdate(SS.interval)
			endIf
		else
			int choice = getRandomDifferent(0, (len - 1), _temp_r)
			; Debug.Trace("# �����_�����[�h�F�O���" +_temp_r + " ���ʂ�" + choice)
			If (choice == 0) && (subtitleSet.length > 0)
				ShowSuper(name_Uke, name_Seme, subtitleSet[0])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 1) && (subtitleSet.length > 1)
				ShowSuper(name_Uke, name_Seme, subtitleSet[1])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 2) && (subtitleSet.length > 2)
				ShowSuper(name_Uke, name_Seme, subtitleSet[2])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 3) && (subtitleSet.length > 3)
				ShowSuper(name_Uke, name_Seme, subtitleSet[3])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 4) && (subtitleSet.length > 4)
				ShowSuper(name_Uke, name_Seme, subtitleSet[4])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 5) && (subtitleSet.length > 5)
				ShowSuper(name_Uke, name_Seme, subtitleSet[5])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 6) && (subtitleSet.length > 6)
				ShowSuper(name_Uke, name_Seme, subtitleSet[6])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 7) && (subtitleSet.length > 7)
				ShowSuper(name_Uke, name_Seme, subtitleSet[7])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 8) && (subtitleSet.length > 8)
				ShowSuper(name_Uke, name_Seme, subtitleSet[8])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 9) && (subtitleSet.length > 9)
				ShowSuper(name_Uke, name_Seme, subtitleSet[9])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 10) && (subtitleSet.length > 10)
				ShowSuper(name_Uke, name_Seme, subtitleSet[10])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 11) && (subtitleSet.length > 11)
				ShowSuper(name_Uke, name_Seme, subtitleSet[11])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 12) && (subtitleSet.length > 12)
				ShowSuper(name_Uke, name_Seme, subtitleSet[12])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 13) && (subtitleSet.length > 13)
				ShowSuper(name_Uke, name_Seme, subtitleSet[13])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 14) && (subtitleSet.length > 14)
				ShowSuper(name_Uke, name_Seme, subtitleSet[14])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 15) && (subtitleSet.length > 15)
				ShowSuper(name_Uke, name_Seme, subtitleSet[15])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 16) && (subtitleSet.length > 16)
				ShowSuper(name_Uke, name_Seme, subtitleSet[16])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 17) && (subtitleSet.length > 17)
				ShowSuper(name_Uke, name_Seme, subtitleSet[17])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 18) && (subtitleSet.length > 18)
				ShowSuper(name_Uke, name_Seme, subtitleSet[18])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			elseIf (choice == 19) && (subtitleSet.length > 19)
				ShowSuper(name_Uke, name_Seme, subtitleSet[19])
				_temp_r = choice
				If repeatUpdate
					registerforsingleupdate(SS.interval)
				endIf
			else	 ; �����_���̌��ʂƎ����̌�����v���Ȃ��ꍇ
				If repeatUpdate
					registerforsingleupdate(0.1)
				endIf
			endIf
		endif
	else ; ���s�[�g���[�h
		; debug.trace("# ���s�[�g���[�h �O��_temp��" + _temp)
		If temp >= subtitleSet.length ; �\���񐔂��Z���t�����z������0�ɖ߂�
			_temp = 0
		endif
		If (_temp == 0)
			ShowSuper(name_Uke, name_Seme, subtitleSet[0])
		elseIf (_temp == 1)
			ShowSuper(name_Uke, name_Seme, subtitleSet[1])
		elseIf (_temp == 2)
			ShowSuper(name_Uke, name_Seme, subtitleSet[2])
		elseIf (_temp == 3)
			ShowSuper(name_Uke, name_Seme, subtitleSet[3])
		elseIf (_temp == 4)
			ShowSuper(name_Uke, name_Seme, subtitleSet[4])
		elseIf (_temp == 5)
			ShowSuper(name_Uke, name_Seme, subtitleSet[5])
		elseIf (_temp == 6)
			ShowSuper(name_Uke, name_Seme, subtitleSet[6])
		elseIf (_temp == 7)
			ShowSuper(name_Uke, name_Seme, subtitleSet[7])
		elseIf (_temp == 8)
			ShowSuper(name_Uke, name_Seme, subtitleSet[8])
		elseIf (_temp == 9)
			ShowSuper(name_Uke, name_Seme, subtitleSet[9])
		elseIf (_temp == 10)
			ShowSuper(name_Uke, name_Seme, subtitleSet[10])
		elseIf (_temp == 11)
			ShowSuper(name_Uke, name_Seme, subtitleSet[11])
		elseIf (_temp == 12)
			ShowSuper(name_Uke, name_Seme, subtitleSet[12])
		elseIf (_temp == 13)
			ShowSuper(name_Uke, name_Seme, subtitleSet[13])
		elseIf (_temp == 14)
			ShowSuper(name_Uke, name_Seme, subtitleSet[14])
		elseIf (_temp == 15)
			ShowSuper(name_Uke, name_Seme, subtitleSet[15])
		elseIf (_temp == 16)
			ShowSuper(name_Uke, name_Seme, subtitleSet[16])
		elseIf (_temp == 17)
			ShowSuper(name_Uke, name_Seme, subtitleSet[17])
		elseIf (_temp == 18)
			ShowSuper(name_Uke, name_Seme, subtitleSet[18])
		elseIf (_temp == 19)
			ShowSuper(name_Uke, name_Seme, subtitleSet[19])
		endIf
		_temp += 1
		If repeatUpdate
			registerforsingleupdate(SS.interval)
		endIf
	endif
EndFunction

Event OnUpdate()
	If repeatUpdate
		ShowSubtitles(_sset)
	endif
EndEvent

; �����_���œ��������񑱂��ďo���Ȃ��悤�ɂ���
int Function getRandomDifferent(int min, int max, int before)
	int n = Utility.randomInt(min, max)
	while ( n == before)
		n = Utility.randomInt(min, max)
	endwhile
	return n
EndFunction
