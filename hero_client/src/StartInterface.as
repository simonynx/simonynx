//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.net.*;
    import Utils.*;
    import flash.system.*;
    import flash.ui.*;

    public class StartInterface extends Sprite {

        private function ShowContextMenu1(_arg1:Sprite, _arg2:String):void{
            var _local4:ContextMenuItem;
            _arg1.stage.showDefaultContextMenu = false;
            var _local3:ContextMenu = new ContextMenu();
            _local3.hideBuiltInItems();
            _local4 = new ContextMenuItem("英雄王座");
            _local3.customItems.push(_local4);
            _local4 = new ContextMenuItem("白鲸工作室");
            _local3.customItems.push(_local4);
            _local4 = new ContextMenuItem("版本:v3.72.2012.02.14");
            _local3.customItems.push(_local4);
            _local4 = new ContextMenuItem("广州菲音版权所有");
            _local3.customItems.push(_local4);
            _local4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toFeiyin);
            _arg1.contextMenu = _local3;
        }
        public function Run(_arg1:Sprite, _arg2:Object):void{
            Security.allowDomain("*");
            var _local3:MyGame = new MyGame(_arg1.stage, _arg2);
            if (((!((_arg2 == null))) && (!((String(_arg2.LocalURL).indexOf("3663") == -1))))){
                _arg1.stage.showDefaultContextMenu = false;
            } else {
                ShowContextMenu1(_arg1, GameConfigData.CurrentServer);
            };
            _arg1.addChild(_local3);
            if (Capabilities.isDebugger){
                _arg1.addChild(new FPS());
            };
        }
        public function HelpFun(_arg1:ContextMenuEvent):void{
            UIFacade.GetInstance().openHelpView();
        }
        private function toFeiyin(_arg1:ContextMenuEvent):void{
            navigateToURL(new URLRequest("http://www.xunwan.com"), "_blank");
        }

    }
}//package 
