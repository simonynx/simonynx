//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import Net.*;
    import OopsEngine.Utils.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import OopsEngine.AI.PathFinder.*;
    import Render3D.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Bag.Datas.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import OopsEngine.Scene.StrategyScene.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.ToolTip.Mediator.data.*;
    import GameUI.Modules.WineParty.Data.*;
    import GameUI.Modules.StoryDisplay.model.data.*;
    import GameUI.Modules.StoryDisplay.model.vo.*;
    import GameUI.Modules.Arena.Data.*;
    import OopsEngine.AI.MapPathFinder.*;
    import flash.ui.*;

    public class SceneController {

        private var _ScenePlayerCount:int = 0;
        public var IsSceneLoaded:Boolean = false;
        public var IsFirstLoad:Boolean = false;
        public var gameScenePlay:GameScenePlay;
        private var SceneVerse:MovieClip;
        private var PetmoveStepCount:int = 0;
        private var NextPoint:Point;
        public var playerdistance:int = 0;
        private var moveStepCount:int = 0;
        private var musicTimeOut:uint = 0;
        public var loadCircle:Sprite;
        private var BeforeTargetPoint:Point;
        public var IsCanController:Boolean = false;
        private var perPoint:Point;

        public function SceneController(_arg1:String, _arg2:String){
            perPoint = new Point(0, 0);
            super();
            GameCommonData.GameInstance.GameScene.GameSceneTransferOpen = onGameSceneTransferOpen;
            GameCommonData.GameInstance.GameScene.GameSceneLoadComplete = onGameSceneLoadComplete;
            GameCommonData.GameInstance.GameScene.StartScene(GameCommonData.SCENE_GAME);
            GameCommonData.GameInstance.GameScene.TransferScene(_arg1, _arg2);
            TestManager.getInstance();
        }
        public function SendOnLoadComplete():void{
            ClearElementData();
        }
        public function MoveNextScenePoint():void{
            var finder:* = null;
            var MapList:* = null;
            var TargetPoint:* = null;
            CloseNPCDialog();
            try {
                finder = new MapFinder(GameCommonData.MapTree);
                MapList = finder.Find(GameCommonData.GameInstance.GameScene.GetGameScene.name, GameCommonData.TargetScene);
                TargetPoint = new Point(GameCommonData.GameInstance.GameScene.GetGameScene.ConnectScene[MapList[0]].X, GameCommonData.GameInstance.GameScene.GetGameScene.ConnectScene[MapList[0]].Y);
                playerdistance = 0;
                PlayerMove(MapTileModel.GetTilePointToStage(TargetPoint.x, TargetPoint.y));
            } catch(e:Error) {
                GameCommonData.UIFacadeIntance.showPrompt(LanguageMgr.GetTranslation("当前地图无寻路"), 0xFFFF00);
            };
        }
        private function onGameSceneLoadComplete(_arg1:GameScene):void{
            var _local2:* = null;
            var _local3:* = null;
            var equipSetData:* = null;
            var _arg1:* = _arg1;
			
            GameCommonData.Player.SetMissionPrompt(0);
            if (loadCircle != null){
                GameCommonData.GameInstance.GameUI.removeChild(GameCommonData.Scene.loadCircle);
                GameCommonData.Scene.loadCircle = null;
            };
            if (((((!(GameCommonData.showChargeTips)) && ((GameCommonData.Player.Role.VIP == 0)))) && (!((GameCommonData.Player.Role.VIPEND == 0))))){
                UIFacade.GetInstance().sendNotification(EventList.SHOW_VIP_WARN_VIEW);
                GameCommonData.showChargeTips = true;
            };
            if ((_arg1 is GameScenePlay)){
                DestinationCursor.getInstance().setParent(_arg1.BottomLayer);
                this.gameScenePlay = (_arg1 as GameScenePlay);
                this.gameScenePlay.MouseDown = onMouseDown;
                GameCommonData.Player.MoveComplete = onPlayMoveComplete;
                GameCommonData.Player.MoveStep = onPlayMoveStep;
                GameCommonData.Player.MoveNode = onMoveNode;
                GameCommonData.Player.UpdateSkillEffect = PlayerController.onUpdateSkillEffect;
                GameCommonData.GameInstance.GameScene.GetGameScene.UpdateNicety = updateSmallMap;
                _local2 = MapTileModel.GetTilePointToStage(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
                _local3 = this.gameScenePlay.SceneMove(_local2.x, _local2.y, true);
                this.gameScenePlay.x = int(_local3.x);
                this.gameScenePlay.y = int(_local3.y);
                if (GameCommonData.GameInstance.GameScene.GetGameScene.name != GameCommonData.GameInstance.GameScene.GetGameScene.MapId){
                };
                if (!GameCommonData.IsLoadUserInfo){
                    SetUser();
                    GameCommonData.IsLoadUserInfo = true;
                    RepeatRequest.getInstance().bagItemCount = 0;
                    equipSetData = GameCommonData.GameInstance.Content.Load(GameConfigData.EquipSetList).GetByteArray();
                    EquipSetConst.GetEquipSetFromFile(equipSetData);
                    GameCommonData.GameInstance.Content.UnLoad(GameConfigData.EquipSetList);
                    GuildSend.getMyGuildInfo();
                    GuildSend.GetGuildAuras();
                    GuildSend.GuildGB_GetApplyList();
                    TaskSend.GetQuestLogQueryList();
                    GuildSend.getDutyList();
                    GuildSend.GetGuildEventsList();
                    GuildSend.getApplyList();
                    QuestionSend.GetMyQuestinfo();
                    GameCommonData.Scene.IsFirstLoad = true;
                    PlayerActionSend.GetPartyInfo(4294967295, 0);
                   UIFacade.GetInstance().sendNotification(EventList.SHOW_OFFLINEEXP, true);
                    if (GameCommonData.openServerDate > 7){
                      UIFacade.GetInstance().sendNotification(EventList.SHOW_CHARGE_CHEST, false);
                   } else {
                       UIFacade.GetInstance().sendNotification(EventList.SHOW_CHARGE_CHEST, true);//geoffyan
                   };
                } else {
                    if (GameCommonData.IsChangeOnline){
                        SetUser();
                        SendOnLoadComplete();
                        UIFacade.UIFacadeInstance.chgLineSuc();
                        GameCommonData.IsChangeOnline = false;
                        GameCommonData.Scene.IsFirstLoad = true;
                        GuildSend.GetGuildAuras();
                    } else {
                        SendOnLoadComplete();
                    };
                };
                this.IsSceneLoaded = true;
                SceneVerse = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SceneVerse");
                SceneVerse.mouseChildren = false;
                SceneVerse.mouseEnabled = false;
                SceneVerse.x = ((GameCommonData.GameInstance.ScreenWidth - SceneVerse.width) / 2);
                SceneVerse.y = (((GameCommonData.GameInstance.ScreenHeight - SceneVerse.height) / 2) - 170);
                SceneVerse.Container.txtMapName.text = this.gameScenePlay.MapName;
                if ((((this.gameScenePlay.MapName == LanguageMgr.GetTranslation("米德加特"))) && (!((GameCommonData.OwnerMainCity == ""))))){
                    SceneVerse.Container.txtDescription.text = ((((this.gameScenePlay.Description + "[") + GameCommonData.OwnerMainCity) + "]") + LanguageMgr.GetTranslation("公会所属"));
                    SceneVerse.Container.txtDescription.textColor = 0xBA00FF;
                } else {
                    SceneVerse.Container.txtDescription.text = this.gameScenePlay.Description;
                    SceneVerse.Container.txtDescription.textColor = 0xFFFF;
                };
                GameCommonData.GameInstance.GameUI.addChild(SceneVerse);
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:7,
                    id:0
                });
                clearTimeout(musicTimeOut);
                musicTimeOut = setTimeout(PlayMusic, 30000);
                if (GameCommonData.IsInTower){
                    PlayerActionSend.TowerLoadComplete();
                    AddOwner();
                    GameCommonData.IsInTower = false;
                    if (GameCommonData.TowerPetPlace != -1){
                        PetSend.Out(GameCommonData.TowerPetPlace);
                    };
                    GameCommonData.TowerPetPlace = -1;
                } else {
                    GameCommonData.TranscriptFinish = false;
                    PlayerActionSend.gameSceneLoadComplete(uint(_arg1.MapId));
                    if (GameCommonData.IsGotoParty){
                        UIFacade.GetInstance().sendNotification(WinPartEvent.SEND_GOTO_PARTY);
                        GameCommonData.IsGotoParty = false;
                    } else {
                        if (GameCommonData.IsGotoArena){
                            UIFacade.GetInstance().sendNotification(ArenaEvent.SEND_GO_ARENA);
                            GameCommonData.IsGotoArena = false;
                        } else {
                            if (GameCommonData.IsGotoCSB){
                                UIFacade.GetInstance().sendNotification(EventList.CSB_GOREADYSCENE);
                                GameCommonData.IsGotoCSB = false;
                            } else {
                                UIFacade.GetInstance().sendNotification(ArenaEvent.CLOSE_OTHER);
                            };
                        };
                    };
                };
                PlayerController.RefreshMediState();
                preloadTaskRes();
                if (judgeStoryDisplay(1)){
                    return;
                };
                if ((((GameCommonData.TargetScene == "")) && (GameCommonData.TaskTargetCommand))){
                    setTimeout(function ():void{
                        UIFacade.GetInstance().changeNpcWin(1);
                    }, 1000);
                };
                doGuide();
            };
            UIFacade.GetInstance().sendNotification(EventList.CHANGE_SCENEAFTER);
            trace("发送complete");
        }
        public function SetScenePos(_arg1:Boolean=false):void{
            var _local2:Point;
            if (this.IsSceneLoaded){
                _local2 = this.gameScenePlay.SceneMove(GameCommonData.Player.GameX, GameCommonData.Player.GameY, _arg1);
                if (GameCommonData.Rect != null){
                    GameCommonData.Rect.x = ((GameCommonData.Rect.x + this.gameScenePlay.x) - int(_local2.x));
                    GameCommonData.Rect.y = ((GameCommonData.Rect.y + this.gameScenePlay.y) - int(_local2.y));
                };
                this.gameScenePlay.x = int(_local2.x);
                this.gameScenePlay.y = int(_local2.y);
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:6,
                    id:0
                });
            };
        }
        private function onGameSceneTransferOpen():void{
            if (((!((this.SceneVerse == null))) && (!((this.SceneVerse.parent == null))))){
                GameCommonData.GameInstance.GameUI.removeChild(this.SceneVerse);
            };
        }
        public function CloseNPCDialog():void{
            if (GameCommonData.NPCDialogIsOpen){
                UIFacade.GetInstance().changeNpcWin(3);
            };
        }
        private function preloadTaskRes():void{
            switch (GameCommonData.GameInstance.GameScene.GetGameScene.name){
                case "1005":
                    if (((((GameCommonData.TaskInfoDic[1225]) && (GameCommonData.TaskInfoDic[1225].IsAccept))) && (!(GameCommonData.TaskInfoDic[1225].IsComplete)))){
                        SpeciallyEffectController.getInstance().showPotDropWaterMc(gameScenePlay, 97, 204);
                    };
                    break;
            };
        }
        public function MapPlayerTitleMove(_arg1:Point, _arg2:int=0, _arg3:String=""):void{
            var _local4:Point = MapTileModel.GetTilePointToStage(_arg1.x, _arg1.y);
            MapPlayerMove(_local4, _arg2, _arg3);
        }
        public function StopPlayerMove(_arg1:GameElementPlayer):void{
            this.ResetMoveState();
            this.PetResetMoveState();
            this.SetPlayerPos(_arg1);
            this.SetScenePos();
        }
        public function PetResetMoveState():void{
            if (GameCommonData.Player.Role.UsingPetAnimal != null){
                GameCommonData.Player.Role.UsingPetAnimal.Stop();
                this.PetmoveStepCount = 0;
            };
        }
        private function showJsMessage(_arg1:String):void{
            var _local2:uint = uint(_arg1);
            if ((((_local2 > 2000)) && (!((_local2 == 2002))))){
                JSManager.showMessage(LanguageMgr.GetTranslation("新你已进副本"), 2);
            };
        }
        public function DeletePlayer(_arg1:uint):void{
            var _local2:GameElementAnimal;
            var _local3:Boolean;
            var _local4:String;
            var _local5:GameElementAnimal;
            var _local6:String;
            var _local7:GameElementAnimal;
            var _local8:DataProxy;
            if (GameCommonData.SameSecnePlayerList[_arg1] != null){
                _local2 = GameCommonData.SameSecnePlayerList[_arg1];
                _local8 = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
                if (_local8.TESLPanelIsOpen){
                    if (TESL_CommonData.Avatars.indexOf(_local2.Role.MonsterTypeID) != -1){
                        UIFacade.GetInstance().sendNotification(TranscriptEvent.TESL_REMOVETRAP, _local2);
                    };
                };
                if ((((((_local2.Role.Type == GameRole.TYPE_PET)) || ((_local2.Role.Type == GameRole.TYPE_PLAYER)))) && (_local2.Enabled))){
                    this.ScenePlayerCount = (this.ScenePlayerCount - 1);
                };
                _local3 = false;
                if (this.ScenePlayerCount <= GameCommonData.SameSecnePlayerMaxCount){
                    for (_local4 in GameCommonData.SameSecnePlayerList) {
                        _local5 = GameCommonData.SameSecnePlayerList[_local4];
                        if ((((_local5.Role.Type == GameRole.TYPE_PLAYER)) && ((_local5.Enabled == false)))){
                            _local5.Enabled = true;
                            _local5.Visible = true;
                            _local3 = true;
                            if (GameCommonData.Screen == 0){
                                _local5.Visible = false;
                            };
                            this.ScenePlayerCount = (this.ScenePlayerCount + 1);
                            break;
                        };
                    };
                    if (_local3 == false){
                        for (_local6 in GameCommonData.SameSecnePlayerList) {
                            _local7 = GameCommonData.SameSecnePlayerList[_local6];
                            if ((((((((_local7.Role.Type == GameRole.TYPE_PET)) && (_local7.Role.MasterPlayer))) && (_local7.Role.MasterPlayer.Enabled))) && ((_local7.Enabled == false)))){
                                _local7.Enabled = true;
                                _local7.Visible = true;
                                if ((((GameCommonData.Screen == 0)) || ((GameCommonData.Screen == 1)))){
                                    if (!((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == _local7.Role.Id)))){
                                        _local7.Visible = false;
                                    };
                                };
                                this.ScenePlayerCount = (this.ScenePlayerCount + 1);
                                break;
                            };
                        };
                    };
                };
                if (GameCommonData.SameSecnePlayerList[_arg1] == GameCommonData.PetTargetAnimal){
                    if (GameCommonData.Player.Role.UsingPetAnimal != null){
                        GameCommonData.PetTargetAnimal = null;
                        GameCommonData.Player.Role.UsingPetAnimal.MoveSeek();
                    };
                };
                if (GameCommonData.SameSecnePlayerList[_arg1] == GameCommonData.TargetAnimal){
                    GameCommonData.TargetAnimal = null;
                    UIFacade.GetInstance().upDateInfo(31);
                };
                if (GameCommonData.SameSecnePlayerList[_arg1] == GameCommonData.AttackAnimal){
                    GameCommonData.AttackAnimal = null;
                };
                if ((((_local2.Role.Type == GameRole.TYPE_PLAYER)) && (_local2.Role.ConvoyCarAnimal))){
                    ConvoyController.removeConvoyCar(_local2);
                };
                if (_local2.Role.Type == GameRole.TYPE_PET){
                    if (((GameCommonData.Player.Role.UsingPetAnimal) && ((_local2 == GameCommonData.Player.Role.UsingPetAnimal)))){
                        GameCommonData.Player.Role.UsingPetAnimal.clearPath();
                        GameCommonData.PetTargetAnimal = null;
                        UIFacade.GetInstance().sendNotification(PlayerInfoComList.REMOVE_PET_UI);
                        GameCommonData.Player.Role.UsingPetAnimal = null;
                        if (GameCommonData.Player.IsAutomatism){
                            if (GameCommonData.lastPlayPetIdx != -1){
                                PetSend.Out(GameCommonData.lastPlayPetIdx);
                            };
                        };
                    };
                    if (((((_local2.Role.MasterPlayer) && (_local2.Role.MasterPlayer.Role))) && (_local2.Role.MasterPlayer.Role.UsingPetAnimal))){
                        _local2.Role.MasterPlayer.Role.UsingPetAnimal = null;
                    };
                };
                if (_local2.Role.Type == GameRole.TYPE_COLLECT){
                    if (GameCommonData.TargetAnimal == _local2){
                        UIFacade.GetInstance().sendNotification(PlayerInfoComList.REMOVE_TARGET_COLLECT, _local2.Role);
                    };
                };
                if (((!((GameCommonData.TeamPlayerList == null))) && (!((GameCommonData.TeamPlayerList[_local2.Role.Id] == null))))){
                    UIFacade.GetInstance().sendNotification(EventList.MEMBER_ONLINE_STATUS_TEAM, {
                        id:_local2.Role.Id,
                        state:1
                    });
                };
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:4,
                    id:_arg1
                });
                GameCommonData.SameSecnePlayerList[_arg1].AllDispose();
                delete GameCommonData.SameSecnePlayerList[_arg1];
                Render3DManager.getInstance().RemoveAnimation(_arg1);
            };
        }
        public function onPlayMoveStep(_arg1:GameElementAnimal):void{
            this.SetScenePos();
            this.updateSceneEffectElement();
            UIFacade.GetInstance().updateSmallMap({
                type:1,
                id:0
            });
            UIFacade.GetInstance().updateSmallMap({
                type:5,
                id:0
            });
        }
        public function SetPlayerPos(_arg1:GameElementPlayer):void{
            var _local2:Point = MapTileModel.GetTilePointToStage(_arg1.Role.TileX, _arg1.Role.TileY);
            _arg1.X = _local2.x;
            _arg1.Y = _local2.y;
        }
        public function configObject(_arg1:GameElementAnimal):void{
            var _local2:ModelOffset;
            var _local3:ModelOffset;
			
            if (_arg1.Role.Type == GameRole.TYPE_PLAYER){
                _arg1.Role.PersonSkinName = PlayerSkinsController.GetDress(_arg1.Role);
                _arg1.Role.WeaponSkinName = PlayerSkinsController.GetWeapen(_arg1.Role.WeaponSkinID, _arg1.Role.Sex);
                _arg1.Role.MountSkinName = PlayerSkinsController.GetMount(_arg1.Role.MountSkinID);
                _local2 = PlayerSkinsController.getSkinOffset(_arg1.Role);
                if (_local2 != null){
                    _arg1.Offset = new Point(_local2.X, _local2.Y);
                    _arg1.OffsetHeight = _local2.H;
                };
            } else {
                if ((((((_arg1.Role.Type == GameRole.TYPE_ENEMY)) || ((_arg1.Role.Type == GameRole.TYPE_PET)))) || ((_arg1.Role.Type == GameRole.TYPE_CONVOYCAR)))){
                    _local3 = GameCommonData.ModelOffsetNpcEnemy[_arg1.Role.MonsterTypeID];
                    if (_local3 != null){
                        _arg1.Offset = new Point(_local3.X, _local3.Y);
                        _arg1.OffsetHeight = _local3.H;
                        _arg1.Role.Title = _local3.Title;
                        if (((_local3.NotTurn) && ((_local3.NotTurn == 1)))){
                            _arg1.Role.IsTurn = false;
                        };
                        _arg1.Role.PersonSkinName = ((("Resources/Enemy/" + _local3.Swf) + ".swf?v=") + GameConfigData.EnemyVersion);
                        _arg1.skins.staticFrameRate = _local3.frameRate;
                        _arg1.skins.runFrameRate = _local3.frameRate1;
                        _arg1.skins.FrameRate = ((_arg1.skins.FrameRate > 0)) ? _arg1.skins.FrameRate : 1;
                    } else {
                        throw (new Error(("怪物类型没有填写对应swf" + _arg1.Role.MonsterTypeID.toString())));
                    };
                    _arg1.SetMoveSpend(_arg1.Role.Speed);
                } else {
                    if ((((_arg1.Role.Type == GameRole.TYPE_NPC)) || ((_arg1.Role.Type == GameRole.TYPE_COLLECT)))){
                        _local3 = GameCommonData.ModelOffsetNpcEnemy[_arg1.Role.MonsterTypeID];
                        if (_local3 != null){
                            _arg1.Offset = new Point(_local3.X, _local3.Y);
                            _arg1.skins.FrameRate = _local3.frameRate;
                            _arg1.skins.FrameRate = ((_arg1.skins.FrameRate > 0)) ? _arg1.skins.FrameRate : 1;
                            _arg1.OffsetHeight = _local3.H;
                            _arg1.Role.Title = _local3.Title;
                            if (((_local3.NotTurn) && ((_local3.NotTurn == 1)))){
                                _arg1.Role.IsTurn = false;
                            };
                            _arg1.Role.PersonSkinName = ((("Resources/NPC/" + _local3.Swf) + ".swf?v=") + GameConfigData.NPCVersion);
                        } else {
                            throw (new Error(("npc类型没有填写对应swf" + _arg1.Role.MonsterTypeID.toString())));
                        };
                        _arg1.SetMoveSpend(_arg1.Role.Speed);
                    };
                };
            };
            _arg1.ChooseTarger = PlayerMouseController.onChooseTarger;
            _arg1.MouseOutTarger = PlayerMouseController.onMouseOutTarger;
            _arg1.MouseOverTarger = PlayerMouseController.onMouseOverTarger;
            _arg1.MoveStep = PlayerController.onMoveStep;
            _arg1.ActionPlayFrame = PlayerController.onActionPlayFrame;
            _arg1.UpdateSkillEffect = PlayerController.onUpdateSkillEffect;
            _arg1.ActionPlayComplete = PlayerController.onActionPlayComplete;
        }
        public function get ScenePlayerCount():int{
            return (_ScenePlayerCount);
        }
        public function PlayerStop():void{
            DestinationCursor.getInstance().hide();
            GameCommonData.Player.Stop();
            GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
            GameCommonData.IsFollow = false;
            this.ResetMoveState();
            this.NextPoint = null;
            CloseNPCDialog();
            ClearAutoPath();
            GameCommonData.TargetScene = "";
            if (GameCommonData.Player.Role.UsingPetAnimal != null){
                GameCommonData.Player.Role.UsingPetAnimal.Stop();
                GameCommonData.Player.Role.UsingPetAnimal.SetAction(GameElementSkins.ACTION_STATIC);
                PetmoveStepCount = 0;
            };
        }
        private function updateSceneEffectElement():void{
            var _local1:GameElementSceneEffect;
            for each (_local1 in this.gameScenePlay.SEElements) {
                if ((((Math.abs((GameCommonData.Player.GameX - _local1.x)) < 800)) && ((Math.abs((GameCommonData.Player.GameY - _local1.y)) < 800)))){
                    if (this.gameScenePlay.BottomLayer.Elements.IndexOf(_local1) == -1){
                        this.gameScenePlay.BottomLayer.Elements.Add(_local1);
                    };
                } else {
                    if (this.gameScenePlay.BottomLayer.Elements.IndexOf(_local1) != -1){
                        this.gameScenePlay.BottomLayer.Elements.Remove(_local1);
                        _local1.Dispose();
                    };
                };
            };
        }
        public function UseSkill(_arg1:GameElementAnimal):void{
            var _local2:SkillInfo;
            GameCommonData.AttackAnimal = _arg1;
            if (GameCommonData.Player.Role.DefaultSkill == 0){
                GameCommonData.IsAddAttack = true;
                CombatController.ReserveAttack(_arg1);
                trace("发送攻击", _arg1.Role.Id);
            } else {
                _local2 = (GameCommonData.SkillList[GameCommonData.Player.Role.DefaultSkill] as SkillInfo);
                if (((!((_local2 == null))) && (!((_arg1 == null))))){
                    if (((GameSkillMode.IsSaveSkill(_local2)) || ((_arg1.Role.HP > 0)))){
                        PlayerController.UsePlayerSkill(_local2, _arg1, null);
                    };
                };
                GameCommonData.Player.Role.DefaultSkill = 0;
            };
            if (((((((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.HP > 0)))) && (!((_arg1 == null))))) && ((_arg1.Role.HP > 0)))){
                if (DistanceController.PetChangeTargetDistance(12)){
                    PetResetMoveState();
                    GameCommonData.Player.Role.UsingPetAnimal.SetAction(GameElementSkins.ACTION_STATIC);
                    GameCommonData.PetTargetAnimal = _arg1;
                } else {
                    GameCommonData.Player.Role.UsingPetAnimal.MoveSeek();
                };
            };
            PlayerController.RefreshMediState();
            if (GameCommonData.Player.Role.IsMediation){
                GameCommonData.Player.Role.IsMediation = false;
                PlayerController.BeginMediation(false);
            };
        }
        public function ClearSkill():void{
            var _local1:Object;
            var _local2:GameSkillResource;
            var _local3:SkillInfo;
            for (_local1 in GameCommonData.SkillOnLoadEffectList) {
                _local2 = (GameCommonData.SkillOnLoadEffectList[_local1] as GameSkillResource);
                _local3 = (GameCommonData.SkillList[_local2.SkillID] as SkillInfo);
                _local2.EffectBR = null;
                _local2.geed = null;
                _local2 = null;
                GameCommonData.SkillLoadEffectList[_local1] = null;
                delete GameCommonData.SkillLoadEffectList[_local1];
                GameCommonData.SkillOnLoadEffectList[_local1] = null;
                delete GameCommonData.SkillOnLoadEffectList[_local1];
            };
        }
        public function SetUser():void{
            var _local1:ModelOffset = PlayerSkinsController.getSkinOffset(GameCommonData.Player.Role);
            if (_local1){
                GameCommonData.Player.Offset = new Point(_local1.X, _local1.Y);
                GameCommonData.Player.OffsetHeight = _local1.H;
            };
            GameCommonData.Player.Role.MountSkinName = PlayerSkinsController.GetMount(GameCommonData.Player.Role.MountSkinID);
            GameCommonData.Player.Role.PersonSkinName = PlayerSkinsController.GetDress(GameCommonData.Player.Role);
            if (PlayerSkinsController.IsCanUse(parseInt(GameCommonData.Player.Role.WeaponSkinName), GameCommonData.Player.Role.CurrentJobID)){
                GameCommonData.Player.Role.WeaponSkinName = PlayerSkinsController.GetWeapen(parseInt(GameCommonData.Player.Role.WeaponSkinName), GameCommonData.Player.Role.Sex);
            };
        }
        public function MapPlayerMove(_arg1:Point, _arg2:int=0, _arg3:String=""):void{
            var _local4:Point;
            var _local5:int;
            var _local6:Point;
            if (ChgLineData.isChgLine){
                return;
            };
            GameCommonData.IsMoveTargetAnimal = false;
            CloseNPCDialog();
            if (IsPlayerWalk()){
                if (((((!((_arg2 == 0))) && ((_arg3 == "")))) || ((GameCommonData.GameInstance.GameScene.GetGameScene.name == _arg3)))){
                    _local4 = MapTileModel.GetTileStageToPoint(_arg1.x, _arg1.y);
                    _local5 = MapTileModel.Distance(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, _local4.x, _local4.y);
                    if (_local5 <= _arg2){
                        if (GameCommonData.isAutoPath){
                            UIFacade.GetInstance().changeNpcWin(1);
                            GameCommonData.isAutoPath = false;
                        };
                        return;
                    };
                };
                GameCommonData.TargetPoint = MapTileModel.GetTileStageToPoint(_arg1.x, _arg1.y);
                GameCommonData.TargetDistance = _arg2;
                GameCommonData.TargetScene = "";
                playerdistance = _arg2;
                if ((((_arg3.length > 0)) && (!((_arg3 == GameCommonData.GameInstance.GameScene.GetGameScene.name))))){
                    GameCommonData.TargetScene = _arg3;
                    MoveNextScenePoint();
                } else {
                    _local6 = MapTileModel.GetTileStageToPoint(_arg1.x, _arg1.y);
                    if (this.gameScenePlay.Map.IsPass(_local6.x, _local6.y)){
                        PlayerMove(_arg1);
                    };
                };
            } else {
                GameCommonData.isAutoPath = false;
            };
        }
        public function RemoveAllElementBefourLevelScene():void{
            var _local1:String;
            var _local2:GameElementAnimal;
            var _local3:Array = [];
            for (_local1 in GameCommonData.SameSecnePlayerList) {
                _local3.push(_local1);
            };
            for each (_local1 in _local3) {
                if (((GameCommonData.SameSecnePlayerList[_local1]) && ((GameCommonData.SameSecnePlayerList[_local1] is GameElementAnimal)))){
                    _local2 = GameCommonData.SameSecnePlayerList[_local1];
                    if (_local2.handler){
                        _local2.handler.Clear();
                    };
                    DeletePlayer(_local2.Role.Id);
                };
            };
            GameCommonData.Player.SetParentScene(null);
            this.ScenePlayerCount = 0;
            this.gameScenePlay.ClearElement();
            if (GameCommonData.Player.Role.UsingPetAnimal){
                GameCommonData.Player.Role.UsingPetAnimal.clearPath();
                GameCommonData.PetTargetAnimal = null;
                UIFacade.GetInstance().sendNotification(PlayerInfoComList.REMOVE_PET_UI);
                GameCommonData.Player.Role.UsingPetAnimal = null;
            };
        }
        private function doGuide():void{
            UIFacade.GetInstance().sendNotification(NewGuideEvent.NEWPLAYER_GUILD_CHANGESCENE);
        }
        public function AddOwner():void{
            this.AddPlayer(GameCommonData.Player);
            GameCommonData.Player.ActionPlayFrame = PlayerController.onActionPlayFrame;
            UIFacade.UIFacadeInstance.updateSmallMap({
                type:7,
                id:0
            });
            this.gameScenePlay.Background.LoadMap();
            trace("add owner");
            if (!(((GameCommonData.Player.Role.UsingPetId > 0)) && ((GameCommonData.Player.Role.UsingPetAnimal == null)))){
                if (GameCommonData.TargetScene.length > 0){
                    if (GameCommonData.TargetScene != GameCommonData.GameInstance.GameScene.GetGameScene.name){
                        GameCommonData.Scene.MoveNextScenePoint();
                    } else {
                        GameCommonData.Scene.playerdistance = GameCommonData.TargetDistance;
                        GameCommonData.Scene.PlayerMove(MapTileModel.GetTilePointToStage(GameCommonData.TargetPoint.x, GameCommonData.TargetPoint.y));
                        GameCommonData.TargetScene = "";
                    };
                    GameCommonData.isAutoPath = true;
                };
            };
        }
        public function IsPlayerWalk():Boolean{
            var _local1:Boolean = true;
            if (GameCommonData.Player.Role.State == GameRole.STATE_TRADE){
                UIFacade.GetInstance().showNoMoveInfo(1);
                _local1 = false;
            } else {
                if (GameCommonData.Player.Role.State == GameRole.STATE_STALL){
                    UIFacade.GetInstance().showNoMoveInfo(2);
                    _local1 = false;
                } else {
                    if (GameCommonData.Player.Role.State == GameRole.STATE_LOOKINGNPCSHOP){
                        _local1 = false;
                    } else {
                        if (GameCommonData.Player.Role.State != GameRole.STATE_NULL){
                            _local1 = false;
                        };
                    };
                };
            };
            if (GameCommonData.Player.Role.HP == 0){
                _local1 = false;
            };
            return (_local1);
        }
        public function SetCursor():void{
            var _local1:Point;
            if (GameCommonData.IsMoveTargetAnimal == false){
                DestinationCursor.getInstance().hide();
                _local1 = MapTileModel.GetTileStageToPoint(this.gameScenePlay.mouseX, this.gameScenePlay.mouseY);
                if (this.gameScenePlay.Map.IsPass(_local1.x, _local1.y)){
                    _local1 = MapTileModel.GetTilePointToStage(_local1.x, _local1.y);
                    DestinationCursor.getInstance().show();
                    DestinationCursor.getInstance().desIcon.x = _local1.x;
                    DestinationCursor.getInstance().desIcon.y = _local1.y;
                };
            };
        }
        public function updateSmallMap():void{
            UIFacade.UIFacadeInstance.updateSmallMap({
                type:1,
                id:0
            });
        }
        public function DistanceUseSkill(_arg1:int):void{
            if ((((GameCommonData.Player.Role.HP > 0)) && (!((GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                if (GameCommonData.AttackAnimal != null){
                    if (DistanceController.PlayerTargetAnimalDistance(GameCommonData.AttackAnimal, _arg1)){
                        GameCommonData.Player.Stop();
                        if (GameCommonData.Player.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK){
                            GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                        };
                        UseSkill(GameCommonData.AttackAnimal);
                        this.ResetMoveState();
                        this.PetResetMoveState();
                        GameCommonData.IsMoveTargetAnimal = false;
                    };
                };
            };
        }
        public function TransferScene(_arg1:String, _arg2:String):void{
            var _arg1:* = _arg1;
            var _arg2:* = _arg2;
            this.gameScenePlay.IsUpdateNicety = false;
            this.IsSceneLoaded = false;
            this.IsCanController = false;
            setTimeout(SetCanController, 5000);
            GameCommonData.preMapId = int(GameCommonData.GameInstance.GameScene.GetGameScene.MapId);
            GameCommonData.Player.prepPoint = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
            if (_arg2 != GameCommonData.GameInstance.GameScene.GetGameScene.MapId){
                showJsMessage(_arg2);
                RemoveAllElementBefourLevelScene();
                if (GameCommonData.Scene.loadCircle == null){
                    GameCommonData.Scene.loadCircle = (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LoadCircle") as MovieClip);
                    GameCommonData.Scene.loadCircle.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                    GameCommonData.Scene.loadCircle.y = (GameCommonData.GameInstance.ScreenHeight / 2);
                    GameCommonData.GameInstance.GameUI.addChild(GameCommonData.Scene.loadCircle);
                };
                GameCommonData.GameInstance.GameScene.TransferScene(_arg1, _arg2);
            } else {
                DestinationCursor.getInstance().setParent(GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer);
                this.IsSceneLoaded = true;
                GameCommonData.Scene.StopPlayerMove(GameCommonData.Player);
                GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                if (GameCommonData.Player.Role.UsingPetAnimal){
                    PetController.getInstance().ResetPetPos(GameCommonData.Player.Role.UsingPetAnimal);
                };
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:1,
                    id:0
                });
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:5,
                    id:0
                });
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:6,
                    id:0
                });
                if (judgeStoryDisplay(1)){
                    if (GameCommonData.Player.IsAutomatism){
                        if (!MapManager.IsInTower()){
                            PlayerController.EndAutomatism();
                        };
                    };
                    GameCommonData.isAutoPath = false;
                    UIFacade.UIFacadeInstance.closeOpenPanel();
                    BagData.clearLocks();
                    return;
                };
                if ((((GameCommonData.TargetScene == "")) && (GameCommonData.TaskTargetCommand))){
                    setTimeout(function ():void{
                        UIFacade.GetInstance().changeNpcWin(1);
                    }, 1000);
                };
                setTimeout(doGuide, 1000);
            };
            if (GameCommonData.Player.IsAutomatism){
                if (!MapManager.IsInTower()){
                    PlayerController.EndAutomatism();
                };
            };
            GameCommonData.isAutoPath = false;
            UIFacade.UIFacadeInstance.closeOpenPanel();
            BagData.clearLocks();
        }
        public function AddPlayer(_arg1:GameElementAnimal):void{
            var _local3:GameElementPet;
            var _local4:DataProxy;
            var _local5:int;
            var _local6:ItemTemplateInfo;
            var _local7:uint;
            var _local8:GameElementPet;
            var _local9:JianTouMc;
            var _local2:Number = getTimer();
            _arg1.SetParentScene(this.gameScenePlay);
            if (GameCommonData.IsSelfDead){
                _arg1.filters = [ColorFilters.BWFilter];
            };
            if (_arg1.Role.Face == 30000){
                this.gameScenePlay.TopLayer.Elements.Add(_arg1);
            } else {
                UIFacade.UIFacadeInstance.updateSmallMap({
                    type:3,
                    id:_arg1.Role.Id
                });
                if (_arg1 == GameCommonData.Player){
                    _arg1.Skins.IsEffect(false);
                };
                if (this.gameScenePlay.MiddleLayer.Elements.IndexOf(_arg1) == -1){
                    this.gameScenePlay.MiddleLayer.Elements.Add(_arg1);
                };
                if (_arg1.Role.HP == 0){
                    if ((((_arg1.Role.Type == GameRole.TYPE_OWNER)) || ((_arg1.Role.Type == GameRole.TYPE_PLAYER)))){
                        if (_arg1.Role.HP == 0){
                            if (_arg1.Role.Type == GameRole.TYPE_OWNER){
                                _arg1.Skins.InitActionDead(2);
                            } else {
                                if (_arg1.Role.Type == GameRole.TYPE_PLAYER){
                                    _arg1.Skins.InitActionDead(2);
                                } else {
                                    if (_arg1.Role.Type == GameRole.TYPE_ENEMY){
                                        _arg1.Skins.InitActionDead(0);
                                    };
                                };
                            };
                        };
                    };
                    if (_arg1.Role.Id == GameCommonData.Player.Role.Id){
                        UIFacade.UIFacadeInstance.showRelive();
                    };
                };
                switch (_arg1.Role.Type){
                    case GameRole.TYPE_PET:
                        if (!((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == _arg1.Role.Id)))){
                            if (this.ScenePlayerCount >= GameCommonData.SameSecnePlayerMaxCount){
                                _arg1.Visible = false;
                                _arg1.Enabled = false;
                            };
                        } else {
                            UIFacade.UIFacadeInstance.sendNotification(EventList.ALLROLEINFO_UPDATE, {
                                id:_arg1.Role.Id,
                                type:1001
                            });
                        };
                        break;
                    case GameRole.TYPE_PLAYER:
                        if (this.ScenePlayerCount >= GameCommonData.SameSecnePlayerMaxCount){
                            _arg1.Visible = false;
                            _arg1.Enabled = false;
                        };
                        if (((_arg1.Role.UsingPetAnimal) && (_arg1.Role.UsingPetAnimal.Enabled))){
                            _arg1.Visible = true;
                            _arg1.Enabled = true;
                        };
                        break;
                    case GameRole.TYPE_CONVOYCAR:
                        _arg1.Visible = true;
                        _arg1.Enabled = true;
                        break;
                };
                switch (_arg1.Role.Type){
                    case GameRole.TYPE_PET:
                        if ((((GameCommonData.Screen == 0)) || ((GameCommonData.Screen == 1)))){
                            if (!((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == _arg1.Role.Id)))){
                                _arg1.Visible = false;
                            };
                        };
                        break;
                    case GameRole.TYPE_PLAYER:
                        if (GameCommonData.Screen == 0){
                            _arg1.Visible = false;
                        };
                        break;
                };
                if (_arg1.Role.isHidden){
                    _arg1.Visible = false;
                };
                if ((((((_arg1.Role.Type == GameRole.TYPE_OWNER)) || ((_arg1.Role.Type == GameRole.TYPE_PLAYER)))) && ((_arg1.Role.ConvoyFlag > 0)))){
                    ConvoyController.addConvoyCar(_arg1);
                };
                if (_arg1.Role.Type == GameRole.TYPE_PET){
                    if (_arg1.Role.MasterPlayer){
                        _local6 = UIConstData.ItemDic[_arg1.Role.MasterPlayer.Role.MountSkinID];
                        _local7 = 0;
                        if (_local6 != null){
                            _local7 = (_local6.Color + 2);
                        };
                        _arg1.SetMoveSpend((5 + _local7));
                    };
                    _local5 = _arg1.Role.MasterId;
                    if (_arg1.Role.MasterId == GameCommonData.Player.Role.Id){
                        _arg1.Role.MasterPlayer = GameCommonData.Player;
                        GameCommonData.Player.Role.UsingPetAnimal = (_arg1 as GameElementPet);
                        _arg1.Role.Title = _arg1.Role.MasterPlayer.Role.Name;
                        if (GameCommonData.Player.Role.UsingPet){
                            GameCommonData.Player.Role.UsingPet.IsUsing = true;
                        };
                        UIFacade.GetInstance().sendNotification(PlayerInfoComList.SHOW_PET_UI, _arg1.Role);
                        PetController.getInstance().MoveToMaster(_arg1);
                    } else {
                        if (((GameCommonData.SameSecnePlayerList[_local5]) && ((GameCommonData.SameSecnePlayerList[_local5] is GameElementPlayer)))){
                            _arg1.Role.MasterPlayer = GameCommonData.SameSecnePlayerList[_local5];
                            _arg1.Role.Title = _arg1.Role.MasterPlayer.Role.Name;
                            GameCommonData.SameSecnePlayerList[_local5].Role.UsingPetAnimal = _arg1;
                        } else {
                            _arg1.Role.Title = (_arg1.Role.Title + "(找不到主人)");
                        };
                    };
                    _arg1.ShowTitle();
                    ConvoyController.setMoveSpeed(_arg1);
                    if (((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == _arg1.Role.Id)))){
                        if (GameCommonData.TargetScene.length > 0){
                            if (GameCommonData.TargetScene != GameCommonData.GameInstance.GameScene.GetGameScene.name){
                                GameCommonData.Scene.MoveNextScenePoint();
                            } else {
                                GameCommonData.Scene.playerdistance = GameCommonData.TargetDistance;
                                GameCommonData.Scene.PlayerMove(MapTileModel.GetTilePointToStage(GameCommonData.TargetPoint.x, GameCommonData.TargetPoint.y));
                                GameCommonData.TargetScene = "";
                            };
                            GameCommonData.isAutoPath = true;
                        };
                    };
                };
                _local4 = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
                if (((_local4) && ((_local4.screenAll == false)))){
                    if ((((((_arg1.Role.Type == GameRole.TYPE_PET)) && (!((_arg1.Role.MasterPlayer == GameCommonData.Player))))) || ((_arg1.Role.Type == GameRole.TYPE_PLAYER)))){
                        if (((!(_arg1.Role.isHidden)) && (_arg1.Enabled))){
                            _arg1.Visible = false;
                        };
                    };
                };
                if ((((_arg1.Role.Type == GameRole.TYPE_OWNER)) || ((_arg1.Role.Type == GameRole.TYPE_PLAYER)))){
                    if (SharedManager.getInstance().showGuildName){
                        _arg1.showGuildName();
                    } else {
                        _arg1.hideGuildName();
                    };
                    if (SharedManager.getInstance().showPlayerTitle){
                        _arg1.ShowTitle();
                    } else {
                        _arg1.HideTitle();
                    };
                    if ((((_arg1.Role.UsingPetId > 0)) && ((_arg1.Role.UsingPetAnimal == null)))){
                        if (((GameCommonData.SameSecnePlayerList[_arg1.Role.UsingPetId]) && ((GameCommonData.SameSecnePlayerList[_arg1.Role.UsingPetId].Role.MasterId == _arg1.Role.Id)))){
                            _local8 = (GameCommonData.SameSecnePlayerList[_arg1.Role.UsingPetId] as GameElementPet);
                            _arg1.Role.UsingPetAnimal = _local8;
                            _local8.Role.MasterPlayer = (_arg1 as GameElementPlayer);
                            _local8.Role.Title = _local8.Role.MasterPlayer.Role.Name;
                            _local8.ShowTitle();
                        };
                    };
                };
            };
            if ((((((_arg1.Role.Type == GameRole.TYPE_PET)) || ((_arg1.Role.Type == GameRole.TYPE_PLAYER)))) && (_arg1.Enabled))){
                if (GameCommonData.SameSecnePlayerList[_arg1.Role.Id] == null){
                    this.ScenePlayerCount = (this.ScenePlayerCount + 1);
                };
            };
            if ((((((_arg1.Role.Type == GameRole.TYPE_OWNER)) && (!(SharedManager.getInstance().showSelfBlood)))) || (!(SharedManager.getInstance().showOtherBlood)))){
                _arg1.setBloodViewVisble(false);
            };
            if (((!((GameCommonData.TeamPlayerList == null))) && (!((GameCommonData.TeamPlayerList[_arg1.Role.Id] == null))))){
                UIFacade.GetInstance().sendNotification(EventList.MEMBER_ONLINE_STATUS_TEAM, {
                    id:_arg1.Role.Id,
                    state:0
                });
            };
            if (_local4.TESLPanelIsOpen){
                if (TESL_CommonData.Avatars.indexOf(_arg1.Role.MonsterTypeID) != -1){
                    UIFacade.GetInstance().sendNotification(TranscriptEvent.TESL_ADDTRAP, _arg1);
                };
            };
            if (NewGuideData.PointNPCIsOpen){
                if ((((((_arg1.Role.MonsterTypeID == 1077)) && (GameCommonData.TaskInfoDic[1233]))) && (GameCommonData.TaskInfoDic[1233].IsAccept))){
                    _local9 = JianTouMc.getInstance(_arg1.Role.MonsterTypeID.toString()).show(_arg1, "", 3);
                    _local9.autoClickClean = true;
                    _local9.setJTToTargetPostion(_arg1.parent);
                };
                if ((((((((_arg1.Role.MonsterTypeID == 1137)) && (GameCommonData.TaskInfoDic[1306]))) && (GameCommonData.TaskInfoDic[1306].IsAccept))) && (!(GameCommonData.TaskInfoDic[1306].IsComplete)))){
                    _local9 = JianTouMc.getInstance(_arg1.Role.MonsterTypeID.toString()).show(_arg1, "", 3);
                    _local9.autoClickClean = true;
                    _local9.setJTToTargetPostion(_arg1.parent);
                };
            };
        }
        public function ClearAutoPath():void{
            if (GameCommonData.isAutoPath){
                GameCommonData.isAutoPath = false;
                UIFacade.GetInstance().changeNpcWin(2);
            };
        }
        private function PlayMusic():void{
            if (SharedManager.getInstance().allowMusic){
                if (GameCommonData.GameInstance.GameScene.GetGameScene != null){
                    GameCommonData.GameInstance.GameScene.GetGameScene.MusicLoad(SharedManager.getInstance().musicVolumn);
                };
            };
        }
        private function judgeStoryDisplay(_arg1:int):Boolean{
            var _local2:StoryVO;
            var _local3:TaskInfoStruct;
            var _local4:Boolean;
            var _local5:Array;
            var _local6:Point;
            var _local7:Point;
            for each (_local2 in GameCommonData.StoryDisplayList) {
                _local3 = GameCommonData.TaskInfoDic[_local2.taskID];
                if (_local3 == null){
                    break;
                };
                if (_local2.count <= _local3.storyCount){
                    break;
                };
                _local4 = false;
                switch (int(_local2.taskProgress[_local3.storyCount])){
                    case 10:
                        if (_local3.IsAccept){
                            _local4 = true;
                        };
                        break;
                    case 20:
                        if ((((TaskCommonData.CompleteTaskIdArray.indexOf(_local3.taskId) == -1)) && (_local3.IsComplete))){
                            _local4 = true;
                        };
                        break;
                    case 30:
                        if (TaskCommonData.CompleteTaskIdArray.indexOf(_local3.taskId) != -1){
                            _local4 = true;
                        };
                        break;
                };
                if (_local4){
                    if (_local2.tileList[(_local3.storyCount + 1)] != null){
                        for each (_local5 in _local2.tileList[(_local3.storyCount + 1)]) {
                            if (GameCommonData.GameInstance.GameScene.GetGameScene.MapId == _local5[0]){
                                _local6 = new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
                                _local7 = new Point(_local5[1], _local5[2]);
                                if (DistanceController.Distance(_local6, _local7, 3)){
                                    UIFacade.GetInstance().sendNotification(StoryDisplayConst.PLAYER_STOP, {
                                        vo:_local2,
                                        taskInfo:_local3,
                                        type:_arg1
                                    });
                                    return (true);
                                };
                            };
                        };
                    };
                };
            };
            return (false);
        }
        public function onMouseDown(_arg1:MouseEvent):void{
			
            var _local2:SkillInfo;
            var _local3:Object;
            var _local4:SkillInfo;
            var _local9:Point;
            var _local10:int;
            var _local11:Point;
            var _local12:Point;
            if ((((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).BagIsSplit) || ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).BagIsDestory))){
                return;
            };
            if (GameCommonData.Player.gameScene == null){
                trace("自己还没加载到当前场景");
                return;
            };
            if (ChgLineData.isChgLine){
                return;
            };
            if ((((GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK)) && (GameCommonData.Player.IsLoadSkins))){
                return;
            };
            if (this.IsSceneLoaded == false){
                return;
            };
            if (GameCommonData.Player.IsRushing == true){
                return;
            };
            GameCommonData.IsAddAttack = false;
            GameCommonData.AttackAnimal = null;
            GameCommonData.IsFollow = false;
            GameCommonData.TargetPickItem = null;
            if (!gameScenePlay.Map.IsPass(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY)){
                _local9 = this.gameScenePlay.Map.FindNearPassPoint(new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY));
                GameCommonData.Player.Role.TileX = _local9.x;
                GameCommonData.Player.Role.TileY = _local9.y;
            };
            var _local5:Point = MapTileModel.GetTileStageToPoint(this.gameScenePlay.mouseX, this.gameScenePlay.mouseY);
            var _local6:Point = new Point(this.gameScenePlay.mouseX, this.gameScenePlay.mouseY);
            if (((!((GameCommonData.Rect == null))) && (!((GameCommonData.RectSkillID == 0))))){
                SpeciallyEffectController.getInstance().ClearFloorEffect();
                _local2 = GameCommonData.SkillList[GameCommonData.RectSkillID];
                GameCommonData.RectSkillPos = _local5;
                if (DistanceController.AnimalTargetDistance(GameCommonData.Player, _local5, _local2.Distance)){
                    PlayerController.PlayerUseSkill(_local2, _local5);
                } else {
                    this.playerdistance = _local2.Distance;
                    GameCommonData.TargetScene = "";
                    UIFacade.GetInstance().changePath();
                    PlayerMove(_local6);
                };
                CloseNPCDialog();
                ClearAutoPath();
                return;
            };
            GameCommonData.RectSkillID = 0;
            GameCommonData.RectSkillPos = null;
            var _local7:Boolean;
            var _local8:Boolean;
            this.playerdistance = 0;
            if (_arg1.target.name == this.gameScenePlay.name){
                if (GameCommonData.Player.IsAutomatism){
                    PlayerController.EndAutomatism();
                };
                SysCursor.GetInstance().isLock = false;
                GameCommonData.IsMoveTargetAnimal = false;
                if (!this.gameScenePlay.Map.IsPass(_local5.x, _local5.y)){
                    return;
                };
                if ((((GameCommonData.Player.Role.TileX == _local5.x)) && ((GameCommonData.Player.Role.TileY == _local5.y)))){
                    return;
                };
            } else {
                if ((((GameCommonData.Player.Role.TileX == _local5.x)) && ((GameCommonData.Player.Role.TileY == _local5.y)))){
                    if ((((GameCommonData.TargetAnimal == null)) && ((_arg1.target.name.indexOf("Package_") == -1)))){
                        return;
                    };
                };
            };
            ClearAutoPath();
            DestinationCursor.getInstance().hide();
            if (_arg1.target.name.indexOf("Package_") > -1){
                this.playerdistance = 1;
                _local3 = new Object();
                _local3.items = _arg1.target.Data;
                _local3.id = _arg1.target.ID;
                _local3.target = _arg1.target;
                _local3.x = _arg1.stageX;
                _local3.y = _arg1.stageY;
                if (DistanceController.AnimalTargetDistance(GameCommonData.Player, new Point(_arg1.target.TileX, _arg1.target.TileY), 2)){
                    GameCommonData.UIFacadeIntance.PickItem(_local3);
                    GameCommonData.TargetPickItem = null;
                    _local7 = false;
                    _local8 = false;
                } else {
                    GameCommonData.TargetPickItem = _local3;
                    _local7 = true;
                    _local8 = true;
                };
            } else {
                if (((!((GameCommonData.TargetAnimal == null))) && ((GameCommonData.IsMoveTargetAnimal == true)))){
                    GameCommonData.Player.Role.DefaultSkill = 0;
                    GameCommonData.TargetScene = "";
                    UIFacade.UIFacadeInstance.selectPlayer();
                    if (GameCommonData.TargetAnimal.Role.Face == 30000){
                        _local7 = false;
                        _local8 = false;
                        CloseNPCDialog();
                    } else {
                        if (PlayerController.IsUseSkill(GameCommonData.Player, GameCommonData.TargetAnimal)){
                            CloseNPCDialog();
                            if (TargetController.IsAttack(GameCommonData.TargetAnimal)){
                                GameCommonData.AttackAnimal = GameCommonData.TargetAnimal;
                                if (GameCommonData.Player.Role.DefaultSkill == 0){
                                    _local4 = SkillManager.GetDefaultSkill(GameCommonData.Player);
                                } else {
                                    _local4 = (GameCommonData.SkillList[GameCommonData.Player.Role.DefaultSkill] as SkillInfo);
                                };
                                this.playerdistance = _local4.Distance;
                                if (DistanceController.PlayerTargetAnimalDistance(GameCommonData.TargetAnimal, playerdistance)){
                                    if (!DistanceController.PlayerTarAnimalRealyDistance(GameCommonData.TargetAnimal, playerdistance)){
                                        if (((!((GameCommonData.TargetAnimal == null))) && ((GameCommonData.IsMoveTargetAnimal == true)))){
                                            if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_RUN){
                                                return;
                                            };
                                        };
                                    };
                                    GameCommonData.Player.Stop();
                                    if (GameCommonData.Player.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK){
                                        GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                                    };
                                    if (((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.ActionState == GameElementSkins.ACTION_RUN)))){
                                        GameCommonData.Player.Role.UsingPetAnimal.Stop();
                                        GameCommonData.Player.Role.UsingPetAnimal.SetAction(GameElementSkins.ACTION_STATIC);
                                    };
                                    UseSkill(GameCommonData.AttackAnimal);
                                    _local7 = false;
                                    _local8 = false;
                                    this.ResetMoveState();
                                    this.PetResetMoveState();
                                } else {
                                    _local7 = true;
                                    _local8 = false;
                                    _local6 = new Point(GameCommonData.TargetAnimal.GameX, GameCommonData.TargetAnimal.GameY);
                                };
                            } else {
                                _local7 = false;
                                _local8 = false;
                                GameCommonData.IsMoveTargetAnimal = false;
                                _local6 = new Point(this.gameScenePlay.mouseX, this.gameScenePlay.mouseY);
                            };
                        } else {
                            playerdistance = 3;
                            if (DistanceController.PlayerTargetAnimalDistance(GameCommonData.TargetAnimal, 4)){
                                if (GameCommonData.Player.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK){
                                    GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                                };
                                if (GameCommonData.TargetAnimal.Role.Type == GameRole.TYPE_NPC){
                                    _local10 = Vector2.DirectionByTan(GameCommonData.TargetAnimal.GameX, GameCommonData.TargetAnimal.GameY, GameCommonData.Player.GameX, GameCommonData.Player.GameY);
                                    if (GameCommonData.TargetAnimal.Role.IsTurn){
                                        GameCommonData.TargetAnimal.SetDirection(_local10);
                                    };
                                    GameCommonData.Player.SetDirection(Vector2.OppositeDirection(_local10));
                                    UIFacade.GetInstance().changeNpcWin(1, GameCommonData.TargetAnimal.Role.Id);
                                } else {
                                    if (GameCommonData.TargetAnimal.Role.Type == GameRole.TYPE_COLLECT){
                                        UIFacade.GetInstance().sendNotification(PlayerInfoComList.START_COLLECT, GameCommonData.TargetAnimal);
                                    };
                                };
                                _local7 = false;
                                _local8 = false;
                                if (((!((GameCommonData.Player.Role.UsingPetAnimal == null))) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.ActionState == GameElementSkins.ACTION_RUN)))){
                                    GameCommonData.Player.Role.UsingPetAnimal.Stop();
                                    GameCommonData.Player.Role.UsingPetAnimal.SetAction(GameElementSkins.ACTION_STATIC);
                                };
                                this.ResetMoveState();
                                this.PetResetMoveState();
                            } else {
                                CloseNPCDialog();
                                _local7 = true;
                                _local8 = false;
                                _local6 = new Point(GameCommonData.TargetAnimal.GameX, (GameCommonData.TargetAnimal.GameY + 30));
                            };
                            if (((GameCommonData.Player.IsAutomatism) || (AutoFbManager.IsAutoFbing))){
                                PlayerController.EndAutomatism();
                            };
                        };
                    };
                } else {
                    CloseNPCDialog();
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).IsCollecting){
                        GameCommonData.TargetAnimal = null;
                        UIFacade.GetInstance().sendNotification(PlayerInfoComList.CANCEL_COLLECT, false);
                    };
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).IsGrabPeting){
                        UIFacade.GetInstance().sendNotification(PlayerInfoComList.CANCEL_COLLECT, false);
                    };
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).IsUseTaskItem){
                        UIFacade.GetInstance().sendNotification(BagEvents.CANCEL_TASKITEM_USE);
                    };
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).NPCShopIsOpen){
                        UIFacade.GetInstance().sendNotification(EventList.CLOSENPCSHOPVIEW);
                    };
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).DepotIsOpen){
                        UIFacade.GetInstance().sendNotification(EventList.CLOSEDEPOTVIEW);
                    };
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).NPCExchangeIsOpen){
                        UIFacade.GetInstance().sendNotification(EventList.CLOSENPCEXCHANGEVIEW);
                    };
                    if ((UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).ConvoyIsOpen){
                        UIFacade.GetInstance().sendNotification(EventList.CLOSE_CONVOY_UI);
                    };
                    if (((GameCommonData.Player.IsAutomatism) || (AutoFbManager.IsAutoFbing))){
                        PlayerController.EndAutomatism();
                    };
                };
            };
