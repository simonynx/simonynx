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
    import GameUI.Modules.Task.Model.*;
    import Net.PackHandler.*;
    import Utils.*;
    import OopsFramework.Content.Provider.*;
    import Net.RequestSend.*;
    import GameUI.Modules.CSBattle.Data.*;
    import GameUI.Modules.Activity.Command.*;
    import GameUI.*;

	/**
	 *游戏初始化数据提示源 
	 * @author wengliqiang
	 * 
	 */	
    public class GameInit extends BulkLoaderResourceProvider {

        private var loadItemArr:Array;

        public function GameInit(_arg1:MyGame){
            loadItemArr = [];
            super(1, _arg1);
            setLoadItemArr();
            if (UIConstData.Filter_Switch == false){
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.FilterDic));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.LanguagePack));
            };
            if (GameConfigData.GameDataFilePack != ""){
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.GameDataFilePack), true);
            } else {
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ItemProtoList), true);
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.QuestInfoList), true);
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.EquipSetList), true);
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.MapTree));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ExpList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.PetExpList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.GameSkillList), true);
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.AutoList), true);
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.GameSkillBuffList), true);
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TreasureList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ModelOffsetPlayer));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ModelOffsetNpcEnemy));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ActivityConfig));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.GradeBibleConfig));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.StoryDisplayConfig));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.OccupationIntroXML));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ActivityItems));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.HelpConfig));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.LevelHelpTips));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TargetConfig));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TitleDefList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.AchieveList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TranscriptInfo));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TowerInfoList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TowerRewardList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.Constellation));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.GuildSkillsList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.ActivityEveryDay));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.PetRaceRewardList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.PetRaceActionList));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.OpenBoxConfig));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.EquipRefine));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TaskPathRandom));
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.CsbRewardItemList));
            };
			//GEOFFYAN  配置加载文件中没有，这里补上
			this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.TreasureList));
			
            if (GameConfigData.Freshman){
                this.Download.Add((this.Games.Content.RootDirectory + "Scene/1004/Small.jpg?v=11"));
                this.Download.Add((this.Games.Content.RootDirectory + "Scene/1004/1004.mpt?v=11"));
            };
            if (GameConfigData.LanguageModelPath != ""){
                this.Download.Add(((this.Games.Content.RootDirectory + GameConfigData.LanguageModelPath) + GameConfigData.ModuleLoadVerion));
            };
            if (GameCommonData.Player.Role.Level < 45){
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.NOTICE_DATA));
            };
            if (GameCommonData.Player.Role.Level >= 45){
                this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.QuestInfoAfter60), true);
            };
            this.Download.Add((this.Games.Content.RootDirectory + GameConfigData.MapConfigsPath));
            this.LoadCompleteOne = SourceLoadComplete;
            this.Load();
            CharacterSend.sendCurrentStep("GameInit开始加载");
        }
        override protected function onBulkComplete(_arg1:BulkProgressEvent):void{
            GameCommonData.IsFirstLoadGame = false;
            super.onBulkComplete(_arg1);
        }
        private function showJindu(_arg1:BulkProgressEvent):void{
            var _local2:uint = _arg1.ItemsLoaded;
            var _local3:uint = _arg1.ItemsTotal;
            var _local4:String = loadItemArr[_local2];
            if (GameCommonData.Tiao){
                if (_local4){
                    //GameCommonData.Tiao.content_txt.text = _local4;
                };
               // GameCommonData.Tiao.numPercent_txt.text = (Math.round((_arg1.WeightPercent * 100)) + "%");
               // GameCommonData.Tiao.progressMask.width = ((_arg1.BytesLoaded / _arg1.BytesTotal) * GameCommonData.Tiao.progressMc.width);
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
                loadItemArr = ["正在加载道具信息（1/3）.....", "正在加载装备信息（2/3）.....", "正在加载套装数据（3/3）....."];
            } else {
                loadItemArr = ["正在加载道具信息（1/4）.....", "正在加载角色信息（2/4）.....", "正在加载地图碰撞（3/4）.....", "正在加载小地图 （4/4）....."];
            };
        }
        override protected function onBulkCompleteAll():void{
            var _local2:XML;
            var _local3:ByteArray;
            var _local6:XML;
            var _local7:XML;
            var _local8:RegExp;
            var _local9:RegExp;
            var _local10:RegExp;
            var _local11:XML;
            var _local12:XML;
            var _local13:ByteArray;
            var _local14:int;
            var _local15:Array;
            var _local16:String;
            var _local17:String;
            super.onBulkCompleteAll();
            if (UIConstData.Filter_Switch == false){
                UIConstData.Filter_chat = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.FilterDic)).GetDisplayObject()["filter_dic_chat"];
                LanguageMgr.setup(this.GetResource((this.Games.Content.RootDirectory + GameConfigData.LanguagePack)).GetText());
            };
            if (GameConfigData.LanguageModelPath != ""){
                GameConfigData.LanguageModel = this.GetResource(((this.Games.Content.RootDirectory + GameConfigData.LanguageModelPath) + GameConfigData.ModuleLoadVerion)).GetMovieClip();
            };
            separateChinese();
            AudioController.SoundLoginOff();
            if (GameConfigData.GameDataFilePack != ""){
                UnPackGZPFile();
            };
            var _local1:XML = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.MapConfigsPath)).GetXML();
            for each (_local2 in _local1.elements()) {
                _local14 = _local2.@id;
                GameCommonData.MapConfigs[_local14] = _local2;
            };
			//trace(GameCommonData.GameInstance.Content);
			//trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+GameCommonData.GameInstance.Content.Load(GameConfigData.ItemProtoList));
			//return;
            _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.ItemProtoList).GetByteArray();
            BagInfoAction.getInstance().getItemProtoFromFile(_local3);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.ItemProtoList);
            setTimeout(removeLoad, 1000);
            if (!GameCommonData.isLoginFromLoader){
                GameCommonData.GServerInfo = new Object();
            };
            if (GameCommonData.Player.Role.Level < 45){
                ChatData.NOTICE_ARR = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.NOTICE_DATA)).GetDisplayObject()["NOTICE_HELP_ARR"];
                ChatData.WELCOME_ARR = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.NOTICE_DATA)).GetDisplayObject()["WELCOME_ARR"];
                ChatData.NOTICE_HELP_INTERVAL = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.NOTICE_DATA)).GetDisplayObject()["NOTICE_HELP_INTERVAL"];
                ChatData.WELCOME_INTERVAL = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.NOTICE_DATA)).GetDisplayObject()["WELCOME_INTERVAL"];
            };
            XmlUtils.createXml();
            SharedManager.getInstance().setup();
            GameCommonData.UIFacadeIntance.StartUp();
            var _local4:KeyboardController = new KeyboardController();
            GameCommonData.Scene = new SceneController(GameCommonData.enterGameObj.nSceneName.toString(), GameCommonData.enterGameObj.nMapId.toString());
            var _local5:XML = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.ActivityItems)).GetXML();
            for each (_local6 in _local5.rewardPack) {
                if (ActivityConstants.itemIdArrlist[uint(_local6.@activity)] == null){
                    ActivityConstants.itemIdArrlist[uint(_local6.@activity)] = new Array();
                };
                if (ActivityConstants.chagerArraylist[uint(_local6.@activity)] == null){
                    ActivityConstants.chagerArraylist[uint(_local6.@activity)] = new Array();
                };
                ActivityConstants.chagerArray = ActivityConstants.chagerArraylist[uint(_local6.@activity)];
                ActivityConstants.itemIdArr = ActivityConstants.itemIdArrlist[uint(_local6.@activity)];
                _local15 = _local6.@items.toString().replace(/([ ]{1})/g, "").split(",");
                ActivityConstants.chagerArray[uint(_local6.@id)] = _local15;
                ActivityConstants.itemIdArr.push(int(_local6.@itemId));
            };
            _local7 = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.HelpConfig)).GetXML();
            _local8 = new RegExp(":_", "g");
            _local9 = new RegExp("_]", "g");
            _local10 = new RegExp("'", "g");
            for each (_local11 in _local7.elements()) {
                GameCommonData.HelpConfigItems[String(_local11.@Name)] = new Object();
                GameCommonData.HelpConfigItems[String(_local11.@Name)].Title = String(_local11.@Title);
                _local16 = String(_local11.@Tips).replace(_local10, "\"");
                _local17 = String(_local11.@Info).replace(_local10, "\"");
                _local16 = _local16.replace(_local8, "<");
                _local17 = _local17.replace(_local8, "<");
                GameCommonData.HelpConfigItems[String(_local11.@Name)].Tips = _local16.replace(_local9, ">");
                GameCommonData.HelpConfigItems[String(_local11.@Name)].Text = _local17.replace(_local9, ">");
            };
            _local12 = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.LevelHelpTips)).GetXML();
            for each (_local11 in _local12.elements()) {
                if (GameCommonData.LevelHelpTipsDic[String(_local11.@Type)] == null){
                    GameCommonData.LevelHelpTipsDic[String(_local11.@Type)] = new Dictionary();
                };
                GameCommonData.LevelHelpTipsDic[String(_local11.@Type)][String(_local11.@Value)] = _local11.toString();
            };
            GameCommonData.TargetXMLs = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.TargetConfig)).GetXML();
            GameCommonData.ActivityXMLs = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.ActivityConfig)).GetXML();
            GameCommonData.GradeBibleXMLs = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.GradeBibleConfig)).GetXML();
            GameCommonData.StoryDisplayXMLs = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.StoryDisplayConfig)).GetXML();
            GameCommonData.OccupationIntroXMLS = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.OccupationIntroXML)).GetXML();
            AchieveManager.getInstance().AnalyzeXml_Title(this.GetResource((this.Games.Content.RootDirectory + GameConfigData.TitleDefList)).GetXML());
            AchieveManager.getInstance().AnalyzeXml_Achieve(this.GetResource((this.Games.Content.RootDirectory + GameConfigData.AchieveList)).GetXML());
            GameCommonData.Star = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.Constellation)).GetXML();
            GameCommonData.ActivityEveryDayXML = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.ActivityEveryDay)).GetXML();
            _local13 = GameCommonData.GameInstance.Content.Load(GameConfigData.QuestInfoList).GetByteArray();
            TaskCommonData.AnalyzeTaskPathRandom(this.GetResource((this.Games.Content.RootDirectory + GameConfigData.TaskPathRandom)).GetXML());
            CSBattleData.AnalyzeXml_CsbRewardItem(this.GetResource((this.Games.Content.RootDirectory + GameConfigData.CsbRewardItemList)).GetXML());
            TaskAction.getInstance().getQuestListFromFile(_local13);
            if (GameCommonData.Player.Role.Level >= 45){
                _local13 = GameCommonData.GameInstance.Content.Load(GameConfigData.QuestInfoAfter60).GetByteArray();
                TaskAction.getInstance().getQuestListFromFile(_local13);
            };
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.QuestInfoList);
            GameCommonData.UIFacadeIntance.sendNotification(EventList.ENTERMAPCOMPLETE);
            CharacterSend.sendCurrentStep("资源已加载并解析完");
        }
        private function removeLoad():void{
            if (((GameCommonData.BackGround) && (GameCommonData.GameInstance.GameScene.contains(GameCommonData.BackGround)))){
                GameCommonData.GameInstance.GameScene.removeChild(GameCommonData.BackGround);
                GameCommonData.BackGround = null;
            };
            if (((GameCommonData.Tiao) && (GameCommonData.GameInstance.GameScene.contains(GameCommonData.Tiao)))){
                //GameCommonData.GameInstance.GameScene.removeChild(GameCommonData.Tiao);
                GameCommonData.Tiao = null;
            };
        }
        private function SourceLoadComplete(_arg1:ContentTypeReader):void{
            CharacterSend.sendCurrentStep(("GameInit资源加载到:" + _arg1.Name));
        }
        private function separateChinese():void{
            var _local1:uint;
            while (_local1 < 6) {
                GameCommonData.RolesListDic[_local1] = LanguageMgr.GetTranslation(("职业" + _local1.toString()));
                _local1++;
            };
        }
        override protected function onBulkProgress(_arg1:BulkProgressEvent):void{
            super.onBulkProgress(_arg1);
            if (GameCommonData.Tiao){
                showJindu(_arg1);
            };
        }
        private function UnPackGZPFile():void{
            var _local6:String;
            var _local7:uint;
            var _local8:ContentTypeReader;
            CharacterSend.sendCurrentStep("解压data.gzp文件");
            var _local1:ByteArray = this.GetResource((this.Games.Content.RootDirectory + GameConfigData.GameDataFilePack)).GetByteArray();
            _local1.endian = "littleEndian";
            var _local2:uint;
            var _local3:uint;
            var _local4:int = _local1.readUnsignedInt();
            var _local5:int;
            while (_local5 < _local4) {
                _local6 = UIUtils.ReadString(_local1);
                _local7 = _local1.readUnsignedInt();
                _local2 = _local1.position;
                _local8 = new ContentTypeReader();
                _local8.Name = ((this.Games.Content.RootDirectory + "Resources/GameData/") + _local6);
                _local8.Content = new ByteArray();
                _local1.position = _local7;
                _local3 = _local1.readUnsignedInt();
                _local1.readBytes(_local8.Content, 0, _local3);
                _local1.position = _local2;
                this.addResource(_local8);
                _local5++;
            }
									
            this.RemoveResource((this.Games.Content.RootDirectory + GameConfigData.GameDataFilePack));
        }

    }
}//package 
