//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import flash.utils.*;

    public class FacePlayController implements IUpdateable {

        private static var _instance:FacePlayController = null;

        private var enabled:Boolean = true;
        private var faceDataDic:Dictionary;
        private var faceAnimList:Array;

        public function FacePlayController(){
            faceDataDic = new Dictionary();
            super();
            faceAnimList = new Array();
        }
        public static function getInstance():FacePlayController{
            if (_instance == null){
                _instance = new (FacePlayController)();
                GameCommonData.GameInstance.GameUI.Elements.Add(_instance);
            };
            return (_instance);
        }

        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function get Enabled():Boolean{
            return (enabled);
        }
        public function addToList(_arg1:String, _arg2:uint, _arg3:MovieClip):SkillAnimation{
            var _local5:GameSkillData;
            var _local4:SkillAnimation = new SkillAnimation();
            if (faceDataDic[_arg1]){
                (faceDataDic[_arg1] as GameSkillData).SetAnimationData(_local4);
            } else {
                _local5 = new GameSkillData(_local4);
                _local5.Analyze(_arg3);
                faceDataDic[_arg1] = _local5;
            };
            _local4.guid = _arg2;
            faceAnimList.push(_local4);
            return (_local4);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        public function removeFromList(_arg1:uint):void{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < faceAnimList.length) {
                if (_arg1 == faceAnimList[_local2].guid){
                    faceAnimList.splice(_local2, 1);
                    break;
                };
                _local2++;
            };
        }
        public function Update(_arg1:GameTime):void{
            var _local2:uint;
            _local2 = 0;
            while (_local2 < faceAnimList.length) {
                (faceAnimList[_local2] as SkillAnimation).Update(_arg1);
                _local2++;
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }

    }
}//package Manager 
