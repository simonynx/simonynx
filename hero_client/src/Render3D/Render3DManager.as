//Created by Action Script Viewer - http://www.buraks.com/asv
package Render3D {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Scene.StrategyElement.*;

    public class Render3DManager {

        private static var _instance:Render3DManager;

        public var m_isinited = false;
        public var m_renderbitmap:Bitmap = null;

        public static function getInstance():Render3DManager{
            if (!_instance){
                _instance = new (Render3DManager)();
            };
            return (_instance);
        }

        public function RemoveAnimation(_arg1:uint){
        }
        public function Init3D(_arg1:Stage){
        }
        public function AddAnimation(_arg1:uint, _arg2:GameElementAnimal){
        }
        public function SetSceneOffset(_arg1:int, _arg2:int){
        }
        public function OnRender(_arg1:Event){
        }
        public function Render(_arg1:BitmapData=null){
        }
        public function RemoveMap(_arg1:String){
        }
        public function AddMap(_arg1:String, _arg2:BitmapData, _arg3:int, _arg4:int){
        }

    }
}//package Render3D 
