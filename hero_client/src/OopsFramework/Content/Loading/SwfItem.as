//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *SWF加载类 
	 * @author wengliqiang
	 * 
	 */	
    public class SwfItem extends LoadingItem {

        public var loader:Loader;
        public var swfloader:URLLoader;

        public function SwfItem(_arg1:String, _arg2:String, _arg3:String){
            super(_arg1, _arg2, _arg3);
        }
        override public function onErrorHandler(_arg1:ErrorEvent):void{
            super.onErrorHandler(_arg1);
        }
        override public function stop():void{
            try {
                if (swfloader){
                    swfloader.close();
                };
            } catch(e:Error) {
            };
            super.stop();
        }
        private function onBytesComplete(_arg1:Event):void{
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, false);
            loader.loadBytes(_arg1.target.data, context);
        }
        override public function onStartedHandler(_arg1:Event):void{
            super.onStartedHandler(_arg1);
        }
        override public function destroy():void{
            stop();
            cleanListeners();
            content = null;
            loader = null;
            swfloader = null;
        }
        override public function load():void{
            super.load();
            swfloader = new URLLoader();
            swfloader.dataFormat = URLLoaderDataFormat.BINARY;
            swfloader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            swfloader.addEventListener(Event.COMPLETE, onBytesComplete, false, 0, false);
            swfloader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            swfloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            swfloader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            swfloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
            try {
				trace("$$$$$$$$"+urlRequest.url);
                swfloader.load(urlRequest);
            } catch(e:SecurityError) {
                onSecurityErrorHandler(createErrorEvent(e));
            };
        }
        override public function onCompleteHandler(_arg1:Event):void{
            var evt:* = undefined;
            var _arg1:* = _arg1;
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
            evt = _arg1;
            try {
                content = loader.contentLoaderInfo;
            } catch(e:SecurityError) {
                content = null;
            };
            super.onCompleteHandler(evt);
        }
        override protected function cleanListeners():void{
            if (swfloader){
                swfloader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                swfloader.removeEventListener(Event.COMPLETE, onBytesComplete, false);
                swfloader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                swfloader.removeEventListener(Event.OPEN, onStartedHandler, false);
                swfloader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
                swfloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
            };
        }

    }
}//package OopsFramework.Content.Loading 
