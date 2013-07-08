//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.HeroSkill.SkillConst {
    import flash.utils.*;
    import Manager.*;
    import Utils.*;

    public class NewSkillInfo {

        public var effect_1:int;
        public var effect_2:int;
        public var category:int;
        public var maxLevel:int;
        public var name:String;
        public var effectApplyAuraName_2:String;
        public var familyName:int;
        public var spellDmgType:int;
        public var prevSkillid:String;
        public var castPath:int;
        public var spellCostValue_1:String;
        public var flags:int;
        public var spellCostValue_2:String;
        public var casterAuraState:int;
        public var skillid:int;
        public var effectTargetB_1:int;
        public var effectTargetB_2:int;
        public var equipItemType:int;
        public var needLv:String;
        public var equipItemValue:int;
        public var procFlags:int;
        public var effectPath:String;
        public var attributes:int;
        public var castDistance:int;
        public var targetAuraState:int;
        public var effectBasePoint_1:String;
        public var effectBasePoint_2:String;
        public var spellGroupeType:int;
        public var attributesEx:int;
        public var spellCostType:int;
        public var effectTargetA_1:int;
        public var effectTargetA_2:int;
        public var effectTriggerSpell_1:int;
        public var effectTriggerSpell_2:int;
        public var spellCDTime:String;
        public var discription:String;
        public var content:String;
        public var effectApplyAuraName_1:String;
        public var maxTargets:int;

        private function analyse():void{
            var _local12:int;
            var _local1:SkillInfo;
            var _local2:int;
            var _local3:int;
            var _local4:Array = [];
            var _local5:Array = [];
            var _local6:Array = [];
            var _local7:Array = [];
            var _local8:Array = [];
            var _local9:Array = [];
            var _local10:Array = [];
            var _local11:Array = [];
            var _local13:Array = [];
            var _local14:Array = [];
            _local4 = needLv.split(",");
            _local5 = prevSkillid.split(",");
            _local6 = spellCostValue_1.split(",");
            _local7 = spellCostValue_2.split(",");
            _local8 = effectBasePoint_1.split(",");
            _local9 = effectBasePoint_2.split(",");
            _local14 = effectApplyAuraName_1.split(",");
            _local10 = spellCDTime.split(",");
            _local11 = content.split("&");
            _local12 = discription.match(/\*/g).length;
            while (_local2 < maxLevel) {
                _local1 = new SkillInfo();
                _local1.Id = ((skillid * 100) + (_local2 + 1));
                _local1.Job = familyName;
                _local1.Name = ((name)=="未知") ? LanguageMgr.GetTranslation(name) : name;
                _local1.Level = (_local2 + 1);
                _local1.Type = attributes;
                _local1.SkillMode = category;
                _local1.attributesEx = attributesEx;
                _local1.PreSkillId = _local5[_local2];
                _local1.NeedLevel = _local4[_local2];
                _local1.Distance = castDistance;
                _local1.effect_1 = effect_1;
                _local1.effect_2 = effect_2;
                _local1.effectBasePoint_1 = _local8[_local2];
                _local1.effectBasePoint_2 = _local9[_local2];
                _local1.effectTargetA_1 = effectTargetA_1;
                _local1.effectTargetA_2 = effectTargetA_2;
                _local1.effectTargetB_1 = effectTargetB_1;
                _local1.effectTargetB_2 = effectTargetB_2;
                _local1.CoolTime = _local10[_local2];
                _local1.buffId = _local14[_local2];
                _local1.HitEffect = effectPath;
                _local1.Effect = castPath.toString();
                _local1.MaxLevel = maxLevel;
                _local1.setSkillType();
                _local1.description = discription.replace("#", (_local2 + 1));
                _local1.description = _local1.description.replace("?", (_local10[_local2] / 1000));
                _local3 = 0;
                while (_local3 < _local12) {
                    _local13 = _local11[_local3].split(",");
                    if (_local13.length > 0){
                        _local1.description = _local1.description.replace("*", _local13[_local2]);
                    };
                    _local3++;
                };
                if (_local2 == (maxLevel - 2)){
                    _local1.IsTop = true;
                    if (_local2 == 0){
                        _local1.IsOne = true;
                    };
                };
                if (SkillManager.AllSkillList[_local1.Job] == null){
                    SkillManager.AllSkillList[_local1.Job] = [];
                };
                SkillManager.AllSkillList[_local1.Job].push(_local1);
                GameCommonData.SkillList[_local1.Id] = _local1;
                _local2++;
            };
        }
        public function ReadFromPacket(_arg1:ByteArray):void{
            skillid = _arg1.readInt();
            maxLevel = _arg1.readInt();
            name = UIUtils.ReadString(_arg1);
            discription = UIUtils.ReadString(_arg1);
            category = _arg1.readInt();
            familyName = _arg1.readInt();
            attributes = _arg1.readInt();
            attributesEx = _arg1.readInt();
            flags = _arg1.readInt();
            castDistance = _arg1.readInt();
            spellCostType = _arg1.readInt();
            equipItemType = _arg1.readInt();
            equipItemValue = _arg1.readInt();
            maxTargets = _arg1.readInt();
            spellDmgType = _arg1.readInt();
            procFlags = _arg1.readInt();
            effect_1 = _arg1.readInt();
            effect_2 = _arg1.readInt();
            effectTargetA_1 = _arg1.readInt();
            effectTargetA_2 = _arg1.readInt();
            effectTargetB_1 = _arg1.readInt();
            effectTargetB_2 = _arg1.readInt();
            effectTriggerSpell_1 = _arg1.readInt();
            effectTriggerSpell_2 = _arg1.readInt();
            spellGroupeType = _arg1.readInt();
            casterAuraState = _arg1.readInt();
            targetAuraState = _arg1.readInt();
            castPath = _arg1.readInt();
            effectPath = UIUtils.ReadString(_arg1);
            content = UIUtils.ReadString(_arg1);
            needLv = UIUtils.ReadString(_arg1);
            prevSkillid = UIUtils.ReadString(_arg1);
            spellCostValue_1 = UIUtils.ReadString(_arg1);
            spellCostValue_2 = UIUtils.ReadString(_arg1);
            effectBasePoint_1 = UIUtils.ReadString(_arg1);
            effectBasePoint_2 = UIUtils.ReadString(_arg1);
            effectApplyAuraName_1 = UIUtils.ReadString(_arg1);
            effectApplyAuraName_2 = UIUtils.ReadString(_arg1);
            spellCDTime = UIUtils.ReadString(_arg1);
            analyse();
        }

    }
}//package GameUI.Modules.HeroSkill.SkillConst 
