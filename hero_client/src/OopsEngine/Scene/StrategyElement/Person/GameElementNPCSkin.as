//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import flash.events.*;
    import flash.display.*;
    import OopsFramework.*;
    import OopsEngine.Scene.StrategyElement.*;
    import OopsEngine.Graphics.Animation.*;
    import OopsEngine.Utils.*;
    import OopsFramework.Content.Loading.*;
    import OopsFramework.Content.Provider.*;
    import Net.RequestSend.*;

    public class GameElementNPCSkin extends GameElementSkins {

        public static var npcLoader:BulkLoader = new BulkLoader(1);

        private var actionResource:LoadingItem;
        private var normalActionCount:int = 0;
        private var action:AnimationPlayer;
        private var normalActionCountMax:int = 3;

        public function GameElementNPCSkin(_arg1:GameElementAnimal){
            super(_arg1);
            this.FrameRate = 1;
        }
        override protected function SetActionAndDirection(_arg1:int=0):void{
            if (this.action != null){
                this.action.StartClip((this.currentActionType + this.currentDirection), _arg1);
            };
        }
        private function onActionPlayComplete(_arg1:AnimationEventArgs):void{
            if (((!((this.gep.Role.ActionState == GameElementSkins.ACTION_MOUNT_STATIC))) && (!((this.gep.Role.ActionState == GameElementSkins.ACTION_MOUNT_RUN))))){
                this.gep.Role.ActionState = GameElementSkins.ACTION_STATIC;
            };
            this.ChangeAction(this.gep.Role.ActionState);
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
                npcLoader.Add(_local2);
                actionResource = npcLoader.GetLoadingItem(_local2);
                actionResource.addEventListener(Event.COMPLETE, onPersonResourceComplete);
                actionResource.addEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
                actionResource.name = _local2;
                npcLoader.Load();
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
                npcLoader.Add(_local2);
                actionResource = npcLoader.GetLoadingItem(_local2);
                actionResource.addEventListener(Event.COMPLETE, onPersonResourceComplete);
                actionResource.addEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
                actionResource.name = _local2;
                npcLoader.Load();
            };
        }
        override public function dispose():void{
            if (this.action){
                if (this.action.parent){
                    this.action.parent.removeChild(this.action);
                };
                this.action = null;
            };
            super.dispose();
        }
        private function onPersonResourceComplete(_arg1:Event):void{
            var _local2:MovieClip;
            var _local3:GameElementNPCData;
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, onPersonResourceComplete);
            _arg1.currentTarget.removeEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
            if (_arg1.currentTarget.loader.content){
                _local2 = _arg1.currentTarget.loader.content;
                _local3 = new GameElementNPCData();
                _local3.Analyze(_local2);
                lazyLoadComplete(_local3);
                _local2 = null;
            };
        }
        override protected function onMouseDown(_arg1:MouseEvent):void{
            super.onMouseDown(_arg1);
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
        override protected function ActionPlaying(_arg1:GameTime):void{
            if (this.action != null){
                this.action.Update(_arg1);
            };
        }
        private function lazyLoadComplete(_arg1:GameElementNPCData):void{
            if (SkinLoadComplete != null){
                SkinLoadComplete(this.gep.Role.PersonSkinName, _arg1);
            };
            this.LoadComplete();
            npcLoader.RemoveItem(actionResource.name);
            actionResource = null;
        }
        public function GetAction():AnimationPlayer{
            return (action);
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
        private function onPersonSkinError(_arg1:ErrorEvent):void{
            _arg1.currentTarget.removeEventListener(BulkProgressEvent.ERROR, onPersonSkinError);
            CharacterSend.sendCurrentStep(("error:NPC资源加载失败" + this.gep.Role.PersonSkinName));
        }
        override public function LoadComplete():void{
            var _local1:Array;
            var _local2:GameElementSkins;
            if ((((this.gep.gameScene.CacheResource == null)) || (!((this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName] is GameElementNPCData))))){
                return;
            };
            this.action = new AnimationPlayer();
            this.action.PlayComplete = onActionPlayComplete;
            var _local3:GameElementNPCData = this.gep.gameScene.CacheResource[this.gep.Role.PersonSkinName];
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
