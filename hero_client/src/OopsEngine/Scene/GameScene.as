//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import Manager.*;
    
    import OopsEngine.*;
    import OopsEngine.AI.PathFinder.*;
    import OopsEngine.Exception.*;
    import OopsEngine.Scene.StrategyElement.*;
    
    import OopsFramework.*;
    import OopsFramework.Audio.*;
    import OopsFramework.Content.Loading.*;
    
    import Render3D.*;
    
    import Utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

	/**
	 *游戏场景 
	 * @author wengliqiang
	 * 
	 */	
    public class GameScene extends DrawableGameComponent implements IDisposable {

        private static var loadswfTool:LoadSwfTool = null;

        public var MouseUp:Function;
        public var OffsetX:int;
        public var GameSceneLoadComplete:Function;
        private var topLayer:GameSceneLayer;
        public var OffsetY:int;
        private var floor:GameSceneFloor;
        public var MptByteArray:ByteArray;
        public var Scale:Number;
        private var background:GameSceneBackgroundL;
        public var Map:MapTileModel;
        public var Disposed:Function;
        private var configProvider:GameSceneConfig;
        public var ConfigXml:XML;
        private var musicDelay:int = 5000;
        public var SceneUrl:String;
        public var SEElements:Array;
        public var MapId:String;
        public var ResourceLoadingQueue:Dictionary;
        public var MapHeight:int;
        public var CacheResource:Dictionary;
        private var gameSceneLayers:Array;
        public var GameSceneDataProgress:Function;
        public var RealSmallMap:Bitmap;
        private var audioEngine:AudioEngine;
        private var middleLayer:GameSceneLayer;
        private var musicIntervalId:int;
        public var MouseDown:Function;
        public var Description:String;
        public var ConnectScene:Dictionary;
        private var bottomLayer:GameSceneLayer;
        public var MapName:String;
        public var MapWidth:int;
        public var UpdateNicety:Function;
        public var SmallMap:Bitmap;
        public var MouseMove:Function;

        public function GameScene(_arg1:Game){
            gameSceneLayers = [];
            CacheResource = new Dictionary();
            ResourceLoadingQueue = new Dictionary();
            super(_arg1);
        }
        public function SetVolume(_arg1:int):void{
            if (this.audioEngine != null){
                this.audioEngine.Volume = _arg1;
            };
        }
        private function AnalyseMap():void{
            this.MapName = this.ConfigXml.@Name;
            this.MapWidth = this.ConfigXml.@MapWidth;
            this.MapHeight = this.ConfigXml.@MapHeight;
            this.OffsetX = this.ConfigXml.@OffsetX;
            this.OffsetY = this.ConfigXml.@OffsetY;
            this.Scale = this.ConfigXml.@Scale;
            if (ConfigXml.@SceneMapScale > 0){
                MapTileModel.SCENEMAN_SCALE = this.ConfigXml.@SceneMapScale;
            } else {
                MapTileModel.SCENEMAN_SCALE = 0.14;
            };
            this.Description = this.ConfigXml.@Description;
        }
        public function get IsMusicing():Boolean{
            if (audioEngine){
                return (audioEngine.IsPlaying);
            };
            return (false);
        }
        public function ClearElement():void{
            var _local1:int;
            while (_local1 < this.gameSceneLayers.length) {
                this.gameSceneLayers[_local1].ClearElement();
                _local1++;
            };
        }
        public function set MouseEnabled(_arg1:Boolean):void{
            this.mouseEnabled = _arg1;
            if (this.mouseEnabled){
                this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            } else {
                this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            };
        }
        private function onPlayComplete():void{
            this.MusicLoad();
        }
        public function get TopLayer():GameSceneLayer{
            return (this.topLayer);
        }
        private function PlayMusic(_arg1:int):void{
            if (this.audioEngine == null){
                this.audioEngine = new AudioEngine((this.SceneUrl + "Sound.mp3"));
                this.audioEngine.Loop = 1;
                this.audioEngine.PlayComplete = onPlayComplete;
                this.audioEngine.Play();
                this.audioEngine.Volume = _arg1;
            } else {
                this.audioEngine.Play();
                this.audioEngine.Volume = GetVolume();
            };
            clearInterval(this.musicIntervalId);
        }
        protected function onMouseUp(_arg1:MouseEvent):void{
            if (MouseUp != null){
                MouseUp(_arg1);
            };
        }
        public function get Background():GameSceneBackgroundL{
            return (this.background);
        }
        private function AnalyseTopLayer():void{
            topLayer = new GameSceneLayer();
            topLayer.name = "GameSceneLayer_Top";
        }
        private function AnalyseMiddleLayer():void{
            middleLayer = new GameSceneLayer();
            if (Render3DManager.getInstance().m_renderbitmap != null){
                middleLayer.addChild(Render3DManager.getInstance().m_renderbitmap);
            };
            middleLayer.name = "GameSceneLayer_Mmiddle";
        }
        private function AnalyseFloor():void{
            var _local1:uint;
            var _local6:uint;
            floor = new GameSceneFloor();
            GameCommonData.currentMapVersion = ConfigXml.@version;
            floor.TileWidth = ConfigXml.Floor.@TileWidth;
            floor.TileHeight = ConfigXml.Floor.@TileHeight;
            floor.Row = ConfigXml.Floor.@Row;
            floor.Col = ConfigXml.Floor.@Col;
            floor.OffsetX = ConfigXml.Floor.@OffsetX;
            floor.OffsetY = ConfigXml.Floor.@OffsetY;
            MapTileModel.OFFSET_TAB_X = floor.OffsetX;
            MapTileModel.OFFSET_TAB_Y = floor.OffsetY;
            MapTileModel.TILE_WIDTH = floor.TileWidth;
            MapTileModel.TILE_HEIGHT = floor.TileHeight;
            MapTileModel.TITE_HREF_WIDTH = (floor.TileWidth / 2);
            MapTileModel.TITE_HREF_HEIGHT = (floor.TileHeight / 2);
            var _local2:String = ConfigXml.Floor.text();
            var _local3:Array = _local2.split(",");
            var _local4:int = (floor.TileWidth / 2);
            var _local5:int = (floor.TileHeight / 2);
            floor.Area = new Array();
            while (_local6 < floor.Row) {
                floor.Area[_local6] = new Array();
                _local1 = 0;
                while (_local1 < floor.Col) {
                    floor.Area[_local6][_local1] = _local3[((_local6 * floor.Col) + _local1)];
                    _local1++;
                };
                _local6++;
            };
            this.Map = new MapTileModel();
            this.Map.Map = floor.Area;
        }
        public function MusicLoad(_arg1:int=100):void{
            if (musicIntervalId > 0){
                clearInterval(musicIntervalId);
            };
            PlayMusic(_arg1);
        }
        override protected function LoadContent():void{
            var _local1:int;
            if ((((this.ConfigXml == null)) || ((this.ConfigXml == "")))){
                throw (new Error(ExceptionResources.ErrorGameSceneConfig));
            };
            this.AnalyseMap();
            if (ConfigXml.@MptFile == "true"){
                this.AnalysePathData();
            } else {
                this.AnalyseFloor();
            };
            this.AnalyseTopLayer();
            this.AnalyseMiddleLayer();
            this.AnalyseBottomLayer();
            this.background = new GameSceneBackgroundL(this);
            this.background.name = "BackgroundLayer";
            this.addChildAt(this.background, 0);
            if (GameSceneLoadComplete != null){
                GameSceneLoadComplete();
            };
            this.gameSceneLayers.push(bottomLayer);
            this.gameSceneLayers.push(middleLayer);
            this.gameSceneLayers.push(topLayer);
            while (_local1 < this.gameSceneLayers.length) {
                this.addChildAt(this.gameSceneLayers[_local1], (_local1 + 1));
                _local1++;
            };
            MapManager.setCurrScene(this);
            super.LoadContent();
            background.Advance();
            trace("地图解析完");
        }
        private function AnalyseBottomLayer():void{
            var _local1:XML;
            var _local2:GameElement;
            var _local3:GameElementSceneEffect;
            var _local4:uint;
            var _local5:uint;
            this.ConnectScene = new Dictionary();
            bottomLayer = new GameSceneLayer();
            bottomLayer.name = "GameSceneLayer_Bottom";
            if (ConfigXml.Element != null){
                for each (_local1 in ConfigXml.Element) {
                    if ((((int(_local1.@To) == 1015)) && ((GameCommonData.ModuleCloseConfig[10] == 1)))){
                    } else {
                        _local2 = new GameElement(this.Games);
                        _local2.Prams = String(_local1.@To);
                        if (_local2.Prams.length > 4){
                            _local4 = (_local2.Prams.length - 4);
                            _local5 = 0;
                            while (_local5 < _local4) {
                                _local1.@To = ("0" + _local1.@To);
                                _local5++;
                            };
                        };
                        _local2.X = _local1.@X;
                        _local2.Y = _local1.@Y;
                        if (String(_local1.@toname) != ""){
                            _local2.name = ((_local1.@toname + "_") + _local1.@tolevel);
                        };
                        this.bottomLayer.Elements.Add(_local2);
                        this.ConnectScene[String(_local2.Prams)] = _local2;
                    };
                };
            };
            SEElements = [];
            if (ConfigXml.SceneEffect != null){
                for each (_local1 in ConfigXml.SceneEffect) {
                    _local3 = new GameElementSceneEffect(this.Games);
                    _local3.SetParentScene(this);
                    _local3.AnalyseXML(_local1);
                    SEElements.push(_local3);
                };
            };
        }
        public function get MiddleLayer():GameSceneLayer{
            return (this.middleLayer);
        }
        public function VolumeOpen():void{
            if (this.audioEngine != null){
                this.audioEngine.Volume = 100;
            };
        }
        private function sendShow(_arg1:DisplayObject):void{
        }
        public function MusicStop():void{
            if (((this.audioEngine) && (this.audioEngine.IsPlaying))){
                this.audioEngine.Stop();
            };
            clearInterval(this.musicIntervalId);
            this.audioEngine = null;
        }
        override public function Initialize():void{
            this.SceneUrl = (((this.Games.Content.RootDirectory + "Scene/") + this.name) + "/");
            this.configProvider = new GameSceneConfig(this);
            this.configProvider.Progress = onConfigLoadProgress;
            this.ResourceProviderEntity = this.configProvider;
            super.Initialize();
        }
        private function canSeeTransferScene():Boolean{
            var _local1:int;
            var _local2:Point;
            var _local3:GameElement;
            for each (_local3 in this.ConnectScene) {
                _local3 = (this.BottomLayer.Elements[_local1] as GameElement);
                return (true);
            };
            return (false);
        }
        protected function onMouseDown(_arg1:MouseEvent):void{
            if (MouseDown != null){
                MouseDown(_arg1);
            };
        }
        public function get BottomLayer():GameSceneLayer{
            return (this.bottomLayer);
        }
        private function onConfigLoadProgress(_arg1:BulkProgressEvent):void{
            if (GameSceneDataProgress != null){
                GameSceneDataProgress(_arg1);
            };
        }
        public function VolumeClose():void{
            if (this.audioEngine != null){
                this.audioEngine.Volume = 0;
            };
        }
        override public function Update(_arg1:GameTime):void{
            var _local2:int;
            while (_local2 < this.gameSceneLayers.length) {
                this.gameSceneLayers[_local2].Update(_arg1);
                _local2++;
            };
            super.Update(_arg1);
            background.Advance();
        }
        public function GetVolume():int{
            var _local1:int;
            if (this.audioEngine != null){
                _local1 = this.audioEngine.Volume;
            };
            return (_local1);
        }
        public function loadTransfer():void{
            var _local1:GameElement;
            var _local2:Sprite;
            var _local3:Point;
            for each (_local1 in ConnectScene) {
                _local2 = MapManager.getTransferSceneMC();
                if (_local2){
                    _local2.mouseChildren = false;
                    _local2.mouseEnabled = false;
                    _local3 = MapTileModel.GetTilePointToStage(_local1.X, _local1.Y);
                    _local2.x = _local3.x;
                    _local2.y = _local3.y;
                    UIUtils.HandleTrans(_local2, _local1);
                    BottomLayer.addChild(_local2);
                };
            };
        }
        public function get Floor():GameSceneFloor{
            return (this.floor);
        }
        protected function onMouseMove(_arg1:MouseEvent):void{
            if (MouseMove != null){
                MouseDown(_arg1);
            };
        }
		var tempIndex:int=0;
        public function AnalysePathData():void{
            var _local2:uint;
            var _local3:Array;
            var _local6:int;
            var _local1:ByteArray = this.MptByteArray;
            //_local1.uncompress();
            floor = new GameSceneFloor();
            GameCommonData.currentMapVersion = ConfigXml.@version;
			if(tempIndex>0)
			{
				return;
			}
			tempIndex++;
            floor.TileWidth = _local1.readShort();
            floor.TileHeight = _local1.readShort();
            floor.Row = _local1.readShort();
            floor.Col = _local1.readShort();
            this.MapWidth = _local1.readShort();
            this.MapHeight = _local1.readShort();
            floor.OffsetX = 0;
            floor.OffsetY = _local1.readShort();
            MapTileModel.OFFSET_TAB_X = floor.OffsetX;
            MapTileModel.OFFSET_TAB_Y = (floor.OffsetY - 1);
            MapTileModel.TILE_WIDTH = floor.TileWidth;
            MapTileModel.TILE_HEIGHT = floor.TileHeight;
            MapTileModel.TITE_HREF_WIDTH = (floor.TileWidth / 2);
            MapTileModel.TITE_HREF_HEIGHT = (floor.TileHeight / 2);
            floor.Area = new Array();
            var _local4:int;
            while (_local4 < 10) {
                _local1.readInt();
                _local4++;
            };
            var _local5:int;
            while (_local5 < floor.Row) {
                _local3 = [];
                floor.Area.push(_local3);
                _local6 = 0;
                while (_local6 < floor.Col) {
					
                    _local3.push(_local1.readByte());
                    _local6++;
                };
                _local5++;
            };
            this.Map = new MapTileModel();
            this.Map.Map = floor.Area;
        }
        public function get MouseEnabled():Boolean{
            return (this.mouseEnabled);
        }
        public function Dispose():void{
            var _local1:IDisposable;
            var _local2:int;
            var _local3:*;
            this.Enabled = false;
            this.MouseEnabled = false;
            this.mouseChildren = false;
            this.Map = null;
            this.SmallMap = null;
            this.RealSmallMap = null;
            this.floor = null;
            for each (_local3 in ResourceLoadingQueue) {
                if ((_local3 is GameElementSkins)){
                    _local3.dispose();
                };
            };
            this.ResourceLoadingQueue = null;
            this.CacheResource = null;
            this.ConnectScene = null;
            _local2 = 0;
            while (_local2 < this.gameSceneLayers.length) {
                _local1 = (this.gameSceneLayers[_local2] as IDisposable);
                _local1.Dispose();
                _local2++;
            };
            if (((background) && (background.parent))){
                this.removeChild(background);
            };
            this.gameSceneLayers = null;
            this.background = null;
            this.MusicStop();
            if (this.parent != null){
                this.parent.removeChild(this);
            };
            if (Disposed != null){
                Disposed();
            };
        }

    }
}//package OopsEngine.Scene 
