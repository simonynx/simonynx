//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.display.*;
    import flash.text.*;
    import GameUI.Modules.Activity.Command.*;

    public class ActivityMustDoItem extends Sprite {

        public var Btn_quickComplete:TextField;
        public var Btn_des:MovieClip;
        private var _item:MovieClip;
        public var id:int;
        private var attend:int;
        private var _max:uint;
        private var _textColor:uint;
        public var special:String;
        public var type:int;
        private var _isFinish:Boolean = false;
        private var _activeRate:int;
        private var _rate:int;
        private var _current:uint;
        public var actId:int;
        public var tog:int;
        private var _des:String;
        private var defaultColorList:Array;

        public function ActivityMustDoItem(){
            _item = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ActivityEveryItem1");
            super();
            Btn_quickComplete = new TextField();
            Btn_quickComplete.defaultTextFormat = _item.quickComplete.getTextFormat();
            Btn_quickComplete.x = _item.quickComplete.x;
            Btn_quickComplete.y = _item.quickComplete.y;
            _item.quickComplete.visible = false;
            _item.addChild(Btn_quickComplete);
            Btn_des = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SearchBtn");
            Btn_des.buttonMode = true;
            Btn_des.x = 388;
            Btn_des.y = 8.5;
            _item.addChild(Btn_des);
            _item.txt_0.mouseEnabled = false;
            _item.txt_1.mouseEnabled = false;
            _item.txt_2.mouseEnabled = false;
            addChild(_item);
            defaultColorList = [_item.txt_0.textColor, _item.txt_1.textColor, _item.txt_2.textColor, _item.quickComplete.textColor];
        }
        public function get Rate():int{
            return (_rate);
        }
        public function set current(_arg1:uint):void{
            _current = _arg1;
            if (attend == 0){
                _item.txt_1.text = ((_current + "/") + Max);
            } else {
                _item.txt_1.text = (((((_current + "/(") + Max) + "+") + attend) + ")");
            };
        }
        public function set Rate(_arg1:int):void{
            _rate = _arg1;
        }
        public function set Max(_arg1:uint):void{
            _max = _arg1;
            if (Max > 1){
                type = 1;
            } else {
                type = 0;
            };
        }
        public function set Value(_arg1:uint):void{
            attend = (_arg1 / ActivityConstants.DAILY_ADDITION_VAL);
            if (attend > 0){
                current = _current;
            };
        }
        public function set TextColor(_arg1:int):void{
            if (_arg1 == 1){
                _textColor = 10966952;
            } else {
                if (_arg1 == 0){
                    _textColor = 0xFF00;
                };
            };
        }
        public function get ActiveRate():int{
            return (_activeRate);
        }
        public function get Item():MovieClip{
            return (_item);
        }
        public function get Max():uint{
            return (_max);
        }
        public function set ActiveRate(_arg1:int):void{
            _activeRate = _arg1;
            _item.txt_2.text = ("+" + _arg1);
        }
        public function set Des(_arg1:String):void{
            _des = _arg1;
        }
        public function set Title(_arg1:String):void{
            _item.txt_0.text = _arg1;
        }
        public function get Des():String{
            return (_des);
        }
        public function get current():uint{
            return (_current);
        }
        public function set IsFinish(_arg1:Boolean):void{
            _isFinish = _arg1;
            Btn_quickComplete.mouseEnabled = !(_arg1);
            Btn_des.mouseEnabled = !(_arg1);
            if (_isFinish){
                _item.txt_0.textColor = 0x898989;
                _item.txt_1.textColor = 0x898989;
                _item.txt_2.textColor = 0x898989;
                Btn_quickComplete.textColor = 0x898989;
                current = Max;
            } else {
                _item.txt_0.textColor = _textColor;
                _item.txt_1.textColor = defaultColorList[1];
                _item.txt_2.textColor = defaultColorList[2];
                Btn_quickComplete.textColor = defaultColorList[3];
                if (type == 0){
                    current = 0;
                };
            };
        }
        public function get IsFinish():Boolean{
            return (_isFinish);
        }

    }
}//package GameUI.Modules.Activity.UI 
