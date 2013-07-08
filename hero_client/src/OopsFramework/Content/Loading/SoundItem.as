//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.media.*;

	/**
	 *加载声音类 
	 * @author wengliqiang
	 * 
	 */	
    public class SoundItem extends LoadingItem {

        public var loader:Sound;

        public function SoundItem(_arg1:String, _arg2:String, _arg3:String){
            super(_arg1, _arg2, _arg3);
        }
        override public function onErrorHandler(_arg1:ErrorEvent):void{
            super.onErrorHandler(_arg1);
        }
        override public function onCompleteHandler(_arg1:Event):void{
            content = loader;
            super.onCompleteHandler(_arg1);
        }
        override public function isStreamable():Boolean{
            return (true);
        }
        override public function load():void{
            try {
                super.load();
                loader = new Sound();
                loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
                loader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
                loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
                loader.addEventListener(Event.OPEN, onStartedHandler, false, 0, true);
                loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false, 0, true);
                loader.load(urlRequest, context);
            } catch(e:SecurityError) {
            };
        }
        override public function onStartedHandler(_arg1:Event):void{
            content = loader;
            super.onStartedHandler(_arg1);
        }
        override public function destroy():void{
            cleanListeners();
            stop();
            content = null;
            loader = null;
        }
        override public function isSound():Boolean{
            return (true);
        }
        override protected function cleanListeners():void{
            if (loader){
                loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler, false);
                loader.removeEventListener(Event.COMPLETE, onCompleteHandler, false);
                loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                loader.removeEventListener(Event.OPEN, onStartedHandler, false);
                loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler, false);
            };
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

    }
}//package OopsFramework.Content.Loading 
