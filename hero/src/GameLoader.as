//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
	
	[SWF(width="1000", height="600", backgroundColor="#FFFFFF")]
    public class GameLoader extends Sprite {

        private var speed:Number;
        private var bytesRemaining:int = 10000000;
        private var bytesLoaded:int = 0;
        private var loader:DisLoader;
        private var timeToDownload:Number;
        private var bytesTotal:int = 0;
        private var loadBackGround:MovieClip = null;
        private var percentLoaded:Number;
        private var info:Object = null;
        private var totalTime:int;
        private var scale_tiao:ScaleTiao = null;
        private var GameUrl:String;
        private var weight:int = 1;
        private var fullscreen:Boolean = false;

        public function GameLoader(){
            super();
			//scale_tiao = new MovieClip();
            Security.allowDomain("*");
            this.stage.showDefaultContextMenu = false;
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            //this.initUI();
            this.receiveParaFormWeb();
            this.LoadConfig();
        }
        private function LoadConfig():void{
            var urlldr:URLLoader = new URLLoader();
            urlldr.addEventListener(Event.COMPLETE, this.onXMLComplete);
            if (uint(this.info.ServerID) > 0){
                urlldr.load(new URLRequest(((("GameConfig_" + String(this.info.ServerID)) + ".xml?v=") + Math.random().toString())));
            } else {
                urlldr.load(new URLRequest(("GameConfig.xml?v=" + Math.random().toString())));
            };
            urlldr.dataFormat = URLLoaderDataFormat.BINARY;
        }
        private function onXMLComplete(event:Event):void{
            var sversion:String;
            var firstversion:int;
            if ((event.currentTarget.data is ByteArray)){
                if ((event.currentTarget.data as ByteArray)[0] == 120){
                    (event.currentTarget.data as ByteArray).uncompress();
                };
            };
            this.info.config = XML(event.currentTarget.data);
            var ConfigXml:XML = this.info.config;
            this.info.loginurl = String(ConfigXml.Login.@path);
            this.info.gamepay = String(ConfigXml.GamePay.@path);
            this.info.bbs = String(ConfigXml.BBS.@path);
            this.info.OfficialWebsite = String(ConfigXml.OfficialWebsite.@path);
            this.info.gmnotice = String(ConfigXml.GMNotice.@Info);
            this.info.gmurl = String(ConfigXml.GMNotice.@url);
            this.info.gameswfversion = String(ConfigXml.SourceVersion.@Game);
            this.info.uiswfversion = String(ConfigXml.SourceVersion.@UI);
            this.info.VerificationPath = String(ConfigXml.Verification.@path);
            this.info.usegzp = int(ConfigXml.SourceVersion.@UseGzp);
            this.info.usecdn = int(ConfigXml.SourceVersion.@usecdn);
            this.info.TW = int(ConfigXml.TW.@Info);
            var cdnpath:String = String(ConfigXml.SourceVersion.@cdnpath);
            this.info.LocalURL = this.info.SourceURL;
            if (this.info.usecdn == 1){
                sversion = (this.info.gameswfversion as String);
                firstversion = sversion.indexOf(".");
                if (((!((cdnpath == null))) && ((cdnpath.length > 5)))){
                    this.info.SourceURL = ((cdnpath + sversion.substr(0, (firstversion + 2))) + "/");
                } else {
                    this.info.SourceURL = (("http://cdn1.xunwan.com/yxwz/yxwz" + sversion.substr(0, (firstversion + 2))) + "/");
                };
                this.GameUrl = (this.info.SourceURL + "MMOProjectClient.swf?v=5001");
            };
            if (ConfigXml.VIPPhone != null){
                this.info.gmphone = String(ConfigXml.VIPPhone.@Info);
                this.info.vippath = String(ConfigXml.VIPPhone.@path);
                this.info.vipmail = String(ConfigXml.VIPPhone.@mail);
            };
            this.info.activecodepath = String(ConfigXml.ActiviteCode.@path);
            if (stage.loaderInfo.loaderURL.indexOf("http", 0) == -1){
                this.info.AccSocketIP = ConfigXml.Server.@ip;
                this.info.AccSocketPort = ConfigXml.Server.@port;
                this.info.ServerID = 0;
            };
            this.GameUrl = (this.GameUrl + ("&fv=" + this.info.gameswfversion));
            this.loadBgImg();
            this.startLoad();
        }
        private function startLoad():void{
            this.loader = new DisLoader(this.GameUrl);
            this.loader.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
            this.loader.loadSync(this.LoadComplete);
        }
        private function LoadComplete(loader:DisLoader){
            this.onComplete(null);
        }
        private function onKeyDown(event:KeyboardEvent):void{
            if (event.keyCode == 90){
                ExternalInterface.call("showGoogle", event.keyCode);
            };
            if (event.keyCode == 119){
                if (!(this.fullscreen)){
                    ExternalInterface.call("intofullscreen()");
                    this.fullscreen = true;
                } else {
                    ExternalInterface.call("exitfullscreen()");
                    this.fullscreen = false;
                };
            };
        }
        private function reLoadPage(event:TextEvent):void{
            if (event.text.split("_")[0] == "reload"){
                ExternalInterface.call("function refresh(){window.location.reload();}");
            };
        }
        private function receiveParaFormWeb():void{
//            this.info = new Object();
//            this.info.userName = this.loaderInfo.parameters["user"];
//            this.info.password = this.loaderInfo.parameters["key"];
//            this.info.AccSocketIP = this.loaderInfo.parameters["AccSocketIP"];
//            this.info.AccSocketPort = this.loaderInfo.parameters["AccSocketPort"];
//            this.info.ServerID = this.loaderInfo.parameters["serverid"];
//            this.info.NickName = this.loaderInfo.parameters["nickname"];
//            this.info.SourceURL = (("http://" + this.info.AccSocketIP) + "/");
//            this.info.cm = this.loaderInfo.parameters["cm"];
//            this.info.explorer = this.loaderInfo.parameters["explorer"];
//            this.info.os = this.loaderInfo.parameters["platform"];
			
			this.info = new Object();
			this.info.userName = "7aec18a4224b2419082a4d7660b72062";
			this.info.password = "0_f6cc583239d31f3a92b2c35b62212530_5001_1332485227_2";
			this.info.AccSocketIP = "s37wanwan5.yxwz.xunwan.com";
			this.info.AccSocketPort = 8094
			this.info.ServerID = 0;
			this.info.NickName = "";
			this.info.SourceURL = (("http://" + this.info.AccSocketIP) + "/");
			this.info.cm = 0;
			this.info.explorer = "Firefox";
			this.info.os = "Windows XP";
			
            var domain:String = this.loaderInfo.loaderURL;
            var i:int = domain.lastIndexOf("/");
            if (i > 0){
                domain = domain.substr(0, (i + 1));
            };
            this.info.SourceURL = domain;
            //this.GameUrl = (this.info.SourceURL + "Main.swf");
            //this.info.BackGround = this.loadBackGround;
            //this.info.tiao = this.scale_tiao;
			this.GameUrl = "Main.swf";
			this.info.BackGround = new MovieClip();
			this.info.tiao = new MovieClip();
            var _loc_1:* = this.loaderInfo.parameters["v"];
            if (_loc_1 != null){
                this.GameUrl = (this.GameUrl + ("?v=" + _loc_1));
            } else {
                this.GameUrl = (this.GameUrl + "?v=5001");
            };
        }
        private function onComplete(event:Event):void{
            var _loc_2:Class;
            var _loc_3:* = undefined;
            if (this.loader.contentLoaderInfo.applicationDomain.hasDefinition("StartInterface")){
                _loc_2 = (this.loader.contentLoaderInfo.applicationDomain.getDefinition("StartInterface") as Class);
                _loc_3 = new (_loc_2)();
                _loc_3.Run(this, this.info);
                this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onProgress);
                this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
                this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.reLoad);
                if (this.loader.contentLoaderInfo.loaderURL.charAt(0) == "h"){
                    ExternalInterface.call("intofullscreen()");
                    this.fullscreen = true;
                };
                this.loader = null;
            };
        }
        private function CalculateSpeed():void{
            this.totalTime = getTimer();
            this.timeToDownload = (this.totalTime / 1000);
            if (this.timeToDownload == 0){
                this.timeToDownload = 0.1;
            };
            this.speed = this.TruncateNumber(((this.bytesLoaded / 0x0400) / this.timeToDownload));
        }
        private function initUI():void{
            this.graphics.beginFill(1);
            this.graphics.drawRect(0, -50, 2000, 2000);
            this.graphics.endFill();
            this.scale_tiao = new ScaleTiao();
            //this.scale_tiao.progressMc.mask = this.scale_tiao.progressMask;
			this.scale_tiao.progressMc.mask = new MovieClip();
            this.scale_tiao.content_txt.text = "正在加载游戏主程序.....";
            this.scale_tiao.numPercent_txt.text = "0%";
            this.scale_tiao.num_txt.text = "0kb/s";
            this.scale_tiao.x = ((stage.stageWidth - this.scale_tiao.width) / 2);
            this.scale_tiao.y = ((stage.stageHeight / 2) + 180);
            this.addChild(this.scale_tiao);
            this.loadBackGround = new BackGround();
            this.loadBackGround.name = "loadBackGround";
            this.loadBackGround.reload_txt.htmlText = (((("<a href=\"event:reload_" + "刷新") + "\">") + "若加载不成功，请点此刷新") + "：</a>");
            this.loadBackGround.reload_txt.addEventListener(TextEvent.LINK, this.reLoadPage);
            this.loadBackGround.x = ((stage.stageWidth - this.loadBackGround.width) / 2);
            this.loadBackGround.y = ((stage.stageHeight / 2) + 250);
            this.addChild(this.loadBackGround);
        }
        private function loadBgImg():void{
            var bgImgUrl:String = (this.info.SourceURL + "Resources/Img/LoadingBGImg.jpg");
            var bgLoader:Loader = new Loader();
            bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__loadBgimgCompleteHandler);
            bgLoader.load(new URLRequest(bgImgUrl), new LoaderContext(true));
        }
        private function __loadBgimgCompleteHandler(e:Event):void{
            e.currentTarget.removeEventListener(Event.COMPLETE, this.__loadBgimgCompleteHandler);
            var bgImg:Bitmap = e.currentTarget.content;
            if (bgImg != null){
//                bgImg.x = ((this.scale_tiao.width - bgImg.width) / 2);
//                bgImg.y = -480;
				bgImg.x=0;
				bgImg.y=0;
				//this.addChildAt(bgImg,0);
                //this.scale_tiao.addChildAt(bgImg, 0);
            };
        }
        private function onProgress(event:ProgressEvent):void{
            //this.scale_tiao.progressMask.width = ((event.bytesLoaded / event.bytesTotal) * this.scale_tiao.progressMc.width);
            //this.scale_tiao.lightAsset.x = (this.scale_tiao.progressMask.x + this.scale_tiao.progressMask.width);
            //this.scale_tiao.numPercent_txt.text = (Math.round(((event.bytesLoaded / event.bytesTotal) * 100)) + "%");
            this.bytesLoaded = event.bytesLoaded;
            this.bytesTotal = event.bytesTotal;
            this.bytesRemaining = (this.bytesTotal - this.bytesLoaded);
            this.percentLoaded = (this.bytesLoaded / this.bytesTotal);
            this.CalculateSpeed();
            if (this.speed < 0x0400){
                //this.scale_tiao.num_txt.text = (Math.round(this.speed) + "kb/s");
            } else {
               // this.scale_tiao.num_txt.text = (Math.round((this.speed / 0x0400)) + "mb/s");
            };
            //this.scale_tiao.time_txt.htmlText = "<font color='#FFFFFF'>适龄提示:</font><font color='#FF0000'>18+</font>";
        }
        private function TruncateNumber(param1:Number, param2:int=2):Number{
            var _loc_3:* = Math.pow(10, param2);
            return ((Math.round((param1 * _loc_3)) / _loc_3));
        }
        private function reLoad(event:IOErrorEvent):void{
            this.loader.load(new URLRequest(this.GameUrl));
        }

    }
}//package 
