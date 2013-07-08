//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Stall.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.Modules.Stall.Data.*;

    public class StallSkinManager {

        private static var _instance:StallSkinManager;

        public function StallSkinManager(_arg1:Singleton){
            if (!_arg1){
                throw (new Error("Error getting stallSkin"));
            };
        }
        public static function getInstance():StallSkinManager{
            if (!_instance){
                _instance = new StallSkinManager(new Singleton());
            };
            return (_instance);
        }

        public function getStallSkin(_arg1:int):MovieClip{
            if (_arg1 == 0){
                return (null);
            };
            var _local2:* = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("StallSkin");
            _local2.tabEnabled = false;
            _local2.tabChildren = false;
            _local2.txtStallName.mouseEnabled = false;
            _local2.name = ("stallSkin_" + _arg1);
            _local2.addEventListener(MouseEvent.ROLL_OVER, overHandler);
            _local2.addEventListener(MouseEvent.ROLL_OUT, outHandler);
            _local2.addEventListener(MouseEvent.MOUSE_DOWN, skinClickHandler);
            _local2.gotoAndStop(1);
            return (_local2);
        }
        private function outHandler(_arg1:MouseEvent):void{
            var _local2:* = (_arg1.currentTarget.name as String).split("_")[1];
            _arg1.currentTarget.gotoAndStop(2);
        }
        private function overHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.gotoAndStop(1);
        }
        private function skinClickHandler(_arg1:MouseEvent):void{
            _arg1.stopPropagation();
            GameCommonData.Scene.PlayerStop();
            var _local2:* = (_arg1.currentTarget.name as String).split("_")[1];
            UIFacade.GetInstance().selectStall(_local2);
            _arg1.currentTarget.gotoAndStop(2);
        }

    }
}//package GameUI.Modules.Stall.UI 

class Singleton {

    public function Singleton(){
    }
}
