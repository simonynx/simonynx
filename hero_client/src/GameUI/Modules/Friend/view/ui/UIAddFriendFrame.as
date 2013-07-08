//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;
    import flash.ui.*;

    public class UIAddFriendFrame extends HConfirmFrame {

        public var okFun:Function;
        private var _bg:MovieClip;
        private var nameTF:TextField;
        private var contentSprite:Sprite;

        public function UIAddFriendFrame(){
            initView();
            addEvents();
        }
        override public function show():void{
            super.show();
            if (stage){
                stage.focus = nameTF;
            };
        }
        private function removeEvents():void{
            UIUtils.removeFocusLis(nameTF);
        }
        private function __okHandler(_arg1:MouseEvent=null):void{
            okFun(nameTF.text);
        }
        private function initView():void{
            setSize(186, 128);
            x = 430;
            y = 150;
            titleText = LanguageMgr.GetTranslation("添加好友");
            centerTitle = true;
            blackGound = false;
            showCancel = false;
            _bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("AddFriendAsset");
            _bg.x = 4;
            _bg.y = 31;
            okLabel = LanguageMgr.GetTranslation("添加");
            cancelLabel = LanguageMgr.GetTranslation("取消");
            nameTF = _bg.nameTF;
            nameTF.text = "";
            nameTF.maxChars = 8;
            addContent(_bg);
            nameTF.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
        override public function close():void{
            super.close();
            dispose();
        }
        private function addEvents():void{
            okFunction = __okHandler;
            UIUtils.addFocusLis(nameTF);
        }
        private function onKeyUp(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.ENTER){
                if (okBtn){
                    okBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                };
                _arg1.stopImmediatePropagation();
            };
            _arg1.stopPropagation();
        }
        override public function dispose():void{
            removeEvents();
            super.dispose();
        }

    }
}//package GameUI.Modules.Friend.view.ui 
