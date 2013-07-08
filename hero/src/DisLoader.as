//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.net.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.display.*;
    import flash.system.*;

    public class DisLoader extends Loader {

        private var _bytesLoader:URLLoader;
        public var isSuccess:Boolean;
        public var paras:Object;
        private var _starting:Boolean;
        private var _func:Function;
        private var _tryTime:int;
        protected var _url:URLRequest;
        private var _hadTryTime:int;

        public function DisLoader(string:String, object:Object=null){
            super();
            this._url = new URLRequest(string);
            this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__completed);
            this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__error);
            this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__error);
            this.isSuccess = false;
            this._hadTryTime = 0;
            this.paras = object;
        }
        protected function onError(myEvent:Event):void{
            trace("Load error:", this._url.url);
        }
        public function dispose():void{
            this.cancel();
            this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.__completed);
            this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.__error);
            this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__error);
            if (this._bytesLoader){
                this._bytesLoader.removeEventListener(Event.COMPLETE, this.__bytesLoadComplete);
                this._bytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.__error);
                this._bytesLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__error);
                this._bytesLoader.removeEventListener(ProgressEvent.PROGRESS, this.__progress);
            };
            this._func = null;
            unload();
        }
        protected function onCanceled():void{
        }
        public function loadSync(func:Function=null, tryTime:int=1):void{
            if (!(this._starting)){
                if (func != null){
                    this._func = func;
                    this._tryTime = tryTime;
                };
                this.load(this._url);
            };
        }
        public function get callBack():Function{
            return (this._func);
        }
        public function get tryTime():int{
            return (this._tryTime);
        }
        private function __bytesLoadComplete(event:Event):void{
            LoadingManager.cacheFile(this._url.url, (this._bytesLoader.data as ByteArray), true);
            this.OnBytesLoaded((this._bytesLoader.data as ByteArray));
            this._bytesLoader = null;
        }
        private function OnBytesLoaded(bytes:ByteArray){
            if (((((!((bytes[0] == 67))) || (!((bytes[1] == 87))))) || (!((bytes[2] == 83))))){
                //bytes = LoadingManager.decry(bytes);
				bytes = LoadingManager.asdecry(bytes);
                trace("解密model", bytes[0], bytes[1], bytes[2], bytes[3]);
            };
            loadBytes(bytes);
        }
        private function __completed(myEvent:Event):void{
            this._starting = false;
            this.isSuccess = true;
            this.onCompleted();
            if (this._func != null){
                this._func(this);
            };
        }
        protected function onCompleted():void{
        }
        override public function load(urlrequest:URLRequest, loaderContext:LoaderContext=null):void{
            this._starting = true;
            this._hadTryTime++;
            var localbytes:* = LoadingManager.loadCachedFile(urlrequest.url, true);
            if (localbytes){
                this.OnBytesLoaded(localbytes);
            } else {
                urlrequest.data = new URLVariables();
                urlrequest.data["lv"] = LoadingManager.Version;
                this._bytesLoader = new URLLoader();
                this._bytesLoader.dataFormat = URLLoaderDataFormat.BINARY;
                this._bytesLoader.addEventListener(Event.COMPLETE, this.__bytesLoadComplete);
                this._bytesLoader.addEventListener(IOErrorEvent.IO_ERROR, this.__error);
                this._bytesLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__error);
                this._bytesLoader.addEventListener(ProgressEvent.PROGRESS, this.__progress);
                this._bytesLoader.load(urlrequest);
            };
        }
        private function __progress(e:ProgressEvent){
            dispatchEvent(e);
        }
        public function __error(myEvent:Event):void{
            var myEvent:* = myEvent;
            var event:* = myEvent;
            try {
                if (this._tryTime == this._hadTryTime){
                    this._starting = false;
                    this.isSuccess = false;
                    this.onError(event);
                    if (this._func != null){
                        this._func(this);
                    };
                } else {
                    this.load(this._url);
                };
            } catch(err:Error) {
                trace(err.message);
                trace(err.getStackTrace());
            };
        }
        override public function close():void{
            this._starting = false;
            if (this._bytesLoader){
                this._bytesLoader.removeEventListener(Event.COMPLETE, this.__bytesLoadComplete);
                this._bytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.__error);
                this._bytesLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__error);
                this._bytesLoader.removeEventListener(ProgressEvent.PROGRESS, this.__progress);
                this._bytesLoader.close();
            };
        }
        public function cancel():void{
            if (this._starting){
                this.close();
            };
            this.onCanceled();
        }
        public function isStarted():Boolean{
            return (this._starting);
        }

    }
}//package 
