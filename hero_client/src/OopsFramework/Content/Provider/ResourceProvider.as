//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Provider {
    import OopsFramework.*;
    import OopsFramework.Content.*;
    import flash.utils.*;

	/**
	 *数据源提供器 
	 * @author wengliqiang
	 * 
	 */	
    public class ResourceProvider implements IResourceProvider {

        protected var resources:Dictionary;
        protected var isLoaded:Boolean = false;
        private var game:Game;
        public var LoadComplete:Function = null;

        public function ResourceProvider(_arg1:Game=null){
            if (_arg1 != null){
                this.game = _arg1;
                this.game.Content.ResourceProviders.push(this);
            };
            resources = new Dictionary();
        }
        public function get Games():Game{
            return (this.game);
        }
        public function IsResourceExist(_arg1:String):Boolean{
            return (!((resources[_arg1] == null)));
        }
        public function GetResource(_arg1:String):ContentTypeReader{
            return ((resources[_arg1] as ContentTypeReader));
        }
        protected function addResource(_arg1:ContentTypeReader):void{
            resources[_arg1.Name] = _arg1;
        }
        public function Load():void{
        }
        public function get IsLoaded():Boolean{
            return (this.isLoaded);
        }
        public function RemoveResource(_arg1:String):void{
            delete resources[_arg1];
        }

    }
}//package OopsFramework.Content.Provider 
