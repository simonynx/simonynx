//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Content.Loading {
    import flash.events.*;

	/**
	 *加载事件 
	 * @author wengliqiang
	 * 
	 */	
    public class BulkProgressEvent extends ProgressEvent {

        public static const ERROR:String = "error";
        public static const COMPLETE:String = "complete";
        public static const OPEN:String = "open";
        public static const PROGRESS:String = "progress";

        public var ItemsTotal:uint;
        public var ItemsLoaded:uint;
        public var ItemsSpeed:Number;
        public var ItemBytesLoaded:uint;
        public var ItemBytesTotal:uint;
        private var weightPercent:Number;
        public var Item:LoadingItem;
        public var ErrorMessage:String;

        public function BulkProgressEvent(_arg1:String, _arg2:Boolean=true, _arg3:Boolean=false){
            super(_arg1, _arg2, _arg3);
        }
        public function get WeightPercent():Number{
            return (ValidateNumber(weightPercent));
        }
        public function get PercentLoaded():Number{
            return (ValidateNumber(((bytesTotal > 0)) ? (bytesLoaded / bytesTotal) : 0));
        }
        private function ValidateNumber(_arg1:Number):Number{
            if (((isNaN(_arg1)) || (!(isFinite(_arg1))))){
                return (0);
            };
            return (_arg1);
        }
        public function set BytesLoaded(_arg1:uint):void{
            bytesLoaded = _arg1;
        }
        public function set WeightPercent(_arg1:Number):void{
            weightPercent = _arg1;
        }
        public function get BytesLoaded():uint{
            return (bytesLoaded);
        }
        public function set BytesTotal(_arg1:uint):void{
            bytesTotal = _arg1;
        }
        public function get BytesTotal():uint{
            return (bytesTotal);
        }
        override public function toString():String{
            var _local1:Array = [];
            _local1.push(("ItemBytesLoaded: " + ItemBytesLoaded));
            _local1.push(("ItemBytesTotal: " + ItemBytesTotal));
            _local1.push(("BytesLoaded: " + BytesLoaded));
            _local1.push(("BytesTotal: " + BytesTotal));
            _local1.push(("ItemsLoaded: " + ItemsLoaded));
            _local1.push(("ItemsTotal: " + ItemsTotal));
            _local1.push(("ItemsSpeed: " + ItemsSpeed));
            _local1.push(("PercentLoaded: " + BulkLoader.TruncateNumber(PercentLoaded)));
            _local1.push(("WeightPercent: " + BulkLoader.TruncateNumber(WeightPercent)));
            return ((("BulkProgressEvent " + _local1.join(", ")) + ";"));
        }

    }
}//package OopsFramework.Content.Loading 
