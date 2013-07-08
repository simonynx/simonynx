//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *二进制加载类 
	 * @author wengliqiang
	 * 
	 */	
    public class BinaryItem extends LoadingItem {

        public var loader:URLLoader;

        public function BinaryItem(_arg1:String, _arg2:String, _arg3:String){
            super(_arg1, _arg2, _arg3);
        }
        override public function onErrorHandler(_arg1:ErrorEvent):void{
            super.onErrorHandler(_arg1);
        }
        override public function onCompleteHandler(_arg1:Event):void{
            content = _arg1.target.data;
			trace("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            if ((content is ByteArray)){
                if (((((content as ByteArray)[0] == 120)) && (((content as ByteArray)[1] == 156)))){
                    (content as ByteArray).uncompress();
                };
            };
            super.onCompleteHandler(_arg1);
        }
        override public function load():void{
            super.load();
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
            try {
				trace("-----"+urlRequest.url);
                loader.load(urlRequest);
            } catch(e:SecurityError) {
                onSecurityErrorHandler(createErrorEvent(e));
            };
        }
        override protected function cleanListeners():void{
            if (loader){
                loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                loader.removeEventListener(Event.OPEN, onStartedHandler, false);
                loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
            };
        }
        override public function onStartedHandler(_arg1:Event):void{
            super.onStartedHandler(_arg1);
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
        override public function destroy():void{
            stop();
            cleanListeners();
            content = null;
            loader = null;
        }

    }
}//package OopsFramework.Content.Loading 
