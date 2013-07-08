//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Maket.UI {
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Maket.Data.*;

    public class MarketSalesView extends Sprite {

        private var cells:Array;

        public function MarketSalesView(){
            initView();
            addEvents();
        }
        public function updateData():void{
            var _local1:int;
            var _local2:ShopItemInfo;
            var _local3:UseItem;
            var _local4:MovieClip;
            var _local5:MarketSalesViewCell;
            while (((cells) && ((_local1 < cells.length)))) {
                if (cells[_local1]){
                    cells[_local1].dispose();
                };
                cells[_local1] = null;
                _local1++;
            };
            cells = [];
            _local1 = 0;
            while (((((UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX]) && ((_local1 < UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX].length)))) && ((_local1 < 2)))) {
                _local2 = UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX][_local1];
                if (_local2){
                    _local5 = new MarketSalesViewCell(_local1, _local2);
                    _local5.updateData();
                    _local5.x = 0;
                    _local5.y = (_local1 * (_local5.height + 3));
                    addChild(_local5);
                    cells.push(_local5);
                };
                _local1++;
            };
            if (((MarketConstData.SelfDayLimitCntBuyShopItemObj) && (MarketConstData.SelfDayLimitCntBuyShopItemObj.info))){
                _local5 = new MarketSalesViewCell(_local1, MarketConstData.SelfDayLimitCntBuyShopItemObj.info);
                _local5.updateData();
                _local5.x = 0;
                _local5.y = (_local1 * (_local5.height + 3));
                addChild(_local5);
                cells.push(_local5);
            };
        }
        private function initView():void{
            cells = [];
        }
        public function updateTime():void{
            var _local2:int;
            var _local1 = -1;
            while (_local2 < cells.length) {
                if (cells[_local2]){
                    cells[_local2].updateTime();
                    if (cells[_local2].outTime){
                        _local1 = _local2;
                    };
                };
                _local2++;
            };
            if (_local1 >= 0){
                UIConstData.MarketGoodList[MarketConstData.SALES_LISTIDX].splice(_local1, 1);
                UIFacade.GetInstance().sendNotification(MarketEvent.UPDATE_MARKETSALES);
                UIFacade.GetInstance().sendNotification(MarketEvent.ADDTO_SHOPCAR_MARKET);
            };
        }
        private function addEvents():void{
        }
        public function dispose():void{
            var _local1:int;
            if (parent){
                this.parent.removeChild(this);
            };
            while (_local1 < cells.length) {
                if (cells[_local1]){
                    cells[_local1].dispose();
                };
                cells[_local1] = null;
                _local1++;
            };
        }

    }
}//package GameUI.Modules.Maket.UI 
