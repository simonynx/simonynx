//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import Net.*;
    import OopsFramework.Content.Loading.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.CSBattle.vo.*;
    import GameUI.Modules.Login.Model.*;

    public class GameCommonData {

        public static var TranscriptFinish:Boolean = false;
        public static var CSBattleTeamList:Array = [];
        public static var Rect:Sprite;
        public static var VisibleSameSecnePlayerList:Dictionary = new Dictionary();
        public static var TowerMaxCount:int;
        public static var isLoginFromLoader:Boolean = false;
        public static var IsAddAttack:Boolean = false;
        public static var JobGameSkillList:Dictionary = new Dictionary();
        public static var IsConnectAcc:Boolean = false;
        public static var isNewTaskEnd:Boolean = false;
        public static var GameServerArr:Array = [];
        public static var NextSkillTarget:GameElementAnimal;
        public static var GuildSkillsList:Dictionary = new Dictionary();
        public static var currentMapVersion:uint = 0;
        public static var TowerRewardList:Dictionary = new Dictionary();
        public static var SelectQueDic:Dictionary = new Dictionary();
        public static var IsInTower:Boolean = false;
        public static var CurrentTaskList:Dictionary = new Dictionary();
        public static var mapResourceLoader:BulkLoader = new BulkLoader(2);
        public static var GServerInfo:Object = new Object();
        public static var ModelOffsetNpcEnemy:Dictionary = new Dictionary();
        public static var IsQuestionTime:Boolean;
        public static var activityNight:Boolean = false;
        public static var gameDay:int;
        public static var UICom:Boolean = false;
        public static var GuildFightStatus:uint = 0;
        public static var autoListDic:Dictionary = new Dictionary();
        public static var RoleList:Array;
        public static var ActivityList_upgrade:Array;
        public static var totalPayMoney:uint;
        public static var TargetPoint:Point = new Point();
        public static var IsRushing:Boolean = false;
        public static var Skills:Array = new Array();
        public static var OpenBoxItemIds:Array = new Array();
        public static var RectSkillPos:Point;
        public static var Attack:int = 0;
        public static var StoryDisplayList:Array;
        public static var targetID:int;
        public static var SkillList:Dictionary = new Dictionary();
        public static var talkNpcID:uint;
        public static var Scene:SceneController;
        public static var AccNets:AccNet;
        public static var Star:XML = new XML();
        public static var ActivityList:Array;
        public static var ModelOffsetMount:Dictionary = new Dictionary();
        public static var OwnerMainCity:String = "";
        public static var SkillLoadAudioEngine:Dictionary = new Dictionary();
        public static var GradeBibleList:Array;
        public static var AttackAnimal:GameElementAnimal;
        public static var RectSkillID:int;
        public static var BigMapMaskHi:uint = 0;
        public static var ReChargeCount:int;
        public static var PetRaceActionList:Dictionary = new Dictionary();
        public static var Screen:int = 2;
        public static var IsChangeOnline:Boolean = false;
        public static var RewardRecord:uint = 0;
        public static var IsLoadUserInfo:Boolean = false;
        public static var treasureCDTime:uint;
        public static var MapConfigs:Dictionary = new Dictionary();
        public static var isFirstTimeEnterGame:Boolean = true;
        public static var QuestionDic:Dictionary = new Dictionary();
        public static var GameHelpHotList:Dictionary = new Dictionary();
        public static var loginHint_mc:MovieClip = null;
        public static var npcShopLimit:uint;
        public static var OccupationIntroXMLS:XML = new XML();
        public static var preMapId:int;
        public static var ModelOffsetSkill:Dictionary = new Dictionary();
        public static var lastPlayPetIdx:int = -1;
        public static var Password:String;
        public static var activityFlags:uint;
        public static var PlayerLoadList:Array = null;
        public static var TargetDistance:int = 0;
        public static var GameInstance:MyGame;
        public static var IsMoveTargetAnimal:Boolean = false;
        public static var BigMapMaskLow:uint = 33554432;
        public static var GuildFight_LineId:int;
        public static var AchieveDic:Dictionary = new Dictionary();
        public static var TaskTargetCommand:String = "";
        public static var isReceive1052:Boolean = false;
        public static var TargetXMLs:XML = new XML();
        private static var _SameSecnePlayerList:Dictionary;
        public static var IsGotoCSB:Boolean = false;
        public static var SkillEffectList:Dictionary = new Dictionary();
        public static var showChargeTips:Boolean = false;
        private static var _TargetAnimal:GameElementAnimal;
        public static var ConvoyQuality:uint = 0;
        public static var TowerRankList:Dictionary = new Dictionary();
        public static var MapTree:Dictionary = new Dictionary();
        public static var ModelOffsetPlayer:Dictionary = new Dictionary();
        public static var AutomatismPoint:Point = null;
        public static var Player:GameElementPlayer;
        public static var playerResourceLoader:BulkLoader = new BulkLoader(2);
        public static var Accmoute:String;
        public static var LoginPassword:String = "";
        public static var GameHelpClassList:Dictionary = new Dictionary();
        public static var TeamPlayerListOld:Dictionary = new Dictionary();
        public static var PetRaceRewardList:Dictionary = new Dictionary();
        public static var accuChargeLeftDay:int;
        public static var TotalAchievePoint:int = 0;
        public static var IsGotoParty:Boolean = false;
        public static var ActivityXMLs:XML = new XML();
        public static var TitleDic:Dictionary = new Dictionary();
        public static var StoryDisplayXMLs:XML = new XML();
        public static var GuildFight_IsStarting:Boolean;
        public static var TowerPetPlace:int = -1;
        public static var accuChargeId:int;
        public static var playformId:uint;
        public static var ModuleCloseConfig:Array = [];
        public static var IsGotoArena:Boolean = false;
        public static var DuelAnimal:GameElementAnimal = null;
        public static var TowerList:Dictionary = new Dictionary();
        public static var IsSelfDead:Boolean;
        public static var IsTESLSetTrap:Boolean = false;
        public static var LoginDays:uint = 0;
        public static var IsCollected:Boolean = false;
        public static var NoMovePlayerId:int;
        public static var GradeBibleXMLs:XML = new XML();
        public static var MagicWeaponExp:String;
        public static var activityData:Object = new Object();
        public static var dialogStatus:uint = 0;
        public static var TargetScene:String = "";
        public static var NPCDialogIsOpen:Boolean = false;
        public static var ActivityEveryDayXML:XML = new XML();
        public static var LocalDirectory:String = "";
        public static var loaderTxt:TextField;
        public static var SkillOnLoadEffectList:Dictionary = new Dictionary();
        public static var BackGround:MovieClip = null;
        public static var isReceiveAcc:Boolean = false;
        public static var LoginName:String = "LoginName";
        private static var _isAutoPath:Boolean = false;
        public static var openServerDate:uint = 0;
        public static var TeamPlayerList:Dictionary = new Dictionary();
        public static var HelpConfigItems:Dictionary = new Dictionary();
        public static var Tiao:MovieClip = null;
        public static var treasureSoul:int;
        public static var TaskInfoDic:Dictionary = new Dictionary();
        public static var PetTargetAnimal:GameElementAnimal;
        public static var TranscriptList:Dictionary = new Dictionary();
        public static var SameSecnePlayerMaxCount:int = 100;
        public static var UIFacadeIntance:UIFacade;
        public static var UILoad:Boolean = false;
        public static var IsFollow:Boolean = false;
        public static var CanGetGlass:Boolean = true;
        public static var AutomatismTime:Number = 0;
        public static var LevelHelpTipsDic:Dictionary = new Dictionary();
        public static var isFocusIn:Boolean = false;
        public static var RolesListDic:Dictionary = new Dictionary();
        public static var TargetPickItem:Object;
        public static var GameNets:GameNet;
        public static var AccuChargeEnable:uint = 0;
        public static var IsFirstLoadGame:Boolean = true;
        public static var gameMonth:int;
        public static var RankXMLs:XML = new XML();
        public static var goldenAccountNeed:uint = 2147483647;
        public static var TowerFlyRemainCnt:int;
        public static var enterGameObj:Object = new Object();
        public static var CanWinpartExchange:Boolean = true;
        public static var SCENE_LOGIN:String = "登录场景";
        public static var BuffList:Dictionary = new Dictionary();
        public static var OpenBoxConfig:uint = 0;
        public static var flagTestYL:Boolean = false;
        public static var NewAndCharge:uint = 0;
        public static var DefaultNickName:String = "";
        public static var GameHelpList:Dictionary = new Dictionary();
        public static var isSend:Boolean = true;
        public static var ServerId:String;
        public static var CSBattleMyTeamInfo:CSBattleTeamInfo;
        public static var SelectedRole:RoleVo;
        public static var IsInCombat:Boolean = false;
        public static var PackageList:Dictionary = new Dictionary();
        public static var SCENE_GAME:String = "游戏场景";
        public static var TowerRewardRecord:Array = new Array();
        public static var ServerIp:String = "";
        public static var currAccountMoney:uint;
        public static var SkillLoadEffectList:Dictionary = new Dictionary();
        public static var ActivityItems:Dictionary = new Dictionary();
        public static var GuildBattle_IsStarting:Boolean = false;

        public static function get IsInCrossServer():Boolean{
            return ((GameConfigData.CurrentServerId == 10));
        }
        public static function set TargetAnimal(_arg1:GameElementAnimal):void{
            _TargetAnimal = _arg1;
        }
        public static function GetSkillEffectPath(_arg1:String):String{
            return (((((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameSkillListSWF) + _arg1) + ".swf?v=") + GameConfigData.SkillVersion));
        }
        public static function get TargetAnimal():GameElementAnimal{
            return (_TargetAnimal);
        }
        public static function get SameSecnePlayerList():Dictionary{
            return (_SameSecnePlayerList);
        }
        public static function get isAutoPath():Boolean{
            return (_isAutoPath);
        }
        public static function set isAutoPath(_arg1:Boolean):void{
            _isAutoPath = _arg1;
            if (_isAutoPath){
                SpeciallyEffectController.getInstance().showAutoMc(2);
            } else {
                SpeciallyEffectController.getInstance().showAutoMc(0);
            };
        }
        public static function set SameSecnePlayerList(_arg1:Dictionary):void{
            _SameSecnePlayerList = _arg1;
        }

    }
}//package 
