//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Equipment.mediator {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;

    public class CommonView {

        public var btn_help:HLabelButton;
        private var _sprite:Sprite;
        private var helpFrame:HFrame;
        private var helpText:TextField;
        private var _type:String;

        public function CommonView(_arg1:Sprite, _arg2:String){
            _sprite = _arg1;
            _type = _arg2;
            initView();
        }
        private function setTextContent():void{
            if (helpText.text == ""){
                helpFrame.titleText = (GameCommonData.HelpConfigItems[_type].Title as String);
                helpText.text = (GameCommonData.HelpConfigItems[_type].Text as String);
            };
        }
        protected function onHelpHandler(_arg1:MouseEvent):void{
            if (GameCommonData.GameInstance.GameUI.contains(helpFrame)){
                GameCommonData.GameInstance.GameUI.removeChild(helpFrame);
            } else {
                setTextContent();
                GameCommonData.GameInstance.GameUI.addChild(helpFrame);
            };
        }
        private function initView():void{
            var _local1:HLabelButton;
            btn_help = new HLabelButton();
            btn_help.name = "btn_help";
            btn_help.textField.mouseEnabled = false;
            btn_help.label = LanguageMgr.GetTranslation("帮助");
            btn_help.x = 265;
            btn_help.y = 340;
            _sprite.addChild(btn_help);
            btn_help.visible = false;
            helpFrame = new HFrame();
            helpFrame.setSize(300, 400);
            helpFrame.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - (helpFrame.width / 2));
            helpFrame.y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (helpFrame.height / 2));
            helpFrame.closeCallBack = closeHelpPanel;
            btn_help.addEventListener(MouseEvent.CLICK, onHelpHandler);
            helpFrame.showClose = true;
            helpFrame.centerTitle = true;
            helpFrame.blackGound = true;
            _local1 = new HLabelButton();
            _local1.name = "btn_help";
            _local1.textField.mouseEnabled = false;
            _local1.label = LanguageMgr.GetTranslation("确定");
            _local1.x = (150 - (_local1.width / 2));
            _local1.y = 360;
            helpFrame.addChild(_local1);
            _local1.addEventListener(MouseEvent.CLICK, closePanel);
            var _local2:TextFormat = new TextFormat();
            _local2.size = 13;
            _local2.color = 0xFFFFFF;
            helpText = new TextField();
            helpText.multiline = true;
            helpText.wordWrap = true;
            helpText.mouseEnabled = false;
            helpText.width = 280;
            helpText.x = 10;
            helpText.y = 40;
            helpText.height = 350;
            helpText.defaultTextFormat = _local2;
            helpFrame.addChild(helpText);
        }
        protected function closeHelpPanel():void{
            if (GameCommonData.GameInstance.GameUI.contains(helpFrame)){
                GameCommonData.GameInstance.GameUI.removeChild(helpFrame);
            };
        }
        private function closePanel(_arg1:MouseEvent):void{
            closeHelpPanel();
        }

    }
}//package GameUI.Modules.Equipment.mediator 
