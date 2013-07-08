//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import OopsFramework.*;
    import OopsEngine.Utils.*;
    import OopsFramework.Collections.*;

	/**
	 *游戏场景组件 
	 * @author wengliqiang
	 * 
	 */	
    public class GameSceneComponent extends DrawableGameComponent {

        private var gameScenes:DictionaryCollection;
        private var currentGameScene:GameScene;
        private var previousGameScene:GameScene;
        private var gameSceneClass:Class;
        public var GameSceneTransferOpen:Function;
        public var GameSceneDataProgress:Function;
        public var GameSceneLoadComplete:Function;

        public function GameSceneComponent(_arg1:Game){
            super(_arg1);
            this.name = "GameSceneComponent";
            this.mouseEnabled = false;
            this.gameScenes = new DictionaryCollection();
        }
        public function get GetGameScene():GameScene{
            return (this.currentGameScene);
        }
        public function get GameScenes():DictionaryCollection{
            return (this.gameScenes);
        }
        public function StartScene(_arg1:String):void{
            if (this.gameScenes[_arg1] != null){
                this.gameSceneClass = (this.gameScenes[_arg1] as Class);
            };
        }
        public function TransferScene(_arg1:String, _arg2:String):void{
            this.previousGameScene = this.currentGameScene;
            if (this.previousGameScene != null){
                this.previousGameScene.MusicStop();
            };
            this.currentGameScene = new this.gameSceneClass(this.Games);
            this.currentGameScene.name = _arg1;
            this.currentGameScene.MapId = _arg2;
            this.currentGameScene.GameSceneDataProgress = this.GameSceneDataProgress;
            this.currentGameScene.GameSceneLoadComplete = onGameSceneLoadComplete;
            if (GameSceneTransferOpen != null){
                GameSceneTransferOpen();
            };
            this.currentGameScene.Initialize();
            this.addChild(this.currentGameScene);
        }
        override public function Update(_arg1:GameTime):void{
            if (((!((this.currentGameScene == null))) && (this.currentGameScene.Enabled))){
                this.currentGameScene.Update(_arg1);
            };
            super.Update(_arg1);
        }
        private function onGameSceneLoadComplete():void{
            if (this.previousGameScene != null){
                this.previousGameScene.Dispose();
                this.previousGameScene = null;
                System.CollectEMS();
            };
            if (GameSceneLoadComplete != null){
                GameSceneLoadComplete(this.currentGameScene);
            };
        }

    }
}//package OopsEngine.Scene 
