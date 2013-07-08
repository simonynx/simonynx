//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import OopsEngine.Scene.*;
    import flash.geom.*;
    import OopsFramework.Content.Loading.*;
    import OopsEngine.AI.PathFinder.*;
    import flash.system.*;

    public class GameElementSceneEffect extends GameElement {

        private static const TYPE_MAINCODE:int = 1;
        private static const TYPE_DEFAULT:int = 0;

        public static var loader:BulkLoader = new BulkLoader(1);

        private var type:String;
        private var _ScaleValue:Number;
        private var _ContentWidth:uint;
        private var loadItem:LoadingItem;
        private var swfType:int = -1;
        private var _gameScene:GameScene;
        private var _ContentHeight:uint;
        private var resPath:String;
        private var displayObject:DisplayObject;
        private var _AlphaValue:Number;
        public var Id:uint;

        public function GameElementSceneEffect(_arg1:Game){
            super(_arg1);
        }
        public function set ContentHeight(_arg1:uint):void{
            _ContentHeight = _arg1;
        }
        public function AnalyseXML(_arg1:XML):void{
            this.type = String(_arg1.@Type);
            this.Id = int(_arg1.@Id);
            var _local2:Point = MapTileModel.GetTilePointToStage(int(_arg1.@X), int(_arg1.@Y));
            this.X = _local2.x;
            this.Y = _local2.y;
            this.ContentWidth = int(_arg1.@ContentWidth);
            this.ContentHeight = int(_arg1.@ContentHeight);
            this.ScaleValue = Number(_arg1.@ScaleValue);
            Enabled = true;
            resPath = (("Resources/SceneEffect/" + type) + ".swf");
        }
        public function set ScaleValue(_arg1:Number):void{
            _ScaleValue = _arg1;
            this.scaleX = (this.scaleY = this.ScaleValue);
        }
        private function onError(_arg1:IOErrorEvent):void{
        }
        override public function Dispose():void{
            super.Dispose();
            while (this.numChildren) {
                this.removeChildAt(0);
            };
        }
        public function set ContentWidth(_arg1:uint):void{
            _ContentWidth = _arg1;
        }
        public function LoadComplete():void{
            var _local1:Array;
            var _local2:GameElementSceneEffect;
            var _local3:SkillAnimation;
            var _local4:LoaderInfo;
            var _local5:Class;
            var _local6:*;
            var _local7:Function;
            if (this.gameScene.CacheResource == null){
                return;
            };
            if ((((this.gameScene.CacheResource[resPath] is LoaderInfo)) && (this.gameScene.CacheResource[resPath].applicationDomain.hasDefinition("Main")))){
                this.swfType = TYPE_MAINCODE;
            } else {
                if ((this.gameScene.CacheResource[resPath] is GameSkillData)){
                    this.swfType = TYPE_DEFAULT;
                };
            };
            if (swfType == TYPE_DEFAULT){
                _local3 = GetAnimation(resPath);
                displayObject = _local3;
                addChild(displayObject);
                _local3.isLoop = true;
                _local3.StartClip("jn", 0, 12);
            } else {
                if (swfType == TYPE_MAINCODE){
                    _local4 = this.gameScene.CacheResource[resPath];
                    if (((_local4) && (_local4.applicationDomain.hasDefinition("Main")))){
                        _local5 = (_local4.applicationDomain.getDefinition("Main") as Class);
                        _local6 = new (_local5)();
                        if ((_local6 is DisplayObject)){
                            displayObject = _local6;
                            addChild(_local6);
                            _local6.cacheAsBitmap = true;
                            this.scaleX = (this.scaleY = this.ScaleValue);
                            if (((stage) && (_local6.hasOwnProperty("setWH")))){
                                _local7 = _local6.setWH;
                                _local7(ContentWidth, ContentHeight);
                            };
                        };
                    };
                };
            };
            if (this.gameScene.ResourceLoadingQueue[resPath] != null){
                _local1 = this.gameScene.ResourceLoadingQueue[resPath];
                _local2 = _local1.shift();
                while (_local2 != null) {
                    _local2.LoadComplete();
                    _local2 = _local1.shift();
                };
            };
        }
        public function SetParentScene(_arg1:GameScene):void{
            this._gameScene = _arg1;
        }
        public function get AlphaValue():Number{
            return (_AlphaValue);
        }
        public function set AlphaValue(_arg1:Number):void{
            _AlphaValue = _arg1;
        }
        public function get ContentHeight():uint{
            return (_ContentHeight);
        }
        override public function Update(_arg1:GameTime):void{
            super.Update(_arg1);
            if ((displayObject is SkillAnimation)){
                (displayObject as SkillAnimation).Update(_arg1);
            };
        }
        private function onResourceLoadComplete(_arg1:Event):void{
            var loadInfo:* = undefined;
            var geed:* = null;
            var animationSkill:* = null;
            var event:* = _arg1;
            event.currentTarget.removeEventListener(Event.COMPLETE, onResourceLoadComplete);
            if (((((((((((((event.currentTarget) && (event.currentTarget.loader))) && (event.currentTarget.loader.content))) && (event.currentTarget.content))) && (this.gameScene))) && (this.gameScene.CacheResource))) && (loadItem))){
                loadInfo = event.currentTarget.content;
                if (((loadInfo) && (loadInfo.applicationDomain.hasDefinition("Main")))){
                    this.gameScene.CacheResource[resPath] = loadInfo;
                } else {
                    try {
                        animationSkill = SkillAnimation.createSkillAnimation();
                        animationSkill.IsPool = true;
                        geed = new GameSkillData(animationSkill);
                        geed.Analyze(loadInfo.content);
                        this.gameScene.CacheResource[resPath] = geed;
                    } catch(e:Error) {
                        throw (new Error(("EffectName  " + loadInfo.content.name)));
                    };
                };
                loader.RemoveItem(loadItem.name);
                this.loadItem = null;
                LoadComplete();
            };
        }
        public function get ContentWidth():uint{
            return (_ContentWidth);
        }
        public function GetAnimation(_arg1:String):SkillAnimation{
            var _local2:SkillAnimation = SkillAnimation.createSkillAnimation();
            _local2.IsPool = true;
            var _local3:GameSkillData = this.gameScene.CacheResource[_arg1];
            _local3.SetAnimationData(_local2);
            return (_local2);
        }
        override public function Initialize():void{
            loadSwf();
        }
        public function get gameScene():GameScene{
            return (_gameScene);
        }
        private function loadSwf():void{
            var _local1:String;
            var _local2:LoaderContext;
            if (this.gameScene.CacheResource[resPath] != null){
                if (this.gameScene.CacheResource[resPath] != true){
                    this.LoadComplete();
                } else {
                    if (this.gameScene.ResourceLoadingQueue[resPath] == null){
                        this.gameScene.ResourceLoadingQueue[resPath] = new Array();
                    };
                    this.gameScene.ResourceLoadingQueue[resPath].push(this);
                };
            } else {
                this.gameScene.CacheResource[resPath] = true;
                _local1 = (this.Games.Content.RootDirectory + resPath);
                loader.Add(_local1);
                this.loadItem = loader.GetLoadingItem(_local1);
                this.loadItem.name = _local1;
                _local2 = new LoaderContext();
                _local2.applicationDomain = new ApplicationDomain();
                this.loadItem.context = _local2;
                this.loadItem.addEventListener(Event.COMPLETE, onResourceLoadComplete);
                loader.Load();
            };
        }
        private function onBulkError(_arg1:BulkProgressEvent):void{
        }
        public function get ScaleValue():Number{
            return (_ScaleValue);
        }

    }
}//package OopsEngine.Scene.StrategyElement 
