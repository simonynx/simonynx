//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.TreasureChests.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsFramework.*;
    import flash.utils.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import OopsFramework.Utils.*;
    import Utils.*;
    import GameUI.Modules.TreasureChests.Data.*;

    public class TreasureChest extends Sprite implements IUpdateable {

        private var timeCount:int;
        private var timer:OopsFramework.Utils.Timer;
        private var box:MovieClip;
        private var timeEnd:int;
        private var loadswfTool:LoadSwfTool;
        private var isNoTreasure:Boolean;

        public function TreasureChest(){
            init();
            super();
        }
        private function onOpenHandler(_arg1:MouseEvent):void{
            if (isNoTreasure){
                MessageTip.show(LanguageMgr.GetTranslation("本日在线奖品领取完毕"));
                return;
            };
            var _local2:DataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
            if (!_local2.TreasureViewIsOpen){
                UIFacade.GetInstance().sendNotification(TreasureEvent.SHOW_TREASURE);
            } else {
                UIFacade.GetInstance().sendNotification(TreasureEvent.CLOSE_TREASURE);
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        private function init():void{
            box = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TreasureBox");
            box.buttonMode = true;
            this.addChild(box);
            box.text.mouseEnabled = false;
            box.addEventListener(MouseEvent.CLICK, onOpenHandler);
            timer = new OopsFramework.Utils.Timer();
            timer.DistanceTime = 1000;
            box.box.gotoAndStop(1);
            box.box.mouseEnabled = false;
            box.box.mouseChildren = false;
        }
        public function setPos():void{
            this.x = (GameCommonData.GameInstance.ScreenWidth - 200);
            this.y = 135;
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function noTreasure():void{
            isNoTreasure = true;
            if (box.box){
                box.box.gotoAndStop(1);
            };
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function Update(_arg1:GameTime):void{
            if (timer.IsNextTime(_arg1)){
                updateTime();
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function setNewTreasure(_arg1:int):void{
            timeCount = _arg1;
            timeEnd = (getTimer() + (timeCount * 1000));
            GameCommonData.GameInstance.GameUI.Elements.Add(this);
            box.text.textColor = 16763954;
            if (box.box){
                box.box.gotoAndStop(1);
            };
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
            box.text.text = ((_local4 + ":") + _local3);
            box.text.textColor = 16763954;
            if (((box.box) && ((timeCount == 0)))){
                GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                box.box.play();
                box.text.text = LanguageMgr.GetTranslation("可领取");
                box.text.textColor = 0xFF00;
            };
        }
        public function removeAll():void{
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
            if (this.box){
                this.box.removeEventListener(MouseEvent.CLICK, onOpenHandler);
                this.removeChild(this.box);
                box = null;
            };
            if (this.parent){
                this.parent.removeChild(this);
            };
        }

    }
}//package GameUI.Modules.TreasureChests.View 
