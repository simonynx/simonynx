//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content {
    import flash.utils.*;
    import OopsFramework.Content.Provider.*;

    public class ContentManager {

        public var LocalDirectory:String = "";
        public var RootDirectory:String = "";
        private var loadedAssets:Dictionary;
        private var resourceProviders:Array;

        public function ContentManager(){
            this.resourceProviders = [];
            this.loadedAssets = new Dictionary();
        }
        public function Load(_arg1:String):ContentTypeReader{
            var _local2:int;
            var _local3:IResourceProvider;
			
            var _local4:* = this.loadedAssets[(this.RootDirectory + _arg1)];
			trace("*****************"+_local4);
            if (_local4 == null){
                _local2 = 0;
                while (_local2 < this.resourceProviders.length) {
                    _local3 = (this.resourceProviders[_local2] as IResourceProvider);
                    if (_local3 != null){
                        if (((_local3.IsLoaded) && (_local3.IsResourceExist((this.RootDirectory + _arg1))))){
                            this.loadedAssets[(this.RootDirectory + _arg1)] = _local3.GetResource((this.RootDirectory + _arg1));
                            _local4 = this.loadedAssets[(this.RootDirectory + _arg1)];
                        };
                    };
                    _local2++;
                };
            };
            return ((_local4 as ContentTypeReader));
        }
        public function get CacheResource():Dictionary{
            return (this.loadedAssets);
        }
        public function get ResourceProviders():Array{
            return (this.resourceProviders);
        }
        public function UnLoad(_arg1:String):void{
            var _local2:int;
            var _local3:IResourceProvider;
            var _local4:* = this.loadedAssets[(this.RootDirectory + _arg1)];
            if (_local4 != null){
                delete this.loadedAssets[(this.RootDirectory + _arg1)];
                _local2 = 0;
                while (_local2 < this.resourceProviders.length) {
                    _local3 = (this.resourceProviders[_local2] as IResourceProvider);
                    if (_local3 != null){
                        if (((_local3.IsLoaded) && (_local3.IsResourceExist((this.RootDirectory + _arg1))))){
                            _local3.RemoveResource((this.RootDirectory + _arg1));
                        };
                    };
                    _local2++;
                };
            };
        }

    }
}//package OopsFramework.Content 
