//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import OopsFramework.Content.Loading.*;
    import OopsFramework.Content.Provider.*;

	/**
	 *游戏角色加载管理类
	 * @author wengliqiang
	 * 
	 */	
    public class GameRoleManager extends BulkLoaderResourceProvider {

        private var loadType:int;
        private var completeFun:Function;

        public function GameRoleManager(_arg1:MyGame, _arg2:int, _arg3:Function){
            this.completeFun = _arg3;
            this.loadType = _arg2;
            super(1, _arg1);
            if (loadType == 0){
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.UILibrarySelectRole));
            } else {
                if (loadType == 1){
                    this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.UILibraryCreateRoleSimple));
                    this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.RandomNameDic));
                };
            };
            this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.FilterDic));
            this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.LanguagePack));
            this.Download.Load();
        }
        override public function dispose():void{
            this.completeFun = null;
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.UILibraryCreateRoleSimple);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.RandomNameDic);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.UILibrarySelectRole);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.FilterDic);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.LanguagePack);
            this.RemoveResource((this.Games.Content.RootDirectory + GameConfigData.UILibraryCreateRoleSimple));
            this.RemoveResource((this.Games.Content.RootDirectory + GameConfigData.RandomNameDic));
            this.RemoveResource((this.Games.Content.RootDirectory + GameConfigData.UILibrarySelectRole));
            this.RemoveResource((this.Games.Content.RootDirectory + GameConfigData.FilterDic));
            this.RemoveResource((this.Games.Content.RootDirectory + GameConfigData.LanguagePack));
            super.dispose();
        }
        override protected function onBulkProgress(_arg1:BulkProgressEvent):void{
            super.onBulkProgress(_arg1);
            if (GameCommonData.Tiao){
                //GameCommonData.Tiao.progressMask.width = ((_arg1.BytesLoaded / _arg1.BytesTotal) * GameCommonData.Tiao.progressMc.width);
                //GameCommonData.Tiao.lightAsset.x = (GameCommonData.Tiao.progressMask.x + GameCommonData.Tiao.progressMask.width);
                //GameCommonData.Tiao.numPercent_txt.text = (Math.round(((_arg1.BytesLoaded / _arg1.BytesTotal) * 100)) + "%");
                if (loadType == 0){
                   // GameCommonData.Tiao.content_txt.text = "正在加载选择角色信息.....";
                } else {
                    if (loadType == 1){
                       // GameCommonData.Tiao.content_txt.text = "正在加载创建角色信息.....";
                    };
                };
                if (_arg1.ItemsSpeed < 0x0400){
                   // GameCommonData.Tiao.num_txt.text = (Math.round(_arg1.ItemsSpeed) + "kb/s");
                } else {
                   // GameCommonData.Tiao.num_txt.text = (Math.round((_arg1.ItemsSpeed / 0x0400)) + "mb/s");
                };
            };
        }
        override protected function onBulkCompleteAll():void{
            var _local1:uint;
            var _local2:XML;
            GameCommonData.UIFacadeIntance = UIFacade.GetInstance();
            if (GameCommonData.Tiao){
               // GameCommonData.Tiao.content_txt.text = "正在验证角色信息.....";
            };
            if (this.GetResource((this.Games.Content.RootDirectory + GameConfigData.FilterDic))){
               // UIConstData.Filter_chat = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.FilterDic)).GetDisplayObject()["filter_dic_chat"];
                LanguageMgr.setup(this.GetResource((this.Games.Content.RootDirectory + GameConfigData.LanguagePack)).GetText());
                _local1 = 0;
                while (_local1 < 6) {
                    GameCommonData.RolesListDic[_local1] = LanguageMgr.GetTranslation(("职业" + _local1.toString()));
                    _local1++;
                };
                UIConstData.Filter_Switch = true;
            };
            if (this.GetResource((this.Games.Content.RootDirectory + GameConfigData.RandomNameDic))){
                _local2 = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.RandomNameDic)).GetXML();
                UIConstData.RandomNameArr[0][0] = _local2.man.firstname[0].split(",");
                UIConstData.RandomNameArr[0][1] = _local2.man.lastname[0].split(",");
                UIConstData.RandomNameArr[1][0] = _local2.women.firstname[0].split(",");
                UIConstData.RandomNameArr[1][1] = _local2.women.lastname[0].split(",");
            };
            if (completeFun){
                completeFun.call();
            };
        }

    }
}//package 
