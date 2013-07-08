//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import OopsFramework.Content.Loading.*;
    import GameUI.View.*;
    import Render3D.*;

    public class GameSceneBackgroundL extends Sprite {

        private static var g_dumpmap:BitmapData = new BitmapData(10, 10, false, 0);

        private var scaleH:Number;
        private var mapMaxCount:int;
        private var scaleW:Number;
        public var MapTileHeight:int = 300;
        private var picLoading:Boolean = false;
        private var mapCount:int;
        private var imageLoader:BulkLoader;
        public var MapTileWidth:int = 300;
        private var picMaxX:int;
        private var picMaxY:int;
        private var itemObj:Object;
        private var frameCount:int;
        private var bmObj:Object;
        private var imArray:Array;
        private var gameScene:GameScene;

        public function GameSceneBackgroundL(_arg1:GameScene){
            imageLoader = GameCommonData.mapResourceLoader;
            imArray = [];
            super();
            this.mouseEnabled = false;
            this.mouseChildren = false;
            bmObj = new Object();
            itemObj = new Object();
            this.gameScene = _arg1;
            this.picMaxX = (Math.ceil((this.gameScene.MapWidth / MapTileWidth)) - 1);
            this.picMaxY = (Math.ceil((this.gameScene.MapHeight / MapTileHeight)) - 1);
            this.mapMaxCount = ((this.picMaxX + 1) * (this.picMaxY + 1));
            var _local2:int = (this.gameScene.MapWidth + this.gameScene.OffsetX);
            var _local3:int = (this.gameScene.MapHeight + this.gameScene.OffsetY);
            scaleW = (this.gameScene.MapWidth / MapTileWidth);
            scaleH = (this.gameScene.MapHeight / MapTileHeight);
        }
        private function CanSee(_arg1:Bitmap):Boolean{
            if (((((((((_arg1.x + this.gameScene.x) > -300)) && (((_arg1.y + this.gameScene.y) > -300)))) && (((_arg1.x + this.gameScene.x) < 1500)))) && (((_arg1.y + this.gameScene.y) < 900)))){
                return (true);
            };
            return (false);
        }
        private function LoadMap2():void{
            var _local1:int;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:String;
            var _local8:ImageItem;
            var _local10:Bitmap;
            var _local11:String;
            var _local12:Number;
            var _local13:Number;
            var _local14:BitmapData;
            var _local15:Rectangle;
            CheckRedundancy();
            var _local9 = "";
            if (GameCommonData.currentMapVersion != 0){
                _local9 = ("?v=" + GameCommonData.currentMapVersion);
            };
            if (this.bmObj != null){
                _local1 = int((Math.abs(this.gameScene.x) / MapTileWidth));
                _local2 = int((Math.abs(this.gameScene.y) / MapTileHeight));
                _local3 = int((Math.abs((this.gameScene.Games.ScreenWidth - this.gameScene.x)) / this.MapTileWidth));
                _local4 = int((Math.abs((this.gameScene.Games.ScreenHeight - this.gameScene.y)) / this.MapTileHeight));
                _local1 = ((_local1 <= 0)) ? 0 : _local1;
                _local2 = ((_local2 <= 0)) ? 0 : _local2;
                _local3 = ((_local3 >= picMaxX)) ? picMaxX : _local3;
                _local4 = ((_local4 >= picMaxY)) ? picMaxY : _local4;
                _local5 = _local1;
                while (_local5 <= _local3) {
                    _local6 = _local2;
                    while (_local6 <= _local4) {
                        _local7 = ((_local5 + "_") + _local6);
                        if (!this.bmObj[_local7]){
                            _local10 = new Bitmap();
                            if (((!((this.gameScene.SmallMap == null))) && (!((this.gameScene.SmallMap.bitmapData == null))))){
                                _local12 = (this.gameScene.SmallMap.width / scaleW);
                                _local13 = (this.gameScene.SmallMap.height / scaleH);
                                _local14 = new BitmapData(_local12, _local13, false, 0);
                                _local15 = new Rectangle((_local5 * _local12), (_local6 * _local13), _local12, _local13);
                                _local14.copyPixels(this.gameScene.SmallMap.bitmapData, _local15, new Point(0, 0), null, null, true);
                                _local10.bitmapData = _local14;
                            } else {
                                _local10.bitmapData = g_dumpmap;
                            };
                            _local10.scaleX = (300 / _local12);
                            _local10.scaleY = (300 / _local13);
                            _local10.x = (_local5 * 300);
                            _local10.y = (_local6 * 300);
                            _local10.width = 300;
                            _local10.height = 300;
                            if (this.bmObj[_local7] == null){
                                this.bmObj[_local7] = _local10;
                            };
                            this.addChild(this.bmObj[_local7]);
                            _local11 = ((((((this.gameScene.Games.Content.RootDirectory + "Scene/") + this.gameScene.name) + "/") + _local7) + ".jpg") + _local9);
                            imageLoader.Add(_local11, false, _local7, 1, 1);
                            _local8 = (imageLoader.GetLoadingItem(_local7) as ImageItem);
                            _local8.addEventListener(Event.COMPLETE, onPicComplete);
                            _local8.addEventListener(IOErrorEvent.IO_ERROR, onPicError);
                            _local8.addEventListener(BulkProgressEvent.ERROR, onPicError2);
                            _local8.name = _local7;
                            itemObj[_local7] = _local8;
                            imageLoader.Load();
                        };
                        _local6++;
                    };
                    _local5++;
                };
            } else {
                MessageTip.show(LanguageMgr.GetTranslation("地图加载有误"));
            };
        }
        public function onDestroy():void{
        }
        private function onPicError(_arg1:Event):void{
            MessageTip.show((_arg1.currentTarget.name + LanguageMgr.GetTranslation("x格地图加不出来")));
        }
        private function CheckRedundancy():void{
            var _local1:*;
            var _local2:LoadingItem;
            for (_local1 in bmObj) {
                if (!CanSee(bmObj[_local1])){
                    if (((!((bmObj[_local1] == null))) && (!((bmObj[_local1].parent == null))))){
                        bmObj[_local1].parent.removeChild(bmObj[_local1]);
                    };
                    if (((!((bmObj[_local1].bitmapData == null))) && (!((bmObj[_local1].bitmapData == g_dumpmap))))){
                        bmObj[_local1].bitmapData.dispose();
                    };
                    if (itemObj[_local1] != null){
                        _local2 = itemObj[_local1];
                        imageLoader.RemoveItem(_local1);
                        _local2.destroy();
                        delete itemObj[_local1];
                        _local2.removeEventListener(Event.COMPLETE, onPicComplete);
                        _local2.removeEventListener(IOErrorEvent.IO_ERROR, onPicError);
                        _local2.removeEventListener(BulkProgressEvent.ERROR, onPicError2);
                    };
                    delete bmObj[_local1];
                };
            };
        }
        public function Advance():void{
            LoadMap2();
        }
        private function onPicError2(_arg1:Event):void{
            MessageTip.show((_arg1.currentTarget.name + LanguageMgr.GetTranslation("x格地图加不出来2")));
        }
        public function LoadMap():void{
        }
        public function ResetMask(){
            var _local3:int;
            var _local4:int;
            var _local5:*;
            var _local6:BitmapData;
            var _local7:Rectangle;
            var _local1:Number = (this.gameScene.SmallMap.width / scaleW);
            var _local2:Number = (this.gameScene.SmallMap.height / scaleH);
            for (_local5 in bmObj) {
                if ((bmObj[_local5] as Bitmap).bitmapData == g_dumpmap){
                    _local3 = ((bmObj[_local5] as Bitmap).x / 300);
                    _local4 = ((bmObj[_local5] as Bitmap).y / 300);
                    _local6 = new BitmapData(_local1, _local2, false, 0);
                    _local7 = new Rectangle((_local3 * _local1), (_local4 * _local2), _local1, _local2);
                    _local6.copyPixels(this.gameScene.SmallMap.bitmapData, _local7, new Point(0, 0), null, null, true);
                    (bmObj[_local5] as Bitmap).bitmapData = _local6;
                    (bmObj[_local5] as Bitmap).width = 300;
                    (bmObj[_local5] as Bitmap).height = 300;
                };
            };
        }
        private function onPicComplete(_arg1:Event):void{
            var _local2:ImageItem;
            var _local3:Array;
            var _local4:uint;
            var _local5:uint;
            _local2 = (_arg1.target as ImageItem);
            _local3 = _local2.name.split("_");
            _local4 = _local3[0];
            _local5 = _local3[1];
            var _local6:Bitmap = bmObj[_local2.name];
            if (_local6 == null){
                _local6 = new Bitmap();
            };
            this.addChild(_local6);
            if (((!((_local6.bitmapData == g_dumpmap))) && (!((_local6.bitmapData == null))))){
                _local6.bitmapData.dispose();
            };
            _local6.bitmapData = _local2.content.content.bitmapData;
            _local6.x = uint((_local4 * MapTileWidth));
            _local6.y = uint((_local5 * MapTileHeight));
            _local6.scaleX = 1;
            _local6.scaleY = 1;
            _local2.removeEventListener(Event.COMPLETE, onPicComplete);
            _local2.removeEventListener(IOErrorEvent.IO_ERROR, onPicError);
            _local2.removeEventListener(BulkProgressEvent.ERROR, onPicError2);
            if (Render3DManager.getInstance().m_isinited){
                this.visible = false;
                Render3DManager.getInstance().AddMap(_local2.name, _local6.bitmapData, _local6.x, _local6.y);
                _local6.bitmapData.dispose();
                _local6.bitmapData = null;
            };
        }

    }
}//package OopsEngine.Scene 
