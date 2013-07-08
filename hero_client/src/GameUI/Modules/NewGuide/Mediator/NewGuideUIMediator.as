//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Mediator {
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.Modules.NewGuide.UI.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.HButton.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.Unity.Data.*;
    import OopsEngine.AI.PathFinder.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.NPCExchange.Mediator.*;
    import Net.RequestSend.*;
    import GameUI.Modules.MainScene.Mediator.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Pet.Mediator.*;
    import GameUI.Modules.AutoPlay.mediator.*;
    import GameUI.Modules.NPCChat.Mediator.*;
    import GameUI.Modules.HeroSkill.Mediator.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.NewInfoTip.Command.*;

    public class NewGuideUIMediator extends Mediator {

        public static const NAME:String = "NewGuideUIMediator";

        private static var PointingItemTempleteId:int;

        private var pointTarget:DisplayObject;
        private var guideFrame:GuideFrame;

        public function NewGuideUIMediator(){
            super(NAME);
        }
        public function hideJianTouUI():void{
            JianTouMc.getInstance().close();
        }
        public function resize():void{
            doGuide(NewGuideData.curType, NewGuideData.curStep, pointTarget);
            if (guideFrame){
                guideFrame.x = ((GameCommonData.GameInstance.ScreenWidth - guideFrame.frameWidth) / 2);
                guideFrame.y = ((GameCommonData.GameInstance.ScreenHeight - guideFrame.frameHeight) / 2);
            };
        }
        public function Guide_Exchange(_arg1:int, _arg2:Object):void{
            var npcId:* = undefined;
            var npcPlayer:* = null;
            var idx:* = null;
            var target:* = null;
            var itemGridUnit:* = null;
            var jt:* = null;
            var step:* = _arg1;
            var data:* = _arg2;
            switch (step){
                case 1:
                    npcId = int(data["npcId"]);
                    for (idx in GameCommonData.SameSecnePlayerList) {
                        if ((((GameCommonData.SameSecnePlayerList[idx] is GameElementNPC)) && ((GameCommonData.SameSecnePlayerList[idx].Role.MonsterTypeID == npcId)))){
                            npcPlayer = GameCommonData.SameSecnePlayerList[idx];
                            break;
                        };
                    };
                    if (npcPlayer == null){
                        return;
                    };
                    if (UnityConstData.contributeIsOpen == true){
                        facade.sendNotification(UnityEvent.HIDE_GUILDDONATEPANEL);
                    };
                    if (NPCExchangeConstData.goodList[npcPlayer.Role.MonsterTypeID] == null){
                        sendNotification(NPCChatComList.SEND_NPC_MSG, {
                            npcId:npcPlayer.Role.Id,
                            linkId:0
                        });
                    } else {
                        facade.registerMediator(new NPCExchangeMediator());
                        sendNotification(EventList.SHOWNPCEXCHANGEVIEW, {
                            npcId:npcPlayer.Role.Id,
                            shopName:npcPlayer.Role.Name
                        });
                    };
                    break;
                case 2:
                    target = data["target"];
                    itemGridUnit = data["itemGridUnit"];
                    jt = JianTouMc.getInstance().show(target, LanguageMgr.GetTranslation("点击兑换<br>星辰碎片"), 3, itemGridUnit.getBounds(itemGridUnit.stage));
                    jt.autoClickClean = true;
                    jt.clickCallBack = function ():void{
                        facade.sendNotification(EventList.CLOSENPCEXCHANGEVIEW);
                        facade.sendNotification(EventList.CLOSEBAG);
                        facade.sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[TaskCommonData.LoopBaseTaskId]);
                    };
                    break;
            };
        }
        private function findBagItem(_arg1:int):DisplayObject{
            var _local2:int;
            var _local3:int;
            var _local4:DisplayObject;
            var _local5:Object;
            while (_local2 < BagData.AllItems.length) {
                _local3 = 0;
                while (_local3 < BagData.AllItems[_local2].length) {
                    _local5 = BagData.AllItems[_local2][_local3];
                    if (BagData.AllItems[_local2][_local3] == undefined){
                    } else {
                        if (_arg1 == (BagData.AllItems[_local2][_local3] as InventoryItemInfo).TemplateID){
                            _local4 = BagData.GridUnitList[BagData.SelectIndex][(_local3 % BagData.MAX_GRIDS)].Item;
                            break;
                        };
                    };
                    _local3++;
                };
                _local2++;
            };
            return (_local4);
        }
        public function Guide_PointBag(_arg1:Object):void{
            var _local6:DisplayObject;
            var _local8:DisplayObject;
            var _local9:JianTouMc;
            var _local10:DisplayObject;
            var _local2:Array = [];
            if (_arg1.itemId){
                _local2[0] = _arg1.itemId;
            } else {
                if (_arg1.itemIdArr){
                    _local2 = _arg1.itemIdArr;
                };
            };
            var _local3 = "";
            var _local4:Boolean;
            if (_arg1.tipsTxt){
                _local3 = _arg1.tipsTxt;
            };
            if (_arg1.isJT != undefined){
                _local4 = _arg1.isJT;
            };
            var _local5:Array = [];
            var _local7:int;
            while (_local7 < _local2.length) {
                _local8 = findBagItem(_local2[_local7]);
                if (_local8){
                    if ((((_local6 == null)) || ((_local6.x < _local8.x)))){
                        _local6 = _local8;
                        PointingItemTempleteId = _local2[_local7];
                    };
                    _local5.push(_local8.getBounds(_local8.stage));
                };
                _local7++;
            };
            if (_local6){
                _local9 = JianTouMc.getInstance(JianTouMc.TYPE_USEBAGITEM).show(_local6, _local3, 4, _local5);
                _local10 = (facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.getContent();
                _local9.setJTToTargetPostion(_local10);
                _local9.jtMc.visible = _local4;
            };
        }
        public function Guide_PetRace(_arg1:int, _arg2:Object):void{
            var _local3:MovieClip;
            var _local4:Sprite;
            switch (_arg1){
                case 1:
                    _local3 = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_9"];
                    _local3.mcFlash.play();
                    _local3.mcFlash.visible = true;
                    JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("点击打开宠物争霸面板"), 3);
                    break;
                case 2:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("报名挑战"), 2);
                    JianTouMc.getInstance().closeBtn().visible = true;
                    break;
                case 3:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("请输入队伍名字某条件点确认"), 2);
                    break;
                case 4:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("我的队伍"), 2);
                    break;
                case 5:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("配置组员"), 2);
                    break;
                case 6:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("调用该宠物"), 2);
                    break;
                case 7:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("确定使用该宠物"), 2);
                    break;
                case 8:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("保存配置"), 2);
                    break;
                case 9:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("点击积分赛页面"), 2);
                    break;
                case 10:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("切换可挑战队伍页面"), 2);
                    break;
                case 11:
                    _local4 = _arg2["target"];
                    JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("挑战对手"), 2);
                    break;
                default:
                    JianTouMc.getInstance().close();
            };
        }
        private function doTask_10(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_11(_arg1:int):void{
            var _local2:TaskText;
            var _local3:InventoryItemInfo;
            var _local4:QuickSkillManager;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
                case 2:
                    _local3 = BagData.getItemByType(NewGuideData.ITEMTEMPID_MPYAO_SMALL);
                    if (_local3){
                        _local4 = (UIFacade.GetInstance().retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
                        _local4.autoAddItem(0, _local3, 7);
                    };
                    break;
            };
        }
        private function doTask_12(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_13(_arg1:int):void{
            var taskText:* = null;
            var step:* = _arg1;
            switch (step){
                case 1:
                    taskText = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(taskText, "", 2, GetRecBoundToFollowTree(taskText));
                    break;
                case 2:
                    JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("点击进入副本"), 2);
                    break;
                case 5:
                    if (GameCommonData.TaskInfoDic[NewGuideData.TASK_13].Conditions[1].IsComplete){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:13,
                            STEP:6
                        });
                        break;
                    };
                    taskText = GetPointFromFollowTree(1);
                    JianTouMc.getInstance().show(taskText, "", 2, GetRecBoundToFollowTree(taskText));
                    break;
                case 6:
                    taskText = GetPointFromFollowTree(2);
                    JianTouMc.getInstance().show(taskText, "", 2, GetRecBoundToFollowTree(taskText));
                    break;
                case 7:
                    if (NewGuideData.IsShowEd_GuildPick){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                        return;
                    };
                    if (((guideFrame) && (guideFrame.parent))){
                        guideFrame.close();
                    };
                    guideFrame = new GuideFrame(4);
                    guideFrame.x = ((GameCommonData.GameInstance.ScreenWidth - guideFrame.frameWidth) / 2);
                    guideFrame.y = ((GameCommonData.GameInstance.ScreenHeight - guideFrame.frameHeight) / 2);
                    guideFrame.show();
                    NewGuideData.IsShowEd_GuildPick = true;
                    guideFrame.okFun = function ():void{
                        var _local1:TaskText;
                        JianTouMc.getInstance().close();
                        if (GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsComplete){
                            sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                        } else {
                            _local1 = GetPointFromFollowTree(1);
                            JianTouMc.getInstance().show(_local1, "", 2, GetRecBoundToFollowTree(_local1));
                        };
                    };
                    JianTouMc.getInstance().show(guideFrame.okBtn, "", 2);
                    break;
                case 8:
                    taskText = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(taskText, "", 2);
                    break;
                case 9:
                    JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("点击离开副本"), 2).autoClickClean = true;
                    break;
                case 10:
                    taskText = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(taskText, "", 2, GetRecBoundToFollowTree(taskText));
                    break;
            };
        }
        private function doTask_14(_arg1:int):void{
            var _local2:TaskText;
            var _local3:int;
            var _local4:GameElementAnimal;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
                case 2:
                    for each (_local4 in GameCommonData.SameSecnePlayerList) {
                        if (((((_local4) && ((_local4 is GameElementNPC)))) && ((_local4.Role.MonsterTypeID == 1011)))){
                            _local3 = _local4.Role.Id;
                        };
                    };
                    if (_local3 > 0){
                        sendNotification(TaskCommandList.SHOW_TASKINFO_UI, {
                            taskId:NewGuideData.TASK_15,
                            npcId:_local3,
                            npcName:LanguageMgr.GetTranslation("诺亚")
                        });
                    };
                    break;
            };
        }
        private function doTask_15(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("点击将自动寻径至对应职业登记人处"), 2, _local2.getBounds(_local2.stage));
                    break;
                case 2:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_16(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_17(_arg1:int):void{
            var _local2:DataProxy;
            var _local3:SimpleButton;
            switch (_arg1){
                case 1:
                    _local2 = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    if (((_local2) && (!(_local2.NewSkillIsOpen)))){
                        facade.sendNotification(EventList.SHOWONLY, "skill");
                        _local2.NewSkillIsOpen = true;
                        facade.sendNotification(EventList.SHOWSKILLVIEW);
                    };
                    break;
                case 2:
                    if (((pointTarget) && (pointTarget.stage))){
                        JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("点击学习技能"), 1, pointTarget.getBounds(pointTarget.stage)).setJTToTargetPostion(pointTarget.parent);
                    };
                    break;
                case 3:
                    _local3 = (facade.retrieveMediator(NewSkillMediator.NAME) as NewSkillMediator).getCloseBtn();
                    if (_local3){
                        JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("点击关闭技能面板"), 1).setJTToTargetPostion(_local3.parent);
                    };
                    break;
                case 4:
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_17]);
                    break;
            };
        }
        private function doTask_18(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_19(_arg1:int):void{
            var _local2:SimpleButton;
            var _local3:MovieClip;
            switch (_arg1){
                case 1:
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_22]);
                    break;
                case 2:
                    if (!this.dataProxy.autoPlayIsOpen){
                        _local2 = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["hammerBtn"];
                        JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("请点击打开神兵面板"), 3).setJTToTargetPostion(_local2.parent);
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:19,
                            STEP:6
                        });
                    };
                    break;
                case 6:
                    if (!GameCommonData.Player.IsAutomatism){
                        _local3 = (UIFacade.GetInstance().retrieveMediator(AutoPlayMediator.NAME) as AutoPlayMediator).guide_autoPlayBtn();
                        if (_local3){
                            JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("左键点击开始自动挂机"), 3).setJTToTargetPostion(_local3.parent);
                        };
                    } else {
                        JianTouMc.getInstance().close();
                    };
                    break;
                case 7:
                    JianTouMc.getInstance().close();
                    break;
                case 9:
                    JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("当前神兵经验值已满，点击升级神兵"), 1).setJTToTargetPostion(pointTarget.parent);
                    break;
                case 10:
                    JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("点击关闭界面"), 1).setJTToTargetPostion(pointTarget.parent);
                    break;
                case 11:
                    JianTouMc.getInstance().close();
                    break;
                case 12:
                    if (!this.dataProxy.autoPlayIsOpen){
                        _local2 = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["hammerBtn"];
                        JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("请点击打开神兵面板"), 3).setJTToTargetPostion(_local2.parent);
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                    };
                    break;
                case 13:
                    if (!GameCommonData.Player.IsAutomatism){
                        _local3 = (UIFacade.GetInstance().retrieveMediator(AutoPlayMediator.NAME) as AutoPlayMediator).guide_autoPlayBtn();
                        if (_local3){
                            JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("左键点击开始自动挂机"), 3).setJTToTargetPostion(_local3.parent);
                        };
                    } else {
                        JianTouMc.getInstance().close();
                    };
                    break;
                case 14:
                    JianTouMc.getInstance().close();
                    break;
                case 15:
                    if (!this.dataProxy.autoPlayIsOpen){
                        _local2 = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["hammerBtn"];
                        JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("请点击打开神兵面板"), 3).setJTToTargetPostion(_local2.parent);
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                    };
                    break;
                case 16:
                    if (!GameCommonData.Player.IsAutomatism){
                        _local3 = (UIFacade.GetInstance().retrieveMediator(AutoPlayMediator.NAME) as AutoPlayMediator).guide_autoPlayBtn();
                        if (_local3){
                            JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("左键点击开始自动挂机"), 3).setJTToTargetPostion(_local3.parent);
                        };
                    } else {
                        JianTouMc.getInstance().close();
                    };
                    break;
                case 17:
                    JianTouMc.getInstance().close();
                    break;
                case 18:
                    if (!this.dataProxy.autoPlayIsOpen){
                        _local2 = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["hammerBtn"];
                        JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("请点击打开神兵面板"), 3).setJTToTargetPostion(_local2.parent);
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                    };
                    break;
                case 19:
                    if (!GameCommonData.Player.IsAutomatism){
                        _local3 = (UIFacade.GetInstance().retrieveMediator(AutoPlayMediator.NAME) as AutoPlayMediator).guide_autoPlayBtn();
                        if (_local3){
                            JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("左键点击开始自动挂机"), 3).setJTToTargetPostion(_local3.parent);
                        };
                    } else {
                        JianTouMc.getInstance().close();
                    };
                    break;
                case 20:
                    JianTouMc.getInstance().close();
                    break;
            };
        }
        public function Guide_Treasure():void{
            var _local1:GuideTreasureView = new GuideTreasureView();
            _local1.x = ((GameCommonData.GameInstance.ScreenWidth - _local1.frameWidth) / 2);
            _local1.y = ((GameCommonData.GameInstance.ScreenHeight - _local1.frameHeight) / 2);
            GameCommonData.GameInstance.GameUI.addChild(_local1);
        }
        public function Guide_Consignment():void{
            var _local1:GuideConsignmentView = new GuideConsignmentView();
            _local1.x = ((GameCommonData.GameInstance.ScreenWidth - _local1.frameWidth) / 2);
            _local1.y = ((GameCommonData.GameInstance.ScreenHeight - _local1.frameHeight) / 2);
            GameCommonData.GameInstance.GameUI.addChild(_local1);
        }
        public function Guide_TowerJump(_arg1:DisplayObject):void{
            var _local2:Rectangle = _arg1.getBounds(_arg1.stage);
            JianTouMc.getInstance().show(_arg1, LanguageMgr.GetTranslation("花费一定金币能快速到达你曾经到达过的特定层次"), 4, _local2);
        }
        public function Guide_Strengthen(_arg1:int, _arg2:Object):void{
            var _local3:DisplayObject;
            switch (_arg1){
                case 1:
                    _local3 = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_11"].equipStrength_btn;
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local3, LanguageMgr.GetTranslation("点击打开装备锻造界面"), 3);
                    break;
                case 2:
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_arg2["target"], LanguageMgr.GetTranslation("双击选择一件蓝色品质的装备"), 3);
                    break;
                case 3:
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_arg2["target"], LanguageMgr.GetTranslation("双击放入神恩符"), 3);
                    break;
                case 4:
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_arg2["target"], LanguageMgr.GetTranslation("点击强化"), 4);
                    break;
                case 5:
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).close();
                    break;
            };
        }
        private function GetRecBoundToFollowTree(_arg1:TaskText):Rectangle{
            return (TaskCommonData.GetRecBoundToFollowTree(_arg1));
        }
        private function doTask_2(_arg1:int):void{
            switch (_arg1){
                case 1:
                    break;
            };
        }
        private function get dataProxy():DataProxy{
            return ((facade.retrieveProxy(DataProxy.NAME) as DataProxy));
        }
        private function doTask_4(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("点击尼古拉斯开始自动寻路"), 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_5(_arg1:int):void{
            var _local2:TaskText;
            var _local3:InventoryItemInfo;
            var _local4:QuickSkillManager;
            switch (_arg1){
                case 1:
                    CharacterSend.sendCurrentStep("自动寻路去侏儒小兵怪点");
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("点击侏儒小兵开始自动寻路"), 2, GetRecBoundToFollowTree(_local2));
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_5]);
                    break;
                case 2:
                    break;
                case 3:
                    CharacterSend.sendCurrentStep("回复任务中(小试身手)");
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("回复任务"), 2, GetRecBoundToFollowTree(_local2));
                    break;
                case 4:
                    _local3 = BagData.getItemByType(30100001);
                    if (_local3){
                        _local4 = (UIFacade.GetInstance().retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
                        _local4.autoAddItem(0, _local3, 6);
                    };
                    break;
            };
        }
        private function doTask_6(_arg1:int):void{
            var taskText:* = null;
            var step:* = _arg1;
            switch (step){
                case 1:
                    CharacterSend.sendCurrentStep("自动寻路去符文采集点");
                    taskText = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(taskText, LanguageMgr.GetTranslation("点击自动寻径到符文采集点"), 2, GetRecBoundToFollowTree(taskText));
                    break;
                case 2:
                    CharacterSend.sendCurrentStep(LanguageMgr.GetTranslation("到达采集点采集符文中"));
                    taskText = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(taskText, LanguageMgr.GetTranslation("采集符文碎片"), 2, GetRecBoundToFollowTree(taskText));
                    break;
                case 3:
                    setTimeout(function ():void{
                        CharacterSend.sendCurrentStep("回复任务中(采集符文)");
                        var _local1:TaskText = GetPointFromFollowTree(0);
                        JianTouMc.getInstance().show(_local1, LanguageMgr.GetTranslation("点击蒂米霍斯开始自动寻路"), 2, GetRecBoundToFollowTree(_local1));
                        sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_6]);
                    }, 500);
                    break;
            };
        }
        private function doTask_7(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, LanguageMgr.GetTranslation("点击艾莎开始自动寻路"), 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function doTask_1(_arg1:int):void{
            var taskText:* = null;
            var step:* = _arg1;
            switch (step){
                case 1:
                    if (((guideFrame) && (guideFrame.parent))){
                        guideFrame.close();
                    };
                    CharacterSend.sendCurrentStep("显示第一个升级提示框");
                    guideFrame = new GuideFrame(1, true);
                    guideFrame.x = ((GameCommonData.GameInstance.ScreenWidth - guideFrame.frameWidth) / 2);
                    guideFrame.y = ((GameCommonData.GameInstance.ScreenHeight - guideFrame.frameHeight) / 2);
                    guideFrame.show();
                    guideFrame.okFun = function ():void{
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                        CharacterSend.GetReward(GetRewardType.LEVEL_ITEM_EXP);
                        CharacterSend.sendCurrentStep("点击第一个升级提示框确定按钮");
                    };
                    taskText = GetPointFromFollowTree(1);
                    JianTouMc.getInstance().show(taskText, LanguageMgr.GetTranslation("点击新手引导诺亚开始旅程"), 1, GetRecBoundToFollowTree(taskText));
                    break;
                case 2:
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_UPSTEP);
                    break;
                case 3:
                    CharacterSend.sendCurrentStep("自动寻路去诺亚接任务(领取武器)");
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_1]);
                    break;
                case 4:
                    CharacterSend.sendCurrentStep("打开NPC对话框_诺亚_领取武器");
                    JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("点击领取武器接受任务"), 1);
                    break;
                case 5:
                    CharacterSend.sendCurrentStep("任务(领取武器)接取界面");
                    JianTouMc.getInstance().show((facade.retrieveMediator(NPCChatMediator.NAME) as NPCChatMediator).nextTF, LanguageMgr.GetTranslation("点击此处接受任务"), 1);
                    JianTouMc.getInstance().x = (JianTouMc.getInstance().x - 50);
                    break;
                case 6:
                    CharacterSend.sendCurrentStep("自动寻路去阿斯加还任务(领取武器)");
                    taskText = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(taskText, LanguageMgr.GetTranslation("点击下划线内容自动寻径完成任务"), 2, GetRecBoundToFollowTree(taskText));
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_1]);
                    break;
                case 7:
                    break;
                case 8:
                    CharacterSend.sendCurrentStep("打开NPC对话框_阿斯加_领取武器");
                    JianTouMc.getInstance().show(pointTarget, LanguageMgr.GetTranslation("点击领取武器完成任务2"), 1).setJTToTargetPostion(pointTarget.parent);
                    break;
                case 9:
                    CharacterSend.sendCurrentStep("任务(领取武器)完成界面");
                    JianTouMc.getInstance().show((facade.retrieveMediator(NPCChatMediator.NAME) as NPCChatMediator).nextTF, LanguageMgr.GetTranslation("点击此处完成任务2"), 1);
                    JianTouMc.getInstance().x = (JianTouMc.getInstance().x - 50);
                    break;
                case 10:
                    break;
                case 11:
                    JianTouMc.getInstance().close();
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_2]);
                    break;
            };
        }
        private function doTask_9(_arg1:int):void{
            var _local2:TaskText;
            switch (_arg1){
                case 1:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
                case 2:
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_9]);
                    break;
                case 3:
                    _local2 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local2, "", 2, GetRecBoundToFollowTree(_local2));
                    break;
            };
        }
        private function GetPointFromFollowTree(_arg1:int=-1, _arg2:int=-1):TaskText{
            return (TaskCommonData.GetPointFromFollowTree(_arg1, _arg2));
        }
        public function Guide_ClosePointBag(_arg1:Object):void{
            if ((((_arg1 == null)) || ((PointingItemTempleteId == int(_arg1))))){
                JianTouMc.getInstance(JianTouMc.TYPE_USEBAGITEM).close();
                PointingItemTempleteId = 0;
                return;
            };
        }
        private function doTask_8(_arg1:int):void{
            var _local2:*;
            var _local3:HLabelButton;
            var _local4:SimpleButton;
            var _local5:TaskText;
            var _local6:int;
            switch (_arg1){
                case 1:
                    if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_PET0]){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:8,
                            STEP:4
                        });
                    };
                    break;
                case 4:
                    _local2 = facade.retrieveProxy(DataProxy.NAME);
                    if (((_local2) && (!(_local2.PetIsOpen)))){
                        facade.sendNotification(EventList.SHOWONLY, "pet");
                        facade.sendNotification(EventList.SHOWPETVIEW);
                    };
                    break;
                case 5:
                    _local3 = (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).outBtn;
                    if (_local3){
                        JianTouMc.getInstance().show(_local3, LanguageMgr.GetTranslation("点击宠物出战"), 2).setJTToTargetPostion(_local3.parent);
                    };
                    break;
                case 6:
                    _local4 = (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).closeBtn;
                    if (_local4){
                        JianTouMc.getInstance().show(_local4, LanguageMgr.GetTranslation("点击关闭宠物面板"), 1).setJTToTargetPostion(_local4.parent);
                    };
                    break;
                case 7:
                    if (GameCommonData.Player.Role.UsingPet == null){
                        _local6 = (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).getCurrSelect();
                        if (_local6 != -1){
                            PetSend.Out(ItemConst.EQUIPMENT_SLOT_PET0);
                        };
                    };
                    sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[NewGuideData.TASK_8]);
                    _local5 = GetPointFromFollowTree(0);
                    JianTouMc.getInstance().show(_local5, LanguageMgr.GetTranslation("点击艾莎开始自动寻路"), 2, GetRecBoundToFollowTree(_local5));
                    break;
            };
        }
        public function doGuide(_arg1:int, _arg2:int, _arg3:DisplayObject=null):void{
            this.pointTarget = _arg3;
            switch (_arg1){
                case 1:
                    doTask_1(_arg2);
                    break;
                case 2:
                    doTask_2(_arg2);
                    break;
                case 4:
                    doTask_4(_arg2);
                    break;
                case 5:
                    doTask_5(_arg2);
                    break;
                case 6:
                    doTask_6(_arg2);
                    break;
                case 7:
                    doTask_7(_arg2);
                    break;
                case 8:
                    doTask_8(_arg2);
                    break;
                case 9:
                    doTask_9(_arg2);
                    break;
                case 10:
                    doTask_10(_arg2);
                    break;
                case 11:
                    doTask_11(_arg2);
                    break;
                case 12:
                    doTask_12(_arg2);
                    break;
                case 13:
                    doTask_13(_arg2);
                    break;
                case 14:
                    doTask_14(_arg2);
                    break;
                case 15:
                    doTask_15(_arg2);
                    break;
                case 16:
                    doTask_16(_arg2);
                    break;
                case 17:
                    doTask_17(_arg2);
                    break;
                case 18:
                    doTask_18(_arg2);
                    break;
                case 19:
                    doTask_19(_arg2);
                    break;
            };
        }
        private function doGuild_Team(_arg1:int):void{
            switch (_arg1){
                case 1:
                    break;
                case 2:
                    break;
                case 3:
                    break;
            };
        }
        public function Guide_Fly():void{
            GameCommonData.Player.Stop();
            if (GameCommonData.Player.Role.UsingPetAnimal){
                GameCommonData.Player.Role.UsingPetAnimal.Stop();
            };
            var _local1:String = (GameCommonData.TaskInfoDic[NewGuideData.TASK_FLY] as TaskInfoStruct).taskProcessFinish;
            var _local2:Array = TaskCommonData.getQuestEventData(_local1);
            GameCommonData.TaskTargetCommand = _local2[4];
            GameCommonData.targetID = _local2[4];
            facade.sendNotification(EventList.SHOWALERT, {
                comfrim:MoveToCommon.sendFlyToCommand,
                isShowClose:false,
                comfirmTxt:LanguageMgr.GetTranslation("立即传送"),
                title:LanguageMgr.GetTranslation("提示"),
                delayTime:5,
                info:LanguageMgr.GetTranslation("进入下一个进阶场景5秒传送"),
                params:{
                    mapId:_local2[0],
                    tileX:_local2[1],
                    tileY:_local2[2],
                    taskId:_local2[3],
                    npcId:_local2[4]
                }
            });
        }
        public function closeGuideFrame():void{
            if (((guideFrame) && (guideFrame.parent))){
                guideFrame.close();
                guideFrame = null;
            };
        }
        public function Guide_HaveNewSkillPoint():void{
            var currentTaskId:* = 0;
            if (GameCommonData.Player.Role.Level == 14){
                currentTaskId = -1;
                if (GameCommonData.NPCDialogIsOpen){
                    currentTaskId = (facade.retrieveMediator(NPCChatMediator.NAME) as NPCChatMediator).taskId;
                    sendNotification(NPCChatComList.HIDE_NPC_CHAT);
                };
                guideFrame = new GuideFrame(6);
                guideFrame.x = ((GameCommonData.GameInstance.ScreenWidth - guideFrame.frameWidth) / 2);
                guideFrame.y = ((GameCommonData.GameInstance.ScreenHeight - guideFrame.frameHeight) / 2);
                guideFrame.show();
                guideFrame.okFun = function ():void{
                    if (currentTaskId > 0){
                        sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[currentTaskId]);
                    };
                };
            };
            var bagMc:* = ((UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_1"];
            bagMc.mcFlash.play();
            bagMc.mcFlash.visible = true;
            JianTouMc.getInstance().show(bagMc, LanguageMgr.GetTranslation("您有新的技能点可添加"), 3);
        }
        private function FindNearestEnemy(_arg1:uint):GameElementAnimal{
            var _local2:uint;
            var _local5:String;
            var _local6:GameElementAnimal;
            var _local3:int = int.MAX_VALUE;
            var _local4:int;
            for (_local5 in GameCommonData.SameSecnePlayerList) {
                _local6 = (GameCommonData.SameSecnePlayerList[_local5] as GameElementAnimal);
                if (_local6.Role.MonsterTypeID == _arg1){
                    _local4 = MapTileModel.Distance(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY, _local6.Role.TileX, _local6.Role.TileY);
                    if (_local4 < _local3){
                        _local3 = _local4;
                        _local2 = _local6.Role.Id;
                    };
                };
            };
            return (GameCommonData.SameSecnePlayerList[_local2]);
        }
        public function Guide_OpenBox10():void{
            var _local1:InventoryItemInfo;
            _local1 = BagData.getItemByType(NewGuideData.ITEMTEMPID_NEWBOX10);
            if (_local1){
                facade.sendNotification(AutoUseEquipCommand.NAME, _local1);
            };
        }

    }
}//package GameUI.Modules.NewGuide.Mediator 

