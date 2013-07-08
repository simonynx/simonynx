//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import OopsEngine.Skill.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.AutoPlay.Data.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class PlayerSkillCoolDown extends GameAction {

        private static var instance:PlayerSkillCoolDown;

        public function PlayerSkillCoolDown(_arg1:Boolean=true){
            super(_arg1);
            if (instance != null){
                throw (new Error("单体"));
            };
        }
        public static function getInstance():PlayerSkillCoolDown{
            if (instance == null){
                instance = new (PlayerSkillCoolDown)();
            };
            return (instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            var _local2:SkillInfo;
            var _local3:Date;
            var _local4:Object;
            var _local8:InventoryItemInfo;
            var _local9:uint;
            var _local5:int = _arg1.readUnsignedInt();
            var _local6:int = _arg1.readUnsignedByte();
            var _local7:int;
            while (_local7 < _local6) {
                _local4 = {};
                _local4.idUser = _local5;
                _local4.magicid = _arg1.readUnsignedInt();
                _local4.infotype = _arg1.readUnsignedShort();
                _local4.privateTotalCdTime = _arg1.readUnsignedInt();
                _local4.privateCdTime = _arg1.readUnsignedInt();
                if ((((_local4.privateCdTime > 0)) && (((_local4.privateTotalCdTime - _local4.privateCdTime) >= 0)))){
                    sendNotification(EventList.RECEIVE_COOLDOWN_MSG, _local4);
                };
                if ((((AutoPlayData.MagicWeaponSkillId == _local4.magicid)) && ((_local4.idUser == GameCommonData.Player.Role.Id)))){
                    _local8 = RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_TREASURE];
                    _local9 = (((_local8.Strengthen + 1))<IntroConst.TreasureExp.length) ? IntroConst.TreasureExp[(_local8.Strengthen + 1)] : 0;
                    if (_local8.Experience < (IntroConst.TreasureExp[_local8.Strengthen] + _local9)){
                        _local8.Experience++;
                        sendNotification(AutoPlayEventList.UPDATE_TREASURE_EXP, {
                            level:_local8.Strengthen,
                            exp:_local8.Experience
                        });
                    };
                    GameCommonData.treasureSoul++;
                    sendNotification(EquipCommandList.REFRESH_SACRIFICE_SOUL);
                };
                if (((!((GameCommonData.Player == null))) && ((GameCommonData.Player.Role.Id == _local4.idUser)))){
                    _local2 = (GameCommonData.SkillList[_local4.magicid] as SkillInfo);
                    if (_local2 != null){
                        _local3 = new Date();
                        _local2.AutomatismUseTime = (_local3.time + _local4.privateCdTime);
                    };
                };
                _local7++;
            };
            sendNotification(EventList.RECEIVE_CD_PUBLIC_MSG, 1000);
        }

    }
}//package Net.PackHandler 
