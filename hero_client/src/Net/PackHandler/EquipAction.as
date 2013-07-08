//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Command.*;

    public class EquipAction extends GameAction {

        private static var LEARNSKILL_LEVELLIMIT:uint = 3;
        private static var LEARNSKILL_TOPLEVEL:uint = 4;
        private static var PETSMSG_REBUILD:uint = 0;
        private static var LEARNSKILL_FAIL:uint = 1;
        private static var LEARNSKILL_SUCCESS:uint = 0;
        private static var _instance:EquipAction;
        private static var LEARNSKILL_WRONGSKILL:uint = 2;
        private static var PETSMSG_STRENGTHEN:uint = 1;
        private static var PETSMSG_LEARNSKILL:uint = 2;

        public function EquipAction(_arg1:Boolean=true){
            super(_arg1);
        }
        public static function getInstance():EquipAction{
            if (!_instance){
                _instance = new (EquipAction)();
            };
            return (_instance);
        }

        private function batchRebuild(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint;
            var _local5:uint;
            if (_local2 == 0){
                if (_local3 == 2){
                    facade.sendNotification(EquipCommandList.SAVE_TREASURE_BATCH, _local3);
                } else {
                    if (_local3 == 1){
                        facade.sendNotification(EquipCommandList.SAVE_PET_BATCH, _local3);
                    };
                };
            } else {
                if (_local3 == 1){
                    _local4 = 0;
                    while (_local4 < 10) {
                        _local5 = 0;
                        while (_local5 < 5) {
                            EquipDataConst.petBatchRebuilds[_local4][_local5] = _arg1.readUnsignedInt();
                            _local5++;
                        };
                        _local4++;
                    };
                    facade.sendNotification(EquipCommandList.REFRESH_PET_BATCH);
                } else {
                    if (_local3 == 2){
                        _local4 = 0;
                        while (_local4 < 10) {
                            _local5 = 0;
                            while (_local5 < 5) {
                                EquipDataConst.treasureBatchRebuilds[_local4][_local5] = _arg1.readUnsignedInt();
                                _local5++;
                            };
                            _local4++;
                        };
                        facade.sendNotification(EquipCommandList.REFRESH_TREASURE_BATCH);
                    };
                };
            };
        }
        private function itemActivateResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Boolean = _arg1.readBoolean();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:InventoryItemInfo = BagData.getItemById(_local2);
            if (_local5 == null){
                _local5 = RolePropDatas.getItemById(_local2);
                if (_local5 == null){
                    UIFacade.GetInstance().sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("物品出错"),
                        color:0xFFFF00
                    });
                    return;
                };
            };
            if (_local3){
                MessageTip.popup(LanguageMgr.GetTranslation("激活成功"));
                if (_local4 == 0){
                    _local5.Add1 = (_local5.Add1 + 1000000);
                } else {
                    if (_local4 == 1){
                        _local5.Add2 = (_local5.Add2 + 1000000);
                    } else {
                        if (_local4 == 2){
                            _local5.Add3 = (_local5.Add3 + 1000000);
                        };
                    };
                };
            } else {
                MessageTip.popup(LanguageMgr.GetTranslation("激活失败"));
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_ACTIVE, {
                sucess:_local3,
                index:_local4
            });
        }
        private function treasureResetResult(_arg1:NetPacket):void{
            var _local2:Boolean;
            if (_local2){
                MessageTip.popup(LanguageMgr.GetTranslation("重生成功"));
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_TREASURE_RESET, _local2);
        }
        private function itemEmbedResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            MessageTip.popup(LanguageMgr.GetTranslation("镶嵌成功"));
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_EMBED);
        }
        private function equipTransferResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            if (_local2 == 0){
                MessageTip.popup(LanguageMgr.GetTranslation("融合成功"));
                UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_TRANSFER);
            } else {
                if (_local2 == 1){
                    MessageTip.popup(LanguageMgr.GetTranslation("转移成功"));
                    UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_TREASURE_TRANSFORM);
                } else {
                    if (_local2 == 3){
                        MessageTip.popup(LanguageMgr.GetTranslation("转移成功"));
                        UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_TRANSFORM);
                    };
                };
            };
        }
        private function itemBreakResult(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:uint = _arg1.readUnsignedInt();
            if (_local3 == 0){
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("分解失败")) + "</font>");
                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            } else {
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("分解成功")) + "</font>");
                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_BREAK, _local3);
            UIFacade.GetInstance().sendNotification(EventList.UPDATEBAG);
        }
        private function runeUnEmbedResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            MessageTip.popup(LanguageMgr.GetTranslation("拆除成功"));
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_EMBED);
        }
        private function itemPourResult(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:Boolean = _arg1.readBoolean();
            if (_local3){
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("合成成功")) + "</font>");
                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            } else {
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("合成失败")) + "</font>");
                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_POUR, _local3);
        }
        private function treasureLevelUpResult(_arg1:NetPacket):void{
            MessageTip.popup(LanguageMgr.GetTranslation("神兵升级成功"));
        }
        private function treasureRebuildResult(_arg1:NetPacket):void{
            var _local2:Boolean;
            if (_local2){
                MessageTip.popup(LanguageMgr.GetTranslation("洗炼成功"));
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_TREASURE_REBUILD, _local2);
        }
        private function itemOrnamentUpStarResult(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Boolean = _arg1.readBoolean();
            if (_local4){
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("饰品升星成功")) + "</font>");
            } else {
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("饰品升星失败")) + "</font>");
            };
            UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_UPSTAR_ACTIVE, {success:_local4});
        }
        override public function Processor(_arg1:NetPacket):void{
            switch (_arg1.opcode){
                case Protocol.SMSG_ITEM_STRENGTH:
                    itemStrengthResult(_arg1);
                    break;
                case Protocol.SMSG_ORNAMENT_STRENGTHEN:
                    itemOrnamentUpStarResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_POUR:
                    itemPourResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_BREAK:
                    itemBreakResult(_arg1);
                    break;
                case Protocol.SMSG_TREASURE_LEVELUP:
                    treasureLevelUpResult(_arg1);
                    break;
                case Protocol.SMSG_TREASURE_SACRIFICE:
                    treasureSacrificeResult(_arg1);
                    break;
                case Protocol.SMSG_TREASURE_RESET:
                    treasureResetResult(_arg1);
                    break;
                case Protocol.SMSG_TREASURE_REBUILD:
                    treasureRebuildResult(_arg1);
                    break;
                case Protocol.SMSG_TREASURE_SKILLCHANGE:
                    treasureTransferResult(_arg1);
                    break;
                case Protocol.SMSG_PET_RESULT:
                    petResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_ACTIVATE:
                    itemEmbedResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_COMPOSE:
                    runeComposeResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_GET_OUT:
                    runeUnEmbedResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_IDENTIFY:
                    runeIdentifyResult(_arg1);
                    break;
                case Protocol.SMSG_ITEM_TRANSFER:
                    equipTransferResult(_arg1);
                    break;
                case Protocol.SMSG_EQUIP_COMPOSE:
                    equipRefine(_arg1);
                    break;
                case Protocol.SMSG_SOUL_BOOM:
                    soulBoom(_arg1);
                    break;
                case Protocol.SMSG_BATCH_REBUILD:
                    batchRebuild(_arg1);
                    break;
            };
        }
        private function runeComposeResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:Boolean = _arg1.readBoolean();
            if (_local3){
                MessageTip.popup(LanguageMgr.GetTranslation("合成成功"));
            } else {
                MessageTip.popup(LanguageMgr.GetTranslation("合成失败"));
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_COMPOSE, _local3);
        }
        private function treasureTransferResult(_arg1:NetPacket):void{
            var _local2:Boolean;
            if (_local2){
                MessageTip.popup(LanguageMgr.GetTranslation("转换成功"));
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_TREASURE_TRANSFER, _local2);
        }
        private function itemStrengthResult(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:Boolean = _arg1.readBoolean();
            var _local5:Boolean = _arg1.readBoolean();
            if (_local4){
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("强化成功")) + "</font>");
                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            } else {
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("强化失败")) + "</font>");
                UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_STRENGTH, {
                sucess:_local4,
                protect:_local5
            });
        }
        private function runeIdentifyResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            MessageTip.popup(LanguageMgr.GetTranslation("符文鉴定成功"));
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_IDENTIFY);
        }
        private function petResult(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local3 == PETSMSG_REBUILD){
                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("洗炼成功")) + "</font>");
                facade.sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
                facade.sendNotification(EquipCommandList.REFRESH_PET_REBUILD);
            } else {
                if (_local3 == PETSMSG_STRENGTHEN){
                    if (_local4 == 0){
                        facade.sendNotification(EquipCommandList.REFRESH_PET_STRENGTHEN, {sucess:true});
                        facade.sendNotification(Guide_PetUpstarCommand.NAME, {step:4});
                    } else {
                        if (_local4 == 1){
                            facade.sendNotification(EquipCommandList.REFRESH_PET_STRENGTHEN, {sucess:false});
                            facade.sendNotification(Guide_PetUpstarCommand.NAME, {step:4});
                        } else {
                            if (_local4 == 2){
                                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("提升已达到上限")) + "</font>");
                                facade.sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
                                facade.sendNotification(EquipCommandList.REFRESH_PET_STRENGTHEN, {sucess:false});
                            };
                        };
                    };
                } else {
                    if (_local3 == PETSMSG_LEARNSKILL){
                        switch (_local4){
                            case LEARNSKILL_SUCCESS:
                                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("学习成功")) + "</font>");
                                facade.sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
                                break;
                            case LEARNSKILL_FAIL:
                                _local2 = (("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("学习失败")) + "</font>");
                                facade.sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local2);
                                break;
                            case LEARNSKILL_WRONGSKILL:
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("指定的技能书错误!"),
                                    color:0xFFFF00
                                });
                                break;
                            case LEARNSKILL_LEVELLIMIT:
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("技能等级已达限制!"),
                                    color:0xFFFF00
                                });
                                break;
                            case LEARNSKILL_TOPLEVEL:
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("技能已达到最高等级!"),
                                    color:0xFFFF00
                                });
                                break;
                        };
                        facade.sendNotification(EquipCommandList.REFRESH_PET_LEARN);
                    };
                };
            };
        }
        private function equipRefine(_arg1:NetPacket):void{
            var _local2:Boolean = _arg1.readBoolean();
            if (_local2){
                MessageTip.popup(LanguageMgr.GetTranslation("秘炼成功"));
                UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_EQUIP_REFINE);
            } else {
                MessageTip.popup(LanguageMgr.GetTranslation("秘炼条件不符"));
            };
        }
        private function soulBoom(_arg1:NetPacket):void{
            var _local3:uint;
            var _local2:Boolean = _arg1.readBoolean();
            if (_local2){
                _local3 = _arg1.readUnsignedInt();
                MessageTip.popup(LanguageMgr.GetTranslation("获取x魂值点", String(_local3)));
            } else {
                MessageTip.popup(LanguageMgr.GetTranslation("获取魂值失败"));
            };
        }
        private function treasureSacrificeResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readByte();
            var _local4:uint = _arg1.readUnsignedInt();
            if (_local3 == 0){
                MessageTip.popup(LanguageMgr.GetTranslation("返回一半魂值"));
            } else {
                if (_local3 == 1){
                    MessageTip.popup(LanguageMgr.GetTranslation("附魂成功x提升y点", LanguageMgr.treasureProps[_local2], String(_local4)));
                } else {
                    MessageTip.popup(LanguageMgr.GetTranslation("附魂爆发x提升y点", LanguageMgr.treasureProps[_local2], String(_local4)));
                };
            };
            UIFacade.GetInstance().sendNotification(EquipCommandList.REFRESH_TREASURE_SACRIFICE);
        }

    }
}//package Net.PackHandler 
