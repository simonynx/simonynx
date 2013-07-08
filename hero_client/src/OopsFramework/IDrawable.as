//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {

	/**
	 *可绘制的 
	 * @author wengliqiang
	 * 
	 */	
    public interface IDrawable {

        function get DrawOrder():int;
        function get Visible():Boolean;
        function set VisibleChanged(_arg1:Function):void;
        function get VisibleChanged():Function;
        function get DrawOrderChanged():Function;
        function set DrawOrderChanged(_arg1:Function):void;

    }
}//package OopsFramework 
