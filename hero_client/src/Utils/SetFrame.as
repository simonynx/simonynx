//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.display.*;

    public class SetFrame {

        public static function RemoveFrame(_arg1:DisplayObjectContainer, _arg2:String="YellowFrame"):void{
            if ((((_arg1 == null)) || ((_arg1.numChildren == 0)))){
                return;
            };
            if (_arg1.getChildByName(_arg2)){
                _arg1.removeChild(_arg1.getChildByName(_arg2));
            };
        }
        public static function UseFrame2(_arg1:DisplayObject, _arg2:String="YellowFrame", _arg3:int=0, _arg4:int=0, _arg5:int=53, _arg6:int=53):void{
            var _local7:MovieClip;
            if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary) == null){
                if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple)){
                    _local7 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple).GetClassByMovieClip(_arg2);
                };
            } else {
                _local7 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(_arg2);
            };
            if (_local7 == null){
                return;
            };
            if (_local7.getChildByName(_arg2)){
                return;
            };
            _local7.name = _arg2;
            _arg1.parent.addChild(_local7);
            _arg1.parent.setChildIndex(_local7, (_arg1.parent.numChildren - 1));
            _local7.x = (_arg1.x + _arg3);
            _local7.y = (_arg1.y + _arg4);
            _local7.width = _arg5;
            _local7.height = _arg6;
        }
        public static function UseFrame(_arg1:DisplayObject, _arg2:String="YellowFrame"):void{
            var _local3:MovieClip;
            if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary) == null){
                if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple)){
                    _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple).GetClassByMovieClip(_arg2);
                };
            } else {
                _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(_arg2);
            };
            if (_local3 == null){
                return;
            };
            _local3.name = _arg2;
            _local3.mouseEnabled = false;
            _local3.mouseChildren = false;
            _arg1.parent.addChild(_local3);
            _arg1.parent.setChildIndex(_local3, (_arg1.parent.numChildren - 1));
            _local3.x = _arg1.x;
            _local3.y = _arg1.y;
        }

    }
}//package Utils 
