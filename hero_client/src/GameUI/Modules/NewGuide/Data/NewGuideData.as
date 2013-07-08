//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Data {

    public class NewGuideData {

        public static const TASK_7:int = 1008;
        public static const TASK_9:int = 1010;
        public static const CANSALEITEMS:Array = [20102001, 20112001, 20122001, 20132001, 20142001, 20152001, 20210001, 20220001, 20230001, 20240001, 20250001, 20310001, 20320001, 20330001, 20340001, 20350001, 20410001, 20420001, 20430001, 20440001, 20450001];
        public static const TASK_10:int = 1011;
        public static const TASK_11:int = 1012;
        public static const TASK_12:int = 1013;
        public static const TASK_13:int = 1014;
        public static const TASK_14:int = 1001;
        public static const TASK_15:int = 1015;
        public static const TASK_16:int = 1016;
        public static const TASK_17:int = 1017;
        public static const TASK_18:int = 1018;
        public static const TASK_SHOWBTN_SHILIAN:int = 1227;
        public static const TASK_19:int = 1019;
        public static const TASK_TREASURE:int = 1124;
        public static const TASK_22:int = 1102;
        public static const TASK_CONSIGNMENT:int = 2201;
        public static const ITEMTEMPID_SSSP:int = 50700004;
        public static const TASK_TRANS:int = 1132;
        public static const TASK_SHOWBTN_TREASURE:int = 1103;
        public static const ITEMTEMPID_NEWBOX10_1:uint = 20210001;
        public static const ITEMTEMPID_NEWBOX10_2:uint = 20310001;
        public static const ITEMTEMPID_NEWBOX1_2:uint = 20300001;
        public static const ITEMTEMPID_NEWBOX1_3:uint = 20400001;
        public static const ITEMTEMPID_NEWBOX10:uint = 50200001;
        public static const ITEMTEMPID_NEWBOX10_3:uint = 20410001;
        public static const ITEMTEMPID_NEWBOX1_1:uint = 20200001;
        public static const TASK_SHOWBTN_PETRACE:int = 1308;
        public static const TASK_SHENGYUAN_SINGLE:int = 1233;
        public static const TASK_FLY:int = 1133;
        public static const TASK_STORAGE:int = 1125;
        public static const ITEMTEMPID_MPYAO_SMALL:uint = 30100101;
        public static const TASK_SHOWBTN_STRENGTHEN:int = 1124;
        public static const TASK_JOBS:Array = [2001, 2002, 2003, 2004, 2005];
        public static const ITEMTEMPID_NEWBOX1:uint = 50200004;
        public static const ITEMTEMPID_YXZH:int = 20600001;
        public static const ITEMTEMPID_HPYAO_SMALL:uint = 30100001;
        public static const TASK_1:int = 1002;
        public static const TASK_EQUIPEXCHANGE:int = 1232;
        public static const TASK_4:int = 1005;
        public static const TASK_5:int = 1006;
        public static const TASK_6:int = 1007;
        public static const TASK_8:int = 1009;
        public static const TASK_2:int = 1003;

        public static var IsShowEd_GuildPick:Boolean = false;
        public static var CurrentTaskId:int;
        public static var PointNPCIsOpen:Boolean = false;
        private static var _curType:uint = 0;
        public static var newerHelpIsOpen:Boolean = false;
        public static var StepArr:Array = [0, 10];
        private static var _curStep:uint = 0;

        public static function get curStep():uint{
            return (_curStep);
        }
        public static function CheckStepFinsh(_arg1:int, _arg2:int):Boolean{
            return (true);
        }
        public static function set curType(_arg1:uint):void{
            _curType = _arg1;
        }
        public static function set curStep(_arg1:uint):void{
            _curStep = _arg1;
        }
        public static function get curType():uint{
            return (_curType);
        }

    }
}//package GameUI.Modules.NewGuide.Data 
