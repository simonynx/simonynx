//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Pet.Mediator.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetAction extends GameAction {

        private static var _instance:PetAction;

        private var dataProxy:DataProxy;

        public function PetAction(_arg1:Boolean=true){
            super(_arg1);
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
        }
        public static function getInstance():PetAction{
            if (!_instance){
                _instance = new (PetAction)();
            };
            return (_instance);
        }

        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_PET_SELECT_TO_BATTLE:
                    toBattleHandler(_arg1);
                    break;
                case Protocol.SMSG_PET_BACK_TO_REST:
                    restHandler(_arg1);
                    break;
                case Protocol.SMSG_PET_RENAME:
                    renameHandler(_arg1);
                    break;
            };
        }
        private function restHandler(_arg1:NetPacket):void{
            var _local2:int = _arg1.readShort();
            if ((((_local2 >= ItemConst.EQUIPMENT_SLOT_PET0)) && ((_local2 <= ItemConst.EQUIPMENT_SLOT_PET_END)))){
                if (((RolePropDatas.ItemList[_local2]) && (RolePropDatas.ItemList[_local2].PetInfo))){
                    (RolePropDatas.ItemList[_local2] as InventoryItemInfo).PetInfo.IsUsing = false;
                    if (GameCommonData.Player.Role.UsingPet){
                        GameCommonData.Player.Role.UsingPet.IsUsing = false;
                        GameCommonData.Player.Role.UsingPet = null;
                    };
                };
                (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).updatePetList();
            };
        }
        private function toBattleHandler(_arg1:NetPacket):void{
            var _local2:int = _arg1.readShort();
            if ((((_local2 >= ItemConst.EQUIPMENT_SLOT_PET0)) && ((_local2 <= ItemConst.EQUIPMENT_SLOT_PET_END)))){
                if (((RolePropDatas.ItemList[_local2]) && (RolePropDatas.ItemList[_local2].PetInfo))){
                    (RolePropDatas.ItemList[_local2] as InventoryItemInfo).PetInfo.IsUsing = true;
                    GameCommonData.Player.Role.UsingPet = (RolePropDatas.ItemList[_local2] as InventoryItemInfo).PetInfo;
                    RolePropDatas.lastOutPet = _local2;
                };
                (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).updatePetList();
                if ((((NewGuideData.curType == 8)) && ((NewGuideData.curStep == 5)))){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:8,
                        STEP:6
                    });
                };
            };
        }
        private function renameHandler(_arg1:NetPacket):void{
            var _local3:uint;
            var _local4:uint;
            var _local5:String;
            var _local6:String;
            var _local7:GameElementPlayer;
            var _local2:uint = _arg1.readByte();
            if (_local2 == 0){
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                _local5 = _arg1.ReadString();
                if (_local3 == GameCommonData.Player.Role.Id){
                    if (((((RolePropDatas.ItemList[_local4]) && (RolePropDatas.ItemList[_local4].PetInfo.IsUsing))) && (GameCommonData.Player.Role.UsingPetAnimal))){
                        GameCommonData.Player.Role.UsingPetAnimal.SetName(_local5);
                    };
                    (facade.retrieveMediator(PetRenameMediator.NAME) as PetRenameMediator).updatePetName(_local3, _local4, _local5);
                };
                for (_local6 in GameCommonData.SameSecnePlayerList) {
                    if ((GameCommonData.SameSecnePlayerList[_local6] is GameElementPlayer)){
                        _local7 = GameCommonData.SameSecnePlayerList[_local6];
                        if (((_local7) && ((_local7.Role.Id == _local3)))){
                            if (_local7.Role.UsingPetAnimal){
                                _local7.Role.UsingPetAnimal.SetName(_local5);
                                break;
                            };
                        };
                    };
                };
            };
        }

    }
}//package Net.PackHandler 
