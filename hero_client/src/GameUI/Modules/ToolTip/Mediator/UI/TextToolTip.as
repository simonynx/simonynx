//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator.UI {
    import flash.display.*;
    import flash.text.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class TextToolTip implements IToolTip {

        private var content:Sprite;
        private var toolTip:Sprite;
        private var max:uint = 158;
        private var back:MovieClip;
        private var data:String = "";

        public function TextToolTip(_arg1:Sprite, _arg2:String, _arg3:uint=0){
            this.toolTip = _arg1;
            this.data = _arg2;
            if (_arg3 != 0){
                max = _arg3;
            };
        }
        public function BackWidth():Number{
            return (back.width);
        }
        public function Update(_arg1:Object):void{
        }
        private function upDatePos():void{
            var _local1:* = 1;
            var _local2:Number = 0;
            back.width = max;
            back.height = (content.height + 25);
            var _local3:int;
            while (_local3 < content.numChildren) {
                if (content.getChildAt(_local3).width > max){
                    content.getChildAt(_local3).width = max;
                };
                _local3++;
            };
        }
        private function setContent():void{
            content = new Sprite();
            var _local1:Array = [{
                text:data,
                color:IntroConst.COLOR
            }];
            showContent(_local1);
            toolTip.addChild(content);
        }
        public function GetType():String{
            return ("TextToolTip");
        }
        private function setFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.font = LanguageMgr.DEFAULT_FONT;
            _local1.leading = 2;
            _local1.align = TextFormatAlign.LEFT;
            return (_local1);
        }
        public function Remove():void{
        }
        public function Show():void{
            back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToolTipBackSmall");
            back.width = max;
            toolTip.addChild(back);
            setContent();
            upDatePos();
        }
        private function showContent(_arg1:Array):void{
            var _local2:TextField;
            var _local3:int;
            while (_local3 < _arg1.length) {
                _local2 = new TextField();
                _local2.selectable = false;
                _local2.multiline = true;
                _local2.mouseWheelEnabled = false;
                _local2.defaultTextFormat = setFormat();
                _local2.autoSize = TextFieldAutoSize.LEFT;
                _local2.width = toolTip.width;
                _local2.wordWrap = true;
                _local2.x = 12;
                _local2.y = 12;
                _local2.filters = OopsEngine.Graphics.Font.Stroke(0);
                _local2.textColor = _arg1[_local3].color;
                _local2.htmlText = _arg1[_local3].text;
                if (max > _local2.textWidth){
                    max = (_local2.textWidth + 25);
                };
                content.addChild(_local2);
                _local3++;
            };
        }

    }
}//package GameUI.Modules.ToolTip.Mediator.UI 
