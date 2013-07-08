//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.Content.*;
    import flash.utils.*;
    import OopsFramework.Content.Provider.*;
    import flash.ui.*;

	/**
	 *游戏处理显示类 
	 * @author wengliqiang
	 * 
	 */	
    public class Game extends Sprite {

        public var KeyDown:Function;
        private var isRun:Boolean;
        public var ResourceProviderEntity:ResourceProvider;
        private var updateableComponents:Array;
        public var MainStage:Stage;
        private var gameComponents:GameComponentCollection;
        private var doneFirstUpdate:Boolean = false;
        public var KeyUp:Function;
        private var screenWidth:uint;
        private var screenHeight:uint;
        public var Resize:Function;
        private var isMouseVisible:Boolean = true;
        private var keyboardEnabled:Boolean = true;
        private var gameTime:GameTime;
        private var currentlyUpdatingComponents:Array;
        private var content:ContentManager;
        private var notYetInitialized:Array;

        public function Game(_arg1:Stage=null){
            gameTime = new GameTime();
            updateableComponents = [];
            currentlyUpdatingComponents = [];
            notYetInitialized = [];
            super();
            this.Run(_arg1);
        }
        private function onUpdate(_arg1:Event):void{
            var _local2:int = getTimer();
            this.gameTime.ElapsedGameTime = (_local2 - this.gameTime.TotalGameTime);
            this.gameTime.TotalGameTime = _local2;
            this.Update(gameTime);
        }
        protected function LoadContent():void{
        }
        public function get ScreenWidth():uint{
            return (this.screenWidth);
        }
        protected function Initialize():void{
            var _local1:IGameComponent;
            while (this.notYetInitialized.length != 0) {
                _local1 = (this.notYetInitialized.shift() as IGameComponent);
                _local1.Initialize();
            };
            if (this.ResourceProviderEntity == null){
                this.LoadContent();
            } else {
                this.ResourceProviderEntity.LoadComplete = LoadContent;
                this.ResourceProviderEntity.Load();
            };
        }
        private function GameComponentAdded(_arg1:IGameComponent):void{
            var _local2:IUpdateable;
            if ((_arg1 is IUpdateable)){
                this.updateableComponents.push(_arg1);
                this.updateableComponents.sortOn("UpdateOrder", Array.NUMERIC);
                _local2 = (_arg1 as IUpdateable);
                _local2.UpdateOrderChanged = onUpdateOrderChanged;
            };
            if ((_arg1 is IDrawable)){
                this.addChild((_arg1 as DrawableGameComponent));
            };
            if (doneFirstUpdate){
                _arg1.Initialize();
            } else {
                this.notYetInitialized.push(_arg1);
            };
        }
        public function get Components():GameComponentCollection{
            return (this.gameComponents);
        }
        protected function onKeyUp(_arg1:KeyboardEvent):void{
            if (KeyUp != null){
                KeyUp(_arg1);
            };
        }
        private function onUpdateOrderChanged(_arg1:GameComponent):void{
            this.updateableComponents.sortOn("UpdateOrder", Array.NUMERIC);
        }
        public function get KeyboardEnabled():Boolean{
            return (this.keyboardEnabled);
        }
        protected function onKeyDown(_arg1:KeyboardEvent):void{
            if (KeyDown != null){
                KeyDown(_arg1);
            };
        }
        public function get ScreenHeight():uint{
            return (this.screenHeight);
        }
        public function getGameTime():GameTime{
            return (this.gameTime);
        }
        public function get Content():ContentManager{
            return (this.content);
        }
        private function GameComponentRemoved(_arg1:IGameComponent):void{
            var _local2:int;
            if (this.isRun == false){
                _local2 = this.notYetInitialized.indexOf(_arg1);
                if (_local2 > -1){
                    this.notYetInitialized.splice(_arg1, 1);
                };
            };
            var _local3:IUpdateable = (_arg1 as IUpdateable);
            if (_local3 != null){
                _local2 = this.updateableComponents.indexOf(_local3);
                if (_local2 > -1){
                    this.updateableComponents.splice(_local3, 1);
                };
            };
            if ((_arg1 is IDrawable)){
                this.removeChild((_arg1 as DrawableGameComponent));
            };
        }
        protected function Update(_arg1:GameTime):void{
            var _local2:IUpdateable;
            var _local3:int;
            this.currentlyUpdatingComponents = this.updateableComponents.concat();
            while (_local3 < this.currentlyUpdatingComponents.length) {
                _local2 = (this.currentlyUpdatingComponents[_local3] as IUpdateable);
                if (_local2.Enabled){
                    _local2.Update(_arg1);
                };
                _local3++;
            };
            this.currentlyUpdatingComponents = [];
            this.doneFirstUpdate = true;
        }
        private function Run(_arg1:Stage):void{
            if (_arg1 == null){
                this.MainStage = this.stage;
            } else {
                this.MainStage = _arg1;
            };
            this.MainStage.frameRate = GameConfigData.GameFrameRate;
            this.MainStage.align = StageAlign.TOP_LEFT;
            this.MainStage.scaleMode = StageScaleMode.NO_SCALE;
            this.MainStage.stageFocusRect = false;
            this.screenWidth = this.MainStage.stageWidth;
            this.screenHeight = this.MainStage.stageHeight;
            this.mouseEnabled = false;
            this.KeyboardEnabled = true;
            this.gameComponents = new GameComponentCollection();
            this.gameComponents.Added = GameComponentAdded;
            this.gameComponents.Removed = GameComponentRemoved;
            this.content = new ContentManager();
            this.Initialize();
            this.isRun = true;
            this.Update(this.gameTime);
            this.MainStage.addEventListener(Event.RESIZE, onResize);
            this.MainStage.addEventListener(Event.ENTER_FRAME, onUpdate);
        }
        private function onResize(_arg1:Event):void{
            this.screenWidth = this.MainStage.stageWidth;
            this.screenHeight = this.MainStage.stageHeight;
            if (Resize != null){
                Resize(_arg1);
            };
        }
        public function set KeyboardEnabled(_arg1:Boolean):void{
            this.keyboardEnabled = _arg1;
            if (this.keyboardEnabled){
                this.MainStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                this.MainStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            } else {
                this.MainStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                this.MainStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            };
        }
        public function set IsMouseVisible(_arg1:Boolean):void{
            if (_arg1){
                Mouse.show();
            } else {
                Mouse.hide();
            };
            this.isMouseVisible = _arg1;
        }
        public function get IsMouseVisible():Boolean{
            return (this.isMouseVisible);
        }

    }
}//package OopsFramework 
