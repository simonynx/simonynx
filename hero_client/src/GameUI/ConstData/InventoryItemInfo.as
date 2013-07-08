//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.ConstData {
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.utils.*;
    import Manager.*;
    import Net.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.AutoPlay.command.*;

    public class InventoryItemInfo extends ItemTemplateInfo {

        public var Master:String;
        public var isBind:uint;
        public var Enchanting:uint;
        public var Experience:uint = 0;
        public var Sacrifice:uint;
        public var id:uint;
        public var isBroken:uint;
        private var _ItemGUID:uint;
        public var Prefix:uint;
        public var Duration:uint;
        public var IntervalID:uint = 0;
        public var TreasureProperty:Array;
        public var ValidTime:uint;
        public var Strengthen:uint;
        public var PetInfo:GamePetRole;
        public var Add1:uint;
        public var Add2:uint;
        public var index:uint;
        public var Add4:uint;
        public var Add3:uint;
        public var Place:int;
        public var Count:int = 1;
        public var BeginTime:uint;
        public var OtherFlags:uint;
        public var RemainTime:int;

        public function Dispose():void{
            if (IntervalID > 0){
                clearInterval(IntervalID);
            };
        }
        public function ReadFromPacket(_arg1:NetPacket):void{
			return;//geoffyan
            Place = _arg1.readUnsignedInt();
            Count = _arg1.readUnsignedInt();
            if (Count == 0){
                return;
            };
            ItemGUID = _arg1.readUnsignedInt();
            TemplateID = _arg1.readUnsignedInt();
            var _local2:uint = _arg1.readUnsignedInt();
            isBind = (_local2 % 10);
            isBroken = (_local2 / 10);
            BeginTime = _arg1.readUnsignedInt();
            ValidTime = _arg1.readUnsignedInt();
            if ((((BeginTime > 0)) && ((ValidTime > 0)))){
                RemainTime = (((BeginTime + ValidTime) - (TimeManager.Instance.Now().time / 1000)) / 60);
            } else {
                RemainTime = 0;
            };
            ClassFactory.copyProperties(UIConstData.ItemDic[TemplateID], this);
            if (((UIConstData.ItemDic[TemplateID]) && ((((UIConstData.ItemDic[TemplateID].MainClass == ItemConst.ITEM_CLASS_EQUIP)) || ((((UIConstData.ItemDic[TemplateID].MainClass == ItemConst.ITEM_CLASS_PET)) && ((UIConstData.ItemDic[TemplateID].SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))))){
                ReadExtraData(_arg1, TemplateID);
            } else {
                Add1 = _arg1.readUnsignedInt();
                Add2 = _arg1.readUnsignedInt();
                Add3 = _arg1.readUnsignedInt();
            };
            if (((((UIConstData.ItemDic[TemplateID]) && ((UIConstData.ItemDic[TemplateID].MainClass == ItemConst.ITEM_CLASS_PET)))) && ((UIConstData.ItemDic[TemplateID].SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                ReadPetData(_arg1);
            };
            id = ItemGUID;
            type = TemplateID;
            SetRemainTime();
        }
        private function decrRemainTime():void{
            var func:* = null;
            RemainTime--;
            if (RemainTime == 0){
                clearInterval(IntervalID);
                IntervalID = 0;
                func = function ():void{
                    BagInfoSend.ItemThrow(ItemGUID);
                };
                func();
                setTimeout(func, 20000);
            };
        }
        public function SetRemainTime():void{
            if (((((!((MainClass == ItemConst.ITEM_CLASS_PET))) && ((BeginTime > 0)))) && ((RemainTime > 0)))){
                if (IntervalID > 0){
                    clearInterval(IntervalID);
                };
                IntervalID = setInterval(decrRemainTime, 60000);
            };
        }
        public function WriteConcatString():String{
            var _local2:uint;
            var _local1 = "";
            _local1 = ((((((((((((String(Strengthen) + "_") + String(Enchanting)) + "_") + String(Experience)) + "_") + String(Add1)) + "_") + String(Add2)) + "_") + String(Add3)) + "_") + String(Add4));
            if ((((MainClass == ItemConst.ITEM_CLASS_EQUIP)) && ((SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)))){
                _local2 = 0;
                _local2 = 0;
                while (_local2 < TreasureProperty.length) {
                    _local1 = ((_local1 + "_") + String(TreasureProperty[_local2]));
                    _local2++;
                };
                _local1 = ((_local1 + "_") + Master);
                return (_local1);
            };
            if ((((MainClass == ItemConst.ITEM_CLASS_PET)) && ((SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                if (PetInfo){
                    _local1 = (_local1 + PetInfo.WriteConcatString());
                };
            };
            return (_local1);
        }
        public function get ItemGUID():uint{
            return (_ItemGUID);
        }
        public function ReadExtraData(_arg1:NetPacket, _arg2:uint):void{
            var _local3:uint;
            Strengthen = _arg1.readUnsignedInt();
            Enchanting = _arg1.readUnsignedInt();
            Experience = _arg1.readUnsignedInt();
            Add1 = _arg1.readUnsignedInt();
            Add2 = _arg1.readUnsignedInt();
            Add3 = _arg1.readUnsignedInt();
            Add4 = _arg1.readUnsignedInt();
            if (UIConstData.ItemDic[_arg2].SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                TreasureProperty = new Array(8);
                _local3 = 0;
                _local3 = 0;
                while (_local3 < TreasureProperty.length) {
                    TreasureProperty[_local3] = _arg1.readUnsignedInt();
                    _local3++;
                };
                Master = _arg1.ReadString();
            };
            if ((((Place == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)) && ((Master == GameCommonData.Player.Role.Name)))){
                UIFacade.GetInstance().sendNotification(AutoPlayEventList.UPDATE_TREASURE_EXP, {
                    level:Strengthen,
                    exp:Experience
                });
            };
        }
        public function ReadPetData(_arg1:NetPacket):void{
            if (PetInfo == null){
                PetInfo = new GamePetRole();
            };
            PetInfo.ReadFromPacket(_arg1);
            PetInfo.CommonSkills[0] = Add1;
            PetInfo.CommonSkills[1] = Add2;
            PetInfo.CommonSkills[2] = Add3;
            PetInfo.CommonSkills[3] = Add4;
        }
        public function ParseConcatString(_arg1:Array, _arg2:uint):void{
            var _local4:uint;
            TemplateID = _arg2;
            ClassFactory.copyProperties(UIConstData.ItemDic[TemplateID], this);
            type = _arg2;
            var _local3:uint = 7;
            Strengthen = uint(_arg1[(_local3 + 0)]);
            Enchanting = uint(_arg1[(_local3 + 1)]);
            Experience = uint(_arg1[(_local3 + 2)]);
            Add1 = uint(_arg1[(_local3 + 3)]);
            Add2 = uint(_arg1[(_local3 + 4)]);
            Add3 = uint(_arg1[(_local3 + 5)]);
            Add4 = uint(_arg1[(_local3 + 6)]);
            if (SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                TreasureProperty = new Array(8);
                _local4 = 0;
                _local4 = 0;
                while (_local4 < TreasureProperty.length) {
                    TreasureProperty[_local4] = uint(_arg1[((_local3 + 7) + _local4)]);
                    _local4++;
                };
                Master = _arg1[(_local3 + 15)];
                return;
            };
            if ((((MainClass == ItemConst.ITEM_CLASS_PET)) && ((SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))){
                if (PetInfo == null){
                    PetInfo = new GamePetRole();
                };
                PetInfo.ParseConcatString(_arg1);
                PetInfo.CommonSkills[0] = Add1;
                PetInfo.CommonSkills[1] = Add2;
                PetInfo.CommonSkills[2] = Add3;
                PetInfo.CommonSkills[3] = Add4;
            };
        }
        public function set ItemGUID(_arg1:uint):void{
            _ItemGUID = _arg1;
        }

    }
}//package GameUI.ConstData 
