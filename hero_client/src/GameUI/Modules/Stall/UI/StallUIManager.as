//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Stall.UI {
    import flash.display.*;
    import GameUI.View.*;
    import GameUI.Modules.Stall.Data.*;

    public class StallUIManager {

        private var stall:MovieClip;

        public function StallUIManager(_arg1:MovieClip){
            this.stall = _arg1;
            initView();
        }
        public function countMoney(_arg1:uint, _arg2:uint):Array{
            var _local3:Array = new Array(3);
            var _local4:uint = ((_arg1 % 100) * _arg2);
            _local3[2] = (_local4 % 100);
            var _local5:uint = uint((_local4 - _local3[2]));
            _local4 = (((uint(((_arg1 % 10000) / 100)) * 100) * _arg2) + _local5);
            _local3[1] = uint(((_local4 % 10000) / 100));
            _local5 = (_local4 - (_local3[1] * 100));
            _local4 = ((uint((_arg1 / 10000)) * _arg2) + (_local5 / 10000));
            _local3[0] = uint(_local4);
            return (_local3);
        }
        public function lockBtns():void{
        }
        public function refreshMoney(_arg1:Array, _arg2:uint, _arg3:int=-1):Array{
            var _local5:Array;
            var _local4:int;
            if (StallConstData.SelectIndex == 0){
                if ((((((_arg2 == 0)) && (StallConstData.SelectedItem))) && (StallConstData.SelectedItem.Item))){
                    _local4 = StallConstData.SelectedItem.Item.Pos;
                    if (_arg3 == -1){
                        _arg3 = _arg1[_local4].Count;
                    };
                    _local5 = countMoney(_arg1[_local4].price, _arg3);
                } else {
                    if ((((((_arg2 == 2)) && (StallConstData.SelectedDownItem))) && (StallConstData.SelectedDownItem.Item))){
                        _local4 = StallConstData.SelectedDownItem.Item.Pos;
                        if (_arg3 == -1){
                            _arg3 = _arg1[_local4].Count;
                        };
                        _local5 = countMoney(_arg1[_local4].price, _arg3);
                    } else {
                        if (stall.content1.visible){
                            _local5 = countMoneyAll(_arg1);
                        } else {
                            _local5 = [0, 0, 0];
                        };
                    };
                };
                if (_arg2 == 0){
                    StallConstData.moneyAll[0] = _local5[0];
                    StallConstData.moneyAll[1] = _local5[1];
                    StallConstData.moneyAll[2] = _local5[2];
                    showMoney(0);
                } else {
                    StallConstData.moneyDownAll[0] = _local5[0];
                    StallConstData.moneyDownAll[1] = _local5[1];
                    StallConstData.moneyDownAll[2] = _local5[2];
                    showMoney(2);
                };
            };
            return (_local5);
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
        public function showMoney(_arg1:uint):void{
            if (_arg1 == 0){
                if (stall.content1.visible){
                    stall.content1.txtMoney1.text = uint(StallConstData.moneyAll[0]);
                    stall.content1.txtMoney2.text = uint(StallConstData.moneyAll[1]);
                    stall.content1.txtMoney3.text = uint(StallConstData.moneyAll[2]);
                } else {
                    stall.content13.txtMoney1.text = uint(StallConstData.moneyAll[0]);
                    stall.content13.txtMoney2.text = uint(StallConstData.moneyAll[1]);
                    stall.content13.txtMoney3.text = uint(StallConstData.moneyAll[2]);
                };
            } else {
                if (_arg1 == 2){
                    if (stall.content2.visible){
                        stall.content2.txtMoney1.text = uint(StallConstData.moneyDownAll[0]);
                        stall.content2.txtMoney2.text = uint(StallConstData.moneyDownAll[1]);
                        stall.content2.txtMoney3.text = uint(StallConstData.moneyDownAll[2]);
                    } else {
                        stall.content23.txtMoney1.text = uint(StallConstData.moneyDownAll[0]);
                        stall.content23.txtMoney2.text = uint(StallConstData.moneyDownAll[1]);
                        stall.content23.txtMoney3.text = uint(StallConstData.moneyDownAll[2]);
                    };
                } else {
                    if (_arg1 == 3){
                        stall.content12.txtMoney1.text = uint(StallConstData.moneyGet[0]);
                        stall.content12.txtMoney2.text = uint(StallConstData.moneyGet[1]);
                        stall.content12.txtMoney3.text = uint(StallConstData.moneyGet[2]);
                    } else {
                        if (_arg1 == 4){
                            stall.content22.txtMoney1.text = uint(StallConstData.moneyPay[0]);
                            stall.content22.txtMoney2.text = uint(StallConstData.moneyPay[1]);
                            stall.content22.txtMoney3.text = uint(StallConstData.moneyPay[2]);
                        };
                    };
                };
            };
        }
        private function initView():void{
            stall.txtOwerName.mouseEnabled = false;
            stall.txtOwerName.text = "";
            stall.txtStallName.text = "";
        }
        public function unLockBtns():void{
            stall._btnStartStall.mouseEnabled = true;
            stall._btnCloseStall.mouseEnabled = true;
            stall._btnClearStall.mouseEnabled = true;
        }
        public function setModel(_arg1:uint):void{
            if (_arg1 == 0){
                stall.btnPrivate.visible = false;
                stall.content1.visible = true;
                stall.content2.visible = true;
                stall.content12.visible = false;
                stall.content22.visible = false;
                stall.content13.visible = false;
                stall.content23.visible = false;
                stall.txtStallName.mouseEnabled = true;
                stall._btnCloseStall.visible = false;
                stall._btnStartStall.visible = true;
                stall._btnClearStall.visible = true;
                stall.stallnamebg.y = 14;
                stall.stallownerbg.visible = false;
                stall.txtOwerName.visible = false;
                stall.txtStallName.y = 13;
            } else {
                if (_arg1 == 1){
                    stall.btnPrivate.visible = false;
                    stall.content1.visible = false;
                    stall.content2.visible = false;
                    stall.content12.visible = true;
                    stall.content22.visible = true;
                    stall.content13.visible = false;
                    stall.content23.visible = false;
                    stall.txtStallName.mouseEnabled = false;
                    stall._btnCloseStall.visible = true;
                    stall._btnStartStall.visible = false;
                    stall._btnClearStall.visible = true;
                    stall.stallnamebg.y = 14;
                    stall.stallownerbg.visible = false;
                    stall.txtOwerName.visible = false;
                    stall.txtStallName.y = 13;
                } else {
                    if (_arg1 == 2){
                        stall.btnPrivate.visible = true;
                        stall.content1.visible = false;
                        stall.content2.visible = false;
                        stall.content12.visible = false;
                        stall.content22.visible = false;
                        stall.content13.visible = true;
                        stall.content23.visible = true;
                        stall.txtStallName.mouseEnabled = false;
                        stall._btnCloseStall.visible = false;
                        stall._btnStartStall.visible = false;
                        stall._btnClearStall.visible = false;
                        stall.stallnamebg.y = -2;
                        stall.stallownerbg.y = 24.4;
                        stall.stallownerbg.visible = true;
                        stall.txtOwerName.visible = true;
                        stall.txtStallName.y = -3;
                    };
                };
            };
        }
        private function countMoneyAll(_arg1:Array):Array{
            var _local3:Array;
            var _local2:Object;
            var _local4:Array = [0, 0, 0];
            var _local5:Array = new Array(3);
            var _local6:int;
            while (_local6 < _arg1.length) {
                if (((_arg1[_local6]) && (_arg1[_local6].type))){
                    _local3 = countMoney(_arg1[_local6].price, _arg1[_local6].Count);
                    _local4[2] = (_local4[2] + _local3[2]);
                    if (_local4[2] >= 100){
                        _local4[1] = (_local4[1] + 1);
                        _local4[2] = (_local4[2] - 100);
                    };
                    _local4[1] = (_local4[1] + _local3[1]);
                    if (_local4[1] >= 100){
                        _local4[0] = (_local4[0] + 1);
                        _local4[1] = (_local4[1] - 100);
                    };
                    _local4[0] = (_local4[0] + _local3[0]);
                };
                _local6++;
            };
            _local5[0] = _local4[0];
            _local5[1] = _local4[1];
            _local5[2] = _local4[2];
            return (_local5);
        }

    }
}//package GameUI.Modules.Stall.UI 
