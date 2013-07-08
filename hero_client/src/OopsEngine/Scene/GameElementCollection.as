//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import OopsFramework.Collections.*;
    import OopsFramework.Exception.*;

    public class GameElementCollection extends ArrayCollection {

        override public function Add(_arg1):void{
            var _local2:int = this.IndexOf(_arg1);
            if (_local2 != -1){
                throw (new ArgumentError(ExceptionResources.CannotAddSameComponent));
            };
            if ((_arg1 is GameElement) == false){
                throw (new ArgumentError(ExceptionResources.GameElementCollection));
            };
            super.Add(_arg1);
        }

    }
}//package OopsEngine.Scene 
