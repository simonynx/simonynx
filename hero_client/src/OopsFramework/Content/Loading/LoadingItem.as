//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *加载基类 
	 * @author wengliqiang
	 * 
	 */	
    public class LoadingItem extends EventDispatcher {

        public static const STATUS_STOPPED:String = "stopped";
        public static const STATUS_WAIT:String = "wait";
        public static const STATUS_STARTED:String = "started";
        public static const STATUS_ERROR:String = "error";
        public static const STATUS_FINISHED:String = "finished";

        public var content;
        public var status:String;
        public var preventCache:Boolean;
        public var name:String;
        public var weightPercentLoaded:Number;
        public var maxTries:int = 3;
        public var bytesTotal:int = 0;
        public var httpStatus:int = -1;
        public var parsedURL:SmartURL;
        protected var urlRequest:URLRequest;
        public var percentLoaded:Number;
        public var priority:int = 0;
        public var responseTime:Number;
        public var context = null;
        public var numTries:int = 0;
        public var totalTime:int;
        public var type:String;
        public var speed:Number;
        public var bytesRemaining:int = 10000000;
        public var isLoaded:Boolean;
        public var bytesLoaded:int = 0;
        public var startTime:int;
        public var timeToDownload:Number;
        public var url:String;
        public var errorEvent:ErrorEvent;
        public var weight:int = 1;
        public var latency:Number;

        public function LoadingItem(_arg1:String, _arg2:String, _arg3:String){
            if (((!(_arg1)) || (!(String(_arg1))))){
                throw (new Error("[BulkLoader] 不能添加一个空的 URL 的项目"));
            };
            this.status = STATUS_WAIT;
            this.type = _arg2;
            this.name = _arg3;
            this.url = _arg1;
            urlRequest = new URLRequest(this.url);
            parsedURL = new SmartURL(_arg1);
        }
        public function stop():void{
            if (isLoaded){
                return;
            };
            status = STATUS_STOPPED;
        }
        public function isSound():Boolean{
            return (false);
        }
        public function onSecurityErrorHandler(_arg1:ErrorEvent):void{
            status = STATUS_ERROR;
            errorEvent = (_arg1 as ErrorEvent);
            dispatchErrorEvent(errorEvent);
            cleanListeners();
        }
        private function dispatchErrorEvent(_arg1:ErrorEvent):void{
            status = STATUS_ERROR;
            dispatchEvent(new ErrorEvent(BulkProgressEvent.ERROR, true, false, _arg1.text));
        }
        public function isXML():Boolean{
            return (false);
        }
        public function onCompleteHandler(_arg1:Event):void{
            status = STATUS_FINISHED;
            isLoaded = true;
            CalculateSpeed();
            dispatchEvent(_arg1);
            cleanListeners();
        }
        private function CalculateSpeed():void{
            totalTime = getTimer();
            timeToDownload = ((totalTime - responseTime) / 1000);
            if (timeToDownload == 0){
                timeToDownload = 0.1;
            };
            speed = BulkLoader.TruncateNumber(((bytesLoaded / 0x0400) / timeToDownload));
        }
        private function get humanFiriendlySize():String{
            var _local1:Number = (bytesTotal / 0x0400);
            if (_local1 < 0x0400){
                return ((int(_local1) + " kb"));
            };
            return (((_local1 / 0x0400).toPrecision(3) + " mb"));
        }
        protected function createErrorEvent(_arg1:Error):ErrorEvent{
            return (new ErrorEvent(BulkProgressEvent.ERROR, false, false, _arg1.message));
        }
        public function onErrorHandler(_arg1:ErrorEvent):void{
            numTries++;
            if (numTries < maxTries){
                status = null;
                load();
                _arg1.stopPropagation();
            } else {
                status = STATUS_ERROR;
                errorEvent = _arg1;
                dispatchErrorEvent(errorEvent);
                cleanListeners();
            };
        }
        public function onProgressHandler(_arg1:ProgressEvent):void{
            bytesLoaded = _arg1.bytesLoaded;
            bytesTotal = _arg1.bytesTotal;
            bytesRemaining = (bytesTotal - bytesLoaded);
            percentLoaded = (bytesLoaded / bytesTotal);
            weightPercentLoaded = (percentLoaded * weight);
            CalculateSpeed();
            dispatchEvent(_arg1);
        }
        public function isStreamable():Boolean{
            return (false);
        }
        public function onHttpStatusHandler(_arg1:HTTPStatusEvent):void{
            httpStatus = _arg1.status;
            dispatchEvent(_arg1);
        }
        public function isImage():Boolean{
            return (false);
        }
        public function get hostName():String{
            return (parsedURL.host);
        }
        public function isLoader():Boolean{
            return (false);
        }
        public function onStartedHandler(_arg1:Event):void{
            responseTime = getTimer();
            latency = BulkLoader.TruncateNumber(((responseTime - startTime) / 1000));
            status = STATUS_STARTED;
            dispatchEvent(_arg1);
        }
        public function getStats():String{
            return (((((((((((("Item url: " + url) + "(s), total time: ") + (totalTime / 1000).toPrecision(3)) + "(s), download time: ") + timeToDownload.toPrecision(3)) + "(s), latency:") + latency) + "(s), speed: ") + speed) + " kb/s, size: ") + humanFiriendlySize));
        }
        override public function toString():String{
            return (((((("LoadingItem 地址: " + url) + ", 文件类型:") + type) + ", 状态: ") + status));
        }
        public function load():void{
            var _local1:String;
            var _local2:String;
            if (preventCache){
                _local2 = ("Cache=" + getTimer());
                if (url.indexOf("?") == -1){
                    _local1 = ((this.url + "?") + _local2);
                } else {
                    _local1 = ((this.url + "&") + _local2);
                };
                urlRequest.url = _local1;
            };
            startTime = getTimer();
        }
        public function isVideo():Boolean{
            return (false);
        }
        protected function cleanListeners():void{
        }
        public function isText():Boolean{
            return (false);
        }
        public function destroy():void{
            content = null;
        }
        public function isSWF():Boolean{
            return (false);
        }

    }
}//package OopsFramework.Content.Loading 
