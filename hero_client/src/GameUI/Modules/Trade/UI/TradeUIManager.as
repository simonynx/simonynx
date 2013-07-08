//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Trade.UI {
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Trade.Data.*;
    import GameUI.Modules.Bag.Proxy.*;

    public class TradeUIManager {

        private var tradePanel:MovieClip = null;
        private var moneyPanel:MovieClip = null;
        private var tradeDataProxy:TradeDataProxy = null;

        public function TradeUIManager(_arg1:MovieClip, _arg2:MovieClip, _arg3:TradeDataProxy):void{
            this.tradePanel = _arg1;
            this.moneyPanel = _arg2;
            this.tradeDataProxy = _arg3;
            init();
        }
        public function showItems(_arg1:Array):void{
            var _local2:UseItem;
            var _local3:uint;
            var _local4:int;
            while (_local4 < _arg1.length) {
                if (_arg1[_local4] == undefined){
                } else {
                    _local2 = new UseItem(_local4, _arg1[_local4].type, tradePanel[("mcPhoto_" + _local4)]);
                    _local2.Num = _arg1[_local4].Count;
                    _local2.x = 2;
                    _local2.y = 2;
                    _local2.Id = _arg1[_local4].id;
                    _local2.IsBind = _arg1[_local4].isBind;
                    _local2.Type = _arg1[_local4].type;
                    TradeConstData.GridUnitList[_local4].Item = _local2;
                    TradeConstData.GridUnitList[_local4].IsUsed = true;
                    TradeConstData.GridUnitList[_local4].Grid.addChild(_local2);
                };
                _local4++;
            };
        }
        public function showMoney(_arg1:uint):void{
            var _local2:Array;
            var _local3:String;
            var _local4:Array;
            var _local5:String;
            if (_arg1 == 0){
                tradePanel.txtMoney_op1.text = String(int((tradeDataProxy.moneyOp / 10000)));
                tradePanel.txtMoney_op2.text = String(int(((tradeDataProxy.moneyOp % 10000) / 100)));
                tradePanel.txtMoney_op3.text = String((tradeDataProxy.moneyOp % 100));
            } else {
                tradePanel.txtMoney_self1.text = String(int((tradeDataProxy.moneySelf / 10000)));
                tradePanel.txtMoney_self2.text = String(int(((tradeDataProxy.moneySelf % 10000) / 100)));
                tradePanel.txtMoney_self3.text = String((tradeDataProxy.moneySelf % 100));
            };
        }
        public function showItemsOp(_arg1:Array):void{
            var _local2:UseItem;
            var _local3:uint;
            var _local4:int;
            while (_local4 < _arg1.length) {
                if (_arg1[_local4] == undefined){
                } else {
                    _local2 = new UseItem(_local4, _arg1[_local4].type, tradePanel[("mcOpPhoto_" + _local4)]);
                    _local2.Num = _arg1[_local4].Count;
                    _local2.x = 2;
                    _local2.y = 2;
                    _local2.Id = _arg1[_local4].id;
                    _local2.IsBind = _arg1[_local4].isBind;
                    _local2.Type = _arg1[_local4].type;
                    TradeConstData.GridUnitListOp[_local4].Item = _local2;
                    TradeConstData.GridUnitListOp[_local4].IsUsed = true;
                    TradeConstData.GridUnitListOp[_local4].Grid.addChild(_local2);
                };
                _local4++;
            };
        }
        private function init():void{
            tradePanel.txtRoleName_op.text = "";
            tradePanel.txtRoleName_self.text = GameCommonData.Player.Role.Name;
            tradePanel.txtState_op.visible = false;
            tradePanel.txtState_self.visible = false;
            tradePanel.txtState_op.text = LanguageMgr.GetTranslation("尚未锁定");
            tradePanel.txtState_self.text = LanguageMgr.GetTranslation("尚未锁定");
            tradePanel.txtRoleName_op.mouseEnabled = false;
            tradePanel.txtState_op.mouseEnabled = false;
            tradePanel.txtState_self.mouseEnabled = false;
            var _local1:int;
            while (_local1 < 6) {
                tradePanel[("mcGood_op_" + _local1)].txtGoodName.text = "";
                tradePanel[(("mcGood_" + _local1) + "_self")].txtGoodName.text = "";
                tradePanel[("mcGood_op_" + _local1)].mouseEnabled = false;
                tradePanel[(("mcGood_" + _local1) + "_self")].mouseEnabled = false;
                _local1++;
            };
            moneyPanel.txtJin.restrict = "0-9";
            moneyPanel.txtYin.restrict = "0-9";
            moneyPanel.txtTong.restrict = "0-9";
            tradePanel.mcGreenRect.visible = false;
            tradePanel.mcGreenRect.mouseEnabled = false;
            tradePanel.mcGreenRectOp.visible = false;
            tradePanel.mcGreenRectOp.mouseEnabled = false;
        }
        public function removeAllItemOp():void{
            var _local1:int;
            var _local2:int;
            var _local3:ItemBase;
            while (_local1 < 6) {
                _local2 = (tradePanel[("mcOpPhoto_" + _local1)].numChildren - 1);
                while (_local2) {
                    if ((tradePanel[("mcOpPhoto_" + _local1)].getChildAt(_local2) is ItemBase)){
                        _local3 = (tradePanel[("mcOpPhoto_" + _local1)].getChildAt(_local2) as ItemBase);
                        tradePanel[("mcOpPhoto_" + _local1)].removeChild(_local3);
                        _local3 = null;
                    };
                    _local2--;
                };
                _local1++;
            };
            var _local4:int;
            while (_local4 < 6) {
                TradeConstData.GridUnitListOp[_local4].Item = null;
                TradeConstData.GridUnitListOp[_local4].IsUsed = false;
                _local4++;
            };
        }
        public function addItem(_arg1:int, _arg2:Object):void{
            var _local12:uint;
            var _local13:uint;
            var _local14:uint;
            var _local15:uint;
            var _local16:uint;
            var _local17:int;
            var _local18:ItemBase;
            var _local3:int;
            var _local4:int;
            var _local5:MovieClip;
            var _local6:UseItem;
            var _local7:int;
            var _local8:int;
            var _local9:MovieClip;
            var _local10:UseItem;
            var _local11:* = _arg2.data;
            if (_arg2.place < 10000){
                _local3 = _arg2.place;
            } else {
                _local3 = (_arg2.place - 10000);
            };
            if (_arg1 == 0){
                if (_local3 > -1){
                    TradeConstData.goodOpList[_local3] = _local11;
                    if (_local11){
                        _local5 = tradePanel[("mcOpPhoto_" + _local3)];
                        _local6 = new UseItem(_local3, _local11.type, _local5);
                        _local5.addChild(_local6);
                        _local6.Id = _local11.id;
                        _local6.Num = _local11.Count;
                        _local6.x = 2;
                        _local6.y = 2;
                        TradeConstData.GridUnitListOp[_local3].Item = _local6;
                        tradePanel[("mcGood_op_" + _local3)].txtGoodName.text = UIConstData.ItemDic[_local11.type].Name;
                        (TradeConstData.GridUnitListOp[_local3] as GridUnit).Grid.mouseEnabled = true;
                    } else {
                        _local15 = (_arg2.place - 10000);
                        _local16 = (tradePanel[("mcOpPhoto_" + _local15)].numChildren - 1);
                        _local17 = _local16;
                        while (_local17 >= 0) {
                            if ((tradePanel[("mcOpPhoto_" + _local15)].getChildAt(_local17) is ItemBase)){
                                _local18 = (tradePanel[("mcOpPhoto_" + _local15)].getChildAt(_local17) as ItemBase);
                                tradePanel[("mcOpPhoto_" + _local15)].removeChild(_local18);
                                _local18 = null;
                            };
                            _local17--;
                        };
                        tradePanel[("mcGood_op_" + _local15)].txtGoodName.text = "";
                    };
                };
                if (tradeDataProxy.sfLocked){
                    UIFacade.GetInstance().sendNotification(EventList.TRADEUNLOCK);
                };
            } else {
                if (_local3 > -1){
                    if (_local11){
                        if (TradeConstData.goodSelfList[_local3]){
                            _local12 = TradeConstData.goodSelfList[_local3].Place;
                            _local13 = ItemConst.placeToPanel(_local12);
                            _local14 = ItemConst.placeToOffset(_local12);
                            if (BagData.SelectIndex == _local13){
                                BagData.GridUnitList[BagData.SelectIndex][_local14].Item.IsLock = false;
                            };
                            BagData.AllLocks[_local13][_local14] = false;
                        };
                        TradeConstData.idItemSelfArr[_local3] = _local11.Place;
                        TradeConstData.goodSelfList[_local3] = _local11;
                        _local9 = tradePanel[("mcPhoto_" + _local3)];
                        _local10 = new UseItem(_local3, _local11.type, _local9);
                        _local9.addChild(_local10);
                        _local10.Id = _local11.ItemGUID;
                        _local10.Num = _local11.Count;
                        _local10.x = 2;
                        _local10.y = 2;
                        TradeConstData.GridUnitList[_local3].Item = _local10;
                        tradePanel[(("mcGood_" + _local3) + "_self")].txtGoodName.text = UIConstData.ItemDic[_local11.type].Name;
                        (TradeConstData.GridUnitList[_local3] as GridUnit).Grid.mouseEnabled = true;
                    } else {
                        _local12 = TradeConstData.goodSelfList[_local3].Place;
                        _local13 = ItemConst.placeToPanel(_local12);
                        _local14 = ItemConst.placeToOffset(_local12);
                        if (BagData.SelectIndex == _local13){
                            BagData.GridUnitList[BagData.SelectIndex][(_local14 % BagData.MAX_GRIDS)].Item.IsLock = false;
                        };
                        BagData.AllLocks[_local13][_local14] = false;
                        TradeConstData.goodSelfList[_local3] = null;
                        _local15 = (_arg2.place - 10000);
                        _local16 = (tradePanel[("mcPhoto_" + _local15)].numChildren - 1);
                        _local17 = _local16;
                        while (_local17 >= 0) {
                            if ((tradePanel[("mcPhoto_" + _local15)].getChildAt(_local17) is ItemBase)){
                                _local18 = (tradePanel[("mcPhoto_" + _local15)].getChildAt(_local17) as ItemBase);
                                tradePanel[("mcPhoto_" + _local15)].removeChild(_local18);
                                _local18 = null;
                            };
                            _local17--;
                        };
                        tradePanel[(("mcGood_" + _local3) + "_self")].txtGoodName.text = "";
                    };
                };
                tradeDataProxy.removeAllFrames();
                if (tradeDataProxy.opLocked){
                    UIFacade.GetInstance().sendNotification(EventList.TRADEUNLOCK_OP);
                };
            };
        }
        public function removeAllItem():void{
            var _local1:int;
            var _local2:int;
            var _local3:ItemBase;
            while (_local1 < 6) {
                _local2 = (tradePanel[("mcPhoto_" + _local1)].numChildren - 1);
                while (_local2) {
                    if ((tradePanel[("mcPhoto_" + _local1)].getChildAt(_local2) is ItemBase)){
                        _local3 = (tradePanel[("mcPhoto_" + _local1)].getChildAt(_local2) as ItemBase);
                        tradePanel[("mcPhoto_" + _local1)].removeChild(_local3);
                        _local3 = null;
                    };
                    _local2--;
                };
                _local1++;
            };
            var _local4:int;
            while (_local4 < 6) {
                TradeConstData.GridUnitList[_local4].Item = null;
                TradeConstData.GridUnitList[_local4].IsUsed = false;
                _local4++;
            };
        }
        public function getMoney(_arg1:uint):Array{
            var _local2:Array = [];
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            _local3 = (_arg1 / 10000);
            _local4 = ((_arg1 - (_local3 * 10000)) / 100);
            _local5 = (_arg1 % 100);
            _local2.push(_local3);
            _local2.push(_local4);
            _local2.push(_local5);
            return (_local2);
        }
        public function initPanel():void{
            tradePanel.txtState_op.text = LanguageMgr.GetTranslation("尚未锁定");
            tradePanel.txtState_self.text = LanguageMgr.GetTranslation("尚未锁定");
            var _local1:int;
            while (_local1 < 6) {
                tradePanel[("mcGood_op_" + _local1)].txtGoodName.text = "";
                tradePanel[(("mcGood_" + _local1) + "_self")].txtGoodName.text = "";
                _local1++;
            };
            tradePanel.txtMoney_op1.text = "0";
            tradePanel.txtMoney_op2.text = "0";
            tradePanel.txtMoney_op3.text = "0";
            tradePanel.txtMoney_self1.text = "0";
            tradePanel.txtMoney_self2.text = "0";
            tradePanel.txtMoney_self3.text = "0";
            tradePanel.txtMoney_op1.mouseEnabled = false;
            tradePanel.txtMoney_op2.mouseEnabled = false;
            tradePanel.txtMoney_op3.mouseEnabled = false;
            tradePanel.txtMoney_self1.mouseEnabled = false;
            tradePanel.txtMoney_self2.mouseEnabled = false;
            tradePanel.txtMoney_self3.mouseEnabled = false;
            tradePanel.mcGreenRect.visible = false;
            tradePanel.mcGreenRectOp.visible = false;
        }
        public function delItem(_arg1:int, _arg2:Object):void{
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            if (_arg1 == 0){
                _local3 = 0;
                while (_local3 < TradeConstData.goodOpList.length) {
                    if (((TradeConstData.goodOpList[_local3]) && ((TradeConstData.goodOpList[_local3].id == _arg2.id)))){
                        TradeConstData.goodOpList.splice(_local3, 1);
                        TradeConstData.goodOpList[4] = null;
                        break;
                    };
                    _local3++;
                };
                _local4 = 0;
                while (_local4 < 6) {
                    tradePanel[("mcGood_op_" + _local4)].txtGoodName.text = "";
                    _local4++;
                };
                while (_local5 < TradeConstData.goodOpList.length) {
                    if (TradeConstData.goodOpList[_local5]){
                        tradePanel[("mcGood_op_" + _local5)].txtGoodName.text = UIConstData.ItemDic[TradeConstData.goodOpList[_local5].type].Name;
                    };
                    _local5++;
                };
                removeAllItemOp();
                showItemsOp(TradeConstData.goodOpList);
            } else {
                _local6 = 0;
                while (_local6 < TradeConstData.goodSelfList.length) {
                    if (((TradeConstData.goodSelfList[_local6]) && ((TradeConstData.goodSelfList[_local6].id == _arg2.id)))){
                        TradeConstData.goodSelfList.splice(_local6, 1);
                        TradeConstData.goodSelfList[4] = undefined;
                        break;
                    };
                    _local6++;
                };
                _local7 = 0;
                while (_local7 < 6) {
                    tradePanel[(("mcGood_" + _local7) + "_self")].txtGoodName.text = "";
                    _local7++;
                };
                while (_local8 < TradeConstData.goodSelfList.length) {
                    if (TradeConstData.goodSelfList[_local8]){
                        tradePanel[(("mcGood_" + _local8) + "_self")].txtGoodName.text = UIConstData.ItemDic[TradeConstData.goodSelfList[_local8].type].Name;
                    };
                    _local8++;
                };
                removeAllItem();
                tradeDataProxy.removeAllFrames();
                showItems(TradeConstData.goodSelfList);
            };
        }

    }
}//package GameUI.Modules.Trade.UI 
