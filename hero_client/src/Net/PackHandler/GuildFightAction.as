//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;

    public class GuildFightAction extends GameAction {

        private static var instance:GuildFightAction;

        private var _packet:NetPacket;

        public function GuildFightAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():GuildFightAction{
            if (instance == null){
                instance = new (GuildFightAction)();
            };
            return (instance);
        }

        private function updateGF(_arg1:NetPacket):void{
            var _local9:String;
            var _local10:String;
            var _local11:uint;
            var _local2:String = _arg1.ReadString();
            var _local3:String = _arg1.ReadString();
            GameCommonData.GuildFight_IsStarting = _arg1.readBoolean();
            var _local4:Array = [_local2, _local3];
            var _local5:Array = [];
            var _local6:uint = _arg1.readUnsignedInt();
            var _local7:int = _arg1.readUnsignedInt();
            var _local8:int;
            while (_local8 < _local7) {
                _local9 = _arg1.ReadString();
                _local10 = _arg1.ReadString();
                _local11 = _arg1.readUnsignedInt();
                _local5.push({
                    list:_local8,
                    guildname:_local9,
                    guilder:_local10,
                    roleid:_local11
                });
                _local8++;
            };
            sendNotification(EventList.UPDATE_GUILD_FIGHT_ITEM, {
                guildArray:_local5,
                infoArray:_local4,
                overTime:_local6
            });
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_GUILD_WAR_CMD:
                    updateGF(_arg1);
                    break;
                case Protocol.SMSG_CENTER_FUNC_STATE:
                    updateFuncState(_arg1);
                    break;
                default:
                    trace("公会战面板收到的服务器消息有问题");
            };
        }
        private function updateFuncState(_arg1:NetPacket):void{
            var _local4:uint;
            var _local5:Boolean;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint;
            _local3 = 0;
            while (_local3 < _local2) {
                _local4 = _arg1.readUnsignedInt();
                _local5 = _arg1.readBoolean();
                switch (_local4){
                    case 0:
                        GameCommonData.GuildFight_IsStarting = _local5;
                        GameCommonData.GuildFight_LineId = 1;
                        sendNotification(EventList.UPDATE_GUILD_FIGHT_ITEM);
                        break;
                    case 1:
                        GameCommonData.activityNight = _local5;
                        if (_local5){
                            if (((((GameCommonData.Player) && (GameCommonData.Player.Role))) && ((GameCommonData.Player.Role.Level >= 32)))){
                                facade.sendNotification(EventList.CONVOY_READY);
                            };
                        } else {
                            if (BtnManager.convoyBtn){
                                facade.sendNotification(EventList.CONVOY_OVER);
                            };
                        };
                        break;
                };
                _local3++;
            };
        }

    }
}//package Net.PackHandler 
