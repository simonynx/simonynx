//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Role {
    import flash.utils.*;
    import Net.*;

    public class GamePetRole {

        public static const PET_TYPE_DIC:Dictionary = new Dictionary();

        public var CritRate:Number;
        public var ExpNow:uint;
        public var HpMax:uint;
        public var Defense:uint;
        public var MpMax:uint;
        public var ExpMax:uint;
        public var petguid:uint;
        public var CommonSkills:Array;
        public var Hp:uint;
        public var PetName:String;
        public var isAssign:uint;
        public var Id:uint;
        public var Dodge:uint;
        public var SpecialSkill:uint;
        public var Start:uint;
        public var Mp:uint;
        public var SkillLevel:Array;
        public var UpgradeValue:Array;
        public var PetType:uint;
        public var IsUsing:Boolean;
        public var Level:uint;
        public var Attack:uint;
        public var Hit:uint;
        public var Crit:Number;

        public function GamePetRole(){
            CommonSkills = new Array(4);
            UpgradeValue = new Array(12);
            SkillLevel = [];
            PET_TYPE_DIC[0] = LanguageMgr.GetTranslation("空");
            PET_TYPE_DIC[1] = LanguageMgr.GetTranslation("攻击");
            PET_TYPE_DIC[2] = LanguageMgr.GetTranslation("防御");
            PET_TYPE_DIC[3] = LanguageMgr.GetTranslation("生命");
            PET_TYPE_DIC[4] = LanguageMgr.GetTranslation("魔法");
            PET_TYPE_DIC[5] = LanguageMgr.GetTranslation("命中");
            PET_TYPE_DIC[6] = LanguageMgr.GetTranslation("躲闪");
            super();
        }
        public static function getPanelPos(_arg1:uint):uint{
            if ((((_arg1 == 1)) || ((_arg1 == 2)))){
                return ((_arg1 + 2));
            };
            if ((((_arg1 == 3)) || ((_arg1 == 4)))){
                return ((_arg1 - 2));
            };
            if ((((_arg1 == 5)) || ((_arg1 == 6)))){
                return (_arg1);
            };
            return (0);
        }

        public function get SubType():String{
            return (PET_TYPE_DIC[(PetType % 10000)]);
        }
        public function WriteConcatString():String{
            var _local1 = "";
            _local1 = ((((((((((((((((((((((((((((((("_" + PetName) + "_") + String(Level)) + "_") + String(ExpNow)) + "_") + String(PetType)) + "_") + String(SpecialSkill)) + "_") + String(Start)) + "_") + String(HpMax)) + "_") + String(Hp)) + "_") + String(MpMax)) + "_") + String(Mp)) + "_") + String(Attack)) + "_") + String(Defense)) + "_") + String(Hit)) + "_") + String(Dodge)) + "_") + String(Crit)) + "_") + String(CritRate));
            var _local2:uint;
            _local2 = 0;
            while (_local2 < UpgradeValue.length) {
                _local1 = ((_local1 + "_") + String(UpgradeValue[_local2]));
                _local2++;
            };
            return (_local1);
        }
        public function ReadFromPacket(_arg1:NetPacket):void{
            PetName = _arg1.ReadString();
            Level = _arg1.readUnsignedInt();
            ExpNow = _arg1.readUnsignedInt();
            PetType = _arg1.readUnsignedShort();
            SpecialSkill = _arg1.readUnsignedInt();
            Start = _arg1.readShort();
            HpMax = _arg1.readUnsignedInt();
            Hp = _arg1.readUnsignedInt();
            MpMax = _arg1.readUnsignedInt();
            Mp = _arg1.readUnsignedInt();
            Attack = _arg1.readUnsignedInt();
            Defense = _arg1.readUnsignedInt();
            Hit = _arg1.readUnsignedInt();
            Dodge = _arg1.readUnsignedInt();
            Crit = _arg1.readFloat();
            CritRate = _arg1.readFloat();
            var _local2:uint;
            _local2 = 0;
            while (_local2 < UpgradeValue.length) {
                UpgradeValue[_local2] = _arg1.readByte();
                _local2++;
            };
        }
        public function get MainType():String{
            return (PET_TYPE_DIC[uint((PetType / 10000))]);
        }
        public function ParseConcatString(_arg1:Array):void{
            var _local2:uint = 7;
            PetName = _arg1[(_local2 + 7)];
            Level = uint(_arg1[(_local2 + 8)]);
            ExpNow = uint(_arg1[(_local2 + 9)]);
            PetType = uint(_arg1[(_local2 + 10)]);
            SpecialSkill = uint(_arg1[(_local2 + 11)]);
            Start = uint(_arg1[(_local2 + 12)]);
            HpMax = uint(_arg1[(_local2 + 13)]);
            Hp = uint(_arg1[(_local2 + 14)]);
            MpMax = uint(_arg1[(_local2 + 15)]);
            Mp = uint(_arg1[(_local2 + 16)]);
            Attack = uint(_arg1[(_local2 + 17)]);
            Defense = uint(_arg1[(_local2 + 18)]);
            Hit = uint(_arg1[(_local2 + 19)]);
            Dodge = uint(_arg1[(_local2 + 20)]);
            Crit = Number(_arg1[(_local2 + 21)]);
            CritRate = Number(_arg1[(_local2 + 22)]);
            var _local3:uint;
            _local3 = 0;
            while (_local3 < UpgradeValue.length) {
                UpgradeValue[_local3] = uint(_arg1[((_local2 + 23) + _local3)]);
                _local3++;
            };
        }

    }
}//package OopsEngine.Role 
