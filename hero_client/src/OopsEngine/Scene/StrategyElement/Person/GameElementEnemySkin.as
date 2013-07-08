//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;
    import OopsEngine.Graphics.Animation.*;
    import OopsFramework.Content.Loading.*;
    import OopsFramework.Content.Provider.*;

    public class GameElementEnemySkin extends GameElementSkins {

        public static var enemyLoader:BulkLoader = GameCommonData.playerResourceLoader;

        private var actionResource:LoadingItem;
        private var action:GameElementEnemyAnimation;
        public var skintype:int = 0;

        public function GameElementEnemySkin(_arg1:GameElementAnimal){
            super(_arg1);
        }
        override protected function SetActionAndDirection(_arg1:int=0):void{
            if (this.gep.Role.ActionState.indexOf(GameElementSkins.ACTION_STATIC) > -1){
                if (staticFrameRate == 0){
                    this.FrameRate = 2;
                } else {
                    this.FrameRate = staticFrameRate;
                };
            } else {
                if (this.gep.Role.ActionState.indexOf(GameElementSkins.ACTION_DEAD) > -1){
                    this.FrameRate = 9;
                    this.mouseChildren = false;
                    this.mouseEnabled = false;
                } else {
                    if (this.gep.Role.ActionState.indexOf(GameElementSkins.ACTION_RUN) > -1){
                        if (runFrameRate == 0){
                            this.FrameRate = 8;
                        } else {
                            this.FrameRate = runFrameRate;
                        };
                    } else {
                        this.FrameRate = 9;
                    };
                };
            };
            if (this.action != null){
                this.action.StartClip((this.currentActionType + this.currentDirection), _arg1);
            };
        }
        private function onPersonResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementEnemyData;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onPersonResourceComplete);
            if (_arg1.currentTarget.loader.content){
                _local2 = _arg1.currentTarget.loader.content;
                _local3 = new GameElementEnemyData(skintype);
                _local3.Analyze(_local2);
                lazyLoadComplete(_local3, (_arg1.currentTarget as LoadingItem));
                _local2 = null;
            };
        }
        override public function LoadSkin(_arg1:String=null):void{
            var _local2:String;
            if (this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] != null){
                if (this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] != true){
                    this.LoadComplete();
                } else {
                    if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] == null){
                        this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] = new Array();
                        this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName].push(this);
                    } else {
                        this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName].push(this);
                    };
                };
            } else {
                this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] = true;
                _local2 = (this.gep.Games.Content.RootDirectory + this.gep.Role.PersonSkinName);
                enemyLoader.Add(_local2, false, null, 1, 2);
                this.actionResource = enemyLoader.GetLoadingItem(_local2);
                this.actionResource.name = _local2;
                this.actionResource.addEventListener(Event.COMPLETE, onPersonResourceComplete);
                enemyLoader.Load();
            };
        }
        public function ChangePerson(_arg1:Boolean=false):void{
            var _local2:String;
            this.gep.IsLoadSkins = false;
            if (this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] != null){
                if (this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] != true){
                    this.LoadComplete();
                } else {
                    if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] == null){
                        this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] = new Array();
                        this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName].push(this);
                    } else {
                        this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName].push(this);
                    };
                };
            } else {
                this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] = true;
                _local2 = (this.gep.Games.Content.RootDirectory + this.gep.Role.PersonSkinName);
                enemyLoader.Add(_local2);
                this.actionResource = enemyLoader.GetLoadingItem(_local2);
                this.actionResource.name = _local2;
                this.actionResource.addEventListener(Event.COMPLETE, onPersonResourceComplete);
                enemyLoader.Load();
            };
        }
        override public function dispose():void{
            if (this.action){
                if (this.action.parent){
                    this.action.parent.removeChild(this.action);
                };
                this.action.dispose();
                this.action = null;
            };
            super.dispose();
        }
        public function GetAction():AnimationPlayer{
            return (action);
        }
        override protected function ActionPlaying(_arg1:GameTime):void{
            if (this.action != null){
                this.action.Update(_arg1);
            };
        }
        private function lazyLoadComplete(_arg1:GameElementEnemyData, _arg2:LoadingItem):void{
            var _local4:Array;
            var _local5:GameElementSkins;
            var _local3:String = String(_arg2.name).substring(this.gep.Games.Content.RootDirectory.length);
            if (SkinLoadComplete != null){
                SkinLoadComplete(_local3, _arg1);
            };
            if (_local3 == gep.Role.PersonSkinName){
                this.LoadComplete();
            } else {
                if (((this.gep.gameScene) && (!((this.gep.gameScene.ResourceLoadingQueue[_local3] == null))))){
                    _local4 = this.gep.gameScene.ResourceLoadingQueue[_local3];
                    _local5 = _local4.shift();
                    while (_local5 != null) {
                        _local5.LoadComplete();
                        _local5 = _local4.shift();
                    };
                };
            };
            enemyLoader.RemoveItem(_arg2.name);
            this.actionResource = null;
        }
        override public function RemovePersonSkin(_arg1:String):void{
            switch (_arg1){
                case GameElementSkins.EQUIP_PERSON:
                    if (this.action != null){
                        this.removeChild(this.action);
                        this.action = null;
                        gep.Role.PersonSkinName = null;
                    };
                    break;
            };
            if (ChangeEquip != null){
                ChangeEquip(_arg1);
            };
            if (ChangeSkins != null){
                ChangeSkins(_arg1, this.gep);
            };
        }
        override protected function onMouseMove(_arg1:MouseEvent):void{
            var _local2:uint = action.bitmapData.getPixel32(Math.abs((this.mouseX - action.x)), Math.abs((this.mouseY - action.y)));
            var _local3:uint = ((_local2 >> 24) & 0xFF);
            if (_local2 != 0){
                this.AddHighlight();
            } else {
                this.DeleteHighlight();
            };
        }
        override public function LoadComplete():void{
            var _local1:Array;
            var _local2:GameElementSkins;
            if ((((this.gep.gameScene.CacheResource == null)) || (!((this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] is GameElementEnemyData))))){
                trace("加载太慢，导致怪物变形时前一个形象还没加载完");
                return;
            };
            if (((action) && (action.parent))){
                action.parent.removeChild(action);
                this.action.dispose();
            };
            this.action = new GameElementEnemyAnimation();
            this.action.PlayComplete = this.ActionPlayComplete;
            this.action.PlayFrame = this.ActionPlayFrame;
            var _local3:GameElementEnemyData = this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName];
            _local3.SetAnimationData(this.action);
            this.addChild(this.action);
            this.MaxBodyWidth = this.action.MaxWidth;
            this.MaxBodyHeight = this.action.MaxHeight;
            if (BodyLoadComplete != null){
                BodyLoadComplete();
            };
            if (this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName] != null){
                _local1 = this.gep.gameScene.ResourceLoadingQueue[this.gep.Role.PersonSkinName];
                _local2 = _local1.shift();
                while (_local2 != null) {
                    _local2.LoadComplete();
                    _local2 = _local1.shift();
                };
            };
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
