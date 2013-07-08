//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Role {
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.ScreenMessage.View.*;
    import OopsEngine.Graphics.Tagger.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.Bag.Datas.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Relive.Data.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.Question.model.*;
    import GameUI.Modules.WineParty.Data.*;
    import GameUI.Modules.RoleProperty.Mediator.RoleUtils.*;

    public class GameRole {

        public static const TYPE_COLLECT:String = "采集物体";
        public static const TYPE_PLAYER:String = "玩家";
        public static const STATE_DEPOT:String = "state_depot";
        public static const TYPE_OWNER:String = "主角";
        public static const F_STAET_FROZEN:int = 128;
        public static const TYPE_CONVOYCAR:String = "镖车";
        public static const F_STATE_FREEZE:int = 16;
        public static const STATE_NULL:String = null;
        public static const F_STATE_CUTTING:int = 0x0400;
        public static const F_STATE_VERTIGO:int = 1;
        public static const F_STATE_SHIELDS:int = 0x0100;
        public static const F_STATE_ASTHENIA = 2;
        public static const F_STATE_FASTING:int = 64;
        public static const TYPE_ENEMY:String = "敌人";
        public static const STATE_LOOKINGNPCSHOP:String = "state_lookingNPCShop";
        public static const STATE_LOOKINGSTALL:String = "state_lookingStall";
        public static const F_STATE_NULL:int = 0;
        public static const F_STATE_SLEEP:int = 4;
        public static const STATE_STALL:String = "state_stall";
        public static const STATE_TRADE:String = "state_trade";
        public static const F_STATE_CHARM:int = 8;
        public static const TYPE_PET:String = "宠物";
        public static const TYPE_NPC:String = "NPC";
        public static const F_STATE_HUNTERSTAMP:int = 32;

        public var MasterPlayer:GameElementPlayer;
        public var DuelTime:Number = 0;
        public var TitleColor:uint;
        private var _weaponSkinName:String;
        private var _CurrentTitleId:int;
        public var wantLoadPerson:Boolean;
        public var UsingPet:GamePetRole = null;
        public var PkValue:uint;
        private var _FightState:int;
        public var OwnTitles:Array;
        public var GuildDutyID:int;
        public var Speed:uint;
        public var StallName:String;
		//private var _MonsterTypeID:int = 25;//geoffyan 
        private var _MonsterTypeID:int = 0;
        private var _UsingPetId:uint;
        public var PetList:Dictionary;
        private var _MP:int;
        public var NpcFlags:uint;
        private var _TileX:int;
        private var _TileY:int;
        public var ConvoyCarAnimal:GameElementConvoycar;
        public var weaponStength:int;
        private var _PersonSkinName:String;
        private var _ArenaTeamId:int;
        private var _ConvoyFlag:uint;
        private var _MaxHp:int = 1;
        private var _isTeamLeader:Boolean;
        public var State:String;
        private var _DynamicFlag:uint;
        public var Score:uint = 0;
        public var Face:uint;
        public var PermanentRecord:uint;
        public var Gold:Number;
        private var _level:uint = 0;
        private var _pkTime:Number = 0;
        public var MissionState:int = 0;
        public var OfferValue:Array;
        private var _WeaponSkinID:int = 0;
        private var _GuildBanChatFlag:int;
        public var wantLoadMount:Boolean;
        public var Name:String;
        public var StateList:Dictionary;
        public var DefaultSkill:int = 0;
        public var GuildPermissions:int;
        private var _PetBattleFlag:int;
        public var StallId:int;
        private var _VIPEND:Number;
        private var _MountSkinName:String;
        public var canPickItem:Boolean = true;
        public var Money:Number;
        public var wantLoadWeapon:Boolean;
        public var CanUseSkill:Boolean = true;
        public var CsbPoint:int;
        public var DeleteObjDateTime:Number = 0;
        public var NameBorderColor:uint = 0;
        public var _MountSkinID:int;
        public var IsTurn:Boolean = true;
        public var wantLoadWeaponEffect:Boolean;
        public var GuildName:String = "";
        private var _MaxMp:int;
        public var FatigueValue:Number;
        private var _PersonSkinID:int;
        private var _IsMediation:Boolean;
        public var DotBuff:Array;
        public var MainJob:RoleJob;
        public var UseSkill:int = 0;
        public var _isStalling:uint = 0;
        public var PlusBuff:Array;
        public var PkState:uint = 0;
        private var _idTeam:uint;
        public var _Title:String;
        public var Id:uint;
        public var MasterId:int;
        public var TitleBorderColor:uint = 0;
        public var idTeamLeader:uint = 0;
        private var _VIP:int = 0;
        public var canUseItem:Boolean = true;
        public var GuildColor:uint = 16611586;
        private var _weaponEffectName:String;
        public var Type:String;
        public var AttackTime:Number = 0;
        public var Gift:Number;
        public var VIPColor:String = null;
        public var unityId:uint;
        public var GMFlag:uint;
        public var isHidden:Boolean = false;
        public var OnLineAwardTime:uint = 0;
        public var NameColor:uint = 0xFFFFFF;
        public var GuildDutyName:String;
        public var personMountSkinName:String;
        public var CurrentPlayer:GameElementAnimal;
        private var _CurrentJobID:int = 0;
        public var CanMove:Boolean = true;
        private var _hp:int = 0;
        public var CsbOffer:int;
        private var _sex:uint;
        public var GuildDutyLevel:int;
        private var _TreasureID:int = 0;
        public var GuildBuildValue:int;
        public var ActionState:String;
        private var _Direction:int;
        public var AdditionAtt:AdditionalAtt;
        private var _loopTaskIdx;
        public var UsingPetAnimal:GameElementPet;
        public var Exp:uint;
        private var _preTilePoint:Point;

        public function GameRole(){
            OfferValue = [0, 0, 0, 0, 0, 0, 0, 0];
            OwnTitles = [];
            PetList = new Dictionary();
            MainJob = new RoleJob();
            AdditionAtt = new AdditionalAtt();
            Direction = GameElementSkins.DIRECTION_DOWN;
            ActionState = GameElementSkins.ACTION_STATIC;
            PlusBuff = new Array();
            DotBuff = new Array();
            StateList = new Dictionary();
            super();
        }
        public function IsChangeActionState():Boolean{
            if (((!((this.ActionState == GameElementSkins.ACTION_DEAD))) && (!((this.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))))){
                return (true);
            };
            return (false);
        }
        public function get WeaponSkinName():String{
            return (_weaponSkinName);
        }
        public function get MaxMp():int{
            return (_MaxMp);
        }
        public function set WeaponSkinName(_arg1:String):void{
            _weaponSkinName = _arg1;
        }
        public function set VIP(_arg1:uint):void{
            if (_arg1 == this._VIP){
                return;
            };
            this._VIP = _arg1;
            if (((!((this.CurrentPlayer.PersonName == null))) && (!((this.CurrentPlayer.PersonName.text == ""))))){
                this.CurrentPlayer.SetVIP();
            };
            if (QuestionConstData.started){
                UIFacade.GetInstance().sendNotification(QuestionEvents.QUESTION_UPDATETEXT);
            };
            if (GameCommonData.Player.Role.Id == this.Id){
                UIFacade.GetInstance().sendNotification(WinPartEvent.VIP_CHANGE);
                if ((((((_arg1 == 0)) && (!((VIPEND == 0))))) && (!(GameCommonData.showChargeTips)))){
                    UIFacade.GetInstance().sendNotification(EventList.SHOW_VIP_WARN_VIEW);
                    GameCommonData.showChargeTips = true;
                };
            };
        }
        public function get VIP():uint{
            return (this._VIP);
        }
        public function set MaxMp(_arg1:int):void{
            var _local2:int;
            if (_MaxMp != _arg1){
                _local2 = (_arg1 - _MaxMp);
                _MaxMp = _arg1;
                if ((((GameCommonData.Player.Role.Id == this.Id)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_MP, _local2);
                };
            };
        }
        public function DelteBuff(_arg1:GameSkillBuff):Boolean{
            var _local2:int;
            while (_local2 < PlusBuff.length) {
                if (PlusBuff[_local2].BuffID == _arg1.BuffID){
                    PlusBuff.splice(_local2, 1);
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function get PlayerGuildOffer():uint{
            return (OfferValue[8]);
        }
        public function set HP(_arg1:int):void{
            if (_hp != _arg1){
                this._hp = _arg1;
                if (CurrentPlayer){
                    if (CurrentPlayer.isUpdateBlood){
                        CurrentPlayer.updateBlood();
                    };
                };
                if (GameCommonData.Player.Role.Id == this.Id){
                    if (_hp == 0){
                        UIFacade.GetInstance().sendNotification(ReliveEvent.SHOWRELIVE);
                    };
                    UIFacade.GetInstance().sendNotification(AutoPlayEventList.ATT_CHANGE_EVENT, 1);
                    UIFacade.GetInstance().sendNotification(EventList.UPDATE_MYATTRIBUATT, "Hp");
                };
                if (((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == this.Id)))){
                    UIFacade.GetInstance().sendNotification(AutoPlayEventList.ATT_CHANGE_EVENT, 3);
                };
            };
        }
        public function DelteDot(_arg1:GameSkillBuff):Boolean{
            var _local2:int;
            while (_local2 < DotBuff.length) {
                if (DotBuff[_local2].BuffID == _arg1.BuffID){
                    DotBuff.splice(_local2, 1);
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function get idTeam():uint{
            return (_idTeam);
        }
        public function set PlayerGuildOffer(_arg1:uint):void{
            OfferValue[8] = _arg1;
        }
        public function get preTilePoint():Point{
            if (_preTilePoint == null){
                _preTilePoint = new Point(_TileX, _TileY);
            };
            return (_preTilePoint);
        }
        public function get PlayerSocity():uint{
            return (OfferValue[7]);
        }
        public function get TreasureID():int{
            return (_TreasureID);
        }
        public function get ArenaTeamId():int{
            return (_ArenaTeamId);
        }
        public function get MonsterTypeID():int{
            return (_MonsterTypeID);
        }
        public function UpdateDuelTime():void{
            var _local1:Date = new Date();
            DuelTime = _local1.time;
        }
        public function set idTeam(_arg1:uint):void{
            var _local2:int = _idTeam;
            _idTeam = _arg1;
            if ((((_arg1 == GameCommonData.Player.Role.idTeam)) || ((_local2 == GameCommonData.Player.Role.idTeam)))){
                GameCommonData.UIFacadeIntance.sendNotification(PlayerInfoComList.UPDATE_TEAM_SMALLMAP);
            };
            if (_arg1 == 0){
                isTeamLeader = false;
            };
        }
        public function get IsAttack():Boolean{
            var _local1:Date = new Date();
            if (((((_local1.time - AttackTime) > 5000)) || (!(GameCommonData.IsInCombat)))){
                return (false);
            };
            return (true);
        }
        public function get DynamicFlag():uint{
            return (_DynamicFlag);
        }
        public function set preTilePoint(_arg1:Point):void{
            _preTilePoint = _arg1;
        }
        public function get Title():String{
            return (_Title);
        }
        public function get PersonSkinName():String{
            return (_PersonSkinName);
        }
        public function set ArenaTeamId(_arg1:int):void{
            if (_ArenaTeamId != _arg1){
                _ArenaTeamId = _arg1;
                if (_ArenaTeamId == 0){
                    NameColor = 0xFFFFFF;
                } else {
                    if (_ArenaTeamId == 1){
                        NameColor = 0xFF0000;
                    } else {
                        if (_ArenaTeamId == 2){
                            NameColor = 26367;
                        } else {
                            if ((((_ArenaTeamId >= 10000)) && ((_ArenaTeamId < 20000)))){
                                NameColor = 0xFF00;
                            } else {
                                if ((((_ArenaTeamId >= 20000)) && ((_ArenaTeamId < 30000)))){
                                    NameColor = 0xFFFFFF;
                                };
                            };
                        };
                    };
                };
                if (CurrentPlayer){
                    CurrentPlayer.setNameColor();
                };
            };
        }
        public function get GuildBanChatFlag():int{
            if (_GuildBanChatFlag <= (new Date().time / 1000)){
                _GuildBanChatFlag = 0;
            };
            return (_GuildBanChatFlag);
        }
        public function get Sex():uint{
            return (_sex);
        }
        public function readMyInfoPkg(_arg1:NetPacket):void{
            this.Id = _arg1.readUnsignedInt();
            this.Name = _arg1.ReadString();
            this.NameBorderColor = 0;
            this.Title = (("<" + LanguageMgr.GetTranslation("英雄王座真好玩")) + ">");
            this.TitleColor = 65526;
            this.TitleBorderColor = 1770495;
            this.Face = _arg1.readUnsignedInt();
            this.PersonSkinID = _arg1.readUnsignedInt();
            this.Sex = _arg1.readUnsignedInt();
            this.CurrentJobID = _arg1.readUnsignedInt();
            this.MainJob.Job = this.CurrentJobID;
            this.Money = _arg1.readUnsignedInt();
            this.Gold = _arg1.readUnsignedInt();
            this.Gift = _arg1.readUnsignedInt();
            var _local2:int;
            while (_local2 < 8) {
                this.OfferValue[_local2] = _arg1.readUnsignedInt();
                _local2++;
            };
            this.PkValue = 1;
            this.PkState = 1;
            this.NameBorderColor = 0;
            this.Type = GameRole.TYPE_OWNER;
            ReadProperties(_arg1);
        }
        public function set PlayerRepute2(_arg1:uint):void{
            if (OfferValue[1] != _arg1){
                OfferValue[1] = _arg1;
                UIFacade.GetInstance().sendNotification(NPCExchangeEvent.NPC_EXCHANGE_SUCESS);
            };
        }
        public function set PlayerRepute3(_arg1:uint):void{
            if (OfferValue[2] != _arg1){
                OfferValue[2] = _arg1;
                UIFacade.GetInstance().sendNotification(NPCExchangeEvent.NPC_EXCHANGE_SUCESS);
            };
        }
        public function set PlayerRepute4(_arg1:uint):void{
            if (OfferValue[3] != _arg1){
                OfferValue[3] = _arg1;
                UIFacade.GetInstance().sendNotification(NPCExchangeEvent.NPC_EXCHANGE_SUCESS);
            };
        }
        public function set MonsterTypeID(_arg1:int):void{
            var _local2:int = _MonsterTypeID;
            _MonsterTypeID = _arg1;
        }
        public function set PlayerSocity(_arg1:uint):void{
            OfferValue[7] = _arg1;
        }
        public function set PersonSkinID(_arg1:int):void{
            var _local2:int;
            var _local3:int;
            if (_PersonSkinID != _arg1){
                _local2 = _PersonSkinID;
                _local3 = _PersonSkinID;
                _PersonSkinID = _arg1;
                wantLoadPerson = false;
                if (((CurrentPlayer) && (CurrentPlayer.gameScene))){
                    if ((((this.Type == GameRole.TYPE_PLAYER)) || ((this.Type == GameRole.TYPE_OWNER)))){
                        PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_PERSON, this._PersonSkinID, CurrentPlayer);
                        if (((((!((_local3 == 0))) && ((((int((_arg1 / 10000)) > 0)) || ((_arg1 == 101)))))) && ((MountSkinID == 0)))){
                            SpeciallyEffectController.getInstance().PlayChangeEffect(CurrentPlayer);
                        };
                    } else {
                        if ((((this.Type == GameRole.TYPE_ENEMY)) || ((this.Type == GameRole.TYPE_NPC)))){
                            EnemySkinsController.SetSkin(_local2, _PersonSkinID, CurrentPlayer);
                        };
                    };
                } else {
                    wantLoadPerson = true;
                };
            };
        }
        public function get PlayerBattleRepute():uint{
            return (OfferValue[5]);
        }
        public function set TreasureID(_arg1:int):void{
            _TreasureID = _arg1;
            TreasureController.getInstance().updateTreasure(this.CurrentPlayer, TreasureID);
        }
        public function set PlayerRepute5(_arg1:uint):void{
            if (OfferValue[4] != _arg1){
                OfferValue[4] = _arg1;
                UIFacade.GetInstance().sendNotification(NPCExchangeEvent.NPC_EXCHANGE_SUCESS);
            };
        }
        public function set PlayerRepute1(_arg1:uint):void{
            if (OfferValue[0] != _arg1){
                OfferValue[0] = _arg1;
                UIFacade.GetInstance().sendNotification(NPCExchangeEvent.NPC_EXCHANGE_SUCESS);
            };
        }
        public function set Title(_arg1:String):void{
            _Title = _arg1;
            if ((((_arg1 == LanguageMgr.GetTranslation("可抓捕"))) && ((this.Type == GameRole.TYPE_ENEMY)))){
                this.TitleColor = 16496146;
            };
        }
        public function set DynamicFlag(_arg1:uint):void{
            IsMediation = (_arg1 & 16);
            ConvoyFlag = ((_arg1 & ((2 | 4) | 8)) >> 1);
            _DynamicFlag = _arg1;
        }
        public function get FightState():int{
            return (_FightState);
        }
        public function set PersonSkinName(_arg1:String):void{
            if (_arg1 == null){
                return;
            };
            _PersonSkinName = _arg1;
        }
        public function set GuildBanChatFlag(_arg1:int):void{
            _GuildBanChatFlag = _arg1;
        }
        public function get isTeamLeader():Boolean{
            return (_isTeamLeader);
        }
        public function set Sex(_arg1:uint):void{
            _sex = _arg1;
        }
        public function set TileY(_arg1:int):void{
            preTilePoint.y = _TileY;
            _TileY = _arg1;
        }
        public function get UsingPetId():uint{
            return (_UsingPetId);
        }
        public function set TileX(_arg1:int):void{
            preTilePoint.x = _TileX;
            _TileX = _arg1;
        }
        public function get CurrentTitleId():int{
            return (_CurrentTitleId);
        }
        public function clearAllParams():void{
            this.WeaponSkinID = 0;
            this.MountSkinID = 0;
            this.ActionState = GameElementSkins.ACTION_STATIC;
        }
        public function set Direction(_arg1:int):void{
            _Direction = _arg1;
        }
        public function get MountSkinName():String{
            return (_MountSkinName);
        }
        public function get WeaponSkinID():int{
            return (_WeaponSkinID);
        }
        public function set Level(_arg1:uint):void{
            var _local2:uint;
            var _local3:Array;
            if ((((_arg1 > 1000)) && ((this.CurrentPlayer is GameElementPet)))){
                _arg1 = (_arg1 % 1000);
            };
            if (_arg1 > _level){
                if (_level != 0){
                    if (this.Id == GameCommonData.Player.Role.Id){
                        GameCommonData.UIFacadeIntance.sendNotification(EventList.UPDATE_MYATTRIBUATT, "Level");
                        _local2 = _level;
                        while (_local2 < _arg1) {
                            if ((_local2 % 2) != 0){
                                if ((((_local2 >= 9)) && ((_local2 < 28)))){
                                    var _local4 = SkillManager.SkillCurrentPoint;
                                    var _local5:int;
                                    var _local6 = (_local4[_local5] + 1);
                                    _local4[_local5] = _local6;
                                } else {
                                    if ((((_local2 >= 29)) && ((_local2 < 68)))){
                                        _local4 = SkillManager.SkillCurrentPoint;
                                        _local5 = 1;
                                        _local6 = (_local4[_local5] + 1);
                                        _local4[_local5] = _local6;
                                    } else {
                                        if ((((_local2 >= 69)) && ((_local2 < 100)))){
                                            _local4 = SkillManager.SkillCurrentPoint;
                                            _local5 = 2;
                                            _local6 = (_local4[_local5] + 1);
                                            _local4[_local5] = _local6;
                                        };
                                    };
                                };
                            };
                            _local2++;
                        };
                        if ((((_arg1 > 20)) && ((_arg1 < 63)))){
                            GameCommonData.UIFacadeIntance.sendNotification(EventList.SET_STAR_OPEN_STATUS, 1);
                            GameCommonData.UIFacadeIntance.sendNotification(EventList.REFRESH_STAR, _arg1);
                        };
                    };
                    _level = _arg1;
                    if (this.Id == GameCommonData.Player.Role.Id){
                        _local3 = [20, 45, 55];
                        if (BagData.BagNum[0] < BagData.MAX_GRIDS){
                            if (BagData.EXTEND_NUM < (4 * BagData.GRID_COLS)){
                                if (_level == _local3[0]){
                                    UIFacade.GetInstance().sendNotification(BagEvents.EXTENDBAG, (4 * BagData.GRID_COLS));
                                };
                            } else {
                                if (BagData.EXTEND_NUM < (5 * BagData.GRID_COLS)){
                                    if (_level == _local3[1]){
                                        UIFacade.GetInstance().sendNotification(BagEvents.EXTENDBAG, (5 * BagData.GRID_COLS));
                                    };
                                } else {
                                    if (BagData.EXTEND_NUM < (6 * BagData.GRID_COLS)){
                                        if (_level == _local3[2]){
                                            UIFacade.GetInstance().sendNotification(BagEvents.EXTENDBAG, (6 * BagData.GRID_COLS));
                                        };
                                    };
                                };
                            };
                        };
                    };
                    RoleLevUp.PlayLevUp(Id, true);
                    UIFacade.GetInstance().sendNotification(EventList.UPDATESKILLVIEW);
                };
                _level = _arg1;
                GameCommonData.UIFacadeIntance.sendNotification(EventList.UPDATE_MAINSECEN_EXP);
                if (this.Id == GameCommonData.Player.Role.Id){
                    UIFacade.GetInstance().sendNotification(TaskCommandList.UPDATE_LEVEL_TASK);
                    if ((((((_level + 2) % 4) == 0)) && ((_level >= 14)))){
                        UIFacade.GetInstance().sendNotification(NewInfoTipNotiName.NEWINFOTIP_SKILL_SHOW);
                    };
                    if (_level > 30){
                        UIFacade.GetInstance().sendNotification(TranscriptEvent.SHOW_TOWER_BTN);
                    };
                    UIFacade.GetInstance().sendNotification(EventList.PLAYER_LEVELUP);
                    UIFacade.GetInstance().sendNotification(HelpTipsNotiName.HELPTIPS_SHOW, {
                        TYPE:"Level",
                        VALUE:_level
                    });
                };
                UIFacade.GetInstance().sendNotification(EventList.UPDATE_LEVEL);
            };
        }
        public function get MountSkinID():uint{
            return (_MountSkinID);
        }
        public function get ConvoyFlag():uint{
            return (_ConvoyFlag);
        }
        public function set PlayerBattleRepute(_arg1:uint):void{
            OfferValue[5] = _arg1;
        }
        public function get IsMediation():Boolean{
            return (_IsMediation);
        }
        public function IsBuff(_arg1:int):Boolean{
            var _local2:int;
            while (_local2 < PlusBuff.length) {
                if (PlusBuff[_local2].BuffID == _arg1){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function UpdateBuff(_arg1:GameSkillBuff):void{
            var _local2:int;
            while (_local2 < PlusBuff.length) {
                if (PlusBuff[_local2].BuffID == _arg1.BuffID){
                    PlusBuff[_local2] = _arg1;
                    return;
                };
                _local2++;
            };
            PlusBuff.push(_arg1);
        }
        public function set MaxHp(_arg1:int):void{
            var _local2:int;
            if (_MaxHp != _arg1){
                _local2 = (_arg1 - _MaxHp);
                this._MaxHp = _arg1;
                if ((((GameCommonData.Player.Role.Id == this.Id)) && (GameCommonData.Scene))){
                    FightHeadThread.Instance.push(GameCommonData.Player, AttackFace.MAX_HP, _local2);
                };
                if (CurrentPlayer){
                    if (CurrentPlayer.isUpdateBlood){
                        CurrentPlayer.updateBlood();
                    };
                };
            };
        }
        public function set PlayerTeaching(_arg1:uint):void{
            OfferValue[6] = _arg1;
        }
        public function get IsBattling():Boolean{
            return ((_PetBattleFlag == 2));
        }
        public function get weaponEffectName():String{
            return (_weaponEffectName);
        }
        public function set FightState(_arg1:int):void{
            var _local2:String;
            if (_FightState == _arg1){
                return;
            };
            _FightState = _arg1;
            for (_local2 in StateList) {
                StateList[_local2] = false;
            };
            if ((_FightState & F_STATE_VERTIGO)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("眩晕"));
                StateList[F_STATE_VERTIGO] = true;
            };
            if ((_FightState & F_STATE_ASTHENIA)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("虚弱"));
                StateList[F_STATE_ASTHENIA] = true;
            };
            if ((_FightState & F_STATE_SLEEP)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("昏睡"));
                StateList[F_STATE_SLEEP] = true;
            };
            if ((_FightState & F_STATE_FREEZE)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("定身"));
                StateList[F_STATE_FREEZE] = true;
            };
            if ((_FightState & F_STATE_CHARM)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("魅惑"));
                StateList[F_STATE_CHARM] = true;
            };
            if ((_FightState & F_STATE_HUNTERSTAMP)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("猎人印记"));
                StateList[F_STATE_HUNTERSTAMP] = true;
            };
            if ((_FightState & F_STATE_FASTING)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("禁食"));
                StateList[F_STATE_FASTING] = true;
            };
            if ((_FightState & F_STAET_FROZEN)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("冰箱"));
                StateList[F_STAET_FROZEN] = true;
            };
            if ((_FightState & F_STATE_SHIELDS)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("护盾"));
                StateList[F_STATE_SHIELDS] = true;
            };
            if ((_FightState & F_STATE_CUTTING)){
                CombatController.Skill(this.CurrentPlayer, LanguageMgr.GetTranslation("切割"));
                StateList[F_STATE_CUTTING] = true;
            };
            if ((((((_FightState & F_STATE_VERTIGO)) || ((_FightState & F_STATE_SLEEP)))) || ((_FightState & F_STATE_FREEZE)))){
                CanMove = false;
                canPickItem = false;
                if (CurrentPlayer){
                    CurrentPlayer.Stop();
                };
            } else {
                CanMove = true;
                canPickItem = true;
            };
            if ((((((((_FightState & F_STATE_VERTIGO)) || ((_FightState & F_STATE_SLEEP)))) || ((_FightState & F_STATE_CHARM)))) || ((_FightState & F_STAET_FROZEN)))){
                CanUseSkill = false;
            } else {
                CanUseSkill = true;
            };
            if ((((((_FightState & F_STATE_SLEEP)) || ((_FightState & F_STATE_FREEZE)))) || ((_FightState & F_STATE_ASTHENIA)))){
                canUseItem = false;
            } else {
                canUseItem = true;
            };
            if (this.CurrentPlayer){
                this.CurrentPlayer.setEffectVisible();
            };
        }
        public function UpdateAttackTime():void{
            var _local1:Date = new Date();
            AttackTime = _local1.time;
            if (!MapManager.IsInGVG()){
                UIFacade.GetInstance().sendNotification(PlayerInfoComList.CANCEL_COLLECT, true);
            };
            UIFacade.GetInstance().sendNotification(BagEvents.CANCEL_TASKITEM_USE);
        }
        public function set PkTime(_arg1:Number):void{
            if ((((this.ArenaTeamId == 1)) || ((this.ArenaTeamId == 2)))){
                return;
            };
            if ((((((_pkTime < 10)) && ((_arg1 >= 10)))) && ((this == GameCommonData.Player.Role)))){
                UIFacade.GetInstance().sendNotification(HelpTipsNotiName.HELPTIPS_SHOW, {TYPE:"TYPE_REDNAME"});
            };
            _pkTime = _arg1;
            if (_pkTime >= 10){
                NameColor = 0xFF0000;
            } else {
                if (_pkTime >= 5){
                    NameColor = 0xFFFF00;
                } else {
                    NameColor = 0xFFFFFF;
                };
            };
            if ((CurrentPlayer is GameElementPlayer)){
                (CurrentPlayer as GameElementPlayer).setNameColor();
            };
            if (this == GameCommonData.Player.Role){
                UIFacade.GetInstance().sendNotification(RoleEvents.UPDATE_PKVALUE);
            };
        }
        public function IsChangeDirection():Boolean{
            if (this.ActionState != GameElementSkins.ACTION_DEAD){
                return (true);
            };
            return (false);
        }
        public function get HP():int{
            return (_hp);
        }
        public function set isStalling(_arg1:uint):void{
            if ((((_arg1 == 0)) && (!((_isStalling == 0))))){
                _isStalling = _arg1;
                UIFacade.GetInstance().sendNotification(EventList.ENDSTALL, this.Id);
                return;
            };
            if ((((_isStalling == 0)) && ((_arg1 > 0)))){
                _isStalling = _arg1;
                UIFacade.GetInstance().sendNotification(EventList.BEGINSTALL, this.Id);
            };
        }
        public function set isTeamLeader(_arg1:Boolean):void{
            _isTeamLeader = _arg1;
        }
        public function get PlayerRepute1():uint{
            return (OfferValue[0]);
        }
        public function get PlayerRepute2():uint{
            return (OfferValue[1]);
        }
        public function get PlayerRepute3():uint{
            return (OfferValue[2]);
        }
        public function set UsingPetId(_arg1:uint):void{
            _UsingPetId = _arg1;
        }
        public function get PlayerRepute5():uint{
            return (OfferValue[4]);
        }
        public function set VIPEND(_arg1:uint):void{
            this._VIPEND = (_arg1 * 1000);
            UIFacade.GetInstance().sendNotification(EventList.UPDATE_VIP_TIME, _arg1);
        }
        public function get TileY():int{
            return (_TileY);
        }
        public function get PlayerRepute4():uint{
            return (OfferValue[3]);
        }
        public function set MP(_arg1:int):void{
            if (_MP != _arg1){
                this._MP = _arg1;
                if (GameCommonData.Player.Role.Id == this.Id){
                    UIFacade.GetInstance().sendNotification(AutoPlayEventList.ATT_CHANGE_EVENT, 2);
                    UIFacade.GetInstance().sendNotification(EventList.UPDATE_MYATTRIBUATT, "Mp");
                };
                if (((GameCommonData.Player.Role.UsingPetAnimal) && ((GameCommonData.Player.Role.UsingPetAnimal.Role.Id == this.Id)))){
                    UIFacade.GetInstance().sendNotification(AutoPlayEventList.ATT_CHANGE_EVENT, 4);
                };
            };
        }
        public function get PersonSkinID():int{
            return (_PersonSkinID);
        }
        public function get TileX():int{
            return (_TileX);
        }
        public function readNormalInfoPkg(_arg1:NetPacket):void{
            this.Name = _arg1.ReadString();
            if ((((((((((this.Type == GameRole.TYPE_PLAYER)) || ((this.Type == GameRole.TYPE_OWNER)))) || ((this.Type == GameRole.TYPE_ENEMY)))) || ((this.Type == GameRole.TYPE_NPC)))) || ((this.Type == GameRole.TYPE_COLLECT)))){
                this.GuildName = _arg1.ReadString();
                if (((!((GuildName == ""))) && ((this.Type == GameRole.TYPE_ENEMY)))){
                    this.GuildName = ((("[" + this.GuildName) + "]") + LanguageMgr.GetTranslation("公会所属"));
                    this.GuildColor = 0xFF00;
                    if (CurrentPlayer){
                        CurrentPlayer.setGuildColor();
                    };
                };
            };
            if ((DynamicFlag & 1)){
                StallName = _arg1.ReadString();
                isStalling = 1;
            };
            if (Type == GameRole.TYPE_PET){
                MasterId = _arg1.readUnsignedInt();
            };
            this.TileX = int(_arg1.readFloat());
            this.TileY = int(_arg1.readFloat());
            this.Direction = _arg1.readUnsignedInt();
            this.Speed = 5;
            this.Title = (("<" + LanguageMgr.GetTranslation("英雄王座真好玩")) + ">");
            if (this.Type == GameRole.TYPE_PLAYER){
                this.TitleColor = 65526;
                this.TitleBorderColor = 1770495;
                this.PkValue = 1;
                this.PkState = 1;
            };
            if (this.Type == GameRole.TYPE_ENEMY){
                this.TitleColor = 15456147;
                this.TitleBorderColor = 3477505;
                this.NameBorderColor = 0x220C00;
            };
            if (this.Type == GameRole.TYPE_PET){
                this.TitleColor = 65382;
                this.TitleBorderColor = 3477505;
                this.NameBorderColor = 0x220C00;
            };
        }
        public function get Level():uint{
            return (_level);
        }
        public function set PetBattleFlag(_arg1:int):void{
            _PetBattleFlag = _arg1;
            if ((((_PetBattleFlag == 1)) && ((this.Type == GameRole.TYPE_PET)))){
                PetController.getInstance().MoveToMaster(this.CurrentPlayer);
            };
        }
        public function get IsDuel():Boolean{
            var _local1:Date = new Date();
            if ((_local1.time - DuelTime) > 5000){
                return (false);
            };
            return (true);
        }
        public function get MaxHp():int{
            return (_MaxHp);
        }
        public function get PlayerTeaching():uint{
            return (OfferValue[6]);
        }
        public function set loopTaskIdx(_arg1):void{
            _loopTaskIdx = _arg1;
        }
        public function set MountSkinID(_arg1:uint):void{
            if (_MountSkinID == _arg1){
                return;
            };
            _MountSkinID = _arg1;
            wantLoadMount = false;
            if (((CurrentPlayer) && (CurrentPlayer.gameScene))){
                PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_MOUNT, _MountSkinID, CurrentPlayer);
            } else {
                wantLoadMount = true;
            };
        }
        public function set CurrentJobID(_arg1:int):void{
            if (_CurrentJobID != _arg1){
                _CurrentJobID = _arg1;
                this.MainJob.Job = _CurrentJobID;
            };
        }
        public function set WeaponSkinID(_arg1:int):void{
            var _local2:int = int((_arg1 / 100));
            var _local3:int = int((_arg1 % 100));
            if (_WeaponSkinID != _local2){
                _WeaponSkinID = _local2;
                wantLoadWeapon = false;
                if (((CurrentPlayer) && (CurrentPlayer.gameScene))){
                    PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_WEAOIB, this._WeaponSkinID, CurrentPlayer);
                } else {
                    wantLoadWeapon = true;
                };
            };
            if (weaponStength != _local3){
                weaponStength = _local3;
                wantLoadWeaponEffect = false;
                if (((CurrentPlayer) && (CurrentPlayer.gameScene))){
                    PlayerSkinsController.SetSkin(GameElementSkins.EQUIP_WEAPONE_EFFECT, this.weaponStength, CurrentPlayer);
                } else {
                    wantLoadWeaponEffect = true;
                };
            };
        }
        public function get Direction():int{
            return (_Direction);
        }
        public function set MountSkinName(_arg1:String):void{
            _MountSkinName = _arg1;
        }
        public function ReadProperties(_arg1:NetPacket):void{
            this.Level = _arg1.readUnsignedInt();
            this.Exp = _arg1.readUnsignedInt();
            this.MaxHp = _arg1.readUnsignedInt();
            this.HP = _arg1.readUnsignedInt();
            this.MaxMp = _arg1.readUnsignedInt();
            this.MP = _arg1.readUnsignedInt();
            this.MainJob.AttackMin = _arg1.readUnsignedInt();
            this.MainJob.AttackMax = _arg1.readUnsignedInt();
            this.MainJob.Defense = _arg1.readUnsignedInt();
            this.MainJob.Hit = _arg1.readUnsignedInt();
            this.MainJob.Dodge = _arg1.readUnsignedInt();
            this.MainJob.SkillHit = _arg1.readUnsignedInt();
            this.MainJob.SkillDodge = _arg1.readUnsignedInt();
            this.MainJob.CritRate = Number(_arg1.readFloat().toFixed(4));
            this.MainJob.Crit = Number(_arg1.readFloat().toFixed(4));
            this.MainJob.VertigoResistance = _arg1.readUnsignedInt();
            this.MainJob.WeakResistance = _arg1.readUnsignedInt();
            this.MainJob.SleepResistance = _arg1.readUnsignedInt();
            this.MainJob.CharmResistance = _arg1.readUnsignedInt();
            this.MainJob.FixedBodyResistance = _arg1.readUnsignedInt();
            this.MainJob.FightPower = _arg1.readUnsignedInt();
        }
        public function get PkTime():Number{
            return (_pkTime);
        }
        public function get isStalling():uint{
            return (_isStalling);
        }
        public function set ConvoyFlag(_arg1:uint):void{
            if (((((!((_ConvoyFlag == _arg1))) && (CurrentPlayer))) && ((((Type == TYPE_OWNER)) || ((Type == TYPE_PLAYER)))))){
                _ConvoyFlag = _arg1;
                if (_ConvoyFlag > 0){
                    ConvoyController.addConvoyCar(this.CurrentPlayer);
                } else {
                    ConvoyController.removeConvoyCar(this.CurrentPlayer);
                };
            };
        }
        public function set IsMediation(_arg1:Boolean):void{
            if (this.CurrentPlayer == null){
                return;
            };
            _IsMediation = _arg1;
            if (((_IsMediation) && (!((MountSkinID == 0))))){
                MountSkinID = 0;
            };
            if (_IsMediation){
                this.CurrentPlayer.SetAction(GameElementSkins.ACTION_MEDITATION);
                if ((((this.CurrentPlayer.getChildByName(SpeciallyEffectController.EFFECT_MEDIATION) == null)) && (this.CurrentPlayer.IsLoadSkins))){
                    SpeciallyEffectController.getInstance().showSceneMovieEffect(SpeciallyEffectController.EFFECT_MEDIATION, 0, 0, 0, true, this.CurrentPlayer, 0);
                };
                if ((((this.CurrentPlayer.getChildByName(SpeciallyEffectController.EFFECT_MEDIATION_TOP) == null)) && (this.CurrentPlayer.IsLoadSkins))){
                    SpeciallyEffectController.getInstance().showSceneMovieEffect(SpeciallyEffectController.EFFECT_MEDIATION_TOP, 0, 0, 0, true, this.CurrentPlayer);
                };
            } else {
                this.CurrentPlayer.SetAction(GameElementSkins.ACTION_STATIC);
                if (this.CurrentPlayer.getChildByName(SpeciallyEffectController.EFFECT_MEDIATION)){
                    this.CurrentPlayer.removeChild(this.CurrentPlayer.getChildByName(SpeciallyEffectController.EFFECT_MEDIATION));
                };
                if (this.CurrentPlayer.getChildByName(SpeciallyEffectController.EFFECT_MEDIATION_TOP)){
                    this.CurrentPlayer.removeChild(this.CurrentPlayer.getChildByName(SpeciallyEffectController.EFFECT_MEDIATION_TOP));
                };
            };
        }
        public function IsDot(_arg1:int):Boolean{
            var _local2:GameSkillBuff;
            var _local3:int;
            while (_local3 < DotBuff.length) {
                _local2 = (DotBuff[_local3] as GameSkillBuff);
                if (_local2.BuffID == _arg1){
                    return (true);
                };
                _local3++;
            };
            return (false);
        }
        public function UpdateDot(_arg1:GameSkillBuff):void{
            var _local2:int;
            while (_local2 < DotBuff.length) {
                if (DotBuff[_local2].BuffID == _arg1.BuffID){
                    DotBuff[_local2] = _arg1;
                    return;
                };
                _local2++;
            };
            DotBuff.push(_arg1);
        }
        public function get MP():int{
            return (_MP);
        }
        public function get VIPEND():uint{
            return (this._VIPEND);
        }
        public function get CurrentJobID():int{
            return (_CurrentJobID);
        }
        public function get loopTaskIdx(){
            return (_loopTaskIdx);
        }
        public function UpdateBuffTime(_arg1:int, _arg2:int):void{
            var _local3:int;
            while (_local3 < PlusBuff.length) {
                if (PlusBuff[_local3].BuffID == _arg1){
                    PlusBuff[_local3].BuffTime = _arg2;
                    return;
                };
                _local3++;
            };
        }
        public function IsSameTpyeBuff(_arg1:int):Boolean{
            var _local2:int;
            while (_local2 < PlusBuff.length) {
                if (int((PlusBuff[_local2].BuffID / 100)) == int((_arg1 / 100))){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function set weaponEffectName(_arg1:String):void{
            _weaponEffectName = _arg1;
        }
        public function set CurrentTitleId(_arg1:int):void{
            _CurrentTitleId = _arg1;
            AchieveManager.getInstance().setPlayerTitle(_arg1, this.CurrentPlayer);
        }

    }
}//package OopsEngine.Role 
