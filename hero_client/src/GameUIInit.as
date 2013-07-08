//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import OopsFramework.Content.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import OopsFramework.Content.Loading.*;
    import GameUI.Modules.Chat.Data.*;
    import Utils.*;
    import OopsFramework.Content.Provider.*;
    import Net.RequestSend.*;
    import GameUI.*;

	/**
	 *游戏初始化UI加载类 
	 * @author wengliqiang
	 * 
	 */	
    public class GameUIInit extends BulkLoaderResourceProvider {

        private var loadItemArr:Array;

        public function GameUIInit(_arg1:MyGame){
            loadItemArr = [];
            super(1, _arg1);
            setLoadItemArr();
            this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.UILibrary), false, null, 5);
            this.Load();
            CharacterSend.sendCurrentStep("GameUIInit开始加载");
        }
        private function removeLoad():void{
        }
        private function showJindu(_arg1:BulkProgressEvent):void{
            var _local2:uint = _arg1.ItemsLoaded;
            var _local3:uint = _arg1.ItemsTotal;
            var _local4:String = loadItemArr[_local2];
            if (GameCommonData.Tiao){
                if (_local4){
                   // GameCommonData.Tiao.content_txt.text = _local4;
                };
               // GameCommonData.Tiao.numPercent_txt.text = (Math.round((_arg1.WeightPercent * 100)) + "%");
                //GameCommonData.Tiao.progressMask.width = ((_arg1.BytesLoaded / _arg1.BytesTotal) * GameCommonData.Tiao.progressMc.width);
               // GameCommonData.Tiao.lightAsset.x = (GameCommonData.Tiao.progressMask.x + GameCommonData.Tiao.progressMask.width);
                if (_arg1.ItemsSpeed < 2000){
                   // GameCommonData.Tiao.num_txt.text = (Math.round(_arg1.ItemsSpeed) + "kb/s");
                } else {
                   // GameCommonData.Tiao.num_txt.text = (Math.round((_arg1.ItemsSpeed / 0x0400)) + "mb/s");
                };
            };
        }
        private function setLoadItemArr():void{
            if (UIConstData.Filter_Switch == false){
                loadItemArr = ["正在加载资源库（1/3）.....", "正在加载公告数据（2/3）.....", "正在加载坐骑数据（3/3）....."];
            } else {
                loadItemArr = ["正在加载资源库（1/5）....."];
            };
        }
        override protected function onBulkCompleteAll():void{
            if (GameCommonData.UICom){
                new GameInit(GameCommonData.GameInstance);
            } else {
                GameCommonData.UICom = true;
            };
        }
        override protected function onBulkComplete(_arg1:BulkProgressEvent):void{
            CharacterSend.sendCurrentStep(("GameUIInit加载完" + _arg1.BytesLoaded.toString()));
            super.onBulkComplete(_arg1);
        }
        override protected function onBulkProgress(_arg1:BulkProgressEvent):void{
            super.onBulkProgress(_arg1);
            if (GameCommonData.Tiao){
                showJindu(_arg1);
            };
        }

    }
}//package 
