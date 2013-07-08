//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import Manager.*;
    import Net.*;
    import GameUI.Modules.Login.StartMediator.*;
    import Utils.*;
    import OopsEngine.*;
    import OopsEngine.Scene.StrategyScene.*;
    import flash.system.*;

    public class MyGame extends Engine {

        public function MyGame(_arg1:Stage=null, _arg2:Object=null){
            super(_arg1);
            HOHOParms.InitParmMap();
            if (_arg2){
                GameCommonData.BackGround = (_arg2.BackGround as MovieClip);
                GameCommonData.Tiao = (_arg2.tiao as MovieClip);
                GameCommonData.isLoginFromLoader = true;
                this.Content.RootDirectory = _arg2.SourceURL;
                this.Content.LocalDirectory = _arg2.LocalURL;
                GameCommonData.LocalDirectory = this.Content.LocalDirectory;
                GameCommonData.Accmoute = _arg2.userName;
                GameCommonData.Password = _arg2.password;
                GameCommonData.DefaultNickName = _arg2.NickName;
                if ((((GameCommonData.DefaultNickName == undefined)) || ((GameCommonData.DefaultNickName == null)))){
                    GameCommonData.DefaultNickName = "";
                };
                GameConfigData.AccSocketIP = _arg2.AccSocketIP;
                GameConfigData.AccSocketPort = _arg2.AccSocketPort;
                GameCommonData.loginHint_mc = _arg2.hint_mc;
                GameConfigData.CurrentServer = String(_arg2.ServerID);
                if (GameConfigData.CurrentServer.length >= 5){
                    GameConfigData.RankConfig = (("Resources/GameData/Rank_" + GameConfigData.CurrentServer) + ".xml");
                };
                GameConfigData.LoginUrl = _arg2.loginurl;
                GameConfigData.GamePay = _arg2.gamepay;
                GameConfigData.GMNotice = String(_arg2.gmnotice);
                GameConfigData.OtherCountryFt = int(_arg2.TW);
                GameConfigData.GMUrl = String(_arg2.gmurl);
                if (_arg2.hasOwnProperty("gmphone")){
                    GameConfigData.GreenServicePhone = String(_arg2.gmphone);
                    GameConfigData.GreenService = String(_arg2.vippath);
                };
                GameConfigData.BBS = _arg2.bbs;
                GameConfigData.GameChengMi = _arg2.cm;
                GameConfigData.Env = (GameConfigData.Env + String(_arg2.explorer));
                GameConfigData.Env = (GameConfigData.Env + String(_arg2.os));
                GameConfigData.OfficialWebsite = String(_arg2.OfficialWebsite);
                GameConfigData.ActivityCodePath = String(_arg2.activecodepath);
                GameConfigData.VerificationPath = String(_arg2.VerificationPath);
                if (_arg2.usegzp != 1){
                    GameConfigData.GameDataFilePack = "";
                };
                if (_arg2.usegzp == 1){
                    GameConfigData.LanguagePack = "Resources/language.bml?v=";
                };
                GameConfigData.UILibrary = (GameConfigData.UILibrary + _arg2.uiswfversion);
                GameConfigData.LanguagePack = (GameConfigData.LanguagePack + _arg2.uiswfversion);
                GameConfigData.ModuleLoadVerion = ("?v=" + _arg2.gameswfversion);
                if (((!(_arg2.userName)) || (!(_arg2.password)))){
                    GameCommonData.isLoginFromLoader = false;
                };
                GameConfigData.GamePay = StringUtil.replace(GameConfigData.GamePay, GameCommonData.Accmoute);
            } else {
                GameConfigData.GameDataFilePack = "";
                GameConfigData.AccSocketIP = "192.168.7.50";
                GameConfigData.AccSocketPort = 8094;
                GameCommonData.LoginName = "robota2";
                GameCommonData.LoginPassword = "123456";
            };
            Security.allowDomain("*");
            Engine.UILibrary = GameConfigData.UILibrary;
            GameCommonData.GameInstance = this;
            this.GameScene.GameScenes.Add(GameCommonData.SCENE_GAME, GameScenePlay);
            this.Resize = ResizeManager.getInstance().Resize;
            addBack();
            if (GameCommonData.isLoginFromLoader){
                if (GameCommonData.Tiao){
                    //GameCommonData.Tiao.content_txt.text = "正在连接登录服务器......";
                };
                //GameCommonData.AccNets = new AccNet(GameConfigData.AccSocketIP, GameConfigData.AccSocketPort);
				GameCommonData.AccNets = new AccNet("s37wanwan2.yxwz.xunwan.com", 8094);
            } else {
                TestLogin.login();
            };
        }
        private function addBack():void{
            if (GameCommonData.BackGround){
                GameCommonData.GameInstance.GameScene.addChild(GameCommonData.BackGround);
            };
            if (GameCommonData.Tiao){
               // GameCommonData.GameInstance.GameScene.addChild(GameCommonData.Tiao);
            };
        }
        override protected function Update(_arg1:GameTime):void{
            super.Update(_arg1);
            if (UIFacade.UIFacadeInstance){
                UIFacade.UIFacadeInstance.gameHeartPoint(_arg1);
            };
        }

    }
}//package 
