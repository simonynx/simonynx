//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.display.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class EquipUtils {

        private static var itemInfo:ItemTemplateInfo;
        private static var textParent:MovieClip = null;
        private static var format2:TextFormat;
        private static var lines:uint = 1;

        public function EquipUtils(){
            format2 = new TextFormat();
            format2.size = 12;
            format2.font = LanguageMgr.DEFAULT_FONT;
        }
        public static function removeHole(_arg1:MovieClip):void{
            clearText();
        }
        public static function addActive(_arg1:ItemTemplateInfo, _arg2:MovieClip):void{
            var _local4:uint;
            var _local5:String;
            var _local6:uint;
            var _local7:uint;
            var _local8:String;
            itemInfo = _arg1;
            var _local3:Array = new Array(3);
            _local3[0] = (_arg1 as InventoryItemInfo).AdditionFields[0];
            _local3[1] = (_arg1 as InventoryItemInfo).AdditionFields[1];
            _local3[2] = (_arg1 as InventoryItemInfo).AdditionFields[2];
            if ((((((_local3[0] > 0)) || ((_local3[1] > 0)))) || ((_local3[2] > 0)))){
                _local4 = 0;
                while (_local4 < 3) {
                    if (_local3[_local4] > 0){
                        _local5 = String(_local3[_local4]);
                        _local6 = (_local3[_local4] % 100);
                        _local7 = (uint((_local3[_local4] / 100)) % 100);
                        _local8 = String(uint((_local3[_local4] / 10000)));
                        if ((((_local7 == 5)) || ((_local7 == 6)))){
                            _local8 = (_local8 + "%");
                        } else {
                            if ((((((_local7 == 16)) || ((_local7 == 17)))) || ((_local7 == 18)))){
                                _local8 = (Number((uint((_local3[_local4] / 10000)) / 100)).toFixed(1) + "%");
                            };
                        };
                        if (((((_arg1 as InventoryItemInfo).Strengthen >= _local6)) && ((_local6 > 0)))){
                            addTF(_arg2, null, 16777049, true, (((((((("(" + LanguageMgr.GetTranslation("强化")) + "+") + _local6) + LanguageMgr.GetTranslation("激活")) + ")") + LanguageMgr.AdditionProperty[_local7]) + " +") + _local8));
                        } else {
                            if (_local6 > 0){
                                addTF(_arg2, null, 0x888888, true, (((((((("(" + LanguageMgr.GetTranslation("强化")) + "+") + _local6) + LanguageMgr.GetTranslation("激活")) + ")") + LanguageMgr.AdditionProperty[_local7]) + " +") + _local8));
                            } else {
                                addTF(_arg2, null, 16777049, true, (((((((("(" + LanguageMgr.GetTranslation("强化")) + "+") + _local6) + LanguageMgr.GetTranslation("激活")) + ")") + LanguageMgr.AdditionProperty[_local7]) + " +") + _local8));
                            };
                        };
                    };
                    _local4++;
                };
            };
        }
        public static function addHole(_arg1:ItemTemplateInfo, _arg2:MovieClip):void{
            var _local4:uint;
            var _local6:Bitmap;
            itemInfo = _arg1;
            clearText();
            textParent = _arg2;
            var _local3:uint = (_arg1 as InventoryItemInfo).Add1;
            if (_local3 > 0){
                _local6 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap(String(("ShapeSolid" + String(_local3))));
                _local6.y = (4 + (lines * 20));
                _local6.x = 6;
                _local6.name = "Shape";
                _arg2.addChild(_local6);
            };
            _local4 = (_arg1 as InventoryItemInfo).Add2;
            addTF(_arg2, null, 16496146, true, ((IntroConst.EquipHolePrefix[_local4] + "·") + _arg1.Name), 20);
            var _local5:uint = (_arg1.Attack - 1);
            if ((((_local5 == 4)) || ((_local5 == 5)))){
                if (_local5 == 5){
                    addTF(_arg2, null, 324530, true, (((LanguageMgr.EquipHoleType[_arg1.Attack] + " +") + String((IntroConst.RunePropValue[_local5][(_arg1.HpBonus - 1)] / 100))) + "%"), 20);
                } else {
                    addTF(_arg2, null, 324530, true, (((LanguageMgr.EquipHoleType[_arg1.Attack] + " +") + String(IntroConst.RunePropValue[_local5][(_arg1.HpBonus - 1)])) + "%"), 20);
                };
            } else {
                addTF(_arg2, null, 324530, true, ((LanguageMgr.EquipHoleType[_arg1.Attack] + " +") + IntroConst.RunePropValue[_local5][(_arg1.HpBonus - 1)]), 20);
            };
            _local4 = (_arg1 as InventoryItemInfo).Add2;
            if (_local4 > 0){
                if (_local4 == 6){
                    addTF(_arg2, null, 324530, true, ((LanguageMgr.RunePrefix[_local4] + IntroConst.RunePrefixValue[((_arg1.HpBonus - 1) - 4)][(_local4 - 1)]) + "%"), 20);
                } else {
                    addTF(_arg2, null, 324530, true, ((LanguageMgr.RunePrefix[_local4] + IntroConst.RunePrefixValue[((_arg1.HpBonus - 1) - 4)][(_local4 - 1)]) + "点"), 20);
                };
            };
        }
        public static function calcBonus(_arg1:ItemTemplateInfo, _arg2:uint, _arg3:uint, _arg4:uint):uint{
            var _local5:uint = _arg4;
            if ((_arg3 % 2) == 1){
                _local5++;
                _arg2 = (_arg2 * 2);
            } else {
                _arg2 = (_arg2 * 8);
            };
            _arg2 = (_arg2 * (_local5 * (((27 * _local5) + 10) - (_local5 * _local5))));
            _arg2 = (_arg2 / 1200);
            if (_arg1.Color == 0){
                _arg2 = (_arg2 * Number((1 / 3)));
            } else {
                if (_arg1.Color == 1){
                    _arg2 = (_arg2 * Number((2 / 3)));
                } else {
                    if (_arg1.Color == 3){
                        _arg2 = (_arg2 * Number((31 / 25)));
                    };
                };
            };
            _arg2 = (_arg2 + 1);
            return (_arg2);
        }
        private static function addTreasureTip(_arg1:String, _arg2:uint, _arg3:uint=0):void{
            var _local5:uint;
            var _local4:String = ((_arg1 + "  ") + _arg2);
            if (_arg3 > 0){
                _local5 = addTF(textParent, format2, 16755236, false, _local4);
                addTF(textParent, format2, 0xFF00, true, (("(+" + _arg3) + ")"), _local5);
            } else {
                addTF(textParent, format2, 16755236, true, _local4);
            };
        }
        public static function addSacrificeInfo(_arg1:ItemTemplateInfo, _arg2:MovieClip):void{
            var _local3:uint;
            itemInfo = _arg1;
            clearText();
            textParent = _arg2;
            var _local4:uint = (_arg1 as InventoryItemInfo).Strengthen;
            if (_local4 == 0){
                _local4 = 1;
            };
            var _local5:Number = IntroConst.TreasurePropRatio[(_local4 - 1)];
            _local3 = (_arg1.Attack * (1 + (0.2 * _local5)));
            addTreasureTip(LanguageMgr.GetTranslation("攻击"), _local3, (_arg1 as InventoryItemInfo).TreasureProperty[0]);
            _local3 = (_arg1.HpBonus * (1 + (0.5 * _local5)));
            addTreasureTip(LanguageMgr.GetTranslation("生命"), _local3, (_arg1 as InventoryItemInfo).TreasureProperty[1]);
            _local3 = (_arg1.MpBonus * (1 + (0.5 * _local5)));
            addTreasureTip(LanguageMgr.GetTranslation("魔法"), _local3, (_arg1 as InventoryItemInfo).TreasureProperty[2]);
        }
        private static function InventoryItem():InventoryItemInfo{
            return ((itemInfo as InventoryItemInfo));
        }
        private static function addSkill(_arg1:uint):void{
            var _local2:String;
            var _local4:String;
            if (_arg1 == 0){
                return;
            };
            _local2 = (String((_arg1 % 1000000)) + "01");
            var _local3:SkillInfo = SkillManager.getIdSkillInfo(uint(_local2));
            if (_local3){
                _local4 = SkillManager.getIdSkillInfo(uint(_local2)).Name;
            } else {
                _local4 = (String(_arg1) + "01");
            };
            if (_arg1 > 1000000){
                addTF(textParent, format2, 0xFFFFFF, true, _local4);
            } else {
                addTF(textParent, format2, 0x888888, true, _local4);
            };
        }
        public static function addPourInfo(_arg1:ItemTemplateInfo, _arg2:MovieClip):void{
            itemInfo = _arg1;
            clearText();
            textParent = _arg2;
            var _local3:uint = addTF(_arg2, null, 9819657, false, (((("(" + LanguageMgr.GetTranslation("合成")) + "+") + ((_arg1 as InventoryItemInfo).Enchanting % 100)) + ")"));
            var _local4:uint = ((_arg1 as InventoryItemInfo).Enchanting / 100);
            var _local5:uint = UIConstData.ItemDic[(_local4 + 10100005)].MpBonus;
            var _local6:uint = ((_arg1 as InventoryItemInfo).Enchanting % 100);
            addTF(_arg2, null, 9819657, true, ((LanguageMgr.AdditionProperty[int((_local5 / 1000))] + "+") + ((_local5 % 1000) * _local6)), (_local3 + 5));
        }
        public static function addTF(_arg1:MovieClip, _arg2:TextFormat, _arg3:uint, _arg4:Boolean, _arg5:String, _arg6:uint=0, _arg7:Boolean=false):uint{
            var _local8:TextField;
            if (format2 == null){
                format2 = new TextFormat();
                format2.size = 12;
                format2.font = LanguageMgr.DEFAULT_FONT;
            };
            _local8 = new TextField();
            if (_arg7 == true){
                _local8.width = 195;
                _local8.wordWrap = true;
                _local8.multiline = true;
            };
            _local8.text = _arg5;
            _local8.autoSize = TextFieldAutoSize.LEFT;
            _local8.textColor = _arg3;
            _local8.setTextFormat(format2);
            _local8.cacheAsBitmap = true;
            _local8.x = (4 + _arg6);
            _local8.y = (10 + (lines * 15));
            _local8.mouseEnabled = false;
            _arg1.addChild(_local8);
            if (_arg4){
                lines = (lines + _local8.numLines);
            };
            return ((_local8.width + _arg6));
        }
        public static function addProperty(_arg1:ItemTemplateInfo, _arg2:MovieClip):void{
            var _local3:uint;
            var _local4:uint;
            var _local6:uint;
            var _local10:uint;
            var _local11:uint;
            itemInfo = _arg1;
            clearText();
            textParent = _arg2;
            var _local5:uint = 14610175;
            var _local7:uint = (_arg1.Color + 1);
            if (_arg1.Color == 3){
                _local7 = 3;
            };
            if (_arg1.Attack > 0){
                _local3 = 0;
                _local4 = _arg1.Attack;
            } else {
                _local3 = _arg1.MinAttack;
                _local4 = _arg1.MaxAttack;
            };
            var _local8:uint;
            if ((_arg1 is InventoryItemInfo)){
                if ((_arg1 as InventoryItemInfo).Strengthen > 0){
                    _local5 = 324530;
                    _local8 = calcBonus(_arg1, ((InventoryItem().MinAttack + InventoryItem().MaxAttack) / 2), ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON, (_arg1 as InventoryItemInfo).Strengthen);
                } else {
                    _local5 = 324530;
                };
            };
            if (_local3 > 0){
                if ((((_local8 > 0)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)))){
                    _local6 = addTF(_arg2, null, _local5, false, ((((LanguageMgr.GetTranslation("攻击") + ":   ") + _local3) + " - ") + _local4));
                    addTF(_arg2, null, 16627970, true, (("(+" + String(_local8)) + ")"), _local6);
                    _local8 = 0;
                } else {
                    _local6 = addTF(_arg2, null, _local5, true, ((((LanguageMgr.GetTranslation("攻击") + ":   ") + _local3) + " - ") + _local4));
                };
            } else {
                if (_local4 > 0){
                    if ((((_local8 > 0)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)))){
                        _local6 = addTF(_arg2, null, _local5, false, ((LanguageMgr.GetTranslation("攻击") + ":   ") + _local4));
                        addTF(_arg2, null, 16627970, true, (("(+" + String(_local8)) + ")"), _local6);
                        _local8 = 0;
                    } else {
                        addTF(_arg2, null, _local5, true, ((LanguageMgr.GetTranslation("攻击") + ":   ") + _local4));
                    };
                };
            };
            var _local9 = "";
            if ((_arg1 is InventoryItemInfo)){
                if ((_arg1 as InventoryItemInfo).Strengthen > 0){
                    _local10 = (_arg1 as InventoryItemInfo).Strengthen;
                    if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH){
                        _local11 = calcBonus(_arg1, _arg1.Defence, ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH, _local10);
                        if (_arg1.Defence == 0){
                            _local9 = ((LanguageMgr.GetTranslation("防御") + ":   ") + _local11);
                        } else {
                            _local8 = _local11;
                        };
                    } else {
                        if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE){
                            _local11 = calcBonus(_arg1, _arg1.HpBonus, ItemConst.ITEM_SUBCLASS_EQUIP_SHOE, _local10);
                            if (_arg1.HpBonus == 0){
                                _local9 = ((LanguageMgr.GetTranslation("生命") + ":   ") + _local11);
                            } else {
                                _local8 = _local11;
                            };
                        } else {
                            if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT){
                                _local11 = calcBonus(_arg1, _arg1.MpBonus, ItemConst.ITEM_SUBCLASS_EQUIP_HAT, _local10);
                                if (_arg1.MpBonus == 0){
                                    _local9 = ((LanguageMgr.GetTranslation("魔法") + ":   ") + _local11);
                                } else {
                                    _local8 = _local11;
                                };
                            };
                        };
                    };
                };
            };
            if (_arg1.Defence > 0){
                if ((((_local8 > 0)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH)))){
                    _local6 = addTF(_arg2, null, 324530, false, ((LanguageMgr.GetTranslation("防御") + ":   ") + String(_arg1.Defence)));
                    addTF(_arg2, null, 16627970, true, (("(+" + String(_local8)) + ")"), _local6);
                    _local8 = 0;
                } else {
                    addTF(_arg2, null, 324530, true, ((LanguageMgr.GetTranslation("防御") + ":   ") + String(_arg1.Defence)));
                };
            };
            if (_arg1.HpBonus > 0){
                if ((((_local8 > 0)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE)))){
                    _local6 = addTF(_arg2, null, 324530, false, ((LanguageMgr.GetTranslation("生命") + ":   ") + String(_arg1.HpBonus)));
                    addTF(_arg2, null, 16627970, true, (("(+" + String(_local8)) + ")"), _local6);
                    _local8 = 0;
                } else {
                    addTF(_arg2, null, 324530, true, ((LanguageMgr.GetTranslation("生命") + ":   ") + String(_arg1.HpBonus)));
                };
            };
            if (_arg1.MpBonus > 0){
                if ((((_local8 > 0)) && ((_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT)))){
                    _local6 = addTF(_arg2, null, 324530, false, ((LanguageMgr.GetTranslation("魔法") + ":   ") + String(_arg1.MpBonus)));
                    addTF(_arg2, null, 16627970, true, (("(+" + String(_local8)) + ")"), _local6);
                    _local8 = 0;
                } else {
                    addTF(_arg2, null, 324530, true, ((LanguageMgr.GetTranslation("魔法") + ":   ") + String(_arg1.MpBonus)));
                };
            };
            addActive(_arg1, _arg2);
        }
        private static function addSpecialSkill(_arg1:ItemTemplateInfo):void{
            var _local2:uint;
            var _local4:String;
            itemInfo = _arg1;
            if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                if ((_arg1 as InventoryItemInfo)){
                    _local2 = ((_arg1.AdditionFields[0] * 100) + (_arg1 as InventoryItemInfo).Enchanting);
                } else {
                    return;
                };
            } else {
                if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY){
                    _local2 = ((_arg1.AdditionFields[0] * 100) + 1);
                } else {
                    if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK){
                        _local2 = ((_arg1.AdditionFields[0] * 100) + 1);
                    };
                };
            };
            var _local3:SkillInfo = SkillManager.getIdSkillInfo(_local2);
            if (_local3){
                _local4 = ((LanguageMgr.GetTranslation("特有技能") + "  ") + _local3.Name);
                if (_arg1.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                    _local4 = (((_local4 + " ") + (_arg1 as InventoryItemInfo).Enchanting) + LanguageMgr.GetTranslation("级"));
                };
                addTF(textParent, null, 0xBA00FF, true, _local4);
            };
        }
        public static function clearText():void{
            if (textParent == null){
                return;
            };
            var _local1:int = (textParent.numChildren - 1);
            while (_local1 >= 0) {
                textParent.removeChildAt(_local1);
                _local1--;
            };
            lines = 1;
        }
        public static function calcOrnamentBonus(_arg1:ItemTemplateInfo, _arg2:Number, _arg3:uint, _arg4:uint):uint{
            var _local5:Number = ((-(Math.pow(_arg4, 3)) + (32 * Math.pow(_arg4, 2))) + (10 * _arg4));
            if (_arg3 == 0){
                _local5 = Math.floor((((_local5 * 6) / 5000) * _arg2));
            } else {
                _local5 = Math.floor((((_local5 * 24) / 5000) * _arg2));
            };
            if (_local5 == 0){
                _local5 = 1;
            };
            return (_local5);
        }
        public static function addSkillInfo(_arg1:ItemTemplateInfo, _arg2:MovieClip):void{
            itemInfo = _arg1;
            clearText();
            textParent = _arg2;
            addSpecialSkill(_arg1);
            addSkill((_arg1 as InventoryItemInfo).Add1);
            addSkill((_arg1 as InventoryItemInfo).Add2);
            addSkill((_arg1 as InventoryItemInfo).Add3);
            addSkill((_arg1 as InventoryItemInfo).Add4);
        }

    }
}//package Utils 
