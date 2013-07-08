//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.display.*;
    import OopsEngine.Skill.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.Components.*;
    import Utils.*;
    import OopsEngine.Graphics.*;

    public class FriendChatCell extends UISprite {

        protected var desTf:TextField;
        protected var _des:String;
        protected var _w:uint;
        private var faceGuidList:Array;

        public function FriendChatCell(_arg1:uint){
            faceGuidList = new Array();
            super();
            this._w = _arg1;
            this.createChildren();
        }
        private function addImg(_arg1:String, _arg2:Rectangle):void{
            var _local3:MovieClip;
            var _local4:uint;
            var _local5:SkillAnimation;
            var _local6:Sprite;
            var _local7:Bitmap;
            if (((ChatData.loadswfTool) && (ChatData.loadswfTool.ComplateLoaded))){
                if (ChatData.mcFaceDic[_arg1]){
                    _local3 = ChatData.mcFaceDic[_arg1];
                } else {
                    _local3 = ChatData.loadswfTool.GetClassByMovieClip(("F" + _arg1));
                    ChatData.mcFaceDic[_arg1] = _local3;
                };
                _local4 = ChatData.getFaceGUID();
                _local5 = FacePlayController.getInstance().addToList(_arg1, _local4, _local3);
                faceGuidList.push(_local4);
                _local6 = new Sprite();
                _local6.x = (_arg2.x - 0);
                _local6.y = (_arg2.y - 4);
                _local6.addChild(_local5);
                addChild(_local6);
                _local5.StartClip("jn");
            } else {
                if (ChatData.loadswfTool == null){
                    ChatData.loadswfTool = new LoadSwfTool(((GameConfigData.FaceSwf + "?v=") + GameConfigData.ChatFaceVerion), false);
                };
                _local7 = new Bitmap();
                _local7.bitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData(("F" + _arg1));
                _local7.x = (_arg2.x - 0);
                _local7.y = (_arg2.y - 4);
                this.addChild(_local7);
            };
        }
        public function set des(_arg1:String):void{
            if (_arg1 == this._des){
                return;
            };
            this._des = _arg1;
            this.toRepaint();
        }
        protected function doLayout():void{
            this.height = (this.desTf.height + 2);
        }
        private function setBmpMask(_arg1:Rectangle):void{
            var _local2:Shape;
            if (_arg1){
                _local2 = new Shape();
                _local2.graphics.beginFill(0xFFFFFF, 1);
                _local2.graphics.drawRect((_arg1.x - 1), _arg1.y, (_arg1.width + 19), _arg1.height);
                _local2.graphics.endFill();
                _local2.blendMode = BlendMode.ERASE;
                this.addChild(_local2);
            };
        }
        protected function toRepaint():void{
            this.desTf.htmlText = this._des;
            this.setFace();
            this.doLayout();
        }
        protected function removeAllFace():void{
            while (this.numChildren > 2) {
                this.removeChildAt(2);
            };
            var _local1:uint;
            _local1 = 0;
            while (_local1 < faceGuidList.length) {
                FacePlayController.getInstance().removeFromList(faceGuidList[_local1]);
                _local1++;
            };
        }
        protected function createChildren():void{
            this.desTf = new TextField();
            this.addChild(this.desTf);
            this.desTf.textColor = 0xFFFFFF;
            this.desTf.defaultTextFormat = this.textFormat();
            this.desTf.mouseEnabled = false;
            this.desTf.autoSize = TextFieldAutoSize.LEFT;
            this.desTf.width = this._w;
            this.desTf.filters = OopsEngine.Graphics.Font.Stroke(0);
            this.desTf.wordWrap = true;
            this.desTf.multiline = true;
            this.desTf.selectable = false;
            this.desTf.mouseWheelEnabled = false;
            this.cacheAsBitmap = true;
        }
        private function textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.leading = 8;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            return (_local1);
        }
        private function setFace():void{
            var _local1:RegExp = /(\\\d{3})/g;
            var _local2:Array = this.desTf.text.split(_local1);
            if (((!(_local2)) || ((_local2.length == 0)))){
                return;
            };
            var _local3:int;
            var _local4:int;
            var _local5:int;
            while (_local3 < _local2.length) {
                if (((_local1.test(_local2[_local3])) && ((int(int(_local2[_local3].slice(1, 4))) <= ChatData.FACE_NUM)))){
                    if (_local5 == 5){
                        break;
                    };
                    if (this.desTf.getCharBoundaries(_local4) == null){
                        setTimeout(setFace, 50);
                        return;
                    };
                    setBmpMask(this.desTf.getCharBoundaries(_local4));
                    addImg(_local2[_local3].slice(1, 4), this.desTf.getCharBoundaries(_local4));
                    _local5++;
                    _local4 = (_local4 + _local2[_local3].length);
                } else {
                    _local4 = (_local4 + _local2[_local3].length);
                };
                _local3++;
            };
        }

    }
}//package GameUI.Modules.Friend.view.ui 
