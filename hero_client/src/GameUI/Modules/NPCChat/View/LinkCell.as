//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;
    import GameUI.Modules.NPCChat.Proxy.*;

    public class LinkCell extends UISprite {

        private var icon:BitmapData;
        public var linkTf:TextField;
        public var onLinkClick:Function;
        private var mouseOverAsset:MovieClip;
        private var _linkId:int;
        public var m_eventid:int;
        protected var data:Object;
        private var code:Boolean = false;
        private var arrDes:Array;
        private var _showStr:String;
        protected var iconUrl:String;
        private var type:uint;
        private var boxMessage:String = "";

        public function LinkCell(_arg1:String, _arg2:int, _arg3:int, _arg4:String, _arg5:uint, _arg6:Boolean=false, _arg7:String=""){
            data = {};
            super();
            this.iconUrl = _arg1;
            this._linkId = _arg3;
            this.m_eventid = _arg2;
            this._showStr = _arg4;
            this.type = _arg5;
            this.code = _arg6;
            this.boxMessage = _arg7;
            this.createChildren();
            this.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
            mouseOverAsset = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LinkCellLightAsset");
            mouseOverAsset.width = this.width;
            mouseOverAsset.mouseEnabled = false;
        }
        private function __mouseOutHandler(_arg1:MouseEvent):void{
            if (((mouseOverAsset) && (mouseOverAsset.parent))){
                mouseOverAsset.parent.removeChild(mouseOverAsset);
            };
        }
        protected function onClickLink(_arg1:MouseEvent):void{
            onLinkClick({
                linkId:this.linkId,
                EventID:this.m_eventid,
                type:this.type,
                command:this.showStr,
                code:code,
                boxm:boxMessage
            });
        }
        public function get linkId():int{
            return (_linkId);
        }
        override public function set height(_arg1:Number):void{
            super.height = _arg1;
            if (mouseOverAsset){
                this.mouseOverAsset.height = _arg1;
            };
        }
        private function __mouseOverHandler(_arg1:MouseEvent):void{
            this.addChildAt(mouseOverAsset, 0);
        }
        override public function set width(_arg1:Number):void{
            super.width = _arg1;
            if (mouseOverAsset){
                this.mouseOverAsset.width = _arg1;
            };
        }
        public function set htmlText(_arg1:String):void{
            this.linkTf.htmlText = _arg1;
        }
        public function get showStr():String{
            return (_showStr);
        }
        protected function createChildren():void{
            var _local3:Bitmap;
            var _local4:TaskInfoStruct;
            this.buttonMode = true;
            this.mouseEnabled = true;
            if (this.iconUrl != ""){
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData(this.iconUrl);
                _local3 = new Bitmap(this.icon);
                this.addChild(_local3);
                _local3.x = 0;
                _local3.y = 3;
            };
            this.linkTf = new TextField();
            var _local1:TextFormat = new TextFormat();
            _local1.color = 16776513;
            _local1.size = 15;
            linkTf.defaultTextFormat = _local1;
            this.linkTf.autoSize = TextFieldAutoSize.CENTER;
            this.linkTf.selectable = false;
            this.linkTf.mouseEnabled = false;
            var _local2 = "";
            if (type == DialogConstData.CHATTYPE_TASK){
                if (_local3){
                    _local3.visible = false;
                };
                _local4 = GameCommonData.TaskInfoDic[linkId];
                if (_local4){
                    if (iconUrl == DialogConstData.getInstance().getSymbolName(2)){
                        _local2 = (((((("<font color=\"#FF7C3B\" size=\"15\" face=\"宋体\">【" + QuestType.GetTypeName(_local4.taskType).slice(0, 2)) + "】") + this.showStr) + "(") + LanguageMgr.GetTranslation("已完成")) + ")&nbsp;&nbsp;</font>");
                    } else {
                        if (iconUrl == DialogConstData.getInstance().getSymbolName(3)){
                            _local2 = (((((("<font color=\"#FFFFFF\" size=\"15\" face=\"宋体\">【" + QuestType.GetTypeName(_local4.taskType).slice(0, 2)) + "】") + this.showStr) + "(") + LanguageMgr.GetTranslation("未完成")) + ")&nbsp;&nbsp;</font>");
                        } else {
                            if (iconUrl == DialogConstData.getInstance().getSymbolName(4)){
                                _local2 = (((((("<font color=\"#7EFF00\" size=\"15\" face=\"宋体\">【" + QuestType.GetTypeName(_local4.taskType).slice(0, 2)) + "】") + this.showStr) + "(") + LanguageMgr.GetTranslation("可接")) + ")&nbsp;&nbsp;</font>");
                            } else {
                                _local2 = ("" + iconUrl);
                                this.mouseChildren = false;
                                this.mouseEnabled = false;
                                this.filters = [ColorFilters.BWFilter];
                            };
                        };
                    };
                } else {
                    _local2 = ("" + linkId);
                    this.mouseChildren = false;
                    this.mouseEnabled = false;
                    this.filters = [ColorFilters.BWFilter];
                };
                width = 280;
            } else {
                if ((((type == DialogConstData.CHATTYPE_OTHER)) || ((type == DialogConstData.CHATTYPE_EXIT)))){
                    if (_local3){
                        _local3.visible = true;
                    };
                    _local2 = (((("<a href=\"event:" + String(this.linkId)) + "\"><font color=\"#FFFD41\" size=\"15\" face=\"宋体\">") + this.showStr) + "</font></a>");
                    width = 127;
                };
            };
            height = 10;
            if (this.showStr == LanguageMgr.GetTranslation("洗第二重")){
                if (GameCommonData.Player.Role.Level < 30){
                    this.mouseChildren = false;
                    this.mouseEnabled = false;
                    this.filters = [ColorFilters.BWFilter];
                };
            } else {
                if (this.showStr == LanguageMgr.GetTranslation("洗第三重")){
                    if (GameCommonData.Player.Role.Level < 70){
                        this.mouseChildren = false;
                        this.mouseEnabled = false;
                        this.filters = [ColorFilters.BWFilter];
                    };
                };
            };
            this.linkTf.htmlText = _local2;
            this.addChild(this.linkTf);
            this.linkTf.x = 30;
            this.linkTf.y = 2;
            this.addEventListener(MouseEvent.CLICK, onClickLink);
        }
        public function get htmlText():String{
            return (linkTf.htmlText);
        }

    }
}//package GameUI.Modules.NPCChat.View 
