﻿/* Free to use, Free for life.
	Made by panex0845 
*/

;@Ahk2Exe-SetName AzurLane Helper
;@Ahk2Exe-SetDescription AzurLane Helper
;@Ahk2Exe-SetVersion 1.0.0.1
;@Ahk2Exe-SetMainIcon img\01.ico

if not A_IsAdmin { ;強制用管理員開啟
Run *RunAs "%A_ScriptFullPath%"
Exitapp
}

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent
#SingleInstance, force
Coordmode, pixel, window
Coordmode, mouse, window
DetectHiddenWindows, On
DetectHiddenText, On
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_WorkingDir%  ; Ensures a consistent starting directory.
SetControlDelay, -1
SetBatchLines, 1000ms
SetTitleMatchMode, 3
Menu, Tray, NoStandard
Menu, tray, add, &顯示介面, Showsub
Menu, tray, add,  , 
Menu, Tray, Default, &顯示介面
Menu, tray, add, 結束, Exitsub
Menu, Tray, Icon , img\01.ico,,, 1
Gui, font, s11 Q0, 新細明體

RegRead, ldplayer, HKEY_CURRENT_USER, Software\Changzhi\dnplayer-tw, InstallDir
if (ldplayer="") {
	Msgbox, 未偵測到雷電模擬器已被安裝，請嘗試重新安裝。
	Exitapp
}
Global ldplayer
Gui Add, Text,  x15 y20 w100 h20 , 模擬器標題：
IniRead, title, settings.ini, emulator, title, 
if (title="") or (title="ERROR") {
    InputBox, title, 設定精靈, `n`n　　　　　　　請輸入模擬器標題,, 400, 200,,,,, 雷電模擬器
    if ErrorLevel {
        Exitapp
    }
    else if  (title="") {
          Msgbox, 16, 設定精靈, 未輸入任何資訊。
          reload
    }
    else {
		InputBox, emulatoradb, 設定精靈, `n`n　　　　　　　請輸入模擬器編號,, 400, 200,,,,, 0
		if (emulatoradb>15 or emulatoradb<0) {
			msgbox, 請輸入介於0-15的數字
			exitapp
		}
		else {
			Iniwrite, %emulatoradb%, settings.ini, emulator, emulatoradb
			Iniwrite, %title%, settings.ini, emulator, title
			reload
		}
    }
}
Run, %comspec% /c powercfg /change /monitor-timeout-ac 0,, Hide ;關閉螢幕省電模式
iniread, SetGuiBGcolor, settings.ini, OtherSub, SetGuiBGcolor, 0
IniRead, SetGuiBGcolor2, settings.ini, OtherSub, SetGuiBGcolor2, FFCCCC
if (SetGuiBGcolor)
{
	Gui, Color, %SetGuiBGcolor2%
}
Gui Add, Edit, x110 y17 w100 h21 vtitle ginisettings , %title%
Gui Add, Text,  x220 y20 w80 h20 , 代號：
IniRead, emulatoradb, settings.ini, emulator, emulatoradb, 0
Gui, Add, DropDownList, x270 y15 w40 h300 vemulatoradb ginisettings Choose%emulatoradb%, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|0||
GuicontrolGet, emulatoradb
Gui Add, Text,  x330 y20 w80 h20 , 容許誤差：
IniRead, AllowanceValue, settings.ini, emulator, AllowanceValue, 2000
Gui Add, Edit, x410 y17 w50 h21 vAllowanceValue ginisettings  readonly Number Limit4, %AllowanceValue%
Gui, Add, Button, x20 y470 w100 h20 gstart vstart , 開始
Gui, Add, Button, x140 y470 w100 h20 greload vreload, 停止
Gui, Add, Button, x260 y470 w100 h20 gReAnchorSub vReAnchorSub, 再次出擊
Gui, Add, Button, x480 y470 w100 h20 gReSizeWindowSub vReSizeWindowSub, 調整視窗
Gui, Add, button, x780 y470 w100 h20 gexitsub, 結束 
Gui, Add, text, x480 y20 w400 h20 vstarttext, 
Gui, Add, text, x480 y50 w150 h20 vAnchorTimesText, 出擊次數：0 次
;~ Gui, Add, text, x650 y50 w150 h20 vAnchorFailedText, 旗艦大破：0 次
Gui, Add, ListBox, x480 y74 w400 h393 ReadOnly vListBoxLog
;~ Gui, Add, Picture, x480 y450 0x4000000 ,img\WH.png

Gui,Add,Tab, x10 y50 w460 h405 gTabFunc, 出　擊|出擊２|學　院|後　宅|任　務|其　他|
;///////////////////     GUI Right Side  Start  ///////////////////

Gui, Tab, 出　擊
Tab1_Y := 90
iniread, AnchorSub, settings.ini, Battle, AnchorSub
Gui, Add, CheckBox, x30 y%Tab1_Y% w150 h20 gAnchorsettings vAnchorSub checked%AnchorSub% +c4400FF, 啟動自動出擊
Tab1_Y += 30
Gui, Add, text, x30 y%Tab1_Y% w80 h20  , 選擇地圖：
Tab1_Y -= 5
iniread, AnchorMode, settings.ini, Battle, AnchorMode, 普通
if AnchorMode=普通
	Gui, Add, DropDownList, x110 y%Tab1_Y% w60 h100 vAnchorMode gAnchorsettings, 普通||困難|停用|
else if AnchorMode=困難
	Gui, Add, DropDownList, x110 y%Tab1_Y% w60 h100 vAnchorMode gAnchorsettings, 普通|困難||停用|
else if AnchorMode=停用
	Gui, Add, DropDownList, x110 y%Tab1_Y% w60 h100 vAnchorMode gAnchorsettings, 普通|困難|停用||

iniread, AnchorChapter, settings.ini, Battle, AnchorChapter
iniread, AnchorChapter2, settings.ini, Battle, AnchorChapter2
Tab1_Y += 5
Gui, Add, text, x180 y%Tab1_Y% w20 h20  , 第
Tab1_Y -= 5
if AnchorChapter=紅染1
	Gui, Add, DropDownList, x200 y%Tab1_Y% w60 h300 vAnchorChapter gAnchorsettings Choose%AnchorChapter%, 1|2|3|4|5|6|7|紅染1||紅染2|S.P.|
else if AnchorChapter=紅染2
	Gui, Add, DropDownList, x200 y%Tab1_Y% w60 h300 vAnchorChapter gAnchorsettings Choose%AnchorChapter%, 1|2|3|4|5|6|7|紅染1|紅染2||S.P.|
else if AnchorChapter=S.P.
	Gui, Add, DropDownList, x200 y%Tab1_Y% w60 h300 vAnchorChapter gAnchorsettings Choose%AnchorChapter%, 1|2|3|4|5|6|7|紅染1|紅染2|S.P.||
else
	Gui, Add, DropDownList, x200 y%Tab1_Y% w60 h300 vAnchorChapter gAnchorsettings Choose%AnchorChapter%, 1||2|3|4|5|6|7|紅染1|紅染2|S.P.|
Tab1_Y += 5
Gui, Add, text, x270 y%Tab1_Y% w40 h20  , 章 第
Gui, Add, DropDownList, x310 y115 w40 h100 vAnchorChapter2 gAnchorsettings Choose%AnchorChapter2% , 1||2|3|4|
Gui, Add, text, x360 y%Tab1_Y% w20 h20  , 節


Tab1_Y += 35
Gui, Add, text, x30 y%Tab1_Y% w80 h20  , 出擊艦隊：
Tab1_Y -= 5
iniread, ChooseParty1, settings.ini, Battle, ChooseParty1, 第一艦隊
if ChooseParty1=第一艦隊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊||第二艦隊|第三艦隊|第四艦隊|第五艦隊|第六艦隊|
else if ChooseParty1=第二艦隊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊||第三艦隊|第四艦隊|第五艦隊|第六艦隊|
else if ChooseParty1=第三艦隊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊||第四艦隊|第五艦隊|第六艦隊|
else if ChooseParty1=第四艦隊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊||第五艦隊|第六艦隊|
else if ChooseParty1=第五艦隊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊||第六艦隊|
else if ChooseParty1=第六艦隊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊|第六艦隊||
Tab1_Y += 5
Gui, Add, text, x210 y%Tab1_Y% w15 h20  , 、
Tab1_Y -= 5
iniread, ChooseParty2, settings.ini, Battle, ChooseParty2, 不使用
if ChooseParty2=不使用
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊|第六艦隊|不使用||
else if ChooseParty2=第一艦隊
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊||第二艦隊|第三艦隊|第四艦隊|第五艦隊|第六艦隊|不使用|
else if ChooseParty2=第二艦隊
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊||第三艦隊|第四艦隊|第五艦隊|第六艦隊|不使用|
else if ChooseParty2=第三艦隊
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊||第四艦隊|第五艦隊|第六艦隊|不使用|
else if ChooseParty2=第四艦隊
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊||第五艦隊|第六艦隊|不使用|
else if ChooseParty2=第五艦隊
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊||第六艦隊|不使用|
else if ChooseParty2=第六艦隊
	Gui, Add, DropDownList, x230 y%Tab1_Y% w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊|第六艦隊||不使用|

Tab1_Y += 32
iniread, SwitchPartyAtFirstTime, settings.ini, Battle, SwitchPartyAtFirstTime
Gui, Add, CheckBox, x110 y%Tab1_Y% w190 h20 gAnchorsettings vSwitchPartyAtFirstTime checked%SwitchPartyAtFirstTime% , 進入地圖時交換隊伍順序
iniread, WeekMode, settings.ini, Battle, WeekMode
Gui, Add, CheckBox, x310 y%Tab1_Y% w80 h20 gAnchorsettings vWeekMode checked%WeekMode% , 周回模式

Tab1_Y += 33
Gui, Add, text, x30 y%Tab1_Y% w80 h20  , 偵查目標：
Tab1_Y -= 3 ;  Y = 207
iniread, Ship_Target1, settings.ini, Battle, Ship_Target1, 1
iniread, Ship_Target2, settings.ini, Battle, Ship_Target2, 1
iniread, Ship_Target3, settings.ini, Battle, Ship_Target3, 1
iniread, Ship_Target4, settings.ini, Battle, Ship_Target4, 1
iniread, Item_Bullet, settings.ini, Battle, Item_Bullet, 1
iniread, Item_Quest, settings.ini, Battle, Item_Quest, 1
iniread, Plane_Target1, settings.ini, Battle, Plane_Target1, 0
Gui, Add, CheckBox, x110 y%Tab1_Y% w80 h20 gAnchorsettings vShip_Target1 checked%Ship_Target1% , 航空艦隊
Gui, Add, CheckBox, x195 y%Tab1_Y% w80 h20 gAnchorsettings vShip_Target2 checked%Ship_Target2% , 運輸艦隊
Gui, Add, CheckBox, x280 y%Tab1_Y% w80 h20 gAnchorsettings vShip_Target3 checked%Ship_Target3% , 主力艦隊
Gui, Add, CheckBox, x365 y%Tab1_Y% w80 h20 gAnchorsettings vShip_Target4 checked%Ship_Target4% , 偵查艦隊
Tab1_Y += 25
Gui, Add, CheckBox, x110 y%Tab1_Y% w80 h20 gAnchorsettings vItem_Bullet checked%Item_Bullet% , 子彈補給
Gui, Add, CheckBox, x195 y%Tab1_Y% w80 h20 gAnchorsettings vItem_Quest checked%Item_Quest% , 神秘物資
Gui, Add, CheckBox, x280 y%Tab1_Y% w80 h20 gAnchorsettings vPlane_Target1 checked%Plane_Target1% , 航空器

Tab1_Y += 33
Gui, Add, text, x30 y%Tab1_Y% w80 h20  , 受到伏擊：
iniread, Assault, settings.ini, Battle, Assault, 規避
Tab1_Y -= 5
if Assault=規避
	Gui, Add, DropDownList, x110 y%Tab1_Y% w60 h100 vAssault gAnchorsettings, 規避||迎擊|
else if Assault=迎擊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w60 h100 vAssault gAnchorsettings, 規避|迎擊||

Tab1_Y += 5
Gui, Add, text, x185 y%Tab1_Y% w80 h20  , 自律模式：
Tab1_Y -= 5
iniread, Autobattle, settings.ini, Battle, Autobattle, 自動
if Autobattle=自動
	Gui, Add, DropDownList, x265 y%Tab1_Y% w80 h100 vAutobattle gAnchorsettings, 自動||半自動|關閉|
else if Autobattle=半自動
	Gui, Add, DropDownList, x265 y%Tab1_Y% w80 h100 vAutobattle gAnchorsettings, 自動|半自動||關閉|
else if Autobattle=關閉
	Gui, Add, DropDownList, x265 y%Tab1_Y% w80 h100 vAutobattle gAnchorsettings, 自動|半自動|關閉||

Tab1_Y += 35
Gui, Add, text, x30 y%Tab1_Y% w80 h20  , 遇到BOSS：
Tab1_Y -= 5
iniread, BossAction, settings.ini, Battle, BossAction, 隨緣攻擊－當前隊伍
if BossAction=隨緣攻擊－當前隊伍
	Gui, Add, DropDownList, x110 y%Tab1_Y% w150 h150 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍||隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊|撤退|
else if BossAction=隨緣攻擊－切換隊伍
	Gui, Add, DropDownList, x110 y%Tab1_Y% w150 h150 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍||優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊|撤退|
else if BossAction=優先攻擊－當前隊伍
	Gui, Add, DropDownList, x110 y%Tab1_Y% w150 h150 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍||優先攻擊－切換隊伍|能不攻擊就不攻擊|撤退|
else if BossAction=優先攻擊－切換隊伍
	Gui, Add, DropDownList, x110 y%Tab1_Y% w150 h150 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍||能不攻擊就不攻擊|撤退|
else if BossAction=能不攻擊就不攻擊
	Gui, Add, DropDownList, x110 y%Tab1_Y% w150 h150 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊||撤退|
else if BossAction=撤退
	Gui, Add, DropDownList, x110 y%Tab1_Y% w150 h150 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊|撤退||

Tab1_Y += 35
Gui, Add, text, x30 y%Tab1_Y% w140 h20  , 心情低落：
Tab1_Y -= 5
iniread, mood, settings.ini, Battle, mood, 強制出戰
if mood=強制出戰
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vmood gAnchorsettings, 強制出戰||更換隊伍|休息1小時|休息2小時|休息3小時|休息5小時|
else if mood=更換隊伍
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍||休息1小時|休息2小時|休息3小時|休息5小時|
else if mood=休息1小時
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時||休息2小時|休息3小時|休息5小時|
else if mood=休息2小時
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時|休息2小時||休息3小時|休息5小時|
else if mood=休息3小時
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時|休息2小時|休息3小時||休息5小時|
else if mood=休息5小時
	Gui, Add, DropDownList, x110 y%Tab1_Y% w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時|休息2小時|休息3小時|休息5小時||

Tab1_Y += 35
iniread, Use_FixKit, settings.ini, Battle, Use_FixKit
iniread, AlignCenter, settings.ini, Battle, AlignCenter
Gui, Add, CheckBox, x30 y%Tab1_Y% w120 h20 gAnchorsettings vUse_FixKit checked%Use_FixKit% , 使用維修工具
Gui, Add, CheckBox, x160 y%Tab1_Y% w160 h20 gAnchorsettings vAlignCenter checked%AlignCenter% , 偵查時嘗試置中地圖

Tab1_Y += 28
iniread, BattleTimes, settings.ini, Battle, BattleTimes, 0
Gui, Add, CheckBox, x30 y%Tab1_Y% w50 h20 gAnchorsettings vBattleTimes checked%BattleTimes% , 出擊
IniRead, BattleTimes2, settings.ini, Battle, BattleTimes2, 20
Gui Add, Edit, x82 y%Tab1_Y% w40 h20 vBattleTimes2 gAnchorsettings Number Limit4, %BattleTimes2%
Tab1_Y += 3
Gui Add, Text,  x128 y%Tab1_Y% w90 h20 , 輪，強制休息
Tab1_Y -= 3
IniRead, TimetoBattle, settings.ini, Battle, TimetoBattle, 0
Gui, Add, CheckBox, x230 y%Tab1_Y% w30 h20 gAnchorsettings vTimetoBattle checked%TimetoBattle% , 於 
IniRead, TimetoBattle1, settings.ini, Battle, TimetoBattle1, 1302
IniRead, TimetoBattle2, settings.ini, Battle, TimetoBattle2, 0102
Gui Add, Edit, x270 y%Tab1_Y% w40 h20 vTimetoBattle1 gAnchorsettings Number Limit4, %TimetoBattle1% ;指定的重新出擊時間 (24小時制)
Gui Add, Edit, x320 y%Tab1_Y% w40 h20 vTimetoBattle2 gAnchorsettings Number Limit4, %TimetoBattle2% ;指定的重新出擊時間(24小時制)
Tab1_Y += 3
Gui Add, Text,  x370 y%Tab1_Y% w90 h20 , 時，重新出擊
Tab1_Y += 25
iniread, StopBattleTime, settings.ini, Battle, StopBattleTime, 0
Gui, Add, CheckBox, x30 y%Tab1_Y% w70 h20 vStopBattleTime gAnchorsettings checked%StopBattleTime% , 每出擊
Tab1_Y -= 2
iniread, StopBattleTime2, settings.ini, Battle, StopBattleTime2, 5
Gui, Add, DropDownList, x100 y%Tab1_Y% w40 h300 vStopBattleTime2 gAnchorsettings Choose%StopBattleTime2% , 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|
Tab1_Y += 5
Gui Add, Text,  x150 y%Tab1_Y% w90 h20 , 輪，休息
Tab1_Y -= 5
iniread, StopBattleTime3, settings.ini, Battle, StopBattleTime3, 10
Tab1_Y += 3
Gui, Add, Edit, x220 y%Tab1_Y% w40 h20 vStopBattleTime3 gAnchorsettings Number Limit4, %StopBattleTime3%
Tab1_Y += 3
Gui Add, Text,  x270 y%Tab1_Y% w90 h20 , 分鐘
;~ Gui, Add, CheckBox, x30 y%Tab1_Y% w60 h20  checked%BattleTimes% , TEST

Gui, Tab, 出擊２
Tab2_Y := 90
;~ Gui, Add, text, x30 y%Tab2_Y% w360 h20  +cFF0088, 本頁為出擊頁面的詳細設定，需勾選自動出擊方有效果
;~ Gui, Add, GroupBox, x13 y120 w455 h170, ` 　　　　　　　　　　　　　
Gui, Add, text, x30 y%Tab2_Y% w150 h20, 船䲧已滿：
Tab2_Y-=3
iniread, Shipsfull, settings.ini, Battle, Shipsfull, 停止出擊
if Shipsfull=整理船䲧
	Gui, Add, DropDownList, x110 y%Tab2_Y% w100 h100 vShipsfull gAnchorsettings, 整理船䲧||停止出擊|關閉遊戲|
else if Shipsfull=停止出擊
	Gui, Add, DropDownList, x110 y%Tab2_Y% w100 h100 vShipsfull gAnchorsettings, 整理船䲧|停止出擊||關閉遊戲|
else if Shipsfull=關閉遊戲
	Gui, Add, DropDownList, x110 y%Tab2_Y% w100 h100 vShipsfull gAnchorsettings, 整理船䲧|停止出擊|關閉遊戲||
else
	Gui, Add, DropDownList, x110 y%Tab2_Y% w100 h100 vShipsfull gAnchorsettings, 整理船䲧||停止出擊|關閉遊戲|
Tab2_Y+=3
Gui, Add, text, x220 y%Tab2_Y% w180 h20, 如整理，要退役的角色：
iniread, IndexAll, settings.ini, Battle, IndexAll, 1 ;全部
iniread, Index1, settings.ini, Battle, Index1 ;前排先鋒
iniread, Index2, settings.ini, Battle, Index2 ;後排主力
iniread, Index3, settings.ini, Battle, Index3 ;驅逐
iniread, Index4, settings.ini, Battle, Index4 ;輕巡
iniread, Index5, settings.ini, Battle, Index5 ;重巡
iniread, Index6, settings.ini, Battle, Index6 ;戰列
iniread, Index7, settings.ini, Battle, Index7 ;航母
iniread, Index8, settings.ini, Battle, Index8 ;維修
iniread, Index9, settings.ini, Battle, Index9 ;其他
Tab2_Y+=30
Gui, Add, text, x30 y%Tab2_Y% w50 h20  , 索　引
Tab2_Y-=3
Gui, Add, CheckBox, x80 y%Tab2_Y% w50 h20 gAnchorsettings vIndexAll checked%IndexAll% , 全部
Guicontrol, disable, IndexAll
Gui, Add, CheckBox, x130 y%Tab2_Y% w80 h20 gAnchorsettings vIndex1 checked%Index1% , 前排先鋒
Gui, Add, CheckBox, x210 y%Tab2_Y% w80 h20 gAnchorsettings vIndex2 checked%Index2% , 後排主力
Gui, Add, CheckBox, x290 y%Tab2_Y% w50 h20 gAnchorsettings vIndex3 checked%Index3% , 驅逐
Gui, Add, CheckBox, x340 y%Tab2_Y% w50 h20 gAnchorsettings vIndex4 checked%Index4% , 輕巡
Gui, Add, CheckBox, x390 y%Tab2_Y% w50 h20 gAnchorsettings vIndex5 checked%Index5% , 重巡
Tab2_Y+=30
Gui, Add, CheckBox, x80 y%Tab2_Y% w50 h20 gAnchorsettings vIndex6 checked%Index6% , 戰列
Gui, Add, CheckBox, x130 y%Tab2_Y% w50 h20 gAnchorsettings vIndex7 checked%Index7% , 航母
Gui, Add, CheckBox, x180 y%Tab2_Y% w50 h20 gAnchorsettings vIndex8 checked%Index8% , 維修
Gui, Add, CheckBox, x230 y%Tab2_Y% w50 h20 gAnchorsettings vIndex9 checked%Index9% , 其他

iniread, CampAll, settings.ini, Battle, CampAll, 1 ;全部
iniread, Camp1, settings.ini, Battle, Camp1 ;白鷹
iniread, Camp2, settings.ini, Battle, Camp2 ;皇家
iniread, Camp3, settings.ini, Battle, Camp3 ;重櫻
iniread, Camp4, settings.ini, Battle, Camp4 ;鐵血
iniread, Camp5, settings.ini, Battle, Camp5 ;東煌
iniread, Camp6, settings.ini, Battle, Camp6 ;北方聯合
iniread, Camp7, settings.ini, Battle, Camp7 ;其他
Tab2_Y+=33
Gui, Add, text, x30 y%Tab2_Y% w50 h20  , 陣　營
Tab2_Y-=3
Gui, Add, CheckBox, x80 y%Tab2_Y% w50 h20 gAnchorsettings vCampAll checked%CampAll% , 全部
Guicontrol, disable, CampAll
Gui, Add, CheckBox, x130 y%Tab2_Y% w50 h20 gAnchorsettings vCamp1 checked%Camp1% , 白鷹
Gui, Add, CheckBox, x180 y%Tab2_Y% w50 h20 gAnchorsettings vCamp2 checked%Camp2% , 皇家
Gui, Add, CheckBox, x230 y%Tab2_Y% w50 h20 gAnchorsettings vCamp3 checked%Camp3% , 重櫻
Gui, Add, CheckBox, x280 y%Tab2_Y% w50 h20 gAnchorsettings vCamp4 checked%Camp4% , 鐵血
Gui, Add, CheckBox, x330 y%Tab2_Y% w50 h20 gAnchorsettings vCamp5 checked%Camp5% , 東煌
Tab2_Y+=30
Gui, Add, CheckBox, x80 y%Tab2_Y% w80 h20 gAnchorsettings vCamp6 checked%Camp6% , 北方聯合
Gui, Add, CheckBox, x160 y%Tab2_Y% w50 h20 gAnchorsettings vCamp7 checked%Camp7% , 其他

iniread, RarityAll, settings.ini, Battle, RarityAll, 1 ;全部
iniread, Rarity1, settings.ini, Battle, Rarity1, 1 ;普通
iniread, Rarity2, settings.ini, Battle, Rarity2, 1 ;稀有
iniread, Rarity3, settings.ini, Battle, Rarity3 ;精銳
iniread, Rarity4, settings.ini, Battle, Rarity4 ;超稀有
Tab2_Y+=33
Gui, Add, text, x30 y%Tab2_Y% w75 h20  , 稀有度：
Tab2_Y-=3
Gui, Add, CheckBox, x80 y%Tab2_Y% w50 h20 gAnchorsettings vRarityAll checked%RarityAll% , 全部
Guicontrol, disable, RarityAll
Gui, Add, CheckBox, x130 y%Tab2_Y% w50 h20 gAnchorsettings vRarity1 checked%Rarity1% , 普通
Gui, Add, CheckBox, x180 y%Tab2_Y% w50 h20 gAnchorsettings vRarity2 checked%Rarity2% , 稀有
Gui, Add, CheckBox, x230 y%Tab2_Y% w50 h20 gAnchorsettings vRarity3 checked%Rarity3% , 精銳
Gui, Add, CheckBox, x280 y%Tab2_Y% w75 h20 gAnchorsettings vRarity4 checked%Rarity4% , 超稀有

iniread, DailyGoalSub, settings.ini, Battle, DailyGoalSub
;~ Gui, Add, GroupBox, x11 y280 w457 h75, ` 
Tab2_Y+=33 ;270
Gui, Add, CheckBox, x30 y%Tab2_Y% w200 h20 gAnchorsettings vDailyGoalSub checked%DailyGoalSub% , 自動執行每日任務：指派：
Tab2_Y-=2 ;268
iniread, DailyParty, settings.ini, Battle, DailyParty, 第一艦隊
if DailyParty=第一艦隊
	Gui, Add, DropDownList, x240 y%Tab2_Y% w90 h150 vDailyParty gAnchorsettings, 第一艦隊||第二艦隊|第三艦隊|第四艦隊|第五艦隊|
