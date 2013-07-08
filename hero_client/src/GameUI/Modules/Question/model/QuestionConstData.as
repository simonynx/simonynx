//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Question.model {
    import GameUI.Modules.Question.vo.*;

    public class QuestionConstData {

        public static var started:Boolean = false;
        public static var totalCnt:uint = 30;
        public static var rankLists:Array = [];
        public static var useDoubleCnt:uint = 0;
        public static var useBribeCnt:uint = 0;
        public static var currentScore:uint;
        public static var STATE_RESULT:int = 3;
        public static var STATE_QUESTION_END:int = 2;
        public static var totalDoubleCnt:uint = 3;
        public static var COST_BRIBE_GOLD:int = 1000;
        public static var STATE_QUESTION_ING:int = 1;
        public static var STATE_OVER:int = 4;
        public static var STATE_READY:int = 0;
        public static var currentQuestion:QuestionVo;

        public static function get totalBribeCnt():uint{
            if (GameCommonData.Player.Role.VIP == 1){
                return (4);
            };
            if (GameCommonData.Player.Role.VIP == 2){
                return (5);
            };
            if (GameCommonData.Player.Role.VIP == 3){
                return (7);
            };
            return (3);
        }
        public static function initData():void{
            currentScore = 0;
            useDoubleCnt = 0;
            useBribeCnt = 0;
            currentQuestion = null;
            rankLists = [];
        }
        public static function GetABCDFromIdx(_arg1:int):String{
            var _local2 = "";
            switch (_arg1){
                case 0:
                    _local2 = "A";
                    break;
                case 1:
                    _local2 = "B";
                    break;
                case 2:
                    _local2 = "C";
                    break;
                case 3:
                    _local2 = "D";
                    break;
            };
            return (_local2);
        }
        public static function CheckHasRight():Boolean{
            if (GameCommonData.Player.Role.Level < 25){
                return (false);
            };
            return (true);
        }

    }
}//package GameUI.Modules.Question.model 
