//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import GameUI.Modules.Activity.Command.*;

    public class GoldBarView extends Sprite {

        private var rechargeBtn:HLabelButton;
        private var view:Sprite;
        private var getBtn:HLabelButton;

        public function GoldBarView(){
            init();
            initEvent();
        }
        private function init():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GoldBarViewAsset");
            this.addChild(view);
            getBtn = new HLabelButton();
            getBtn.label = LanguageMgr.GetTranslation("提取");
            getBtn.x = 25;
            getBtn.y = 43;
            this.addChild(getBtn);
            rechargeBtn = new HLabelButton();
            rechargeBtn.label = LanguageMgr.GetTranslation("充值");
            rechargeBtn.x = 485;
            rechargeBtn.y = 15;
            this.addChild(rechargeBtn);
            setText();
        }
        private function onGetHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(EventList.SHOW_GET_MONEY_VIEW);
        }
        private function initEvent():void{
            getBtn.addEventListener(MouseEvent.CLICK, onGetHandler);
            rechargeBtn.addEventListener(MouseEvent.CLICK, onRechargeHandler);
        }
        private function onRechargeHandler(_arg1:MouseEvent):void{
            if (GameConfigData.GamePay != ""){
                navigateToURL(new URLRequest(GameConfigData.GamePay), "_blank");
            };
        }
        public function setText():void{
            var _local2:int;
            var _local5:int;
            var _local7:String;
            if (GameCommonData.accuChargeId == 0){
                return;
            };
            var _local1:int = (GameCommonData.ReChargeCount / 100);
            var _local3:int;
            var _local4:int = ActivityConstants.ChargeGoldList.length;
            while (_local3 < _local4) {
                if (int(ActivityConstants.ChargeGoldList[_local3]) > _local1){
                    _local2 = ActivityConstants.ChargeGoldList[_local3];
                    break;
                };
                _local3++;
            };
            if (_local1 >= int(ActivityConstants.ChargeGoldList[(ActivityConstants.chagerArraylist[GameCommonData.accuChargeId].length - 1)])){
                _local2 = int(ActivityConstants.ChargeGoldList[(ActivityConstants.chagerArraylist[GameCommonData.accuChargeId].length - 1)]);
            };
            var _local6:int = (_local2 - _local1);
            view["precentageTxt"].text = ((_local1 + "/") + _local2);
            if (_local6 >= 0){
                view["canGetRewardTxt"].htmlText = LanguageMgr.GetTranslation("本次活动已领x金叶子", _local1);
                view["bar"].width = ((_local1 / _local2) * 374);
                _local7 = LanguageMgr.GetTranslation("某条件下再拿金叶子提示句", _local6, _local2);
                view["canGetGoldTxt"].htmlText = _local7;
            } else {
                view["bar"].width = 374;
                view["canGetRewardTxt"].htmlText = LanguageMgr.GetTranslation("你当前可领取所有礼包");
                view["canGetGoldTxt"].htmlText = LanguageMgr.GetTranslation("感谢完成所有礼包");
            };
        }

    }
}//package GameUI.Modules.Activity.UI 
