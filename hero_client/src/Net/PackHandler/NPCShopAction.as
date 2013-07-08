//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.NPCExchange.Mediator.*;
    import GameUI.Modules.NPCShop.Mediator.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.NPCShop.Data.*;

    public class NPCShopAction extends GameAction {

        private static var _instance:NPCShopAction;

        public function NPCShopAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():NPCShopAction{
            if (!_instance){
                _instance = new (NPCShopAction)();
            };
            return (_instance);
        }

        private function updateTowerShopNum(_arg1:NetPacket):void{
            var _local7:String;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:uint;
            var _local6:uint;
            _local5 = 0;
            while (_local5 < NPCExchangeConstData.goodList[NPCExchangeConstData.towerMosterID].length) {
                _local6 = 0;
                while (_local6 < NPCExchangeConstData.goodList[NPCExchangeConstData.towerMosterID][_local5].length) {
                    if (NPCExchangeConstData.goodList[NPCExchangeConstData.towerMosterID][_local5][_local6].ShopId == _local3){
                        NPCExchangeConstData.goodList[NPCExchangeConstData.towerMosterID][_local5][_local6].curr_amount = _local4;
                        _local7 = GameCommonData.SameSecnePlayerList[_local2].Role.Name;
                        UIFacade.GetInstance().sendNotification(EventList.UPDATENPCEXCHANGEVIEW, {
                            npcId:_local2,
                            shopName:_local7
                        });
                        return;
                    };
                    _local6++;
                };
                _local5++;
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_LIST_INVENTORY:
                    getNPCShopList(_arg1);
                    break;
                case Protocol.SMSG_TOWER_VENDOR:
                    getTowerShopList(_arg1);
                    break;
                case Protocol.SMSG_TOWER_VENDOR_UPDATE:
                    updateTowerShopNum(_arg1);
                    break;
            };
        }
        private function getNPCShopList(_arg1:NetPacket):void{
            var _local2:ShopItemInfo;
            var _local8:String;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint;
            if (GameCommonData.SameSecnePlayerList[_local3]){
                _local4 = GameCommonData.SameSecnePlayerList[_local3].Role.MonsterTypeID;
            };
            var _local5:uint = _arg1.readUnsignedInt();
            var _local6:int = _arg1.readUnsignedInt();
            if (_local6 == 0){
                MessageTip.popup(LanguageMgr.GetTranslation("活动进行时才开放兑换"));
                return;
            };
            if (_local5 == 0){
                NPCShopConstData.goodList[_local4] = [[], [], [], [], []];
            } else {
                if (_local5 == 1){
                    NPCExchangeConstData.goodList[_local4] = [[], [], [], [], []];
                };
            };
            var _local7:int;
            while (_local7 < _local6) {
                _local2 = new ShopItemInfo();
                _local2.ReadFromPacket(_arg1);
                if (_local5 == 0){
                    if (_local2.MainClass == ItemConst.ITEM_CLASS_EQUIP){
                        if (_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE){
                            NPCShopConstData.goodList[_local4][3].push(_local2);
                        } else {
                            if (_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH){
                                NPCShopConstData.goodList[_local4][1].push(_local2);
                            } else {
                                if (_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT){
                                    NPCShopConstData.goodList[_local4][2].push(_local2);
                                } else {
                                    if (_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON){
                                        NPCShopConstData.goodList[_local4][0].push(_local2);
                                    } else {
                                        if ((((((_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)) || ((_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY)))) || ((_local2.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK)))){
                                            NPCShopConstData.goodList[_local4][0].push(_local2);
                                        } else {
                                            NPCShopConstData.goodList[_local4][0].push(_local2);
                                        };
                                    };
                                };
                            };
                        };
                    } else {
                        NPCShopConstData.goodList[_local4][0].push(_local2);
                    };
                } else {
                    if (((!((_local2.Job == 0))) && (!((_local2.Job == GameCommonData.Player.Role.CurrentJobID))))){
                    } else {
                        if (_local2.ClassTypeFlag == 100){
                            NPCExchangeConstData.goodList[_local4][0].push(_local2);
                        } else {
                            if (_local2.MainClass == ItemConst.ITEM_CLASS_EQUIP){
                                switch (_local2.SubClass){
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON:
                                        NPCExchangeConstData.goodList[_local4][0].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_SHOE:
                                        NPCExchangeConstData.goodList[_local4][3].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH:
                                        NPCExchangeConstData.goodList[_local4][1].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_HAT:
                                        NPCExchangeConstData.goodList[_local4][2].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY:
                                        NPCExchangeConstData.goodList[_local4][3].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK:
                                        NPCExchangeConstData.goodList[_local4][4].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE:
                                        NPCExchangeConstData.goodList[_local4][0].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_RING:
                                        NPCExchangeConstData.goodList[_local4][1].push(_local2);
                                        break;
                                    case ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY:
                                        NPCExchangeConstData.goodList[_local4][2].push(_local2);
                                        break;
                                    default:
                                        NPCExchangeConstData.goodList[_local4][0].push(_local2);
                                };
                            } else {
                                NPCExchangeConstData.goodList[_local4][0].push(_local2);
                            };
                        };
                    };
                };
                _local7++;
            };
            if (_local5 == 0){
                UIFacade.GetInstance().registerMediator(new NPCShopMediator());
                _local8 = LanguageMgr.GetTranslation("VIP药店");
                if (GameCommonData.SameSecnePlayerList[_local3]){
                    _local8 = GameCommonData.SameSecnePlayerList[_local3].Role.Name;
                };
                UIFacade.GetInstance().sendNotification(EventList.SHOWNPCSHOPVIEW, {
                    npcId:_local3,
                    shopType:1,
                    shopName:_local8
                });
            } else {
                UIFacade.GetInstance().registerMediator(new NPCExchangeMediator());
                _local8 = GameCommonData.SameSecnePlayerList[_local3].Role.Name;
                UIFacade.GetInstance().sendNotification(EventList.SHOWNPCEXCHANGEVIEW, {
                    npcId:_local3,
                    shopName:_local8
                });
            };
        }
        private function getTowerShopList(_arg1:NetPacket):void{
            var _local2:ShopItemInfo;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = GameCommonData.SameSecnePlayerList[_local3].Role.MonsterTypeID;
            NPCExchangeConstData.towerMosterID = _local4;
            var _local5:int = _arg1.readUnsignedInt();
            if (_local5 == 0){
                return;
            };
            NPCExchangeConstData.goodList[_local4] = [[], [], [], [], []];
            var _local6:int;
            while (_local6 < _local5) {
                _local2 = new ShopItemInfo();
                _local2.ReadFromPacket(_arg1);
                _local2.curr_amount = _arg1.readUnsignedInt();
                NPCExchangeConstData.goodList[_local4][0].push(_local2);
                _local6++;
            };
            UIFacade.GetInstance().registerMediator(new NPCExchangeMediator());
            var _local7:String = GameCommonData.SameSecnePlayerList[_local3].Role.Name;
            UIFacade.GetInstance().sendNotification(EventList.SHOWNPCEXCHANGEVIEW, {
                npcId:_local3,
                shopName:_local7
            });
        }

    }
}//package Net.PackHandler 
