//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;
    import OopsFramework.*;
    import flash.utils.*;
    import OopsFramework.Debug.*;

	/**
	 *加载类（所有类型，管理各各种加载类） 有最大连接数
	 * @author wengliqiang
	 * 
	 */	
    public class BulkLoader extends EventDispatcher implements IDisposable {

        public static const AVAILABLE_TYPES:Array = [TYPE_VIDEO, TYPE_XML, TYPE_TEXT, TYPE_SOUND, TYPE_MOVIECLIP, TYPE_IMAGE, TYPE_BINARY];
        public static const CAN_BEGIN_PLAYING:String = "canBeginPlaying";
        public static const TYPE_VIDEO:String = "video";
        public static const TYPE_TEXT:String = "text";
        public static const TYPE_MOVIECLIP:String = "movieclip";
        public static const TYPE_BINARY:String = "binary";
        public static const TYPE_SOUND:String = "sound";
        public static const TYPE_XML:String = "xml";
        public static const TYPE_IMAGE:String = "image";

        public static var TYPE_CLASSES:Object = {
            image:ImageItem,
            movieclip:SwfItem,
            xml:XMLItem,
            video:VideoItem,
            sound:SoundItem,
            text:URLItem,
            binary:BinaryItem
        };
        public static var MOVIECLIP_EXTENSIONS:Array = ["swf"];
        public static var IMAGE_EXTENSIONS:Array = ["jpg", "jpeg", "gif", "png"];
        public static var XML_EXTENSIONS:Array = ["xml"];
        public static var AVAILABLE_EXTENSIONS:Array = ["swf", "jpg", "jpeg", "gif", "png", "flv", "mp3", "xml", "txt", "js"];
        public static var TEXT_EXTENSIONS:Array = ["txt", "js", "php", "asp", "py"];
        public static var SOUND_EXTENSIONS:Array = ["mp3", "f4a", "f4b"];
        public static var VIDEO_EXTENSIONS:Array = ["flv", "f4v", "f4p", "mp4"];

        private var items:Array;
        private var bytesLoaded:int = 0;
        private var maxConnections:int = 12;
        private var bytesTotal:int = 0;
        private var currentConnections:int = 0;
        public var CustomTypesExtensions:Dictionary;
        private var itemsTotal:int;
        private var itemsLoaded:int;
        private var itemsSpeed:Number = 0;
        private var dictItems:Dictionary;
        private var totalWeight:int;
        private var weightPercent:Number = 0;
        private var workItems:Array;

        public function BulkLoader(_maxConnections:int=1){
            dictItems = new Dictionary();
            items = new Array();
            workItems = new Array();
            CustomTypesExtensions = new Dictionary();
            super();
            this.maxConnections = _maxConnections;
        }
        public static function TruncateNumber(_arg1:Number, _arg2:int=2):Number{
            var _local3:int = Math.pow(10, _arg2);
            return ((Math.round((_arg1 * _local3)) / _local3));
        }

        public function Add(_arg1:String, _arg2:Boolean=false, _arg3:String=null, _arg4:int=1, _arg5:int=1):void{
            if ((((_arg3 == null)) || ((_arg3 == "")))){
                _arg3 = _arg1;
            };
            var _local6:LoadingItem = GetLoadingItem(_arg1);
            if (_local6){
                return;
            };
            var _local7:String = GuessType(_arg1);
			trace("type:"+_local7,_arg1);
            _local6 = new TYPE_CLASSES[_local7](_arg1, _local7, _arg3);
            _local6.preventCache = _arg2;
            _local6.weight = _arg4;
            _local6.addEventListener(BulkProgressEvent.OPEN, onOpen);
            _local6.addEventListener(BulkProgressEvent.COMPLETE, onComplete);
            _local6.addEventListener(BulkProgressEvent.PROGRESS, onProgress);
            _local6.addEventListener(BulkProgressEvent.ERROR, onItemError);
            _local6.priority = _arg5;
            items.push(_local6);
            workItems.push(_local6);
            dictItems[_local6.name] = _local6;
            totalWeight = (totalWeight + _local6.weight);
            itemsTotal++;
        }
        public function get ItemsTotal():int{
            return (this.itemsTotal);
        }
        public function Dispose():void{
            items.forEach(itemDispose);
        }
        public function Load():void{
            lazyLoad();
        }
        private function onOpen(_arg1:Event):void{
            var _local2:LoadingItem = (_arg1.target as LoadingItem);
            var _local3:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.OPEN);
            _local3.Item = _local2;
            _local3.BytesLoaded = bytesLoaded;
            _local3.BytesTotal = bytesTotal;
            _local3.ItemsLoaded = itemsLoaded;
            _local3.ItemsTotal = itemsTotal;
            _local3.ItemsSpeed = itemsSpeed;
            _local3.WeightPercent = weightPercent;
            dispatchEvent(_local3);
        }
        public function get workItem():int{
            return (workItems.length);
        }
        private function itemDispose(_arg1:LoadingItem, ... _args):void{
            _arg1.removeEventListener(BulkProgressEvent.OPEN, onOpen);
            _arg1.removeEventListener(BulkProgressEvent.COMPLETE, onComplete);
            _arg1.removeEventListener(BulkProgressEvent.PROGRESS, onProgress);
            _arg1.removeEventListener(BulkProgressEvent.ERROR, onItemError);
            _arg1.destroy();
        }
        private function onItemError(_arg1:ErrorEvent):void{
            currentConnections--;
            this.Load();
            var _local2:LoadingItem = (_arg1.target as LoadingItem);
            var _local3:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.ERROR);
            _local3.Item = _local2;
            _local3.BytesLoaded = bytesLoaded;
            _local3.BytesTotal = bytesTotal;
            _local3.ItemsLoaded = itemsLoaded;
            _local3.ItemsTotal = itemsTotal;
            _local3.ItemsSpeed = itemsSpeed;
            _local3.WeightPercent = weightPercent;
            _local3.ErrorMessage = _arg1.text;
            dispatchEvent(_local3);
            Logger.Error(this, "onItemError", _arg1.text);
        }
        public function RemoveItem(_arg1:String):Boolean{
            var _local3:uint;
            var _local2:LoadingItem = dictItems[_arg1];
            if (_local2 == null){
                return (false);
            };
            if (_local2.status != LoadingItem.STATUS_FINISHED){
                currentConnections--;
            };
            _local3 = items.indexOf(_local2);
            items.splice(_local3, 1);
            _local3 = workItems.indexOf(_local2);
            workItems.splice(_local3, 1);
            dictItems[_arg1] = null;
            delete dictItems[_arg1];
            totalWeight = (totalWeight - _local2.weight);
            return (true);
        }
        private function GuessType(_arg1:String):String{
//            var _local2:String;
//            var _local3:String;
//            var _local4:String = ((_arg1.indexOf("?") > -1)) ? _arg1.substring(0, _arg1.indexOf("?")) : _arg1;
//            var _local5:String = ((_arg1.indexOf("?") > -1)) ? _arg1.substring(0, _arg1.indexOf("?")) : _arg1.substring(_local4.lastIndexOf("/"));
//            var _local6:String = ((_arg1.indexOf("?") > -1)) ? _arg1.substring(0, _arg1.indexOf("?")) : _arg1.substring(_local4.lastIndexOf("/")).substring((_local5.lastIndexOf(".") + 1)).toLowerCase();
//            trace("******"+_local6,_arg1);
//			if (!Boolean(_local6)){
//                _local6 = BulkLoader.TYPE_TEXT;
//            };
//            if ((((_local6 == BulkLoader.TYPE_IMAGE)) || ((BulkLoader.IMAGE_EXTENSIONS.indexOf(_local6) > -1)))){
//                _local2 = BulkLoader.TYPE_IMAGE;
//            } else {
//                if ((((_local6 == BulkLoader.TYPE_SOUND)) || ((BulkLoader.SOUND_EXTENSIONS.indexOf(_local6) > -1)))){
//                    _local2 = BulkLoader.TYPE_SOUND;
//                } else {
//                    if ((((_local6 == BulkLoader.TYPE_VIDEO)) || ((BulkLoader.VIDEO_EXTENSIONS.indexOf(_local6) > -1)))){
//                        _local2 = BulkLoader.TYPE_VIDEO;
//                    } else {
//                        if ((((_local6 == BulkLoader.TYPE_XML)) || ((BulkLoader.XML_EXTENSIONS.indexOf(_local6) > -1)))){
//                            _local2 = BulkLoader.TYPE_XML;
//                        } else {
//                            if ((((_local6 == BulkLoader.TYPE_MOVIECLIP)) || ((BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(_local6) > -1)))){
//                                _local2 = BulkLoader.TYPE_MOVIECLIP;
//                            } else {
//                                for (_local3 in CustomTypesExtensions) {
//                                    if (_local3 == _local6){
//                                        _local2 = CustomTypesExtensions[_local3];
//                                        break;
//                                    };
//                                };
//                                if (!_local2){
//                                    _local2 = BulkLoader.TYPE_BINARY;
//                                };
//                            };
//                        };
//                    };
//                };
//            };
//            return (_local2);
			
			var _local5:String;
			var _local6:String;
			var _local2:String = ((_arg1.indexOf("?") > -1)) ? _arg1.substring(0, _arg1.indexOf("?")) : _arg1;
			var _local3:String = _local2.substring(_local2.lastIndexOf("/"));
			var _local4:String = _local3.substring((_local3.lastIndexOf(".") + 1)).toLowerCase();
			trace("******GuessType:"+_local6,_arg1);
			if (!Boolean(_local4)){
				_local4 = BulkLoader.TYPE_TEXT;
			};
			if ((((_local4 == BulkLoader.TYPE_IMAGE)) || ((BulkLoader.IMAGE_EXTENSIONS.indexOf(_local4) > -1)))){
				_local5 = BulkLoader.TYPE_IMAGE;
			} else {
				if ((((_local4 == BulkLoader.TYPE_SOUND)) || ((BulkLoader.SOUND_EXTENSIONS.indexOf(_local4) > -1)))){
					_local5 = BulkLoader.TYPE_SOUND;
				} else {
					if ((((_local4 == BulkLoader.TYPE_VIDEO)) || ((BulkLoader.VIDEO_EXTENSIONS.indexOf(_local4) > -1)))){
						_local5 = BulkLoader.TYPE_VIDEO;
					} else {
						if ((((_local4 == BulkLoader.TYPE_XML)) || ((BulkLoader.XML_EXTENSIONS.indexOf(_local4) > -1)))){
							_local5 = BulkLoader.TYPE_XML;
						} else {
							if ((((_local4 == BulkLoader.TYPE_MOVIECLIP)) || ((BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(_local4) > -1)))){
								_local5 = BulkLoader.TYPE_MOVIECLIP;
							} else {
								for (_local6 in CustomTypesExtensions) {
									if (_local6 == _local4){
										_local5 = CustomTypesExtensions[_local6];
										break;
									};
								};
								if (!_local5){
									_local5 = BulkLoader.TYPE_BINARY;
								};
							};
						};
					};
				};
			};
			return (_local5);
        }
        private function GetProgressForItems(_arg1:ProgressEvent):BulkProgressEvent{
            var _local2:LoadingItem;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            bytesLoaded = (bytesTotal = 0);
            var _local3:Number = 0;
            var _local4:Number = 0;
            var _local12:Number = 0;
            for each (_local2 in items) {
                if (!_local2){
                } else {
                    _local7++;
                    _local6++;
                    _local5 = (_local5 + _local2.weight);
                    if ((((((_local2.status == LoadingItem.STATUS_STARTED)) || ((_local2.status == LoadingItem.STATUS_FINISHED)))) || ((_local2.status == LoadingItem.STATUS_STOPPED)))){
                        _local12 = (_local12 + _local2.speed);
                        _local9 = (_local9 + _local2.bytesLoaded);
                        _local11 = (_local11 + _local2.bytesTotal);
                        _local4 = (_local4 + ((_local2.bytesLoaded / _local2.bytesTotal) * _local2.weight));
                        if (_local2.status == LoadingItem.STATUS_FINISHED){
                            _local8++;
                        };
                    };
                };
            };
            if (_local6 != _local7){
                _local10 = Number.POSITIVE_INFINITY;
            } else {
                _local10 = _local11;
            };
            _local3 = (_local4 / _local5);
            if (_local5 == 0){
                _local3 = 0;
            };
            _local12 = (_local12 / (itemsLoaded + 1));
            itemsSpeed = _local12;
            var _local13:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.PROGRESS);
            _local13.ItemBytesLoaded = _arg1.bytesLoaded;
            _local13.ItemBytesTotal = _arg1.bytesTotal;
            _local13.ItemsLoaded = _local8;
            _local13.ItemsTotal = _local7;
            _local13.ItemsSpeed = _local12;
            _local13.BytesLoaded = _local9;
            _local13.BytesTotal = _local10;
            _local13.WeightPercent = _local3;
            return (_local13);
        }
        public function GetLoadingItem(_arg1:String):LoadingItem{
            return ((this.dictItems[_arg1] as LoadingItem));
        }
        public function Stop():void{
            items.forEach(itemStop);
        }
        private function onProgress(_arg1:ProgressEvent):void{
            var _local2:BulkProgressEvent = GetProgressForItems(_arg1);
            dispatchEvent(_local2);
        }
        private function itemStop(_arg1:LoadingItem, ... _args):void{
            if ((((_arg1.status == LoadingItem.STATUS_WAIT)) || ((_arg1.status == LoadingItem.STATUS_STARTED)))){
                _arg1.stop();
            };
            currentConnections = 0;
        }
        private function lazyLoad():void{
            var _local1:LoadingItem;
            while ((((currentConnections < maxConnections)) && ((workItems.length > 0)))) {
                workItems.sortOn("priority", Array.NUMERIC);
                _local1 = (workItems.shift() as LoadingItem);
                _local1.load();
                currentConnections++;
            };
        }
        public function get _currentConnections():uint{
            return (this.currentConnections);
        }
        private function onComplete(_arg1:Event):void{
            itemsLoaded++;
            currentConnections--;
            var _local2:LoadingItem = (_arg1.target as LoadingItem);
            var _local3:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.COMPLETE);
            _local3.Item = _local2;
            _local3.BytesLoaded = bytesLoaded;
            _local3.BytesTotal = bytesTotal;
            _local3.ItemsLoaded = itemsLoaded;
            _local3.ItemsTotal = itemsTotal;
            _local3.ItemsSpeed = itemsSpeed;
            _local3.WeightPercent = weightPercent;
            dispatchEvent(_local3);
            if (itemsLoaded != itemsTotal){
                this.Load();
            };
        }

    }
}//package OopsFramework.Content.Loading 
