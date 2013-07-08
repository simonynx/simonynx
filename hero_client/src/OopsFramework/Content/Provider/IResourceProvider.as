//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Provider {
    import OopsFramework.Content.*;

	/**
	 *数据源接口 
	 * @author wengliqiang
	 * 
	 */	
    public interface IResourceProvider {

        function RemoveResource(_arg1:String):void;
        function GetResource(_arg1:String):ContentTypeReader;
        function get IsLoaded():Boolean;
        function IsResourceExist(_arg1:String):Boolean;

    }
}//package OopsFramework.Content.Provider 
