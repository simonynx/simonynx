//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.net.*;

	/**
	 *视频加载类 
	 * @author wengliqiang
	 * 
	 */	
    public class VideoItem extends LoadingItem {

        public var stream:NetStream;
        public var dummyEventTrigger:Sprite;
        public var pausedAtStart:Boolean;
        public var _metaData:Object;
        public var _canBeginStreaming:Boolean;
        private var nc:NetConnection;
        public var _checkPolicyFile:Boolean;

        public function VideoItem(_arg1:String, _arg2:String, _arg3:String){
            super(_arg1, _arg2, _arg3);
            bytesTotal = (bytesLoaded = 0);
        }
        override protected function cleanListeners():void{
            if (stream){
                stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false);
                stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
            };
            if (dummyEventTrigger){
                dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, createNetStreamEvent, false);
                dummyEventTrigger = null;
            };
        }
        override public function onStartedHandler(_arg1:Event):void{
            content = stream;
            if (((pausedAtStart) && (stream))){
                stream.pause();
            };
            super.onStartedHandler(_arg1);
        }
        override public function stop():void{
            try {
                if (stream){
                    stream.close();
                };
            } catch(e:Error) {
            };
            super.stop();
        }
        private function fireCanBeginStreamingEvent():void{
            if (_canBeginStreaming){
                return;
            };
            _canBeginStreaming = true;
            var _local1:Event = new Event(BulkLoader.CAN_BEGIN_PLAYING);
            dispatchEvent(_local1);
        }
        public function get metaData():Object{
            return (_metaData);
        }
        function onNetStatus(_arg1:NetStatusEvent):void{
            var _local2:Event;
            if (!stream){
                return;
            };
            stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
            if (_arg1.info.code == "NetStream.Play.Start"){
                content = stream;
                _local2 = new Event(Event.OPEN);
                onStartedHandler(_local2);
            } else {
                if (_arg1.info.code == "NetStream.Play.StreamNotFound"){
                    onErrorHandler(createErrorEvent(new Error(("[VideoItem] NetStream not found at " + this.url))));
                };
            };
        }
        override public function isStreamable():Boolean{
            return (true);
        }
        override public function load():void{
            super.load();
            nc = new NetConnection();
            nc.connect(null);
            stream = new NetStream(nc);
            stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
            dummyEventTrigger = new Sprite();
            dummyEventTrigger.addEventListener(Event.ENTER_FRAME, createNetStreamEvent, false, 0, true);
            var customClient:* = new Object();
            customClient.onCuePoint = function (... _args):void{
            };
            customClient.onMetaData = onVideoMetadata;
            customClient.onPlayStatus = function (... _args):void{
            };
            stream.client = customClient;
            try {
                stream.play(urlRequest, _checkPolicyFile);
            } catch(e:SecurityError) {
                super.onSecurityErrorHandler(createErrorEvent(e));
            };
            stream.seek(0);
        }
        public function get canBeginStreaming():Boolean{
            return (_canBeginStreaming);
        }
        function onVideoMetadata(_arg1:Object):void{
            _metaData = _arg1;
        }
        override public function onCompleteHandler(_arg1:Event):void{
            content = stream;
            super.onCompleteHandler(_arg1);
        }
        public function get checkPolicyFile():Object{
            return (_checkPolicyFile);
        }
        override public function isVideo():Boolean{
            return (true);
        }
        public function createNetStreamEvent(_arg1:Event):void{
            var _local2:Event;
            var _local3:Event;
            var _local4:ProgressEvent;
            var _local5:int;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            if ((((bytesTotal == bytesLoaded)) && ((bytesTotal > 8)))){
                if (dummyEventTrigger){
                    dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, createNetStreamEvent, false);
                };
                fireCanBeginStreamingEvent();
                _local2 = new Event(Event.COMPLETE);
                onCompleteHandler(_local2);
            } else {
                if ((((((bytesTotal == 0)) && (stream))) && ((stream.bytesTotal > 4)))){
                    _local3 = new Event(Event.OPEN);
                    onStartedHandler(_local3);
                    bytesLoaded = stream.bytesLoaded;
                    bytesTotal = stream.bytesTotal;
                } else {
                    if (stream){
                        _local4 = new ProgressEvent(ProgressEvent.PROGRESS, false, false, stream.bytesLoaded, stream.bytesTotal);
                        if (((((isVideo()) && (metaData))) && (!(_canBeginStreaming)))){
                            _local5 = (getTimer() - responseTime);
                            if (_local5 > 100){
                                _local6 = (bytesLoaded / (_local5 / 1000));
                                bytesRemaining = (bytesTotal - bytesLoaded);
                                _local7 = (bytesRemaining / (_local6 * 0.8));
                                _local8 = (metaData.duration - stream.bufferLength);
                                if (_local8 > _local7){
                                    fireCanBeginStreamingEvent();
                                };
                            };
                        };
                        super.onProgressHandler(_local4);
                    };
                };
            };
        }
        override public function destroy():void{
            if (stream){
            };
            stop();
            cleanListeners();
            stream = null;
            super.destroy();
        }

    }
}//package OopsFramework.Content.Loading 