else if DailyParty=第二艦隊
	Gui, Add, DropDownList, x240 y%Tab2_Y% w90 h150 vDailyParty gAnchorsettings, 第一艦隊|第二艦隊||第三艦隊|第四艦隊|第五艦隊|
else if DailyParty=第三艦隊
	Gui, Add, DropDownList, x240 y%Tab2_Y% w90 h150 vDailyParty gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊||第四艦隊|第五艦隊|
else if DailyParty=第四艦隊
	Gui, Add, DropDownList, x240 y%Tab2_Y% w90 h150 vDailyParty gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊||第五艦隊|
else if DailyParty=第五艦隊
	Gui, Add, DropDownList, x240 y%Tab2_Y% w90 h150 vDailyParty gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊||
iniread, DailyGoalRed, settings.ini, Battle, DailyGoalRed, 1
iniread, DailyGoalRedAction, settings.ini, Battle, DailyGoalRedAction
Tab2_Y+=28
Gui, Add, CheckBox, x50 y%Tab2_Y% w110 h20 gAnchorsettings vDailyGoalRed checked%DailyGoalRed% , 斬首行動：第
Tab2_Y-=2
Gui, Add, DropDownList, x160 y%Tab2_Y% w40 h100 vDailyGoalRedAction gAnchorsettings Choose%DailyGoalRedAction% , 1||2|3|4|
Tab2_Y+=5
Gui, Add, text, x210 y%Tab2_Y% w40 h20  , 關。
iniread, DailyGoalGreen, settings.ini, Battle, DailyGoalGreen, 1
iniread, DailyGoalGreenAction, settings.ini, Battle, DailyGoalGreenAction
Tab2_Y+=23
Gui, Add, CheckBox, x50 y%Tab2_Y% w110 h20 gAnchorsettings vDailyGoalGreen checked%DailyGoalGreen% , 海域突進：第
Tab2_Y-=2
Gui, Add, DropDownList, x160 y%Tab2_Y% w40 h100 vDailyGoalGreenAction gAnchorsettings Choose%DailyGoalGreenAction% , 1||2|3|4|
Tab2_Y+=5
Gui, Add, text, x210 y%Tab2_Y% w40 h20  , 關。
iniread, DailyGoalBlue, settings.ini, Battle, DailyGoalBlue, 1
iniread, DailyGoalBlueAction, settings.ini, Battle, DailyGoalBlueAction
Tab2_Y+=23
Gui, Add, CheckBox, x50 y%Tab2_Y% w110 h20 gAnchorsettings vDailyGoalBlue checked%DailyGoalBlue% , 商船護衛：第
Tab2_Y-=2
Gui, Add, DropDownList, x160 y%Tab2_Y% w40 h100 vDailyGoalBlueAction gAnchorsettings Choose%DailyGoalBlueAction% , 1||2|3|4|
Tab2_Y+=5
Gui, Add, text, x210 y%Tab2_Y% w40 h20  , 關。
iniread, DailyGoalSunday, settings.ini, Battle, DailyGoalSunday
Tab2_Y-=29
Gui, Add, CheckBox, x260 y%Tab2_Y% w140 h20 gAnchorsettings vDailyGoalSunday checked%DailyGoalSunday% , 禮拜日三個都打

iniread, OperationSub, settings.ini, Battle, OperationSub
Tab2_Y+=56
Gui, Add, CheckBox, x30 y%Tab2_Y% w230 h20 gAnchorsettings vOperationSub checked%OperationSub% , 自動執行演習，選擇敵方艦隊：
Tab2_Y-=2
iniread, Operationenemy, settings.ini, Battle, Operationenemy, 隨機的
if Operationenemy=隨機的
	Gui, Add, DropDownList, x260 y%Tab2_Y% w80 h150 vOperationenemy gAnchorsettings, 隨機的||最弱的|最左邊|最右邊|
else if Operationenemy=最弱的
	Gui, Add, DropDownList, x260 y%Tab2_Y% w80 h150 vOperationenemy gAnchorsettings, 隨機的|最弱的||最左邊|最右邊|
else if Operationenemy=最左邊
	Gui, Add, DropDownList, x260 y%Tab2_Y% w80 h150 vOperationenemy gAnchorsettings, 隨機的|最弱的|最左邊||最右邊|
else if Operationenemy=最右邊
	Gui, Add, DropDownList, x260 y%Tab2_Y% w80 h150 vOperationenemy gAnchorsettings, 隨機的|最弱的|最左邊|最右邊||
else 
	Gui, Add, DropDownList, x260 y%Tab2_Y% w80 h150 vOperationenemy gAnchorsettings, 隨機的||最弱的|最左邊|最右邊|

Gui, Add, button, x355 y%Tab2_Y% w100 h24 gResetOperationSub vResetOperation, 重置演習 
iniread, Leave_Operatio, settings.ini, Battle, Leave_Operatio
Tab2_Y+=28
Gui, Add, CheckBox, x50 y%Tab2_Y% w110 h20 gAnchorsettings vLeave_Operatio checked%Leave_Operatio% , 血量過低撤退

Gui, Tab, 學　院
iniread, AcademySub, settings.ini, Academy, AcademySub
Gui, Add, CheckBox, x30 y90 w150 h20 gAcademysettings vAcademySub checked%AcademySub% +c4400FF, 啟動自動學院
iniread, AcademyOil, settings.ini, Academy, AcademyOil, 1
Gui, Add, CheckBox, x30 y120 w150 h20 gAcademysettings vAcademyOil checked%AcademyOil%, 自動採集石油
iniread, AcademyCoin, settings.ini, Academy, AcademyCoin, 1
Gui, Add, CheckBox, x30 y150 w150 h20 gAcademysettings vAcademyCoin checked%AcademyCoin%, 自動蒐集金幣
iniread, AcademyTactics, settings.ini, Academy, AcademyTactics, 1
Gui, Add, CheckBox, x30 y180 w120 h20 gAcademysettings vAcademyTactics checked%AcademyTactics%, 自動學習技能
iniread, 150expbookonly, settings.ini, Academy, 150expbookonly, 1
Gui, Add, CheckBox, x160 y180 w200 h20 gAcademysettings v150expbookonly checked%150expbookonly%, 僅使用150`%經驗的課本
iniread, AcademyShop, settings.ini, Academy, AcademyShop, 1
Gui, Add, CheckBox, x30 y210 w220 h20 gAcademysettings vAcademyShop checked%AcademyShop%, 軍火商刷新時進行購物`(金幣)
iniread, SkillBook_ATK, settings.ini, Academy, SkillBook_ATK
iniread, SkillBook_DEF, settings.ini, Academy, SkillBook_DEF
iniread, SkillBook_SUP, settings.ini, Academy, SkillBook_SUP
iniread, Cube, settings.ini, Academy, Cube
Gui, Add, CheckBox, x50 y240 w80 h20 gAcademysettings vSkillBook_ATK checked%SkillBook_ATK%, 攻擊教材
Gui, Add, CheckBox, x140 y240 w80 h20 gAcademysettings vSkillBook_DEF checked%SkillBook_DEF%, 防禦教材
Gui, Add, CheckBox, x230 y240 w80 h20 gAcademysettings vSkillBook_SUP checked%SkillBook_SUP%, 輔助教材
Gui, Add, CheckBox, x320 y240 w80 h20 gAcademysettings vCube checked%Cube%, 心智魔方

Gui, Tab, 後　宅
iniread, DormSub, settings.ini, Dorm, DormSub
Gui, Add, CheckBox, x30 y90 w150 h20 gDormsettings vDormSub checked%DormSub% +c4400FF, 啟動自動整理後宅
iniread, DormCoin, settings.ini, Dorm, DormCoin, 1
Gui, Add, CheckBox, x30 y120 w150 h20 gDormsettings vDormCoin checked%DormCoin%, 自動蒐集傢俱幣
iniread, Dormheart, settings.ini, Dorm, Dormheart, 1
Gui, Add, CheckBox, x30 y150 w150 h20 gDormsettings vDormheart checked%Dormheart%, 自動撈取海洋之心

iniread, DormFood, settings.ini, Dorm, DormFood
Gui, Add, CheckBox, x30 y180 w80 h20 gDormsettings vDormFood checked%DormFood%, 糧食低於
IniRead, DormFoodBar, settings.ini, Dorm, DormFoodBar, 80
Gui, Add, Slider, x110 y178 w100 h30 gDormsettings vDormFoodBar range10-80 +ToolTip , %DormFoodBar%
Gui, Add, Text, x215 y180 w20 h20 vDormFoodBarUpdate , %DormFoodBarUpdate% 
Gui, Add, Text, x240 y180 w100 h20 vTestbar1Percent, `%自動補給

Gui, Tab, 任　務
iniread, MissionSub, settings.ini, MissionSub, MissionSub
Gui, Add, CheckBox, x30 y90 w150 h20 gMissionsettings vMissionSub checked%MissionSub% +c4400FF, 啟動自動接收任務

Gui, Tab, 其　他
Gui, Add, button, x30 y90 w120 h20 gDebug2, 除錯
Gui, Add, button, x180 y90 w200 h20 gForumSub, Bug回報、功能建議討論區
Gui, Add, button, x180 y120 w200 h20 gDiscordSub, Discord
Gui, Add, button, x30 y120 w120 h20 gDailyGoalSub2, 執行每日任務
Gui, Add, button, x30 y150 w120 h20 gOperationSub, 執行演習
Gui, Add, button, x30 y180 w120 h20 gstartemulatorsub, 啟動模擬器
iniread, GuiHideX, settings.ini, OtherSub, GuiHideX
Gui, Add, CheckBox, x30 y210 w200 h20 gOthersettings vGuiHideX checked%GuiHideX% , 按X隱藏本視窗，而非關閉
iniread, EmulatorCrushCheck, settings.ini, OtherSub, EmulatorCrushCheck
Gui, Add, CheckBox, x30 y240 w200 h20 gOthersettings vEmulatorCrushCheck checked%EmulatorCrushCheck% , 自動檢查模擬器是否當機
iniread, AutoLogin, settings.ini, OtherSub, AutoLogin
Gui, Add, CheckBox, x30 y270 w200 h20 gOthersettings vAutoLogin checked%AutoLogin% , 斷線自動重登(Google帳號)

Gui, Add, CheckBox, x30 y300 w125 h20 gOthersettings vSetGuiBGcolor checked%SetGuiBGcolor% , 自訂背景顏色 0x
Gui Add, Edit, x155 y299 w80 h21 vSetGuiBGcolor2 gOthersettings Limit6, %SetGuiBGcolor2%

;///////////////////     GUI Right Side  End ///////////////////

IniRead, azur_x, settings.ini, Winposition, azur_x, 0
IniRead, azur_y, settings.ini, Winposition, azur_y, 0
if azur_x=
	azur_x := 0
if azur_y=
	azur_y := 0
Gui Show, w900 h500 x%azur_x% y%azur_y%, Azur Lane - %title%
Menu, Tray, Tip , Azur Lane `(%title%)
#include Gdip.dll
pToken := Gdip_Startup()　
Winget, UniqueID,, %title%
Allowance = %AllowanceValue%
Global UniqueID
Global Allowance
LogShow("啟動完畢，等待開始")
Gosub, whitealbum
Settimer, whitealbum, 10000 ;很重要!
iniread, Autostart, settings.ini, OtherSub, Autostart, 0
if (Autostart)
{
	iniwrite, 0, settings.ini, OtherSub, Autostart
	Goto, Start
}
return

