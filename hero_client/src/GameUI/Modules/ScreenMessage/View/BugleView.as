//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;

    public class BugleView extends Sprite {

        private static var _instance:BugleView;

        private var _isPlaying:Boolean;
        private var _timer:Timer;
        private var view:MovieClip;
        private var _currentBugleType:int;
        private var blankSpace:String;
        private var _currentBugle:String;
        private var _bugleList:Array;

        public function BugleView(){
            mouseEnabled = false;
            mouseChildren = false;
            init();
            initEvent();
            super();
        }
        public static function get instance():BugleView{
            if (_instance == null){
                _instance = new (BugleView)();
            };
            return (_instance);
        }

        public function setPos():void{
            view.width = (GameCommonData.GameInstance.ScreenWidth - 430);
        }
        private function checkPlay():void{
            var _local1:String;
            var _local2:String;
            if (_isPlaying){
                return;
            };
            if (_bugleList.length > 0){
                _local1 = _bugleList.splice(0, 1)[0];
                _local2 = _local1.slice(0, 1);
                _currentBugleType = 1;
                if (_local2 == "s"){
                    _currentBugleType = 2;
                } else {
                    if (_local2 == "f"){
                        _currentBugleType = 3;
                    };
                };
                _currentBugle = _local1.slice(1);
                _isPlaying = true;
                _timer.reset();
                _timer.start();
                show();
            } else {
                hide();
            };
        }
        public function fBugle(_arg1:String):void{
            var _local2:String = filterString(_arg1, "<1_");
            _local2 = filterString(_local2, "<2_");
            _local2 = filterString(_local2, "<3_");
            var _local3:String = (("f" + blankSpace) + _local2);
            _bugleList.push(_local3);
            checkPlay();
        }
        private function filterString(_arg1:String, _arg2:String):String{
            var _local5:uint;
            var _local6:String;
            var _local7:Array;
            var _local3:String = _arg1;
            var _local4:int = _local3.indexOf(_arg2);
            while (_local4 != -1) {
                _local5 = _local3.indexOf(">", _local4);
                _local6 = _local3.substring(_local4, _local5);
                _local7 = _local6.split("_");
                _local3 = ((_local3.substring(0, _local4) + _local7[1]) + _local3.substring((_local5 + 1), _local3.length));
                _local4 = _local3.indexOf(_arg2);
            };
            return (_local3);
        }
        public function hide():void{
            if (parent){
                parent.removeChild(this);
            };
        }
        private function init():void{
            blankSpace = "                                                                                             ";
            _timer = new Timer(80);
            _bugleList = [];
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BugleAsset");
            view.x = 260;
            view.y = 65;
            this.addChild(view);
            view.width = (GameCommonData.GameInstance.ScreenWidth - 430);
        }
        public function sysNotice(_arg1:String):void{
            var _local2:String = filterString(_arg1, "<1_");
            _local2 = filterString(_local2, "<2_");
            _local2 = filterString(_local2, "<3_");
            var _local3:String = (("s" + blankSpace) + _local2);
            _bugleList.unshift(_local3);
            checkPlay();
        }
        private function initEvent():void{
            _timer.addEventListener(TimerEvent.TIMER, _timerHandler);
        }
        private function _timerHandler(_arg1:TimerEvent):void{
            if (_currentBugle == ""){
                _isPlaying = false;
                _timer.stop();
                checkPlay();
            } else {
                if (view.content_txt.text != ""){
                    if (view.content_txt.getCharBoundaries(0) == null){
                        _currentBugle = "";
                    } else {
                        if (view.content_txt.getCharBoundaries(0).width < 7){
                            _currentBugle = _currentBugle.slice(1);
                        } else {
                            if (view.content_txt.getCharBoundaries(0).width < 14){
                                _currentBugle = (" " + _currentBugle.slice(1));
                            } else {
                                _currentBugle = ("   " + _currentBugle.slice(1));
                            };
                        };
                    };
                };
                view.content_txt.text = _currentBugle;
            };
        }
        public function show():void{
            GameCommonData.GameInstance.TooltipLayer.addChild(this);
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
