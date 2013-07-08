//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.StartMediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import GameUI.Modules.Login.Model.*;
    import GameUI.Modules.Login.view.*;

    public class SelectRoleWindow extends Sprite {

        public static const TYPE_HEFU:uint = 1;
        public static const TYPE_NORMAL:uint = 0;

        private var countClick:int = 0;
        public var renameView:SelectRoleRenameView;
        private var timeId:int = 0;
        private var cells:Array;
        public var enterGameBtn:SimpleButton;
        public var keepBtn:HLabelButton;
        public var KeepRoleArr:Array;
        private var _currentSelectInfo:RoleVo;
        private var mainMc:MovieClip;
        private var _scrollPanel;
        public var errormsg:TextField;
        private var type:uint = 0;
        private var _bgImg:Bitmap;

        public function SelectRoleWindow(){
            cells = [];
            KeepRoleArr = [];
            super();
            initView();
            addEvents();
        }
        public function setRoleData(_arg1:Array):void{
            var _local2:RoleCellView;
            var _local3:RoleVo;
            var _local5:int;
            var _local6:int;
            if (_arg1.length <= 3){
                type = TYPE_NORMAL;
            } else {
                type = TYPE_HEFU;
            };
            cleanCells();
            cells = [];
            var _local4:Sprite = new Sprite();
            if (type == TYPE_NORMAL){
                mainMc.enterGameBtn.visible = true;
                keepBtn.visible = false;
                mainMc.keepRoleTipsMc.visible = false;
                _local5 = 0;
                while (_local5 < 3) {
                    _local6 = 0;
                    while (_local6 < _arg1.length) {
                        if (_local5 == _arg1[_local6].Index){
                            _local3 = _arg1[_local6];
                            break;
                        };
                        _local3 = null;
                        _local6++;
                    };
                    _local2 = new RoleCellView(_local5);
                    _local2.info = _local3;
                    _local2.type = type;
                    _local2.x = 0;
                    _local2.y = (_local5 * 90);
                    _local2.addEventListener(Event.SELECT, selectRoleItemHandler);
                    _local2.addEventListener("create_role", createRoleHandler);
                    _local4.addChild(_local2);
                    cells.push(_local2);
                    _local5++;
                };
            } else {
                if (type == TYPE_HEFU){
                    _arg1.sortOn("Level", (Array.NUMERIC | Array.DESCENDING));
                    mainMc.enterGameBtn.visible = false;
                    keepBtn.visible = true;
                    mainMc.keepRoleTipsMc.visible = true;
                    _local5 = 0;
                    while (_local5 < _arg1.length) {
                        _local3 = _arg1[_local5];
                        _local2 = new RoleCellView(_local5);
                        _local2.info = _local3;
                        _local2.type = type;
                        _local2.x = 0;
                        _local2.y = (_local5 * 90);
                        _local2.addEventListener("change_hfAddRole", changeHfAddRoleHandler);
                        _local4.addChild(_local2);
                        cells.push(_local2);
                        if (_local5 < 3){
                            _local2.addRoleHandler(null);
                        };
                        _local5++;
                    };
                };
            };
            this._scrollPanel.source = _local4;
            this._scrollPanel.update();
        }
        private function onBGCom(_arg1:Event):void{
            (_arg1.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE, onBGCom);
            var _local2:MovieClip = _arg1.currentTarget.content.getChildAt(0);
            var _local3:Bitmap = (_local2.getChildAt(0) as Bitmap);
            _bgImg.bitmapData = _local3.bitmapData;
            resize();
        }
        private function selectRoleItemHandler(_arg1:Event):void{
            var _local2:RoleCellView;
            this._scrollPanel.focusManager.deactivate();
            if (_arg1.currentTarget.info.Name.indexOf("#") != -1){
                showRenameView(_arg1.currentTarget.info);
                return;
            };
            countClick++;
            if (countClick == 1){
                timeId = setTimeout(selectRoleItem, 200);
                _arg1.stopPropagation();
            } else {
                if ((((countClick == 2)) && ((currentSelectInfo == _arg1.currentTarget.info)))){
                    countClick = 0;
                    clearTimeout(timeId);
                    _arg1.stopPropagation();
                    enterGameBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                } else {
                    countClick = 0;
                };
            };
            var _local3:int;
            while (_local3 < cells.length) {
                _local2 = cells[_local3];
                if (_local2.info){
                    if (_local2 == _arg1.currentTarget){
                        _currentSelectInfo = _local2.info;
                        _local2.selected = true;
                    } else {
                        _local2.selected = false;
                    };
                };
                _local3++;
            };
        }
        private function loadBG():void{
            var _local1:Loader = new Loader();
            _local1.load(new URLRequest("Resources/GameDLC/SelecrRoleBack.swf"));
            _local1.contentLoaderInfo.addEventListener(Event.COMPLETE, onBGCom);
        }
        private function selectRoleItem():void{
            this.countClick = 0;
            dispatchEvent(new Event(Event.SELECT));
        }
        private function initView():void{
            this.graphics.beginFill(0, 1);
            this.graphics.drawRect(-1000, -1000, 4000, 3000);
            this.graphics.endFill();
            _bgImg = new Bitmap();
            this.addChildAt(_bgImg, 0);
            loadBG();
            addChildAt(_bgImg, 0);
            mainMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole).GetClassByMovieClip("SelectRole");
            addChild(mainMc);
            enterGameBtn = mainMc.enterGameBtn;
            var _local1:Class = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole).GetClass("fl.containers.ScrollPane");
            this._scrollPanel = new (_local1)();
            this._scrollPanel.setStyle("upSkin", new Sprite());
            this._scrollPanel.setStyle("skin", new Sprite());
            this._scrollPanel.horizontalScrollPolicy = "off";
            this._scrollPanel.verticalScrollPolicy = "auto";
            this._scrollPanel.setSize(325, 290);
            this._scrollPanel.x = 320;
            this._scrollPanel.y = 55;
            mainMc.addChild(DisplayObject(_scrollPanel));
            keepBtn = new HLabelButton();
            keepBtn.label = LanguageMgr.GetTranslation("保留角色");
            keepBtn.x = 450;
            keepBtn.y = 420;
            mainMc.addChild(keepBtn);
            errormsg = new TextField();
            errormsg.text = "";
            errormsg.textColor = 0xFFFF00;
            errormsg.autoSize = TextFieldAutoSize.CENTER;
            errormsg.selectable = false;
            errormsg.mouseEnabled = false;
            errormsg.x = 330;
            errormsg.y = 450;
            errormsg.width = 330;
            mainMc.addChild(errormsg);
        }
        private function createRoleHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        private function changeHfAddRoleHandler(_arg1:Event):void{
            var _local3:RoleCellView;
            KeepRoleArr = [];
            var _local2:Array = [];
            var _local4:int;
            while (_local4 < cells.length) {
                _local3 = cells[_local4];
                if (_local3.info){
                    if (_local3.addMcSelected){
                        _local2.push(_local3);
                    };
                };
                _local4++;
            };
            KeepRoleArr = _local2;
        }
        private function addEvents():void{
        }
        public function dispose():void{
            cleanCells();
            if (((_bgImg) && (_bgImg.parent))){
                _bgImg.parent.removeChild(_bgImg);
                _bgImg = null;
            };
            if (((mainMc) && (mainMc.parent))){
                mainMc.parent.removeChild(mainMc);
                mainMc = null;
            };
            enterGameBtn = null;
            while (this.numChildren) {
                this.removeChildAt(0);
            };
        }
        private function cleanCells():void{
            var _local1:RoleCellView;
            var _local2:int;
            while (_local2 < cells.length) {
                _local1 = cells[_local2];
                _local1.removeEventListener(Event.SELECT, selectRoleItemHandler);
                _local1.removeEventListener("change_hfAddRole", changeHfAddRoleHandler);
                _local1.removeEventListener("create_role", createRoleHandler);
                _local1.dispose();
                _local2++;
            };
            cells = [];
        }
        public function get currentSelectInfo():RoleVo{
            return (this._currentSelectInfo);
        }
        private function showRenameView(_arg1:RoleVo):void{
            if (renameView == null){
                renameView = new SelectRoleRenameView();
            };
            renameView.info = _arg1;
            renameView.show();
            renameView.centerFrame();
        }
        public function resize():void{
            _bgImg.width = GameCommonData.GameInstance.ScreenWidth;
            _bgImg.height = GameCommonData.GameInstance.ScreenHeight;
            _bgImg.x = 0;
            _bgImg.y = 0;
            mainMc.x = ((GameCommonData.GameInstance.ScreenWidth - mainMc.width) / 2);
            mainMc.y = ((GameCommonData.GameInstance.ScreenHeight - mainMc.height) / 2);
        }
        private function removeEvents():void{
        }

    }
}//package GameUI.Modules.Login.StartMediator 
