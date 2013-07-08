//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *图片加载类 
	 * @author wengliqiang
	 * 
	 */	
    public class ImageItem extends LoadingItem {

        public var loader:Loader;

        public function ImageItem(_arg1:String, _arg2:String, _arg3:String){
            super(_arg1, _arg2, _arg3);
        }
        override public function onErrorHandler(_arg1:ErrorEvent):void{
            super.onErrorHandler(_arg1);
        }
        override public function stop():void{
            try {
                if (loader){
                    loader.close();
                };
            } catch(e:Error) {
            };
            super.stop();
        }
        public function GetDefinitionByName(_arg1:String):Class{
            if (loader.contentLoaderInfo.applicationDomain.hasDefinition(_arg1)){
                return ((loader.contentLoaderInfo.applicationDomain.getDefinition(_arg1) as Class));
            };
            return (null);
        }
        override public function load():void{
            super.load();
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.INIT, onInitHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onErrorHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler);
            try {
                loader.load(urlRequest, context);
            } catch(e:SecurityError) {
                super.onSecurityErrorHandler(createErrorEvent(e));
            };
        }
        override public function isImage():Boolean{
            return ((type == BulkLoader.TYPE_IMAGE));
        }
        override public function onCompleteHandler(_arg1:Event):void{
            var evt:* = undefined;
            var _arg1:* = _arg1;
            evt = _arg1;
            try {
                content = loader.contentLoaderInfo;
            } catch(e:SecurityError) {
                content = null;
            };
            super.onCompleteHandler(evt);
        }
        override protected function cleanListeners():void{
            var _local1:Object;
            if (loader){
                _local1 = loader.contentLoaderInfo;
                _local1.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                _local1.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                _local1.removeEventListener(Event.INIT, onInitHandler, false);
                _local1.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                _local1.removeEventListener(IOErrorEvent.NETWORK_ERROR, onErrorHandler, false);
                _local1.removeEventListener(Event.OPEN, onStartedHandler, false);
                _local1.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            };
        }
        override public function isSWF():Boolean{
            return ((type == BulkLoader.TYPE_MOVIECLIP));
        }
        override public function destroy():void{
            stop();
            cleanListeners();
            content = null;
            loader = null;
        }
        public function onInitHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
        }

    }
}//package OopsFramework.Content.Loading 