Debug2:
text1 := GdiGetPixel(12, 24)
text2 := DwmGetPixel(12, 24)
text3 := GdiGetPixel(1300, 681)
text4 := DwmGetPixel(1300, 681)
text5 := GdiGetPixel(485, 21)
text6 := DwmGetPixel(485, 21)
text11 := Dwmcheckcolor(1300, 681, 16777215)
text22 := Dwmcheckcolor(12, 24, 16041247)
text33 := Dwmcheckcolor(1, 35, 2633790)
WinGet, UniqueID, ,Azur Lane - %title%
Global UniqueID 
gui, Color, FF0000
sleep 100
Red := DwmGetPixel(336, 456)
sleep 200
gui, Color, 00FF00
sleep 100
Green := DwmGetPixel(336, 456)
sleep 200
gui, Color, 0000FF
sleep 100
Blue :=  DwmGetPixel(336, 456)
sleep 200
gui, Color, FFFFFF
sleep 100
White := DwmGetPixel(336, 456)
sleep 200
gui, Color, 000000
sleep 100
Black := DwmGetPixel(336, 456)
sleep 200
gui, Color, Default
Msgbox, Red: %Red% `nGreen:%Green%`nBlue: %Blue%`nWhite: %White%`nBlack:%Black%`n`nGdiGetPixel(211, 17)：%text1% and 4294231327`nDwmGetPixel(211, 17)：%text2% and %text22%`nGdiGetPixel(1300, 681)：%text3% and 4294967295`nDwmGetPixel(1300, 681)：%text4% and %text11%`nGdiGetPixel(485, 21)：%text5% and 4280823870`nDwmGetPixel(485, 21)：%text6% and %text33%
Winget, UniqueID,, %title%
Global UniqueID
return

TabFunc: ;切換分頁讀取GUI設定，否則可能導致選項失效
gosub, inisettings
gosub, Anchorsettings
gosub, Academysettings
gosub, Dormsettings
gosub, Missionsettings
gosub, Othersettings
return

inisettings: ;一般設定
Guicontrolget, title
Guicontrolget, emulatoradb
Guicontrolget, AllowanceValue
Iniwrite, %emulatoradb%, settings.ini, emulator, emulatoradb
Iniwrite, %title%, settings.ini, emulator, title
Iniwrite, %AllowanceValue%, settings.ini, emulator, AllowanceValue
return

Anchorsettings: ;出擊設定
Guicontrolget, AnchorSub
Guicontrolget, AnchorMode
Guicontrolget, ChapterMode
Guicontrolget, AnchorChapter 
Guicontrolget, AnchorChapter2
Guicontrolget, Assault
Guicontrolget, mood
Guicontrolget, moodtime
Guicontrolget, Autobattle
Guicontrolget, BossAction
Guicontrolget, Shipsfull
Guicontrolget, ChooseParty1
Guicontrolget, ChooseParty2
Guicontrolget, SwitchPartyAtFirstTime
Guicontrolget, WeekMode
Guicontrolget, Use_FixKit
Guicontrolget, AlignCenter
Guicontrolget, BattleTimes
Guicontrolget, BattleTimes2
Guicontrolget, Ship_Target1
Guicontrolget, Ship_Target2
Guicontrolget, Ship_Target3
Guicontrolget, Ship_Target4
Guicontrolget, Item_Bullet
Guicontrolget, Item_Quest
Guicontrolget, Plane_Target1
Guicontrolget, TimetoBattle
Guicontrolget, TimetoBattle1
Guicontrolget, TimetoBattle2
Guicontrolget, StopBattleTime
Guicontrolget, StopBattleTime2
Guicontrolget, StopBattleTime3
Iniwrite, %AnchorSub%, settings.ini, Battle, AnchorSub
Iniwrite, %AnchorMode%, settings.ini, Battle, AnchorMode
Iniwrite, %ChapterMode%, settings.ini, Battle, ChapterMode
Iniwrite, %AnchorChapter%, settings.ini, Battle, AnchorChapter
Iniwrite, %AnchorChapter2%, settings.ini, Battle, AnchorChapter2
Iniwrite, %Assault%, settings.ini, Battle, Assault
Iniwrite, %mood%, settings.ini, Battle, mood
Iniwrite, %moodtime%, settings.ini, Battle, moodtime
Iniwrite, %Autobattle%, settings.ini, Battle, Autobattle
Iniwrite, %BossAction%, settings.ini, Battle, BossAction
Iniwrite, %Shipsfull%, settings.ini, Battle, Shipsfull
Iniwrite, %ChooseParty1%, settings.ini, Battle, ChooseParty1
Iniwrite, %ChooseParty2%, settings.ini, Battle, ChooseParty2
Iniwrite, %SwitchPartyAtFirstTime%, settings.ini, Battle, SwitchPartyAtFirstTime
Iniwrite, %WeekMode%, settings.ini, Battle, WeekMode
Iniwrite, %Use_FixKit%, settings.ini, Battle, Use_FixKit
Iniwrite, %AlignCenter%, settings.ini, Battle, AlignCenter
Iniwrite, %BattleTimes%, settings.ini, Battle, BattleTimes
Iniwrite, %BattleTimes2%, settings.ini, Battle, BattleTimes2
Iniwrite, %Ship_Target1%, settings.ini, Battle, Ship_Target1
Iniwrite, %Ship_Target2%, settings.ini, Battle, Ship_Target2
Iniwrite, %Ship_Target3%, settings.ini, Battle, Ship_Target3
Iniwrite, %Ship_Target4%, settings.ini, Battle, Ship_Target4
Iniwrite, %Item_Bullet%, settings.ini, Battle, Item_Bullet
Iniwrite, %Item_Quest%, settings.ini, Battle, Item_Quest
Iniwrite, %Plane_Target1%, settings.ini, Battle, Plane_Target1
Iniwrite, %TimetoBattle%, settings.ini, Battle, TimetoBattle
Iniwrite, %TimetoBattle1%, settings.ini, Battle, TimetoBattle1
Iniwrite, %TimetoBattle2%, settings.ini, Battle, TimetoBattle2
Iniwrite, %StopBattleTime%, settings.ini, Battle, StopBattleTime
Iniwrite, %StopBattleTime2%, settings.ini, Battle, StopBattleTime2
Iniwrite, %StopBattleTime3%, settings.ini, Battle, StopBattleTime3
Global Assault, Autobattle, shipsfull, ChooseParty1, ChooseParty2, AnchorMode, SwitchPartyAtFirstTime, WeekMode, AnchorChapter, AnchorChapter2
FirstChooseParty := 0
;////出擊2///////
Guicontrolget, IndexAll
Guicontrolget, Index1
Guicontrolget, Index2
Guicontrolget, Index3
Guicontrolget, Index4
Guicontrolget, Index5
Guicontrolget, Index6
Guicontrolget, Index7
Guicontrolget, Index8
Guicontrolget, Index9
Guicontrolget, CampAll
Guicontrolget, Camp1
Guicontrolget, Camp2
Guicontrolget, Camp3
Guicontrolget, Camp4
Guicontrolget, Camp5
Guicontrolget, Camp6
Guicontrolget, Camp7
Guicontrolget, RarityAll
Guicontrolget, Rarity1
Guicontrolget, Rarity2
Guicontrolget, Rarity3
Guicontrolget, Rarity4
Guicontrolget, DailyGoalSub
Guicontrolget, DailyParty
Guicontrolget, DailyGoalSunday
Guicontrolget, DailyGoalRed
Guicontrolget, DailyGoalRedAction
Guicontrolget, DailyGoalGreen
Guicontrolget, DailyGoalGreenAction
Guicontrolget, DailyGoalBlue
Guicontrolget, DailyGoalBlueAction
Guicontrolget, OperationSub
Guicontrolget, Operationenemy
Guicontrolget, Leave_Operatio
Iniwrite, %IndexAll%, settings.ini, Battle, IndexAll ;全部
Iniwrite, %Index1%, settings.ini, Battle, Index1 ;前排先鋒
Iniwrite, %Index2%, settings.ini, Battle, Index2 ;後排主力
Iniwrite, %Index3%, settings.ini, Battle, Index3 ;驅逐
Iniwrite, %Index4%, settings.ini, Battle, Index4 ;輕巡
Iniwrite, %Index5%, settings.ini, Battle, Index5 ;重巡
Iniwrite, %Index6%, settings.ini, Battle, Index6 ;戰列
Iniwrite, %Index7%, settings.ini, Battle, Index7 ;航母
Iniwrite, %Index8%, settings.ini, Battle, Index8 ;維修
Iniwrite, %Index9%, settings.ini, Battle, Index9 ;其他
Iniwrite, %CampAll%, settings.ini, Battle, CampAll ;全部
Iniwrite, %Camp1%, settings.ini, Battle, Camp1 ;白鷹
Iniwrite, %Camp2%, settings.ini, Battle, Camp2 ;皇家
Iniwrite, %Camp3%, settings.ini, Battle, Camp3 ;重櫻
Iniwrite, %Camp4%, settings.ini, Battle, Camp4 ;鐵血
Iniwrite, %Camp5%, settings.ini, Battle, Camp5 ;東煌
Iniwrite, %Camp6%, settings.ini, Battle, Camp6 ;北方聯合
Iniwrite, %Camp7%, settings.ini, Battle, Camp7 ;其他
Iniwrite, %RarityAll%, settings.ini, Battle, RarityAll ;全部
Iniwrite, %Rarity1%, settings.ini, Battle, Rarity1 ;普通
Iniwrite, %Rarity2%, settings.ini, Battle, Rarity2 ;稀有
Iniwrite, %Rarity3%, settings.ini, Battle, Rarity3 ;精銳
Iniwrite, %Rarity4%, settings.ini, Battle, Rarity4 ;超稀有
Iniwrite, %DailyGoalSub%, settings.ini, Battle, DailyGoalSub  ;自動執行每日任務
Iniwrite, %DailyParty%, settings.ini, Battle, DailyParty  ;每日隊伍選擇
Iniwrite, %DailyGoalSunday%, settings.ini, Battle, DailyGoalSunday ;禮拜日三個都打
Iniwrite, %DailyGoalRed%, settings.ini, Battle, DailyGoalRed
Iniwrite, %DailyGoalRedAction%, settings.ini, Battle, DailyGoalRedAction
Iniwrite, %DailyGoalGreen%, settings.ini, Battle, DailyGoalGreen
Iniwrite, %DailyGoalGreenAction%, settings.ini, Battle, DailyGoalGreenAction
Iniwrite, %DailyGoalBlue%, settings.ini, Battle, DailyGoalBlue
Iniwrite, %DailyGoalBlueAction%, settings.ini, Battle, DailyGoalBlueAction
Iniwrite, %OperationSub%, settings.ini, Battle, OperationSub ;自動執行演習
Iniwrite, %Operationenemy%, settings.ini, Battle, Operationenemy
Iniwrite, %Leave_Operatio%, settings.ini, Battle, Leave_Operatio
Global IndexAll, Index1, Index2, Index3, Index4, Index5, Index6, Index7, Index8, Index9, CampAll, Camp1,Camp2, Camp3, Camp4, Camp5, Camp6, Camp7, Camp8, Camp9, RarityAll, Rarity1, Rarity2, Rarity3, Rarity4, DailyParty, Leave_Operatio
return

Academysettings: ;學院設定
Guicontrolget, AcademySub
Guicontrolget, AcademyOil
Guicontrolget, AcademyCoin
Guicontrolget, AcademyTactics
Guicontrolget, AcademyShop
Guicontrolget, 150expbookonly
Guicontrolget, SkillBook_ATK
Guicontrolget, SkillBook_DEF
Guicontrolget, SkillBook_SUP
Guicontrolget, Cube
Iniwrite, %AcademySub%, settings.ini, Academy, AcademySub
Iniwrite, %AcademyOil%, settings.ini, Academy, AcademyOil
Iniwrite, %AcademyCoin%, settings.ini, Academy, AcademyCoin
Iniwrite, %AcademyShop%, settings.ini, Academy, AcademyShop
Iniwrite, %AcademyTactics%, settings.ini, Academy, AcademyTactics
Iniwrite, %150expbookonly%, settings.ini, Academy, 150expbookonly
Iniwrite, %SkillBook_ATK%, settings.ini, Academy, SkillBook_ATK
Iniwrite, %SkillBook_DEF%, settings.ini, Academy, SkillBook_DEF
Iniwrite, %SkillBook_SUP%, settings.ini, Academy, SkillBook_SUP
Iniwrite, %Cube%, settings.ini, Academy, Cube
return

Dormsettings: ;後宅設定
Guicontrolget, DormSub
Guicontrolget, DormCoin
Guicontrolget, Dormheart
Guicontrolget, DormFood
Guicontrolget, DormFoodBar
Iniwrite, %DormSub%, settings.ini, Dorm, DormSub
Iniwrite, %DormCoin%, settings.ini, Dorm, DormCoin
Iniwrite, %Dormheart%, settings.ini, Dorm, Dormheart
Iniwrite, %DormFood%, settings.ini, Dorm, DormFood
Iniwrite, %DormFoodBar%, settings.ini, Dorm, DormFoodBar
Guicontrol, ,DormFoodBarUpdate, %DormFoodBar%
Global DormFood
return

Missionsettings: ;任務設定
Guicontrolget, MissionSub
Iniwrite, %MissionSub%, settings.ini, MissionSub, MissionSub
return

Othersettings: ;其他設定
Guicontrolget, GuiHideX
Guicontrolget, EmulatorCrushCheck
Guicontrolget, AutoLogin
Guicontrolget, SetGuiBGcolor
Guicontrolget, SetGuiBGcolor2
Iniwrite, %GuiHideX%, settings.ini, OtherSub, GuiHideX
Iniwrite, %EmulatorCrushCheck%, settings.ini, OtherSub, EmulatorCrushCheck
Iniwrite, %AutoLogin%, settings.ini, OtherSub, AutoLogin
Iniwrite, %SetGuiBGcolor%, settings.ini, OtherSub, SetGuiBGcolor
Iniwrite, %SetGuiBGcolor2%, settings.ini, OtherSub, SetGuiBGcolor2
Global AutoLogin
return

exitsub:
WindowName = Azur Lane - %title%
wingetpos, azur_x, azur_y,, WindowName
iniwrite, %azur_x%, settings.ini, Winposition, azur_x
iniwrite, %azur_y%, settings.ini, Winposition, azur_y
exitapp
return

Showsub:
Gui, show
return

GuiClose:
if GuiHideX {
	Traytip, 訊息, 　`nAzurLane (%title%) 背景執行中!`n　, 2
	Gui, Hide
} else {
	WindowName = Azur Lane - %title%
	wingetpos, azur_x, azur_y,, WindowName
	iniwrite, %azur_x%, settings.ini, Winposition, azur_x
	iniwrite, %azur_y%, settings.ini, Winposition, azur_y
	ExitApp
}
return

guicontrols: ;關閉某些按鈕，避免更動
Guicontrol, disable, Start
Guicontrol, disable, title
Guicontrol, disable, emulatoradb
Guicontrol, disable, EmulatorCrushCheck
Guicontrol, disable, BattleTimes2
Guicontrol, disable, Timetobattle1
Guicontrol, disable, Timetobattle2
Guicontrol, disable, StopBattleTime3
return

Start:
gosub, TabFunc
gosub, guicontrols
IfWinNotExist , %title%
	goto startemulatorsub
Winget, UniqueID,, %title%
Allowance = %AllowanceValue%
emulatoradb = %emulatoradb%
Global UniqueID
Global Allowance
Global emulatoradb
LogShow("開始！")
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
WinSet, Transparent, off, %title%
Settimer, Mainsub, 2500
Settimer, WinSub, 3200
if (EmulatorCrushCheck)
{
	Settimer, EmulatorCrushCheckSub, 600000
}
return

ForumSub:
Run, https://github.com/panex0845/AzurLane/issues
return

DiscordSub:
Run, https://discord.gg/GFCRSap
return

EmulatorCrushCheckSub:
CheckPostion1 := DwmGetpixel(56, 84)
CheckPostion2 := DwmGetpixel(313, 515)
CheckPostion3 := DwmGetpixel(938, 235)
CheckPostion4 := DwmGetpixel(163, 357)
CheckPostion5 := DwmGetpixel(513, 66)
Withdraw := DwmCheckcolor(772, 706, 12996946) 
sleep 1000
if (DwmGetpixel(56, 84)=CheckPostion1 and DwmGetpixel(313, 515)=CheckPostion2 and DwmGetpixel(938, 235)=CheckPostion3 and DwmGetpixel(163, 357)=CheckPostion4 and DwmGetpixel(513, 66)=CheckPostion5 and !Withdraw and DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(1240, 83, 16249847))
{
	sleep 1000
	if (DwmGetpixel(56, 84)=CheckPostion1 and DwmGetpixel(313, 515)=CheckPostion2 and DwmGetpixel(938, 235)=CheckPostion3 and DwmGetpixel(163, 357)=CheckPostion4 and DwmGetpixel(513, 66)=CheckPostion5 and !Withdraw and DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(1240, 83, 16249847))
	{
		sleep 1000
		if (DwmGetpixel(56, 84)=CheckPostion1 and DwmGetpixel(313, 515)=CheckPostion2 and DwmGetpixel(938, 235)=CheckPostion3 and DwmGetpixel(163, 357)=CheckPostion4 and DwmGetpixel(513, 66)=CheckPostion5 and !Withdraw and DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(1240, 83, 16249847))
		{
			LogShow("=====模擬器當機=====")
			iniwrite, 1, settings.ini, OtherSub, Autostart
			runwait, dnconsole.exe quit --index %emulatoradb% , %ldplayer%, Hide
			sleep 10000
			goto, startemulatorSub
		}
	}
}
return

ResetOperationSub:
GuiControl, disable, ResetOperation
OperationDone := VarSetCapacity  ;重置演習判斷
iniWrite, 0, settings.ini, Battle, OperationYesterday
LogShow("演習已被重置")
sleep 200
GuiControl, Enable, ResetOperation
;~ if (DwmCheckcolor(12, 200, 16777215) and DwmCheckcolor(1144, 440, 14592594)) ;如果位於首頁
;~ {
	;~ Random, x, 1018, 1144
	;~ Random, y, 339, 455
	;~ C_Click(x, y) ;點擊出擊
	;~ Loop
	;~ {
		;~ if (DwmCheckcolor(794, 710, 16777215) and DwmCheckcolor(812, 699, 13000026)) ;如果在現實地圖(關卡)
		;~ {
			;~ C_Click(54, 88) ;回到上一頁
		;~ }
		;~ else if (DwmCheckcolor(750, 719, 10864623) and DwmCheckcolor(132, 63, 14085119)) ;在關卡選擇頁面
		;~ {
			;~ Break
		;~ }
		;~ sleep 300
	;~ }
;~ }
return

Mainsub: ;優先檢查出擊以外的其他功能
LDplayerCheck := DwmCheckcolor(1, 35, 2633790) 
Formattime, Nowtime, ,HHmm
if !LDplayerCheck ;檢查模擬器有沒有被縮小
{
	goto, Winsub
}
else if LDplayerCheck
{
	if (NowTime=0101 or Nowtime=1301)
	{
		DailyDone := VarSetCapacity ;重置每日判斷
		OperationDone := VarSetCapacity  ;重置演習判斷
		iniWrite, 0, settings.ini, Battle, OperationYesterday
	}
	MainCheck := [DwmCheckcolor(12, 200, 16777215), DwmCheckcolor(12, 200, 16250871)] ;主選單圖示
	MainCheck := CheckArray(MainCheck*)
	Formation := DwmCheckcolor(895, 415, 16777215) ;編隊BTN
	WeighAnchor := DwmCheckcolor(1035, 345, 16777215) ;出擊BTN
	LDtitlebar := DwmCheckcolor(1, 35, 2633790) ;
	MissionCheck := DwmCheckcolor(948, 709, 16772071) ;任務驚嘆號
	if (MissionSub and MissionCheck and MainCheck and Formation and WeighAnchor and LDtitlebar) ;任務
	{
		gosub, MissionSub
		sleep 3000
	}
	AcademyCheck := DwmCheckcolor(627, 712, 11882818) ;學院驚嘆號
	if (AcademySub and AcademyCheck and MainCheck and Formation and WeighAnchor and LDtitlebar and AcademyDone<1) ;學院
	{
		gosub, AcademySub
		sleep 3000
	}
	DormMissionCheck := DwmCheckcolor(790, 710, 16244694) ;後宅驚嘆號
	if (DormSub and DormMissionCheck and MainCheck and Formation and WeighAnchor and LDtitlebar and DormDone<1)  ;後宅
	{
		gosub, DormSub
		sleep 3000
	}
	if ((AnchorSub and LDtitlebar) and (!AcademyCheck or AcademyDone=1 or !AcademySub) and (!DormMissionCheck or DormDone=1 or !DormSub))  ;出擊
	{
		gosub, AnchorSub
	}
}
if ((Timetobattle) and (Nowtime=TimetoBattle1 or Nowtime=TimetoBattle2) and RunOnceTime<1)
{
	StopAnchor := 0
	LogShow("重新出擊")
	Timetobattle11 := Timetobattle1+1
	Timetobattle22 := Timetobattle2+1
	RunOnceTime := 1
}
else if (RunOnceTime=1 and (Nowtime=Timetobattle11 or Nowtime=Timetobattle11))
{
	RunOnceTime := VarSetCapacity
	Timetobattle11 := VarSetCapacity
	Timetobattle22 := VarSetCapacity
}
return

clock:
StopAnchor := 0
return

ReAnchorSub:
Guicontrol, disable, ReAnchorSub
LogShow("再次出擊！")
StopAnchor := VarSetCapacity
StopBattleTimeCount := VarSetCapacity
WeighAnchorCount := VarSetCapacity
sleep 1000
Guicontrol, enable, ReAnchorSub
return

AnchorSub: ;出擊
if (DwmCheckcolor(46, 181, 16774127) and DwmCheckcolor(1140, 335, 14577994)) ;在主選單偵測到軍事任務已完成
{
	LogShow("執行軍事委託")
	C_Click(20, 200)
	Loop
	{
		if (DwmCheckcolor(495, 321, 15704642)) ;出現選單
		{
			C_Click(444, 318) ;點擊軍事委託完成
			sleep 2500
		}
		else if (DwmCheckcolor(1216, 75, 16777215) or DwmCheckcolor(1215, 76, 16777215)) ;出現委託成功S頁面
		{
			break
		}
		sleep 500
	}
	Loop
	{
		sleep 1000
		if (DwmCheckcolor(1226, 74, 16777215) or DwmCheckcolor(1215, 76, 16777215)) ;委託成功 S
		{
			C_Click(639, 141) ;隨便點
			sleep 1000
		}
		else if (DwmCheckcolor(461, 316, 16777215) and DwmCheckcolor(432, 321, 16777215) and DwmCheckcolor(268, 348, 9240551) and DwmCheckcolor(237, 355, 9240551)) ;如果已經"空閒"
		{
			C_Click(441, 314)
			sleep 1500
		}
		else if (DwmCheckcolor(135, 57, 15726591) and DwmCheckcolor(167, 59, 16251903)) ;成功進入委託頁面
		{
			Rmenu := 1
			break
		}
		else
		{
			LoopVar++
			if (LoopVar>100)
			{
				LogShow("軍事委託出現錯誤")
				LoopVar := VarSetCapacity
				Rmenu := VarSetCapacity
				Break
			}
		}
		GetItem()
		GetItem2()
	}
	LoopVar := VarSetCapacity
	if (Rmenu=1)
	{
		Rmenu := VarSetCapacity
		DelegationMission()
		Loop, 50
		{
			if DwmCheckcolor(109, 172, 4876692)
			{
				C_Click(1246, 89)
				sleep 2000
			}
			else if (DwmCheckcolor(12, 200, 16777215) or DwmCheckcolor(12, 200, 16250871))
			{
				break
			}
			sleep 300
		}
	}
	else
	{
		Loop
		{
			if DwmCheckcolor(109, 172, 4876692)
			{
				C_Click(1246, 89)
				sleep 2000
			}
			else if (DwmCheckcolor(12, 200, 16777215) or DwmCheckcolor(12, 200, 16250871))
			{
				break
			}
			sleep 500
		}
	}
	LogShow("軍事委託結束")
}
AnchorCheck := DwmCheckcolor(1036, 346, 16777215)
AnchorCheck2 := DwmCheckcolor(1096, 331, 16769924)
MainCheck := [DwmCheckcolor(12, 200, 16777215), DwmCheckcolor(12, 200, 16250871)] ;主選單圖示
MainCheck := CheckArray(MainCheck*)
if (AnchorCheck and AnchorCheck2 and MainCheck and StopAnchor<1)
{
	Random, x, 1025, 1145
	Random, y, 356, 453
	C_Click(x,y) ;於首頁點擊點擊右邊"出擊"
}
if ((DwmCheckcolor(1234, 649, 16777215) or DwmCheckcolor(1234, 649, 16250871)) and DwmCheckcolor(1109, 605, 3224625) and  DwmCheckcolor(31, 621, 16777215)) ;右下出擊
{
	sleep 300
    if (DwmCheckcolor(773, 155, 15695211) and Autobattle="自動") ;Auto Battle >> ON
    {
		LogShow("開啟自律模式")
        C_Click(819, 160)
    }
	else if (DwmCheckcolor(779, 153, 574331) and Autobattle="半自動")
	{
		LogShow("開啟半自動模式")
		C_Click(819, 160)
	}
	else if (DwmCheckcolor(779, 153, 574331) and Autobattle="關閉")
	{
		LogShow("關閉自律模式")
		C_Click(819, 160)
	}
	if (DwmCheckcolor(121, 568, 16777215) and (Use_FixKit)) ;如果有維修工具
	{
		Loop, 100
		{
			if (DwmCheckcolor(121, 568, 16777215)) ;如果有維修工具
			{
				C_Click(119, 570) ;使用維修工具
			}
			else if (DwmCheckcolor(331, 223, 16777215) and DwmCheckcolor(422, 358, 16777215)) ; 跳出訊息選單
			{
				C_Click(755, 481) ;點擊使用
				if (DwmCheckcolor(411, 358, 16250871)) ;如果HP是滿的
				{
					C_Click(530, 480) ;點擊取消
				}
			}
			sleep 300
			if (DwmCheckcolor(132, 59, 14610431)) ;回到編隊頁面
			{
				break
			}	
		}
	}
	AnchorTimes++ ;統計出擊次數
	GuiControl, ,AnchorTimesText, 出擊次數：%AnchorTimes% 次。
	LogShow("出擊～！")
    Random, x, 1056, 1225
	Random, y, 656, 690
	C_Click(x, y) ;於編隊頁面點擊右下 "出擊"
	shipsfull(StopAnchor)
	IsDetect := VarSetCapacity
    TargetFailed := VarSetCapacity
    TargetFailed2 := VarSetCapacity
    TargetFailed3 := VarSetCapacity
    TargetFailed4 := VarSetCapacity
    TargetFailed5 := VarSetCapacity
    TargetFailed6 := VarSetCapacity
	Plane_TargetFailed1 := VarSetCapacity
    BossFailed := VarSetCapacity
    BulletFailed := VarSetCapacity
    QuestFailed := VarSetCapacity
	SearchLoopcount := VarSetCapacity
	SearchFailedMessage := VarSetCapacity
	SearchLoopcountFailed2 := VarSetCapacity
    if (GdiGetPixel(743, 541)=4282544557) ;心情低落
    {
		if mood=強制出戰
		{
			LogShow("老婆心情低落：提督SAMA沒人性")
			C_Click(790, 546)
		}
		else if mood=更換隊伍
		{
			LogShow("老婆心情低落，但更換隊伍未完成，強制休息")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -3600000
		}
		else if mood=休息1小時
		{
			LogShow("老婆心情低落：休息1小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock,  -3600000
		}
		else if mood=休息2小時
		{
			LogShow("老婆心情低落：休息2小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -7200000
		}
		else if mood=休息3小時
		{
			LogShow("老婆心情低落：休息3小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -10800000
		}
		else if mood=休息5小時
		{
			LogShow("老婆心情低落：休息5小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -14400000
		}
		else
		{
			msgbox get sometihng bad
		}
    }
    else if (DwmGetPixel(543, 361)=15724527) ;石油不足
    {
        LogShow("石油不足，停止出擊到永遠！")
        C_Click(1230, 74)
		StopAnchor := 1
    }
    Loop, 15 ;等待回到主頁面
    {
        sleep 1000
    } until DwmCheckcolor(12, 200, 16777215)
    
}
gosub BtnCheck
if (Withdraw and Switchover )
{
	if (IsDetect<1)
		LogShow("偵查中。")
	sleep 1000
	if (AlignCenter) and !(GdipImageSearch2(x, y, "img/Map_Lower.png", 0, 1, 150, 540, 650, 740)) and ((Bossaction="優先攻擊－當前隊伍" or Bossaction="優先攻擊－切換隊伍") and !(GdipImageSearch2(n, m, "img/targetboss_1.png", 0, 1, MapX1, MapY1, MapX2, MapY2))) ; 嘗試置中地圖
	{
		sleep 500
		A_SwipeFast(164, 218, 1235, 646)
		Loop
		{
			Random, x, 165, 1000
			A_SwipeFast(x, 600, x, 500)
			AlignCenterCount++
		} until (GdipImageSearch2(x, y, "img/Map_Lower.png", 0, 1, 600, 550, 1270, 670)) or AlignCenterCount>10
		y1 := y - 5
		y2 := y + 5
		AlignCenterCount := VarSetCapacity
		Loop 
		{
			Random, y, 180, 650
			A_SwipeFast(650, y, 430, y)
			AlignCenterCount++
		} until (GdipImageSearch2(x, y, "img/Map_Lower.png", 0, 1, 125, y1, 220, y5)) or AlignCenterCount>10
		AlignCenterCount := VarSetCapacity
	}
	Loop, 100
	{
		sleep 300
		MapX1 := 125, MapY1 := 125, MapX2 :=1180, MapY2 := 650 ; //////////檢查敵方艦隊的範圍////////// MapX1, MapY1 always be 0 or 100 
		;Mainfleet := 4287894561 ; ARGB 主力艦隊
		;~ FinalBoss := 4294920522 ; ARGB BOSS艦隊
		Random, SearchDirection, 1, 8
		if (GdipImageSearch2(x, y, "img/bullet.png", 105, SearchDirection, MapX1, MapY1, MapX2, MapY2) and GdipImageSearch2(n, n, "img/Bullet_None.png", 10, SearchDirection, MapX1, MapY1, MapX2, MapY2) and bulletFailed<1 and Item_Bullet) ;只有在彈藥歸零時才會拾取
		{
			LogShow("嗶嗶嚕嗶～發現：子彈補給！")
			xx := x 
			yy := y + 80
			Loop, 3
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (yy>660)
				{
					A_Swipe(138,300,148,215)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						bulletFailed++
						break
					}
					sleep 2000
				}
				if (DwmCheckcolor(1235, 652, 16777215)) ;規避失敗
				{
					Break
				}
				if (DwmCheckcolor(325, 358, 16250871)) ;獲得道具
				{
					C_Click(xx, yy)
					Break
				}
				BackAttack()
				sleep 1000
			}
			bulletFailed++
		}
		if (GdipImageSearch2(x, y, "img/quest.png", 8, SearchDirection, MapX1, MapY1, MapX2, MapY2) and questFailed<1 and Item_Quest) ;
		{
			LogShow("嗶嗶嚕嗶～發現：神秘物資！")
			xx := x
			yy := y + 70
			Loop, 4
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (yy>660)
				{
					A_Swipe(138,300,148,215)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279) and !(DwmCheckcolor(576, 258, 16777215) and DwmCheckcolor(712, 258, 16777215))) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						questFailed++
						break
					}
					sleep 2000
				}
				if (DwmCheckcolor(1235, 652, 16777215)) ;規避失敗，進入編隊畫面
				{
					Break
				}
				if (DwmCheckcolor(576, 258, 16777215) and DwmCheckcolor(712, 258, 16777215)) ;獲得道具
				{
					sleep 1200
					C_Click(xx, yy)
					Break
				}
				BackAttack()
				sleep 1000
			}
			IsDetect := 1
			return
		}
		if (GdipImageSearch2(x, y, "img/targetboss_1.png", 0, SearchDirection, MapX1, MapY1, MapX2, MapY2) and BossFailed<1) and (Bossaction="優先攻擊－當前隊伍" or Bossaction="優先攻擊－切換隊伍" or Bossaction="撤退") ;ＢＯＳＳ
		{
			if Bossaction=撤退
			{
				LogShow("嗶嗶嚕嗶～發現：最終BOSS，撤退！")
				C_Click(830, 710) ;點擊撤退
				sleep 1000
				C_Click(791, 543) ;點擊確定
				return
			}
			else if (x<340 and y<190) ;如果在左上角可能誤點
			{
				LogShow("BOSS位於左上角，拖曳畫面！")
				Random, y, 200, 600
				A_Swipe(370, y, 700, y)
				return
			}
			else if Bossaction=優先攻擊－當前隊伍
			{
				LogShow("嗶嗶嚕嗶～優先攻擊最終BOSS！")
				TargetFailed := 1
				TargetFailed2 := 1
				TargetFailed3 := 1
				TargetFailed4 := 1
				Loop, 15
				{
					xx := x
					yy := y
					if (DwmCheckcolor(135, 57, 14085119) and xx>147 and yy>200 and xx<MapX2 and yy<MapY2) 
					{
						C_Click(xx, yy)
						if (DwmCheckcolor(516, 357, 16250871))  ;16250871
						{
							BossFailed++
							LogShow("哎呀哎呀，前往BOSS的路徑被擋住了！")
							sleep 2000
							TargetFailed := 0
							TargetFailed2 := 0
							TargetFailed3 := 0
							TargetFailed4 := 0
							break
						}
					}
					else if (DwmCheckcolor(135, 57, 14085119) and xx<290 and yy<195) 
					{
						random, swipeboss, 1, 2
						if swipeboss=1
						{
							A_Swipe(138,215,148,300)  ;下
						}
						else if swipeboss=2
						{
							A_Swipe(148,300,138,215)  ;上
						}
						break
					}
					if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
					{
						sleep 1000
					}
					if (DwmCheckcolor(1235, 652, 16777215)) ;進入戰鬥界面
					{
						Break
					}
					BackAttack()
					sleep 500
				}
			}
			else if Bossaction=優先攻擊－切換隊伍
			{
				xx := x 
				yy := y 
				if (SwitchParty<1)
				{
					LogShow("嗶嗶嚕嗶～切換隊伍並重新搜尋最終BOSS！")
					SwitchParty := 1
					BossactionTarget := 1 ;如果已經觸發到BOSS
					bulletFailed := 1
					TargetFailed := 1
					TargetFailed2 := 1
					TargetFailed3 := 1
					TargetFailed4 := 1
					Loop, 15
					{
						boss := Dwmgetpixel(x, y)
						if (Dwmgetpixel(x, y)=boss)
						{
							C_Click(1035, 715) ;切換隊伍
							break
						}
						sleep 300
					}
				}
				else
				{
					C_Click(xx, yy)
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871)) 
					{
						BossFailed++
						LogShow("哎呀哎呀，前往BOSS的路徑被擋住了！")
						sleep 1000
						C_Click(1035, 715) ;換回原本的隊伍
						sleep 1000
						TargetFailed := 0
						TargetFailed2 := 0
						TargetFailed3 := 0
						TargetFailed4 := 0
						SwitchParty := 0
						return
					}
					sleep 4050
					BackAttack()
					if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and BossFailed<1) ; 如果沒有成功進入戰鬥，再試一次
					{
						C_Click(xx, yy)
						sleep 2050
					}
				}
			}
			else
			{
				msgbox, 優先攻擊－當前隊伍 or 優先攻擊－切換隊伍 發生錯誤
			}
			return
		}
		if ((GdipImageSearch2(x, y, "img/target2_1.png", 105, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target2_2.png", 105, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target2_3.png", 105, SearchDirection, MapX1, MapY1, MapX2, MapY2)) and TargetFailed2<1 and (Ship_Target2 or SearchLoopcount>9)) ;
		{
			LogShow("嗶嗶嚕嗶～發現：運輸艦隊！")
			xx := x 
			yy := y 
			Loop, 15
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						TargetFailed2++
						LogShow("哎呀哎呀，前往運輸艦隊的路徑被擋住了！")
						sleep 2000
						break
					}
					sleep 1500
				}
				if (DwmCheckcolor(1235, 652, 16777215))
				{
					Break
				}
				BackAttack()
				sleep 500
			}
			return
		}
		if ((GdipImageSearch2(x, y, "img/target_1.png", 33, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target_2.png", 33, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target_3.png", 33, SearchDirection, MapX1, MapY1, MapX2, MapY2)) and TargetFailed<1 and (Ship_Target1 or SearchLoopcount>9)) ;
		{
			LogShow("嗶嗶嚕嗶～發現：航空艦隊！")
			xx := x 
			yy := y 
			Loop, 15
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						TargetFailed++
						LogShow("哎呀哎呀，前往航空艦隊的路徑被擋住了！")
						sleep 2000
						break
					}
					sleep 1500
				}
				if (DwmCheckcolor(1235, 652, 16777215))
				{
					Break
				}
				BackAttack()
				sleep 500
			}
			return
		}
		if ((GdipImageSearch2(x, y, "img/target4_1.png", 60, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target4_2.png", 60, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target4_3.png", 60, SearchDirection, MapX1, MapY1, MapX2, MapY2)) and TargetFailed4<1 and (Ship_Target4 or SearchLoopcount>9)) 
		{
			LogShow("嗶嗶嚕嗶～發現：偵查艦隊！")
			xx := x
			yy := y
			Loop, 15
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						TargetFailed4++
						LogShow("哎呀哎呀，前往偵查艦隊的路徑被擋住了！")
						sleep 2000
						break
					}
					sleep 1500
				}
				if (DwmCheckcolor(1235, 652, 16777215))
				{
					Break
				}
				BackAttack()
				sleep 500
			}
			return
		}
		if ((GdipImageSearch2(x, y, "img/target3_1.png", 45, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target3_2.png", 45, SearchDirection, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target3_3.png", 45, SearchDirection, MapX1, MapY1, MapX2, MapY2)) and TargetFailed3<1 and (Ship_Target3 or SearchLoopcount>9)) 
		;~ else if (Gdip_PixelSearch2( x,  y, MapX1, MapY1, MapX2, MapY2, Mainfleet, 0) and TargetFailed3<1) 
		{
			LogShow("嗶嗶嚕嗶～發現：主力艦隊！")
			xx := x
			yy := y 
			Loop, 15
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						TargetFailed3++
						LogShow("哎呀哎呀，前往主力艦隊的路徑被擋住了！")
						sleep 2000
						break
					}
					sleep 1500
				}
				if (DwmCheckcolor(1235, 652, 16777215))
				{
					Break
				}
				BackAttack()
				sleep 500
			}
			return
		}
		if ((Plane_Target1 or SearchLoopcount>9) and GdipImageSearch2(x, y, "img/target_plane1.png", 25, SearchDirection, MapX1, MapY1, MapX2, MapY2) and Plane_TargetFailed1<1) ;航空器
		{
			LogShow("嗶嗶嚕嗶～發現：航空器！")
			xx := x 
			yy := y 
			Loop, 15
			{
				if (xx<290 and yy<193)
				{
					A_Swipe(138,215,148,300)
					break
				}
				if (DwmCheckcolor(135, 57, 14085119) or DwmCheckcolor(164, 61, 15201279)) ;如果在限時(無限時)地圖
				{
					C_Click(xx, yy)
					if (DwmCheckcolor(516, 357, 16250871))  ;16250871
					{
						Plane_TargetFailed1++
						LogShow("哎呀哎呀，前往航空器的路徑被擋住了！")
						sleep 2000
						break
					}
					sleep 1500
				}
				if (DwmCheckcolor(1235, 652, 16777215))
				{
					Break
				}
				BackAttack()
				sleep 500
			}
			return
		}
		if (Bossaction!="能不攻擊就不攻擊" or SearchLoopcount>15) and (GdipImageSearch2(x, y, "img/targetboss_1.png", 0, SearchDirection, MapX1, MapY1, MapX2, MapY2) and BossFailed<1 ) ;ＢＯＳＳ
		{
			xx := x 
			yy := y 
			if (xx<290 and yy<193)
			{
				A_Swipe(138,215,148,300)
				return
			}
			if (SearchLoopcount>15 and ossaction="能不攻擊就不攻擊")
			{
				LogShow("已經偵查不到其他船艦，攻擊最終BOSS！")
			}
			else
			{
			LogShow("嗶嗶嚕嗶～發現最終BOSS！")
			}
			if (SwitchParty<1 and Bossaction="隨緣攻擊－切換隊伍")
			{
				LogShow("發現BOSS：隨緣攻擊－切換隊伍！")
				SwitchParty := 1
				C_Click(1035, 706)
			}
			else
			{
				C_Click(xx, yy)
				C_Click(xx, yy)
			}
			if (DwmCheckcolor(516, 357, 16250871)) 
			{
				BossFailed++
				return
			}
			sleep 4050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and BossFailed<1) ; 如果沒有成功進入戰鬥，再試一次
			{
				C_Click(xx, yy)
				sleep 2050
			}
			return
		}
		if (SearchLoopcount>3 and DwmCheckcolor(793, 711, 16777215))
		{
			if (SearchFailedMessage<1)
			{
				LogShow("偵查失敗，嘗試拖曳畫面")
				SearchFailedMessage := 1
			}
			if side<1
			{
				;~ A_Swipe(652,166,652,660)  ;下
				A_Swipe(1013,531,211,106)  ;↖
				side := 2
			}
			else if side=2
			{
					A_Swipe(652,130,652,710)  ;swipe side : ↓
				side=3
			}
			else if side=3
			{
					A_Swipe(652,130,652,710)  ;swipe side : ↓
				side=4
			}
			else if side=4
			{
				A_Swipe(257,310,1040,310) ;swipe side : →
				;~ A_Swipe(1256,310,120,310) ;左
				side=5
			}
			else if side=5
			{
				;~ A_Swipe(1256,310,120,310) ;左
				A_Swipe(188,241,1164,621) ;swipe side : ↘
				side=6
			}
			else if side=6
			{
				;~ A_Swipe(1256,310,120,310) ;左
				 A_Swipe(604,710,652,130)  ;swipe side : ↑
				side=7
			}
			else if side=7
			{
				;~ A_Swipe(200,310,1240,310) ;右
				A_Swipe(363,555,1011,220) ;swipe side : ↗
				side=8
			}
			else if side=8
			{
				;~ A_Swipe(200,310,1240,310) ;右
				A_Swipe(1256,310,120,310) ;swipe side : ←
				side=0
			}
			sleep 300
			SearchLoopcountFailed++
			SearchLoopcountFailed2++
			if (GdipImageSearch2(x, y, "img/Myposition.png", 10, SearchDirection, MapX1, MapY1, MapX2, MapY2) and SearchLoopcountFailed>2)
			{
				Random, xx, 1, 3
				if xx=1
				{
					xx := x + 150
					yy := y + 200
				}
				else if xx=2
				{
					xx := x - 150
					yy := y + 200
				}
				else if xx=3
				{
					xx := x 
					yy := y + 320
				}
				if (xx>130 and xx<1185) and (yy>150 and yy<660)
				{
					LogShow("未找到指定目標，嘗試隨機移動")
					MoveCheck := Dwmgetpixel(xx, yy)
					sleep 500
					if (Dwmgetpixel(xx, yy)=MoveCheck) ;避免切換到艦隊
					{
						C_Click(xx, yy)
						C_Click(xx, yy)
					}
					MoveCheck := VarSetCapacity
				}
				SearchLoopcountFailed := 0
				sleep 2000
				if (DwmCheckcolor(793, 711, 16250871))
				{
					MoveFailed++
				}
			}
			if (BossactionTarget!=1)
			{
				TargetFailed := VarSetCapacity
				TargetFailed2 := VarSetCapacity
				TargetFailed3 := VarSetCapacity
				TargetFailed4 := VarSetCapacity
				Plane_TargetFailed1 := VarSetCapacity
			}
			else if (BossactionTarget=1 and SearchLoopcountFailed2>8)
			{
				TargetFailed := VarSetCapacity
				TargetFailed2 := VarSetCapacity
				TargetFailed3 := VarSetCapacity
				TargetFailed4 := VarSetCapacity
				Plane_TargetFailed1 := VarSetCapacity
				BossactionTarget := VarSetCapacity
			}
			else if (BossFailed=1)
			{
				TargetFailed := VarSetCapacity
				TargetFailed2 := VarSetCapacity
				TargetFailed3 := VarSetCapacity
				TargetFailed4 := VarSetCapacity
				Plane_TargetFailed1 := VarSetCapacity
			}
			else if (SearchLoopcountFailed2>8)
			{
				TargetFailed := VarSetCapacity
				TargetFailed2 := VarSetCapacity
				TargetFailed3 := VarSetCapacity
				TargetFailed4 := VarSetCapacity
				Plane_TargetFailed1 := VarSetCapacity
			}
			if (SearchLoopcountFailed2>60)
			{
				LogShow("重複60次未能偵查到目標，撤退")
				TargetFailed := VarSetCapacity
				TargetFailed2 := VarSetCapacity
				TargetFailed3 := VarSetCapacity
				TargetFailed4 := VarSetCapacity
				TargetFailed5 := VarSetCapacity
				TargetFailed6 := VarSetCapacity
				Plane_TargetFailed1 := VarSetCapacity
				BossFailed := VarSetCapacity
				BulletFailed := VarSetCapacity
				QuestFailed := VarSetCapacity
				SearchLoopcount := VarSetCapacity
				SearchLoopcountFailed2 := VarSetCapacity
				C_Click(794, 714)
				sleep 200
				C_Click(781, 545)
			}
		}
		SearchLoopcount++
		if (!DwmCheckcolor(758, 699, 12996946) and !DwmCheckcolor(172, 68, 14085119))
		{
			Break
		}
	} 
}
else if (WeighAnchor1 and WeighAnchor2) ;在出擊選擇關卡的頁面
{
	if (DwmCheckcolor(1063, 684, 16774127) and DwmCheckcolor(928, 681, 9220764)) ;委託任務已完成
	{
		LogShow("執行軍事委託任務！")
		C_Click(1006, 712)
		Loop, 60
		{
			sleep 500
		} Until DwmCheckcolor(135, 58, 15725567)
		DelegationMission()
		sleep 1000
		Loop, 5
		{
			if (DwmCheckcolor(167, 64, 15201279))
			{
				C_Click(58, 92)
				sleep 1500
			}
		}
	}
	if (DailyGoalSub and DailyDone<1)
	{
		iniread, Yesterday, settings.ini, Battle, Yesterday
		FormatTime, Today, ,dd
		Formattime, Checkweek, , Wday ;星期的天數 (1 – 7). 星期天為 1.
		if (Yesterday=Today)
		{
			DailyDone := 1
		}
		else if ((Checkweek=1 or Checkweek=4 or Checkweek=7) and DailyGoalRed) ;
		{
			DailyDone := 0
		}
		else if ((Checkweek=1 or Checkweek=3 or Checkweek=6) and DailyGoalGreen) ;
		{
			DailyDone := 0
		}
		else if ((Checkweek=1 or Checkweek=2 or Checkweek=5) and DailyGoalBlue) ;
		{
			DailyDone := 0
		}
		else 
		{
			DailyDone := 1
		}
		if (DailyDone=0)
		{
			if (DwmCheckcolor(145, 686, 16777215) and DwmCheckcolor(132, 61, 14085119) and DwmCheckcolor(750, 717, 10864623))
			{ ;如果在出擊頁面檢查到每日還沒執行
				LogShow("執行每日任務！")
				Loop
				{
					if (DwmCheckcolor(145, 686, 16777215) and DwmCheckcolor(132, 61, 14085119) and DwmCheckcolor(750, 717, 10864623))  ;如果在出擊頁面檢查到每日還沒執行
					{
						C_Click(826, 709) ;嘗試進入每日頁面
						sleep 3000
					}
					if (DwmCheckcolor(30, 395, 16777215) and DwmCheckcolor(154, 61, 15201279))
					{
						Break ;成功進入每日頁面
					}
				}
			Goto, DailyGoalSub
			}
		}
		else
		{
			DailyDone := 1
		}
	}
	if (OperationSub and OperationDone<1)
	{
		iniread, OperationYesterday, settings.ini, Battle, OperationYesterday
		FormatTime, OperationToday, ,dd
		if (OperationYesterday=OperationToday)
		{
			OperationDone := 1
		}
		else
		{
			if (DwmCheckcolor(145, 686, 16777215) and DwmCheckcolor(132, 61, 14085119) and DwmCheckcolor(1130, 686, 16773086))
			{ ;如果在出擊頁面檢查到演習還沒執行
				LogShow("自動執行演習！")
				Loop
				{
					if (DwmCheckcolor(145, 686, 16777215) and DwmCheckcolor(132, 61, 14085119) and DwmCheckcolor(1130, 686, 16773086))  ;如果在出擊頁面檢查到演習還沒執行
					{
						C_Click(1177, 706) ;嘗試進入演習頁面
						sleep 3000
					}
					if (DwmCheckcolor(137, 61, 15201279) and DwmCheckcolor(170, 69, 14610431)) ;左上"演習"
					{
						Break ;成功進入每日頁面
					}
				}
			Goto, OperationSub
			}
		}
	}
	if (BattleTimes) ;如果有勾選出擊N輪
	{
		if (WeighAnchorCount>=BattleTimes2 or BattleTimes2=0) ;如果已達出擊次數
		{
			textshow = 已出擊 %WeighAnchorCount% 輪，強制休息。
			WeighAnchorCount := VarSetCapacity
			LogShow(textshow)
			sleep 1000
			StopAnchor := 1
			C_Click(1229, 71) ;回首頁
			return
		}
	}
	if (StopBattleTime) ;勾選 " 每出擊N輪
	{
		if (StopBattleTimeCount>=StopBattleTime2)
		{
			StopAnchor := 1
			textshow = ☆☆ 已出擊 %StopBattleTimeCount% 輪，休息 %StopBattleTime3% 分鐘。 ☆☆
			LogShow(textshow)
			StopBattleTimeCount := VarSetCapacity
			StopBattleTime3ms := StopBattleTime3*60*1000
			Settimer, clock, -%StopBattleTime3ms%
			C_Click(1229, 71) ;回首頁
			sleep 5000
			return
		}
	}
	if (WeighAnchorCount>=8)
	{
		WeighAnchorCount := VarSetCapacity
		C_Click(1229, 71) ;回首頁 (檢查一些在首頁才會有的功能)
		sleep 2000
		return
	}
	bulletFailed := 1 ;進去關卡第一輪不拿彈藥
	StopBattleTimeCount++ ;每出擊N場修及的判斷次數
	WeighAnchorCount++ ;判斷目前出擊次數
	sleep 1000 ;判斷現在位於第幾關 1 2 3 4 5 6 7 8 9 
	Chapter1 := DwmCheckcolor(221, 523, 16777215)  ;第一關 1-1
	Chapter2 := DwmCheckcolor(887, 533, 16777215) ;第二關 2-1
	Chapter3 := DwmCheckcolor(453, 296, 16777215) ;第三關 3-1
	Chapter4 := DwmCheckcolor(292, 372, 16777215) ;第四關 4-1
	Chapter5 := DwmCheckcolor(292, 434, 16777215) ;第五關 5-1
	Chapter6 := DwmCheckcolor(988, 575, 16777215) ;第六關 6-1
	Chapter7 := DwmCheckcolor(279, 558, 16777215) ;第七關 7-1
	Chapter8 := 0
	Chapter9 := 0
	Chapter10 := 0
	Chapter11 := 0
	Chapter12 := 0
	Chapter13 := 0
	ChapterEvent1 := DwmCheckcolor(500, 248, 16777215) ;14 活動：紅染1 A1
	ChapterEvent2 := DwmCheckcolor(421, 588, 16777215) ;15 活動：紅染2 B1
	ChapterEventSP := DwmCheckcolor(530, 263, 16777215) ; 16 活動：努力、希望和計畫
	ChapterFailed := 1
	array := [Chapter1, Chapter2,Chapter3, Chapter4, Chapter5, Chapter6, Chapter7, Chapter8, Chapter9, Chapter10, Chapter11, Chapter12, Chapter13, ChapterEvent1,ChapterEvent2, ChapterEventSP, ChapterFailed]
	Chapter := VarSetCapacity
	Loop % array.MaxIndex()
	{
		this_Chapter := array[A_Index]
		Chapter++
		if (this_Chapter=1)
		{
			break
		}
	}
	if (AnchorChapter=Chapter) 
	{
		;~ LogShow("畫面已經在主線地圖") 
	}
	else if (Chapter=14 or Chapter=15) and (AnchorChapter="紅染1" or AnchorChapter="紅染2")
	{
		;~ LogShow("畫面已經在紅染地圖")
	}
	else if (Chapter=16) and (AnchorChapter="S.P.")
	{
		;~ LogShow("畫面已經在S.P.地圖") 
	}
	else if (Chapter=14 or Chapter=15 or Chapter=16)
	{
		C_Click(60, 90)
	}
	else if (Chapter=array.MaxIndex())
	{
		LogShow("選擇章節時發生錯誤2")
	}
	else
	{
		;~ LogShow("1111")
		ClickSide := (AnchorChapter-Chapter) ; 負數點右邊 正數點左邊
		ClickCount := abs(AnchorChapter-Chapter)
		if (ClickSide>0)
		{
			Loop, %ClickCount%
			{
			C_Click(1224,412)
			sleep 200
			}
		}
		else
		{
			Loop, %ClickCount%
			{
			C_Click(52,412)
			sleep 200
			}
		}
	}
	if AnchorMode=停用
	{
		StopAnchor := 1
		LogShow("選擇地圖已停用，停止出擊到永遠。")
		sleep 1000
		C_Click(1228, 68)
		sleep 1000
		Loop, 20
		{
			if (DwmCheckcolor(132, 54, 14085119) and DwmCheckcolor(160, 72, 14085119)) ;如果還在出擊頁面
			{
				C_Click(1228, 68)
			}
			else if (DwmCheckcolor(12, 201, 16777215)) ;成功回到首頁
			{
				Break
			}
			sleep 350
		}
		return
	}
	else if AnchorMode=普通
	{
		LogShow("選擇攻略地圖，難度：普通")
		if (DwmCheckcolor(58, 681, 16777215) or DwmCheckcolor(51, 684, 16777215)) ;一般關卡的困難 OR 活動難度的困難
		{
			;不做任何事
		}
		else if (DwmCheckcolor(58, 681, 7047894) or DwmCheckcolor(51, 684, 6523606))
		{
			C_Click(99,703)
			sleep 1000
			if !(DwmCheckcolor(58, 681, 16777215) or DwmCheckcolor(51, 684, 16777215))
			{
				LogShow("難度選擇為普通時發生錯誤1")
				return
			}
		}
		else if (AnchorChapter="S.P.")
		{
			;不做任何事 (SP似乎沒有分難度)
		}
		else 
		{
			LogShow("難度選擇為普通時發生錯誤2")
			return
		}
	}
	else if AnchorMode=困難
	{
		LogShow("選擇攻略地圖，難度：困難")
		if (DwmCheckcolor(58, 681, 7047894) or DwmCheckcolor(51, 684, 6523606))
		{
			;不做任何事
		}
		else if (DwmCheckcolor(58, 681, 16777215) or DwmCheckcolor(51, 684, 16777215))
		{
			C_Click(99,703)
			sleep 1000
			if !(DwmCheckcolor(58, 681, 7047894) or DwmCheckcolor(51, 684, 6523606))
			{
				LogShow("難度選擇為困難時發生錯誤1")
				return
			}
		}
		else 
		{
			LogShow("難度選擇為困難時發生錯誤2")
			return
		}
	}
	sleep 500
	Chaptermessage = ——選擇關卡： 第 %AnchorChapter% 章 第 %AnchorChapter2% 節。——
	LogShow(Chaptermessage)
	if (AnchorChapter=1 and AnchorChapter2=1) ; 選擇關卡 1-1
	{
		if (DwmCheckcolor(220, 527, 16777215))
		{
			C_Click(221,526)
		}
	}
	else if (AnchorChapter=1 and AnchorChapter2=2) ; 選擇關卡 1-2
	{
		if (DwmCheckcolor(509, 341, 16777215))
		{
			C_Click(510,342)
		}
	}
	else if (AnchorChapter=1 and AnchorChapter2=3) ; 選擇關卡 1-3
	{
		if (DwmCheckcolor(712, 599, 16777215))
		{
			C_Click(713,600)
		}
	}
	else if (AnchorChapter=1 and AnchorChapter2=4) ; 選擇關卡 1-4
	{
		if (DwmCheckcolor(861, 246, 16777215))
		{
			C_Click(862,247)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=1) ; 選擇關卡 2-1
	{
		if (DwmCheckcolor(867, 531, 16777215))
		{
			C_Click(868,530)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=2) ; 選擇關卡 2-2
	{
		if (DwmCheckcolor(802, 261, 16777215))
		{
			C_Click(803,262)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=3) ; 選擇關卡 2-3
	{
		if (DwmCheckcolor(341, 345, 16777215))
		{
			C_Click(341,346)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=4) ; 選擇關卡 2-4
	{
		if (DwmCheckcolor(437, 619, 16777215))
		{
			C_Click(438,620)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=1) ; 選擇關卡3-1
	{
		if (DwmCheckcolor(476, 292, 16777215))
		{
			C_Click(477,293)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=2) ; 選擇關卡3-2
	{
		if (DwmCheckcolor(304, 572, 16777215))
		{
			C_Click(305,573)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=3) ; 選擇關卡3-3
	{
		if (DwmCheckcolor(866, 208, 16777215))
		{
			C_Click(867,209)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=4) ; 選擇關卡3-4
	{
		if (DwmCheckcolor(690, 432, 16777215))
		{
			C_Click(691,433)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=1) ; 選擇關卡4-1
	{
		if (DwmCheckcolor(311, 377, 16777215))
		{
			C_Click(312,378)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=2) ; 選擇關卡4-2
	{
		if (DwmCheckcolor(476, 540, 16777215))
		{
			C_Click(477,541)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=3) ; 選擇關卡4-3
	{
		if (DwmCheckcolor(878, 618, 16777215))
		{
			C_Click(879,619)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=4) ; 選擇關卡4-4
	{
		if (DwmCheckcolor(855, 360, 16777215))
		{
			C_Click(856,361)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=1) ; 選擇關卡5-1
	{
		if (DwmCheckcolor(315, 437, 16777215))
		{
			C_Click(516,438)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=2) ; 選擇關卡5-2
	{
		if (DwmCheckcolor(906, 607, 16777215))
		{
		C_Click(907,608)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=3) ; 選擇關卡5-3
	{
		if (DwmCheckcolor(788, 435, 16777215))
		{
			C_Click(789,436)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=4) ; 選擇關卡5-4
	{
		if (DwmCheckcolor(642, 284, 16777215))
		{
			C_Click(623,285)
		}
	}
	else if (AnchorChapter=6 and AnchorChapter2=1) ; 選擇關卡6-1
	{
		if (DwmCheckcolor(965, 573, 16777215))
		{
			C_Click(966,574)
		}
	}
	else if (AnchorChapter=6 and AnchorChapter2=2) ; 選擇關卡6-2
	{
		if (DwmCheckcolor(777, 416, 16777215))
		{
			C_Click(778,417)
		}
	}
	else if (AnchorChapter=6 and AnchorChapter2=3) ; 選擇關卡6-3
	{
		if (DwmCheckcolor(477, 289, 16777215))
		{
			C_Click(478,290)
		}
	}
	else if (AnchorChapter=6 and AnchorChapter2=4) ; 選擇關卡6-4
	{
		if (DwmCheckcolor(373, 498, 16777215))
		{
			C_Click(374,499)
		}
	}
	else if (AnchorChapter=7 and AnchorChapter2=1) ; 選擇關卡7-1
	{
		if (DwmCheckcolor(279, 558, 16777215))
		{
			C_Click(280,559)
		}
	}
	else if (AnchorChapter=7 and AnchorChapter2=2) ; 選擇關卡7-2
	{
		if (DwmCheckcolor(533, 255, 16777215))
		{
			C_Click(534,256)
		}
	}
	else if (AnchorChapter=7 and AnchorChapter2=3) ; 選擇關卡7-3
	{
		if (DwmCheckcolor(875, 356, 16777215))
		{
			C_Click(876,357)
		}
	}
	else if (AnchorChapter=7 and AnchorChapter2=4) ; 選擇關卡7-4
	{
		if (DwmCheckcolor(1018, 521, 16777215))
		{
			C_Click(1019,522)
		}
	}
	else if (AnchorChapter="紅染1" or AnchorChapter="紅染2")
	{
		if (DwmCheckcolor(1238, 246, 16760369) and (AnchorChapter="紅染1" or AnchorChapter="紅染2"))
		{
			C_Click(1201, 226)
			sleep 2000
		}
		else if (ChapterEvent1 and AnchorChapter="紅染2") ;
		{
			C_Click(1223, 411)
			sleep 2000
		}
		else if (ChapterEvent2 and AnchorChapter="紅染1") ;
		{
			C_Click(48, 409)
			sleep 2000
		}
		if (AnchorChapter="紅染1" and AnchorChapter2=1)
		{
			if (DwmCheckcolor(500, 249, 16777215))
			{
				C_Click(501,250)
			}
		}
		else if (AnchorChapter="紅染1" and AnchorChapter2=2)
		{
			if (DwmCheckcolor(798, 594, 16777215))
			{
				C_Click(799,595)
			}
		}
		else if (AnchorChapter="紅染1" and AnchorChapter2=3)
		{
			if (DwmCheckcolor(963, 326, 16777215))
			{
				C_Click(964,325)
			}
		}
		else if (AnchorChapter="紅染1" and AnchorChapter2=4)
		{
			LogShow("紅染1篇沒有第四關")
		}
		else if (AnchorChapter="紅染2" and AnchorChapter2=1)
		{
			if (DwmCheckcolor(421, 591, 16777215))
			{
				C_Click(422,592)
			}
		}
		else if (AnchorChapter="紅染2" and AnchorChapter2=2)
		{
			if (DwmCheckcolor(935, 573, 16777215))
			{
				C_Click(936,574)
			}
		}
		else if (AnchorChapter="紅染2" and AnchorChapter2=3)
		{
			if (DwmCheckcolor(774, 297, 16777215))
			{
				C_Click(775,298)
			}
		}
	}
	else if (AnchorChapter="S.P.")
	{
		if (DwmCheckcolor(1199, 234, 16772054) and AnchorChapter="S.P.")
		{
			C_Click(1201, 226) ;畫面在主線地圖時，點擊特殊作戰進入SP地圖
			sleep 2000
		}
		if (AnchorChapter="S.P." and AnchorChapter2=1)
		{
			if (DwmCheckcolor(530, 265, 16777215))
			{
				C_Click(531,264) ;點擊SP1
			}
		}
		else if (AnchorChapter="S.P." and AnchorChapter2=2)
		{
			if (DwmCheckcolor(819, 395, 16777215))
			{
				C_Click(820,394) ;點擊SP2
			}
		}
		else if (AnchorChapter="S.P." and AnchorChapter2=3)
		{
			if (DwmCheckcolor(649, 601, 16777215))
			{
				C_Click(650,600) ;點擊SP3
			}
		}
	}
	else 
	{
		LogShow("選擇關卡時發生錯誤！")
		sleep 2000
		return
	}
	SwitchParty := 0 ;BOSS換隊
	;~ ChapterCheck := ("0,0,0")
	;~ ChapterCheckArray := StrSplit(ChapterCheck, ",")
	;~ msgbox % ChapterCheckArray.MaxIndex()
	;~ Loop % ChapterCheckArray.MaxIndex()
	;~ {
		;~ this_Chapter := ChapterCheckArray[A_Index]
		;~ Chapter++
		;~ if (this_Chapter=1)
		;~ {
			;~ msgbox, 目前位於：第 %Chapter% 關
			;~ Chapter := VarSetCapacity
			;~ break
		;~ }
	;~ }
	;~ LogShow("ERROR")
}
Try
{
	battlevictory()
	Battle()
	ChooseParty(StopAnchor)
	ToMap()
	shipsfull(StopAnchor)
	BackAttack()
	Message_Story()
	Battle_End()
	UnknowWife()
	Message_Normal()
	Message_Center()
	NewWife()
	GetCard()
	GetItem2()
	GetItem()
	battlevictory()
	GuLuGuLuLu()
	CloseEventList()
	SystemNotify()
	ClickFailed()
	AutoLoginIn()
}
return

;~ F3::
;~ pBitmap := Gdip_BitmapFromHWND(UniqueID), Gdip_GetDimensions(pBitmap, w, h)
;~ MapX1 := 0, MapY1 := 0, MapX2 := 1000, MapY2 := 745
;~ Random, SearchDirection, 1, 8
;~ g := Gdip_PixelSearch(pBitmap, 4287894561,  x,  y)
;~ g := Gdip_PixelSearch2( x,  y, 0, 0, MapX2, MapY2, 4286845976, 0)
;~ g := GdipImageSearch2(x, y, "img/Map_Lower.png", 0, SearchDirection, MapX1, MapY1, MapX2, MapY2)
;~ tooltip x%x% y%y% g%g%
;~ C_Click(x,y)
;~ return

BtnCheck:
    Withdraw := DwmCheckcolor(772, 706, 12996946)  ; 撤退
    Switchover := DwmCheckcolor(1025, 697,9212581)  ;Checkcolor(1025, 697, 4287402661) 切換
    Offensive := DwmCheckcolor(1234, 703, 16239426) ;Checkcolor(1234, 703, 4294429506)
    WeighAnchor1 := DwmCheckcolor(132, 54, 14085119)  ;Checkcolor(748, 716, 4289054703) ;左上角 出 
    WeighAnchor2 := DwmCheckcolor(160, 73, 14085119) ;Checkcolor(942, 680, 4286291604) ;左上角 擊
return 

OperationSub:
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
LogShow("開始演習。")
Loop
{
	sleep 1000
	if (DwmCheckcolor(138, 61, 15201279) and DwmCheckcolor(154, 71, 14085119))  ;演習介面隨機
	{
		if (Operationenemy="最弱的")
		{
			Capture2(234, 298, 293, 322)   ;第一位敵人主力
			enemy1 := OCR("capture/OCRTemp.png")
			Capture2(481, 298, 538, 322)   ;第二位敵人主力
			enemy2 := OCR("capture/OCRTemp.png")			
			Capture2(720, 298, 783, 322)  ;第三位敵人主力
			enemy3 := OCR("capture/OCRTemp.png")
			Capture2(963, 298, 1027, 322) ;第四位敵人主力
			enemy4 := OCR("capture/OCRTemp.png")
			FileDelete, capture\OCRTemp.png
			Min_enemy := MinMax("min",enemy1,enemy2,enemy3,enemy4)
			enemytext = 敵方戰力：%enemy1%, %enemy2%, %enemy3%, %enemy4%.
			LogShow(enemytext)
			;~ msgbox, enemy1=%enemy1%`nenemy2=%enemy2%`nenemy3=%enemy3%`nenemy4=%enemy4%`nMin_enemy=%Min_enemy%
			if (Min_enemy=enemy1)
			{
				C_Click(218, 280)
			} 
			else if (Min_enemy=enemy2)
			{
				C_Click(462, 280)
			}
			else if (Min_enemy=enemy3)
			{
				C_Click(708, 280)
			}
			else if (Min_enemy=enemy4)
			{
				C_Click(940, 280)
			}
			enemy1 := VarSetCapacity
			enemy2 := VarSetCapacity
			enemy3 := VarSetCapacity
			enemy4 := VarSetCapacity
			Min_enemy := VarSetCapacity
		}
		else if (Operationenemy="隨機的")
		{
			LogShow("選擇隨機的敵方艦隊")
			Random, clickpos, 1, 4 ;隨機挑選敵人
			if clickpos=1
			{
				C_Click(226, 286)
				sleep 1000
			}
			else if clickpos=2
			{
				C_Click(453, 286)
				sleep 1000
			}
			else if clickpos=3
			{
				C_Click(700, 286)
				sleep 1000
			}
			else if clickpos=4
			{
				C_Click(941, 286)
				sleep 1000
			}
		}
		else if (Operationenemy="最左邊")
		{
			C_Click(226, 286)
			sleep 1000
		}
		else if (Operationenemy="最右邊")
		{
			C_Click(941, 286)
			sleep 1000
		}
	}
	else if (DwmCheckcolor(664, 231, 16777215) and DwmCheckcolor(752, 246, 16777215) and DwmCheckcolor(728, 604, 16238402)) ;演習對手訊息
	{
		C_Click(647, 608)
		Loop
		{
			sleep 500
		} until DwmCheckcolor(1233, 650, 16777215)
	}
	else if (DwmCheckcolor(133, 59, 15200255) and DwmCheckcolor(152, 65, 14610431) and DwmCheckcolor(169, 63, 15201279)) ;編隊畫面
	{
		LogShow("演習出擊。")
		C_Click(1089, 689)
		if (DwmCheckcolor(529, 359, 16249847))
		{
			LogShow("演習結束！")
			Iniwrite, %OperationToday%, settings.ini, Battle, OperationYesterday
			C_Click(1239, 72) ;回到首頁
			break
		}
		sleep 3000
	}
	else if (DwmCheckcolor(208, 58, 14085119) and DwmCheckcolor(198, 62, 14085119) and DwmCheckcolor(102, 663, 16239426)) ;誤點商店
	{
		C_Click(57, 90) ;誤點商店，自動離開
	}
	Try
	{
		battlevictory()
		Battle_Operation()
		ChooseParty(StopAnchor)
		ToMap()
		shipsfull(StopAnchor)
		BackAttack()
		Message_Story()
		Battle_End()
		UnknowWife()
		Message_Normal()
		Message_Center()
		NewWife()
		GetCard()
		GetItem2()
		GetItem()
		battlevictory()
		GuLuGuLuLu()
		CloseEventList()
		SystemNotify()
		AutoLoginIn()
	}
}
return

startemulatorSub:
run, dnconsole.exe launchex --index %emulatoradb% --packagename "com.hkmanjuu.azurlane.gp" , %ldplayer%, Hide
sleep 10000
Winget, UniqueID,, %title%
Allowance = %AllowanceValue%
Global UniqueID, Allowance
Loop
{
	if (DwmCheckcolor(1259, 695, 16777215) and DwmCheckcolor(1240, 700, 22957) and DwmCheckcolor(1, 35, 2633790))
	{
		LogShow("位於遊戲首頁，自動登入")
		sleep 5000
		C_Click(642, 420)
		sleep 5000
	}
	if (DwmCheckcolor(144, 93, 16777215) and DwmCheckcolor(183, 93, 16777215) and DwmCheckcolor(1222, 152, 16241474) and DwmCheckcolor(1, 35, 2633790))
	{
		LogShow("出現系統公告，不再顯示")
		if !(DwmCheckcolor(212, 67, 2171953))
		{
			C_Click(994, 110)
		}
		C_Click(1193, 103)
	}
	if (DwmCheckcolor(296, 210, 16777215) and DwmCheckcolor(453, 242, 16777215) and DwmCheckcolor(789, 533, 15176225)) ;更新提示
	{
		LogShow("開始自動更新")
		C_Click(786, 534)
	}
	if (DwmCheckcolor(894, 422, 16777215) and DwmCheckcolor(12, 200, 16777215) and DwmCheckcolor(998, 63, 16729459))
	{
		LogShow("LoginBreak")
		break
	}
	GetItem2()
	GetItem()
	CloseEventList()
	sleep 1000
	WinMove,  %title%, , , , 1318, 758
}
iniread, Autostart, settings.ini, OtherSub, Autostart, 0
if (Autostart)
{
	iniwrite, 0, settings.ini, OtherSub, Autostart
	goto, start
}
else
{
	goto, start
}
return



DailyGoalSub:
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
if  (DailyGoalSub and DailyDone<1)
{
	iniread, Yesterday, settings.ini, Battle, Yesterday
	FormatTime, Today, ,dd
	if (Yesterday=Today)
	{
		DailyDone := 1
		LogShow("已完成每日任務。")
		Loop
		{
			if (DwmCheckcolor(30, 397, 16777215) and DwmCheckcolor(1252, 397, 16777215) and DwmCheckcolor(170, 64, 15201279)) ;如果在每日頁面
			{
				LogShow("返回主選單。")
				C_Click(1242, 69)
			}
			if (DwmCheckcolor(12, 201, 16777215) and DwmCheckcolor(1, 35, 2633790)) ;如果成功返回主選單 
			{
				Break
			}
		}
	}
	else
	{
		DailyGoalSub2:
		Formattime, Checkweek, , Wday ;星期的天數 (1 – 7). 星期天為 1.
		Loop
		{
			 if (DwmCheckcolor(384, 192, 16768825) and DwmCheckcolor(397, 190, 16768825))
			{
				;~ A_Swipe(652,166,652,610)
				sleep 1000
				if ((Checkweek=1 or Checkweek=4 or Checkweek=7) and DailyGoalRedAction=1) or ((Checkweek=3 or Checkweek=6) and DailyGoalGreenAction=1) or ((Checkweek=2 or Checkweek=5) and DailyGoalBlueAction=1)
				{
					C_Click(721, 262)
				}
				else if ((Checkweek=1 or Checkweek=4 or Checkweek=7) and DailyGoalRedAction=2) or ((Checkweek=3 or Checkweek=6) and DailyGoalGreenAction=2) or ((Checkweek=2 or Checkweek=5) and DailyGoalBlueAction=2)
				{
					C_Click(721, 401)
				}
				else if ((Checkweek=1 or Checkweek=4 or Checkweek=7) and DailyGoalRedAction=3) or ((Checkweek=3 or Checkweek=6) and DailyGoalGreenAction=3) or ((Checkweek=2 or Checkweek=5) and DailyGoalBlueAction=3)
				{
					C_Click(721, 552)
				}
				else if ((Checkweek=1 or Checkweek=4 or Checkweek=7) and DailyGoalRedAction=4) or ((Checkweek=3 or Checkweek=6) and DailyGoalGreenAction=4) or ((Checkweek=2 or Checkweek=5) and DailyGoalBlueAction=4)
				{
					C_Click(756, 552)
				}
				if (DwmCheckcolor(477, 361, 15724527))
				{		
					if (Checkweek=1 and CheckweekCount<1 and DailyGoalSunday) ;如果是禮拜天  (打左邊)
					{
						CheckweekCount := 1
						Checkweek := 2
						C_Click(55, 90)
						sleep 500
						C_Click(367, 376)
						C_Click(645, 414)
						sleep 1000
					}
					else if (Checkweek=2 and CheckweekCount=1 and DailyGoalSunday) ;如果是禮拜天  (打右邊)
					{
						CheckweekCount := 2
						Checkweek := 3
						C_Click(55, 90)
						sleep 500
						C_Click(889, 403)
						C_Click(907, 416)
						C_Click(627, 410)
						sleep 1000
					}
					else
					{
						Logshow("每日任務次數用盡，返回主選單。")
						Loop, 20
						{
							if (DwmCheckcolor(169, 59, 16251903)) ;檢查每日頁面左上角 每日的日
							{
								C_Click(1242, 66)
								sleep 2000
							}
							if (DwmCheckcolor(12, 200, 16777215)) ;檢查首頁白點
							{
								DailyBreak := 1
								DailyDone := 1
								Logshow("每日任務已結束")
								Break
							}
							sleep 500
						}
						DailyDone := 1
						DailyBreak := 1
					}
				}
				if (DailyBreak=1)
				{
					Break
				}
				sleep 2000
			}
			else if (DwmCheckcolor(1075, 655, 16777215) and DwmCheckcolor(1234, 650, 16777215) and DwmCheckcolor(1222, 656, 16239426))
			{
				if (ChooseDailyParty<1) ;第一次執行時判斷使用第幾隊 寫法偷懶 等有閒再來改
				{
					Logshow("選擇每日艦隊中。")
					sleep 1500
					Loop, 5
					{
						C_Click(39, 372) ;偷懶...不判斷目前第幾隊 直接點左邊5下換回第一艦隊
					}
					if DailyParty=第一艦隊
					{ ;不執行 本來就是第一艦隊
					}
					else if DailyParty=第二艦隊
					{
						C_Click(915, 376)
					}
					else if DailyParty=第三艦隊
					{
						Loop, 2 
						{
						C_Click(915, 376)
						}
					}
					else if DailyParty=第四艦隊
					{
						Loop, 3 
						{
						C_Click(915, 376)
						}
					}
					else if DailyParty=第五艦隊
					{
						Loop, 4 
						{
						C_Click(915, 376)
						}
					}
					ChooseDailyParty := 1
				}
				Logshow("出擊每日任務！")
				C_Click(1147, 667)
				if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(791, 546, 4355509) and DwmCheckcolor(849, 232, 4877741))
				{
					Logshow("老婆心情低落，休息10分鐘。")
					C_Click(496, 543) ;點擊取消
					sleep 600000
					if (DwmCheckcolor(1235, 650, 16250871))
					{
						C_Click(1133, 690) ;點擊出擊
					}
				}
				else if (DwmCheckcolor(543, 358, 16250871) and DwmCheckcolor(543, 364, 15198183))
				{
					Logshow("石油不足，停止每日任務。")
					StopAnchor := 1
					Loop
					{
						if (DwmCheckcolor(133, 56, 15201279) and DwmCheckcolor(133, 56, 15201279)) ;檢查"編隊"
						{
							C_Click(1230, 68) ;返回主選單
						}
						else if (DwmCheckcolor(12, 200, 16777215))
						{
							Break
						}
						sleep 1000
					}
					return
				}
			}
			else if (DwmCheckcolor(30, 395, 16777215) and DwmCheckcolor(1251, 396, 16777215) and DwmCheckcolor(170, 59, 16251903))   ;如果在每日選擇關卡頁面，選中間那個
			{
				C_Click(642, 423)
			}
			else
			{
				Try
				{
					battlevictory()
					Battle()
					ChooseParty(StopAnchor)
					ToMap()
					shipsfull(StopAnchor)
					BackAttack()
					Message_Story()
					Battle_End()
					UnknowWife()
					Message_Normal()
					Message_Center()
					NewWife()
					GetCard()
					GetItem2()
					GetItem()
					battlevictory()
					GuLuGuLuLu()
					CloseEventList()
					SystemNotify()
					AutoLoginIn()
				}
			}
		}
	}
	Iniwrite, %Today%, settings.ini, Battle, Yesterday
	DailyBreak := VarSetCapacity
	ChooseDailyParty := VarSetCapacity
	CheckweekCount := VarSetCapacity
}
return

MissionSub:
if (MissionCheck and MainCheck) ;如果有任務獎勵
{
    LogShow("發現任務獎勵！")
	sleep 500
    C_Click(883, 725) ;點擊任務按紐
	Loop
	{
		sleep 500
	} until DwmCheckcolor(51, 199, 16243588) ;等待進入任務界面 (偵測金色的"全部")
    Loop
    {
        if (DwmCheckcolor(1070, 91, 13019697) and DwmCheckcolor(1198, 117, 12410186)) ;全部領取任務獎勵
        {
            LogShow("領取全部任務獎勵！")
            C_Click(1068, 63)
        }
        else if (DwmCheckcolor(594, 223, 16766794) and DwmCheckcolor(1198, 117, 12410186)) ;領取第一個任務獎勵
        {
            C_Click(1136, 187)
        }
		else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215)) ;獲得道具
		{
			C_Click(636, 91)
		}
        else if (GdiGetPixel(751, 205)=4286894079 or GdiGetPixel(749, 278)=4287419391 ) ;確認獎勵
        {
            C_Click(641, 597)
        }
        else if (DwmCheckcolor(71, 606, 16777215) and DwmCheckcolor(53, 693, 16777215) and DwmCheckcolor(1108, 656, 16777215)) ;獲得腳色
        {
            C_Click(604, 349)
        }
        else if (GdiGetPixel(915, 232)=4291714403 and GdiGetPixel(815, 232)=4283594165) ;是否鎖定該腳色(否)
        {
            C_Click(489, 546)
        }
		else if (DwmCheckcolor(459, 544, 16777215) and DwmCheckcolor(811, 546, 16777215) and DwmCheckcolor(413, 225, 16777215)) ;是否提交物品(是)
        {
            C_Click(811, 546)
        }
		else if (DwmCheckcolor(1273, 67, 10858165)) ;劇情
        {
            C_Click(811, 546)
        }
        else if (DwmCheckcolor(1147, 183, 15198183) or DwmCheckcolor(1140, 395, 9718090))
        {
            LogShow("獎勵領取結束，返回主選單！")
            C_Click(1227, 69)
			break
        }
        sleep 400
    } 
}
return

AcademySub:
if (AcademyDone<1)
{
	ShopX1 := 100, ShopY1 := 100, ShopX2 := 1250, ShopY2 := 650
	LogShow("執行學院任務！")
	sleep 500
	C_Click(580, 727)
	Loop ;等待進入學院
	{
		sleep 500
		Academycount++
		if (DwmCheckcolor(135, 72, 14085119) and DwmCheckcolor(169, 70, 14609407))
		{
			sleep 1200
			break
		}
		else if (Academycount=200)
		{
			Logshow("AcademySub Error")
			return ;不再執行
		}
	}
	Academycount := VarSetCapacity
	Loop
	{
		 if (GdipImageSearch2(x, y, "img/AcademyOil.png", 100, 8, 95, 298, 542, 723) and AcademyOil and GetOil<1) ;
		{
			LogShow("發現石油，高雄發大財！")
			GetOil := 1
			C_Click(x, y)
		}
		if (GdipImageSearch2(x, y, "img/AcademyCoin.png", 100, 8, 450, 411, 843, 748) and AcademyCoin and fullycoin<1) ;
		{
			LogShow("發現金幣，高雄發大財！")
			C_Click(x, y)
			if (DwmCheckcolor(437, 361, 15724527))
			{
				LogShow("高雄的錢…真的太多了…")
				fullycoin := 1
			}
		}
		if (DwmCheckcolor(1132, 213, 16774127) and AcademyShop and AcademyShopDone<1) ;商店出現 "！" DwmCheckcolor(1132, 213, 16774127)
		{
			LogShow("商店街發大財")
			C_Click(1113, 210)
			Loop, 20
			{
				sleep 500
			} until DwmCheckcolor(101, 662, 16239426) ;檢查是否進入商店
			ShopX1 := 430, ShopY1 := 150, ShopX2 := 1250, ShopY2 := 620
			Loop
			{
				if (GdipImageSearch2(x, y, "img/SkillBook_ATK.png", 115, 8, ShopX1, ShopY1, ShopX2, ShopY2) and SkillBook_ATK and AtkCoin<1) ;如果有攻擊課本
				{
					SkillBookPos := dwmgetpixel(x,y)
					LogShow("購買艦艇教材-攻擊(金幣)")
					Loop, 20
					{
						if (SkillBookPos=dwmgetpixel(x,y))
						{
							xx := x+10
							yy := y+8
							C_Click(xx,yy) ;點擊課本
						}
						if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;跳出購買訊息
						{
							Random, xx, 713, 863
							Random, yy, 527, 569
							C_Click(xx,yy) ;隨機點擊"兌換"鈕
							sleep 4000
							if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;如果金幣不足
							{
								AtkCoin++
								Random, xx, 414, 527
								Random, yy, 566, 569
								C_Click(xx,yy) ;點擊取消
							}
							Break
						}
						else if buycheck>10
						{
							
						}
						sleep 600
					}
				}
				if (GdipImageSearch2(x, y, "img/SkillBook_DEF.png", 115, 8, ShopX1, ShopY1, ShopX2, ShopY2) and SkillBook_DEF and DefCoin<1) ;如果有防禦課本
				{
					SkillBookPos := dwmgetpixel(x,y)
					LogShow("購買艦艇教材-防禦(金幣)")
					Loop, 20
					{
						if (SkillBookPos=dwmgetpixel(x,y))
						{
							xx := x+10
							yy := y+8
							C_Click(xx,yy) ;點擊課本
						}
						if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;跳出購買訊息
						{
							Random, xx, 713, 863
							Random, yy, 527, 569
							C_Click(xx,yy) ;隨機點擊"兌換"鈕
							sleep 4000
							if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;如果金幣不足
							{
								DefCoin++
								Random, xx, 414, 527
								Random, yy, 566, 569
								C_Click(xx,yy) ;點擊取消
							}
							Break
						}
						sleep 600
					}
				}
				if (GdipImageSearch2(x, y, "img/SkillBook_SUP.png", 115, 8, ShopX1, ShopY1, ShopX2, ShopY2) and SkillBook_SUP and SupCoin<1) ;如果有防禦課本
				{
					SkillBookPos := dwmgetpixel(x,y)
					LogShow("購買艦艇教材-輔助(金幣)")
					Loop, 20
					{
						if (SkillBookPos=dwmgetpixel(x,y))
						{
							xx := x+10
							yy := y+8
							C_Click(xx,yy) ;點擊課本
						}
						if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;跳出購買訊息
						{
							Random, xx, 713, 863
							Random, yy, 527, 569
							C_Click(xx,yy) ;隨機點擊"兌換"鈕
							sleep 4000
							if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;如果金幣不足
							{
								SupCoin++
								Random, xx, 414, 527
								Random, yy, 566, 569
								C_Click(xx,yy) ;點擊取消
							}
							Break
						}
						sleep 600
					}
				}
				if (GdipImageSearch2(x, y, "img/Cube.png", 115, 8, ShopX1, ShopY1, ShopX2, ShopY2) and Cube and CubeCoin<1) ;如果有心智魔方
				{
					CubePos := dwmgetpixel(x,y)
					LogShow("購買心智魔方(金幣)")
					Loop, 20
					{
						if (CubePos=dwmgetpixel(x,y))
						{
							xx := x+10
							yy := y+8
							C_Click(xx,yy) ;點擊魔方
						}
						if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;跳出購買訊息
						{
							Random, xx, 713, 863
							Random, yy, 527, 569
							C_Click(xx,yy) ;隨機點擊"兌換"鈕
							sleep 4000
							if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(414, 225, 16777215)) ;如果金幣不足
							{
								SupCoin++
								Random, xx, 414, 527
								Random, yy, 566, 569
								C_Click(xx,yy) ;點擊取消
							}
							Break
						}
						sleep 600
					}
				}
				ShopCount++
				if (ShopCount>20)
				{
					AcademyShopDone := 1
					ShopCount := VarSetCapacity
					AtkCoin := VarSetCapacity
					DefCoin := VarSetCapacity
					SupCoin := VarSetCapacity
					CubeCoin := VarSetCapacity
					LogShow("購買結束")
					C_Click(59, 91)
					break
				}
				sleep 500
			}
		}
		if (DwmCheckcolor(878, 194, 16774127) and AcademyTactics and learnt<1)
		{
			LogShow("我們真的學不來！")
			C_Click(740, 166) ;點擊學院
			sleep 3000
			Loop, 50
			{
				sleep 500
			}  until (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(811, 548, 16777215) and DwmCheckcolor(460, 541, 16777215) and DwmCheckcolor(414, 225, 16777215))
			C_Click(789, 541)
			Loop
			{
				if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(811, 548, 16777215) and DwmCheckcolor(460, 541, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(750, 538, 4353453))
				{
					LogShow("學習！學習！")
					C_Click(786, 545)
				}
				else if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(661, 548, 16777215) and DwmCheckcolor(608, 550, 16777215)) ;學習的技能已滿等
				{
					C_Click(643, 545) ;點擊確定
				}
				else if (DwmCheckcolor(873, 649, 16777215) and DwmCheckcolor(1151, 654, 16777215) and DwmCheckcolor(915, 666, 16777215)) ;選擇課本頁面
				{
					If (150expbookonly)
					{
						sleep 1000
						if (GdipImageSearch2(x, y, "img/150exp.png", 110, 8, 100, 100, 1200, 650)) ;如果找到150% EXP課本
						{
							LogShow("使用150%經驗課本！")
							xx := x
							yy := y + 30
							C_Click(xx, yy)
							C_Click(1097, 641) ;開始課程
						}
						else
						{
							LogShow("未找到150%經驗課本！")
							C_Click(904, 655) ;取消
						}
					}
					else
					{
						LogShow("開始課程！")
						C_Click(1097, 641)
						if (DwmCheckcolor(556, 358, 16249847))
						{
							LogShow("課本不足，無法學習")
							C_Click(903,653)
						}
					}
				}
				else if (DwmCheckcolor(810, 547, 16777215) and DwmCheckcolor(460, 540, 16777215) and DwmCheckcolor(515, 534, 16777215))
				{
					LogShow("堅持學習！")
					C_Click(789, 541)
				}
				else if (DwmCheckcolor(225, 67, 14085119) and DwmCheckcolor(274, 165, 13022901))
				{
					sleep 5000
					if (DwmCheckcolor(225, 67, 14085119) and DwmCheckcolor(274, 165, 13022901))
					{
					LogShow("學習結束～！")
					learnt := 1
					C_Click(56, 94)
					sleep 1000
					break
					}
				}
			}
		}
		sleep 300
		Academycount++
		if (Academycount>30)
		{
			LogShow("離開學院。")
			GetOil := VarSetCapacity
			Academycount := VarSetCapacity
			fullycoin := VarSetCapacity
			learnt := VarSetCapacity
			AcademyShopDone := VarSetCapacity
			AcademyDone := 1
			Settimer, AcademyClock, -1800000 ;30分鐘後再開始檢查
			Loop, 60
			{
				if (DwmCheckcolor(170, 68, 14610431))
				{
					C_Click(38,92)
				}
				else if (DwmCheckcolor(12, 202, 16777215))
				{
					Break
				}
				GetItem()
				GetItem2()
				CloseEventList()
				sleep 1000
			}
			break
		}
	}
}
return

AcademyClock:
LogShow("AcademyDone := VarSetCapacity")
AcademyDone := VarSetCapacity
return

WinSub:
LDplayerCheck := DwmCheckcolor(1, 35, 2633790)
if !LDplayerCheck
{
	WinGet, Wincheck, MinMax, %title%
	if Wincheck=-1
	{
		LogShow("視窗被縮小，等待自動恢復")
		WinRestore, %title%
	}
	else if Wincheck=1
	{
		WinRestore, %title%
		LogShow("視窗被放大，等待自動恢復")
	}
}
return

ReSizeWindowSub:
GuiControl, disable, ReSizeWindowSub
LogShow("視窗已調整為：1280 x 720")
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
sleep 100
GuiControl, enable, ReSizeWindowSub
return

DormSub:
if (DormDone<1) ;後宅發現任務
{
	DormX1 := 0
	DormY1 := 0
	DormX2 := 1250
	DormY2 := 620
	LogShow("執行後宅任務！")
	sleep 500
	C_Click(723, 727)
	Loop ;等待進入後宅
	{
		DormCount++
		sleep 500
		GuLuGuLuLu()
		if (DwmCheckcolor(30, 88, 14071320) and DwmCheckcolor(109, 578, 16711688))
		{
			sleep 1500
			break
		}
		else if (DwmCheckcolor(724, 670, 16776191) and DwmCheckcolor(565, 124, 16777215))
		{
			C_Click(1110, 657) ;獲得經驗 按確定
		}
		else if (DormCount=200)
		{
			LogShow("DormSub Error")
			return
		}
	}
	DormCount := VarSetCapacity
	Loop
	{
		GuLuGuLuLu() ;如果太過飢餓 
		if (DwmCheckcolor(190, 90, 16711688) and DwmCheckcolor(1206, 115, 16765852) and DwmCheckcolor(665, 687, 16250871))
		{
			C_Click(1261, 464) ;點到訓練自動離開
		}
		else if (DwmCheckcolor(372, 337, 11924356) and DwmCheckcolor(458, 344, 9235282) and DwmCheckcolor(450, 292, 8090037))
		{
			C_Click(1261, 464) ;點到施工自動離開
		}
		else if (DwmCheckcolor(528, 348, 14588572) and DwmCheckcolor(469, 313, 16777215) and DwmCheckcolor(636, 532, 16761682))
		{
			C_Click(617, 115) ;點到換層自動離開
		}
		else if (DwmCheckcolor(292, 295, 15180378) and DwmCheckcolor(701, 565, 16777215) and DwmCheckcolor(726, 329, 14604238))
		{
			C_Click(617, 115) ;點到存糧自動離開
		}
		else if (DwmCheckcolor(1096, 541, 16236114) and DwmCheckcolor(104, 586, 16776191) and DwmCheckcolor(1173, 687, 16761657))
		{
			C_Click(37, 90) ;點到管理自動離開
		}
		else if (DwmCheckcolor(689, 108, 15694195) and DwmCheckcolor(995, 90, 16729459) and DwmCheckcolor(797, 104, 16236114))
		{
			C_Click(1200, 68) ;點到商店自動離開
		}
		else if (DwmCheckcolor(827, 235, 5403053) and DwmCheckcolor(331, 209, 16777215) and DwmCheckcolor(619, 292, 61439))
		{
			C_Click(638, 545) ;點到訊息自動離開
		}
		else if (DwmCheckcolor(218, 51, 0) and DwmCheckcolor(331, 209, 16777215) and DwmCheckcolor(619, 292, 61439))
		{
			C_Click(1299, 646) ;點到分享自動離開
		}
		else if (DwmCheckcolor(724, 670, 16776191) and DwmCheckcolor(565, 124, 16777215))
		{
			C_Click(1110, 657) ;獲得經驗 按確定
		}
		else if (DormFood and DormFoodDone<1)
		{
			FoodX := (550-30)*(DormFoodBar/100)+30
			if (DwmGetpixel(FoodX, 725)<8000000) ;存糧進度條
			{
				FoodCheck := 1
			} else {
				FoodCheck := 0
			}
			;~ FoodCheck := DwmCheckcolor(FoodX, 729, 5394770) 
			FoodCheck2 := DwmCheckcolor(48, 686, 16764746) ;左下黃十字
			if (FoodCheck and FoodCheck2)
			{
				if (DormFoodBar>=50 and DormFoodBar<65)
				{
					DormFoodBar := 66
				}
				else if (DormFoodBar<50 and DormFoodBar>39)
				{
					DormFoodBar := 38
				}
				LogShow("存糧不足，自動補給")
				C_Click(292,718)
				Loop
				{
					Food1 := DwmCheckcolor(402, 406, 6538215)
					Food2 := DwmCheckcolor(559, 403, 6535902)
					Food3 := DwmCheckcolor(711, 401, 5947102)
					Food4 := DwmCheckcolor(838, 380, 5941974)
					SuppilesbartargetX :=  (1020-430)*(DormFoodBar/100)+430  ; x1=430 , x2=1020, y=303
					Suppilesbar := DwmCheckcolor(SuppilesbartargetX, 303, 4869450)
					if (Food1 and Suppilesbar)
					{
						C_Click(358,416) 
					}
					else if (Food2 and Suppilesbar)
					{
						C_Click(519,416)
					}
					else if (Food3 and Suppilesbar)
					{
						C_Click(669,416)
					}
					else if (Food4 and Suppilesbar)
					{
						C_Click(826,416)
					}
					if (!Suppilesbar or (!Food1 and !Food2 and !Food3 and !Food4))
					{
						C_Click(557,119) ;離開餵食
						sleep 500
						DormFoodDone := 1
						break
					}
				}
			}
		}
		if ((GdipImageSearch2(x, y, "img/Dorm_Coin.png", 8, 8, DormX1, DormY1, DormX2, DormY2) or GdipImageSearch2(x, y, "img/Dorm_Coin2.png", 7, 8, DormX1, DormY1, DormX2, DormY2)) and DormCoin and Dorm_Coin<3) 
		{
			LogShow("收成傢俱幣")
			C_Click(x, y)
			Dorm_Coin++
		}
		else if ((GdipImageSearch2(x, y, "img/Dorm_heart.png", 5, 8, DormX1, DormY1, DormX2, DormY2) or GdipImageSearch2(x, y, "img/Dorm_heart2.png", 10, 8, DormX1, DormY1, DormX2, DormY2)) and Dormheart and Dorm_heart<3) 
		{
			LogShow("增加親密度")
			C_Click(x, y)
			Dorm_heart++
		}
		sleep 300
		Dormcount++
		if (Dormcount>25)
		{
			LogShow("離開後宅。")
			Dorm_Coin := VarSetCapacity
			Dorm_heart := VarSetCapacity
			Dormcount := VarSetCapacity
			DormFoodDone := VarSetCapacity
			DormDone := 1
			Settimer, DormClock, -1800000 ;半小時檢查一次
			Loop, 20
			{
				if (DwmCheckcolor(95, 573, 16711680))
				{
					C_Click(38,92)
				}
				else if (DwmCheckcolor(12, 202, 16777215))
				{
					Break
				}
				sleep 1000
			}
			break
		}
	}
}
return

DormClock:
DormDone := VarSetCapacity
LogShow("DormDone := VarSetCapacity")
return

Reload:
Critical
WindowName = Azur Lane - %title%
wingetpos, azur_x, azur_y,, WindowName
iniwrite, %azur_x%, settings.ini, Winposition, azur_x
iniwrite, %azur_y%, settings.ini, Winposition, azur_y
Guicontrol, disable, Reload
Reload
return

whitealbum: ;重要！
Random, num, 1, 15
if (num=1) 
    Guicontrol, ,starttext, 目前狀態：白色相簿什麼的已經無所謂了。
else if (num=2) 
    Guicontrol, ,starttext, 目前狀態：為什麼你會這麼熟練啊！
else if (num=3)   
    Guicontrol, ,starttext, 目前狀態：是我，是我先，明明都是我先來的……
else if (num=4) 
    Guicontrol, ,starttext, 目前狀態：又到了白色相簿的季節。
else if (num=5) 
    Guicontrol, ,starttext, 目前狀態：為什麼會變成這樣呢……
else if (num=6) 
    Guicontrol, ,starttext, 目前狀態：傳達不了的戀情已經不需要了。
else if (num=7) 
    Guicontrol, ,starttext, 目前狀態：你到底要把我甩開多遠你才甘心啊！？
else if (num=8) 
    Guicontrol, ,starttext, 目前狀態：冬馬和雪菜都是好女孩！
else if (num=9) 
    Guicontrol, ,starttext, 目前狀態：夢裡不覺秋已深，余情豈是為他人。
else if (num=10) 
    Guicontrol, ,starttext, 目前狀態：先從我眼前消失的是你吧！？
else if (num=11) 
    Guicontrol, ,starttext, 目前狀態：你就把你能治好的人給治好吧。
else if (num=12) 
    Guicontrol, ,starttext, 目前狀態：我……害怕雪，因為很美麗，所以我害怕。
else if (num=13) 
    Guicontrol, ,starttext, 目前狀態：對不起…我的嫉妒，真的很深啊。
else if (num=14) 
    Guicontrol, ,starttext, 目前狀態：逞強的話語中 卻總藏著一聲嘆息 。
return

DelegationMission() {
	Loop
	{
		sleep 300
	} until DwmCheckcolor(166, 65, 15201279) ;進入委託頁面
	C_Click(53, 191) ;每日
	Loop
	{
		sleep 300
	} until DwmCheckcolor(52, 171, 16777207) ;等待切換到每日頁面
	Loop, 220
	{
		sleep 300
		if (DwmCheckcolor(181, 136, 11358530)) 
		{	
			LogShow("完成委託任務")
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(58, 76, 16777215) or DwmCheckcolor(1215, 74, 16777215))
		{
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(711, 261, 16777215) or DwmCheckcolor(575, 258, 16777215))
		{
			LogShow("每日獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215))
		{
			LogShow("每日獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(443, 205, 8699499) or DwmCheckcolor(443, 205, 6515067)) ;任務都在進行中 or 都沒接到任務
		{
			sleep 1500
			if (DwmCheckcolor(443, 205, 8699499) or DwmCheckcolor(443, 205, 6515067))
			{
				break
			}
		}
	}
	C_Click(51, 283) ;緊急
	Loop
	{
		sleep 300
	} until DwmCheckcolor(53, 295, 16252820) ;等待切換到緊急頁面
	if (DwmCheckcolor(143, 205, 12404034) or DwmCheckcolor(144, 348, 12404034) or DwmCheckcolor(145, 494, 12404034) or DwmCheckcolor(143, 641, 12404034))  ;接獲緊急任務
	{
		sleep 2000
		if (DwmCheckcolor(143, 205, 12404034) or DwmCheckcolor(144, 348, 12404034) or DwmCheckcolor(145, 494, 12404034) or DwmCheckcolor(143, 641, 12404034))  ;接獲緊急任務
		{
			UrgentTask := 1
		}
		else
		{
			UrgentTask := 0
		}
	}
	Loop, 260
	{
		sleep 300
		if (DwmCheckcolor(181, 136, 11358530))
		{
			LogShow("完成委託任務")
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(58, 76, 16777215) or DwmCheckcolor(1215, 74, 16777215))
		{
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(711, 261, 16777215) or DwmCheckcolor(575, 258, 16777215))
		{
			LogShow("緊急獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215))
		{
			LogShow("緊急獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(435, 204, 7042444) or DwmCheckcolor(371, 204, 8699499) or DwmCheckcolor(1141, 385, 9718090) or DwmCheckcolor(145, 202, 12404034) or DwmCheckcolor(433, 205, 6516091)) ;第一個任務為灰階狀態 或 進行中 或沒有接到任務
		{
			sleep 1500
			if (DwmCheckcolor(435, 204, 7042444) or DwmCheckcolor(371, 204, 8699499) or DwmCheckcolor(1141, 385, 9718090) or DwmCheckcolor(145, 202, 12404034) or DwmCheckcolor(433, 205, 6516091))
			{			
				break
			}
		}
	}
	if (UrgentTask=0)
	{
		UrgentTask := VarSetCapacity
	}
	else
	{
		DelegationMission3()
		UrgentTask := VarSetCapacity
	}
	C_Click(53, 191) ;每日
	sleep 300
	DelegationMission3()
	sleep 500
	Loop
	{
		if (DwmCheckcolor(167, 64, 15201279))
		{
		C_Click(62, 91) ;離開
		break
		}
		sleep 500
	}
}

DelegationMission3() ;自動接收軍事任務 . 0=接受失敗 . 1=接受成功 . 2=油耗過高不接受 . 3=進入選單失敗
{
	if (DwmCheckcolor(438, 205, 6515067) or DwmCheckcolor(438, 205, 7042444)) ;第一個任務未開始
	{
		LogShow("Mission1 := 0")
		Mission1 := 0
	}
	if (DwmCheckcolor(435, 352, 6516091) or DwmCheckcolor(435, 352, 7042444)) ;第二個任務未開始
	{
		LogShow("Mission2 := 0")
		Mission2 := 0
	}
	if (DwmCheckcolor(437, 499, 7040379) or DwmCheckcolor(437, 499, 7043468)) ;第三個任務未開始
	{
		LogShow("Mission3 := 0")
		Mission3 := 0
	}
	if (DwmCheckcolor(435, 643, 6516091) or DwmCheckcolor(435, 643, 7043468)) ;第四個任務未開始
	{
		LogShow("Mission4 := 0")
		Mission4 := 0
	}
	if (Mission1 = 0 and !DwmCheckcolor(1082, 62, 9211540) and !DwmCheckcolor(1088, 63, 11383477))
	{
		C_Click(560, 192)
		Mission1 := DelegationMission2()
		if (Mission1=2 and !DwmCheckcolor(1082, 62, 9211540) and !DwmCheckcolor(1088, 63, 11383477) and Mission4=0)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	if (Mission2 = 0 and !DwmCheckcolor(1082, 62, 9211540) and !DwmCheckcolor(1088, 63, 11383477))
	{
		C_Click(560, 332)
		Mission2 := DelegationMission2()
		if (Mission1=2  and Mission4=0)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	if (Mission3 = 0 and !DwmCheckcolor(1082, 62, 9211540) and !DwmCheckcolor(1088, 63, 11383477))
	{
		C_Click(560, 471)
		Mission3 := DelegationMission2()
		if (Mission3=2  and Mission4=0)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	if (Mission4 = 0 and !DwmCheckcolor(1082, 62, 9211540) and !DwmCheckcolor(1088, 63, 11383477))
	{
		C_Click(560, 620)
		Mission4 := DelegationMission2()
		if (Mission4=2)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	Mission1 := VarSetCapacity
	Mission2 := VarSetCapacity
	Mission3 := VarSetCapacity
	Mission4 := VarSetCapacity
}

DelegationMission2()
{
Loop, 30  ;等待選單開啟
	{
		sleep 300
		if (DwmCheckcolor(992, 365, 16777215) and DwmCheckcolor(1149, 366, 16777215))
		{
			loopcount := VarSetCapacity
			break
		}
		loopcount++
		if (loopcount>20)
		{
			;~ Logshow("未能成功進入軍事任務選單")
			e := 3
			loopcount := VarSetCapacity
			return e
		}
	}
	;~ LogShow("成功進入")
	if (DwmCheckcolor(1138, 338, 4870499) or DwmCheckcolor(1108, 166, 16729459) or DwmCheckcolor(772, 165, 3748921)) ;如果耗油是個位數 或 出現寶石 或 出現油田
	{
		C_Click(931, 380)
		if (DwmCheckcolor(1149, 386, 15709770)) ;如果成功推薦角色
		{
			C_Click(1096, 385) ;開始
			sleep 1000
			if (DwmCheckcolor(329, 209, 16777215) and DwmCheckcolor(811,547, 16777215)) ;如果有花費油
			{
				C_Click(784, 548) ;確認
				sleep 1000
			}
			C_Click(1227, 172) ;離開介面
			sleep 300
			A_Swipe(1220,187,1220,473) ;往上拉
			e := 1 ;成功接受委託任務
			;~ LogShow("軍事任務成功接受")
			return e
		}
		else 
		{
			C_Click(1227, 172) ;離開介面
			sleep 500
			A_Swipe(1220,187,1220,473) ;往上拉
			sleep 500
			e := 0 ;接收失敗...可能是角色等級或數量不足 etc...
			;~ LogShow("軍事任務接收失敗")
			return e
		}
	}
	else
	{
		C_Click(1227, 172) ;離開介面
		sleep 500
		A_Swipe(1220,187,1220,473) ;往上拉
		sleep 500
		e := 2 ;油耗超過個位數 不予接受
		;~ LogShow("軍事任務油耗超過個位數")
		return e
	}
}

battlevictory() ;戰鬥勝利(失敗) 大獲全勝
{
	;~ Global
	;~ if (DwmCheckcolor(197, 311, 15200231) and DwmCheckcolor(550, 321, 13029318) and DwmCheckcolor(664, 346, 14608350))
	;~ {
		;~ AnchorFailedTimes++
		;~ Guicontrol, ,AnchorFailedText, 旗艦大破：%AnchorFailedTimes% 次。
		;~ LogShow("======旗艦大破======")
		;~ Random, x, 100, 1000
		;~ Random, y, 100, 600
		;~ C_Click(x, y)
	;~ }
	if (DwmCheckcolor(123, 650, 16777215)  or DwmCheckcolor(139, 666, 16777215) or DwmCheckcolor(125, 682, 16777215) or DwmCheckcolor(110, 666, 16777215)) and (DwmCheckcolor(68, 703, 16777215) or DwmCheckcolor(68, 703, 528417) or DwmCheckcolor(661, 405, 16777215)) and DwmCheckcolor(685, 406, 16777215) and !DwmCheckcolor(1208, 658, 4379631) and DwmCheckcolor(1, 35, 2633790) ;點擊繼續
	{
		LogShow("艦已靠港。")
		Random, x, 100, 1000
		Random, y, 100, 600
		C_Click(x, y)
	}
}

GetItem()
{
	if (DwmCheckcolor(576, 258, 16777215) and DwmCheckcolor(613, 257, 16777215) and DwmCheckcolor(715, 274, 16777215) and DwmCheckcolor(622, 275, 7574271)) ;獲得道具
	{
		LogShow("獲得道具，點擊繼續！")
		C_Click(638, 519)
	}
}

GetItem2()
{
	if (DwmCheckcolor(576, 186, 16777215) and DwmCheckcolor(711, 187, 16777215) and DwmCheckcolor(613, 187, 16777215) and DwmCheckcolor(641, 199, 8104703)) ;獲得道具
	{
		LogShow("獲得道具，點擊繼續2！")
		C_Click(638, 519)
	}
	else if (DwmCheckcolor(576, 258, 16777215) and DwmCheckcolor(712, 258, 16777215) and DwmCheckcolor(730, 270, 13041663))
	{
		LogShow("獲得道具，點擊繼續3！")
		C_Click(638, 519)
	}
}

GetCard()
{
	if (DwmCheckcolor(71, 412, 16777215) and DwmCheckcolor(57, 514, 16777215) and DwmCheckcolor(70, 607, 16777215) and DwmCheckcolor(52, 694, 16777215) and DwmCheckcolor(1, 35, 2633790)) ;獲得新卡片
	{
		sleep 1500
		Capture() ;拍照
		C_Click(604, 349) ;離開介面
		if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(414, 224, 16777215) and DwmCheckcolor(811, 546, 16777215) and DwmCheckcolor(1, 35, 2633790))
		{
			LogShow("獲得新卡片，自動上鎖！")
			C_Click(791, 543) ;上鎖
		}
	}
}

NewWife()
{
	if (DwmCheckcolor(810, 549, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(459, 544, 16777215) and DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(896, 229, 16777215) and DwmCheckcolor(718, 388, 16777207) and DwmCheckcolor(1, 35, 2633790)) ;訊息自動確認
	{
		LogShow("撿到老婆，簽字簽字！")
		C_Click(788, 545)
	}
}

Message_Center()
{
	if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(661, 549, 16777215) and (DwmGetPixel(640, 545)>4300000 and  DwmGetPixel(640, 545)<5000000)) ;中央訊息
	{
		LogShow("中央訊息，點擊確認！")
		C_Click(635, 542)
	}
	else if (DwmCheckcolor(330, 196, 16777215) and DwmCheckcolor(414, 210, 16777215) and DwmCheckcolor(690, 559, 16777215) and DwmCheckcolor(665, 349, 10268333))
	{
		LogShow("每日提示，今日不再顯示！")
		C_Click(774, 497)
		C_Click(638, 565)
	}
}

Message_Normal()
{
	if (DwmCheckcolor(810, 549, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(459, 544, 16777215) and DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(896, 229, 16777215) and DwmCheckcolor(1, 35, 2633790)) ;訊息自動確認
	{
		LogShow("出現訊息，點擊取消！")
		C_Click(490, 548)
	}
}

UnknowWife()
{
	if (GdiGetPixel(811, 548)=4294967295 and GdiGetPixel(441, 346)=4283584850) ;未知腳色(確認)
	{
		LogShow("未知腳色(確認)！")
		C_Click(811, 546)
	}
}

Battle_End()
{
	if (DwmGetPixel(1108, 699)=16777215 and DwmGetPixel(914, 680)=16777215 and DwmGetPixel(98, 242)=16777215) and DwmCheckcolor(1, 35, 2633790)  ;確定
	{
		LogShow("結算畫面，點擊確定！")
		Random, x, 1015, 1160
		Random, y, 679, 712
		C_Click(x, y)
		sleep 6000
	}
}

Message_Story()
{
	SkipBtn := DwmCheckcolor(1244, 67, 13553622) 
	SkipBtn2 := DwmCheckcolor(1245, 68, 13553622)
	 if (SkipBtn and SkipBtn2)
	{
		LogShow("劇情對話，自動略過")
		C_Click(1200, 74)
		sleep 1000
		if (DwmCheckcolor(810, 546, 16777215))
		{
			C_Click(784, 545)
		}
	}
}

BackAttack()
{
	 if (DwmCheckcolor(417, 389, 16777215) and DwmCheckcolor(842, 401, 16777215) and DwmCheckcolor(1096, 521, 16777215) and DwmCheckcolor(351, 417, 16735595)) ;遇襲
	{
		if Assault=迎擊
		{
			LogShow("遇襲：迎擊！")
			C_Click(843, 508)
		}
		else if Assault=規避
		{
			LogShow("遇襲：規避！")
			C_Click(1068, 502)
		}
		else
		{
			LogShow("伏擊錯誤")
			Msgbox, Assalut = %Assault%
		}
	}
}

shipsfull(byref StopAnchor)
{
	if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(897, 230, 16777215) and DwmCheckcolor(865, 557, 16777215) and DwmCheckcolor(463, 541, 16777215) and DwmCheckcolor(615, 533, 16777215) and DwmCheckcolor(402, 527, 3761564) and DwmCheckcolor(1, 35, 2633790))
	{
		if shipsfull=停止出擊
		{
			LogShow("船䲧已滿：停止出擊。")
			Traytip, Azur Lane, 船䲧已滿：停止出擊。
			C_Click(896,231)
			Loop
			{
				if (DwmCheckcolor(1234, 650, 16777215) and DwmCheckcolor(997, 194, 8685204)) or (DwmCheckcolor(1234, 650, 16250871) and DwmCheckcolor(1234, 650, 16250871)) ;進入戰鬥的編隊頁面 (出擊、目標底下箭頭) 點擊右上HOME回首頁
				{
					C_Click(1227,71)
					sleep 2000
				}
				else if (DwmCheckcolor(944, 540, 16250871) and DwmCheckcolor(1047, 531, 16250871))
				{
					C_Click(1034,210)
					sleep 1500
				}
				else if (DwmCheckcolor(143, 688, 16777215))
				{
					C_Click(58,89)
					sleep 1500
				}
				else if (DwmCheckcolor(12, 200, 16777215)) ;回到首頁 偵測左方稜形白點
				{
					StopAnchor := 1 ;不再出擊
					Break
				}
				else
				{
					BreakShipsfailed++
					if (BreakShipsfailed>=50)
					{
						StopAnchor := 1 ;不再出擊
						Break
					}
				}
				sleep 300
			}
			BreakShipsfailed := VarSetCapacity
		}
		else if shipsfull=關閉遊戲
		{
			LogShow("船䲧已滿：關閉模擬器。")
			sleep 500
			run, dnconsole.exe quit --index %emulatoradb%, %ldplayer%, Hide
			sleep 500
		}
		else if shipsfull=整理船䲧
		{
			LogShow("船䲧已滿：開始整理。")
			C_Click(437, 539)
			Loop ;等待進入船䲧畫面
			{
				sleep 400
				shipcount++
				if (shipcount>50)
				{
					LogShow("等待進入船䲧的過程中發生錯誤")
					StopAnchor := 1 ;不再出擊
					return StopAnchor
				}
			} until DwmCheckcolor(830, 700, 16777215) and DwmCheckcolor(599, 710, 16777215) and DwmCheckcolor(1, 35, 2633790)
			shipcount := VarSetCapacity
			Loop
			{
				if (DwmCheckcolor(830, 700, 16777215) and DwmCheckcolor(599, 710, 16777215))
				{
					C_Click(1136, 64) ;開啟篩選
					Loop
					{
						sleep 400
						shipcount++
						if (shipcount>50)
						{
							LogShow("等待進入篩選清單的過程中發生錯誤")
							StopAnchor := 1 ;不再出擊
							return StopAnchor
						}
					} until DwmCheckcolor(71, 125, 16777215) and DwmCheckcolor(112, 259, 16777215) and DwmCheckcolor(1, 35, 2633790)
					shipcount := VarSetCapacity
					C_Click(502, 129) ;排序 等級
					C_Click(363, 266) ;索引 全部
					C_Click(363, 397)  ;陣營全 陣營
					C_Click(363, 530)  ;稀有度 全部
					if (Index1)
						C_Click(517, 264)
					if (Index2)
						C_Click(666, 265)
					if (Index3)
						C_Click(833, 265)
					if (Index4)
						C_Click(991, 265)
					if (Index5)
						C_Click(1134, 265)
					if (Index6)
						C_Click(348, 324)
					if (Index7)
						C_Click(517, 324)
					if (Index8)
						C_Click(666, 324)
					if (Index9)
						C_Click(833, 324)
					if (Camp1)
						C_Click(513, 397)
					if (Camp2)
						C_Click(666, 397)
					if (Camp3)
						C_Click(833, 397)
					if (Camp4)
						C_Click(991, 397)
					if (Camp5)
						C_Click(1134, 397)
					if (Camp6)
						C_Click(356, 457)
					if (Camp7)
						C_Click(513, 457)
					if (Rarity1)
						C_Click(513, 529)
					if (Rarity2)
						C_Click(666, 529)
					if (Rarity3)
						C_Click(833, 529)
					if (Rarity4)
						C_Click(991, 529)
					if (DwmCheckcolor(821, 702, 16777215))
					{
					C_Click(796, 702)
					sleep 1000
						if (DwmCheckcolor(280, 397, 16777215) and DwmCheckcolor(1141, 380, 9718090) and DwmCheckcolor(1141, 423, 9718090)) ;如果篩選完畢發現沒有船可以退役
						{
							LogShow("篩選後已經無符合條件的船艦，強制停止")
							StopAnchor := 1
							C_Click(1243, 67) ;回到首頁
							return StopAnchor
						}
					break
					}
					else
					{
						Msgbox, 排序角色出錯
					}
				sleep 300
				}
			}
			;~ LogShow("排序完畢這裡繼續")
			Loop
			{
				if (DwmCheckcolor(1035, 683, 16777215) and DwmCheckcolor(825, 684, 16777215) and DwmCheckcolor(156, 84, 16777215))
					C_Click(1014,677)  ;退役確定
				else if (DwmCheckcolor(330, 208, 16777215) and DwmCheckcolor(523, 546, 16777215) and DwmCheckcolor(811, 555, 16777215)) ;如果有角色等級不為1(確定)
					C_Click(787,546)  
				else if (DwmGetPixel(711, 261)=16777215 and DwmGetPixel(575, 258)=16777215) ;獲得道具
					C_Click(636, 91)
				else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215)) ;獲得道具
					C_Click(636, 91)
				else if (DwmCheckcolor(212, 173, 16777215) and DwmCheckcolor(986, 592, 16777215)) ;拆裝(確定)
					C_Click(979, 580)
				else if (DwmCheckcolor(211, 153, 16777215) and DwmCheckcolor(828, 615, 16777215)) ;將獲得以下材料
					C_Click(805, 605)
				else if (DwmCheckcolor(1102, 705, 10856101) and DwmCheckcolor(1142, 386, 9718090) and DwmCheckcolor(111, 448, 9208460)) ;暫無符合條件的艦船
				{
					C_Click(64, 91)
					Logshow("退役結束")
					break
				}
				else if (!(DwmCheckcolor(266, 403, 16777215) and DwmCheckcolor(1141, 388, 9718090)) and DwmCheckcolor(879, 709, 16777215)) ;第一位還沒被退役
				{
					DockCount++
					if (DockCount>20 and DwmCheckcolor(154, 60, 15201279) and DwmCheckcolor(173, 70, 14085119)) ;偵測"船塢"
					{
						C_Click(64, 91) ;避免出現一些問題(例如船未上鎖)，強制結束退役
						DockCount := VarSetCapacity
						Logshow("發生一些問題，退役結束")
						break
					}
					else
					{
						C_Click(165,220) ;1
						if !DwmCheckcolor(330, 220, 2171945)
							C_Click(330,220) ;2
						if !DwmCheckcolor(495, 220, 4342090)
							C_Click(495,220) ;3
						if !DwmCheckcolor(660, 220, 5393754)
							C_Click(660,220) ;4
						if !DwmCheckcolor(825, 220, 5393754)
							C_Click(825,220) ;5
						if !DwmCheckcolor(990, 220, 3750986)
							C_Click(990,220) ;6
						if !DwmCheckcolor(1155, 220, 2698289)
							C_Click(1155,220) ;7
						if !DwmCheckcolor(165, 420, 4335665)
							C_Click(165,420) ;2-1
						if !DwmCheckcolor(330, 420, 3745841)
							C_Click(330,420) ;2-2
						if !DwmCheckcolor(495, 220, 4342090)
							C_Click(495,420) ;2-3
						C_Click(1078,702)  ;確定
					}
				}
				sleep 500
			}  
		}
	}
}

ToMap()
{
	if (DwmCheckcolor(869, 531, 14587474) and DwmCheckcolor(1045, 532, 16777215) and DwmCheckcolor(1045, 550, 16238402))
	{
		if (WeekMode and DwmCheckcolor(1045, 630, 9737876)) ;周回模式開關
		{
			C_Click(1022, 631)
		}
		LogShow("立刻前往攻略地圖")
		Random, x, 866, 1034
		Random, y, 533, 571
		C_Click(x, y)
	}
}

ChooseParty(Byref StopAnchor)
{
	Global
	if (DwmCheckcolor(991, 619, 14586450) and DwmCheckcolor(1167, 636, 16238402) and DwmCheckcolor(1174, 617, 16777215))
	{
		LogShow("選擇出擊艦隊中。")
		if FirstChooseParty<1 ;只在第一次啟動選擇隊伍 直到選項變更
		{
			if (AnchorMode="普通") and !(AnchorChapter="S.P.")
			{
				C_Click(1142, 370) ;先清掉第二艦隊
				sleep 300
				C_Click(1060, 230) ;開啟第一艦隊的選擇選單
				sleep 300
				if ChooseParty1=第一艦隊
					C_Click(1093, 296) 
				else if ChooseParty1=第二艦隊
					C_Click(1093, 340) 
				else if ChooseParty1=第三艦隊
					C_Click(1093, 382) 
				else if ChooseParty1=第四艦隊
					C_Click(1098, 424) 
				else if ChooseParty1=第五艦隊
					C_Click(1098, 466) 
				else if ChooseParty1=第六艦隊
					C_Click(1098, 506) 
				if ChooseParty2!=不使用
				{
					sleep 500
					C_Click(1053, 368)	;開啟第二艦隊的選擇選單
					sleep 500
				}
				if ChooseParty2=第一艦隊
					C_Click(1103, 431)
				else if ChooseParty2=第二艦隊
					C_Click(1103, 472)
				else if ChooseParty2=第三艦隊
					C_Click(1103, 514)
				else if ChooseParty2=第四艦隊
					C_Click(1103, 556)
				else if ChooseParty2=第五艦隊
					C_Click(1103, 600)
				else if ChooseParty2=第六艦隊
					C_Click(1103, 641)
				sleep 300
				FirstChooseParty := 1
			}
		}
		Random, x, 1000, 1150
		Random, y, 620, 655
		C_Click(x, y)	;立刻前往
		sleep 200
		if (GdiGetPixel(743, 541)=4282544557) ;心情低落
		{
			LogShow("老婆心情低落中。")
			C_Click(743, 541)
		}
		else if (DwmCheckcolor(530, 360, 15724535) or DwmCheckcolor(530, 360, 16249847)) ; 資源不夠
		{
			LogShow("石油不足，停止出擊到永久。")
			StopAnchor := 1
			C_Click(1230, 68) ;返回主選單
			return StopAnchor
		}
		else if DwmCheckcolor(424, 361, 15724527) and AnchorMode="困難"
		{
			LogShow("困難模式次數已用盡，停止出擊到永久。")
			StopAnchor := 1
			C_Click(1230, 68) ;返回主選單
			return StopAnchor
		}
		sleep 2000
		if (SwitchPartyAtFirstTime and (ChooseParty2!="不使用" or AnchorMode="困難"))
		{
			Loop, 20
			{
				sleep 500
				if (DwmCheckcolor(766, 701, 12996946) and DwmCheckcolor(1059, 696, 9738925) and DwmCheckcolor(1257, 712, 16239426)) ;如果進入地圖頁面 檢測"撤退" "切換" "迎擊"
				{
					sleep 3000
					Random, x, 963, 1096
					Random, y, 701, 728
					C_Click(x,y) ;點擊"切換"
					break
				}
			}
		}
		if ((AnchorChapter="S.P.") and AnchorChapter2="3") ;如果是SP3 先往左上拉 避免開場的多次偵測
		{
			A_Swipe(272, 419, 1100, 422)
		}
	}
}

Battle_Operation()
{
	 if (DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(1240, 83, 16249847))
	{
		LogShow("報告提督SAMA，艦娘航行中！")
		Loop
		{
			sleep 1000
			if !(DwmCheckcolor(1225, 83, 16249847))
			{
				sleep 1000
				if !(DwmCheckcolor(1225, 83, 16249847))
				{
					Break
				}
			}
			if (Leave_Operatio) ;快輸了自動離開
			{
				if (DwmCheckcolor(584, 87, 15672353) and !DwmCheckcolor(499, 86, 15671312) and !DwmCheckcolor(1196, 654, 16777215) and !DwmCheckcolor(1043, 650, 16777215) and !DwmCheckcolor(897, 660, 16777215))  
				{
					sleep 1000
					if (DwmCheckcolor(584, 87, 15672353) and !DwmCheckcolor(499, 86, 15671312) and !DwmCheckcolor(1196, 654, 16777215) and !DwmCheckcolor(1043, 650, 16777215) and !DwmCheckcolor(897, 660, 16777215))   ;再檢查一次
					{
						LogShow("我方血量過低，自動離開戰鬥")
						Loop, 100
						{
							if (DwmCheckcolor(1241, 82, 16249847))
							{
								C_Click(1210, 82) ;點擊暫停
								sleep 1000
							}
							else if (DwmCheckcolor(457, 549, 16777215))
							{
								C_Click(504, 553) ;退出戰鬥
								sleep 1000
							}
							else if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(821, 535, 16777215))
							{
								C_Click(790, 544) ;拋棄獲得的資源 道具 腳色
								sleep 1000
							}
							else if (DwmCheckcolor(1231, 666, 16239426) and DwmCheckcolor(1235, 650, 16777215)) ;回到編隊出擊頁面
							{
								C_Click(59, 90) ;返回上一頁
							}
							else if (DwmCheckcolor(153, 69, 14609407) and DwmCheckcolor(170, 70, 14609407)) ;回到演習頁面
							{
								C_Click(1142, 395) ;更換對手
								Break
							}
							else if (DwmCheckcolor(1221, 73, 16777215)) ;太慢退出
							{
								C_Click(620, 391)
								break
							}
							sleep 333
						}
					}
				}
			}
			battletime++
			if (battletime>900) ;如過戰鬥超過15分鐘
			{
				LogShow("戰鬥超時，自動離開")
				Loop, 999
				{
					sleep 500
					if (DwmCheckcolor(1241, 82, 16249847))
					{
						C_Click(1210, 82) ;點擊暫停
						sleep 1000
					}
					if (DwmCheckcolor(457, 549, 16777215) and DwmCheckcolor(457, 549, 16777215))
					{
						C_Click(504, 553) ;退出戰鬥
						sleep 1000
					}
					if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(821, 535, 16777215))
					{
						C_Click(790, 544) ;拋棄獲得的資源 道具 腳色
						sleep 10000
						break
					}
				}
			}
		} 
		battletime := VarSetCapacity
	}
}

Battle()
{
	 if (DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(1240, 83, 16249847))
	{
		LogShow("報告提督SAMA，艦娘航行中！")
		Loop
		{
			sleep 1000
			if !(DwmCheckcolor(1225, 83, 16249847))
			{
				sleep 1000
				if !(DwmCheckcolor(1225, 83, 16249847))
				{
					Break
				}
			}
			else if Autobattle=半自動
			{
				if (DwmCheckcolor(455, 82, 15671329)) or (DwmCheckcolor(372, 61, 16777215))
				{
					if (MoveDown<1)
					{
						A_Swipe(150,630, 150, 700, 650) ;下
						sleep 200
						A_Swipe(116,587, 20, 587, 1000) ;往後
						swipeside := 3
					}
					MoveDown := 1
					if (DwmCheckcolor(897, 656, 16777215) and DwmCheckcolor(1225, 83, 16249847)) ;飛機準備就緒
					{
						C_Click(897, 656)
					}
					else if (DwmCheckcolor(1043, 651, 16777215) and DwmCheckcolor(1225, 83, 16249847) and swipeside=4) ;魚雷準備就緒
					{
						C_Click(1043, 651)
					}
					else if (DwmCheckcolor(1198, 654, 16777215) and DwmCheckcolor(1225, 83, 16249847) and swipeside=4) ;大砲準備就緒
					{
						C_Click(1182, 649)
					}
				}
				HalfAuto++
				if HalfAuto>3
				{
					;~ if swipeside=1
					;~ {
						;~ A_Swipe2(149,545, 149, 400, 2500) ;上
						;~ Swipe := 2
					;~ }
					;~ else if swipeside=2
					;~ {
						;~ A_Swipe2(150,630, 150, 700, 2500) ;下
						;~ Swipe := 3
					;~ }
					if swipeside=3
					{
						A_Swipe2(198,591, 298, 591, 1800) ;往前
						swipeside := 4
					}
					else if swipeside=4
					{
						A_Swipe2(116,587, 20, 587, 1600) ;往後
						swipeside := 3
					}
					HalfAuto := 0
				}
				sleep 300
			}
			battletime++
			if (battletime>600) ;如過戰鬥超過10分鐘
			{
				LogShow("戰鬥超時，自動離開")
				Loop, 999
				{
					sleep 500
					if (DwmCheckcolor(1241, 82, 16249847))
					{
						C_Click(1210, 82) ;點擊暫停
						sleep 1000
					}
					if (DwmCheckcolor(457, 549, 16777215) and DwmCheckcolor(457, 549, 16777215))
					{
						C_Click(504, 553) ;退出戰鬥
						sleep 1000
					}
					if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(821, 535, 16777215))
					{
						C_Click(790, 544) ;拋棄獲得的資源 道具 腳色
						sleep 10000
						break
					}
				}
			}
		} 
		battletime := VarSetCapacity
	}
}

GuLuGuLuLu()
{
	if (DwmCheckcolor(355, 206, 16776183) and DwmCheckcolor(355, 206, 16776183) and DwmCheckcolor(468, 561, 16764787) and DwmCheckcolor(794, 564, 16755282))
	{
		;~ if !DormFood
		;~ {
			LogShow("提督SAMA人家不給吃飯飯！")
			Random, x, 446, 588
			Random, y, 541, 576
			C_Click(x, y)
		;~ }
		;~ else if DormFood
		;~ {
			;~ LogShow("HEHE，吃飯飯！")
			;~ C_Click(757,557)
		;~ }
		;~ else 
		;~ {
			;~ Msgbox, GuLuGuLuLu出現錯誤
		;~ }
	}
}

CloseEventList()
{
	if (DwmCheckcolor(96, 42, 5937919) and DwmCheckcolor(1231, 69, 14088191) and DwmCheckcolor(202, 57, 16251903) and DwmCheckcolor(212, 67, 14610431))
	{
		LogShow("關閉活動總覽")
		C_Click(1240,66)
	}
}

SystemNotify()
{
	if (DwmCheckcolor(144, 93, 16777215) and DwmCheckcolor(183, 93, 16777215) and DwmCheckcolor(1222, 152, 16241474) and DwmCheckcolor(1, 35, 2633790))
	{
		LogShow("出現系統公告，不再顯示")
		if !(DwmCheckcolor(997, 109, 8716180))
		{
			C_Click(994, 110)
		}
		C_Click(1193, 103)
	}
}

ClickFailed()
{
	if (DwmCheckcolor(331, 210, 16777215) and DwmCheckcolor(919, 282, 16241474) and DwmCheckcolor(415, 224, 16777215)) ;誤點"制空值"訊息
	{
		C_Click(893, 229)
		A_Swipe(153, 227,153,453)
	}
	else if (DwmCheckcolor(220, 127, 16777215) and DwmCheckcolor(452, 570, 16771988) and DwmCheckcolor(838, 561, 16746116)) ;誤點敵軍詳情
	{
		C_Click(1136, 298)
		A_Swipe(153, 453,153,227)
	}
}

A_Swipe(x1,y1,x2,y2,swipetime="")
{
	sleep 100
	runwait,  ld.exe -s %emulatoradb% input swipe %x1% %y1% %x2% %y2% %swipetime%,%ldplayer%, Hide
	sleep 500
}

A_SwipeFast(x1,y1,x2,y2,swipetime="")
{
	sleep 50
	runwait,  ld.exe -s %emulatoradb% input swipe %x1% %y1% %x2% %y2% %swipetime%,%ldplayer%, Hide
	sleep 250
}


A_Swipe2(x1,y1,x2,y2,swipetime="")
{
	Run,  ld.exe -s %emulatoradb% input swipe %x1% %y1% %x2% %y2% %swipetime%,%ldplayer%, Hide
}

A_Click(x,y)
{
	sleep 400
	Runwait, ld.exe -s %emulatoradb% input tap %x% %y%, %ldplayer%, Hide
	sleep 500
}

C_Click(PosX, PosY)
{
	sleep 600
	random , x, PosX - 3, PosX + 3 ;隨機偏移 避免偵測
	random , y, PosY - 2, PosY + 2
	ControlClick, x%x% y%y%, ahk_id %UniqueID%,,,2 , NA 
	;~ Runwait, ld.exe -s %emulatoradb% input tap %x% %y%, %ldplayer%, Hide
	sleep 500
}

GdiGetPixel( x, y)
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Argb := Gdip_GetPixel(pBitmap, x, y)
    Gdip_DisposeImage(pBitmap)
    return ARGB
}

Checkcolor( x, y, color="")
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Argb := Gdip_GetPixel(pBitmap, x, y)
    Gdip_DisposeImage(pBitmap)
    if  (color=Argb)
    {
        Argb = 1
        return ARGB
    }
    else if (Color!=Argb)
    {
        Argb = 0
        return ARGB
    }
}

Capture() 
{
FileCreateDir, capture
formattime, nowtime,,yyyy.MM.dd_HH.mm.ss
pBitmap := Gdip_BitmapFromHWND(UniqueID)
pBitmap_part := Gdip_CloneBitmapArea(pBitmap, 0, 36, 1280, 722)
Gdip_SaveBitmapToFile(pBitmap_part, "capture/" . title . "AzurLane_" . nowtime . ".jpg", 100)
Gdip_DisposeImage(pBitmap)
Gdip_DisposeImage(pBitmap_part)
}

Capture2(x1, y1, x2, y2) 
{
FileCreateDir, capture
x2 := x2-x1, y2 := y2-y1
pBitmap := Gdip_BitmapFromHWND(UniqueID)
pBitmap_part := Gdip_CloneBitmapArea(pBitmap, x1, y1, x2, y2)
Gdip_SaveBitmapToFile(pBitmap_part, "capture/" . "OCRTemp" . ".png")
Gdip_DisposeImage(pBitmap)
Gdip_DisposeImage(pBitmap_part)
}

AreaDwmCheckcolor(byref x, byref y, x1, y1, x2, y2, color="") ; slow
{
	defaultX1 := x1
	defaultY1 := y1
	y := y1
	hDC := DllCall("user32.dll\GetDCEx", "UInt", UniqueID, "UInt", 0, "UInt", 1|2)
	Loop
	{
		x1 := x1 +1
		x := x1
		if (x1=x2)
		{
			x1 := defaultX1
			y1 := y1 +1
			y := y1
		}
	   pix := DllCall("gdi32.dll\GetPixel", "UInt", hDC, "Int", x, "Int", y, "UInt")
	   pix := ConvertColor(pix)
	} until pix=color or y=y2
	DllCall("user32.dll\ReleaseDC", "UInt", UniqueID, "UInt", hDC)
	DllCall("gdi32.dll\DeleteDC", "UInt", hDC)
	if (pix=color)
	{
		x := x
		y := y
		a := 1
		return a
	}
	else
	{
		x :=
		y :=
		a := 0
		return a
	}
}

DwmCheckcolor(x, y, color="")
{
    pc_hDC := DllCall("GetDC", "UInt", UniqueID)
    pc_hCDC := DllCall("CreateCompatibleDC", "UInt", pc_hDC)
    pc_hBmp := DllCall("CreateCompatibleBitmap", "UInt", pc_hDC, "Int", 1318, "Int", 758)
    pc_hObj := DllCall("SelectObject", "UInt", pc_hCDC, "UInt", pc_hBmp)
    DllCall("PrintWindow", "UInt", UniqueID, "UInt", pc_hCDC, "UInt", 0)
    pc_c := DllCall("GetPixel", "UInt", pc_hCDC, "Int", x, "Int", y, "UInt")
    pc_c := pc_c >> 16 & 0xff | pc_c & 0xff00 | (pc_c & 0xff) << 16
    pc_c .= ""
    DllCall("DeleteObject", "UInt", pc_hBmp)
    DllCall("DeleteDC", "UInt", pc_hCDC)
    DllCall("ReleaseDC", "UInt", UniqueID, "UInt", pc_hDC)
   if (Allowance>=(abs(color-pc_c)))
    {
        pc_c = 1
        return pc_c
    }
    else 
    {
        pc_c = 0
        return pc_c
    }  
}

debugmode()
{
    List = 0
    Msgbox, 即將點擊%List%
    return List
}

GetPixel(x, y)
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Argb := Gdip_GetPixel(pBitmap, x, y)
    Gdip_DisposeImage(pBitmap)
    return ARGB
}

FindThenClickColor(ARGB, delay="")
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Gdip_PixelSearch(pBitmap, ARGB, x, y)
    Random, rands, delay1, delay2
	sleep, %rands%
    ControlClick, x%x% y%y%, ahk_id %UniqueID%,,,, NA
    Gdip_DisposeImage(pBitmap)
    sleep %delay%
}

GdipImageSearch(byref x, byref y, imagePath = "img/picturehere.png",  Variation=100, direction = 1) 
{
    pBitmap := Gdip_BitmapFromHWND(UniqueID)
    LIST = 0
    bmpNeedle := Gdip_CreateBitmapFromFile(imagePath)
    RET := Gdip_ImageSearch(pBitmap, bmpNeedle, LIST, 0, 0, 1280, 720, Variation, , direction, 1)
    Gdip_DisposeImage(bmpNeedle)
    Gdip_DisposeImage(pBitmap)
    LISTArray := StrSplit(LIST, ",")
    x := LISTArray[1]
    y := LISTArray[2]
    return List
}

GdipImageSearch2(byref x, byref y, imagePath = "img/picturehere.png",  Variation=100, direction = 1, x1=0, y1=0, x2=0, y2=0) 
{
    pBitmap := Gdip_BitmapFromHWND(UniqueID)
    LIST = 0
    bmpNeedle := Gdip_CreateBitmapFromFile(imagePath)
    RET := Gdip_ImageSearch(pBitmap, bmpNeedle, LIST, x1, y1, x2, y2, Variation, , direction, 1)
    Gdip_DisposeImage(bmpNeedle)
    Gdip_DisposeImage(pBitmap)
    LISTArray := StrSplit(LIST, ",")
    x := LISTArray[1]
    y := LISTArray[2]
    return List
}

LogShow(logData) {
formattime, nowtime,, MM-dd HH:mm:ss
guicontrol, , ListBoxLog, [%nowtime%]  %logData%||
return
}

LogShow2(logData) {
guicontrol, , ListBoxLog, %logData%||
return
}

DwmGetPixel(x, y)
{
    pc_hDC := DllCall("GetDC", "UInt", UniqueID)
    pc_hCDC := DllCall("CreateCompatibleDC", "UInt", pc_hDC)
    pc_hBmp := DllCall("CreateCompatibleBitmap", "UInt", pc_hDC, "Int", 1318, "Int", 758)
    pc_hObj := DllCall("SelectObject", "UInt", pc_hCDC, "UInt", pc_hBmp)
    DllCall("PrintWindow", "UInt", UniqueID, "UInt", pc_hCDC, "UInt", 0)
    pc_c := DllCall("GetPixel", "UInt", pc_hCDC, "Int", x, "Int", y, "UInt")
    pc_c := pc_c >> 16 & 0xff | pc_c & 0xff00 | (pc_c & 0xff) << 16
    pc_c .= ""
    DllCall("DeleteObject", "UInt", pc_hBmp)
    DllCall("DeleteDC", "UInt", pc_hCDC)
    DllCall("ReleaseDC", "UInt", UniqueID, "UInt", pc_hDC)
    Return pc_c
}

;~ PixelColor(pc_x, pc_y)
;~ {	
    ;~ pc_hDC := DllCall("GetDC", "UInt", UniqueID)
    ;~ pc_hCDC := DllCall("CreateCompatibleDC", "UInt", pc_hDC)
    ;~ pc_hBmp := DllCall("CreateCompatibleBitmap", "UInt", pc_hDC, "Int", 1318, "Int", 758)
    ;~ pc_hObj := DllCall("SelectObject", "UInt", pc_hCDC, "UInt", pc_hBmp)
    ;~ DllCall("PrintWindow", "UInt", UniqueID, "UInt", pc_hCDC, "UInt", 0)
    ;~ pc_c := DllCall("GetPixel", "UInt", pc_hCDC, "Int", pc_x, "Int", pc_y, "UInt")
    ;~ pc_c := pc_c >> 16 & 0xff | pc_c & 0xff00 | (pc_c & 0xff) << 16
    ;~ pc_c .= ""
    ;~ DllCall("DeleteObject", "UInt", pc_hBmp)
    ;~ DllCall("DeleteDC", "UInt", pc_hCDC)
    ;~ DllCall("ReleaseDC", "UInt", UniqueID, "UInt", pc_hDC)
    ;~ Return pc_c
;~ }

DecToHex(dec)
{
   oldfrmt := A_FormatInteger
   hex := dec
   SetFormat, IntegerFast, hex
   hex += 0
   hex .= ""
   SetFormat, IntegerFast, %oldfrmt%
   return hex
}

ConvertColor( BGRValue )
{
	BlueByte := ( BGRValue & 0xFF0000 ) >> 16
	GreenByte := BGRValue & 0x00FF00
	RedByte := ( BGRValue & 0x0000FF ) << 16
	return RedByte | GreenByte | BlueByte
}

AutoLoginIn() ;預設登入Google帳號
{
	if (AutoLogin)
	{
		If (DwmCheckcolor(472, 473, 10075364) and DwmCheckcolor(505, 274, 9342606) and DwmCheckcolor(740, 510, 2129103)) ;斷線的登入頁面(密碼登入)
		{
			C_Click(777, 254) ;快速登入
			sleep 500
			Loop
			{
				sleep 500
				If (DwmCheckcolor(472, 473, 10075364) and DwmCheckcolor(505, 274, 9342606) and DwmCheckcolor(740, 510, 2129103)) ;斷線的登入頁面(密碼登入)
				{
					C_Click(777, 254) ;快速登入
					sleep 500
				}
				else if (DwmCheckcolor(557, 580, 1668852) and DwmCheckcolor(721, 575, 14502713)) ;FB or Google
				{
					C_Click(704, 586) ;GOOGLE登入
					sleep 500
				}
				else if (DwmCheckcolor(338, 186, 16777215) and DwmCheckcolor(649, 297, 2105636) and DwmCheckcolor(683, 292, 2105636)) ;選擇帳戶
				{
					C_Click(442, 455) ;第一個帳戶
					sleep 500
				}
				else if (DwmCheckcolor(1220, 705, 16777215) and DwmCheckcolor(1240, 700, 22957)) ;位於首頁
				{
					C_Click(587, 377)
					sleep 500
				}
				else if (DwmCheckcolor(12, 200, 16777215) and DwmCheckcolor(577, 63, 3224625) and DwmCheckcolor(997, 64, 16729459))
				{
					iniwrite, 1, settings.ini, OtherSub, Autostart
					reload
					sleep 3000
					return
				}
			}
		}
		else if (DwmCheckcolor(1262, 704, 16777215) and DwmCheckcolor(1240, 718, 22957) and DwmCheckcolor(145, 103, 1063027)) ;登入伺服器選擇頁面
		{
			sleep 3000
			Random, x, 231, 1051
			Random, y, 70, 507
			C_Click( x, y) ;隨機點擊登入
			sleep 3000
		}
	}
}

CheckArray(Var*) ;~ Example.  NowColor := [DwmCheckcolor(12, 200, 16250871), DwmCheckcolor(12, 199, 16777215)] `n Msgbox % CheckArray(NowColor*) 
{ ;檢查數組中，其中一個是否為真
	for k, v in Var
	if v=1
		return 1
	return 0
}

MinMax(type := "max", values*) {
	y := 0, c:= 0
	for k, v in values
		if v is number 
			x .= (k = values.MaxIndex() ? v : v ";"), ++c, y += v 
	Sort, x, % "d`; N" (type = "max" ? " R" : "")
	return type = "avg" ? y/c : SubStr(x, 1, InStr(x, ";") - 1)
}
