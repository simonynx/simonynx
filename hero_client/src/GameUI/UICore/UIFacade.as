//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.UICore {
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.NewGuide.UI.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import OopsFramework.Utils.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import flash.net.*;
    import Net.PackHandler.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.facade.*;
    import GameUI.Modules.TreasureChests.Data.*;
    import GameUI.Command.*;
    import GameUI.Modules.Pk.Data.*;
    import GameUI.Modules.Bag.Datas.*;
    import GameUI.Modules.Transcript.Data.*;
    import GameUI.Modules.ChangeLine.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.MainScene.Mediator.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.Buff.Data.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Relive.Data.*;
    import GameUI.Modules.SetView.Data.*;
    import GameUI.Modules.NewGuide.Command.*;
    import flash.ui.*;

    public class UIFacade extends Facade {

        public static const FACADEKEY:String = "UIFacade";

        public static var UIFacadeInstance:UIFacade;
        private static var IsCheckLackGold:Boolean = false;

        private var timer:OopsFramework.Utils.Timer;
        private var heartTurns:int;
        private var heartTime:int;

        public function UIFacade(_arg1:String){
            super(_arg1);
            timer = new OopsFramework.Utils.Timer();
            timer.DistanceTime = 300000;
        }
        public static function GetInstance():UIFacade{
            if (UIFacadeInstance == null){
                UIFacadeInstance = new UIFacade(FACADEKEY);
            };
            return (UIFacadeInstance);
        }
        public static function sendHeartPoint():void{
        }

        public function ShowExp(_arg1:String):void{
        }
        public function showPrompt(_arg1:String, _arg2:uint):void{
            sendNotification(HintEvents.RECEIVEINFO, {
                info:_arg1,
                color:_arg2
            });
        }
        public function closeOpenPanel():Boolean{
            var _local1:DataProxy = (retrieveProxy(DataProxy.NAME) as DataProxy);
            sendNotification(EventList.SHOWONLY, "");
            var _local2:Boolean;
            if (_local1.TeamIsOpen){
                sendNotification(EventList.REMOVETEAM);
                _local2 = true;
            };
            if (_local1.BagIsOpen){
                sendNotification(EventList.CLOSEBAG);
                _local2 = true;
            };
            if (_local1.ActivityViewIsOpen){
                sendNotification(EventList.CLOSE_ACTIVITY);
                _local2 = true;
            };
            if (_local1.SenceMapIsOpen){
                sendNotification(EventList.CLOSESCENEMAP);
                _local2 = true;
            };
            if (_local1.GMMailIsOpen){
                sendNotification(EventList.CLOSE_GMMAIL_UI);
                _local2 = true;
            };
            if (_local1.MailIsOpen){
                sendNotification(EventList.CLOSEMAIL);
                _local2 = true;
            };
            if (_local1.SetviewIsOpen){
                sendNotification(SetViewEvent.HIDE_SETVIEW);
                _local2 = true;
            };
            if (_local1.FriendsIsOpen){
                sendNotification(FriendCommandList.HIDEFRIEND);
                _local2 = true;
            };
            if (_local1.UnityIsOpen){
                sendNotification(EventList.CLOSEUNITYVIEW);
                _local2 = true;
            };
            if (_local1.NewSkillIsOpen){
                sendNotification(EventList.CLOSESKILLVIEW);
                _local2 = true;
            };
            if (_local1.GoldLeafViewIsOpen){
                sendNotification(EventList.CLOSE_GOLDLEAFVIEW);
                _local2 = true;
            };
            if (_local1.AllInfoMsgIsOpen){
                sendNotification(ScreenMessageEvent.CLOSE_MESSAGE);
                _local2 = true;
            };
            if (_local1.TreasureViewIsOpen){
                sendNotification(TreasureEvent.CLOSE_TREASURE);
                _local2 = true;
            };
            if (_local1.RankIsOpen){
                sendNotification(EventList.CLOSE_RANK);
                _local2 = true;
            };
            if (_local1.OffLineExpIsOpen){
                sendNotification(EventList.CLOSE_OFFLINEEXP);
                _local2 = true;
            };
            if (_local1.VipIsOpen){
                sendNotification(EventList.CLOSE_VIP);
                _local2 = true;
            };
            if (_local1.GameTargetViewIsOpen){
                sendNotification(EventList.CLOSE_TARGET);
                _local2 = true;
            };
            if (_local1.NPCShopIsOpen){
                sendNotification(EventList.CLOSENPCSHOPVIEW);
                _local2 = true;
            };
            if (_local1.NPCExchangeIsOpen){
                sendNotification(EventList.CLOSENPCEXCHANGEVIEW);
                _local2 = true;
            };
            if (_local1.ConvoyIsOpen){
                sendNotification(EventList.CLOSE_CONVOY_UI);
                _local2 = true;
            };
            if (_local1.CSBPanelIsOpen){
                sendNotification(EventList.CLOSE_CSBPANEL);
                _local2 = true;
            };
            if (_local1.EntrustIsOpen){
                sendNotification(EventList.CLOSE_ENTRUST_UI);
            };
            if (GameCommonData.NPCDialogIsOpen){
                UIFacade.GetInstance().changeNpcWin(3);
                _local2 = true;
            };
            if (_local1.AchieveIsOpen){
                sendNotification(EventList.CLOSE_ACHIEVEVIEW);
                _local2 = true;
            };
            _local2 = ((SmallConstData.getInstance().onCloseEquipStreng()) || (_local2));
            if (_local1.TowerViewIsOpen){
                sendNotification(TranscriptEvent.SHOW_TOWER_VIEW);
                _local2 = true;
            };
            if (_local1.PetRaceIsOpen){
                sendNotification(EventList.CLOSE_PETRACE);
                _local2 = true;
            };
            if (_local1.OpenItemBoxIsOpen){
                sendNotification(EventList.CLOSE_OPENITEMBOX_UI);
                _local2 = true;
            };
            if (GameCommonData.IsTESLSetTrap){
                sendNotification(TranscriptEvent.TESL_CANCEL_SETTRAP);
                _local2 = true;
            };
            if (_local1.CSBBagIsOpen){
                sendNotification(EventList.CSB_CLOSECSBBAG);
                _local2 = true;
            };
            if (_local1.occupationIntroIsOpen){
                sendNotification(Guide_OccupationIntro_Command.NAME, {type:3});
                _local2 = true;
            };
            if (_local1.GradeBibleIsOpen){
                sendNotification(EventList.CLOSE_UPGRADE_BIBLE);
                _local2 = true;
            };
            return (_local2);
        }
        public function removeRelive():void{
            sendNotification(ReliveEvent.REMOVERELIVE);
        }
        public function selectStall(_arg1:int):void{
            sendNotification(EventList.GETSTALLITEMS, _arg1);
        }
        public function LackofGift():void{
            var funObj:* = new Object();
            var confirm:* = function ():void{
            };
            var cancel:* = function ():void{
            };
            funObj.comfrim = confirm;
            funObj.cancel = cancel;
            funObj.info = LanguageMgr.GetTranslation("礼券不足");
            sendNotification(EventList.SHOWALERT, funObj);
        }
        public function selectedTask(_arg1:uint):void{
        }
        public function openHelpView():void{
        }
        public function ShowHint(_arg1:String, _arg2:int=0xFFFF00):void{
            this.sendNotification(HintEvents.RECEIVEINFO, {
                info:_arg1,
                color:_arg2
            });
        }
        override protected function initializeController():void{
            super.initializeController();
            this.registerCommand(CommandList.STARTUP, StartupCommand);
            this.registerCommand(CommandList.STARTUPROLE, StartupCommandRole);
        }
        public function changePath(_arg1:uint=0):void{
            sendNotification(EventList.UPDATE_SMALLMAP_PATH, _arg1);
        }
        public function changeNpcWin(_arg1:uint, _arg2:uint=0):void{
            var _local3:String;
            var _local4:GameElementAnimal;
            switch (_arg1){
                case 1:
                    if (_arg2 != 0){
                        sendNotification(EventList.SELECTED_NPC_ELEMENT, {npcId:_arg2});
                    } else {
                        for (_local3 in GameCommonData.SameSecnePlayerList) {
                            if (GameCommonData.SameSecnePlayerList[_local3].Role.MonsterTypeID == GameCommonData.targetID){
                                GameCommonData.targetID = GameCommonData.SameSecnePlayerList[_local3].Role.Id;
                                break;
                            };
                        };
                        if (((((GameCommonData.SameSecnePlayerList[GameCommonData.targetID]) && (!((GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.Type == GameRole.TYPE_OWNER))))) && (!((GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.Type == GameRole.TYPE_PLAYER))))){
                            if (GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.Type == GameRole.TYPE_NPC){
                                TargetController.SetTarget(GameCommonData.SameSecnePlayerList[GameCommonData.targetID]);
                                selectPlayer();
                                GameCommonData.Scene.HelloNPC(GameCommonData.TargetAnimal);
                            } else {
                                if (GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.Type == GameRole.TYPE_ENEMY){
                                    _local4 = PlayerController.FindNearestAnimalByType(GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.MonsterTypeID);
                                    if (_local4){
                                        TargetController.SetTarget(_local4);
                                        GameCommonData.Scene.Attack(GameCommonData.TargetAnimal);
                                        selectPlayer();
                                    };
                                } else {
                                    if (GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.Type == GameRole.TYPE_COLLECT){
                                        TargetController.SetTarget(PlayerController.FindNearestAnimalByType(GameCommonData.SameSecnePlayerList[GameCommonData.targetID].Role.MonsterTypeID));
                                        GameCommonData.Scene.HelloNPC(GameCommonData.TargetAnimal);
                                        selectPlayer();
                                    };
                                };
                            };
                        } else {
                            UIFacade.GetInstance().sendNotification(TaskTextCommand.NAME, {
                                type:"MOVE",
                                text:GameCommonData.TaskTargetCommand
                            });
                        };
                        GameCommonData.TaskTargetCommand = "";
                    };
                    break;
                case 3:
                    sendNotification(EventList.CLOSE_NPC_ALL_PANEL);
                    break;
            };
        }
        public function showPksceneTips(_arg1:int, _arg2:int):void{
            sendNotification(PkEvent.PKSCENETIPS_SHOW, {
                TitleX:_arg1,
                TitleY:_arg2
            });
        }
        public function showRelive():void{
            sendNotification(ReliveEvent.SHOWRELIVE);
        }
        public function StartUp():void{
            this.sendNotification(CommandList.STARTUP);
        }
        public function GetKeyCode(_arg1:int):void{
            var _local2:Object;
            var _local3:Object;
            var _local4:uint;
            var _local7:Boolean;
            var _local8:Array;
            var _local9:int;
            var _local5:MainSceneMediator = (retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator);
            var _local6:DataProxy = (retrieveProxy(DataProxy.NAME) as DataProxy);
            switch (_arg1){
                case 67:
                    _local5.useQuickBtn(0);
                    sendNotification(EventList.SETHEROVIEWPOS, 0);
                    break;
                case 66:
                    _local5.useQuickBtn(4);
                    break;
                case 83:
                    _local5.useQuickBtn(1);
                    break;
                case 81:
                    if (!_local6.TaskIsOpen){
                        sendNotification(EventList.SHOWTASKVIEW);
                    } else {
                        sendNotification(EventList.CLOSETASKVIEW);
                    };
                    break;
                case 85:
                    if (_local6.MarketIsOpen){
                        sendNotification(EventList.CLOSEMARKETVIEW);
                        sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    } else {
                        sendNotification(EventList.SHOWMARKETVIEW);
                    };
                    break;
                case 70:
                    _local5.useQuickBtn(5);
                    break;
                case 72:
                    if (GameCommonData.ModuleCloseConfig[2] == 1){
                        break;
                    };
                    if (GameCommonData.Player.Role.Level < 31){
                        GuidePicFrame.show(GuidePicFrame.TYPE_SHILIAN);
                        return;
                    };
                    sendNotification(TranscriptEvent.SHOW_TOWER_VIEW);
                    GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    break;
                case 74:
                    if (GameCommonData.ModuleCloseConfig[5] == 1){
                        break;
                    };
                    if (_local6.GoldLeafViewIsOpen){
                        sendNotification(EventList.CLOSE_GOLDLEAFVIEW);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    } else {
                        sendNotification(EventList.SHOW_GOLDLEAFVIEW);
                    };
                    break;
                case 75:
                    if (GameCommonData.ModuleCloseConfig[1] == 1){
                        break;
                    };
                    if (_local6.PetRaceIsOpen){
                        sendNotification(EventList.CLOSE_PETRACE);
                    } else {
                        sendNotification(EventList.SHOW_PETRACE);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    };
                    break;
                case 84:
                    _local5.useQuickBtn(7);
                    break;
                case 79:
                    _local5.useQuickBtn(6);
                    break;
                case 69:
                    if (!_local6.MailIsOpen){
                        this.sendNotification(EventList.SHOWMAIL);
                    } else {
                        this.sendNotification(EventList.CLOSEMAIL);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    };
                    break;
                case 77:
                    if (_local6.SenceMapIsOpen){
                        this.sendNotification(EventList.CLOSESCENEMAP);
                    } else {
                        this.sendNotification(EventList.SHOWSENCEMAP);
                    };
                    break;
                case 80:
                    if (_local6.RankIsOpen){
                        sendNotification(EventList.CLOSE_RANK);
                        sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    } else {
                        sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "rank");
                        sendNotification(EventList.SHOW_RANK);
                    };
                    break;
                case 82:
                    sendNotification(PlayerInfoComList.QUICK_TRADE);
                    break;
                case 76:
                    _local5.useQuickBtn(0);
                    sendNotification(EventList.SETHEROVIEWPOS, 1);
                    break;
                case 87:
                    _local5.useQuickBtn(2);
                    break;
                case 75:
                    break;
                case 68:
                    if (!_local6.AchieveIsOpen){
                        sendNotification(EventList.SHOW_ACHIEVEVIEW);
                    } else {
                        sendNotification(EventList.CLOSE_ACHIEVEVIEW);
                    };
                    break;
                case 86:
                    break;
                case 88:
                    break;
                case 78:
                    if (_local6.ConvoyIsOpen){
                        MessageTip.show(LanguageMgr.GetTranslation("接运镖任务时无法进行铸造"));
                        return;
                    };
                    _local7 = false;
                    if (_local6.ForgeOpenFlag > 0){
                        _local7 = true;
                    };
                    if (_local7){
                        sendNotification(EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    } else {
                        sendNotification(EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI);
                    };
                    break;
                case 90:
                    _local8 = [];
                    if ((getTimer() - GameConfigData.MountPressTime) < 3000){
                        break;
                    };
                    if (GameCommonData.Player.Role.Level < 18){
                        MessageTip.show(LanguageMgr.GetTranslation("等级不够无法用"));
                        break;
                    };
                    if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT] == null){
                        MessageTip.show(LanguageMgr.GetTranslation("请先装备坐骑"));
                    } else {
                        if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT].isBroken){
                            MessageTip.show(LanguageMgr.GetTranslation("坐骑已破损"));
                        } else {
                            _local9 = int(GameCommonData.GameInstance.GameScene.GetGameScene.name);
                            if ((((((_local9 >= 2000)) && ((_local9 <= 5001)))) || (MapManager.isInParty()))){
                                return;
                            };
                            if (GameCommonData.Player.Role.IsAttack){
                                MessageTip.popup(LanguageMgr.GetTranslation("战斗中无法使用坐骑"));
                            } else {
                                BagInfoSend.ItemUse((RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT] as InventoryItemInfo).ItemGUID);
                            };
                        };
                    };
                    break;
                case 65:
                    if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                        sendNotification(AutoPlayEventList.QUICK_AUTO_PLAY);
                    } else {
                        UIFacade.GetInstance().ShowHint(LanguageMgr.GetTranslation("您还未装备上神兵"));
                    };
                    break;
                case 71:
                    if (_local6.ActivityViewIsOpen){
                        sendNotification(EventList.CLOSE_ACTIVITY);
                        GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    } else {
                        sendNotification(EventList.SHOW_ACTIVITY);
                    };
                    break;
                case 73:
                    if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                        sendNotification(AutoPlayEventList.QUICK_AUTO_SET);
                    } else {
                        UIFacade.GetInstance().ShowHint(LanguageMgr.GetTranslation("您还未装备上神兵"));
                    };
                    break;
                case Keyboard.ESCAPE:
                    sendNotification(EventList.CLOSE_NPC_ALL_PANEL);
                    if (!UIFacade.GetInstance().closeOpenPanel()){
                        _local5.useQuickBtn(8);
                    };
                    break;
                case Keyboard.F12:
                    if (_local6.screenAll){
                        ScreenController.ScreenAll();
                        _local6.screenAll = false;
                        sendNotification(PlayerInfoComList.SCREEN_ALL_NAME, LanguageMgr.GetTranslation("显示玩家"));
                    } else {
                        ScreenController.ScreenNone();
                        _local6.screenAll = true;
                        sendNotification(PlayerInfoComList.SCREEN_ALL_NAME, LanguageMgr.GetTranslation("屏蔽玩家"));
                    };
                    break;
                case Keyboard.F8:
                    break;
                case Keyboard.ENTER:
                    this.sendNotification(EventList.KEYBORADEVENT, _arg1);
                    break;
                case Keyboard.SPACE:
                    AutomatismController.FindPickItem(false);
                    break;
            };
        }
        public function showBigMap():void{
            this.sendNotification(EventList.SHOWBIGMAP);
        }
        public function Resize():void{
            sendNotification(EventList.RESIZE_STAGE);
        }
        public function openRank():void{
        }
        public function updateSmallMap(_arg1:Object):void{
            sendNotification(EventList.UPDATE_SMALLMAP_DATA, _arg1);
        }
        public function LackofGold():void{
            var _local1:String;
            MessageTip.popup((("<font color='#FFFF00'>" + LanguageMgr.GetTranslation("金币不足可去寄卖行收购")) + "</font>"));
            if (IsCheckLackGold == false){
                _local1 = LanguageMgr.GetTranslation("金币不足可去商城购买钱袋句");
                sendNotification(HelpTipsNotiName.HELPTIPS_MMSHOW, {
                    content:_local1,
                    align:TextFormatAlign.LEFT,
                    title:LanguageMgr.GetTranslation("提示")
                });
                IsCheckLackGold = true;
            };
        }
        public function showNoMoveInfo(_arg1:int):void{
            switch (_arg1){
                case 1:
                    sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易时无法移动"),
                        color:0xFFFF00
                    });
                    break;
                case 2:
                    sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("摆摊时无法移动"),
                        color:0xFFFF00
                    });
                    break;
            };
        }
        public function dragItem(_arg1:Object):void{
            var _local2:QuickSkillManager = (retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
            _local2.addUseItem(_arg1);
        }
        public function LackofGoldLeaf():void{
            var funObj:* = new Object();
            var confirm:* = function ():void{
                if (GameConfigData.GamePay != ""){
                    navigateToURL(new URLRequest(GameConfigData.GamePay), "_blank");
                };
            };
            var cancel:* = function ():void{
            };
            funObj.comfrim = confirm;
            funObj.cancel = cancel;
            funObj.info = LanguageMgr.GetTranslation("金叶子不足充值么");
            sendNotification(EventList.SHOWALERT, funObj);
        }
        private function delayFn(_arg1:String):void{
        }
        public function chgLineSuc():void{
            sendNotification(ChgLineData.CHG_LINE_SUC);
        }
        public function PickItem(_arg1:Object):void{
            if (GameCommonData.Player.Role.canPickItem != true){
                ShowHint(LanguageMgr.GetTranslation("中了状态无法拾取"));
            };
            var _local2:ItemTemplateInfo = UIConstData.ItemDic[_arg1.items];
            var _local3:int;
            if (_local2.MainClass == ItemConst.ITEM_CLASS_MATERIAL){
                _local3 = 1;
            };
            if (((!(ItemConst.IsGold(_arg1.target.info))) && (BagData.isBagFullByItemId(_arg1.target.info.type)))){
                sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("背包已满提示句"),
                    color:0xFF0000
                });
                return;
            };
            var _local4:DragItem = GameCommonData.PackageList[_arg1.id];
            if (!_local4){
                return;
            };
            if (((((!((_local4.OwnerGUID == 0))) && (!((_local4.OwnerGUID == GameCommonData.Player.Role.Id))))) && (((TimeManager.Instance.Now().time * 0.001) < _local4.OwnerTime)))){
                sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("他人掉落等会可拾"),
                    color:0xFF0000
                });
                return;
            };
            if (_local4){
                _local4.isPicked = true;
                PlayerActionSend.SendPickItem(_arg1.id);
            };
        }
        public function changeBuffStatus(_arg1:uint, _arg2:uint=0, _arg3:GameSkillBuff=null):void{
            if (_arg2 == 0){
                sendNotification(EventList.ALLROLEINFO_UPDATE, {
                    id:GameCommonData.Player.Role.Id,
                    type:1001
                });
                switch (_arg1){
                    case 1:
                        this.sendNotification(BuffEvent.ADDBUFF, _arg3);
                        break;
                    case 2:
                        this.sendNotification(EventList.SHOWBUFF, _arg3);
                        break;
                    case 3:
                        this.sendNotification(BuffEvent.DELETEBUFF, _arg3);
                        break;
                    case 4:
                        this.sendNotification(BuffEvent.ADDDEBUFF, _arg3);
                        break;
                    case 5:
                        this.sendNotification(EventList.SHOWDEBUFF, _arg3);
                        break;
                    case 6:
                        this.sendNotification(BuffEvent.DELETEDEBUFF, _arg3);
                        break;
                    case 7:
                        this.sendNotification(BuffEvent.UPDATE_BUFF_TIME, _arg3);
                        break;
                    case 8:
                        this.sendNotification(BuffEvent.CLEAR_ALL_BUFF);
                        break;
                };
            } else {
                sendNotification(EventList.ALLROLEINFO_UPDATE, {
                    id:_arg2,
                    type:1001
                });
            };
        }
        public function isLookStall():Boolean{
            return (false);
        }
        public function selectTeam(_arg1:GameRole):void{
        }
        public function DeletePackage(_arg1:uint):void{
        }
        public function gameHeartPoint(_arg1:GameTime, _arg2:uint=0):void{
        }
        public function selectPlayer():void{
            if (GameCommonData.TargetAnimal){
                if (GameCommonData.TargetAnimal.Role.Type == GameRole.TYPE_COLLECT){
                    this.sendNotification(PlayerInfoComList.HIDE_COUNTERWORKER_UI);
                    this.sendNotification(PlayerInfoComList.SELECT_ELEMENT_COLLECT, GameCommonData.TargetAnimal);
                } else {
                    this.sendNotification(PlayerInfoComList.HIDE_COLLECTIONWORKERINFO_UI);
                    this.sendNotification(PlayerInfoComList.SELECT_ELEMENT, GameCommonData.TargetAnimal.Role);
                };
            } else {
                this.sendNotification(PlayerInfoComList.HIDE_COUNTERWORKER_UI);
            };
            UIFacade.GetInstance().sendNotification(BagEvents.CANCEL_TASKITEM_USE);
        }
        public function upDateInfo(_arg1:uint=0, _arg2:int=-1):void{
            sendNotification(EventList.ALLROLEINFO_UPDATE, {
                type:_arg1,
                id:_arg2
            });
        }
        public function dragSkillItem(_arg1:Object):void{
            var _local2:QuickSkillManager = (retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
            _local2.addSkillItem(_arg1);
        }

    }
}//package GameUI.UICore 
