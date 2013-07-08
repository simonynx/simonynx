//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import OopsFramework.Debug.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.Modules.Roll.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.TreasureChests.Data.*;
    import GameUI.Modules.Pk.Data.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Relive.Data.*;
    import GameUI.Modules.TreasureChests.View.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.WineParty.Data.*;
    import GameUI.Modules.Arena.Data.*;
    import GameUI.Modules.QuickBuy.Command.*;

    public class PlayerAction extends GameAction {

        private static const DUEL_REQUEST_FARAWAYFROMTARGET:int = 6;
        private static const DUEL_REQUEST_TARGETNOTEXIST:int = 3;
        private static const TRANSMIT_NO_PROP:int = 3;
        private static const SERVER_MSG_CYCLE_MESSAGE = 2;
        private static const SERVER_MSG_GLOBAL_NOTICE = 6;
        private static const GAME_SPEICAL_EFFECT_TYPE_GUID = 0;
        private static const DUEL_REQUEST_HASINVITED:int = 7;
        private static const SERVER_MSG_SHUTDOWN_CANCELLED = 4;
        private static const DUEL_REQUEST_TARGETREJECT:int = 9;
        private static const TRANSFER_ERROR_PLAYERLIMIT:int = 5;
        private static const SERVER_MSG_CHATTIPS = 5;
        private static const GAME_SPEICAL_EFFECT_TYPE_SCREEN_CENTER = 1;
        private static const DUEL_REQUEST_TARGETBADSTATE:int = 8;
        private static const SERVER_MSG_SHUTDOWN_TIME = 1;
        private static const DUEL_REQUEST_TARGETROOKIE:int = 4;
        private static const GAME_SPEICAL_EFFECT_TYPE_POSITION = 2;
        private static const DUEL_REQUEST_TARGETDUELING:int = 5;
        private static const SERVER_MSG_POPUPSTRING = 3;
        private static const TRANSMIT_OK:int = 0;
        private static const DUEL_REQUEST_SUCCESS:int = 0;
        private static const TRANSMIT_POS_ERROR:int = 1;
        private static const TRANSMIT_MAP_ERROR:int = 2;
        private static const TRANSMIT_ERROR_LINE:int = 6;
        private static const DUEL_REQUEST_BADSTATE:int = 2;
        private static const DUEL_REQUEST_WRONGSCENE:int = 1;
        private static const TRANSMIT_NO_OPEN:int = 4;

        private static var instance:PlayerAction;
        public static var IsFirstGet:Boolean = true;

        public function PlayerAction(_arg1:Boolean=true){
            super(_arg1);
            if (instance != null){
                throw (new Error("单体出错"));
            };
        }
        public static function getInstance():PlayerAction{
            if (!PlayerAction.instance){
                PlayerAction.instance = new (PlayerAction)();
            };
            return (PlayerAction.instance);
        }

        private function handlerTheArena(_arg1:NetPacket):void{
            var _local4:int;
            var _local5:int;
            var _local6:ArenaNpcInfo;
            var _local7:ArenaInfo;
            var _local8:Array;
            var _local2:int = _arg1.readByte();
            var _local3:int;
            switch (_local2){
                case 0:
                    _local5 = 2;
                    while (_local3 < _local5) {
                        _local6 = new ArenaNpcInfo();
                        _local6.team = _local3;
                        _local6.npcBlood = _arg1.readUnsignedInt();
                        _local6.npcMaxBlood = _arg1.readUnsignedInt();
                        _local6.info0.name = _arg1.ReadString();
                        _local6.info0.level = _arg1.readUnsignedInt();
                        _local6.info0.jobName = _arg1.readUnsignedInt();
                        _local6.info0.count = _arg1.readUnsignedInt();
                        _local6.info1.name = _arg1.ReadString();
                        _local6.info1.level = _arg1.readUnsignedInt();
                        _local6.info1.jobName = _arg1.readUnsignedInt();
                        _local6.info1.count = _arg1.readUnsignedInt();
                        _local6.info2.name = _arg1.ReadString();
                        _local6.info2.level = _arg1.readUnsignedInt();
                        _local6.info2.jobName = _arg1.readUnsignedInt();
                        _local6.info2.count = _arg1.readUnsignedInt();
                        ArenaNpcInfo.dic[_local6.team] = _local6;
                        _local3++;
                    };
                    sendNotification(ArenaEvent.UPDATE_ARENA_INFO);
                    break;
                case 1:
                    break;
                case 2:
                    break;
                case 4:
                    ArenaInfo.winTeam = _arg1.readUnsignedInt();
                    _local4 = _arg1.readUnsignedInt();
                    _local3 = 0;
                    _local8 = [];
                    while (_local3 < _local4) {
                        _local7 = new ArenaInfo();
                        _local7.team = 0;
                        _local7.name = _arg1.ReadString();
                        _local7.level = _arg1.readUnsignedInt();
                        _local7.jobName = _arg1.readUnsignedInt();
                        _local7.sociaty = _arg1.ReadString();
                        _local7.killCount = _arg1.readUnsignedInt();
                        _local7.count = _arg1.readUnsignedInt();
                        _local8.push(_local7);
                        _local3++;
                    };
                    _local4 = _arg1.readUnsignedInt();
                    _local3 = 0;
                    while (_local3 < _local4) {
                        _local7 = new ArenaInfo();
                        _local7.team = 1;
                        _local7.name = _arg1.ReadString();
                        _local7.level = _arg1.readUnsignedInt();
                        _local7.jobName = _arg1.readUnsignedInt();
                        _local7.sociaty = _arg1.ReadString();
                        _local7.killCount = _arg1.readUnsignedInt();
                        _local7.count = _arg1.readUnsignedInt();
                        _local8.push(_local7);
                        _local3++;
                    };
                    sendNotification(ArenaEvent.SETUP_ALL_PERSON_INFO, _local8);
                    break;
            };
        }
        private function handlerSelfArena(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local2:int = _arg1.readByte();
            switch (_local2){
                case 0:
                    ArenaInfo.SelfArenaInfo.killCount = _arg1.readUnsignedInt();
                    ArenaInfo.SelfArenaInfo.count = _arg1.readUnsignedInt();
                    ArenaInfo.SelfArenaInfo.lianxuKill = _arg1.readUnsignedInt();
                    sendNotification(ArenaEvent.UPDATE_ARENA_SELF);
                    break;
                case 1:
                    ArenaInfo.SelfArenaInfo.count = _arg1.readUnsignedInt();
                    ArenaInfo.SelfArenaInfo.winCount = _arg1.readUnsignedInt();
                    ArenaInfo.SelfArenaInfo.isActive = _arg1.readBoolean();
                    ArenaInfo.SelfArenaInfo.exp = _arg1.readUnsignedInt();
                    ArenaInfo.SelfArenaInfo.todayCount = _arg1.readUnsignedInt();
                    trace(ArenaInfo.SelfArenaInfo.todayCount);
                    ArenaInfo.SelfArenaInfo.totalCount = _arg1.readUnsignedInt();
                    _local3 = 0;
                    _local4 = _arg1.readUnsignedInt();
                    while (_local3 < _local4) {
                        _local5 = _arg1.readUnsignedInt();
                        if (ArenaInfo.KillOrBeKillList[_local5] == null){
                            ArenaInfo.KillOrBeKillList[_local5] = new ArenaInfo();
                        };
                        ArenaInfo.KillOrBeKillList[_local5].killThisCount = _arg1.readUnsignedInt();
                        _local3++;
                    };
                    _local3 = 0;
                    _local4 = _arg1.readUnsignedInt();
                    while (_local3 < _local4) {
                        _local5 = _arg1.readUnsignedInt();
                        if (ArenaInfo.KillOrBeKillList[_local5] == null){
                            ArenaInfo.KillOrBeKillList[_local5] = new ArenaInfo();
                        };
                        ArenaInfo.KillOrBeKillList[_local5].beKilledCount = _arg1.readUnsignedInt();
                        _local3++;
                    };
                    sendNotification(ArenaEvent.SHOW_ARENA);
                    break;
            };
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local2:String;
            var _local3:int;
            var _local4:int;
            var _local5:*;
            var _local6:uint;
            var _local7:int;
            var _local8:int;
            var _local9:Boolean;
            var _local10:int;
            var _local11:Object;
            var _local12:uint;
            var _local13:int;
            var _local14:int;
            var _local15:GameElementPlayer;
            var _local16:Array;
            var _local17:Array;
            var _local18:int;
            var _local19:int;
            var _local20:int;
            var _local21:int;
            var _local22:int;
            var _local23:int;
            var _local24:int;
            var _local25:int;
            var _local26:int;
            var _local27:int;
            var _local28:int;
            var _local29:String;
            var _local30:NewInfoTipVo;
            var _local31:int;
            var _local32:int;
            var _local33:int;
            var _local34:String;
            var _local35:String;
            var _local36:String;
            var _local37:Boolean;
            var _local38:int;
            var _local39:TowerRankInfo;
            var _local40:int;
            var _local41:int;
            var _local42:int;
            var _local43:Boolean;
            var _local44:uint;
            var _local45:RollInfo;
            var _local46:uint;
            var _local47:int;
            var _local48:int;
            var _local49:String;
            var _local50:int;
            var _local51:int;
            var _local52:int;
            var _local53:int;
            var _local54:Point;
            var _local55:String;
            var _local56:int;
            var _local57:int;
            var _local58:String;
            var _local59:int;
            var _local60:int;
            var _local61:int;
            var _local62:Array;
            var _local63:Array;
            var _local64:int;
            var _local65:Boolean;
            var _local66:int;
            var _local67:int;
            var _local68:String;
            var _local69:GuardInfo;
            var _local70:uint;
            var _local71:int;
            var _local72:int;
            var _local73:int;
            var _local74:Array;
            var _local75:uint;
            var _local76:String;
            var _local77:int;
            var _local78:int;
            var _local79:int;
            var _local80:int;
            var _local81:GameElementAnimal;
            var _local82:Point;
            var _local83:int;
            var _local84:int;
            switch (_arg1.opcode){
                case Protocol.SMSG_TRANSFERSCENERESULT:
                    _local3 = _arg1.readUnsignedInt();
                    switch (_local3){
                        case TRANSMIT_OK:
                            GameCommonData.Player.Role.TileX = _arg1.readUnsignedShort();
                            GameCommonData.Player.Role.TileY = _arg1.readUnsignedShort();
                            _local2 = _arg1.readUnsignedInt().toString();
                            GameCommonData.Scene.TransferScene(_local2, _local2);
                            UIFacade.GetInstance().sendNotification(EventList.MANAGER_BIBLE_ICON);
                            break;
                        case TRANSMIT_POS_ERROR:
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:new Function(),
                                info:LanguageMgr.GetTranslation("你当前坐标无法传送")
                            });
                            break;
                        case TRANSMIT_MAP_ERROR:
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:new Function(),
                                info:LanguageMgr.GetTranslation("目的地无法到达")
                            });
                            break;
                        case TRANSMIT_NO_PROP:
                            UIFacade.GetInstance().sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:50100002});
                            break;
                        case TRANSMIT_NO_OPEN:
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:new Function(),
                                info:LanguageMgr.GetTranslation("等级限制")
                            });
                            break;
                        case TRANSFER_ERROR_PLAYERLIMIT:
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:new Function(),
                                info:LanguageMgr.GetTranslation("人数限制")
                            });
                            break;
                        case TRANSMIT_ERROR_LINE:
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:new Function(),
                                info:LanguageMgr.GetTranslation("目标地图不在本线开放")
                            });
                            break;
                    };
                    break;
                case Protocol.SMSG_ATTACK_STOP:
                    _local4 = _arg1.readUnsignedInt();
                    sendNotification(EventList.ATTACK_STOP);
                    GameCommonData.IsInCombat = false;
                    break;
                case Protocol.SMSG_ATTACK_START:
                    _local4 = _arg1.readUnsignedInt();
                    _local5 = _arg1.readUnsignedInt();
                    if (_local4 == GameCommonData.Player.Role.Id){
                        sendNotification(EventList.ATTACK_START);
                        GameCommonData.IsInCombat = true;
                    };
                    break;
                case Protocol.SMSG_PLAYER_RESPAWN:
                    _local4 = _arg1.readUnsignedInt();
                    _local6 = _arg1.readUnsignedInt();
                    if (_local4 == GameCommonData.Player.Role.Id){
                        GameCommonData.Player.Role.HP = _local6;
                        UIFacade.UIFacadeInstance.removeRelive();
                        GameCommonData.Player.SetAction(GameElementSkins.ACTION_STATIC);
                        GameCommonData.TargetScene = "";
                        GameCommonData.Scene.AddPlayer(GameCommonData.Player);
                        if (GameCommonData.lastPlayPetIdx > -1){
                            PetSend.Out(GameCommonData.lastPlayPetIdx);
                        };
                    };
                    if (GameCommonData.SameSecnePlayerList[_local4] != null){
                        GameCommonData.SameSecnePlayerList[_local4].Role.HP = _local6;
                        GameCommonData.SameSecnePlayerList[_local4].SetAction(GameElementSkins.ACTION_STATIC);
                        GameCommonData.Scene.AddPlayer(GameCommonData.SameSecnePlayerList[_local4]);
                        if (((!((GameCommonData.TargetAnimal == null))) && ((GameCommonData.TargetAnimal.Role.Id == GameCommonData.SameSecnePlayerList[_local4].Role.Id)))){
                            GameCommonData.TargetAnimal.IsSelect(true);
                        };
                    };
                    break;
                case Protocol.SMSG_SERVER_MESSAGE:
                    HandleServerMsg(_arg1);
                    break;
                case Protocol.SMSG_CAST_SPELL_FAILED:
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readByte();
                    switch (_local8){
                        case 8:
                            GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("目标不正确"),
                                color:0xFFFF00
                            });
                            break;
                        case 14:
                            MessageTip.show(LanguageMgr.GetTranslation("技能cd中"));
                            break;
                        case 15:
                            GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("技能cd冷却中"),
                                color:0xFFFF00
                            });
                            break;
                        case 55:
                            GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("魔法值不足"),
                                color:0xFFFF00
                            });
                            break;
                        case 56:
                            MessageTip.show(LanguageMgr.GetTranslation("缺少抓捕道具"));
                            break;
                    };
                    break;
                case Protocol.SMSG_SET_PK_MODE:
                    _local9 = _arg1.readBoolean();
                    _local10 = _arg1.readByte();
                    _local11 = new Object();
                    _local11.type = _local10;
                    _local11.value = _local9;
                    facade.sendNotification(PkEvent.UPDATEDATA, _local11);
                    break;
                case Protocol.SMSG_PLAYER_TELEPORT:
                    _local12 = _arg1.readUnsignedInt();
                    _local13 = _arg1.readShort();
                    _local14 = _arg1.readShort();
                    if (_local12 == GameCommonData.Player.Role.Id){
                        _local15 = GameCommonData.Player;
                    } else {
                        _local15 = GameCommonData.SameSecnePlayerList[_local12];
                    };
                    if (_local15){
                        _local15.Stop();
                        _local15.SetAction(GameElementSkins.ACTION_STATIC);
                        _local54 = MapTileModel.GetTilePointToStage(_local13, _local14);
                        _local15.Role.TileX = _local13;
                        _local15.Role.TileY = _local14;
                        _local15.X = _local54.x;
                        _local15.Y = _local54.y;
                        GameCommonData.NoMovePlayerId = _local12;
                        if (_local15.Role.UsingPetAnimal){
                            PetController.getInstance().ResetPetPos(_local15.Role.UsingPetAnimal);
                        };
                    };
                    break;
                case Protocol.SMSG_ONLINEREWARD_NOTICE:
                    _local16 = [];
                    _local17 = [];
                    _local20 = _arg1.readUnsignedInt();
                    if (_local20 == 0){
                        UIFacade.GetInstance().sendNotification(TreasureEvent.ALL_TREASURE_GET);
                        return;
                    };
                    if (_local20 == 3){
                        if (TreasureChestView.AwardMsg != ""){
                            _local55 = ((LanguageMgr.GetTranslation("恭喜你成功领取") + ":") + TreasureChestView.AwardMsg);
                            SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "rewardSound");
                            sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local55);
                            TreasureChestView.AwardMsg = "";
                        };
                        MessageTip.show(LanguageMgr.GetTranslation("本日在线礼物领取完毕"));
                        UIFacade.GetInstance().sendNotification(TreasureEvent.ALL_TREASURE_GET);
                        return;
                    };
                    _local21 = _arg1.readUnsignedInt();
                    _local22 = _arg1.readUnsignedInt();
                    if (!IsFirstGet){
                        if (TreasureChestView.AwardMsg != ""){
                            _local55 = ((LanguageMgr.GetTranslation("恭喜你成功领取") + ":") + TreasureChestView.AwardMsg);
                            sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local55);
                            TreasureChestView.AwardMsg = "";
                        };
                        MessageTip.show(LanguageMgr.GetTranslation("成功离去后等下份礼物"));
                    } else {
                        IsFirstGet = false;
                    };
                    while (_local18 < 5) {
                        _local4 = _arg1.readUnsignedInt();
                        if (_local4 != 0){
                            _local16.push(_local4);
                        };
                        _local18++;
                    };
                    _local18 = 0;
                    while (_local18 < 5) {
                        _local19 = _arg1.readUnsignedInt();
                        if (_local19 != 0){
                            _local17.push(_local19);
                        };
                        _local18++;
                    };
                    _local23 = _arg1.readUnsignedInt();
                    _local24 = _arg1.readUnsignedInt();
                    UIFacade.GetInstance().sendNotification(TreasureEvent.NEW_TREASURE, {
                        idArray:_local16,
                        countArray:_local17,
                        time:_local22,
                        getType:_local20
                    });
                    break;
                case Protocol.SMSG_RELIVE_SPELL_CAST:
                    _local25 = _arg1.readUnsignedInt();
                    _local26 = _arg1.readUnsignedInt();
                    sendNotification(ReliveEvent.SHOWSKILL_RELIVE, {
                        Id:_local25,
                        lev:_local26
                    });
                    break;
                case Protocol.SMSG_MONSTER_LEFT:
                    _local19 = _arg1.readUnsignedInt();
                    if (_local19 == -1){
                        sendNotification(TranscriptEvent.CLOSE_TRANSCRIPT_VIEW);
                    } else {
                        sendNotification(TranscriptEvent.SHOW_ENEMY_INFO, _local19);
                    };
                    break;
                case Protocol.SMSG_UNDERCITY_STATE:
                    _local11 = new Object();
                    _local11.targetInfo = _arg1.ReadString();
                    _local11.totalLayer = _arg1.readInt();
                    _local11.currentLayer = _arg1.readInt();
                    _local11.totalMonster = _arg1.readInt();
                    _local11.rate = _arg1.readInt();
                    _local11.timerCount = _arg1.readInt();
                    sendNotification(TranscriptEvent.SHOW_TARGET_RATE, _local11);
                    break;
                case Protocol.SMSG_DUEL_REQUEST_RESPONSE:
                    _local27 = _arg1.readByte();
                    switch (_local27){
                        case DUEL_REQUEST_SUCCESS:
                            MessageTip.show(LanguageMgr.GetTranslation("邀请成功,等待回应"));
                            break;
                        case DUEL_REQUEST_WRONGSCENE:
                            MessageTip.show(LanguageMgr.GetTranslation("场景不对不能邀请切磋"));
                            break;
                        case DUEL_REQUEST_BADSTATE:
                            MessageTip.show(LanguageMgr.GetTranslation("摆摊或交易时不能发出申请"));
                            break;
                        case DUEL_REQUEST_TARGETNOTEXIST:
                            MessageTip.show(LanguageMgr.GetTranslation("目标玩家不在线或不在本场景"));
                            break;
                        case DUEL_REQUEST_TARGETROOKIE:
                            MessageTip.show(LanguageMgr.GetTranslation("新手无法接受切磋邀请"));
                            break;
                        case DUEL_REQUEST_TARGETDUELING:
                            MessageTip.show(LanguageMgr.GetTranslation("对方正在切磋无法邀请"));
                            break;
                        case DUEL_REQUEST_FARAWAYFROMTARGET:
                            MessageTip.show(LanguageMgr.GetTranslation("与邀请目标距离过远"));
                            break;
                        case DUEL_REQUEST_HASINVITED:
                            MessageTip.show(LanguageMgr.GetTranslation("已经邀请过该玩家"));
                            break;
                        case DUEL_REQUEST_HASINVITED:
                            MessageTip.show(LanguageMgr.GetTranslation("对方因xx无法接受邀请"));
                            break;
                        case DUEL_REQUEST_TARGETREJECT:
                            MessageTip.show(LanguageMgr.GetTranslation("对方拒绝了你的邀请"));
                            break;
                    };
                    break;
                case Protocol.SMSG_DUEL_INVITE:
                    _local28 = _arg1.readUnsignedInt();
                    _local29 = _arg1.ReadString();
                    _local30 = new NewInfoTipVo();
                    _local30.title = (_local29 + LanguageMgr.GetTranslation("邀请你切磋"));
                    _local30.type = NewInfoTipType.TYPE_DUEL;
                    _local30.data = _local28;
                    sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local30);
                    break;
                case Protocol.SMSG_DUEL_DOUNTDOWN:
                    _local31 = _arg1.readUnsignedInt();
                    _local32 = _arg1.readUnsignedInt();
                    _local33 = _arg1.readUnsignedInt();
                    if (_local31 == GameCommonData.Player.Role.Id){
                        if (GameCommonData.SameSecnePlayerList[_local32]){
                            GameCommonData.DuelAnimal = GameCommonData.SameSecnePlayerList[_local32];
                        };
                    } else {
                        if (_local32 == GameCommonData.Player.Role.Id){
                            if (GameCommonData.SameSecnePlayerList[_local31]){
                                GameCommonData.DuelAnimal = GameCommonData.SameSecnePlayerList[_local31];
                            };
                        };
                    };
                    _local33 = (_local33 / 1000);
                    DuelController.BeginDuel(_local33);
                    MessageTip.show((_local33 + LanguageMgr.GetTranslation("x秒后开始切磋")));
                    break;
                case Protocol.SMSG_DUEL_RESULT:
                    _local20 = _arg1.readByte();
                    _local35 = _arg1.ReadString();
                    _local36 = _arg1.ReadString();
                    if (_local20 == 0){
                        _local34 = ((((((("<font color ='#ff0000'>" + _local35) + "</font>") + LanguageMgr.GetTranslation("将")) + "<font color ='#eeeee'>") + _local36) + "</font>") + LanguageMgr.GetTranslation("将x击败了后表扬句"));
                    } else {
                        _local34 = ((((((("<font color ='#ff0000'>" + _local35) + "</font>") + LanguageMgr.GetTranslation("x亮出臂上的五道杠")) + "<font color ='#999999'>") + _local36) + "</font>") + LanguageMgr.GetTranslation("y落荒而逃不战而败"));
                    };
                    sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, _local34);
                    if (_local35 == GameCommonData.Player.Role.Name){
                        DuelController.DuelWin();
                    } else {
                        if (_local36 == GameCommonData.Player.Role.Name){
                            DuelController.DuelLost();
                        };
                    };
                    break;
                case Protocol.SMSG_TOWER_GOTO_NEXT_LAYER:
                    _local4 = _arg1.readUnsignedInt();
                    sendNotification(TranscriptEvent.SHOW_HOLE_VIEW, _local4);
                    NPCExchangeConstData.goodList[NPCExchangeConstData.towerMosterID] = null;
                    break;
                case Protocol.SMSG_TOWER_JUMP_REPLY:
                    GameCommonData.TowerFlyRemainCnt = _arg1.readUnsignedInt();
                    _local37 = _arg1.readBoolean();
                    if (_local37){
                        _local4 = _arg1.readUnsignedInt();
                        sendNotification(TranscriptEvent.JUMP_TOWER, _local4);
                    };
                    break;
                case Protocol.SMSG_TOWER_RANKING_LIST:
                    _local18 = 0;
                    _local38 = 3;
                    while (_local18 < _local38) {
                        _local39 = new TowerRankInfo();
                        _local39.id = _arg1.readUnsignedInt();
                        if (_local39.id != 0){
                            _local39.name = _arg1.ReadString();
                            _local39.faceId = _arg1.readUnsignedInt();
                            _local39.level = _arg1.readUnsignedInt();
                            _local39.towerMaxCount = _arg1.readUnsignedInt();
                        };
                        GameCommonData.TowerRankList[_local18] = _local39;
                        _local18++;
                    };
                    _local18 = 0;
                    _local38 = 15;
                    while (_local18 < _local38) {
                        TowerRankInfo.PassContList[_local18] = _arg1.readUnsignedInt();
                        _local18++;
                    };
                    TowerRankInfo.beforeYou = _arg1.readUnsignedInt();
                    TowerRankInfo.afterYou = _arg1.readUnsignedInt();
                    sendNotification(TranscriptEvent.UPDATE_TOWERVIEW);
                    break;
                case Protocol.SMSG_PARTY_CHEERS_REPLY:
                    _local40 = _arg1.readByte();
                    switch (_local40){
                        case 0:
                            MessageTip.show(LanguageMgr.GetTranslation("干杯成功"));
                            break;
                        case 1:
                            MessageTip.show(LanguageMgr.GetTranslation("目标玩家不存在"));
                            break;
                        case 2:
                            MessageTip.show(LanguageMgr.GetTranslation("与被邀请玩家距离太远"));
                            break;
                        case 3:
                            MessageTip.show(LanguageMgr.GetTranslation("没有酒杯"));
                            break;
                        case 4:
                            MessageTip.show(LanguageMgr.GetTranslation("使用了错误的敬酒道具"));
                            break;
                        case 5:
                            MessageTip.show(LanguageMgr.GetTranslation("你的干杯次数已经用尽"));
                            break;
                        case 6:
                            MessageTip.show(LanguageMgr.GetTranslation("对方干杯次数用完"));
                            break;
                        case 7:
                            MessageTip.show(LanguageMgr.GetTranslation("酒会未开始,无法干杯"));
                            break;
                        case 8:
                            MessageTip.show(LanguageMgr.GetTranslation("其他错误"));
                            break;
                    };
                    break;
                case Protocol.SMSG_PARTY_CHEERS_NOTICE:
                    _local41 = _arg1.readUnsignedByte();
                    if (_local41 == 0){
                        _local56 = _arg1.readUnsignedInt();
                        _local57 = _arg1.readUnsignedInt();
                        _local58 = _arg1.ReadString();
                        _local11 = {
                            a:_local56,
                            b:_local57,
                            name:_local58
                        };
                        sendNotification(WinPartEvent.SHOW_GLASS_EFFECT, _local11);
                    } else {
                        if (_local41 == 1){
                            GameCommonData.CanGetGlass = false;
                            facade.sendNotification(WinPartEvent.UPDATE_WINPARTBTNSVIEW);
                        } else {
                            if (_local41 == 2){
                                GameCommonData.CanWinpartExchange = false;
                                facade.sendNotification(WinPartEvent.UPDATE_WINPARTBTNSVIEW);
                            };
                        };
                    };
                    break;
                case Protocol.SMSG_GAME_FUNC_NOTICE:
                    _local42 = _arg1.readUnsignedInt();
                    _local43 = _arg1.readBoolean();
                    if (_local43){
                        _local59 = _arg1.readUnsignedInt();
                        _local60 = _arg1.readUnsignedInt();
                        _local19 = _arg1.readUnsignedInt();
                        _local18 = 0;
                        _local62 = [];
                        _local63 = [];
                        while (_local18 < _local19) {
                            _local4 = _arg1.readUnsignedInt();
                            _local61 = _arg1.readUnsignedInt();
                            _local62.push(_local4);
                            _local63.push(_local61);
                            _local18++;
                        };
                        if (_local42 == 0){
                            sendNotification(WinPartEvent.UPDATE_PARTY_VIEW, {
                                arr:_local62,
                                t:_local60,
                                arr1:_local63,
                                max:_local59
                            });
                        } else {
                            sendNotification(ArenaEvent.SHOW_ARENA_INVITE, {
                                arr:_local62,
                                t:_local60,
                                arr1:_local63,
                                max:_local59
                            });
                        };
                    } else {
                        if (_local42 == 0){
                            sendNotification(WinPartEvent.CLOSE_PARTY_VIEW);
                        } else {
                            if (_local42 == 1){
                                sendNotification(ArenaEvent.CLOSE_BTN);
                            };
                        };
                    };
                    break;
                case Protocol.SMSG_RELAX_ARENA_WHOLE_NOTICE:
                    handlerTheArena(_arg1);
                    break;
                case Protocol.SMSG_RELAX_ARENA_PERSONAL_NOTICE:
                    handlerSelfArena(_arg1);
                    break;
                case Protocol.SMSG_ROLL_ITEM_NOTICE:
                    _local20 = _arg1.readByte();
                    _local44 = _arg1.readUnsignedInt();
                    switch (_local20){
                        case 0:
                            _local19 = _arg1.readUnsignedInt();
                            while (_local18 < _local19) {
                                _local45 = new RollInfo();
                                _local45.index = ((_local44 * 100) + _local18);
                                _local45.itemId = _arg1.readUnsignedInt();
                                RollInfo.dic[_local45.index] = _local45;
                                _local18++;
                            };
                            sendNotification(RollEvent.SHOW_REWARD_VIEW, {guid:_local44});
                            break;
                        case 1:
                            _local64 = _arg1.readUnsignedInt();
                            _local64 = ((_local44 * 100) + _local64);
                            _local29 = _arg1.ReadString();
                            _local65 = _arg1.readBoolean();
                            sendNotification(RollEvent.SHOW_ROLL_STATE, {
                                index:_local64,
                                playerName:_local29,
                                isRoll:_local65
                            });
                            break;
                        case 2:
                            _local64 = _arg1.readUnsignedInt();
                            _local64 = ((_local44 * 100) + _local64);
                            _local66 = _arg1.readUnsignedInt();
                            while (_local18 < _local66) {
                                _local29 = _arg1.ReadString();
                                _local67 = _arg1.readUnsignedInt();
                                sendNotification(RollEvent.SHOW_ROLL_INFO, {
                                    index:_local64,
                                    playerName:_local29,
                                    rollNum:_local67
                                });
                                _local18++;
                            };
                            _local68 = _arg1.ReadString();
                            sendNotification(RollEvent.SHOW_WIN, {
                                index:_local64,
                                owerPlayerName:_local68
                            });
                            break;
                        case 3:
                            sendNotification(RollEvent.REMOVE_VIEW, {guid:_local44});
                            break;
                    };
                    break;
                case Protocol.SMSG_TOWER_GUARDIAN_NOTICE:
                    _local11 = {};
                    _local11.type = _arg1.readByte();
                    switch (_local11.type){
                        case 0:
                            _local66 = _arg1.readUnsignedInt();
                            GuardInfo.dic = new Dictionary();
                            GuardInfo.selfGuardInfo = null;
                            while (_local18 < _local66) {
                                _local69 = new GuardInfo();
                                _local69.layer = _arg1.readUnsignedInt();
                                _local69.playerId = _arg1.readUnsignedInt();
                                _local69.playerName = _arg1.ReadString();
                                _local69.level = _arg1.readUnsignedInt();
                                _local69.sex = _arg1.readUnsignedInt();
                                _local69.faceId = _arg1.readUnsignedInt();
                                if (_local69.playerId == GameCommonData.Player.Role.Id){
                                    _local69.guradTime = _arg1.readUnsignedInt();
                                    GuardInfo.selfGuardInfo = _local69;
                                };
                                GuardInfo.dic[_local69.layer] = _local69;
                                _local18++;
                            };
                            if (dataProxy.TowerViewIsOpen){
                                sendNotification(TranscriptEvent.SHOW_GUARD_INFO, _local11);
                            };
                            break;
                        case 1:
                            _local11.currentLayer = _arg1.readUnsignedInt();
                            _local11.yourLayer = _arg1.readUnsignedInt();
                            sendNotification(TranscriptEvent.SHOW_GUARD_INFO, _local11);
                            break;
                        case 2:
                            _local11.currentLayer = _arg1.readUnsignedInt();
                            _local11.level = _arg1.readUnsignedInt();
                            _local11.name = _arg1.ReadString();
                            _local11.guardLayer = _arg1.readUnsignedInt();
                            sendNotification(TranscriptEvent.SHOW_GUARD_INFO, _local11);
                            break;
                    };
                    break;
                case Protocol.SMSG_WORLD_BOSS_HURTVALUE_LIST:
                    _local11 = {};
                    _local11.playerNum = _arg1.readUnsignedInt();
                    while (_local18 < _local11.playerNum) {
                        _local11[("playerId" + _local18)] = _arg1.readUnsignedInt();
                        _local11[("name" + _local18)] = _arg1.ReadString();
                        _local11[("count" + _local18)] = _arg1.readUnsignedInt();
                        _local18++;
                    };
                    _local11.time = 5000;
                    sendNotification(ArenaEvent.SHOW_BOSS_HURT_VIEW, _local11);
                    break;
                case Protocol.SMSG_ARENA_DEATH_BATTLE_NOTICE:
                    arenaDieoutBallte(_arg1);
                    break;
                case Protocol.SMSG_INSTANCE_MENU:
                    _local46 = _arg1.readUnsignedInt();
                    switch (_local46){
                        case 4294967295:
                            sendNotification(ArenaEvent.CLOSE_HIGHLEVEL_ARENA_VIEW);
                            sendNotification(EventList.UPDATE_GUILD_FIGHT_PROCESS, {type:2});
                            if (dataProxy.TESLPanelIsOpen){
                                sendNotification(TranscriptEvent.CLOSE_TESL_VIEW);
                            };
                            break;
                        case 0:
                            _local70 = _arg1.readUnsignedInt();
                            GameCommonData.TranscriptFinish = true;
                            break;
                        case 1:
                            _local11 = {};
                            _local11.current_batch = _arg1.readUnsignedByte();
                            _local11.max_batch = _arg1.readUnsignedByte();
                            _local11.seed_count = _arg1.readUnsignedByte();
                            _local11.tree_count = _arg1.readUnsignedByte();
                            _local75 = 0;
                            while (_local75 < _local11.tree_count) {
                                _local11[("treename" + _local75)] = _arg1.ReadString();
                                _local11[("treestate" + _local75)] = _arg1.readUnsignedByte();
                                _local11[("seedtaken" + _local75)] = _arg1.readUnsignedByte();
                                _local11[("seedneed" + _local75)] = _arg1.readUnsignedByte();
                                _local11[("buttonenable" + _local75)] = _arg1.readBoolean();
                                _local75++;
                            };
                            sendNotification(ArenaEvent.SHOW_HIGHLEVEL_ARENA_VIEW, _local11);
                            break;
                        case 2:
                            _local20 = _arg1.readUnsignedInt();
                            if (_local20 == 0){
                                _local76 = _arg1.ReadString();
                                _local77 = _arg1.readUnsignedInt();
                                _local78 = _arg1.readUnsignedInt();
                                _local79 = _arg1.readUnsignedInt();
                                _local80 = _arg1.readUnsignedInt();
                                sendNotification(EventList.UPDATE_GUILD_FIGHT_PROCESS, {
                                    type:_local20,
                                    curDefGuildName:_local76,
                                    keepTime:_local77,
                                    selfKeepTime:_local78,
                                    overTime:_local80,
                                    state:_local79
                                });
                            } else {
                                if (_local20 == 1){
                                    _local76 = _arg1.ReadString();
                                    _local28 = _arg1.readUnsignedInt();
                                    sendNotification(EventList.UPDATE_GUILD_FIGHT_PROCESS, {
                                        type:_local20,
                                        curDefGuildName:_local76,
                                        playerId:_local28
                                    });
                                };
                            };
                            break;
                        case 3:
                            _local71 = _arg1.readUnsignedInt();
                            _local72 = _arg1.readUnsignedInt();
                            _local73 = _arg1.readUnsignedInt();
                            _local74 = [];
                            _local18 = 0;
                            while (_local18 < 7) {
                                _local74[_local18] = [_arg1.readUnsignedInt(), _arg1.readUnsignedInt()];
                                _local18++;
                            };
                            if (!dataProxy.TESLPanelIsOpen){
                                facade.sendNotification(TranscriptEvent.SHOW_TESL_VIEW);
                            };
                            facade.sendNotification(TranscriptEvent.TESL_UPDATEDATA, [_local71, _local72, _local73, _local74]);
                            break;
                    };
                    break;
                case Protocol.SMSG_LEAVE_CURRENT_WORLD:
                    GameCommonData.Scene.RemoveAllElementBefourLevelScene();
                    break;
                case Protocol.SMSG_PLAY_SIMPLE_SPEICAL_EFFECT:
                    _local47 = _arg1.readUnsignedInt();
                    _local48 = _arg1.readUnsignedInt();
                    _local49 = _arg1.ReadString();
                    _local50 = 0;
                    _local51 = 0;
                    _local52 = 0;
                    _local53 = 0;
                    switch (_local48){
                        case GAME_SPEICAL_EFFECT_TYPE_GUID:
                            _local50 = _arg1.readUnsignedInt();
                            if (_local50 == GameCommonData.Player.Role.Id){
                                _local81 = GameCommonData.Player;
                            } else {
                                _local81 = (GameCommonData.SameSecnePlayerList[_local50] as GameElementAnimal);
                            };
                            if (_local81){
                                _local82 = MapTileModel.GetTileStageToPoint(_local81.GameX, _local81.Y);
                                _local83 = _local82.x;
                                _local84 = _local82.y;
                                SpeciallyEffectController.getInstance().showSceneMovieEffect(_local49, 0, _local83, _local84);
                            };
                            break;
                        case GAME_SPEICAL_EFFECT_TYPE_SCREEN_CENTER:
                            break;
                        case GAME_SPEICAL_EFFECT_TYPE_POSITION:
                            _local51 = _arg1.readUnsignedInt();
                            _local52 = _arg1.readUnsignedInt();
                            _local53 = _arg1.readUnsignedInt();
                            SpeciallyEffectController.getInstance().showSceneMovieEffect(_local49, _local51, _local52, _local53);
                            break;
                    };
                    break;
            };
        }
        public function get dataProxy():DataProxy{
            return ((facade.retrieveProxy(DataProxy.NAME) as DataProxy));
        }
        private function arenaDieoutBallte(_arg1:NetPacket):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local2:int = _arg1.readUnsignedByte();
            var _local3:Array = [];
            switch (_local2){
                case 0:
                    _local4 = _arg1.readUnsignedInt();
                    _local3 = [_local4];
                    break;
                case 1:
                    _local5 = _arg1.readUnsignedInt();
                    _local3 = [_local5];
                    break;
                case 2:
                    _local6 = _arg1.readUnsignedInt();
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readUnsignedInt();
                    _local3 = [_local6, _local7, _local8];
                    break;
                case 3:
                    _local7 = _arg1.readUnsignedInt();
                    _local8 = _arg1.readUnsignedInt();
                    _local3 = [_local7, _local8];
                    break;
                case 4:
                    _local9 = _arg1.readUnsignedInt();
                    _local3 = [_local9];
                    break;
                case 5:
                    _local7 = _arg1.readUnsignedInt();
                    _local3 = [_local7];
                    break;
                case 6:
                    _local3 = [];
                    break;
            };
            facade.sendNotification(ArenaEvent.UPDATE_DBINFOVIEW, {
                type:_local2,
                data:_local3
            });
        }
        private function HandleServerMsg(_arg1:NetPacket):void{
            var _local4:RegExp;
            var _local5:RegExp;
            var _local6:RegExp;
            var _local7:String;
            var _local8:int;
            var _local9:uint;
            var _local10:Array;
            var _local11:uint;
            var _local12:uint;
            var _local13:String;
            var _local14:uint;
            var _local15:uint;
            var _local16:ChatReceiveMsg;
            var _local17:String;
            var _local18:InventoryItemInfo;
            var _local19:String;
            var _local20:String;
            var _local2 = "";
            var _local3:uint = _arg1.readUnsignedInt();
            switch (_local3){
                case SERVER_MSG_POPUPSTRING:
                    _local2 = _arg1.ReadString();
                    MessageTip.show(_local2);
                    MessageTip.popup(_local2);
                    break;
                case SERVER_MSG_SHUTDOWN_TIME:
                    _local2 = _arg1.ReadString();
                    _local2 = LanguageMgr.GetTranslation("服务器将在x后关闭", _local2);
                    MessageTip.show(_local2);
                    MessageTip.popup(_local2);
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", _local2);
                    break;
                case SERVER_MSG_SHUTDOWN_CANCELLED:
                    _local2 = LanguageMgr.GetTranslation("服务器取消关闭");
                    MessageTip.show(_local2);
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", _local2);
                    break;
                case SERVER_MSG_CYCLE_MESSAGE:
                    _local2 = _arg1.ReadString();
                    _local4 = new RegExp("&lt;", "g");
                    _local5 = new RegExp("&gt;", "g");
                    _local6 = new RegExp("&quot;", "g");
                    _local2 = _local2.replace(_local4, "<");
                    _local2 = _local2.replace(_local5, ">");
                    _local2 = _local2.replace(_local6, "\"");
                    _local7 = _local2;
                    _local8 = _local2.indexOf("<4_");
                    if (_local8 != -1){
                        _local9 = _local2.indexOf(">", _local8);
                        _local7 = _local2.substring(_local8, _local9);
                        _local10 = _local7.split("_");
                        _local7 = ((_local2.substr(0, _local8) + _local10[1]) + _local2.substring((_local9 + 1), _local2.length));
                    };
                    MessageTip.bugle(_local7);
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", _local2);
                    break;
                case SERVER_MSG_CHATTIPS:
                    _local2 = _arg1.ReadString();
                    ChatData.SimpleChat(ChatData.CHAT_TYPE_STSTEM, "", _local2);
                    break;
                case SERVER_MSG_GLOBAL_NOTICE:
                    _local2 = _arg1.ReadString();
                    _local11 = _arg1.readUnsignedInt();
                    _local12 = _arg1.readUnsignedInt();
                    _local13 = _arg1.ReadString();
                    _local14 = _arg1.readUnsignedInt();
                    _local15 = 0;
                    _local16 = new ChatReceiveMsg();
                    _local16.talkObj = new Array(5);
                    while (_local15 < _local14) {
                        _local18 = new InventoryItemInfo();
                        _local18.ReadFromPacket(_arg1);
                        _local19 = (("<" + String((_local15 + 1))) + ">");
                        _local20 = (((((((((("<1_[" + _local18.Name) + "]_") + _local18.ItemGUID) + "_") + _local18.TemplateID) + "_0_") + _local18.isBind) + "_") + _local18.Color) + ">");
                        _local2 = _local2.replace(_local19, _local20);
                        if (BagData.TipShowItemDic[_local18.ItemGUID]){
                            BagData.TipShowItemDic[_local18.ItemGUID] = null;
                        };
                        BagData.TipShowItemDic[_local18.ItemGUID] = _local18;
                        _local15++;
                    };
                    _local16.type = ChatData.CHAT_TYPE_STS;
                    _local17 = ChgLineData.getNameByIndex(_local11);
                    _local16.sendId = _local12;
                    _local16.talkObj[0] = _local13;
                    _local16.talkObj[2] = "";
                    _local16.content = _local2;
                    _local16.color = 0xFFFF00;
                    _local16.talkObj[4] = int(_local16.color).toString(16);
                    _local16.talkObj[3] = _local2;
                    facade.sendNotification(CommandList.RECEIVECOMMAND, _local16);
                    break;
            };
        }

    }
}//package Net.PackHandler 
