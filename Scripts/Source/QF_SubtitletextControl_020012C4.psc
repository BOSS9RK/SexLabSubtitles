;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname QF_SubtitletextControl_020012C4 Extends Quest Hidden

;BEGIN ALIAS PROPERTY SexLabSubtitlesPlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SexLabSubtitlesPlayer Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;�J�n0
(Alias_SexLabSubtitlesPlayer as secondSubtitlePlayerAlias).OnPlayerLoadGame()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE secondSubtitleText
Quest __temp = self as Quest
secondSubtitleText kmyQuest = __temp as secondSubtitleText
;END AUTOCAST
;BEGIN CODE
;�I��100
kmyQuest.UnregisterSubtitles()
debug.trace("# SexLab Subtitles Control - �ėp�����R���g���[���N�G�X�g���I�����܂���")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
