//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.MainScene.Proxy {
    import flash.events.*;
    import flash.display.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.MainScene.Data.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;

    public class QuickSkillManager extends Proxy {

        public static const NAME:String = "QuickSkillManager";

        private var mainScene:MovieClip;

        public function QuickSkillManager(_arg1:MovieClip){
            super(NAME);
            this.mainScene = _arg1;
        }
        public function addUseItem(_arg1:Object):void{
            var _local2:UseItem;
            var _local3:uint;
            var _local4:Object;
            var _local10:InventoryItemInfo;
            var _local5:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local6:Dictionary = QuickBarData.getInstance().expandKeyDic;
            var _local7:UseItem = (_arg1.source as UseItem);
            var _local8:uint = _arg1.index;
            var _local9:String = _arg1.type;
            if (this.isInQuick(_local9, _local8, _local7.Type, _local7.IsBind)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("已经在快捷栏中"),
                    color:0xFFFF00
                });
                return;
            };
            if (this.isInQuickEnable(_local7.itemIemplateInfo)){
                _local2 = new UseItem(-1, _local7.Type, null);
                _local2.x = 2;
                _local2.y = 2;
                _local2.mouseEnabled = true;
                _local2.IsBind = _local7.IsBind;
                _local3 = 0;
                for each (_local10 in (BagData.AllItems[0] as Array)) {
                    if (_local10 != null){
                        if ((((_local10.type == _local2.Type)) && ((_local10.isBind == _local2.IsBind)))){
                            _local3 = (_local3 + _local10.Count);
                        };
                    };
                };
                if ((((_local3 > 0)) && ((UIConstData.ItemDic[_local7.Type].MaxCount == 1)))){
                    _local3 = 1;
                };
                _local2.Num = _local3;
                if (_local2.Num == 0){
                    _local2.canUse(false);
                } else {
                    _local2.canUse(true);
                };
                _local2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                _local2.addEventListener(MouseEvent.CLICK, onUseItemClick);
                _local2.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                _local2.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                if ((((_local9 == "quick")) || ((_local9 == "key")))){
                    if (_local5[_local8] != null){
                        _local5[_local8].parent.removeChild(_local5[_local8]);
                        disposeItem(_local5[_local8]);
                    };
                    _local2.name = ("key_" + _local8);
                    _local5[_local8] = _local2;
                    mainScene.mcQuickBar0[("quick_" + _local8)].addChild(_local5[_local8]);
                    PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local8, PlayerActionSend.BAG_TYPE, _local2.Type, _local2.IsBind);
                } else {
                    if ((((_local9 == "quickf")) || ((_local9 == "keyF")))){
                        if (_local6[_local8] != null){
                            _local6[_local8].parent.removeChild(_local6[_local8]);
                            disposeItem(_local6[_local8]);
                        };
                        _local2.name = ("keyF_" + _local8);
                        _local6[_local8] = _local2;
                        mainScene.mcQuickBar1[("quickf_" + _local8)].addChild(_local6[_local8]);
                        PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local8 + 8), PlayerActionSend.BAG_TYPE, _local2.Type, _local2.IsBind);
                    };
                };
                sendNotification(EventList.SEND_QUICKBAR_MSG);
            };
        }
        public function isInQuickEnable(_arg1:ItemTemplateInfo):Boolean{
            if (((((ItemConst.IsMedical(_arg1)) || (ItemConst.IsUsable(_arg1)))) || (ItemConst.IsConsumable(_arg1)))){
                return (true);
            };
            return (false);
        }
        public function getTheQuickPos(_arg1:int=0):Point{
            return ((mainScene.mcQuickBar0[("quick_" + _arg1)] as Sprite).localToGlobal(new Point(0, 0)));
        }
        protected function onMouseDowmHandler(_arg1:MouseEvent):void{
            if ((_arg1.currentTarget is UseItem)){
                _arg1.currentTarget.onMouseDown();
            };
            _arg1.stopPropagation();
            _arg1.currentTarget.addEventListener(MouseEvent.CLICK, onUseItemClick);
        }
        public function autoAddItem(_arg1:int, _arg2, _arg3:int=-1):void{
            var _local4:int;
            var _local5:Object;
            var _local8:SkillInfo;
            var _local9:*;
            var _local10:InventoryItemInfo;
            var _local6:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local7:Dictionary = QuickBarData.getInstance().expandKeyDic;
            if (_arg1 == 0){
                _local10 = _arg2;
                _local9 = new UseItem(-1, _local10.TemplateID, null);
                _local9.IsBind = _local10.isBind;
            } else {
                _local8 = _arg2;
                _local9 = new NewSkillCell();
                _local9.setLearnSkillInfo(_local8);
            };
            if (_arg3 != -1){
                _local5 = {};
                _local5.source = _local9;
                _local5.index = _arg3;
                _local5.type = "quick";
                if (_arg1 == 0){
                    addUseItem(_local5);
                } else {
                    addSkillItem(_local5);
                };
                return;
            };
            while (_local4 < 8) {
                if (_local6[_local4] == null){
                    _local5 = {};
                    _local5.source = _local9;
                    _local5.index = _local4;
                    _local5.type = "quick";
                    if (_arg1 == 0){
                        addUseItem(_local5);
                    } else {
                        addSkillItem(_local5);
                    };
                    return;
                };
                _local4++;
            };
            _local4 = 0;
            while (_local4 < 8) {
                if (_local7[_local4] == null){
                    _local5 = {};
                    _local5.source = _local9;
                    _local5.index = _local4;
                    _local5.type = "quickf";
                    if (_arg1 == 0){
                        addUseItem(_local5);
                    } else {
                        addSkillItem(_local5);
                    };
                    return;
                };
                _local4++;
            };
        }
        private function isExistItem(_arg1):Boolean{
            if ((_arg1 is SkillUseItem)){
                if (SkillManager.getMyIdSkillInfo(_arg1.skillInfo.Id)){
                    return (true);
                };
            } else {
                if ((_arg1 is UseItem)){
                    if (QuickBarData.getInstance().getItemFromBag(_arg1)){
                        return (true);
                    };
                };
            };
            return (false);
        }
        public function addSkillItem(_arg1:Object):void{
            var _local3:uint;
            var _local5:SkillUseItem;
            var _local6:SkillInfo;
            var _local8:Dictionary;
            var _local2:NewSkillCell = (_arg1.source as NewSkillCell);
            if (_local2.parent == null){
                _local2.dispose();
            };
            _local3 = _arg1.index;
            var _local4:String = _arg1.type;
            _local6 = _local2.skillInfo;
            var _local7:Dictionary = QuickBarData.getInstance().quickKeyDic;
            _local8 = QuickBarData.getInstance().expandKeyDic;
            if (this.isInQuick(_local4, _local3, _local6.TypeID)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("已经在快捷栏中"),
                    color:0xFFFF00
                });
                return;
            };
            if ((((_local4 == "quick")) || ((_local4 == "key")))){
                if (_local7[_local3] != null){
                    _local7[_local3].parent.removeChild(_local7[_local3]);
                    disposeItem(_local7[_local3]);
                };
                _local5 = new SkillUseItem(_local3);
                _local5.x = 2;
                _local5.y = 2;
                _local5.setLearnSkillInfo(_local6);
                _local5.addEventListener(MouseEvent.CLICK, onUseItemClick);
                _local5.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                _local5.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                _local5.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                _local5.name = ("key_" + _local3);
                _local7[_local3] = _local5;
                mainScene.mcQuickBar0[("quick_" + _local3)].addChild(_local7[_local3]);
                PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local3, PlayerActionSend.SKILL_TYPE, _local5.skillInfo.Id);
            } else {
                if ((((_local4 == "quickf")) || ((_local4 == "keyF")))){
                    if (_local8[_local3] != null){
                        _local8[_local3].parent.removeChild(_local8[_local3]);
                        disposeItem(_local8[_local3]);
                    };
                    _local5 = new SkillUseItem(_local3);
                    _local5.x = 2;
                    _local5.y = 2;
                    _local5.setLearnSkillInfo(_local6);
                    _local5.addEventListener(MouseEvent.CLICK, onUseItemClick);
                    _local5.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                    _local5.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                    _local5.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                    _local5.name = ("keyF_" + _local3);
                    _local8[_local3] = _local5;
                    mainScene.mcQuickBar1[("quickf_" + _local3)].addChild(_local8[_local3]);
                    PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local3 + 8), PlayerActionSend.SKILL_TYPE, _local5.skillInfo.Id);
                };
            };
        }
        public function onUseItemClick(_arg1:MouseEvent):void{
            var _local2:* = _arg1.currentTarget;
            this.useQuickKey(_local2);
        }
        private function getNumFromBag(_arg1:int, _arg2:int):uint{
            var _local3:InventoryItemInfo;
            var _local4:uint;
            for each (_local3 in (BagData.AllItems[0] as Array)) {
                if (_local3 != null){
                    if ((((_local3.type == _arg1)) && ((_local3.isBind == _arg2)))){
                        _local4 = (_local4 + _local3.Count);
                    };
                };
            };
            if ((((_local4 > 0)) && ((UIConstData.ItemDic[_arg1].MaxCount == 1)))){
                _local4 = 1;
            };
            return (_local4);
        }
        private function disposeItem(_arg1:Sprite):void{
            if ((_arg1 is SkillUseItem)){
                _arg1.removeEventListener(MouseEvent.CLICK, onUseItemClick);
                _arg1.removeEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                _arg1.removeEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                _arg1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
                _arg1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                (_arg1 as SkillUseItem).dispose();
                _arg1 = null;
            } else {
                _arg1.removeEventListener(MouseEvent.CLICK, onUseItemClick);
                _arg1.removeEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                _arg1.removeEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                _arg1.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
                _arg1.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                (_arg1 as UseItem).gc();
                _arg1 = null;
            };
        }
        private function onMouseMoveHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.removeEventListener(MouseEvent.CLICK, onUseItemClick);
        }
        public function onSyncBag():void{
            var _local1:*;
            var _local2:*;
            var _local3:UseItem;
            var _local4:uint;
            var _local5:UseItem;
            var _local6:uint;
            var _local7:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local8:Dictionary = QuickBarData.getInstance().expandKeyDic;
            for (_local1 in _local7) {
                if (_local7[_local1] != null){
                    if ((_local7[_local1] is UseItem)){
                        _local3 = _local7[_local1];
                        _local4 = this.getNumFromBag(_local3.Type, _local3.IsBind);
                        if (_local4 == 0){
                            _local3.canUse(false);
                        } else {
                            _local3.canUse(true);
                        };
                        _local3.Num = _local4;
                    };
                };
            };
            for (_local2 in _local8) {
                if (_local8[_local2] != null){
                    if ((_local8[_local2] is UseItem)){
                        _local5 = _local8[_local2];
                        _local6 = this.getNumFromBag(_local5.Type, _local5.IsBind);
                        if (_local6 == 0){
                            _local5.canUse(false);
                        } else {
                            _local5.canUse(true);
                        };
                        _local5.Num = _local6;
                    };
                };
            };
        }
        public function updateSkillInfo():void{
            var _local3:*;
            var _local1:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local2:Dictionary = QuickBarData.getInstance().expandKeyDic;
            for each (_local3 in _local1) {
                if ((_local3 is SkillUseItem)){
                    _local3.updateInfo();
                };
            };
            for each (_local3 in _local2) {
                if ((_local3 is SkillUseItem)){
                    _local3.updateInfo();
                };
            };
        }
        protected function onDragedHandler(_arg1:DropEvent):void{
            var _local2:DisplayObject;
            var _local3:String;
            var _local4:DisplayObject;
            var _local5:String;
            var _local6:DisplayObjectContainer;
            var _local7:DisplayObjectContainer;
            var _local8:uint;
            var _local9:DisplayObject;
            var _local10:String;
            var _local11:DisplayObjectContainer;
            var _local12:uint;
            var _local13:DisplayObject;
            var _local14:String;
            var _local15:DisplayObject;
            var _local16:String;
            var _local17:DisplayObjectContainer;
            var _local18:DisplayObjectContainer;
            var _local19:uint;
            var _local20:DisplayObject;
            var _local21:String;
            var _local22:DisplayObjectContainer;
            var _local23:uint;
            var _local24:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local25:Dictionary = QuickBarData.getInstance().expandKeyDic;
            var _local26:uint = _arg1.Data.index;
            if ((((_arg1.Data.type == "quick")) || ((_arg1.Data.type == "key")))){
                if (_local24[_local26] != null){
                    _local2 = _local24[_local26];
                    _local3 = _local2.name;
                    _local4 = _arg1.Data.source;
                    _local5 = _local4.name;
                    _local6 = _arg1.Data.source.parent;
                    if (_local2 == null){
                        return;
                    };
                    _local7 = _local2.parent;
                    if (_local6 == _local7){
                        return;
                    };
                    _local6.removeChild(_arg1.Data.source);
                    _local7.removeChild(_local2);
                    _local8 = uint(_local5.substr((_local5.length - 1), _local5.length));
                    _local2.name = _local5;
                    _local4.name = _local3;
                    if (_local5.indexOf("keyF") != -1){
                        _local25[_local8] = _local2;
                        mainScene.mcQuickBar1[("quickf_" + _local8)].addChild(_local25[_local8]);
                        if ((_local25[_local8] is SkillUseItem)){
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local8 + 8), PlayerActionSend.SKILL_TYPE, _local25[_local8].skillInfo.Id);
                        } else {
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local8 + 8), PlayerActionSend.BAG_TYPE, _local25[_local8].Type, _local25[_local8].IsBind);
                        };
                    } else {
                        if (_local5.indexOf("key") != -1){
                            _local24[_local8] = _local2;
                            mainScene.mcQuickBar0[("quick_" + _local8)].addChild(_local24[_local8]);
                            if ((_local24[_local8] is SkillUseItem)){
                                PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local8, PlayerActionSend.SKILL_TYPE, _local24[_local8].skillInfo.Id);
                            } else {
                                PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local8, PlayerActionSend.BAG_TYPE, _local24[_local8].Type, _local24[_local8].IsBind);
                            };
                        };
                    };
                    _local24[_local26] = _local4;
                    mainScene.mcQuickBar0[("quick_" + _local26)].addChild(_local24[_local26]);
                    if ((_local24[_local26] is SkillUseItem)){
                        PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local26, PlayerActionSend.SKILL_TYPE, _local24[_local26].skillInfo.Id);
                    } else {
                        PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local26, PlayerActionSend.BAG_TYPE, _local24[_local26].Type, _local24[_local26].IsBind);
                    };
                } else {
                    _local9 = _arg1.Data.source;
                    _local10 = _local9.name;
                    _local11 = _arg1.Data.source.parent;
                    _local11.removeChild(_local9);
                    _local12 = uint(_local10.substr((_local10.length - 1), _local10.length));
                    _local9.name = ("key_" + _local26);
                    if (_local10.indexOf("keyF") != -1){
                        _local25[_local12] = null;
                        PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, (_local12 + 8));
                    } else {
                        if (_local10.indexOf("key") != -1){
                            _local24[_local12] = null;
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, _local12);
                        };
                    };
                    _local24[_local26] = _local9;
                    mainScene.mcQuickBar0[("quick_" + _local26)].addChild(_local24[_local26]);
                    if ((_local24[_local26] is SkillUseItem)){
                        PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local26, PlayerActionSend.SKILL_TYPE, _local24[_local26].skillInfo.Id);
                    } else {
                        PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local26, PlayerActionSend.BAG_TYPE, _local24[_local26].Type, _local24[_local26].IsBind);
                    };
                };
            } else {
                if ((((_arg1.Data.type == "quickf")) || ((_arg1.Data.type == "keyF")))){
                    if (_local25[_local26] != null){
                        _local13 = _local25[_local26];
                        _local14 = _local13.name;
                        _local15 = _arg1.Data.source;
                        _local16 = _local15.name;
                        _local17 = _arg1.Data.source.parent;
                        if (_local13 == null){
                            return;
                        };
                        _local18 = _local13.parent;
                        if (_local17 == _local18){
                            return;
                        };
                        _local17.removeChild(_arg1.Data.source);
                        _local18.removeChild(_local13);
                        _local19 = uint(_local16.substr((_local16.length - 1), _local16.length));
                        _local13.name = _local16;
                        _local15.name = _local14;
                        if (_local16.indexOf("keyF") != -1){
                            _local25[_local19] = _local13;
                            mainScene.mcQuickBar1[("quickf_" + _local19)].addChild(_local25[_local19]);
                            if ((_local25[_local19] is SkillUseItem)){
                                PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local19 + 8), PlayerActionSend.SKILL_TYPE, _local25[_local19].skillInfo.Id);
                            } else {
                                PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local19 + 8), PlayerActionSend.BAG_TYPE, _local25[_local19].Type, _local25[_local19].IsBind);
                            };
                        } else {
                            if (_local16.indexOf("key") != -1){
                                _local24[_local19] = _local13;
                                mainScene.mcQuickBar0[("quick_" + _local19)].addChild(_local24[_local19]);
                                if ((_local24[_local19] is SkillUseItem)){
                                    PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local19, PlayerActionSend.SKILL_TYPE, _local24[_local19].skillInfo.Id);
                                } else {
                                    PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, _local19, PlayerActionSend.BAG_TYPE, _local24[_local19].Type, _local24[_local19].IsBind);
                                };
                            };
                        };
                        _local25[_local26] = _local15;
                        mainScene.mcQuickBar1[("quickf_" + _local26)].addChild(_local25[_local26]);
                        if ((_local25[_local26] is SkillUseItem)){
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local26 + 8), PlayerActionSend.SKILL_TYPE, _local25[_local26].skillInfo.Id);
                        } else {
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local26 + 8), PlayerActionSend.BAG_TYPE, _local25[_local26].Type, _local25[_local26].IsBind);
                        };
                    } else {
                        _local20 = _arg1.Data.source;
                        _local21 = _local20.name;
                        _local22 = _arg1.Data.source.parent;
                        _local22.addChild(_local20);
                        _local23 = uint(_local21.substr((_local21.length - 1), _local21.length));
                        _local20.name = ("keyF_" + _local26);
                        if (_local21.indexOf("keyF") != -1){
                            _local25[_local23] = null;
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, (_local23 + 8));
                        } else {
                            if (_local21.indexOf("key") != -1){
                                _local24[_local23] = null;
                                PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, _local23);
                            };
                        };
                        _local25[_local26] = _local20;
                        mainScene.mcQuickBar1[("quickf_" + _local26)].addChild(_local25[_local26]);
                        if ((_local25[_local26] is SkillUseItem)){
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local26 + 8), PlayerActionSend.SKILL_TYPE, _local25[_local26].skillInfo.Id);
                        } else {
                            PlayerActionSend.SendQuickOperate(PlayerActionSend.ADD_QUICKITEM, (_local26 + 8), PlayerActionSend.BAG_TYPE, _local25[_local26].Type, _local25[_local26].IsBind);
                        };
                    };
                };
            };
        }
        private function useQuickKey(_arg1):void{
            var _local2:InventoryItemInfo;
            if ((_arg1 is SkillUseItem)){
                if ((((((_arg1 == null)) || (_arg1.IsCdTimer))) || (!(UIConstData.KeyBoardCanUse)))){
                    return;
                };
                PlayerController.UseSkill(_arg1.skillInfo);
            } else {
                if ((_arg1 is UseItem)){
                    if ((((((((_arg1 == null)) || (_arg1.IsCdTimer))) || (!(UIConstData.KeyBoardCanUse)))) || (!(_arg1.canUseIt)))){
                        return;
                    };
                    if (GameCommonData.Player.Role.canUseItem){
                        _local2 = QuickBarData.getInstance().getItemFromBag(_arg1);
                        if (_local2){
                            if (ItemConst.IsMedicalExceptBAG(_local2)){
                                sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                            };
                            BagInfoSend.ItemUse(_local2.ItemGUID);
                        };
                    };
                };
            };
        }
        public function refresh():void{
            var _local1:String;
            var _local2:MovieClip;
            var _local3:*;
            var _local4:MovieClip;
            var _local5:Boolean;
            var _local6:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local7:Dictionary = QuickBarData.getInstance().expandKeyDic;
            for (_local1 in _local6) {
                if (_local6[_local1] != null){
                    _local2 = mainScene.mcQuickBar0[("quick_" + _local1)];
                    _local3 = _local6[_local1];
                    _local5 = isExistItem(_local3);
                    if (_local5){
                        if (_local3.parent != _local2){
                            _local3.name = ("key_" + _local1);
                            _local3.addEventListener(MouseEvent.CLICK, onUseItemClick);
                            _local3.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                            _local3.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                            _local3.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                            _local2.addChild(_local3);
                            if ((_local3 is UseItem)){
                                _local3.canUse(true);
                                _local3.mouseEnabled = true;
                            };
                        };
                    } else {
                        if ((_local3 is SkillUseItem)){
                            if (_local3.parent == _local2){
                                _local2.removeChild(_local3);
                            };
                            disposeItem(_local3);
                            _local6[_local1] = null;
                        } else {
                            _local3.canUse(false);
                            _local3.name = ("key_" + _local1);
                            _local3.addEventListener(MouseEvent.CLICK, onUseItemClick);
                            _local3.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                            _local3.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                            _local3.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                            _local2.addChild(_local3);
                            _local3.mouseEnabled = true;
                        };
                    };
                };
            };
            for (_local1 in _local7) {
                if (_local7[_local1] != null){
                    _local4 = mainScene.mcQuickBar1[("quickf_" + _local1)];
                    _local3 = _local7[_local1];
                    _local5 = isExistItem(_local3);
                    if (_local5){
                        if (_local3.parent != _local4){
                            _local3.name = ("keyF_" + _local1);
                            _local3.addEventListener(MouseEvent.CLICK, onUseItemClick);
                            _local3.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                            _local3.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                            _local3.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                            _local4.addChild(_local3);
                            if ((_local3 is UseItem)){
                                _local3.canUse(true);
                                _local3.mouseEnabled = true;
                            };
                        };
                    } else {
                        if ((_local3 is SkillUseItem)){
                            if (_local3.parent == _local4){
                                _local4.removeChild(_local3);
                            };
                            disposeItem(_local3);
                            _local7[_local1] = null;
                        } else {
                            _local3.name = ("keyF_" + _local1);
                            _local3.addEventListener(MouseEvent.CLICK, onUseItemClick);
                            _local3.addEventListener(DropEvent.DRAG_THREW, onDrawThrewHandler);
                            _local3.addEventListener(DropEvent.DRAG_DROPPED, onDragedHandler);
                            _local4.addChild(_local3);
                            _local3.canUse(false);
                            _local3.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDowmHandler);
                            _local3.mouseEnabled = true;
                        };
                    };
                };
            };
            onSyncBag();
        }
        protected function onDrawThrewHandler(_arg1:DropEvent):void{
            var _local2:* = _arg1.Data;
            if (_local2.IsCdTimer){
                GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("道具正在冷确中，不能丢弃"),
                    color:0xFFFF00
                });
                return;
            };
            _local2.parent.removeChild(_local2);
            var _local3:Array = _local2.name.split("_");
            if (_local3[0] == "key"){
                QuickBarData.getInstance().quickKeyDic[_local3[1]] = null;
                PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, _local3[1]);
            } else {
                if (_local3[0] == "keyF"){
                    QuickBarData.getInstance().expandKeyDic[_local3[1]] = null;
                    PlayerActionSend.SendQuickOperate(PlayerActionSend.REMOVE_QUICKITEM, (int(_local3[1]) + 8));
                };
            };
            disposeItem(_local2);
        }
        private function isInQuick(_arg1:String, _arg2:int, _arg3:int, _arg4:uint=0):Boolean{
            var _local5:SkillUseItem;
            var _local6:UseItem;
            var _local9:Dictionary;
            var _local7:Dictionary = QuickBarData.getInstance().quickKeyDic;
            var _local8:Dictionary = QuickBarData.getInstance().expandKeyDic;
            if ((((_arg1 == "quick")) || ((_arg1 == "key")))){
                _local9 = _local7;
            } else {
                _local9 = _local8;
            };
            if ((_local9[_arg2] is SkillUseItem)){
                _local5 = _local9[_arg2];
                if (((!((_local5 == null))) && ((_local5.skillInfo.TypeID == _arg3)))){
                    return (true);
                };
            } else {
                if ((_local9[_arg2] is UseItem)){
                    _local6 = _local9[_arg2];
                    if (((((!((_local6 == null))) && ((_local6.Type == _arg3)))) && ((_local6.IsBind == _arg4)))){
                        return (true);
                    };
                };
            };
            return (false);
        }

    }
}//package GameUI.Modules.MainScene.Proxy 