//            if (IsPlayerWalk() == false){
//                _local7 = false;
//                _local8 = false;
//            };
			_local8 = _local7 = true;
            if (_local8){
                this.SetCursor();
            };
            if (_local7){
                GameCommonData.TargetScene = "";
                UIFacade.GetInstance().changePath();
                _local11 = MapTileModel.GetTileStageToPoint(_local6.x, _local6.y);
                if (!this.gameScenePlay.Map.IsPass(_local11.x, _local11.y)){
                    _local12 = this.gameScenePlay.Map.FindNearPassPoint(_local11);
                    _local6 = MapTileModel.GetTilePointToStage(_local12.x, _local12.y);
                };
                PlayerMove(_local6);
            };
        }
        public function ResetMoveState():void{
            GameCommonData.Player.Stop();
            this.NextPoint = null;
            this.moveStepCount = 0;
        }
        public function set ScenePlayerCount(_arg1:int):void{
            _ScenePlayerCount = _arg1;
            trace("_ScenePlayerCount", _ScenePlayerCount);
        }
        public function onPetPlayMoveComplete():void{
            this.PetResetMoveState();
        }
        public function HelloNPC(_arg1:GameElementAnimal, _arg2:int=0):void{
            var _local3:Boolean;
            var _local4:Point = new Point();
            if (GameCommonData.Player.IsRushing == true){
                return;
            };
            if (((((!((_arg1 == null))) && ((GameCommonData.Player.Role.HP > 0)))) && (!((GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                GameCommonData.IsMoveTargetAnimal = true;
                this.playerdistance = 3;
                if (DistanceController.PlayerTargetAnimalDistance(_arg1, playerdistance)){
                    if (((DistanceController.PlayerTarAnimalRealyDistance(_arg1, playerdistance)) || ((GameCommonData.Player.IsMoving == false)))){
                        GameCommonData.Player.Stop();
                        if (GameCommonData.Player.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK){
                            GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                        };
                        if (_arg1.Role.Type == GameRole.TYPE_NPC){
                            UIFacade.GetInstance().sendNotification(EventList.SELECTED_NPC_ELEMENT, {npcId:GameCommonData.targetID});
                        } else {
                            if (_arg1.Role.Type == GameRole.TYPE_COLLECT){
                                UIFacade.GetInstance().sendNotification(PlayerInfoComList.START_COLLECT, GameCommonData.TargetAnimal);
                            };
                        };
                        _local3 = false;
                        this.ResetMoveState();
                        this.PetResetMoveState();
                    };
                } else {
                    _local4 = new Point(_arg1.GameX, _arg1.GameY);
                    _local3 = true;
                };
            } else {
                CloseNPCDialog();
            };
            if (IsPlayerWalk() == false){
                _local3 = false;
            };
            if (_local3){
                GameCommonData.TargetScene = "";
                UIFacade.GetInstance().changePath();
                PlayerMove(_local4);
            };
        }
        public function ClearElementData():void{
            var _local1:GameElementAnimal;
            SpeciallyEffectController.getInstance().ClearFloorEffect();
            GameCommonData.TargetAnimal = null;
            GameCommonData.AttackAnimal = null;
            SpeciallyEffectController.getInstance().SetTargetLight(null);
            if (!MapManager.IsInTower()){
                PlayerController.EndAutomatism();
            };
            GameCommonData.Player.prepPoint = null;
            GameCommonData.Player.Role.ArenaTeamId = 0;
            GameCommonData.Player.Role.PkTime = 0;
            GameCommonData.Player.handler = null;
            GameCommonData.IsMoveTargetAnimal = false;
            GameCommonData.PetTargetAnimal = null;
            GameCommonData.Player.Role.FightState = 0;
            GameCommonData.PackageList = new Dictionary();
            UIFacade.GetInstance().sendNotification(ArenaEvent.CLOSE_BOSS_HURT_VIEW);
            AutoFbManager.instance().reset();
            if (GameCommonData.SameSecnePlayerList){
                for each (_local1 in GameCommonData.SameSecnePlayerList) {
                    _local1.AllDispose();
                };
            };
            GameCommonData.SameSecnePlayerList = new Dictionary();
            ScenePlayerCount = 0;
            ClearSkill();
            BeforeTargetPoint = null;
            NextPoint = null;
            this.ResetMoveState();
            this.PetResetMoveState();
        }
        public function SetCanController():void{
            this.IsCanController = true;
        }
        public function Attack(_arg1:GameElementAnimal, _arg2:int=0):void{
            var _local3:SkillInfo;
            var _local4:Boolean;
            var _local5:Point = new Point();
            if (GameCommonData.Player.IsRushing == true){
                return;
            };
            if (_arg2 != 0){
                _local3 = (GameCommonData.SkillList[_arg2] as SkillInfo);
            };
            if (((((!((_arg1 == null))) && ((GameCommonData.Player.Role.HP > 0)))) && (!((GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                if (PlayerController.IsUseSkill(GameCommonData.Player, _arg1, _local3)){
                    GameCommonData.AttackAnimal = _arg1;
                    GameCommonData.IsMoveTargetAnimal = true;
                    CloseNPCDialog();
                    if (_arg2 == 0){
                        _local3 = SkillManager.GetDefaultSkill(GameCommonData.Player);
                    } else {
                        _local3 = (GameCommonData.SkillList[_arg2] as SkillInfo);
                    };
                    GameCommonData.Player.Role.DefaultSkill = _arg2;
                    this.playerdistance = _local3.Distance;
                    if (((DistanceController.PlayerTargetAnimalDistance(_arg1, playerdistance)) && (((DistanceController.PlayerTarAnimalRealyDistance(_arg1, playerdistance)) || ((GameCommonData.Player.IsMoving == false)))))){
                        GameCommonData.Player.Stop();
                        if (GameCommonData.Player.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK){
                            GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                        };
                        UseSkill(_arg1);
                        trace("useskill*");
                        _local4 = false;
                        this.ResetMoveState();
                        this.PetResetMoveState();
                    } else {
                        _local5 = MapTileModel.GetTilePointToStage(_arg1.Role.TileX, _arg1.Role.TileY);
                        _local4 = true;
                    };
                };
            } else {
                CloseNPCDialog();
            };
            if (IsPlayerWalk() == false){
                _local4 = false;
            };
            if (_local4){
                GameCommonData.TargetScene = "";
                UIFacade.GetInstance().changePath();
                PlayerMove(_local5);
            };
        }
        public function PlayerMove(_arg1:Point):void{
            var _local3:IMediator;
            var _local4:Boolean;
            var _local5:Point;
            if (GameCommonData.Player.Role.CanMove != true){
                UIFacade.UIFacadeInstance.ShowHint(LanguageMgr.GetTranslation("中了状态无法移动"));
                return;
            };
            if (perPoint == _arg1){
                return;
            };
            if (GameCommonData.IsInCrossServer){
                _local3 = UIFacade.UIFacadeInstance.retrieveMediator("CSBattleMediator");
                _local4 = _local3["isCanWalk"];
                if (!_local4){
                    _local5 = MapTileModel.GetTileStageToPoint(_arg1.x, _arg1.y);
                    if ((((_local5.y > 22)) && ((_local5.y < 46)))){
                        MessageTip.show(LanguageMgr.GetTranslation("跨服战中移动提示"));
                        return;
                    };
                };
            };
            perPoint = _arg1;
            PlayerActionSend.PlayerAttackStop();
            var _local2:Point = _arg1.clone();
            if (GameCommonData.Player.PathDirection){
                if (GameCommonData.Player.PathDirection.length == 0){
                    if (GameCommonData.Player.IsMoving == false){
                        GameCommonData.Player.PathDirection = null;
                        GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                    };
                };
            };
            if ((((((GameCommonData.Player.PathDirection == null)) || ((GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_STATIC)))) || ((GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_AFTER)))){
                this.ResetMoveState();
                this.PetResetMoveState();
                GameCommonData.Player.Move(_local2, playerdistance);
            } else {
                if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_STATIC){
                    this.ResetMoveState();
                    this.PetResetMoveState();
                    GameCommonData.Player.Move(_local2, playerdistance);
                } else {
                    NextPoint = _arg1;
                };
            };
        }
        public function onMoveNode(_arg1:int):Boolean{
            var _local2:Point;
            var _local3:int;
            var _local4:int;
            var _local5:Point;
            if ((this.moveStepCount % 2) == 0){
                if (GameCommonData.Player.Role.UsingPetAnimal != null){
                    if (!DistanceController.PlayerPetDistance(10)){
                        GameCommonData.Player.Role.UsingPetAnimal.DistanceMaster(GameCommonData.Player);
                    };
                };
                if (this.NextPoint != null){
                    _local2 = this.NextPoint.clone();
                    this.ResetMoveState();
                    this.PetResetMoveState();
                    GameCommonData.Player.Stop();
                    GameCommonData.Player.Move(_local2, playerdistance);
                    return (false);
                };
                if (((!((GameCommonData.Player.PathDirection == null))) && (this.IsSceneLoaded))){
                    _local3 = GameCommonData.Player.PathDirection.shift();
                    _local4 = 0;
                    if (GameCommonData.Player.PathDirection.length != 0){
                        _local4 = GameCommonData.Player.PathDirection.shift();
                    };
                    _local5 = MapTileModel.GetNextPos(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, _local3);
                    if (_local4 > 0){
                        _local5 = MapTileModel.GetNextPos(_local5.x, _local5.y, _local4);
                    };
                    PlayerActionSend.PlayerWalk(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, ((_local4 > 0)) ? (_local4 + (_local3 * 10)) : _local3);
                    GameCommonData.Player.Role.TileX = _local5.x;
                    GameCommonData.Player.Role.TileY = _local5.y;
                };
            };
            this.moveStepCount++;
            if (AutoFbManager.IsAutoFbing){
                TargetController.GetTargetDistance(2);
            };
            PlayerController.RefreshMediState();
            if (GameCommonData.Player.PathMap.length > 0){
                GameCommonData.Player.PathMap.shift();
                UIFacade.GetInstance().changePath(2);
            };
            this.gameScenePlay.Background.LoadMap();
            return (true);
        }
        public function DeletePackage(_arg1:Object):void{
            if (GameCommonData.PackageList[_arg1] != null){
                if (GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.contains(GameCommonData.PackageList[_arg1])){
                    GameCommonData.GameInstance.GameScene.GetGameScene.BottomLayer.removeChild(GameCommonData.PackageList[_arg1]);
                    UIFacade.GetInstance().DeletePackage((_arg1 as uint));
                };
                delete GameCommonData.PackageList[_arg1];
            };
        }
        public function onPlayMoveComplete():void{
            var _local1:Point;
            var _local2:int;
            if (judgeStoryDisplay(0)){
                return;
            };
            if (this.NextPoint != null){
                _local1 = this.NextPoint.clone();
                this.ResetMoveState();
                this.PetResetMoveState();
                if (((!((perPoint.x == _local1.x))) && (!((perPoint.y == _local1.y))))){
                    GameCommonData.Player.Move(_local1, playerdistance);
                    return;
                };
            };
            if (GameCommonData.TargetScene == GameCommonData.GameInstance.GameScene.GetGameScene.name){
                GameCommonData.TargetScene = "";
            };
            if (((GameCommonData.isAutoPath) && ((GameCommonData.TargetScene == "")))){
                UIFacade.GetInstance().changeNpcWin(1);
                GameCommonData.isAutoPath = false;
            };
            DestinationCursor.getInstance().hide();
            if (GameCommonData.TargetPickItem){
                if (DistanceController.AnimalTargetDistance(GameCommonData.Player, new Point(GameCommonData.TargetPickItem.target.TileX, GameCommonData.TargetPickItem.target.TileY), 7)){
                    GameCommonData.UIFacadeIntance.PickItem(GameCommonData.TargetPickItem);
                    GameCommonData.TargetPickItem = null;
                    if (((GameCommonData.Player.IsAutomatism) || (AutoFbManager.IsAutoFbing))){
                        AutomatismController.FindPickItem(true);
                    } else {
                        AutomatismController.FindPickItem(false);
                    };
                };
            } else {
                if (GameCommonData.RectSkillID > 0){
                    if (GameCommonData.Rect == null){
                        PlayerController.PlayerUseSkill(GameCommonData.SkillList[GameCommonData.RectSkillID], GameCommonData.RectSkillPos);
                        GameCommonData.RectSkillID = 0;
                        GameCommonData.RectSkillPos = null;
                    };
                } else {
                    if (((((!((GameCommonData.AttackAnimal == null))) && (PlayerController.IsUseSkill(GameCommonData.Player, GameCommonData.AttackAnimal)))) && ((GameCommonData.IsMoveTargetAnimal == true)))){
                        Attack(GameCommonData.AttackAnimal, GameCommonData.Player.Role.DefaultSkill);
                    } else {
                        this.ResetMoveState();
                    };
                };
            };
            if (((GameCommonData.TargetAnimal) && ((GameCommonData.IsMoveTargetAnimal == true)))){
                if (GameCommonData.TargetAnimal.Role.Type == GameRole.TYPE_NPC){
                    _local2 = Vector2.DirectionByTan(GameCommonData.TargetAnimal.GameX, GameCommonData.TargetAnimal.GameY, GameCommonData.Player.GameX, GameCommonData.Player.GameY);
                    if (GameCommonData.TargetAnimal.Role.IsTurn){
                        GameCommonData.TargetAnimal.SetDirection(_local2);
                    };
                    GameCommonData.Player.SetDirection(Vector2.OppositeDirection(_local2));
                    UIFacade.GetInstance().changeNpcWin(1, GameCommonData.TargetAnimal.Role.Id);
                } else {
                    if (GameCommonData.TargetAnimal.Role.Type == GameRole.TYPE_COLLECT){
                        HelloNPC(GameCommonData.TargetAnimal);
                    };
                };
            };
            UIFacade.GetInstance().changePath();
            this.gameScenePlay.IsUpdateNicety = true;
            if (((AutoFbManager.IsAutoFbing) || (GameCommonData.Player.IsAutomatism))){
                if (AutomatismController.IsPicking == false){
                    clearTimeout(AutomatismController.ClearNum);
                    PlayerController.BeginAutomatism();
                };
            };
            doGuide();
        }

    }
}//package Manager 
