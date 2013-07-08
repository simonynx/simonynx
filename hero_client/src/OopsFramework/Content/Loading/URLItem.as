//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *HTTP请求类加载 
	 * @author wengliqiang
	 * 
	 */	
    public class URLItem extends LoadingItem {

        public var loader:URLLoader;

        public function URLItem(_arg1:String, _arg2:String, _arg3:String){
            super(_arg1, _arg2, _arg3);
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
        override public function load():void{
            super.load();
            loader = new URLLoader();
            loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, super.onErrorHandler, false, 0, true);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
            try {
                loader.load(urlRequest);
            } catch(e:SecurityError) {
                super.onSecurityErrorHandler(createErrorEvent(e));
            };
        }
        override protected function cleanListeners():void{
            if (loader){
                loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                loader.removeEventListener(Event.OPEN, onStartedHandler, false);
                loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            };
        }
        override public function isText():Boolean{
            return (true);
        }
        override public function onStartedHandler(_arg1:Event):void{
            super.onStartedHandler(_arg1);
        }
        override public function onCompleteHandler(_arg1:Event):void{
            content = loader.data;
			trace("loader.data============================="+loader.data);
            super.onCompleteHandler(_arg1);
        }
        override public function destroy():void{
            stop();
            cleanListeners();
            content = null;
            loader = null;
        }

    }
}//package OopsFramework.Content.Loading 
