//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.AI.MapPathFinder {
    import flash.utils.*;

	/**
	 * 
	 * @author wengliqiang
	 * 
	 */	
    public class MapFinder {

        private static const MAX_COUNT:int = 50000;

        private static var checkCount:uint;

        private var start:MapNode;
        private var isFind:Boolean = false;
        private var openList:Dictionary;
        private var targetMapId:String;
        private var mapTree:Dictionary;
        private var end:MapNode;

        public function MapFinder(_arg1:Dictionary){
            this.mapTree = _arg1;
        }
        private function NoteFinder(_arg1:Array):void{
            var _local2:String;
            var _local3:String;
            var _local4:Array;
            var _local5:String;
            var _local6:MapNode;
            var _local7:Array = [];
            for each (_local2 in _arg1) {
                _local3 = (this.mapTree[_local2] as String);
                if (_local3 != null){
                    _local4 = _local3.split(",");
                    for each (_local5 in _local4) {
                        _local6 = new MapNode();
                        _local6.Id = _local5;
                        _local6.Parent = _local2;
                        if (this.openList[_local6.Id] == null){
                            this.openList[_local6.Id] = _local6;
                        };
                        if (_local6.Id == this.targetMapId){
                            this.end = _local6;
                            return;
                        };
                        _local7.push(_local6.Id);
                        checkCount++;
                    };
                };
            };
            if (checkCount > MAX_COUNT){
                throw (new Error(("不存在地图路径:" + targetMapId)));
            };
            if (_local7.length > 0){
                this.NoteFinder(_local7);
            };
        }
        public function Find(_arg1:String, _arg2:String):Array{
            var _local3:MapNode;
            if (this.mapTree[_arg2] == null){
                throw (new Error(("不存在目标地图:" + _arg2)));
            };
            checkCount = 0;
            this.targetMapId = _arg2;
            this.openList = new Dictionary();
            this.NoteFinder([_arg1]);
            var _local4:Array = [];
            if (this.end != null){
                _local3 = this.end;
                while (true) {
                    if (_local3 != null){
                        _local4.unshift(_local3.Id);
                        _local3 = this.openList[_local3.Parent];
                        if ((((_local3 == null)) || ((_local3.Id == _arg1)))){
                            break;
                        };
                    };
                };
            };
            return (_local4);
        }

    }
}//package OopsEngine.AI.MapPathFinder 
