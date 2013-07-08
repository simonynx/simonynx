//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Maket.Data.*;
    import flash.filters.*;
    import Utils.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.RoleProperty.Mediator.*;
    import GameUI.Modules.ToolTip.Mediator.data.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.Stall.Data.*;
    import GameUI.Modules.Pet.Data.*;
    import GameUI.Modules.ToolTip.Mediator.VO.*;
    import GameUI.*;

    public class SetItemToolTip implements IToolTip {

        private var lines:uint;
        private var tooltip_center:MovieClip;
        private var tooltip_top:MovieClip;
        private var format2:TextFormat;
        private var format1:TextFormat;
        private var closeHandler:Function;
        private var closeBtn:SimpleButton = null;
        private var valueDic:Array;
        private var tipContent:MovieClip;
        private var toolTip:Sprite;
        private var tooltip_bottom:MovieClip;
        private var tipInfo:ItemTemplateInfo;
        private var descLines:uint;
        private var defaultFilters:Array;
        private var isDrag:Boolean = false;

        public function SetItemToolTip(_arg1:Sprite, _arg2:Object, _arg3:Boolean=false, _arg4:Function=null){
            this.toolTip = _arg1;
            this.tipInfo = (_arg2 as ItemTemplateInfo);
            isDrag = _arg3;
            closeHandler = _arg4;
            format1 = new TextFormat();
            format1.size = 14;
            format1.font = LanguageMgr.DEFAULT_FONT;
            format2 = new TextFormat();
            format2.size = 12;
            format2.font = LanguageMgr.DEFAULT_FONT;
            format2.leading = 4;
            var _local5:GlowFilter = new GlowFilter(0, 1, 2, 2, 16);
            defaultFilters = new Array();
            defaultFilters.push(_local5);
            tipContent = new MovieClip();
            lines = 0;
            valueDic = new Array();
        }
        private function addShape(_arg1:uint):void{
            var _local2:Bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap(String(("Shape" + String(_arg1))));
            _local2.y = (5 + (lines * 20));
            _local2.x = 7;
            tipContent.addChild(_local2);
        }
        private function addHole(_arg1:uint):void{
            if (_arg1 == 0){
                return;
            };
            addShape((_arg1 % 10));
            if (IntroConst.GlobalLevel == -1){
                if (uint(((_arg1 % 100) / 10)) == 4){
                    addShapeSolid((_arg1 % 10));
                } else {
                    addShapeSolid(uint(((_arg1 % 100) / 10)));
                };
            };
            var _local2:uint = uint(((_arg1 % 100000) / 1000));
            var _local3:uint = IntroConst.EquipColors[0];
            if ((((_local2 == 5)) || ((_local2 == 6)))){
                _local3 = IntroConst.EquipColors[1];
            } else {
                if (_local2 >= 7){
                    _local3 = IntroConst.EquipColors[2];
                };
            };
            if (IntroConst.GlobalLevel != -1){
                addTF(tipContent, format2, _local3, true, LanguageMgr.GetTranslation("未镶嵌"), 20);
                return;
            };
            var _local4:uint = uint(((_arg1 % 1000) / 100));
            var _local5 = "";
            var _local6:uint = uint((_arg1 / 100000));
            if ((((_local6 > 0)) && ((_local6 <= 10)))){
                _local5 = (String(LanguageMgr.EquipHolePrefix[_local6]) + "·");
            };
            var _local7:String = LanguageMgr.GetTranslation("未镶嵌");
            if (_local2 > 0){
                _local7 = (String(_local2) + LanguageMgr.GetTranslation("级"));
            };
            var _local8 = "";
            if (_local2 > 0){
                if ((((_local4 == 5)) || ((_local4 == 6)))){
                    if (_local4 == 6){
                        _local8 = (("+" + String((IntroConst.RunePropValue[(_local4 - 1)][(_local2 - 1)] / 100))) + "%");
                    } else {
                        _local8 = (("+" + String(IntroConst.RunePropValue[(_local4 - 1)][(_local2 - 1)])) + "%");
                    };
                } else {
                    _local8 = ("+" + String(IntroConst.RunePropValue[(_local4 - 1)][(_local2 - 1)]));
                };
            };
            addTF(tipContent, format2, _local3, true, (((((_local5 + _local7) + LanguageMgr.EquipHoleType[_local4]) + " ") + LanguageMgr.EquipHoleType[_local4]) + _local8), 20);
        }
        private function addAuxiliarySeries():void{
            var _local8:uint;
            var _local9:uint;
            var _local1:uint = 1;
            var _local2:Boolean;
            var _local3:Boolean;
            var _local4:Boolean;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:uint = (tipInfo as InventoryItemInfo).AdditionFields[0];
            if (InventoryItem().Place == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY){
                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                    _local8 = (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE] as InventoryItemInfo).AdditionFields[0];
                    if (_local7 == _local8){
                        _local2 = true;
                        _local5 = true;
                        _local1++;
                    };
                };
                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK]){
                    _local9 = (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK] as InventoryItemInfo).AdditionFields[0];
                    if (_local7 == _local9){
                        _local4 = true;
                        if (_local2){
                            _local6 = true;
                        };
                        _local1++;
                    };
                };
            };
            addTF(tipContent, format2, 14515715, true, (((LanguageMgr.GetTranslation("神兵套装") + "(") + String(_local1)) + "/3)"));
            addSeriesSkill(_local7, _local2, _local3, _local4, _local5, _local6);
        }
        private function setDefaultTooltip():void{
            addName();
            addBind();
            addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
        }
        private function addTreasureSeries():void{
            var _local8:uint;
            var _local9:uint;
            var _local1:uint = 1;
            var _local2:Boolean;
            var _local3:Boolean;
            var _local4:Boolean;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:uint = (tipInfo as InventoryItemInfo).AdditionFields[0];
            if (InventoryItem().Place == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY]){
                    _local8 = (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY] as InventoryItemInfo).AdditionFields[0];
                    if (_local7 == _local8){
                        _local3 = true;
                        _local5 = true;
                        _local1++;
                    };
                };
                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK]){
                    _local9 = (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK] as InventoryItemInfo).AdditionFields[0];
                    if (_local7 == _local9){
                        _local4 = true;
                        _local6 = true;
                        _local1++;
                    };
                };
            };
            addTF(tipContent, format2, 14515715, true, (((LanguageMgr.GetTranslation("神兵套装") + "(") + String(_local1)) + "/3)"));
            addSeriesSkill(_local7, _local2, _local3, _local4, _local5, _local6);
        }
        private function addTreasureTip(_arg1:String, _arg2:uint, _arg3:uint=0):void{
            var _local5:uint;
            var _local4:String = ((_arg1 + "  ") + _arg2);
            if (_arg3 > 0){
                _local5 = addTF(tipContent, format2, 16755236, false, _local4);
                addTF(tipContent, format2, 0xFF00, true, (("(+" + _arg3) + ")"), _local5);
            } else {
                addTF(tipContent, format2, 16755236, true, _local4);
            };
        }
        private function addBind():void{
            var _local1:uint;
            var _local2:uint;
            var _local3:uint;
            var _local4:String;
            var _local5:int;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            if (!IntroConst.ShowBind){
                IntroConst.ShowBind = true;
                return;
            };
            if (IntroConst.GlobalBind > 0){
                if (IntroConst.GlobalBind == 3){
                    addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("获取后绑定"));
                } else {
                    if (IntroConst.GlobalBind == 2){
                        addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("使用后绑定"));
                    } else {
                        if (IntroConst.GlobalBind == 1){
                            addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("已绑定"));
                        } else {
                            addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("未绑定"));
                        };
                    };
                };
                IntroConst.GlobalBind = 0;
            } else {
                if ((tipInfo is InventoryItemInfo)){
                    if (InventoryItem().isBind == 1){
                        addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("已绑定"));
                    } else {
                        if (tipInfo.Binding == 2){
                            if (tipInfo.MainClass == ItemConst.ITEM_CLASS_EQUIP){
                                addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("装备后绑定"));
                            } else {
                                addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("使用后绑定"));
                            };
                        } else {
                            addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("未绑定"));
                        };
                    };
                } else {
                    if ((tipInfo is ShopItemInfo)){
                        if (((!((((tipInfo as ShopItemInfo).SellFlag & ShopItemInfo.SELLING_FLAG_BOUND) == 0))) || ((tipInfo.Binding == 1)))){
                            addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("获取后绑定"));
                        } else {
                            if (tipInfo.Binding == 2){
                                if (tipInfo.MainClass == ItemConst.ITEM_CLASS_EQUIP){
                                    addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("装备后绑定"));
                                } else {
                                    addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("使用后绑定"));
                                };
                            } else {
                                addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("未绑定"));
                            };
                        };
                    };
                };
            };
            if ((((tipInfo is InventoryItemInfo)) || ((tipInfo is ShopItemInfo)))){
                _local1 = 0;
                _local2 = 0;
                _local3 = 0;
                if ((tipInfo is InventoryItemInfo)){
                    _local1 = InventoryItem().RemainTime;
                    _local2 = InventoryItem().BeginTime;
                    _local3 = InventoryItem().ValidTime;
                } else {
                    _local3 = tipInfo.TimeLimit;
                };
                _local4 = "";
                _local5 = 0;
                if ((((_local2 > 0)) && ((_local1 > 0)))){
                    _local4 = (LanguageMgr.GetTranslation("剩余时间") + " ");
                    _local5 = _local1;
                    if (_local5 <= 0){
                        addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("即将到期"));
                        return;
                    };
                } else {
                    if ((((_local2 == 0)) && ((_local3 > 0)))){
                        _local4 = (LanguageMgr.GetTranslation("有效期") + " ");
                        _local5 = (_local3 / 60);
                    } else {
                        return;
                    };
                };
                _local6 = (_local5 / 1440);
                _local7 = ((_local5 % 1440) / 60);
                _local8 = (_local5 % 60);
                if (_local6 > 0){
                    _local4 = (_local4 + (String(_local6) + LanguageMgr.GetTranslation("天")));
                };
                if (_local7 > 0){
                    _local4 = (_local4 + (String(_local7) + LanguageMgr.GetTranslation("小时")));
                };
                if (_local8 > 0){
                    _local4 = (_local4 + (String(_local8) + LanguageMgr.GetTranslation("分钟")));
                };
                addTF(tipContent, format2, 0xA8FF00, true, _local4);
            };
        }
        public function GetType():String{
            return ("SetItemToolTip");
        }
        private function setTreasureTooltip():void{
            var _local1:int;
            var _local2:uint;
            var _local3:String;
            var _local4:uint;
            var _local5:Array;
            var _local6:Number;
            var _local7:String;
            addName();
            addBind();
            addFlag();
            if ((tipInfo is InventoryItemInfo)){
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                    addTF(tipContent, format2, 0xBA00FF, false, LanguageMgr.GetTranslation("神兵主人"));
                    _local3 = (tipInfo as InventoryItemInfo).Master;
                    addTF(tipContent, format2, 0xBA00FF, true, _local3, 60);
                    addTF(tipContent, format2, 0xBA00FF, false, LanguageMgr.GetTranslation("神兵等级"));
                    _local1 = InventoryItem().Strengthen;
                    if (IntroConst.GlobalLevel != -1){
                        _local1 = IntroConst.GlobalLevel;
                    };
                    addTF(tipContent, format2, 0xBA00FF, true, String(_local1), 60);
                    addLine();
                    _local4 = _local1;
                    if (_local4 == 0){
                        _local4 = 1;
                    };
                    _local5 = InventoryItem().TreasureProperty;
                    if (IntroConst.GlobalTreasureLife[0] != -1){
                        _local5 = IntroConst.GlobalTreasureLife;
                    };
                    _local6 = IntroConst.TreasurePropRatio[(_local4 - 1)];
                    _local2 = (tipInfo.Attack * (1 + (0.2 * _local6)));
                    addTreasureTip(LanguageMgr.GetTranslation("攻击"), _local2, _local5[0]);
                    _local2 = (tipInfo.HpBonus * (1 + (0.5 * _local6)));
                    addTreasureTip(LanguageMgr.GetTranslation("生命"), _local2, _local5[1]);
                    _local2 = (tipInfo.MpBonus * (1 + (0.5 * _local6)));
                    addTreasureTip(LanguageMgr.GetTranslation("魔法"), _local2, _local5[2]);
                };
                addLine();
                addSpecialSkill();
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                    if (IntroConst.GlobalTreasureLife[0] != -1){
                        addSkill(InventoryItem().Add1, IntroConst.GlobalTreasureLife[8], 1);
                        addSkill(InventoryItem().Add2, IntroConst.GlobalTreasureLife[9], 7);
                        addSkill(InventoryItem().Add3, IntroConst.GlobalTreasureLife[10], 11);
                        addSkill(InventoryItem().Add4, IntroConst.GlobalTreasureLife[11], 14);
                    } else {
                        addSkill(InventoryItem().Add1, InventoryItem().Add1, 1);
                        addSkill(InventoryItem().Add2, InventoryItem().Add2, 7);
                        addSkill(InventoryItem().Add3, InventoryItem().Add3, 11);
                        addSkill(InventoryItem().Add4, InventoryItem().Add4, 14);
                    };
                };
                addLine();
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                    addTreasureSeries();
                } else {
                    if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY){
                        addAuxiliarySeries();
                    } else {
                        if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK){
                            addSecretBookSeries();
                        };
                    };
                };
                addLine();
                addLevel();
                addPrice();
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            } else {
                addLevel();
                addPrice();
                addFlag();
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                    _local7 = ((LanguageMgr.GetTranslation("攻击") + "  ") + tipInfo.Attack);
                    addTF(tipContent, format2, 16755236, true, _local7);
                    addTreasureTip(LanguageMgr.GetTranslation("生命"), tipInfo.HpBonus);
                    addTreasureTip(LanguageMgr.GetTranslation("魔法"), tipInfo.MpBonus);
                };
                addSpecialSkill();
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            };
            IntroConst.GlobalLevel = -1;
            IntroConst.GlobalTreasureLife[0] = -1;
        }
        private function addStar(_arg1:int):void{
            var _local2:MovieClip = new MovieClip();
            _local2.x = 10;
            _local2.y = (6 + (lines * 20));
            lines = (lines + 1);
            EquipConst.addStar(_arg1, _local2);
            tipContent.addChild(_local2);
        }
        private function setTaskTooltip():void{
            addName();
            addBind();
            addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
        }
        private function getSpecialSkill():String{
            var _local2:uint;
            var _local1 = "";
            if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                if ((tipInfo as InventoryItemInfo)){
                    _local2 = ((tipInfo.AdditionFields[0] * 100) + InventoryItem().Enchanting);
                } else {
                    return (_local1);
                };
            } else {
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY){
                    _local2 = ((tipInfo.AdditionFields[0] * 100) + 1);
                } else {
                    if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK){
                        _local2 = ((tipInfo.AdditionFields[0] * 100) + 1);
                    };
                };
            };
            var _local3:SkillInfo = SkillManager.getIdSkillInfo(_local2);
            if (_local3){
                _local1 = _local3.Name;
            };
            return (_local1);
        }
        private function addProperty(_arg1:uint):void{
            var _local2:uint;
            var _local3:uint;
            var _local5:uint;
            var _local8:uint;
            var _local4:uint = 324530;
            if (tipInfo.Attack > 0){
                _local2 = 0;
                _local3 = tipInfo.Attack;
            } else {
                _local2 = tipInfo.MinAttack;
                _local3 = tipInfo.MaxAttack;
            };
            var _local6:uint;
            if ((tipInfo is InventoryItemInfo)){
                if (_arg1 > 0){
                    _local4 = 324530;
                    if ((((tipInfo.MainClass == ItemConst.ITEM_CLASS_EQUIP)) && ((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY)))))){
                        _local6 = EquipUtils.calcOrnamentBonus(tipInfo, ((InventoryItem().MinAttack + InventoryItem().MaxAttack) / 2), 0, _arg1);
                    } else {
                        _local6 = EquipUtils.calcBonus(tipInfo, ((InventoryItem().MinAttack + InventoryItem().MaxAttack) / 2), ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON, _arg1);
                    };
                } else {
                    _local4 = 324530;
                };
            };
            if (_local2 > 0){
                if ((((_local6 > 0)) && ((((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY)))))){
                    _local5 = addTF(tipContent, format2, _local4, false, ((((LanguageMgr.GetTranslation("攻击") + ":   ") + _local2) + " - ") + _local3));
                    addTF(tipContent, format2, 16627970, true, (("(+" + String(_local6)) + ")"), _local5);
                    _local6 = 0;
                } else {
                    _local5 = addTF(tipContent, format2, _local4, true, ((((LanguageMgr.GetTranslation("攻击") + ":   ") + _local2) + " - ") + _local3));
                };
            } else {
                if (_local3 > 0){
                    if ((((_local6 > 0)) && ((((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY)))))){
                        _local5 = addTF(tipContent, format2, _local4, false, ((LanguageMgr.GetTranslation("攻击") + ":   ") + _local3));
                        addTF(tipContent, format2, 16627970, true, (("(+" + String(_local6)) + ")"), _local5);
                        _local6 = 0;
                    } else {
                        addTF(tipContent, format2, _local4, true, ((LanguageMgr.GetTranslation("攻击") + ":   ") + _local3));
                    };
                };
            };
            var _local7 = "";
            if ((tipInfo is InventoryItemInfo)){
                if (_arg1 > 0){
                    if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH){
                        _local8 = EquipUtils.calcBonus(tipInfo, tipInfo.Defence, ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH, _arg1);
                        if (tipInfo.Defence == 0){
                            _local7 = ((LanguageMgr.GetTranslation("防御") + ":   ") + _local8);
                        } else {
                            _local6 = _local8;
                        };
                    } else {
                        if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE){
                            _local8 = EquipUtils.calcBonus(tipInfo, tipInfo.HpBonus, ItemConst.ITEM_SUBCLASS_EQUIP_SHOE, _arg1);
                            if (tipInfo.HpBonus == 0){
                                _local7 = ((LanguageMgr.GetTranslation("生命") + ":   ") + _local8);
                            } else {
                                _local6 = _local8;
                            };
                        } else {
                            if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT){
                                _local8 = EquipUtils.calcBonus(tipInfo, tipInfo.MpBonus, ItemConst.ITEM_SUBCLASS_EQUIP_HAT, _arg1);
                                if (tipInfo.MpBonus == 0){
                                    _local7 = ((LanguageMgr.GetTranslation("魔法") + ":   ") + _local8);
                                } else {
                                    _local6 = _local8;
                                };
                            };
                        };
                    };
                    if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_VIGOUR){
                        _local6 = EquipUtils.calcOrnamentBonus(tipInfo, tipInfo.Defence, 0, _arg1);
                    };
                };
            };
            if (tipInfo.Defence > 0){
                if ((((_local6 > 0)) && ((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_VIGOUR)))))){
                    _local5 = addTF(tipContent, format2, 324530, false, ((LanguageMgr.GetTranslation("防御") + ":   ") + String(tipInfo.Defence)));
                    addTF(tipContent, format2, 16627970, true, (("(+" + String(_local6)) + ")"), _local5);
                    _local6 = 0;
                } else {
                    addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("防御") + ":   ") + String(tipInfo.Defence)));
                };
            };
            if (tipInfo.NormalHit > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("普通命中") + ":  ") + tipInfo.NormalHit));
            };
            if (tipInfo.NormalDodge > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("普通躲闪") + ":  ") + tipInfo.NormalDodge));
            };
            if (tipInfo.CriticalDamage > 0){
                addTF(tipContent, format2, 324530, true, (((LanguageMgr.GetTranslation("暴击伤害") + ":  ") + tipInfo.CriticalDamage) + "%"));
            };
            if (tipInfo.CriticalRate > 0){
                addTF(tipContent, format2, 324530, true, (((LanguageMgr.GetTranslation("暴击率") + ":  ") + tipInfo.CriticalRate) + "%"));
            };
            if (tipInfo.CrtrateReduce > 0){
                addTF(tipContent, format2, 324530, true, (((LanguageMgr.GetTranslation("暴击率减免") + ":  ") + Number((tipInfo.CrtrateReduce / 100)).toFixed(1)) + "%"));
            };
            if (tipInfo.CrtdmgReduce > 0){
                addTF(tipContent, format2, 324530, true, (((LanguageMgr.GetTranslation("暴击伤害减免") + ":  ") + Number((tipInfo.CrtdmgReduce / 100)).toFixed(1)) + "%"));
            };
            if (tipInfo.DamageReduce > 0){
                addTF(tipContent, format2, 324530, true, (((LanguageMgr.GetTranslation("伤害减免") + ":  ") + Number((tipInfo.DamageReduce / 100)).toFixed(1)) + "%"));
            };
            if (tipInfo.SkillHit > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("技能命中") + ":  ") + tipInfo.SkillHit));
            };
            if (tipInfo.SkillDodge > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("技能躲闪") + ":  ") + tipInfo.SkillDodge));
            };
            if (tipInfo.HpBonus > 0){
                if ((((_arg1 > 0)) && ((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))))){
                    _local6 = EquipUtils.calcOrnamentBonus(tipInfo, tipInfo.HpBonus, 1, _arg1);
                };
                if ((((_local6 > 0)) && ((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))))){
                    _local5 = addTF(tipContent, format2, 324530, false, ((LanguageMgr.GetTranslation("生命") + ":   ") + String(tipInfo.HpBonus)));
                    addTF(tipContent, format2, 16627970, true, (("(+" + String(_local6)) + ")"), _local5);
                    _local6 = 0;
                } else {
                    addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("生命") + ":   ") + String(tipInfo.HpBonus)));
                };
            };
            if (tipInfo.MpBonus > 0){
                if ((((_arg1 > 0)) && ((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY)))))){
                    _local6 = EquipUtils.calcOrnamentBonus(tipInfo, tipInfo.MpBonus, 1, _arg1);
                };
                if ((((_local6 > 0)) && ((((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_MAGICBODY)))))){
                    _local5 = addTF(tipContent, format2, 324530, false, ((LanguageMgr.GetTranslation("魔法") + ":   ") + String(tipInfo.MpBonus)));
                    addTF(tipContent, format2, 16627970, true, (("(+" + String(_local6)) + ")"), _local5);
                    _local6 = 0;
                } else {
                    addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("魔法") + ":   ") + String(tipInfo.MpBonus)));
                };
            };
            if (tipInfo.Resistance1 > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("眩晕抗性") + ":   ") + tipInfo.Resistance1));
            };
            if (tipInfo.Resistance2 > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("虚弱抗性") + ":   ") + tipInfo.Resistance2));
            };
            if (tipInfo.Resistance3 > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("昏睡抗性") + ":   ") + tipInfo.Resistance3));
            };
            if (tipInfo.Resistance4 > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("魅惑抗性") + ":   ") + tipInfo.Resistance4));
            };
            if (tipInfo.Resistance5 > 0){
                addTF(tipContent, format2, 324530, true, ((LanguageMgr.GetTranslation("定身抗性") + ":   ") + tipInfo.Resistance5));
            };
        }
        public function Show():void{
            tooltip_center = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToolTip");
            toolTip.addChild(tooltip_center);
            switch (tipInfo.MainClass){
                case ItemConst.ITEM_CLASS_UNDEF:
                    setDefaultTooltip();
                    break;
                case ItemConst.ITEM_CLASS_EQUIP:
                    if ((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK)))){
                        setTreasureTooltip();
                    } else {
                        setEquipTooltip();
                    };
                    break;
                case ItemConst.ITEM_CLASS_CONSUMABLE:
                    setConsumableTooltip();
                    break;
                case ItemConst.ITEM_CLASS_MATERIAL:
                    setMaterialTooltip();
                    break;
                case ItemConst.ITEM_CLASS_MEDICAL:
                    setMedicalTooltip();
                    break;
                case ItemConst.ITEM_CLASS_USABLE:
                    setUsableTooltip();
                    break;
                case ItemConst.ITEM_CLASS_TASK:
                    setTaskTooltip();
                    break;
                case ItemConst.ITEM_CLASS_PET:
                    if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF){
                        setPetTooltip();
                    } else {
                        setUsableTooltip();
                    };
                    break;
                default:
                    setDefaultTooltip();
            };
            tooltip_center.height = ((((lines * 20) - 40) - (descLines * 4)) + 58);
            if (tipInfo.Name.substr(0, 3) == "VIP"){
                tooltip_center.width = 281;
                tooltip_center.x = 0;
            } else {
                tooltip_center.width = 212;
            };
            upDatePos();
            toolTip.addChild(tipContent);
        }
        private function addShapeSolid(_arg1:uint):void{
            if (_arg1 == 0){
                return;
            };
            var _local2:Bitmap = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap(String(("ShapeSolid" + String(_arg1))));
            _local2.y = (6 + (lines * 20));
            _local2.x = 8;
            tipContent.addChild(_local2);
        }
        private function isAddStarShow(_arg1:ItemTemplateInfo):Boolean{
            if (((ItemConst.isStrengthType(_arg1)) || (ItemConst.isStarType(_arg1)))){
                return (true);
            };
            return (false);
        }
        private function addPrice():void{
            var _local2:uint;
            var _local1:uint = 1;
            if ((tipInfo is InventoryItemInfo)){
                _local1 = (tipInfo as InventoryItemInfo).Count;
                if ((tipInfo as InventoryItemInfo).price > 0){
                    _local2 = (tipInfo as InventoryItemInfo).price;
                    if (StallConstData.stallIdToQuery == GameCommonData.Player.Role.Id){
                        (tipInfo as InventoryItemInfo).price = 0;
                    };
                } else {
                    _local2 = tipInfo.PriceOut;
                };
            } else {
                if ((tipInfo is ShopItemInfo)){
                    if (tipInfo.price > 0){
                        _local2 = (tipInfo as InventoryItemInfo).price;
                        (tipInfo as InventoryItemInfo).price = 0;
                    } else {
                        if (((((tipInfo as ShopItemInfo).APriceArr[0] > 0)) && (((tipInfo as ShopItemInfo).APriceArr[2] == 0)))){
                            _local2 = (tipInfo as ShopItemInfo).APriceArr[0];
                        } else {
                            return;
                        };
                    };
                } else {
                    if (tipInfo.price > 0){
                        _local2 = tipInfo.price;
                        tipInfo.price = 0;
                    } else {
                        return;
                    };
                };
            };
            if (_local2 == 0){
                return;
            };
            addTF(tipContent, format2, 14515715, false, LanguageMgr.GetTranslation("价格"));
            var _local3:uint = int((_local2 / 10000));
            var _local4:uint = int(((_local2 % 10000) / 100));
            var _local5:uint = (_local2 % 100);
            var _local6:uint = (_local1 * _local2);
            var _local7:uint = int((_local6 / 10000));
            var _local8:uint = int(((_local6 % 10000) / 100));
            var _local9:uint = (_local6 % 100);
            var _local10:uint;
            var _local11:uint = 30;
            var _local12:Boolean;
            if (_local3 > 0){
                if ((((_local4 == 0)) && ((_local5 == 0)))){
                    _local12 = true;
                };
                addTF(tipContent, format2, 40102, _local12, (_local3 + LanguageMgr.GetTranslation("金")), _local11);
                _local10 = ((_local10 + 15) + (String(_local3).length * 7));
            };
            if (_local4 > 0){
                if (_local5 == 0){
                    _local12 = true;
                };
                addTF(tipContent, format2, 40102, _local12, (_local4 + LanguageMgr.GetTranslation("银")), (_local10 + _local11));
                _local10 = (_local10 + 27);
            };
            if (_local5 > 0){
                if ((((_local10 >= 54)) || ((_local1 <= 1)))){
                    addTF(tipContent, format2, 40102, true, (_local5 + LanguageMgr.GetTranslation("铜")), (_local11 + _local10));
                    _local10 = 0;
                } else {
                    addTF(tipContent, format2, 40102, false, (_local5 + LanguageMgr.GetTranslation("铜")), (_local11 + _local10));
                    _local10 = (_local10 + 27);
                };
            };
            if (_local1 <= 1){
                return;
            };
            addTF(tipContent, format2, 40102, false, (("(" + LanguageMgr.GetTranslation("总")) + ":"), (_local10 + _local11));
            _local10 = (_local10 + 20);
            if (_local7 > 0){
                addTF(tipContent, format2, 40102, false, (_local7 + LanguageMgr.GetTranslation("金")), (_local10 + _local11));
                _local10 = (_local10 + (15 + (String(_local7).length * 7)));
            };
            if (_local8 > 0){
                addTF(tipContent, format2, 40102, false, (_local8 + LanguageMgr.GetTranslation("银")), (_local10 + _local11));
                _local10 = (_local10 + (15 + (String(_local8).length * 7)));
            };
            if (_local9 > 0){
                addTF(tipContent, format2, 40102, false, (_local9 + LanguageMgr.GetTranslation("铜")), (_local11 + _local10));
                _local10 = (_local10 + (15 + (String(_local9).length * 7)));
            };
            addTF(tipContent, format2, 40102, true, ")", (_local10 + _local11));
        }
        private function setMaterialTooltip():void{
            addName();
            addBind();
            addFlag();
            addLevel();
            addJob();
            addPrice();
            if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_MATERIAL_RECIPE){
                addTF(tipContent, format2, 0xFFD200, true, LanguageMgr.GetTranslation("配方信息"));
            };
            addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
        }
        private function upDatePos():void{
            var _local1:DisplayObject;
            var _local2:* = 0;
            var _local3:Number = 0;
            if (isDrag){
                this.toolTip.mouseEnabled = true;
                this.toolTip.mouseChildren = true;
                toolTip.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseBtn");
                closeBtn.addEventListener(MouseEvent.CLICK, onClose);
                closeBtn.x = ((this.toolTip.width - closeBtn.width) - 5);
                closeBtn.y = 5;
                this.toolTip.addChild(closeBtn);
            };
        }
        private function addFlag():void{
            var _local1:uint;
            var _local2:Boolean;
            if ((tipInfo.Flags & ItemConst.FlAGS_TRADE)){
                _local2 = false;
            };
            if ((tipInfo.Flags & ItemConst.FLAGS_DROP)){
                _local1 = addTF(tipContent, format2, 12293391, _local2, LanguageMgr.GetTranslation("不可掉落"));
            };
            if ((tipInfo.Flags & ItemConst.FlAGS_GIVEUP)){
                _local1 = addTF(tipContent, format2, 12293391, _local2, LanguageMgr.GetTranslation("不可丢弃"), _local1);
            };
            if ((tipInfo.Flags & ItemConst.FlAGS_TRADE)){
                addTF(tipContent, format2, 12293391, true, LanguageMgr.GetTranslation("不可交易"), _local1);
            };
        }
        private function addSkill(_arg1:uint, _arg2:uint, _arg3:uint):void{
            var _local4:String;
            var _local6:String;
            var _local7:uint;
            if (_arg1 == 0){
                return;
            };
            _local4 = (String((_arg1 % 1000000)) + "01");
            var _local5:SkillInfo = SkillManager.getIdSkillInfo(uint(_local4));
            if (_local5){
                _local6 = SkillManager.getIdSkillInfo(uint(_local4)).Name;
            } else {
                _local6 = (String(_arg1) + "01");
            };
            if (_arg2 > 1000000){
                _local7 = addTF(tipContent, format2, 0xFFFFFF, false, _local6);
                addTF(tipContent, format2, 0xFFFFFF, true, (((((" +1" + LanguageMgr.GetTranslation("级")) + " (") + String(_arg3)) + LanguageMgr.GetTranslation("级领悟")) + ")"), 52);
            } else {
                _local7 = addTF(tipContent, format2, 0x888888, false, _local6);
                addTF(tipContent, format2, 0x888888, true, (((((" +1" + LanguageMgr.GetTranslation("级")) + " (") + String(_arg3)) + LanguageMgr.GetTranslation("级领悟")) + ")"), 52);
            };
        }
        public function Remove():void{
            var _local1:int = (toolTip.numChildren - 1);
            while (_local1 >= 0) {
                toolTip.removeChildAt(_local1);
                _local1--;
            };
            toolTip = null;
        }
        private function setEquipTooltip():void{
            var _local5:Array;
            var _local6:uint;
            var _local7:String;
            var _local8:String;
            var _local9:uint;
            var _local10:uint;
            var _local11:String;
            var _local1:int = IntroConst.GlobalLevel;
            if (IntroConst.GlobalLevel == -1){
                if ((tipInfo is InventoryItemInfo)){
                    _local1 = InventoryItem().Strengthen;
                };
            };
            var _local2:Boolean;
            if ((((tipInfo is InventoryItemInfo)) && ((_local1 > 0)))){
                _local2 = false;
            };
            var _local3:uint;
            _local3 = addTF(tipContent, format1, IntroConst.EquipColors[tipInfo.Color], _local2, tipInfo.Name);
            if ((((tipInfo is InventoryItemInfo)) && ((_local1 > 0)))){
                if (!ItemConst.isStarType(tipInfo)){
                    addTF(tipContent, format1, 16627970, true, (((("(" + LanguageMgr.GetTranslation("强化")) + "+") + _local1) + ")"), _local3);
                } else {
                    addTF(tipContent, format1, 16627970, true, "");
                };
            };
            addBind();
            addLevel();
            var _local4:uint = 14610175;
            if (tipInfo.Sex != GameCommonData.Player.Role.Sex){
                _local4 = 0xD20036;
            };
            addFlag();
            addJob();
            if ((((tipInfo is InventoryItemInfo)) && ((_local1 > 0)))){
                if (isAddStarShow(tipInfo)){
                    addLine();
                    addStar(_local1);
                    addLine();
                };
            };
            addLine();
            addProperty(_local1);
            addLine();
            if ((((tipInfo is InventoryItemInfo)) && ((((((((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))))){
                _local5 = new Array(3);
                _local5[0] = InventoryItem().AdditionFields[0];
                _local5[1] = InventoryItem().AdditionFields[1];
                _local5[2] = InventoryItem().AdditionFields[2];
                if ((((((_local5[0] > 0)) || ((_local5[1] > 0)))) || ((_local5[2] > 0)))){
                    _local6 = 0;
                    while (_local6 < 3) {
                        if (_local5[_local6] > 0){
                            if ((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_RING)))){
                                _local7 = LanguageMgr.GetTranslation("升星");
                            } else {
                                _local7 = LanguageMgr.GetTranslation("强化");
                            };
                            _local8 = String(_local5[_local6]);
                            _local9 = (_local5[_local6] % 100);
                            _local10 = (uint((_local5[_local6] / 100)) % 100);
                            _local11 = String(uint((_local5[_local6] / 10000)));
                            if ((((_local10 == 5)) || ((_local10 == 6)))){
                                _local11 = (_local11 + "%");
                            } else {
                                if ((((((_local10 == 16)) || ((_local10 == 17)))) || ((_local10 == 18)))){
                                    _local11 = (Number((uint((_local5[_local6] / 10000)) / 100)).toFixed(1) + "%");
                                };
                            };
                            if ((((_local1 >= _local9)) && ((_local9 > 0)))){
                                addTF(tipContent, format2, 16777049, true, (((((((("(" + _local7) + "+") + _local9) + LanguageMgr.GetTranslation("激活")) + ")") + LanguageMgr.AdditionProperty[_local10]) + " +") + _local11));
                            } else {
                                if (_local9 > 0){
                                    addTF(tipContent, format2, 0x888888, true, (((((((("(" + _local7) + "+") + _local9) + LanguageMgr.GetTranslation("激活")) + ")") + LanguageMgr.AdditionProperty[_local10]) + " +") + _local11));
                                } else {
                                    addTF(tipContent, format2, 16777049, true, (((((((("(" + _local7) + "+") + _local9) + LanguageMgr.GetTranslation("激活")) + ")") + LanguageMgr.AdditionProperty[_local10]) + " +") + _local11));
                                };
                            };
                        };
                        _local6++;
                    };
                };
            };
            if (tipInfo.Set > 0){
                addEquipSetTip();
            };
            addLine();
            if ((tipInfo is InventoryItemInfo)){
                if ((((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE)))){
                    addHole(InventoryItem().Add1);
                    addHole(InventoryItem().Add2);
                    addHole(InventoryItem().Add3);
                    addHole(InventoryItem().Add4);
                };
            } else {
                if ((((((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH)) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_WEAPON)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_HAT)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SHOE)))){
                    addTF(tipContent, format2, 0xA8FF00, true, LanguageMgr.GetTranslation("随机属性尚未指定"));
                };
            };
            addLine();
            if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_MOUNT){
                if (tipInfo.Color == 0){
                    addTF(tipContent, format2, 0xA8FF00, true, ((LanguageMgr.GetTranslation("移动速度") + " ") + "4.0"));
                } else {
                    if (tipInfo.Color == 1){
                        addTF(tipContent, format2, 0xA8FF00, true, ((LanguageMgr.GetTranslation("移动速度") + " ") + "6.0"));
                    } else {
                        addTF(tipContent, format2, 0xA8FF00, true, ((LanguageMgr.GetTranslation("移动速度") + " ") + "8.0"));
                    };
                };
            };
            addPrice();
            IntroConst.GlobalLevel = -1;
            if ((((((tipInfo.MainClass == ItemConst.ITEM_CLASS_EQUIP)) && (InventoryItem()))) && (InventoryItem().isBroken))){
                addTF(tipContent, format1, 0xFF0000, true, LanguageMgr.GetTranslation("该装备已破损"), 0, true);
                addTF(tipContent, format1, 0xFF0000, true, LanguageMgr.GetTranslation("修理后发挥效用"), 0, true);
            } else {
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            };
        }
        private function setUsableTooltip():void{
            var _local1:uint;
            var _local2:uint;
            var _local3:String;
            if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_STRENGTH){
                addName();
                addBind();
                addFlag();
                addLevel();
                addJob();
                addPrice();
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            } else {
                addName();
                addBind();
                addLevel();
                addJob();
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE){
                    _local1 = (tipInfo.Attack - 1);
                    if ((((_local1 == 4)) || ((_local1 == 5)))){
                        if (_local1 == 5){
                            addTF(tipContent, format2, 324530, true, (((LanguageMgr.EquipHoleType[tipInfo.Attack] + " +") + String((IntroConst.RunePropValue[_local1][(tipInfo.HpBonus - 1)] / 100))) + "%"));
                        } else {
                            addTF(tipContent, format2, 324530, true, (((LanguageMgr.EquipHoleType[tipInfo.Attack] + " +") + String(IntroConst.RunePropValue[_local1][(tipInfo.HpBonus - 1)])) + "%"));
                        };
                    } else {
                        addTF(tipContent, format2, 324530, true, ((LanguageMgr.EquipHoleType[tipInfo.Attack] + " +") + IntroConst.RunePropValue[_local1][(tipInfo.HpBonus - 1)]));
                    };
                    _local2 = 0;
                    if ((tipInfo is InventoryItemInfo)){
                        _local2 = InventoryItem().Add2;
                    } else {
                        _local2 = tipInfo.Set;
                    };
                    if (_local2 > 0){
                        if (_local2 == 6){
                            addTF(tipContent, format2, 324530, true, ((LanguageMgr.RunePrefix[_local2] + IntroConst.RunePrefixValue[((tipInfo.HpBonus - 1) - 4)][(_local2 - 1)]) + "%"), 0);
                        } else {
                            addTF(tipContent, format2, 324530, true, ((LanguageMgr.RunePrefix[_local2] + IntroConst.RunePrefixValue[((tipInfo.HpBonus - 1) - 4)][(_local2 - 1)]) + LanguageMgr.GetTranslation("点")), 0);
                        };
                    };
                };
                addPrice();
                addFlag();
                if ((((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)) && ((tipInfo.HpBonus >= 5)))){
                    _local3 = LanguageMgr.GetTranslation("确定形状才能镶嵌句");
                    if ((tipInfo is ShopItemInfo)){
                        addTF(tipContent, format2, 16755236, true, _local3, 0, true);
                    } else {
                        if ((((tipInfo is InventoryItemInfo)) && ((InventoryItem().Add2 == 0)))){
                            addTF(tipContent, format2, 16755236, true, _local3, 0, true);
                        } else {
                            if ((((tipInfo is ItemTemplateInfo)) && ((tipInfo.Set > 0)))){
                                addTF(tipContent, format2, 16755236, true, _local3, 0, true);
                            } else {
                                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
                            };
                        };
                    };
                } else {
                    addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
                };
            };
        }
        private function setMedicalTooltip():void{
            addName();
            addBind();
            addFlag();
            addLevel();
            addJob();
            var _local1 = "";
            if ((((((tipInfo.SubClass == ItemConst.MEDICINE_HPBAG)) || ((tipInfo.SubClass == ItemConst.MEDICINE_MPBAG)))) || ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_MEDICAL_PET)))){
                if (InventoryItem() != null){
                    _local1 = (((LanguageMgr.GetTranslation("当前总量") + InventoryItem().Add1) + "/") + InventoryItem().Attack);
                } else {
                    _local1 = (((LanguageMgr.GetTranslation("当前总量") + tipInfo.Attack) + "/") + tipInfo.Attack);
                };
                addTF(tipContent, format2, 16755236, true, _local1);
            };
            if ((((tipInfo is InventoryItemInfo)) && ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_MEDICINE_EXP)))){
                _local1 = (LanguageMgr.GetTranslation("当前总量") + InventoryItem().Add1);
                addTF(tipContent, format2, 16755236, true, _local1);
            };
            addPrice();
            addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
        }
        private function addSeriesSkill(_arg1:uint, _arg2:Boolean, _arg3:Boolean, _arg4:Boolean, _arg5:Boolean, _arg6:Boolean):void{
            var _local7:uint;
            if (_arg2){
                addTF(tipContent, format2, 14515715, true, UIConstData.TreasureSeriesDic[(String(_arg1) + "_0")].Name);
            } else {
                addTF(tipContent, format2, 0x888888, true, UIConstData.TreasureSeriesDic[(String(_arg1) + "_0")].Name);
            };
            var _local8:String = LanguageMgr.GetTranslation("级");
            if (_arg3){
                _local7 = addTF(tipContent, format2, 14515715, false, UIConstData.TreasureSeriesDic[(String(_arg1) + "_1")].Name);
                if (_arg5){
                    addTF(tipContent, format2, 14515715, true, ((getSpecialSkill() + " +1") + _local8), _local7);
                } else {
                    addTF(tipContent, format2, 0x888888, true, ((getSpecialSkill() + " +1") + _local8), _local7);
                };
            } else {
                _local7 = addTF(tipContent, format2, 0x888888, false, UIConstData.TreasureSeriesDic[(String(_arg1) + "_1")].Name);
                addTF(tipContent, format2, 0x888888, true, ((getSpecialSkill() + " +1") + _local8), _local7);
            };
            if (_arg4){
                _local7 = addTF(tipContent, format2, 14515715, false, UIConstData.TreasureSeriesDic[(String(_arg1) + "_2")].Name);
                if (_arg6){
                    addTF(tipContent, format2, 14515715, true, ((getSpecialSkill() + " +1") + _local8), _local7);
                } else {
                    addTF(tipContent, format2, 0x888888, true, ((getSpecialSkill() + " +1") + _local8), _local7);
                };
            } else {
                _local7 = addTF(tipContent, format2, 0x888888, false, UIConstData.TreasureSeriesDic[(String(_arg1) + "_2")].Name);
                addTF(tipContent, format2, 0x888888, true, ((getSpecialSkill() + " +1") + _local8), _local7);
            };
        }
        private function onMouseUp(_arg1:MouseEvent):void{
            this.toolTip.stopDrag();
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            this.toolTip.startDrag();
            toolTip.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        private function ShopItem():ShopItemInfo{
            return ((tipInfo as ShopItemInfo));
        }
        private function calcBonus(_arg1:uint, _arg2:uint, _arg3:uint):uint{
            var _local4:uint = _arg3;
            if ((_arg2 % 2) == 1){
                _local4++;
                _arg1 = (_arg1 * 2);
            } else {
                _arg1 = (_arg1 * 8);
            };
            _arg1 = (_arg1 * (_local4 * (((27 * _local4) + 10) - (_local4 * _local4))));
            _arg1 = (_arg1 / 1200);
            if (tipInfo.Color == 0){
                _arg1 = (_arg1 * Number((1 / 3)));
            } else {
                if (tipInfo.Color == 1){
                    _arg1 = (_arg1 * Number((2 / 3)));
                } else {
                    if (tipInfo.Color == 3){
                        _arg1 = (_arg1 * Number((31 / 25)));
                    };
                };
            };
            _arg1 = (_arg1 + 1);
            return (_arg1);
        }
        private function addName(_arg1:uint=14610175):uint{
            var _local4:uint;
            var _local2:uint = 1;
            if ((tipInfo is InventoryItemInfo)){
                _local2 = (tipInfo as InventoryItemInfo).Count;
            };
            var _local3 = "";
            if (_local2 > 1){
                _local3 = (((_local3 + "(") + _local2) + ")");
            };
            var _local5:uint;
            if ((tipInfo is InventoryItemInfo)){
                _local5 = InventoryItem().Add2;
            } else {
                _local5 = tipInfo.Set;
            };
            if ((((((tipInfo.MainClass == ItemConst.ITEM_CLASS_USABLE)) && ((tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_USEABLE_RUNE)))) && ((_local5 > 0)))){
                _local4 = addTF(tipContent, format1, IntroConst.EquipColors[tipInfo.Color], true, (((LanguageMgr.EquipHolePrefix[_local5] + "·") + tipInfo.Name) + _local3));
            } else {
                _local4 = addTF(tipContent, format1, IntroConst.EquipColors[tipInfo.Color], true, (tipInfo.Name + _local3));
            };
            return (_local4);
        }
        private function addEquipSetTip():void{
            var _local1:Array;
            var _local2:int;
            var _local5:int;
            var _local8:String;
            var _local9:uint;
            var _local10:Boolean;
            var _local11:String;
            var _local12:int;
            var _local13:int;
            var _local14:String;
            addLine();
            if (((((InventoryItem()) && ((InventoryItem().Place >= ItemConst.EQUIP_SLOT_START)))) && ((InventoryItem().Place < ItemConst.EQUIP_SLOT_END)))){
                _local1 = (UIFacade.GetInstance().retrieveMediator(PlayerEquipMediator.NAME) as PlayerEquipMediator).ItemList;
            };
            if ((((_local1 == null)) || (!((RolePropDatas.ItemList.indexOf(tipInfo) == -1))))){
                _local1 = RolePropDatas.ItemList;
            };
            var _local3:Array = [];
            var _local4:int = LanguageMgr.PersonPanelList.length;
            var _local6:int;
            while (_local6 < _local4) {
                if (((((_local1[_local6]) && (_local1[_local6].Set))) && ((_local1[_local6].Set == tipInfo.Set)))){
                    if (((InventoryItem()) && (InventoryItem().isBroken))){
                    } else {
                        _local2++;
                        _local3.push(_local6);
                    };
                };
                _local6++;
            };
            _local4 = EquipSetConst.EquipSetLocList[tipInfo.Set].length;
            var _local7:EquipSetInfo = EquipSetConst.EquipInfoList[tipInfo.Set];
            addTF(tipContent, format2, 324530, true, (((((_local7.setName + "(") + _local2) + "/") + _local4) + ")"), 0);
            _local6 = 0;
            while (_local6 < _local4) {
                _local5 = EquipSetConst.EquipSetLocList[tipInfo.Set][_local6];
                _local8 = (LanguageMgr.PersonPanelList[_local5] + " ");
                if (_local3.indexOf(_local5) != -1){
                    _local9 = 0xFF00;
                } else {
                    _local9 = 0xCCCCCC;
                };
                if (_local6 == (_local4 - 1)){
                    _local10 = true;
                } else {
                    _local10 = false;
                };
                addTF(tipContent, format2, _local9, _local10, _local8, (30 * _local6));
                _local6++;
            };
            for (_local11 in _local7.collectInfoList) {
                _local12 = _local7.collectInfoList[_local11][0];
                _local5 = _local7.collectInfoList[_local11][1];
                _local13 = _local7.collectInfoList[_local11][2];
                _local14 = ("" + _local13);
                if ((((_local5 == 5)) || ((_local5 == 6)))){
                    _local14 = (String(_local13) + "%");
                } else {
                    if ((((((_local5 == 16)) || ((_local5 == 17)))) || ((_local5 == 18)))){
                        _local14 = (Number((_local13 / 100)).toFixed(1) + "%");
                    };
                };
                if (_local2 >= _local12){
                    _local9 = 16777049;
                } else {
                    _local9 = 0xCCCCCC;
                };
                addTF(tipContent, format2, _local9, true, ((((("[" + _local12) + "]") + LanguageMgr.AdditionProperty[_local5]) + " +") + _local14), 0);
            };
        }
        private function addSecretBookSeries():void{
            var _local8:uint;
            var _local9:uint;
            var _local1:uint = 1;
            var _local2:uint = (tipInfo as InventoryItemInfo).AdditionFields[0];
            var _local3:Boolean;
            var _local4:Boolean;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:Boolean;
            if (InventoryItem().Place == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK){
                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                    _local8 = (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE] as InventoryItemInfo).AdditionFields[0];
                    if (_local2 == _local8){
                        _local3 = true;
                        _local7 = true;
                        _local1++;
                    };
                };
                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY]){
                    _local9 = (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY] as InventoryItemInfo).AdditionFields[0];
                    if (_local2 == _local9){
                        _local4 = true;
                        if (_local3){
                            _local6 = true;
                        };
                        _local1++;
                    };
                };
            };
            addTF(tipContent, format2, 14515715, true, (((LanguageMgr.GetTranslation("神兵套装") + "(") + String(_local1)) + "/3)"));
            addSeriesSkill(_local2, _local3, _local4, _local5, _local6, _local7);
        }
        private function addTF(_arg1:MovieClip, _arg2:TextFormat, _arg3:uint, _arg4:Boolean, _arg5:String, _arg6:uint=0, _arg7:Boolean=false):uint{
            var _local8:TextField;
            _local8 = new TextField();
            _local8.text = _arg5;
            _local8.autoSize = TextFieldAutoSize.LEFT;
            _local8.textColor = _arg3;
            _local8.cacheAsBitmap = true;
            if (_arg7 == true){
                _local8.width = 195;
                _local8.wordWrap = true;
                _local8.multiline = true;
                if (tipInfo.Name.substr(0, 3) == "VIP"){
                    _local8.width = 270;
                };
                _local8.htmlText = _arg5;
            };
            _local8.setTextFormat(_arg2);
            _local8.x = (8 + _arg6);
            _local8.y = (8 + (lines * 20));
            _local8.filters = defaultFilters;
            _local8.mouseEnabled = false;
            _arg1.addChild(_local8);
            if (_arg4){
                lines = (lines + _local8.numLines);
                descLines = _local8.numLines;
            };
            return ((_local8.width + _arg6));
        }
        private function addLine():void{
            var _local1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Tooltip_Line");
            _local1.y = (5 + (lines * 20));
            _local1.height = 1;
            _local1.x = 7;
            tipContent.addChild(_local1);
        }
        private function onClose(_arg1:MouseEvent):void{
            closeHandler();
        }
        private function addSpecialSkill():void{
            var _local2:String;
            var _local1:String = getSpecialSkill();
            if (_local1 != ""){
                _local2 = ((LanguageMgr.GetTranslation("特有技能") + "  ") + _local1);
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE){
                    _local2 = (((_local2 + " ") + InventoryItem().Enchanting) + LanguageMgr.GetTranslation("级"));
                };
                addTF(tipContent, format2, 0xBA00FF, true, _local2);
            };
        }
        private function setConsumableTooltip():void{
            var _local1:String;
            var _local2:String;
            if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_CONSUMABLE_BACK){
                addName();
                addFlag();
                addLevel();
                addJob();
                addBind();
                addPrice();
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            } else {
                addName();
                addBind();
                addFlag();
                if (tipInfo.SubClass == ItemConst.ITEM_SUBCLASS_CONSUMABLE_TREASUREMAP){
                    if ((tipInfo is InventoryItemInfo)){
                        _local1 = String(GameCommonData.MapConfigs[InventoryItem().Add1].@Name);
                        _local2 = LanguageMgr.GetTranslation("可以在p(x,y)附近使用", _local1, InventoryItem().Add2, InventoryItem().Add3);
                        addTF(tipContent, format2, 16755236, true, _local2, 0, true);
                    };
                };
                addLevel();
                addJob();
                addPrice();
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            };
        }
        private function setPetTooltip():void{
            var _local1:String;
            var _local2:uint;
            var _local3:uint;
            var _local4:String;
            if ((tipInfo as InventoryItemInfo)){
                addTF(tipContent, format2, IntroConst.EquipColors[tipInfo.Color], true, InventoryItem().PetInfo.PetName);
                addTF(tipContent, format2, 2133534, true, ((LanguageMgr.GetTranslation("宠物等级") + "   ") + InventoryItem().PetInfo.Level));
                if (InventoryItem().PetInfo.PetType > 0){
                    addTF(tipContent, format2, 2133534, true, (((LanguageMgr.GetTranslation("类型") + "   ") + InventoryItem().PetInfo.MainType) + InventoryItem().PetInfo.SubType));
                };
                addFlag();
                addTF(tipContent, format2, 2133534, true, ((LanguageMgr.GetTranslation("星数") + "   ") + InventoryItem().PetInfo.Start));
                addLine();
                addTF(tipContent, format2, 16220976, false, ((LanguageMgr.GetTranslation("生命") + "   ") + InventoryItem().PetInfo.HpMax));
                addTF(tipContent, format2, PetPropConstData.getColorStr(InventoryItem().PetInfo.UpgradeValue[2]), true, getPetUpgrade(2), 90);
                addTF(tipContent, format2, 16220976, false, ((LanguageMgr.GetTranslation("魔法") + "   ") + InventoryItem().PetInfo.MpMax));
                addTF(tipContent, format2, PetPropConstData.getColorStr(InventoryItem().PetInfo.UpgradeValue[3]), true, getPetUpgrade(3), 90);
                addTF(tipContent, format2, 16220976, false, ((LanguageMgr.GetTranslation("攻击") + "   ") + InventoryItem().PetInfo.Attack));
                addTF(tipContent, format2, PetPropConstData.getColorStr(InventoryItem().PetInfo.UpgradeValue[0]), true, getPetUpgrade(0), 90);
                addTF(tipContent, format2, 16220976, false, ((LanguageMgr.GetTranslation("防御") + "   ") + InventoryItem().PetInfo.Defense));
                addTF(tipContent, format2, PetPropConstData.getColorStr(InventoryItem().PetInfo.UpgradeValue[1]), true, getPetUpgrade(1), 90);
                addTF(tipContent, format2, 16220976, false, ((LanguageMgr.GetTranslation("命中") + "   ") + InventoryItem().PetInfo.Hit));
                addTF(tipContent, format2, PetPropConstData.getColorStr(InventoryItem().PetInfo.UpgradeValue[4]), true, getPetUpgrade(4), 90);
                addTF(tipContent, format2, 16220976, false, ((LanguageMgr.GetTranslation("躲闪") + "   ") + InventoryItem().PetInfo.Dodge));
                addTF(tipContent, format2, PetPropConstData.getColorStr(InventoryItem().PetInfo.UpgradeValue[5]), true, getPetUpgrade(5), 90);
                addTF(tipContent, format2, 16220976, true, (((LanguageMgr.GetTranslation("暴击率") + "   ") + Number((InventoryItem().PetInfo.Crit * 100)).toFixed(1)) + "%"));
                addTF(tipContent, format2, 16220976, true, (((LanguageMgr.GetTranslation("暴击伤害") + "   ") + Number((InventoryItem().PetInfo.CritRate * 100)).toFixed(1)) + "%"));
                addLine();
                _local1 = "";
                _local2 = InventoryItem().PetInfo.SpecialSkill;
                _local3 = uint(((InventoryItem().PetInfo.Level + 19) / 20));
                _local4 = String(_local2);
                if (_local2 > 600000){
                    addTF(tipContent, format2, 16220976, true, (((((((((LanguageMgr.GetTranslation("得意技") + "：") + GameCommonData.SkillList[_local2].Name) + "<") + InventoryItem().PetInfo.MainType) + ">") + _local4.substr((_local1.length - 1), 1)) + "/") + String(_local3)) + LanguageMgr.GetTranslation("级")));
                };
                _local2 = InventoryItem().PetInfo.CommonSkills[0];
                if (_local2 > 600000){
                    _local1 = String(_local2);
                    addTF(tipContent, format2, 16220976, true, (((((((((LanguageMgr.GetTranslation("通用技") + "：") + GameCommonData.SkillList[_local2].Name) + "<") + LanguageMgr.GetTranslation("通用")) + ">") + _local1.substr((_local1.length - 1), 1)) + "/") + String(_local3)) + LanguageMgr.GetTranslation("级")));
                };
                _local2 = InventoryItem().PetInfo.CommonSkills[1];
                if (_local2 > 600000){
                    _local1 = String(_local2);
                    addTF(tipContent, format2, 16220976, true, (((((((((LanguageMgr.GetTranslation("通用技") + "：") + GameCommonData.SkillList[_local2].Name) + "<") + LanguageMgr.GetTranslation("通用")) + ">") + _local1.substr((_local1.length - 1), 1)) + "/") + String(_local3)) + LanguageMgr.GetTranslation("级")));
                };
                _local2 = InventoryItem().PetInfo.CommonSkills[2];
                if (_local2 > 600000){
                    _local1 = String(_local2);
                    addTF(tipContent, format2, 16220976, true, (((((((((LanguageMgr.GetTranslation("通用技") + "：") + GameCommonData.SkillList[_local2].Name) + "<") + LanguageMgr.GetTranslation("通用")) + ">") + _local1.substr((_local1.length - 1), 1)) + "/") + String(_local3)) + LanguageMgr.GetTranslation("级")));
                };
                _local2 = InventoryItem().PetInfo.CommonSkills[3];
                if (_local2 > 600000){
                    _local1 = String(_local2);
                    addTF(tipContent, format2, 16220976, true, (((((((((LanguageMgr.GetTranslation("通用技") + "：") + GameCommonData.SkillList[_local2].Name) + "<") + LanguageMgr.GetTranslation("通用")) + ">") + _local1.substr((_local1.length - 1), 1)) + "/") + String(_local3)) + LanguageMgr.GetTranslation("级")));
                };
                addPrice();
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            } else {
                addName();
                addFlag();
                addLevel();
                addPrice();
                addTF(tipContent, format2, 16220976, true, ((LanguageMgr.GetTranslation("生命") + "   ") + tipInfo.HpBonus));
                addTF(tipContent, format2, 16220976, true, ((LanguageMgr.GetTranslation("魔法") + "   ") + tipInfo.MpBonus));
                addTF(tipContent, format2, 16220976, true, ((LanguageMgr.GetTranslation("攻击") + "   ") + tipInfo.Attack));
                addTF(tipContent, format2, 16220976, true, ((LanguageMgr.GetTranslation("防御") + "   ") + tipInfo.Defence));
                addTF(tipContent, format2, 16220976, true, ((LanguageMgr.GetTranslation("命中") + "   ") + tipInfo.NormalHit));
                addTF(tipContent, format2, 16220976, true, ((LanguageMgr.GetTranslation("躲闪") + "   ") + tipInfo.NormalDodge));
                addTF(tipContent, format2, 16220976, true, (((LanguageMgr.GetTranslation("暴击率") + "   ") + Number(tipInfo.CriticalRate).toFixed(1)) + "%"));
                addTF(tipContent, format2, 16220976, true, (((LanguageMgr.GetTranslation("暴击伤害") + "   ") + Number(tipInfo.CriticalDamage).toFixed(1)) + "%"));
                addTF(tipContent, format2, 16755236, true, tipInfo.Description, 0, true);
            };
        }
        private function addLevel():void{
            var _local1:String;
            if (tipInfo.RequiredLevel > GameCommonData.Player.Role.Level){
                addTF(tipContent, format2, 0xFF0000, true, ((LanguageMgr.GetTranslation("等级要求") + "   ") + tipInfo.RequiredLevel));
            } else {
                _local1 = ((tipInfo.RequiredLevel)==0) ? String(1) : String(tipInfo.RequiredLevel);
                addTF(tipContent, format2, 0xFFFFFF, true, ((LanguageMgr.GetTranslation("等级要求") + "   ") + _local1));
            };
        }
        private function addJob():void{
            var _local1:String;
            if (tipInfo.Job == 0){
                return;
            };
            if (tipInfo.Job != GameCommonData.Player.Role.CurrentJobID){
                addTF(tipContent, format2, 0xD20036, true, GameCommonData.RolesListDic[tipInfo.Job]);
            } else {
                _local1 = ((tipInfo.RequiredLevel)==0) ? String(1) : String(tipInfo.RequiredLevel);
                addTF(tipContent, format2, 14610175, true, GameCommonData.RolesListDic[tipInfo.Job]);
            };
        }
        private function InventoryItem():InventoryItemInfo{
            return ((tipInfo as InventoryItemInfo));
        }
        public function Update(_arg1:Object):void{
        }
        private function getPetUpgrade(_arg1:uint):String{
            var _local2 = "";
            if (InventoryItem().PetInfo.UpgradeValue[_arg1] > 0){
                _local2 = (("+" + String(InventoryItem().PetInfo.UpgradeValue[_arg1])) + "%");
            };
            return (_local2);
        }
        public function BackWidth():Number{
            return (tooltip_center.width);
        }

    }
}//package GameUI.Modules.ToolTip.Mediator.UI 
