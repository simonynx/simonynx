//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Chat.UI {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Skill.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.Chat.Data.*;
    import flash.filters.*;
    import Utils.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class ChatCellText extends Sprite {

        public var sendId:uint;
        private var faceGuidList:Array;
        protected var infoArr:Array;
        protected var defaultColor:uint;
        protected var sourceInfo:String;
        private var leoFlag:Boolean;
        private var lineNum:uint = 42;
        protected var tf:TextField;
        protected var realStr:String = "";
        private var cacheCellArr:Array;
        protected var colorArr:Array;

        public function ChatCellText(_arg1:String, _arg2:uint, _arg3:Boolean=false){
            faceGuidList = new Array();
            leoFlag = _arg3;
            if (leoFlag){
                lineNum = 37;
            };
            infoArr = [];
            colorArr = [];
            cacheCellArr = [];
            super();
            this.mouseEnabled = false;
            this.sourceInfo = _arg1;
            this.defaultColor = _arg2;
            this.blendMode = BlendMode.LAYER;
            this.createChildren();
        }
        protected function getStrLength(_arg1:String):uint{
            var _local2:ByteArray = new ByteArray();
            _local2.writeMultiByte(_arg1, "ASNI");
            return (_local2.length);
        }
        private function getColorFontFormat(_arg1:uint):TextFormat{
            var _local2:TextFormat = new TextFormat();
            _local2.color = ChatData.CHAT_COLORS[_arg1];
            _local2.size = 12;
            _local2.leading = 8;
            _local2.font = LanguageMgr.DEFAULT_FONT;
            return (_local2);
        }
        private function onClickLink(_arg1:TextEvent):void{
            this.dispatchEvent(new ChatCellEvent(ChatCellEvent.CHAT_CELLLINK_CLICK, _arg1.text, this.sendId));
        }
        protected function strToArr(_arg1:String):Array{
            var _local2:Array = [];
            if (_arg1.length > 2){
                _arg1 = _arg1.substring(1, (_arg1.length - 1));
                _local2 = _arg1.split("_");
            };
            return (_local2);
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
        private function textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.leading = 8;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            return (_local1);
        }
        protected function createChildren():void{
            var _local1:String;
            var _local2:Array;
            var _local3:uint;
            var _local4:String;
            var _local5:String;
            var _local8:uint;
            var _local9:uint;
            var _local10:String;
            var _local11:uint;
            var _local6:RegExp = /(<\d_.*?>)/g;
            var _local7:Array = sourceInfo.split(_local6);
            for each (_local1 in _local7) {
                if (_local6.test(_local1)){
                    _local2 = strToArr(_local1);
                    if (uint(_local2[0]) == 3){
                        colorArr.push({
                            startIndex:realStr.length,
                            endIndex:(realStr.length + _local2[1].length),
                            color:_local2[2]
                        });
                        realStr = (realStr + _local2[1]);
                        _local8 = (_local8 + getStrLength(_local2[1]));
                        _local8 = (_local8 % lineNum);
                    } else {
                        _local3 = _local8;
                        if ((_local3 + getStrLength(_local2[1])) >= lineNum){
                            if (leoFlag){
                                realStr = (realStr + ("\n" + _local2[1]));
                            } else {
                                realStr = (realStr + ("\n" + _local2[1]));
                            };
                            _local8 = getStrLength(_local2[1]);
                        } else {
                            _local5 = _local2[1];
                            _local5 = _local5.replace("]", " ");
                            realStr = (realStr + _local5);
                            _local8 = (_local8 + getStrLength(_local2[1]));
                        };
                        _local4 = _local1.substring(1, (_local1.length - 1));
                        if ((((((_local2[0] == 0)) || ((_local2[0] == 1)))) || ((_local2[0] == 2)))){
                            _local9 = _local2[(_local2.length - 1)];
                            if (_local2[0] == 1){
                                if (_local2.length > 7){
                                    _local9 = _local2[6];
                                };
                                infoArr.push({
                                    pos:(realStr.length - _local2[1].length),
                                    info:_local4,
                                    des:_local2[1],
                                    color:IntroConst.EquipColors[_local9],
                                    type:_local2[0]
                                });
                            } else {
                                infoArr.push({
                                    pos:(realStr.length - _local2[1].length),
                                    info:_local4,
                                    des:_local2[1],
                                    color:ChatData.CHAT_COLORS[_local9],
                                    type:_local2[0]
                                });
                            };
                        } else {
                            if (_local2[0] == 4){
                                _local10 = _local2[4];
                                if (_local2.length > 5){
                                    _local11 = 0;
                                    _local11 = 0;
                                    while (_local11 < (_local2.length - 5)) {
                                        _local10 = ((_local10 + "_") + _local2[(_local11 + 5)]);
                                        _local11++;
                                    };
                                };
                                infoArr.push({
                                    pos:(realStr.length - _local2[1].length),
                                    info:_local4,
                                    des:_local2[1],
                                    color:_local2[2],
                                    type:_local2[0],
                                    url:_local10,
                                    underLine:_local2[3]
                                });
                            };
                        };
                    };
                } else {
                    realStr = (realStr + _local1);
                    _local8 = (_local8 + getStrLength(_local1));
                    _local8 = (_local8 % lineNum);
                };
            };
            processChatInfo();
        }
        private function setFace(_arg1:TextField):void{
            var _local4:int;
            var _local5:int;
            var _local2:RegExp = /(\\\d{3})/g;
            var _local3:Array = _arg1.text.split(_local2);
            if (((!(_local3)) || ((_local3.length == 0)))){
                return;
            };
            var _local6:Boolean;
            while (_local5 < _local3.length) {
                if (((_local2.test(_local3[_local5])) && ((int(int(_local3[_local5].slice(1, 4))) <= ChatData.FACE_NUM)))){
                    _local6 = true;
                    setBmpMask(_arg1.getCharBoundaries(_local4));
                    addImg(_local3[_local5].slice(1, 4), _arg1.getCharBoundaries(_local4));
                    _local4 = (_local4 + _local3[_local5].length);
                } else {
                    _local4 = (_local4 + _local3[_local5].length);
                };
                _local5++;
            };
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
        public function dispose():void{
            var _local1:TextField;
            for each (_local1 in this.cacheCellArr) {
                _local1.removeEventListener(TextEvent.LINK, onClickLink);
            };
            while (this.numChildren) {
                this.removeChildAt(0);
            };
            var _local2:uint;
            _local2 = 0;
            while (_local2 < faceGuidList.length) {
                FacePlayController.getInstance().removeFromList(faceGuidList[_local2]);
                _local2++;
            };
        }
        private function processChatInfo():void{
            var _local1:Object;
            var _local2:Object;
            var _local3:TextField;
            var _local4:String;
            var _local5:Rectangle;
            var _local6:int;
            tf = new TextField();
            tf.textColor = defaultColor;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.wordWrap = true;
            tf.defaultTextFormat = textFormat();
            tf.text = realStr;
            if (leoFlag == false){
                tf.width = (ChatData.CHAT_WIDTH - 8);
            } else {
                tf.width = (ChatData.CHAT_WIDTH - 43);
            };
            tf.filters = this.stroke();
            this.addChild(tf);
            for each (_local1 in colorArr) {
                tf.setTextFormat(getColorFontFormat(_local1.color), uint(_local1.startIndex), uint(_local1.endIndex));
            };
            for each (_local2 in infoArr) {
                _local3 = new TextField();
                _local3.selectable = false;
                _local3.autoSize = TextFieldAutoSize.LEFT;
                _local3.defaultTextFormat = textFormat();
                _local3.addEventListener(TextEvent.LINK, onClickLink);
                if (_local2.type == 0){
                    _local4 = (((((("<font color=\"#" + Number(_local2.color).toString(16)) + "\"><a href=\"event:") + _local2.info) + "\">") + _local2.des) + "</a></font>");
                    _local3.styleSheet = ChatData.NameStyle;
                } else {
                    if (_local2.type == 1){
                        _local4 = (((((("<font color=\"#" + Number(_local2.color).toString(16)) + "\"><a href=\"event:") + _local2.info) + "\">") + _local2.des) + "</a></font>");
                        _local3.styleSheet = ChatData.HtmlStyle;
                    } else {
                        if (_local2.type == 2){
                            _local4 = (((((("<u><font color=\"#" + Number(_local2.color).toString(16)) + "\"><a href=\"event:") + _local2.info) + "\">") + _local2.des) + "</a></font></u>");
                            _local3.styleSheet = ChatData.NameStyle;
                        } else {
                            if (_local2.type == 4){
                                _local3.styleSheet = ChatData.HtmlStyle;
                                _local4 = (((((("<u><font color=\"#" + Number(_local2.color).toString(16)) + "\"><a href=\"") + _local2.url) + "\" target=\"_blank\">") + _local2.des) + "</a></font></u>");
                            };
                        };
                    };
                };
                _local3.htmlText = _local4;
                _local5 = tf.getCharBoundaries(_local2.pos);
                _local3.x = (_local5.x - 2);
                _local3.y = (_local5.y - 2);
                if ((_local3.x + _local3.width) >= ChatData.CHAT_WIDTH){
                    _local3.x = (ChatData.CHAT_WIDTH - _local3.width);
                    if (leoFlag){
                        tf.text = ((realStr.substr(0, _local2.pos) + "\n") + realStr.substr(_local2.pos, (realStr.length - _local2.pos)));
                    } else {
                        tf.text = ((realStr.substr(0, _local2.pos) + "\n") + realStr.substr(_local2.pos, (realStr.length - _local2.pos)));
                    };
                    _local6 = realStr.indexOf(" ", _local2.pos);
                    if (_local6 != -1){
                        _local3.x = (tf.getCharBoundaries(0).x - 2);
                        _local3.y = (tf.getCharBoundaries(_local6).y - 3);
                    } else {
                        _local3.htmlText = "";
                    };
                };
                _local3.filters = this.stroke();
                this.cacheCellArr.push(_local3);
                this.addChild(_local3);
            };
            this.setFace(tf);
        }
        private function stroke(_arg1:uint=0):Array{
            var _local2:GlowFilter = new GlowFilter(_arg1, 1, 2, 2, 12);
            var _local3:Array = new Array();
            _local3.push(_local2);
            return (_local3);
        }

    }
}//package GameUI.Modules.Chat.UI 
