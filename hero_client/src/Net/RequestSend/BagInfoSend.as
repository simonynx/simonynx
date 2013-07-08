//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.RequestSend {
    import GameUI.ConstData.*;
    import Net.*;
    import OopsFramework.Debug.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class BagInfoSend {

        public static function ItemRepair(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_REPAIR_ITEM;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function RequestItems():void{
            Logger.Info(BagInfoSend, "RequestItems", "请求背包信息");
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_GOODS;
            _local1.m_sendpacket.writeUnsignedInt(0);
            _local1.SendPacket();
        }
        public static function ItemThrow(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_DESTROYITEM;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ItemUse(_arg1:int):void{
            if (GameCommonData.Player.Role.HP == 0){
                return;
            };
            if (GameCommonData.Player.IsStall > 0){
                return;
            };
            BagData.LockItemByGuid(_arg1);
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_USE_ITEM;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ItemSwap(_arg1:uint, _arg2:int):void{
            if (_arg1 == _arg2){
                return;
            };
            if (BagData.SelectedItem){
                if (_arg1 > 0){
                    if (((!((ItemConst.placeToOffset(_arg1) == -1))) && (!((ItemConst.placeToPanel(_arg1) == -1))))){
                        BagData.LockItem(ItemConst.placeToPanel(_arg1), ItemConst.placeToOffset(_arg1));
                    };
                };
                if (_arg2 > 0){
                    if (((!((ItemConst.placeToOffset(_arg2) == -1))) && (!((ItemConst.placeToPanel(_arg2) == -1))))){
                        BagData.LockItem(ItemConst.placeToPanel(_arg2), ItemConst.placeToOffset(_arg2));
                    };
                };
            };
            var _local3:GameNet = GameCommonData.GameNets;
            _local3.m_sendpacket.opcode = Protocol.CMSG_SWAP_ITEM;
            _local3.m_sendpacket.writeUnsignedInt(_arg1);
            _local3.m_sendpacket.writeInt(_arg2);
            trace("物品交换", _arg1, _arg2);
            _local3.SendPacket();
        }
        public static function ItemSplit(_arg1:uint, _arg2:uint, _arg3:uint):void{
            trace("拆分物品", _arg1, _arg2, _arg3);
            var _local4:GameNet = GameCommonData.GameNets;
            _local4.m_sendpacket.opcode = Protocol.CMSG_SPLIT_ITEM;
            _local4.m_sendpacket.writeUnsignedInt(_arg1);
            _local4.m_sendpacket.writeUnsignedInt(_arg2);
            _local4.m_sendpacket.writeUnsignedInt(_arg3);
            _local4.SendPacket();
        }
        public static function RequestBanks():void{
            var _local1:GameNet = GameCommonData.GameNets;
            _local1.m_sendpacket.opcode = Protocol.CMSG_GET_GOODS;
            _local1.m_sendpacket.writeUnsignedInt(4);
            _local1.SendPacket();
        }
        public static function ExtendGrid(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_SLOT_EXPAND;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }
        public static function ItemDeal(_arg1:uint):void{
            var _local2:GameNet = GameCommonData.GameNets;
            _local2.m_sendpacket.opcode = Protocol.CMSG_ITEM_SORT;
            _local2.m_sendpacket.writeUnsignedInt(_arg1);
            _local2.SendPacket();
        }

    }
}//package Net.RequestSend 
