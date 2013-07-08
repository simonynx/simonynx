//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.Modules.ScreenMessage.Date.*;

    public class MsgButton extends Sprite {

        private static var instance:MsgButton;

        private var openbtn:SimpleButton;
        private var closebtn:SimpleButton;

        public function MsgButton(){
            init();
            initEvent();
            super();
        }
        public static function get Instance():MsgButton{
            if (instance == null){
                instance = new (MsgButton)();
            };
            return (instance);
        }

        private function init():void{
            openbtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("OpenButton");
            this.addChild(openbtn);
            openbtn.name = "msgButton";
            closebtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseButton");
            this.addChild(closebtn);
            closebtn.visible = false;
        }
        private function onOpenHandler(_arg1:MouseEvent):void{
            openbtn.visible = false;
            closebtn.visible = true;
            UIFacade.GetInstance().sendNotification(ScreenMessageEvent.OPEN_MESSAGE);
        }
        public function setVisible():void{
            openbtn.visible = true;
            closebtn.visible = false;
        }
        public function setPos():void{
            this.x = (GameCommonData.GameInstance.ScreenWidth - 40);
            this.y = (GameCommonData.GameInstance.ScreenHeight - 130);
        }
        private function initEvent():void{
            openbtn.addEventListener(MouseEvent.CLICK, onOpenHandler);
            closebtn.addEventListener(MouseEvent.CLICK, onCloseHandler);
        }
        public function show():void{
            GameCommonData.GameInstance.GameUI.addChild(this);
            this.x = (GameCommonData.GameInstance.ScreenWidth - 40);
            this.y = (GameCommonData.GameInstance.ScreenHeight - 130);
        }
        private function onCloseHandler(_arg1:MouseEvent):void{
            openbtn.visible = true;
            closebtn.visible = false;
            UIFacade.GetInstance().sendNotification(ScreenMessageEvent.CLOSE_MESSAGE);
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
