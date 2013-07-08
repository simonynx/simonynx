//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.ConstData {
    import flash.geom.*;
    import flash.utils.*;
    import Utils.*;
    import GameUI.Modules.ToolTip.Mediator.data.*;

    public class ItemTemplateInfo {

        public var RequiredLevel:uint;
        public var NormalHit:uint;
        public var CriticalDamage:uint;
        public var NormalDodge:uint;
        public var MinAttack:uint;
        public var MpBonus:uint;
        public var Job:uint;
        public var MainClass:uint;
        public var SkillHit:uint;
        public var SkillDodge:uint;
        public var MaxAttack:uint;
        public var Defence:uint;
        public var Name:String;
        public var TemplateID:uint;
        public var SubClass:uint;
        public var MaxCount:uint;
        public var AmountLimit:uint;
        public var PriceIn:uint;
        public var type:uint;
        public var Set:uint;
        public var img:uint;
        public var CriticalRate:uint;
        public var Color:uint;
        public var TimeLimit:uint = 0;
        public var HpBonus:uint;
        public var dropIconId:int;
        public var Description:String;
        public var Sex:uint;
        public var CrtdmgReduce:uint;
        public var price:uint;
        public var DamageReduce:uint;
        public var Binding:uint;
        public var Flags:uint;
        public var Attack:uint;
        public var CrtrateReduce:uint;
        public var PriceOut:uint;
        public var AdditionFields:Array;
        public var Resistance1:uint;
        public var Resistance2:uint;
        public var Resistance3:uint;
        public var Resistance4:uint;
        public var Resistance5:uint;

        public function ItemTemplateInfo(){
            AdditionFields = new Array(3);
            super();
        }
        public function getAdditionFields(_arg1:uint):uint{
            return (AdditionFields[_arg1]);
        }
        public function ReadTemplateFromPacket(_arg1:ByteArray):void{
            var _local3:String;
            TemplateID = _arg1.readUnsignedInt();
            MainClass = _arg1.readUnsignedInt();
            SubClass = _arg1.readUnsignedInt();
            Name = UIUtils.ReadString(_arg1);
            Description = UIUtils.ReadString(_arg1);
            Attack = _arg1.readUnsignedInt();
            Defence = _arg1.readUnsignedInt();
            NormalHit = _arg1.readUnsignedInt();
            NormalDodge = _arg1.readUnsignedInt();
            CriticalDamage = _arg1.readUnsignedInt();
            CriticalRate = _arg1.readUnsignedInt();
            SkillHit = _arg1.readUnsignedInt();
            SkillDodge = _arg1.readUnsignedInt();
            HpBonus = _arg1.readUnsignedInt();
            MpBonus = _arg1.readUnsignedInt();
            Resistance1 = _arg1.readUnsignedInt();
            Resistance2 = _arg1.readUnsignedInt();
            Resistance3 = _arg1.readUnsignedInt();
            Resistance4 = _arg1.readUnsignedInt();
            Resistance5 = _arg1.readUnsignedInt();
            CrtrateReduce = _arg1.readUnsignedInt();
            CrtdmgReduce = _arg1.readUnsignedInt();
            DamageReduce = _arg1.readUnsignedInt();
            MinAttack = _arg1.readUnsignedInt();
            MaxAttack = _arg1.readUnsignedInt();
            var _local2:uint;
            while (_local2 < 3) {
                AdditionFields[_local2] = _arg1.readUnsignedInt();
                _local2++;
            };
            Job = _arg1.readUnsignedInt();
            RequiredLevel = _arg1.readUnsignedInt();
            Sex = _arg1.readUnsignedInt();
            Binding = _arg1.readUnsignedInt();
            Flags = _arg1.readUnsignedInt();
            TimeLimit = _arg1.readUnsignedInt();
            Color = _arg1.readUnsignedInt();
            Set = _arg1.readUnsignedInt();
            MaxCount = _arg1.readUnsignedInt();
            PriceOut = _arg1.readUnsignedInt();
            img = _arg1.readUnsignedInt();
            if ((((MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))){
                _local3 = "";
                _local3 = ((("108" + String(Attack)) + "000") + String(HpBonus));
                img = uint(_local3);
            };
            dropIconId = _arg1.readUnsignedInt();
            type = TemplateID;
            if (Set > 0){
                if (!EquipSetConst.EquipSetIdList[Set]){
                    EquipSetConst.EquipSetLocList[Set] = new Array();
                    EquipSetConst.EquipSetIdList[Set] = new Array();
                };
                EquipSetConst.EquipSetLocList[Set].push(ItemConst.GetSetLoc(MainClass, SubClass, Set));
                EquipSetConst.EquipSetIdList[Set].push(TemplateID);
            };
        }

    }
}//package GameUI.ConstData 
