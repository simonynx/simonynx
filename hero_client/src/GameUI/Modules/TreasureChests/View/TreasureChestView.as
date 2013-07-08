//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.TreasureChests.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsFramework.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import OopsFramework.Utils.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;
    import Net.RequestSend.*;

    public class TreasureChestView extends Sprite implements IUpdateable {

        public static var AwardMsg:String = "";

        private var timeCount:int;
        private var bg:HConfirmFrame;
        private var timer:OopsFramework.Utils.Timer;
        private var timeEnd:int;
        private var itemPos1:Array;
        private var itemPos3:Array;
        private var itemPos4:Array;
        private var itemPos5:Array;
        private var itemArr:Array;
        private var itemPos2:Array;
        private var okBtn:HLabelButton;
        private var view:MovieClip;

        public function TreasureChestView(){
            itemPos5 = [[13, 65], [70, 65], [127, 65], [183, 65], [236, 65]];
            itemPos4 = [[33, 65], [90, 65], [147, 65], [203, 65]];
            itemPos3 = [[70, 65], [127, 65], [183, 65]];
            itemPos2 = [[70, 65], [182, 65]];
            itemPos1 = [[123, 65]];
            super();
            init();
        }
        public function hide():void{
            var _local1:DataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
            _local1.TreasureViewIsOpen = false;
            bg.close();
            removeEvent();
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        private function init():void{
            bg = new HConfirmFrame();
            bg.titleText = LanguageMgr.GetTranslation("领取在线奖励");
            bg.blackGound = false;
            bg.showClose = true;
            bg.centerTitle = true;
            bg.showCancel = false;
            bg.setSize(278, 223);
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TreasureView");
            bg.addContent(view);
            view.x = 4;
            view.y = 31;
            view.text.mouseEnabled = false;
            okBtn = bg.okBtn;
            bg.okLabel = LanguageMgr.GetTranslation("领取奖励");
            bg.okFunction = onOkHandler;
            bg.closeCallBack = hide;
            bg.center();
            timer = new OopsFramework.Utils.Timer();
            timer.DistanceTime = 1000;
            itemArr = [];
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function setPos():void{
            bg.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (bg.frameWidth / 2));
            bg.y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (bg.frameHeight / 2));
        }
        public function Update(_arg1:GameTime):void{
            if (timer.IsNextTime(_arg1)){
                updateTime();
            };
        }
        private function initEvent():void{
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function setItem(_arg1:Array, _arg2:Array, _arg3:int):void{
			return;//geoffyan
            var _local6:int;
            var _local7:UseItem;
            var _local8:String;
            var _local9:Sprite;
            timeCount = _arg3;
            timeEnd = (getTimer() + (timeCount * 1000));
            GameCommonData.GameInstance.GameUI.Elements.Add(this);
            removeAllItem();
            okBtn.enable = false;
            var _local4:int = _arg1.length;
            var _local5:Array = this[("itemPos" + _local4)];
            while (_local6 < _local4) {
                _local7 = new UseItem(-1, _arg1[_local6], null);
                _local7.Num = _arg2[_local6];
                _local7.name = ("Treasure_" + _arg1[_local6]);
                _local7.x = 2;
                _local7.y = 2;
                _local8 = (UIConstData.ItemDic[_arg1[_local6]] as ItemTemplateInfo).Name;
                AwardMsg = ((((((AwardMsg + "<font color='#ff33ff'>") + _local8) + "</font>") + _local7.Num) + LanguageMgr.GetTranslation("个")) + "  ");
                _local7.mouseEnabled = true;
                _local9 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local9.addChild(_local7);
                _local9.x = _local5[_local6][0];
                _local9.y = _local5[_local6][1];
                bg.addContent(_local9);
                itemArr.push(_local9);
                _local6++;
            };
        }
        private function onOkHandler(_arg1:MouseEvent=null):void{
            PlayerActionSend.GetTheTreasure();
        }
        private function removeAllItem():void{
            var _local1:Sprite;
            EffectLib.foodsMove(itemArr);
            for each (_local1 in itemArr) {
                if (_local1.parent){
                    _local1.parent.removeChild(_local1);
                };
            };
            itemArr = [];
        }
        private function onCloseHandler(_arg1:MouseEvent):void{
            hide();
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        private function removeEvent():void{
        }
        public function get Enabled():Boolean{
            return (true);
        }
        private function updateTime():void{
            var _local1:int;
            var _local2:int;
            var _local3:String;
            var _local4:String;
            timeCount = ((timeEnd - getTimer()) * 0.001);
            timeCount = ((timeCount >= 0)) ? timeCount : 0;
            _local1 = (timeCount / 60);
            _local2 = (timeCount % 60);
            if (_local2 < 10){
                if (_local2 <= 0){
                    _local2 = 0;
                };
                _local3 = (("0" + _local2) as String);
            } else {
                _local3 = String(_local2);
            };
            if (_local1 < 10){
                _local4 = ("0" + _local1);
            } else {
                _local4 = String(_local1);
            };
            view.text.text = ((_local4 + ":") + _local3);
            if (timeCount == 0){
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                okBtn.enable = true;
            };
        }
        public function show():void{
            var _local1:DataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
            _local1.TreasureViewIsOpen = true;
            GameCommonData.GameInstance.GameUI.addChild(bg);
            initEvent();
        }

    }
}//package GameUI.Modules.TreasureChests.View 
