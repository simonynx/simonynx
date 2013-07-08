//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.Proxy {
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;

    public class DialogConstData {

        public static const CHATTYPE_TASK:uint = 0;
        public static const CHATTYPE_OTHER:uint = 1;
        public static const CHATTYPE_EXIT:uint = 2;

        private static var _instance:DialogConstData;

        public var lockNpcSelected:Boolean;
        private var newPersonTipDic:Dictionary;
        private var dic:Dictionary;

        public function DialogConstData(){
            dic = new Dictionary();
            dic[1] = "symbol_talk";
            dic[2] = "symbol_finish";
            dic[3] = "symbol_unFinish";
            dic[4] = "symbol_unAccpet";
            dic[5] = "symbol_transfer";
            dic[6] = "symbol_shop";
            dic[7] = "symbol_ask";
            dic[8] = "symbol_ask";
        }
        public static function getInstance():DialogConstData{
            if (_instance == null){
                _instance = new (DialogConstData)();
            };
            return (_instance);
        }

        public function getTaskSymbolByState(_arg1:uint):String{
            switch (_arg1){
                case 9:
                    return (dic[2]);
                case 5:
                    return (dic[3]);
                case 8:
                    return (dic[4]);
            };
            return (dic[4]);
        }
        public function getSymbolName(_arg1:uint):String{
            return (dic[_arg1]);
        }
        public function getNpcByMonsterId(_arg1:uint):GameElementAnimal{
            var _local2:String;
            for (_local2 in GameCommonData.SameSecnePlayerList) {
                if ((((GameCommonData.SameSecnePlayerList[_local2].Role.NpcFlags > 0)) && ((GameCommonData.SameSecnePlayerList[_local2].Role.MonsterTypeID == _arg1)))){
                    return (GameCommonData.SameSecnePlayerList[_local2]);
                };
            };
            return (null);
        }

    }
}//package GameUI.Modules.NPCChat.Proxy 
