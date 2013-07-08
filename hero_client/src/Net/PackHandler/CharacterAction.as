//Created by Action Script Viewer - http://www.buraks.com/asv
package Net.PackHandler {
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import Net.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import OopsFramework.Debug.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import flash.net.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Login.StartMediator.*;
    import GameUI.Modules.Login.Model.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.RoleProperty.Mediator.RoleUtils.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.Modules.VIP.Mediator.*;
    import GameUI.Modules.Activity.Mediator.*;

    public class CharacterAction extends GameAction {

        private static var _instance:CharacterAction;

        public function CharacterAction(){
            super(true);
            if (_instance){
                throw (new Error("CharacterAction is Instance"));
            };
        }
        public static function getInstance():CharacterAction{
            if (!_instance){
                _instance = new (CharacterAction)();
            };
            return (_instance);
        }

        private function choostJobResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            if (GameCommonData.Player){
                GameCommonData.Player.Role.CurrentJobID = _local2;
            };
            facade.sendNotification(EventList.CLOSE_SELECTJOB);
            var _local3:int = ((SkillManager.SKILLID_Mediation * 100) + 1);
            SkillManager.MySkillListId.push(_local3);
            SkillManager.setMySkillList();
            var _local4 = SkillManager.getMyIdSkillInfo(_local3);
            if (_local4){
                (facade.retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager).autoAddItem(1, _local4, 7);
            };
        }
        private function updateOwnAchieveTitle(_arg1:NetPacket):void{
            var _local4:uint;
            GameCommonData.Player.Role.OwnTitles = [];
            var _local2:int;
            var _local3:int;
            while (_local3 < 8) {
                _local4 = _arg1.readUnsignedInt();
                _local2 = ((_local3 * 32) + 1);
                while (_local4 > 0) {
                    if ((_local4 & (1 == 1))){
                        GameCommonData.Player.Role.OwnTitles.push(_local2);
                    };
                    _local4 = (_local4 >> 1);
                    _local2++;
                };
                _local3++;
            };
            sendNotification(RoleEvents.UPDATE_ACHIEVETITLE);
        }
        private function permantinfo(_arg1:NetPacket):void{
            var _local5:uint;
            var _local2:uint;
            var _local3:int = _arg1.readInt();
            var _local4:uint = 1;
            if (_local3 != -1){
                _local4 = _arg1.readUnsignedInt();
                processPermantInfo(_local3, _local4);
            } else {
                _local5 = _arg1.readUnsignedInt();
                _local2 = 0;
                while (_local2 < _local5) {
                    _local4 = _arg1.readUnsignedInt();
                    processPermantInfo(_local3, _local4);
                    _local2++;
                };
            };
        }
        private function updateFashion():void{
            if ((GameCommonData.NewAndCharge & 8) == 0){
                RolePropDatas.isShowFashion = true;
                sendNotification(RoleEvents.UPDATE_FASHION_STATUS, true);
            } else {
                RolePropDatas.isShowFashion = false;
                sendNotification(RoleEvents.UPDATE_FASHION_STATUS, false);
            };
            if ((((GameCommonData.Player.Role.Level >= 21)) && (((GameCommonData.NewAndCharge & 16) == 0)))){
                facade.sendNotification(GetRewardEvent.SHOW_GIFREWARDBTN);
            } else {
                facade.sendNotification(GetRewardEvent.HIDE_GIFREWARDBTN);
            };
        }
        private function getRoleList(_arg1:NetPacket):void{
            var _local3:RoleVo;
            trace("connect gameserver success");
            if (GameCommonData.Tiao){
               // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("正在获取角色信息");
            };
            Logger.Info(this, "Processor", LanguageMgr.GetTranslation("开始获取角色信息"));
            GameCommonData.RoleList = new Array();
            GameCommonData.playformId = _arg1.readUnsignedInt();
            VerificationData.HasVerify = _arg1.readBoolean();
            VerificationData.VerifiySucess = _arg1.readBoolean();
            var _local2:int = _arg1.readUnsignedInt();
            var _local4:int;
            while (_local4 < _local2) {
                _local3 = new RoleVo();
                _local3.Index = _arg1.readUnsignedInt();
                _local3.UserId = _arg1.readUnsignedInt();
                _local3.Name = _arg1.ReadString();
                _local3.Level = _arg1.readUnsignedInt();
                _local3.Sex = _arg1.readUnsignedInt();
                _local3.Carrer = _arg1.readUnsignedInt();
                _local3.BannedTime = (_arg1.readUnsignedInt() * 1000);
                _local3.Photo = _arg1.readUnsignedInt();
                _local3.GuildId = _arg1.readUnsignedInt();
                _local3.GuildName = _arg1.ReadString();
                GameCommonData.RoleList.push(_local3);
                _local4++;
            };
            TestLogin.removeLogin();
            facade.registerMediator(new CreateRoleSimpleMediator());
            facade.registerMediator(new SelectRoleMediator());
            facade.registerProxy(new DataProxy());
            if (GameCommonData.RoleList.length == 0){
                facade.sendNotification(EventList.SHOWCREATEROLE, 0);
            } else {
                if (GameCommonData.RoleList.length >= 1){
                    facade.sendNotification(EventList.SHOWSELECTROLE);
                };
            };
        }
        private function enterRole(_arg1:NetPacket):void{
            var _local7:String;
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            if (_local3 != 0){
                _local7 = "";
                switch (_local3){
                    case 1:
                        _local7 = "创建会话对象失败";
                        break;
                    case 2:
                        _local7 = "读取数据失败";
                        break;
                    case 3:
                        _local7 = "延迟加入";
                        break;
                    case 4:
                        _local7 = "跨服战拿不到数据";
                        break;
                };
                if (ChgLineData.isChgLine){
                    MessageTip.popup(_local7);
                    MessageTip.show(_local7);
                };
                GameCommonData.GameNets.endGameNet();
                facade.sendNotification(EventList.SHOW_OFFLINETIP);
                return;
            };
            trace("进入成功");
            var _local4:int = _arg1.readUnsignedInt();
            var _local5:String = _arg1.ReadString();
            var _local6:int = _arg1.readUnsignedInt();
            GameConfigData.CurrentServerId = _local4;
            if (!ChgLineData.isChgLine){
                facade.sendNotification(EventList.REMOVESELECTROLE);
                facade.sendNotification(EventList.REMOVEALLCREATEROLE);
                facade.removeMediator(SelectRoleMediator.NAME);
                facade.removeMediator(CreateRoleSimpleMediator.NAME);
                UIConstData.RandomNameArr = [];
            };
            CharacterSend.getMyCharaterInfo();
            if (ChgLineData.isChgLine){
                GameCommonData.Player.Role.isStalling = 0;
            };
        }
        private function createRoleResult(_arg1:NetPacket):void{
            var _local3:int;
            var _local4:String;
            var _local5:uint;
            var _local6:String;
            var _local7:URLRequest;
            var _local8:URLLoader;
            var _local2:uint = _arg1.readUnsignedInt();
            if (_local2 == 0){
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.ReadString();
                _local5 = _arg1.readUnsignedInt();
                if (_local5 != 0){
                    _local6 = GameCommonData.LocalDirectory.slice(0, (GameCommonData.LocalDirectory.length - 5));
                    _local6 = (_local6 + ((("login_hoho/sdk/baidu/postcreatename.php?user_id=" + _local5) + "&role_name=") + _local4));
                    _local7 = new URLRequest(_local6);
                    _local7.method = URLRequestMethod.POST;
                    _local8 = new URLLoader();
                    _local8.load(_local7);
                };
                UIFacade.GetInstance().sendNotification(CommandList.CREATEOVER, {
                    ErrorType:_local2,
                    Index:_local3,
                    Name:_local4
                });
                trace("创建人物成功");
            } else {
                if (_local2 == 1){
                    CharacterSend.sendCurrentStep("角色创建失败,名字重复");
                    UIFacade.GetInstance().sendNotification(CommandList.CREATEOVER, {ErrorType:_local2});
                    trace("名字重复");
                } else {
                    if (_local2 == 2){
                        UIFacade.GetInstance().sendNotification(CommandList.CREATEOVER, {ErrorType:_local2});
                        trace("总数限制");
                    };
                };
            };
        }
        private function modifyRole(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:String = _arg1.ReadString();
            var _local5:String = _arg1.ReadString();
            if (GameCommonData.SameSecnePlayerList[_local2]){
                GameCommonData.SameSecnePlayerList[_local2].SetName(_local4);
                GameCommonData.SameSecnePlayerList[_local2].Role.Title = _local5;
                if (_local5 != ""){
                    GameCommonData.SameSecnePlayerList[_local2].SetTitle(_local5);
                } else {
                    GameCommonData.SameSecnePlayerList[_local2].HideTitle();
                };
                GameCommonData.SameSecnePlayerList[_local2].Role.Level = _local3;
            };
        }
        private function charRenameResult(_arg1:NetPacket):void{
            var _local2:uint = _arg1.readUnsignedInt();
            var _local3 = "";
            if (_local2 == 1){
                _local3 = _arg1.ReadString();
            };
            facade.sendNotification(EventList.SELECTROLE_CHARNAME_RESULT, {
                result:_local2,
                newName:_local3
            });
        }
        override public function Processor(_arg1:NetPacket):void{
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local2:int = _arg1.opcode;
            switch (_local2){
                case Protocol.SMSG_CHAR_ENUM:
                    getRoleList(_arg1);
                    break;
                case Protocol.SMSG_CHAR_CREATE:
                    createRoleResult(_arg1);
                    break;
                case Protocol.SMSG_ENTERGAME:
                    enterRole(_arg1);
                    break;
                case Protocol.SMSG_CHARINFO:
                    getMyUserInfo(_arg1);
                    break;
                case Protocol.SMSG_MONEYUPDATE:
                    updateMoney(_arg1);
                    break;
                case Protocol.SMSG_ACCOUNTMONEY:
                    _local3 = _arg1.readUnsignedInt();
                    _local4 = _arg1.readUnsignedInt();
                    GameCommonData.totalPayMoney = _local4;
                    _local5 = _arg1.readUnsignedInt();
                    GameCommonData.goldenAccountNeed = _local5;
                    if (GameCommonData.Player){
                        _local6 = GameCommonData.currAccountMoney;
                        GameCommonData.currAccountMoney = _local3;
                        if (_local3 > _local6){
                            facade.sendNotification(MarketEvent.FILL_MONEY_SUCESS);
                        };
                    } else {
                        GameCommonData.currAccountMoney = _local3;
                    };
                    break;
                case Protocol.SMSG_UPDATEGP:
                    updateExp(_arg1);
                    break;
                case Protocol.SMSG_CHOOSERPO_RESULT:
                    choostJobResult(_arg1);
                    break;
                case Protocol.SMSG_TIME_LIMIT_NOTICE:
                    break;
                case Protocol.SMSG_IDENTIFICATION:
                    break;
                case Protocol.SMSG_CREATURE_ALTER:
                    modifyRole(_arg1);
                    break;
                case Protocol.SMSG_GET_STH:
                    getRewardUpdate(_arg1);
                    break;
                case Protocol.SMSG_PERMANTINFO:
                    permantinfo(_arg1);
                    break;
                case Protocol.SMSG_TITLE_UPDATE:
                    updateOwnAchieveTitle(_arg1);
                    break;
                case Protocol.SMSG_KEEP_MERGE_ROLES_RESULT:
                    keepRoleResult(_arg1);
                    break;
                case Protocol.CMSG_CHAR_RENAME:
                    charRenameResult(_arg1);
                    break;
                case Protocol.SMSG_CHAR_NAMECHECK:
                    checkNameResult(_arg1);
                    break;
            };
        }
        private function updateExp(_arg1:NetPacket):void{
            var _local4:String;
            var _local5:GameElementAnimal;
            if (GameCommonData.Player == null){
                return;
            };
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:int = _arg1.readUnsignedInt();
            _local5 = GameCommonData.Player;
            _local5.Role.Exp = _local3;
            _local4 = ((_local5.Role.Exp + "/") + UIConstData.ExpDic[_local5.Role.Level]);
            GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {
                info:(((LanguageMgr.GetTranslation("获得") + ":") + _local2.toString()) + LanguageMgr.GetTranslation("经验")),
                color:0xFF0000
            });
            facade.sendNotification(EventList.UPDATE_MYATTRIBUATT, "Exp");
            facade.sendNotification(EventList.UPDATE_MAINSECEN_EXP);
            facade.sendNotification(EventList.ALLROLEINFO_UPDATE, {
                id:_local5.Role.Id,
                type:1001
            });
        }
        private function getRewardUpdate(_arg1:NetPacket):void{
        }
        private function processPermantInfo(_arg1:uint, _arg2:uint):void{
            var _local3:uint;
            var _local4:Object;
            var _local5:uint;
            var _local6:uint;
            var _local7:ActivityMediator;
            var _local8:uint;
            var _local9:ActivityMediator;
            switch (_arg1){
                case 15:
                    GameCommonData.Player.Role.loopTaskIdx = _arg2;
                    sendNotification(TaskCommandList.UPDATE_ACCTASK_UITREE);
                    break;
                case 17:
                    _local3 = _arg2;
                    _local4 = new Object();
                    _local4.offlineExp = _local3;
                    _local4.describe = "";
                    sendNotification(EventList.UPDATE_OFF_EXP, _local4);
                    sendNotification(EventList.CLOSE_OFFLINEEXP);
                    break;
                case 19:
                    _local5 = _arg2;
                    TaskCommonData.DivineResultTime = (TimeManager.Instance.Now().time + (_local5 * 1000));
                    sendNotification(TaskCommandList.UPDATE_DIVINE_REWARDTIME, TaskCommonData.DivineResultTime);
                    break;
                case 31:
                    GameCommonData.TowerMaxCount = _arg2;
                    break;
                case 14:
                    _local6 = _arg2;
                    sendNotification(GetRewardEvent.UPDATE_REWARD_RECORD, _local6);
                    sendNotification(TranscriptEvent.UPDATE_TOWERVIEW);
                    break;
                case 33:
                    GameCommonData.LoginDays = (_arg2 + 1);
                    sendNotification(EventList.HANDLE_ACTIVITY_BTN, 0);
                    _local7 = (facade.retrieveMediator(ActivityMediator.NAME) as ActivityMediator);
                    if (_local7 != null){
                        _local7.updateLoginDays();
                    };
                    break;
                case 32:
                    _local8 = GameCommonData.NewAndCharge;
                    GameCommonData.NewAndCharge = _arg2;
                    if ((((_local8 == 1)) && ((GameCommonData.NewAndCharge == 3)))){
                        sendNotification(EventList.HANDLE_ACTIVITY_BTN, 3);
                    } else {
                        sendNotification(EventList.HANDLE_ACTIVITY_BTN, 0);
                    };
                    updateFashion();
                    break;
                case 34:
                    GameCommonData.ReChargeCount = _arg2;
                    trace("充值", GameCommonData.ReChargeCount);
                    facade.sendNotification(EventList.UPDATE_RECHARGE_VIEW);
                    break;
                case 35:
                    GameCommonData.AccuChargeEnable = _arg2;
                    _local9 = (facade.retrieveMediator(ActivityMediator.NAME) as ActivityMediator);
                    if (_local9 != null){
                        _local9.enablleAccuCharge();
                    };
                    break;
                case 37:
                    facade.sendNotification(GetRewardEvent.UPDATE_REWARDRECORD, _arg2);
                    break;
                case 41:
                    GameCommonData.ConvoyQuality = _arg2;
                    break;
                case 70:
                    GameCommonData.activityData[70] = _arg2;
                    break;
                case 42:
                    GameCommonData.treasureSoul = _arg2;
                    facade.sendNotification(EquipCommandList.REFRESH_SACRIFICE_SOUL);
                    break;
                case 43:
                    GameCommonData.treasureCDTime = _arg2;
                    facade.sendNotification(EquipCommandList.REFRESH_SACRIFICE_CD_TIME);
                    break;
            };
        }
        private function updateMoney(_arg1:NetPacket):void{
            GameCommonData.Player.Role.Money = _arg1.readUnsignedInt();
            GameCommonData.Player.Role.Gold = _arg1.readUnsignedInt();
            GameCommonData.Player.Role.Gift = _arg1.readUnsignedInt();
            facade.sendNotification(EventList.UPDATEMONEY);
        }
        private function keepRoleResult(_arg1:NetPacket):void{
            var _local3:uint;
            var _local4:uint;
            var _local5:Array;
            var _local6:int;
            var _local2:Boolean = _arg1.readBoolean();
            if (_local2){
                _local5 = [];
                _local6 = 0;
                while (_local6 < 3) {
                    _local5.push({
                        guid:_arg1.readUnsignedInt(),
                        slot:_arg1.readUnsignedInt()
                    });
                    _local6++;
                };
                facade.sendNotification(EventList.UPDATE_ROLELIST, _local5);
            };
        }
        private function getMyUserInfo(_arg1:NetPacket):void{
            var _local3:int;
            var _local10:GameElementAnimal;
            var _local11:uint;
            if (GameCommonData.Player == null){
                GameCommonData.Player = new GameElementPlayer(GameCommonData.GameInstance);
                GameCommonData.Player.Role = new GameRole();
                GameCommonData.Player.Role.CurrentPlayer = GameCommonData.Player;
            };
            GameCommonData.Player.ActionPlayComplete = PlayerController.onActionPlayComplete;
            GameCommonData.Player.Role.readMyInfoPkg(_arg1);
            if (GameCommonData.SameSecnePlayerList){
                for each (_local10 in GameCommonData.SameSecnePlayerList) {
                    _local10.AllDispose();
                };
            };
            GameCommonData.SameSecnePlayerList = new Dictionary();
            if (GameCommonData.Tiao){
               // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("已获取玩家信息");
            };
            var _local2:Object = new Object();
            _local2.nSceneName = _arg1.readUnsignedInt();
            _local2.nMapId = _arg1.readUnsignedInt();
            _local2.nPosX = _arg1.readUnsignedShort();
            _local2.nPosY = _arg1.readUnsignedShort();
            GameCommonData.Player.Role.GMFlag = _arg1.readUnsignedInt();
            GameCommonData.Player.Role.PermanentRecord = _arg1.readUnsignedInt();
            GameCommonData.Player.Role.loopTaskIdx = _arg1.readUnsignedInt();
            GameCommonData.Player.Role.TileX = _local2.nPosX;
            GameCommonData.Player.Role.TileY = _local2.nPosY;
            GameCommonData.enterGameObj = _local2;
            if (GameCommonData.Tiao){
               // GameCommonData.Tiao.content_txt.text = LanguageMgr.GetTranslation("准备加载游戏资源");
            };
            if (GameCommonData.IsFirstLoadGame){
                if (GameCommonData.UICom){
                    new GameInit(GameCommonData.GameInstance);
                } else {
                    GameCommonData.UICom = true;
                };
            } else {
                GameCommonData.Scene = new SceneController(GameCommonData.enterGameObj.nSceneName.toString(), GameCommonData.enterGameObj.nMapId.toString());
            };
            _local3 = 0;
            while (_local3 < 51) {
                GameCommonData.activityData[_local3] = _arg1.readUnsignedInt();
                _local3++;
            };
            GameCommonData.Player.Role.FatigueValue = _arg1.readFloat();
            var _local4:Object = new Object();
            var _local5:uint = _arg1.readUnsignedInt();
            var _local6:uint = (_local5 / (2 * GameCommonData.Player.Role.Level));
            facade.registerMediator(new ActivityMediator());
            _local4.expOffLine = _local5;
            if (_local6 > 0){
                _local4.describe = ((((LanguageMgr.GetTranslation("离线") + int((_local6 / 60))) + LanguageMgr.GetTranslation("小时")) + (_local6 % 60)) + LanguageMgr.GetTranslation("分钟"));
            } else {
                _local4.describe = "";
            };
            sendNotification(EventList.UPDATE_OFF_EXP, _local4);
            GameCommonData.Player.Role.VIP = _arg1.readUnsignedInt();
            var _local7:uint = _arg1.readUnsignedInt();
            facade.registerMediator(new VipMediator());
            sendNotification(EventList.UPDATE_VIP_TIME, _local7);
            GameCommonData.Player.Role.OwnTitles = [];
            var _local8:int;
            _local3 = 0;
            while (_local3 < 8) {
                _local11 = _arg1.readUnsignedInt();
                _local8 = ((_local3 * 32) + 1);
                while (_local11 > 0) {
                    if ((_local11 & (1 == 1))){
                        GameCommonData.Player.Role.OwnTitles.push(_local8);
                    };
                    _local11 = (_local11 >> 1);
                    _local8++;
                };
                _local3++;
            };
            GameCommonData.TowerMaxCount = _arg1.readUnsignedInt();
            GameCommonData.LoginDays = (_arg1.readUnsignedInt() + 1);
            GameCommonData.NewAndCharge = _arg1.readUnsignedInt();
            GameCommonData.OwnerMainCity = _arg1.ReadString();
            updateFashion();
            GameCommonData.AccuChargeEnable = _arg1.readUnsignedInt();
            GameCommonData.ReChargeCount = _arg1.readUnsignedInt();
            var _local9:ActivityMediator = (facade.retrieveMediator(ActivityMediator.NAME) as ActivityMediator);
            if (_local9 != null){
                _local9.enablleAccuCharge();
            };
            GameCommonData.activityData[67] = _arg1.readUnsignedInt();
            GameCommonData.accuChargeId = _arg1.readUnsignedInt();
            GameCommonData.accuChargeLeftDay = _arg1.readUnsignedInt();
            sendNotification(EventList.UPDATE_ACCU_LEAFDAY, GameCommonData.accuChargeLeftDay);
            sendNotification(EventList.UPDATE_ACTIVITY, GameCommonData.activityData);
            GameCommonData.openServerDate = _arg1.readUnsignedInt();
            GameCommonData.RewardRecord = _arg1.readUnsignedInt();
            GameCommonData.ConvoyQuality = _arg1.readUnsignedInt();
            GameCommonData.activityData[70] = _arg1.readUnsignedInt();
            GameCommonData.treasureSoul = _arg1.readUnsignedInt();
            GameCommonData.treasureCDTime = _arg1.readUnsignedInt();
            GameCommonData.activityData[72] = _arg1.readUnsignedInt();
            _arg1.readUnsignedInt();
            _arg1.readUnsignedInt();
           // _arg1.readUnsignedInt();
            //_arg1.readUnsignedInt();
            //_arg1.readUnsignedInt();
            //GameCommonData.activityFlags = _arg1.readUnsignedInt();//geoffyan
            trace(GameCommonData.treasureSoul, GameCommonData.treasureCDTime);
        }
        private function deleteRoleResult(_arg1:NetPacket):void{
        }
        private function checkNameResult(_arg1:NetPacket):void{
            var _local2:int = _arg1.readUnsignedInt();
            var _local3:String = _arg1.ReadString();
            facade.sendNotification(EventList.CHECKROLENAME_RESULT, {
                result:_local2,
                name:_local3
            });
        }

    }
}//package Net.PackHandler 
