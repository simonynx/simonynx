//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Task.Mediator.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Map.SenceMap.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.Modules.Depot.Mediator.*;
    import GameUI.Modules.SetView.Mediator.*;
    import GameUI.Modules.Stall.Mediator.*;
    import GameUI.Modules.Trade.Mediator.*;
    import GameUI.Modules.Unity.Mediator.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.GMMail.Mediator.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.QuickBuy.Mediator.*;
    import GameUI.Modules.Alert.*;
    import GameUI.Modules.Maket.Mediator.*;
    import OopsFramework.Debug.*;
    import GameUI.Modules.PetRace.Data.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Equipment.mediator.*;
    import GameUI.Modules.Chat.Mediator.*;
    import GameUI.Modules.Login.StartMediator.*;
    import Utils.*;
    import GameUI.Modules.TreasureChests.Data.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.MainScene.Mediator.*;
    import GameUI.Modules.AutoPlay.Data.*;
    import GameUI.Modules.Friend.view.mediator.*;
    import GameUI.Modules.GameTarget.Mediator.*;
    import GameUI.Modules.RoleProperty.Mediator.*;
    import GameUI.Modules.Constellation.Mediator.*;
    import GameUI.Modules.Pet.Mediator.*;
    import GameUI.Modules.Buff.Mediator.*;
    import GameUI.Modules.Relive.Mediator.*;
    import GameUI.Modules.Help.Mediator.*;
    import GameUI.Modules.StoryDisplay.view.mediator.*;
    import GameUI.Modules.Roll.Mediator.*;
    import GameUI.Modules.ToolTip.Mediator.*;
    import GameUI.Modules.WineParty.Mediator.*;
    import GameUI.Modules.Arena.Mediator.*;
    import GameUI.Modules.AutoPathFind.*;
    import GameUI.Modules.Team.Mediator.*;
    import GameUI.Modules.NewInfoTip.Mediator.*;
    import GameUI.Mediator.*;
    import GameUI.Modules.UpGradeBible.view.mediator.*;
    import GameUI.Modules.Mail.Mediator.*;
    import GameUI.Modules.GuildFight.Mediator.*;
    import GameUI.Modules.Verification.Mediator.*;
    import GameUI.Modules.ChangeLine.View.*;
    import GameUI.Modules.Achieve.view.mediator.*;
    import GameUI.Modules.GoldLeaf.Mediator.*;
    import GameUI.Modules.CSBattle.Mediator.*;
    import GameUI.Modules.Transcript.Mediator.*;
    import GameUI.Modules.AutoPlay.mediator.*;
    import GameUI.Modules.NPCChat.Mediator.*;
    import GameUI.Modules.Entrust.Mediator.*;
    import GameUI.Modules.Map.SmallMap.Mediator.*;
    import GameUI.Modules.Convoy.Mediator.*;
    import GameUI.Modules.MainScene.Command.*;
    import GameUI.Modules.PetRace.Mediator.*;
    import GameUI.Modules.Pk.Mediator.*;
    import GameUI.Modules.ScreenMessage.Mediator.*;
    import GameUI.Modules.Rank.Mediator.*;
    import GameUI.Modules.OpenItemBox.Mediator.*;
    import GameUI.Modules.OtherCountryFt.*;
    import GameUI.Modules.Question.view.mediator.*;
    import GameUI.Modules.Hint.Mediator.*;
    import GameUI.Modules.FilterBag.Mediator.*;
    import GameUI.Modules.HeroSkill.Mediator.*;
    import GameUI.Modules.TreasureChests.Mediator.*;
    import GameUI.Modules.Map.BigMap.*;

    public class StartupCommand extends SimpleCommand {

        public function StartupCommand(){
            this.initializeNotifier(UIFacade.FACADEKEY);
        }
        private function analyseAutoList(_arg1:ByteArray):void{
            var _local4:uint;
            var _local5:AutoFbInfo;
            _arg1.endian = "littleEndian";
            var _local2:int = _arg1.readUnsignedInt();
            _arg1.position = (_local2 + 4);
            var _local3:uint = _arg1.readUnsignedInt();
            while (_local4 < _local3) {
                _local5 = new AutoFbInfo();
                _local5.ReadFromPacket(_arg1);
                _local4++;
            };
        }
        private function analyseTowerRewardList(_arg1:XML):void{
            var _local4:Array;
            var _local5:TowerLayerInfo;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local5 = new TowerLayerInfo();
                _local5.name = _arg1.record[_local3].@name;
                _local5.pass1 = _arg1.record[_local3].@pass1;
                _local5.pass1Count = _arg1.record[_local3].@p1_number;
                _local5.pass2 = _arg1.record[_local3].@pass2;
                _local5.pass2Count = _arg1.record[_local3].@p2_number;
                _local5.dailyId = _arg1.record[_local3].@daily;
                _local5.dailyCount = _arg1.record[_local3].@d_number;
                _local4 = [];
                _local4.push(uint(_arg1.record[_local3].@item1));
                _local4.push(uint(_arg1.record[_local3].@item2));
                _local4.push(uint(_arg1.record[_local3].@item3));
                _local4.push(uint(_arg1.record[_local3].@item4));
                _local5.itemArr = _local4;
                GameCommonData.TowerRewardList[_local3] = _local5;
                _local3++;
            };
        }
        private function analyseTowerInfo(_arg1:XML):void{
            var _local4:TowerInfo;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = new TowerInfo();
                _local4.id = int(_arg1.record[_local3].@Id);
                _local4.mapId = String(_arg1.record[_local3].@new_scene_id);
                _local4.playerX = int(_arg1.record[_local3].@playerPosX);
                _local4.playerY = int(_arg1.record[_local3].@playerPosY);
                _local4.npcX = int(_arg1.record[_local3].@npcPosX);
                _local4.npcY = int(_arg1.record[_local3].@npcPosY);
                _local4.holeX = int(_arg1.record[_local3].@holePosX);
                _local4.holeY = int(_arg1.record[_local3].@holePosY);
                _local4.money = int(_arg1.record[_local3].@cost_gold);
                _local4.setMapArr();
                GameCommonData.TowerList[_local4.id] = _local4;
                _local3++;
            };
        }
        protected function analyseTreasureList(_arg1:XML):void{
            var _local2:TreasureInfo;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:Array;
            var _local7:Array;
            var _local8:Array;
            var _local9:Array;
            var _local10:int;
            _local3 = _arg1.item.length();
            while (_local4 < _local3) {
                _local10 = _arg1.item[_local4].@Num;
                if (_local10 == 1){
                    _local2 = new TreasureInfo();
                    _local2.Id = _arg1.item[_local4].@ID;
                    _local2.Count = _arg1.item[_local4].@Count;
                    _local2.Time = _arg1.item[_local4].@Time;
                    _local6 = [];
                    _local6.push(_local2);
                    TreasureEvent.FreshTreasure[_local4] = _local6;
                } else {
                    _local7 = _arg1.item[_local4].@ID.split(",");
                    _local8 = _arg1.item[_local4].@Count.split(",");
                    _local9 = _arg1.item[_local4].@Time.split(",");
                    _local6 = [];
                    _local5 = 0;
                    while (_local5 < _local10) {
                        _local2 = new TreasureInfo();
                        _local2.Id = _local7[_local5];
                        _local2.Count = _local8[_local5];
                        _local2.Time = _local9[_local5];
                        _local6.push(_local2);
                        _local5++;
                    };
                    TreasureEvent.FreshTreasure[_local4] = _local6;
                };
                _local4++;
            };
            _local3 = _arg1.itemd.length();
            _local4 = 0;
            while (_local4 < _local3) {
                _local10 = _arg1.itemd[_local4].@Num;
                if (_local10 == 1){
                    _local2 = new TreasureInfo();
                    _local2.Id = _arg1.itemd[_local4].@ID;
                    _local2.Count = _arg1.itemd[_local4].@Count;
                    _local2.Time = _arg1.itemd[_local4].@Time;
                    _local6 = [];
                    _local6.push(_local2);
                    TreasureEvent.DayTreasure[_local4] = _local6;
                } else {
                    _local7 = _arg1.itemd[_local4].@ID.split(",");
                    _local8 = _arg1.itemd[_local4].@Count.split(",");
                    _local9 = _arg1.itemd[_local4].@Time.split(",");
                    _local6 = [];
                    _local5 = 0;
                    while (_local5 < _local10) {
                        _local2 = new TreasureInfo();
                        _local2.Id = _local7[_local5];
                        _local2.Count = _local8[_local5];
                        _local2.Time = _local9[_local5];
                        _local6.push(_local2);
                        _local5++;
                    };
                    TreasureEvent.DayTreasure[_local4] = _local6;
                };
                _local4++;
            };
        }
        private function analyseEquipRefineList(_arg1:XML):void{
            var _local4:String;
            var _local5:String;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = ((String(_arg1.record[_local3].@itemlevel) + "_") + String(_arg1.record[_local3].@carrer));
                _local5 = ((((((String(_arg1.record[_local3].@weapon) + "_") + String(_arg1.record[_local3].@helmet)) + "_") + String(_arg1.record[_local3].@clothes)) + "_") + String(_arg1.record[_local3].@shoes));
                EquipDataConst.equipRefineItems[_local4] = _local5;
                _local3++;
            };
        }
        private function register():void{
            facade.registerProxy(new DataProxy());
            facade.registerMediator(new UILayerMediator());
            facade.registerMediator(new BigMapMediator());
            facade.registerMediator(new TaskItemUseMediator());
            facade.registerMediator(new LibsComponentMediator());
            facade.registerMediator(new SmallMapMediator());
            facade.registerMediator(new SenceMapMediator());
            facade.registerMediator(new QuickBuyMediator());
            facade.registerMediator(new BagMediator());
            facade.registerMediator(new FilterBagMediator());
            facade.registerMediator(new TeamMediator());
            facade.registerMediator(new TradeMediator());
            facade.registerMediator(new StallMediator());
            facade.registerMediator(new ChatMediator());
            facade.registerMediator(new MainSceneMediator());
            facade.registerMediator(new RoleMediator());
            facade.registerMediator(new FriendManagerMediator());
            facade.registerMediator(new NewSkillMediator());
            facade.registerMediator(new ScreenMessageMediator());
            facade.registerMediator(new ITranscriptMediator());
            facade.registerMediator(new PetViewMediator());
            facade.registerMediator(new IPetRaceMediator());
            facade.registerMediator(new IOpenItemBoxMediator());
            facade.registerMediator(new IConvoyMediator());
            facade.registerMediator(new TaskMediator());
            facade.registerMediator(new TaskDailyBookMediator());
            facade.registerMediator(new TreasureMediator());
            facade.registerMediator(new RollMediator());
            facade.registerMediator(new IUnityMediator());
            facade.registerMediator(new HintMediator());
            facade.registerMediator(new IArenaMediator());
            facade.registerMediator(new ItemToolTipMediator());
            facade.registerMediator(new NPCChatMediator());
            facade.registerCommand(EventList.ALLROLEINFO_UPDATE, AllRoleInfoUpdateCommand);
            facade.registerMediator(new MarketMediator());
            facade.registerMediator(new ReliveMediator());
            facade.registerMediator(new ItemPanelMediator());
            facade.registerMediator(new TaskFollowMediator());
            facade.registerMediator(new IWinePartyMeditor());
            facade.registerMediator(new EquipMenuMediator());
            facade.registerMediator(new IEquipForge());
            facade.registerMediator(new ITreasureMeditor());
            facade.registerMediator(new PetBatchRebuildMediator());
            facade.registerMediator(new IEntrustMediator());
            facade.registerMediator(new AutoPathMediator());
            facade.registerMediator(new BuffMediator());
            facade.registerMediator(new PkMediator());
            facade.registerCommand(EventList.RECEIVE_COOLDOWN_MSG, ItemCdCommand);
            facade.registerCommand(EventList.RECEIVE_CD_PUBLIC_MSG, ItemCdCommand);
            facade.registerCommand(EventList.RECEIVE_CD_MEDICINAL, ItemCdCommand);
            facade.registerCommand(EventList.RECEIVE_CD_GUILDSKILL, ItemCdCommand);
            facade.registerMediator(new ChangeLineMediator());
            facade.registerMediator(new AutoPlayMediator());
            facade.registerMediator(new NewInfoTipIIMediator());
            facade.registerMediator(new FriendChatMediator());
            facade.registerMediator(new SetViewMediator());
            facade.registerMediator(new PlayerEquipMediator());
            facade.registerMediator(new GuildDonateMediator());
            facade.registerMediator(new IMailMediator());
            facade.registerMediator(new GMMailMediator());
            facade.registerMediator(new HelpMediator());
            facade.registerMediator(new IGoldLeafMediator());
            facade.registerMediator(new VerificationMediator());
            facade.registerMediator(new NewGuideMediator());
            facade.registerMediator(new HelpTipsMediator());
            facade.registerMediator(new GetRewardMediator());
            facade.registerMediator(new IRankMediator());
            facade.registerMediator(new IQuestionMediator());
            facade.registerMediator(new TargetMediator());
            facade.registerMediator(new AlertMediator());
            if (facade.retrieveMediator(StarMediator.NAME) == null){
                facade.registerMediator(new StarMediator(null));
            };
            facade.registerMediator(new GuildFightMediator());
            facade.registerMediator(new DepotMediator());
            facade.registerMediator(new IAchieveMediator());
            facade.registerMediator(new ICSBattleMediator());
            facade.registerMediator(new OffLineTipsMediator());
            if (GameConfigData.OtherCountryFt == 1){
                facade.registerMediator(new ITWHeroMediator());
            };
            facade.registerMediator(new IUpGradeBibleMediator());
            facade.registerMediator(new IStoryDisplayMediator());
            if (GameConfigData.LanguageModel != null){
                facade.registerMediator(GameConfigData.LanguageModel["GetInstance"]());
            };
        }
        private function analyseOpenBoxList(_arg1:XML):void{
            var _local4:String;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = String(_arg1.record[_local3].@items);
                GameCommonData.OpenBoxItemIds[_local3] = _local4.split(" ");
                _local3++;
            };
        }
        private function analyseExpList(_arg1:XML):void{
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                UIConstData.ExpDic[(_local3 + 1)] = uint(_arg1.record[_local3].@exp);
                _local3++;
            };
        }
        private function analysePetRaceActionList(_arg1:XML):void{
            var _local4:PetRaceActionInfo;
            var _local9:String;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            var _local5:uint;
            var _local6:int;
            var _local7:int;
            var _local8 = -1;
            while (_local3 < _local2) {
                _local9 = "";
                _local4 = new PetRaceActionInfo();
                _local4.act_type = _arg1.record[_local3].@act_type;
                _local4.act_sub_type = _arg1.record[_local3].@act_sub_type;
                if (((!((_local4.act_type == _local6))) || (!((_local4.act_sub_type == _local7))))){
                    _local8 = -1;
                };
                _local8++;
                _local6 = _local4.act_type;
                _local7 = _local4.act_sub_type;
                _local9 = (((String(_local4.act_type) + String(_local4.act_sub_type)) + ((_local8)<=9) ? "0" : "") + String(_local8));
                _local4.act_discription = _arg1.record[_local3].@act_discription;
                _local4.value_count = _arg1.record[_local3].@value_count;
                GameCommonData.PetRaceActionList[_local9] = _local4;
                _local3++;
            };
        }
        private function analysePetExpList(_arg1:XML):void{
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                UIConstData.PetExpDic[(_local3 + 1)] = uint(_arg1.record[_local3].@exp);
                _local3++;
            };
        }
        private function analyseTranscriptInfo(_arg1:XML):void{
            var _local4:TranscriptInfo;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = new TranscriptInfo();
                _local4.id = _arg1.record[_local3].@layerid;
                _local4.name = _arg1.record[_local3].@area_name;
                _local4.info = _arg1.record[_local3].@info;
                _local4.hint = _arg1.record[_local3].@hint;
                _local4.picId = _arg1.record[_local3].@picid;
                GameCommonData.TranscriptList[_local4.id] = _local4;
                _local3++;
            };
        }
        private function analyseGuildSkill(_arg1:XML):void{
            GuildSkillManager.getInstance().analyseGuildSkill(_arg1);
        }
        private function analysePetRaceRewardList(_arg1:XML):void{
            var _local4:Array;
            var _local5:Array;
            var _local6:PetRaceRewardInfo;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local6 = new PetRaceRewardInfo();
                _local6.name = _arg1.record[_local3].@name;
                _local6.type = _arg1.record[_local3].@type;
                _local6.ranking = _arg1.record[_local3].@ranking;
                _local4 = [];
                _local5 = [];
                _local4.push(uint(_arg1.record[_local3].@item1));
                _local4.push(uint(_arg1.record[_local3].@item2));
                _local4.push(uint(_arg1.record[_local3].@item3));
                _local4.push(uint(_arg1.record[_local3].@item4));
                _local4.push(uint(_arg1.record[_local3].@item5));
                _local4.push(uint(_arg1.record[_local3].@item6));
                _local4.push(uint(_arg1.record[_local3].@item7));
                _local4.push(uint(_arg1.record[_local3].@item8));
                _local5.push(uint(_arg1.record[_local3].@num1));
                _local5.push(uint(_arg1.record[_local3].@num2));
                _local5.push(uint(_arg1.record[_local3].@num3));
                _local5.push(uint(_arg1.record[_local3].@num4));
                _local5.push(uint(_arg1.record[_local3].@num5));
                _local5.push(uint(_arg1.record[_local3].@num6));
                _local5.push(uint(_arg1.record[_local3].@num7));
                _local5.push(uint(_arg1.record[_local3].@num8));
                _local6.itemArr = _local4;
                _local6.numArr = _local5;
                GameCommonData.PetRaceRewardList[_local3] = _local6;
                _local3++;
            };
        }
        private function analyseGameSkill(_arg1:ByteArray):void{
            var _local4:uint;
            var _local5:NewSkillInfo;
            _arg1.endian = "littleEndian";
            var _local2:int = _arg1.readUnsignedInt();
            _arg1.position = (_local2 + 4);
            var _local3:uint = _arg1.readUnsignedInt();
            while (_local4 < _local3) {
                _local5 = new NewSkillInfo();
                _local5.ReadFromPacket(_arg1);
                _local4++;
            };
            SkillManager.setMySkillList();
        }
        override public function execute(_arg1:INotification):void{
            Logger.Info(this, "execute", "MVC已经启动");
            Logger.Info(this, "execute", "解析XML数据");
            var _local2:uint = getTimer();
            analyseExpList(GameCommonData.GameInstance.Content.Load(GameConfigData.ExpList).GetXML());
            analysePetExpList(GameCommonData.GameInstance.Content.Load(GameConfigData.PetExpList).GetXML());
            analyseGameSkill(GameCommonData.GameInstance.Content.Load(GameConfigData.GameSkillList).GetByteArray());
            analyseAutoList(GameCommonData.GameInstance.Content.Load(GameConfigData.AutoList).GetByteArray());
            analyseGameSkillBuff(GameCommonData.GameInstance.Content.Load(GameConfigData.GameSkillBuffList).GetXML());
            //analyseTreasureList(GameCommonData.GameInstance.Content.Load(GameConfigData.TreasureList).GetXML());
            analyseTranscriptInfo(GameCommonData.GameInstance.Content.Load(GameConfigData.TranscriptInfo).GetXML());
            analyseTowerInfo(GameCommonData.GameInstance.Content.Load(GameConfigData.TowerInfoList).GetXML());
            analyseTowerRewardList(GameCommonData.GameInstance.Content.Load(GameConfigData.TowerRewardList).GetXML());
            analyseGuildSkill(GameCommonData.GameInstance.Content.Load(GameConfigData.GuildSkillsList).GetXML());
            analysePetRaceRewardList(GameCommonData.GameInstance.Content.Load(GameConfigData.PetRaceRewardList).GetXML());
            analysePetRaceActionList(GameCommonData.GameInstance.Content.Load(GameConfigData.PetRaceActionList).GetXML());
            analyseOpenBoxList(GameCommonData.GameInstance.Content.Load(GameConfigData.OpenBoxConfig).GetXML());
            analyseEquipRefineList(GameCommonData.GameInstance.Content.Load(GameConfigData.EquipRefine).GetXML());
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.ExpList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.PetExpList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.GameSkillList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.GameSkillBuffList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.TreasureList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.TranscriptInfo);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.TowerInfoList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.TowerRewardList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.PetRaceRewardList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.PetRaceActionList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.GuildSkillsList);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.OpenBoxConfig);
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.EquipRefine);
            register();
            facade.sendNotification(EventList.REGISTERCOMPLETE);
            Logger.Info(this, "execute", "MVC注册完成");
            trace((getTimer() - _local2));
            HtmlUtil.color("引用一下", "#00ff00");
        }
        private function analyseGameSkillBuff(_arg1:XML):void{
            var _local3:int;
            var _local4:GameSkillBuff;
            var _local5:int;
            var _local6:String;
            var _local7:int;
            var _local8:String;
            var _local10:int;
            var _local12:int;
            var _local13:int;
            var _local2:int = _arg1.record.length();
            var _local9:Array = [];
            var _local11:Array = [];
            while (_local3 < _local2) {
                _local5 = _arg1.record[_local3].@id;
                _local7 = _arg1.record[_local3].@maxLevel;
                _local8 = _arg1.record[_local3].@name;
                _local6 = _arg1.record[_local3].@discription;
                _local9 = _arg1.record[_local3].@content.split("&");
                _local10 = _local6.match(/\*/g).length;
                _local12 = 0;
                while (_local12 < _local7) {
                    _local4 = new GameSkillBuff();
                    _local4.TypeID = _local5;
                    _local4.Level = (_local12 + 1);
                    _local4.BuffName = _local8;
                    _local4.BuffID = ((_local4.TypeID * 100) + _local4.Level);
                    _local4.BuffEffect = _local6;
                    _local13 = 0;
                    while (_local13 < _local10) {
                        _local11 = _local9[_local13].split(",");
                        _local4.BuffEffect = _local4.BuffEffect.replace("*", _local11[_local12]);
                        _local13++;
                    };
                    GameCommonData.BuffList[_local4.BuffID] = _local4;
                    _local12++;
                };
                _local3++;
            };
        }

    }
}//package GameUI.Command 