import flash.events.*;
import flash.display.*;
import flash.geom.*;
import flash.utils.*;
import com.greensock.*;
import GameUI.View.HButton.*;
import com.greensock.easing.*;

class GuideFrame extends Sprite {

    private var timerId:uint;
    public var okFun:Function;
    private var tweenMax:TweenMax;
    private var _type:int;
    public var okBtn:HBaseButton;
    private var _bg:MovieClip;
    public var blackBoard:Sprite;
    private var okBtnMask:Sprite;
    public var frameWidth:int;
    public var frameHeight:int;
    private var originalPoint:Point;

    public function GuideFrame(_arg1:int, _arg2:Boolean=false){
        this._type = _arg1;
        init(_arg2);
        addEvents();
    }
    private function __clickHandler(_arg1:MouseEvent):void{
        if (okFun != null){
            okFun();
        };
        close();
    }
    public function show():void{
        addEvents();
        GameCommonData.GameInstance.GameUI.addChild(this);
    }
    private function init(_arg1:Boolean):void{
        if (_arg1){
            blackBoard = new Sprite();
            blackBoard.graphics.beginFill(0, 0.5);
            blackBoard.graphics.drawRect(-1500, -1500, 3000, 3000);
            blackBoard.graphics.endFill();
            addChild(blackBoard);
        };
        if ((((this._type > 0)) && ((this._type < 10)))){
            _bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(("NewGuildAsset_" + _type));
            frameWidth = _bg.width;
            frameHeight = (_bg.height + 150);
        } else {
            return;
        };
        addChild(_bg);
        okBtn = new HBaseButton(_bg.okBtn);
        okBtn.useBackgoundPos = true;
        _bg.addChild(okBtn);
        timerId = setInterval(a, 800);
        originalPoint = new Point(okBtn.x, okBtn.y);
    }
    private function addEvents():void{
        this.addEventListener(MouseEvent.CLICK, __clickHandler);
        okBtn.addEventListener(MouseEvent.MOUSE_OVER, __overHandler);
        okBtn.addEventListener(MouseEvent.MOUSE_OUT, __outHandler);
    }
    public function a():void{
        tweenMax = TweenMax.to(okBtn, 1, {
            bezier:[{
                x:originalPoint.x,
                y:(originalPoint.y - 2)
            }, {
                x:originalPoint.x,
                y:originalPoint.y
            }],
            ease:Elastic.easeInOut,
            onComplete:function ():void{
                okBtn.x = originalPoint.x;
                okBtn.y = originalPoint.y;
            }
        });
    }
    private function __overHandler(_arg1:MouseEvent):void{
        clearInterval(timerId);
    }
    public function close():void{
        clearInterval(timerId);
        TweenMax.killTweensOf(okBtn);
        removeEvents();
        if (GameCommonData.GameInstance.GameUI.contains(this)){
            GameCommonData.GameInstance.GameUI.removeChild(this);
        };
        if (okBtn){
            okBtn.dispose();
            okBtn = null;
        };
    }
    private function __outHandler(_arg1:MouseEvent):void{
        timerId = setInterval(a, 800);
    }
    private function removeEvents():void{
        this.removeEventListener(MouseEvent.CLICK, __clickHandler);
        okBtn.removeEventListener(MouseEvent.MOUSE_OVER, __overHandler);
        okBtn.removeEventListener(MouseEvent.MOUSE_OUT, __outHandler);
    }

}
