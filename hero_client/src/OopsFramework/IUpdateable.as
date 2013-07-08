//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {

	/**
	 *更新接口 
	 * @author wengliqiang
	 * 
	 */	
    public interface IUpdateable {

        function get Enabled():Boolean;
        function get EnabledChanged():Function;
        function get UpdateOrder():int;
        function set EnabledChanged(_arg1:Function):void;
        function Update(_arg1:GameTime):void;
        function set UpdateOrderChanged(_arg1:Function):void;
        function get UpdateOrderChanged():Function;

    }
}//package OopsFramework 
