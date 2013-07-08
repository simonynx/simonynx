//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;

    public class ConvoyAction extends GameAction {

        private static var instance:ConvoyAction;

        public function ConvoyAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():ConvoyAction{
            if (instance == null){
                instance = new (ConvoyAction)();
            };
            return (instance);
        }

        private function colorChangeResult(_arg1:NetPacket):void{
            var _local2:Boolean = _arg1.readBoolean();
            if (!_local2){
                MessageTip.popup(LanguageMgr.GetTranslation("未刷出更高品质的货物"));
            } else {
                MessageTip.popup(LanguageMgr.GetTranslation("货物品质改变成功"));
            };
            UIFacade.GetInstance().sendNotification(EventList.REFRESH_CONVOY_QUALITY);
        }
        private function functionConfig(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            while (_local3 < 32) {
                if ((_local2 & (1 << _local3)) != 0){
                    GameCommonData.ModuleCloseConfig[_local3] = 1;
                } else {
                    GameCommonData.ModuleCloseConfig[_local3] = 0;
                };
                _local3++;
            };
            GameCommonData.OpenBoxConfig = GameCommonData.ModuleCloseConfig[0];
            facade.sendNotification(EventList.UPDATE_MODULE_STATUS);
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_ITEM_SACRIFICE:
                    colorChangeResult(_arg1);
                    break;
                case Protocol.SMSG_CONVOY_ROB:
                    convoyRob(_arg1);
                    break;
                case Protocol.SMSG_FUNCION_CONFIG:
                    functionConfig(_arg1);
                    break;
            };
        }
        private function convoyReady(_arg1:NetPacket):void{
            facade.sendNotification(EventList.CONVOY_READY);
        }
        private function convoyRob(_arg1:NetPacket):void{
            var exp_add:* = 0;
            var gold_add:* = 0;
            var count:* = 0;
            var gold:* = 0;
            var silver:* = 0;
            var copper:* = 0;
            var quality:* = 0;
            var packet:* = _arg1;
            var string:* = "";
            var type:* = packet.readByte();
            var func:* = function ():void{
            };
            switch (type){
                case 0:
                    exp_add = packet.readUnsignedInt();
                    string = (LanguageMgr.GetTranslation("护送失败获经验") + String(exp_add));
                    UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                        comfrim:func,
                        cancel:null,
                        isShowClose:false,
                        info:string,
                        title:LanguageMgr.GetTranslation("提 示"),
                        comfirmTxt:LanguageMgr.GetTranslation("确定")
                    });
                    break;
                case 1:
                    exp_add = packet.readUnsignedInt();
                    gold_add = packet.readUnsignedInt();
                    count = packet.readUnsignedInt();
                    gold = uint((gold_add / 10000));
                    silver = uint(((gold_add % 10000) / 100));
                    copper = (gold_add % 100);
                    if (count == 3){
                        string = LanguageMgr.GetTranslation("拦截成功提示句1", String(exp_add), String(gold), String(silver), String(copper));
                    } else {
                        string = LanguageMgr.GetTranslation("拦截成功提示句2", String(exp_add), String(gold), String(silver), String(copper), String((3 - count)));
                    };
                    UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                        comfrim:func,
                        cancel:null,
                        isShowClose:false,
                        info:string,
                        title:"提 示",
                        comfirmTxt:"确定"
                    });
                    break;
                case 2:
                    quality = packet.readUnsignedInt();
                    GameCommonData.Player.Role.ConvoyFlag = (quality + 1);
                    break;
            };
        }

    }
}//package Net.PackHandler 
