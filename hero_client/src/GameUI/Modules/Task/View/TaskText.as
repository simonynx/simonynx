//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.View.Components.*;
    import GameUI.Modules.Task.Commamd.*;
    import OopsEngine.Graphics.*;
    import flash.system.*;

    public class TaskText extends UISprite {

        public const iconDic:Dictionary = new Dictionary();;

        protected var tf:TextField;
        private var _IsShowIcon:Boolean = true;

        public function TaskText(_arg1:Number=215){
   //         iconDic = new Dictionary();
            super();
            this.width = _arg1;
            iconDic["fx"] = true;
            this.tf = new TextField();
            this.tf.wordWrap = true;
            this.tf.condenseWhite = false;
            this.tf.filters = OopsEngine.Graphics.Font.Stroke(0);
            this.tf.multiline = true;
            this.tf.type = TextFieldType.DYNAMIC;
            this.tf.selectable = false;
            this.tf.autoSize = TextFieldAutoSize.LEFT;
            this.tf.width = _arg1;
            this.tf.addEventListener(MouseEvent.ROLL_OVER, onTextRollOverHandler);
            this.tf.addEventListener(MouseEvent.ROLL_OUT, onTextRollOutHandler);
            this.tf.mouseWheelEnabled = false;
            this.tf.defaultTextFormat = textFormat();
            this.addChildAt(tf, 1);
        }
        public function set tfText(_arg1:String):void{
            if (this.tf.htmlText == _arg1){
                return;
            };
            this.removeAll();
            _arg1 = _arg1.replace(/\$MYJOB\$/g, ((GameCommonData.Player.Role.MainJob.Job > 0)) ? GameCommonData.RolesListDic[GameCommonData.Player.Role.MainJob.Job] : "");
            _arg1 = _arg1.replace(/\$MYNAME\$/g, GameCommonData.Player.Role.Name);
            this.tf.htmlText = _arg1;
            this.tf.addEventListener(TextEvent.LINK, onClickLink);
            this.showIcon();
            this.height = this.tf.height;
            this.width = this.tf.width;
        }
        protected function onClickLink(_arg1:TextEvent):void{
            if (_arg1.text != ""){
                UIFacade.GetInstance().sendNotification(TaskTextCommand.NAME, {
                    type:"MOVE",
                    text:_arg1.text
                });
            };
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
            IME.enabled = false;
        }
        public function get tfText():String{
            return (tf.htmlText);
        }
        private function onShooseClickHandler(_arg1:MouseEvent):void{
            var _local2:String = _arg1.currentTarget["taskEvent"];
            if ((((_local2 == null)) || ((_local2.length < 1)))){
                return;
            };
            var _local3:Array = _local2.split(",");
            if (_local3.length != 5){
                return;
            };
            JianTouMc.getInstance(JianTouMc.TYPE_VIPFLYTIP).close();
            UIFacade.GetInstance().sendNotification(TaskTextCommand.NAME, {
                type:"FLY",
                text:_local2
            });
        }
        private function textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.leading = 5;
            _local1.size = 12;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            return (_local1);
        }
        protected function onTextRollOutHandler(_arg1:MouseEvent):void{
            SysCursor.GetInstance().revert();
        }
        protected function onTextRollOverHandler(_arg1:MouseEvent):void{
            SysCursor.GetInstance().showSystemCursor();
        }
        protected function showIcon():void{
            var _local1:MovieClip;
            var _local2:String;
            var _local3:int;
            var _local4:int;
            var _local7:Array;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local5:RegExp = /(\\[a-z]{2})/g;
            var _local6:Array = tf.text.split(_local5);
            _local7 = tf.htmlText.split(_local5);
            if (((!(_local6)) || ((_local6.length == 0)))){
                return;
            };
            while (_local8 < _local6.length) {
                if (_local5.test(_local6[_local8])){
                    if (!isIcon(_local6[_local8].slice(1, 3))){
                        return;
                    };
                    _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(_local6[_local8].slice(1, 3));
                    _local1.buttonMode = true;
                    if (tf.getCharBoundaries(_local9) == null){
                        setTimeout(showIcon, 50);
                        return;
                    };
                    _local2 = tf.htmlText.substring((_local10 - 80), _local10);
                    _local3 = _local2.indexOf("event");
                    _local4 = _local2.indexOf("TARGET");
                    if (((!((_local3 == -1))) && (!((_local4 == -1))))){
                        _local2 = _local2.substring((_local3 + 6), (_local4 - 2));
                        _local1["taskEvent"] = _local2;
                        _local1.addEventListener(MouseEvent.CLICK, onShooseClickHandler);
                    };
                    _local1.x = int(((tf.getCharBoundaries(_local9).x + tf.x) + 1));
                    _local1.y = int(((tf.getCharBoundaries(_local9).y + tf.y) - 3));
                    _local1.name = _local6[_local8].slice(1, 3);
                    this.blendMode = BlendMode.LAYER;
                    setMcMask(_local1);
                    addChild(_local1);
                    _local10 = (_local10 + _local7[_local8].length);
                    _local9 = (_local9 + _local6[_local8].length);
                } else {
                    _local10 = (_local10 + _local7[_local8].length);
                    _local9 = (_local9 + _local6[_local8].length);
                };
                _local8++;
            };
        }
        public function get Tf():TextField{
            return (tf);
        }
        protected function isIcon(_arg1:String):Boolean{
            if (iconDic[_arg1]){
                return (true);
            };
            return (false);
        }
        protected function setMcMask(_arg1:MovieClip):void{
            var _local2:Shape = new Shape();
            _local2.graphics.beginFill(0xFFFFFF, 1);
            _local2.graphics.drawRect((_arg1.x - 2), _arg1.y, 20, 18);
            _local2.graphics.endFill();
            _local2.blendMode = BlendMode.ERASE;
            this.addChild(_local2);
        }
        protected function removeAll():void{
            while (this.numChildren > 2) {
                this.removeChildAt(2);
            };
        }

    }
}//package GameUI.Modules.Task.View 
