//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Activity.Command.*;

    public class TopUpTotalView extends Sprite {

        private var view:Sprite;
        public var acculefttime:TextField;
        private var chargeContainer:Sprite;
        private var chargeBtnsArray:Array;
        private var goldBarView:GoldBarView;

        public function TopUpTotalView(){
            init();
        }
        private function checkAllGet():Boolean{
            var _local1:GiftBagItem;
            for each (_local1 in chargeBtnsArray) {
                if (_local1.getBtn.label != LanguageMgr.GetTranslation("已领取")){
                    return (false);
                };
            };
            return (true);
        }
        private function initBagAward(_arg1:int):void{
            var _local5:Sprite;
            var _local6:FaceItem;
            if (GameCommonData.accuChargeId == 0){
                return;
            };
            ActivityConstants.chagerArray = ActivityConstants.chagerArraylist[GameCommonData.accuChargeId];
            ActivityConstants.itemIdArr = ActivityConstants.itemIdArrlist[GameCommonData.accuChargeId];
            var _local2:Array = ActivityConstants.chagerArraylist;
            while (chargeContainer.numChildren > 0) {
                chargeContainer.removeChildAt(0);
            };
            var _local3:Array = ActivityConstants.chagerArray[_arg1];
            var _local4:int;
            while (_local4 < _local3.length) {
                _local5 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local6 = new FaceItem(_local3[_local4], _local5, "bagIcon", 1, 1);
                _local6.setNum(_local3[(_local4 + 1)]);
                _local6.mouseChildren = false;
                _local6.mouseEnabled = false;
                _local5.x = (_local4 * 21);
                _local5.addChild(_local6);
                chargeContainer.addChild(_local5);
                _local5.name = ("target_" + _local3[_local4]);
                _local4 = (_local4 + 2);
            };
        }
        private function setGiftList():void{
            var _local1:int;
            var _local3:GiftBagItem;
            var _local4:int;
            var _local5:int;
            var _local2:int = ActivityConstants.ChargeGoldList.length;
            var _local6:int;
            var _local7:int = GameCommonData.AccuChargeEnable;
            if (GameCommonData.accuChargeId > 0){
                _local6 = ActivityConstants.chagerArraylist[GameCommonData.accuChargeId].length;
                ActivityConstants.chagerArray = ActivityConstants.chagerArraylist[GameCommonData.accuChargeId];
                ActivityConstants.itemIdArr = ActivityConstants.itemIdArrlist[GameCommonData.accuChargeId];
            };
            chargeBtnsArray = [];
            while (_local1 < _local2) {
                _local3 = new GiftBagItem(_local1);
                this.addChild(_local3);
                _local3.x = (_local4 * (_local3.width + 3));
                _local3.y = ((_local5 * (_local3.height + 3)) + 68);
                if (_local1 >= _local6){
                    _local3.closeService();
                } else {
                    _local3.addEventListener(MouseEvent.CLICK, onBagAward);
                    _local3.openService();
                    chargeBtnsArray.push(_local3);
                };
                _local4++;
                _local1++;
                if (_local4 == 5){
                    _local4 = 0;
                    _local5++;
                };
            };
        }
        private function onBagAward(_arg1:MouseEvent):void{
            initBagAward((_arg1.currentTarget as GiftBagItem).index);
        }
        public function updateGoldView():void{
            goldBarView.setText();
        }
        private function init():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TopUpTotalViewAsset");
            this.addChild(view);
            acculefttime = view["acculefttime"];
            goldBarView = new GoldBarView();
            goldBarView.x = -3;
            goldBarView.y = -5;
            this.addChild(goldBarView);
            chargeContainer = new Sprite();
            this.addChild(chargeContainer);
            chargeContainer.x = 7;
            chargeContainer.y = 330;
            setGiftList();
        }
        public function EnableChargeBtns():void{
            var _local2:int;
            var _local4:GiftBagItem;
            var _local1:int = GameCommonData.AccuChargeEnable;
            var _local3:int = chargeBtnsArray.length;
            while (_local2 < _local3) {
                _local4 = chargeBtnsArray[_local2];
                switch ((_local1 & 3)){
                    case 0:
                        _local4.getBtn.enable = false;
                        break;
                    case 1:
                        _local4.getBtn.enable = true;
                        break;
                    case 3:
                        _local4.getBtn.enable = false;
                        _local4.getBtn.label = LanguageMgr.GetTranslation("已领取");
                        _local4.getBtn.x = 20;
                        break;
                };
                _local1 = (_local1 >> 2);
                _local2++;
            };
            if (checkAllGet()){
                UIFacade.GetInstance().sendNotification(EventList.CLOSE_CHARGE_CHEST);
            };
        }

    }
}//package GameUI.Modules.Activity.UI 
