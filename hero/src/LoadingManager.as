//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.utils.*;
    import cmodule.ALCSWF.*;
    import flash.events.*;
    import flash.net.*;

    public class LoadingManager {

        private static const _reg2:RegExp = /[:|.|\/]/g;
        private static const _reg1:RegExp = /http:\/\/[\w|.|:]+\//i;
        private static const LOCAL_FILE:String = "hoholoading/files";

        private static var _current:Dictionary = new Dictionary();
        private static var THREAD_COUNT:Number = 8;
        private static var _count:int = 0;
        private static var _list:Array = new Array();
        private static var _cache:Dictionary;
        private static var _files:Object;
        private static var _version:int;
        private static var _cacheFile:Boolean = false;
        private static var _saveTimer:Timer;
        private static var _save:Array;
        private static var _retryCount:int = 0;
        private static var _changed:Boolean;
        private static var _so:SharedObject;
      //  public static var cLibInit:CLibInit = null;
        public static var alcLookupLib:Object = null;

        /*public static function decry(bytes:ByteArray):ByteArray{
            if (cLibInit == null){
                cLibInit = new CLibInit();
                alcLookupLib = cLibInit.init();
            };
            return (alcLookupLib.DecodeModel(bytes));
        }*/
        public static function asdecry(bytes:ByteArray):ByteArray{
            var temp:uint;
            var exchange:int;
            var clen:int = (bytes.length - 8);
            bytes[0] = 67;
            bytes[1] = 87;
            bytes[2] = 83;
            var key:Array = [75, 20, 252];
            var offset:int;
            var i:int;
            var j:int;
            var times:int = (clen / 128);
            var curpos:int;
            while (i < times) {
                offset = (i * 128);
                while (j < 64) {
                    temp = bytes[((offset + j) + 8)];
                    bytes[((offset + j) + 8)] = bytes[(((offset + 63) - j) + 8)];
                    bytes[(((offset + 63) - j) + 8)] = temp;
                    j = (j + 9);
                };
                i = (i + 37);
            };
            var limit:int = (clen - 1029);
            while (curpos < limit) {
                bytes[(curpos + 8)] = (bytes[(curpos + 8)] ^ key[0]);
                bytes[((curpos + 420) + 8)] = (bytes[((curpos + 420) + 8)] ^ key[1]);
                bytes[((curpos + 1029) + 8)] = (bytes[((curpos + 1029) + 8)] - key[2]);
                curpos = (curpos + 1374);
            };
            if (clen > 1000){
                exchange = 0;
                while (exchange < 137) {
                    temp = bytes[(exchange + 8)];
                    bytes[(exchange + 8)] = bytes[(((clen - 501) + exchange) + 8)];
                    bytes[(((clen - 501) + exchange) + 8)] = temp;
                    exchange++;
                };
            };
            return (bytes);
        }
        public static function clearFiles(ft:String):void{
            var updated:Array;
            var t:String;
            var temp:Array;
            var f:String;
            var n:String;
            var _loc_3:int;
            var _loc_4:*;
            var filter:* = ft;
            if (_files){
                updated = new Array();
                t = getPath(filter);
                t = t.replace("*", "\\w*");
                updated.push(new RegExp(("^" + t)));
                temp = new Array();
                _loc_4 = _files;
                while ((_loc_4 in _loc_3)) {
                    f = _loc_4[_loc_3];
                    if (hasUpdate(f, updated)){
                        temp.push(f);
                    };
                };
                _loc_4 = temp;
                while ((_loc_4 in _loc_3)) {
                    n = _loc_4[_loc_3];
                    delete _files[n];
                };
                try {
                    if (_cacheFile){
                        _so.flush(((20 * 0x0400) * 0x0400));
                    };
                } catch(e:Error) {
                };
            };
        }
        private static function hasUpdate(filepath:String, updated:Array):Boolean{
            var _loc_3:RegExp;
            for each (_loc_3 in updated) {
                if (filepath.match(_loc_3)){
                    return (true);
                };
            };
            return (false);
        }
        public static function get Version():int{
            return (_version);
        }
        public static function loadCachedFile(filename:String, bcache:Boolean):ByteArray{
            var _loc_3:String;
            var _loc_4:int;
            var _loc_5:ByteArray;
            var _loc_6:SharedObject;
            if (_files){
                _loc_3 = getPath(filename);
                _loc_4 = getTimer();
                _loc_5 = _cache[_loc_3];
                if (_loc_5 == null){
                    if (_files[_loc_3]){
                        _loc_6 = SharedObject.getLocal(_loc_3);
                        _loc_5 = (_loc_6.data["data"] as ByteArray);
                        if (((_loc_5) && (bcache))){
                            _cache[_loc_3] = _loc_5;
                        };
                    };
                };
                if (_loc_5){
                    trace("get{local:", (getTimer() - _loc_4), "ms}", filename);
                    return (_loc_5);
                };
            };
            return (null);
        }
        public static function cacheFile(path:String, data:ByteArray, cacheInMem:Boolean):void{
            var p:String;
            if (_files){
                p = getPath(path);
                _save.push({
                    p:p,
                    d:data
                });
                if (cacheInMem){
                    _cache[p] = data;
                };
                _changed = true;
            };
        }
        private static function loadFilesInLocal():void{
            try {
                _so = SharedObject.getLocal(LOCAL_FILE);
                _so.addEventListener(NetStatusEvent.NET_STATUS, __netStatus);
                _files = _so.data["data"];
                if (_files == null){
                    _files = new Object();
                    _so.data["data"] = _files;
                    _files["version"] = (_version = -1);
                    _cacheFile = false;
                } else {
                    _version = _files["version"];
                    _cacheFile = true;
                };
                trace("本地文件读取完毕");
            } catch(e:Error) {
                trace("本地文件读取错误", e.message);
            };
        }
        public static function saveFilesToLocal():void{
            var state:String;
            var tick:int;
            var obj:Object;
            var so:SharedObject;
            try {
                if (((((_files) && (_changed))) && (_cacheFile))){
                    state = _so.flush(((20 * 0x0400) * 0x0400));
                    if (state != SharedObjectFlushStatus.PENDING){
                        tick = getTimer();
                        if (_save.length > 0){
                            obj = _save[0];
                            so = SharedObject.getLocal(obj.p);
                            so.data["data"] = obj.d;
                            so.flush();
                            _files[obj.p] = true;
                            _so.flush();
                            _save.shift();
                            trace("save local data spend:", (getTimer() - tick), "  left:", _save.length);
                        };
                        if (_save.length == 0){
                            _changed = false;
                        };
                    };
                };
            } catch(e:Error) {
            };
        }
        public static function applyUpdate(fromv:int, tov:int, code:Array):void{
            var _loc_4:Array;
            var _loc_5:String;
            var _loc_6:Array;
            var _loc_7:String;
            var _loc_8:String;
            var _loc_9:String;
            if (tov <= fromv){
                return;
            };
            if (_version < tov){
                if (_version < fromv){
                    _files = new Dictionary();
                    _so.data["data"] = _files;
                } else {
                    _loc_4 = new Array();
                    for each (_loc_5 in code) {
                        _loc_9 = getPath(_loc_5);
                        _loc_9 = _loc_9.replace("*", "\\w*");
                        _loc_4.push(new RegExp(("^" + _loc_9)));
                    };
                    _loc_6 = new Array();
                    for (_loc_7 in _files) {
                        if (hasUpdate(_loc_7, _loc_4)){
                            _loc_6.push(_loc_7);
                        };
                    };
                    for each (_loc_8 in _loc_6) {
                        delete _files[_loc_8];
                    };
                };
                _version = tov;
                _files["version"] = tov;
                _changed = true;
            };
        }
        public static function parseUpdate(xmlfile:XML):void{
            var vs:* = null;
            var unode:* = null;
            var fromv:* = 0;
            var tov:* = 0;
            var fs:* = null;
            var updatelist:* = null;
            var fn:* = null;
            var _loc_3:* = undefined;
            var _loc_5:* = undefined;
            var _loc_4:* = undefined;
            var xmlfile:* = xmlfile;
            var config:* = xmlfile;
            if (_so == null){
                trace("本地存储文件不可用，尝试再读一次");
                loadFilesInLocal();
                if (_so == null){
                    return;
                };
            };
            try {
                vs = config.version;
                for each (_loc_3 in vs) {
                    unode = _loc_3;
                    fromv = int(unode.@from);
                    tov = int(unode.@to);
                    fs = unode.file;
                    updatelist = new Array();
                    for each (_loc_5 in fs) {
                        fn = _loc_5;
                        updatelist.push(String(fn.@value));
                    };
                    applyUpdate(fromv, tov, updatelist);
                };
            } catch(e:Error) {
                trace(e.message);
                trace(e.getStackTrace());
                _version = -1;
                _loc_4 = new Dictionary();
                _files = new Dictionary();
                _so.data["data"] = _loc_4;
                _changed = true;
            };
            saveFilesToLocal();
        }
        public static function get hasFileToSave():Boolean{
            if (_cacheFile){
                return (_changed);
            };
            return (false);
        }
        public static function get cacheAble():Boolean{
            return (_cacheFile);
        }
        public static function set cacheAble(bval:Boolean):void{
            _cacheFile = bval;
        }
        private static function __netStatus(event:NetStatusEvent):void{
            switch (event.info.code){
                case "SharedObject.Flush.Failed":
                    if (_retryCount < 1){
                        _so.flush(((20 * 0x0400) * 0x0400));
                        _retryCount++;
                    } else {
                        cacheAble = false;
                    };
                    break;
                default:
                    _retryCount = 0;
            };
        }
        private static function getPath(filepath:String):String{
            var _loc_2:int = filepath.indexOf("?");
            if (_loc_2 != -1){
                filepath = filepath.substring(0, _loc_2);
            };
            filepath = filepath.replace(_reg1, "");
            return (filepath.replace(_reg2, "-"));
        }
        public static function get list():Array{
            return (_list);
        }
        public static function setup():void{
            _cacheFile = false;
            _cache = new Dictionary();
            _save = new Array();
            loadFilesInLocal();
        }

        public function LoaderManager(){
        }

    }
}//package 
