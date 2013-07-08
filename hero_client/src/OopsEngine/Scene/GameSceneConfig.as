//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import flash.display.*;
    import OopsFramework.Content.*;
    import flash.geom.*;
    import OopsFramework.Content.Loading.*;
    import OopsFramework.Content.Provider.*;
    import OopsEngine.Exception.*;

	/**
	 *游戏场景配置数据加载类
	 * @author wengliqiang
	 * 
	 */	
    public class GameSceneConfig extends BulkLoaderResourceProvider {

        private var mptFileUrl:String;
        private var smallUrl:String;
        private var configXmlUrl:String;
        public var Progress:Function;
        private var gameScene:GameScene;

        public function GameSceneConfig(_arg1:GameScene){
            this.gameScene = _arg1;
            var _local2 = "";
            if (GameCommonData.MapConfigs[this.gameScene.name] != null){
                GameCommonData.currentMapVersion = GameCommonData.MapConfigs[this.gameScene.name].@version;
                if (GameCommonData.currentMapVersion != 0){
                    _local2 = (_local2 + ("?v=" + GameCommonData.currentMapVersion));
                };
            };
			
            this.mptFileUrl = (((this.gameScene.SceneUrl + this.gameScene.name) + ".mpt") + _local2);
			trace("mptFileUrl-----------------------"+mptFileUrl);
            this.smallUrl = ((((this.gameScene.Games.Content.RootDirectory + "Scene/") + this.gameScene.name) + "/Small.jpg") + _local2);
        }
        override protected function onBulkProgress(_arg1:BulkProgressEvent):void{
            super.onBulkProgress(_arg1);
            if (Progress != null){
                Progress(_arg1);
            };
        }
        override public function Load():void{
            this.Download.Add(this.mptFileUrl);
            this.Download.Add(this.smallUrl);
            LoadCompleteOne = SourceLoadComplete;
            super.Load();
        }
        private function SourceLoadComplete(_arg1:ContentTypeReader):void{
            if (mptFileUrl == _arg1.Name){
                this.gameScene.MptByteArray = this.GetResource(this.mptFileUrl).GetByteArray();
                this.gameScene.ConfigXml = GameCommonData.MapConfigs[this.gameScene.name];
                this.gameScene.SmallMap = new Bitmap();
                this.gameScene.RealSmallMap = new Bitmap(this.gameScene.SmallMap.bitmapData);
                if (LoadComplete != null){
                    LoadComplete();
                    LoadComplete = null;
                };
            };
            if (this.GetResource(this.smallUrl) != null){
                if (this.gameScene.SmallMap != null){
                    this.gameScene.SmallMap.bitmapData = this.GetResource(this.smallUrl).GetBitmap().bitmapData;
                    this.gameScene.RealSmallMap.bitmapData = this.gameScene.SmallMap.bitmapData;
                    super.onBulkCompleteAll();
                    this.gameScene.Background.ResetMask();
                };
                return;
            };
        }
        override protected function onBulkError(_arg1:BulkProgressEvent):void{
            throw (new Error(((ExceptionResources.ErrorGameSceneConfig + "：") + _arg1.ErrorMessage)));
        }
        override protected function onBulkCompleteAll():void{
        }

    }
}//package OopsEngine.Scene 
