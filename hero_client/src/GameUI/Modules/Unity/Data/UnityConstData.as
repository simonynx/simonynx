//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Unity.Data {
    import flash.utils.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class UnityConstData {

        public static const SORTLIST:Array = ["CASEINSENSITIVE", "NUMERIC", "NUMERIC", "NUMERIC", "NUMERIC", "NUMERIC"];
        public static const ApplySORTLIST:Array = ["CASEINSENSITIVE", "CASEINSENSITIVE", "NUMERIC", "NUMERIC"];

        public static var unityMainIsOpen:Boolean = false;
        public static var unityMenberIsOpen:Boolean = false;
        public static var unityLevel:int;
        public static var allUnityList:Array = [];
        public static var otherUnityArray:Array = [];
        public static var firstOnline:Boolean = true;
        public static var GuildFBOpenTime:Number = 0;
        public static var oneUnityId:int = 0;
        public static var IsOpenWorkView:Boolean = false;
        public static var GuildBattle_ApplyTargetGuildID:int = 0;
        public static var TmpIndex:int = 0;
        public static var GuildBattle_ApplyList:Array = [];
        public static var perfectNoticeIsOpen:Boolean = false;
        public static var unityObj:Object = new Object();
        public static var IsOpenChgLeaderView:Boolean = false;
        public static var IsOpenCreateGuildView:Boolean = false;
        public static var GuildBattle_SelfKillCnt:int = 0;
        public static var GuildBattle_MyEdKillCnt:int = 0;
        public static var isSelectUnity:Boolean = false;
        public static var updataArr:Array = [];
        public static var contributeIsOpen:Boolean = false;
        public static var GuildBattle_StartTime:Number = 0;
        public static var PerOpenTime:uint = 1800;
        public static var unityCurSelect:int = 0;
        public static var goodSaleList:Array = [];
        public static var SelectedItem:GridUnit = null;
        public static var GuildFB_CrossMode:int = -1;
        public static var IsLoadMyGuildInfo:Boolean = false;
        public static var GuildBattle_TargetGuildID:int = 0;
        public static var GuildFB_Line:uint = 0;
        public static var GuildBattle_TargetGuildName:String = "";
        public static var unityPage:int = 1;
        public static var applyViewIsOpen:Boolean = false;
        public static var isOpenJobManagerView:Boolean = false;
        public static var hireViewIsOpen:Boolean = false;
        public static var GuildBattle_PlayerInfoRankList:Array = [];
        public static var ordainIsOpen:Boolean = false;
        public static var DutyList:Array = [];
        public static var CurrentGuildSkillCDList:Dictionary = new Dictionary();
        public static var GuildEventList:Array = [];
        public static var allMenberList:Array = [];
        public static var GridUnitList:Array = [];
        public static var IsLoadMemberList:Boolean = false;
        public static var GuildLevelDef:Array = [0, 280000, 1008000, 0x2AF800, 0x5C4900, 12240000, 21120000, 36864000, 58240000, 89600000, 133200000, 193536000, 268464000, 373968000, 502208000];
        public static var playerId:int = 0;
        public static var respondUnity:String;
        public static var iscreating:int;
        public static var ApplyDataList:Array = [];
        public static var GuildBattle_MyKillCnt:int = 0;
        public static var isOpenNpcView:Boolean = false;
        public static var MaxMemberCntDic:Array = [0, 30, 40, 48, 53, 58, 62, 65, 68, 71, 73, 75, 77, 78, 79, 80];
        public static var myGuildInfo:GuildInfo = new GuildInfo();
        public static var GuildBattle_EnemyKillCnt:int = 0;
        public static var unityOtherNum:int = 5;
        public static var GuildBattle_DurationTime:int = 1800;

        public static function get GuildFBOpened():Boolean{
            return ((GuildFB_Line > 0));
        }
        public static function getGuildPlayerInfoById(_arg1:int):GuildPlayerInfo{
            var _local2:int;
            while (_local2 < UnityConstData.allMenberList.length) {
                if (_arg1 == UnityConstData.allMenberList[_local2].PlayerId){
                    return (UnityConstData.allMenberList[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public static function getGuildSalary():Object{
            var _local1:uint = (TaskCommonData.GetGuildQuestRewardStep(UnityConstData.getGuildPlayerInfoById(GameCommonData.Player.Role.Id).BuildValue) + 1);
            var _local2:int = UnityConstData.myGuildInfo.Level;
            var _local3:int;
            while ((((_local2 >= ((_local3 + 1) * 3))) && ((_local1 > _local3)))) {
                _local3++;
            };
            return ({
                item:11010001,
                cnt:_local3
            });
        }

    }
}//package GameUI.Modules.Unity.Data 
