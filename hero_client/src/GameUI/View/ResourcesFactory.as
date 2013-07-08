//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import OopsFramework.Content.Loading.*;

    public class ResourcesFactory {

        private static var _instance:ResourcesFactory;

        private var _callBackDic:Dictionary;
        private var bulkLoader:BulkLoader;
        private var _resourceDic:Dictionary;
        private var _loadDic:Dictionary;
        private var item:LoadingItem;

        public function ResourcesFactory(_arg1:Simgle){
            this._callBackDic = new Dictionary();
            this._loadDic = new Dictionary();
            this._resourceDic = new Dictionary();
            this.bulkLoader = new BulkLoader(2);
        }
        public static function getInstance():ResourcesFactory{
            if (_instance == null){
                _instance = new ResourcesFactory(new Simgle());
            };
            return (_instance);
        }
        public static function getInstanceByClass(_arg1:Class, _arg2:Array){
            var _local3:*;
            if (_arg1 == null){
                return (null);
            };
            var _local4:int = (_arg2) ? _arg2.length : 0;
            switch (_local4){
                case 0:
                    _local3 = new (_arg1)();
                    break;
                case 1:
                    _local3 = new _arg1(_arg2[0]);
                    break;
                case 2:
                    _local3 = new _arg1(_arg2[0], _arg2[1]);
                    break;
                case 3:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2]);
                    break;
                case 4:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3]);
                    break;
                case 5:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4]);
                    break;
                case 6:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5]);
                    break;
                case 7:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6]);
                    break;
                case 8:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7]);
                    break;
                case 9:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8]);
                    break;
                case 10:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8], _arg2[9]);
                    break;
                case 11:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8], _arg2[9], _arg2[10]);
                    break;
                case 12:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8], _arg2[9], _arg2[10], _arg2[11]);
                    break;
                case 13:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8], _arg2[9], _arg2[10], _arg2[11], _arg2[12]);
                    break;
                case 14:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8], _arg2[9], _arg2[10], _arg2[11], _arg2[12], _arg2[13]);
                    break;
                case 15:
                    _local3 = new _arg1(_arg2[0], _arg2[1], _arg2[2], _arg2[3], _arg2[4], _arg2[5], _arg2[6], _arg2[7], _arg2[8], _arg2[9], _arg2[10], _arg2[11], _arg2[12], _arg2[13], _arg2[14]);
                    break;
            };
            return (_local3);
        }

        public function getResource(_arg1:String, _arg2:Function):void{
            var _local3:Array;
            var _local4:String = _arg1;
            var _local5:int = _arg1.indexOf("?", 0);
            if (_local5 != -1){
                _local4 = _arg1.substring(0, _local5);
            };
            if (this._loadDic[_local4] == null){
                this._loadDic[_local4] = 1;
                this._callBackDic[_local4] = [_arg2];
                this.bulkLoader.Add(_arg1);
                this.item = (this.bulkLoader.GetLoadingItem(_arg1) as LoadingItem);
                this.item.addEventListener(Event.COMPLETE, onCompleteHandler);
                this.item.url = _arg1;
                this.bulkLoader.Load();
            } else {
                if (this._loadDic[_local4] == 1){
                    _local3 = ((this._callBackDic[_local4] == null)) ? [] : this._callBackDic[_local4];
                    if (_local3.indexOf(_arg2) == -1){
                        _local3.push(_arg2);
                    };
                } else {
                    if (this._loadDic[_local4] == 2){
                        _arg2();
                    };
                };
            };
        }
        public function getBitMapResourceByUrl(_arg1:String):Bitmap{
            var _local2:Bitmap = Bitmap(this._resourceDic[_arg1]);
            if (_local2 != null){
                return (new Bitmap(_local2.bitmapData.clone()));
            };
            return (null);
        }
        public function deleteCallBackFun(_arg1:String, _arg2:Function):void{
            var _local3:int;
            var _local4:Array = (this._callBackDic[_arg1] as Array);
            if (_local4 != null){
                _local3 = _local4.indexOf(_arg2);
                if (_local3 != -1){
                    _local4.splice(_local3, 1);
                    this._callBackDic[_arg1] = _local4;
                };
            };
        }
        public function getswfResourceByUrl(_arg1:String):MovieClip{
            return (this._resourceDic[_arg1]);
        }
        protected function onCompleteHandler(_arg1:Event):void{
            var _local2:uint;
            var _local3:uint;
            var _local7:Array;
            var _local4:String = (_arg1.currentTarget as LoadingItem).url;
            var _local5:int = _local4.indexOf("?", 0);
            if (_local5 != -1){
                _local4 = _local4.substring(0, _local5);
            };
            this._resourceDic[_local4] = _arg1.currentTarget.loader.content;
            this._loadDic[_local4] = 2;
            var _local6:Array = this._callBackDic[_local4];
            if (((!((_local6 == null))) && ((_local6.length > 0)))){
                _local2 = _local6.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    if (_local6[_local3] == null){
                    } else {
                        _local7 = _local6;
                        var _local8 = _local7;
                        _local8[_local3]();
                    };
                    _local3++;
                };
                delete this._callBackDic[_local4];
            };
        }

    }
}//package GameUI.View 

class Simgle {

    public function Simgle(){
    }
}
