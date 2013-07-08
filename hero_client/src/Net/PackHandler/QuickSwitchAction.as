//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import Net.*;
    import GameUI.Modules.MainScene.Data.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.AutoPlay.command.*;

    public class QuickSwitchAction extends GameAction {

        private static const BAG_TYPE:int = 2;
        private static const SKILL_TYPE:int = 1;

        private static var instance:QuickSwitchAction;

        public function QuickSwitchAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():QuickSwitchAction{
            if (instance == null){
                instance = new (QuickSwitchAction)();
            };
            return (instance);
        }

        private function getQuickOperateResult(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:int;
            var _local2:int = _arg1.readUnsignedInt();
            if (_local2 == 0){
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("快捷栏操作成功"),
                    color:0xFFFF00
                });
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_HOTKEY_STATE:
                    getQuickList(_arg1);
                    break;
                case Protocol.SMSG_HOTKEY_OPERATE:
                    getQuickOperateResult(_arg1);
                    break;
            };
        }
        private function getQuickList(_arg1:NetPacket):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:SkillUseItem;
            var _local9:SkillInfo;
            var _local10:UseItem;
            var _local11:int;
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int;
            var _local12:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local13:Dictionary = QuickBarData.getInstance().expandKeyDic;
            var _local14:Dictionary = _local12;
            while (_local3 < _local2) {
                _local4 = _arg1.readUnsignedInt();
                _local6 = _arg1.readUnsignedInt();
                _local7 = _arg1.readUnsignedInt();
                _local11 = _arg1.readByte();
                _local5 = _local4;
                if (_local4 > 7){
                    _local5 = (_local4 - 8);
                    _local14 = _local13;
                };
                if (_local6 == SKILL_TYPE){
                    _local8 = new SkillUseItem(_local5);
                    _local8.x = 2;
                    _local8.y = 2;
                    _local9 = SkillManager.getIdSkillInfo(_local7);
                    _local8.setLearnSkillInfo(_local9);
                    _local14[_local5] = _local8;
                } else {
                    _local10 = new UseItem(-1, _local7, null);
                    _local10.x = 2;
                    _local10.y = 2;
                    _local10.IsBind = _local11;
                    _local14[_local5] = _local10;
                };
                if (_local5 == 8){
                    _local14[8] = null;
                    sendNotification(AutoPlayEventList.UPDATE_ITEM, {
                        item:_local10,
                        type:0
                    });
                };
                if (_local5 == 9){
                    _local14[9] = null;
                    sendNotification(AutoPlayEventList.UPDATE_ITEM, {
                        item:_local10,
                        type:1
                    });
                };
                _local3++;
            };
            sendNotification(EventList.CHANGE_QUICKBAR_UI);
        }

    }
}//package Net.PackHandler 
