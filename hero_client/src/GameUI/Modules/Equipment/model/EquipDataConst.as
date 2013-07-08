//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.model {
    import flash.display.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Equipment.mediator.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class EquipDataConst {

        public static const HEIGHT:int = 376;
        public static const WIDTH:int = 580;

        public static var treasureProps:Array = ["攻击", "生命", "魔法", "眩晕抗性", "虚弱抗性", "昏睡抗性", "魅惑抗性", "定身抗性"];
        public static var equipRefineItems:Dictionary = new Dictionary();
        public static var highStrengNeed:Array = [2000, 2000, 2000, 2000, 2000, 9260, 26500, 41400, 56700, 94000, 129600];
        public static var equipComposeNeed:Array = [0, 0, 120, 480, 1800, 3400, 9000, 17000, 27200];
        public static var equipActiveNeed:uint = 100;
        public static var equipParts:Array = ["武  器", "帽  子", "衣  服", "鞋  子"];
        public static var equipIdentifyNeed:Array = [0, 0, 0, 0, 0, 4500, 8500, 13600, 22800];
        public static var treasureResetNeed:uint = 10000;
        public static var treasureSouldGet:Array = [259, 529, 799, 1069, 1339, 1609, 1879, 2149, 2419, 2689, 2959, 3229];
        public static var treasureSouldNeed:Array = [50, 200, 9, 25, 59, 169, 399, 999, 1999, 3999, 6999, 11999];
        public static var treasureRebuildNeed:uint = 0;
        public static var treasureBatchRebuilds:Array = new Array();
        public static var purpleStrengNeed:Array = [2000, 1, 2000, 2000, 2000, 18520, 66250, 124200, 198450, 376000, 583200];
        public static var equipUnEmbedNeed:Array = [0, 1500, 6000, 22500, 42500, 112500, 212500, 340000, 570000];
        public static var treasureTransformNeed:uint = 2000000;
        public static var petUpgradeNeed:Array = [100, 2500, 10000, 22500, 40000];
        public static var equipEmbedNeed:Array = [0, 300, 1200, 4500, 8500, 22500, 42500, 68000, 114000];
        public static var petBatchRebuilds:Array = new Array();
        public static var strengNeed:Array = [9, 37, 425, 1000, 2370, 4630, 10600, 13800, 16200, 23500, 28800];
        public static var treasureTransformUse:uint = 50700055;
        public static var strengtQulity:Array = [EquipDataConst.strengNeed, EquipDataConst.highStrengNeed, EquipDataConst.highStrengNeed, EquipDataConst.purpleStrengNeed];
        public static var SoulFullValue:uint = 3196;
        public static var equipTransformNeed:uint = 2000000;
        public static var petStrengthenNeed:Array = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000, 10000];
        public static var equipPourNeed:uint = 100;
        public static var treasureTransferNeed:uint = 10000;
        public static var equipTransferNeed:uint = 10000000;
        public static var equipRefineNeed:uint = 2000000;
        private static var _instance:EquipDataConst;
        public static var treasureSacrificeNeed:uint = 2000;
        public static var EquipStrengthenMediator:Mediator;

        private var ei:EquipInterface;
        private var cv:CommonView;

        public function EquipDataConst(){
            var _local1:uint;
            _local1 = 0;
            while (_local1 < 10) {
                treasureBatchRebuilds[_local1] = new Array();
                petBatchRebuilds[_local1] = new Array();
                _local1++;
            };
            super();
        }
        public static function getInstance():EquipDataConst{
            if (_instance == null){
                _instance = new (EquipDataConst)();
            };
            return (_instance);
        }
        public static function checkInCrossServer(_arg1:int):Boolean{
            var _local2:String;
            var _local3:String;
            if (GameCommonData.IsInCrossServer){
                _local2 = LanguageMgr.GetTranslation("跨服战中不能打开界面");
                if (_arg1 == 1){
                    _local3 = "锻造";
                } else {
                    _local3 = "神兵";
                };
                _local2 = _local2.replace("00", _local3);
                MessageTip.show(_local2);
                return (true);
            };
            return (false);
        }

        public function getFeeByValue(_arg1:uint, _arg2:String, _arg3:String="#ffffff", _arg4:String="#ffffff"):String{
            var _local5:String;
            if (_arg1 == 0){
                return ((((((("<font color=\"" + _arg3) + "\">") + _arg2) + "</font><font color=\"") + _arg4) + "\">0\\cc</font>"));
            };
            _local5 = (((((("<font color=\"" + _arg3) + "\">") + _arg2) + "</font><font color=\"") + _arg4) + "\">");
            var _local6:uint = (_arg1 / 10000);
            var _local7:uint = uint(((_arg1 % 10000) / 100));
            var _local8:uint = (_arg1 % 100);
            if (_local6 > 0){
                _local5 = (_local5 + (String(_local6) + "\\ce"));
            };
            if (_local7 > 0){
                _local5 = (_local5 + (String(_local7) + "\\cs"));
            };
            if (_local8 > 0){
                _local5 = (_local5 + (String(_local8) + "\\cc"));
            };
            _local5 = (_local5 + "</font>");
            return (_local5);
        }
        public function getSacrificeTips():String{
            var _local1:String;
            var _local2:uint = GameCommonData.activityData[0];
            if (_local2 >= 12){
                _local1 = LanguageMgr.GetTranslation("获取魂值次数已满");
            } else {
                if (_local2 < 2){
                    if (EquipDataConst.treasureSouldNeed[_local2] < 100){
                        _local1 = LanguageMgr.GetTranslation("花费x银币可以获取x魂值", treasureSouldNeed[_local2], treasureSouldGet[_local2]);
                    } else {
                        _local1 = LanguageMgr.GetTranslation("花费x金币可以获取x魂值", (treasureSouldNeed[_local2] / 100), treasureSouldGet[_local2]);
                    };
                } else {
                    _local1 = LanguageMgr.GetTranslation("花费x金叶子可以获取x魂值", treasureSouldNeed[_local2], treasureSouldGet[_local2]);
                };
            };
            return (_local1);
        }
        public function getCDTimeTips():String{
            var _local1:String;
            var _local2:int = (GameCommonData.treasureCDTime - (TimeManager.Instance.Now().time / 1000));
            if (_local2 <= 0){
                _local1 = LanguageMgr.GetTranslation("无需冷却");
            } else {
                _local1 = LanguageMgr.GetTranslation("花费x个金叶子可将冷却时间置0", String((uint(((_local2 + 599) / 600)) * 2)));
            };
            return (_local1);
        }

    }
}//package GameUI.Modules.Equipment.model 
