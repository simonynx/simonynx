//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {
    import OopsFramework.Collections.*;
    import OopsFramework.Exception.*;

	/**
	 *游戏组件收集器 
	 * @author wengliqiang
	 * 
	 */	
    public class GameComponentCollection extends ArrayCollection {

        override public function Add(_arg1):void{
            var _local2:int = this.IndexOf(_arg1);
            if (_local2 != -1){
                throw (new ArgumentError(ExceptionResources.CannotAddSameComponent));
            };
            if ((_arg1 is IGameComponent) == false){
                throw (new ArgumentError("添加项必须为 IGameComponent 类型对象"));
            };
            super.Add(_arg1);
        }

    }
}//package OopsFramework 
