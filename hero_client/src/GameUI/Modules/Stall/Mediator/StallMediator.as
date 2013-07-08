//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Stall.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Friend.model.*;
    import GameUI.Modules.Friend.model.vo.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.Modules.Chat.Data.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import GameUI.Modules.ScreenMessage.View.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Stall.UI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Stall.Proxy.*;
    import GameUI.Modules.NPCChat.Mediator.*;
    import GameUI.Modules.Stall.Data.*;
    import flash.system.*;
    import GameUI.*;

    public class StallMediator extends Mediator {

        public static const NAME:String = "StallMediator";
        private static const textformat:TextFormat = new TextFormat("黑体", 14, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);
        public static const STALLNAME_MAX_CHAR:uint = 16;
        public static const GRID_DOWN_STARTPOS:Point = new Point(18, 292);
        public static const GRID_STARTPOS:Point = new Point(18, 112);

        private var maxCount:uint;
        private var moneyOpType:int = 0;
        private var iScrollPane:UIScrollPane = null;
        private var moneyPanel:HFrame = null;
        private var gridSprite:MovieClip = null;
        private var delayNumber:uint;
        private var moneycontent:MovieClip;
        private var stallDownGridManager:StallDownGridManager = null;
        private var stallGridManager:StallGridManager = null;
        private var idToAdd:uint = 0;
        private var stallUIManager:StallUIManager = null;
        private var iScrollPaneChoice:UIScrollPane = null;
        private var maxSellCount:uint;
        private var listView:ListComponent = null;
        private var listViewChoice:ListComponent = null;
        private var dataProxy:DataProxy = null;
        private var gridDownSprite:MovieClip = null;

        public function StallMediator(){
            super(NAME);
        }
        private function resetCount(_arg1:uint):void{
            stall.content.content13.txtInputNum.text = String(_arg1);
            StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0, uint(stall.content.content13.txtInputNum.text));
        }
        public function showMoneyPanel():void{
            var _local1:int;
            var _local2:int;
            var _local3:Array;
            var _local4:uint;
            var _local5:Array;
            if (GameCommonData.GameInstance.GameUI.contains(moneyPanel)){
                moneyPanel.x = StallConstData.MONEY_DEFAULT_POS.x;
                moneyPanel.y = StallConstData.MONEY_DEFAULT_POS.y;
            } else {
                GameCommonData.GameInstance.GameUI.addChild(moneyPanel);
            };
            moneycontent.txtJin.text = "0";
            moneycontent.txtYin.text = "0";
            moneycontent.txtTong.text = "1";
        }
        private function endStall():void{
            var _local1:uint;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            StallConstData.stallIdToQuery = 0;
            clearItems();
            gcAll();
            if (dataProxy.BagIsOpen){
                facade.sendNotification(EventList.CLOSEBAG);
            };
            GameCommonData.Player.Role.State = GameRole.STATE_NULL;
            GameCommonData.Player.Role._isStalling = 0;
            facade.sendNotification(HintEvents.RECEIVEINFO, {
                info:LanguageMgr.GetTranslation("摊位已收起"),
                color:0xFFFF00
            });
            UIConstData.KeyBoardCanUse = true;
            GameCommonData.Player.ShowName();
            GameCommonData.Player.ShowTitle();
            GameCommonData.Player.Role.StallId = 0;
            GameCommonData.Player.PlayerStall();
            var _local5:* = GameCommonData.Player;
            if (SharedManager.getInstance().showPlayerTitle){
                _local5.ShowTitle();
            } else {
                _local5.HideTitle();
            };
            _local5.ShowName();
        }
        private function closeStall():void{
            StallConstData.copyStallName = StallConstData.stallName;
            var _local1:uint;
            var _local2:int;
            var _local3:int;
            StallConstData.copyGoodUpList = new Array(StallConstData.GRID_NUM);
            StallConstData.copyGoodDownList = new Array(StallConstData.GRID_NUM);
            var _local4:* = StallConstData.goodUpList;
            _local1 = 0;
            while (_local1 < StallConstData.GRID_NUM) {
                if (StallConstData.goodUpList[_local1]){
                    StallConstData.copyGoodUpList[_local2] = new Object();
                    StallConstData.copyGoodUpList[_local2].index = StallConstData.goodUpList[_local1].index;
                    StallConstData.copyGoodUpList[_local2].type = StallConstData.goodUpList[_local1].type;
                    StallConstData.copyGoodUpList[_local2].price = StallConstData.goodUpList[_local1].price;
                    StallConstData.copyGoodUpList[_local2].id = StallConstData.goodUpList[_local1].id;
                    StallConstData.copyGoodUpList[_local2].Count = StallConstData.goodUpList[_local1].Count;
                    _local2++;
                };
                if (_local1 <= StallConstData.DOWN_GRID_NUM){
                    if (StallConstData.goodDownList[_local1]){
                        StallConstData.copyGoodDownList[_local3] = new Object();
                        StallConstData.copyGoodDownList[_local3].index = StallConstData.goodDownList[_local1].index;
                        StallConstData.copyGoodDownList[_local3].type = StallConstData.goodDownList[_local1].type;
                        StallConstData.copyGoodDownList[_local3].price = StallConstData.goodDownList[_local1].price;
                        StallConstData.copyGoodDownList[_local3].id = StallConstData.goodDownList[_local1].id;
                        StallConstData.copyGoodDownList[_local3].Count = StallConstData.goodDownList[_local1].Count;
                        _local3++;
                    };
                };
                _local1++;
            };
            StallSend.endStall();
        }
        private function formatMoney(_arg1:uint, _arg2:uint, _arg3:uint):Number{
            return ((((10000 * _arg1) + (100 * _arg2)) + _arg3));
        }
        private function moneyCloseHandler(_arg1:Event):void{
            BagData.lockBagGridUnit(true);
            sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
            gcMoneyPanel();
        }
        private function focusOutHandler(_arg1:FocusEvent):void{
            GameCommonData.isFocusIn = false;
            IME.enabled = false;
        }
        public function applyBuyGood():void{
            var _local1:Object;
            var _local2:int;
            var _local3:Object;
            var _local4:Object;
            if (StallConstData.SelectIndex == 0){
                if (((StallConstData.SelectedItem) && (StallConstData.SelectedItem.Item))){
                    _local1 = StallConstData.goodUpList[StallConstData.SelectedItem.Item.Pos];
                    _local2 = StallConstData.SelectedItem.Item.Num;
                    StallSend.buyStallGoods(StallConstData.stallIdToQuery, StallConstData.timeStamp, _local1.id, uint(stall.content.content13.txtInputNum.text));
                } else {
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("请先选择要购买的物品"),
                        color:0xFFFF00
                    });
                };
            };
        }
        private function setPos():void{
            var _local1:DisplayObject = (UIFacade.GetInstance().retrieveMediator(BagMediator.NAME).getViewComponent() as DisplayObject);
            if (((_local1) && (_local1.visible))){
                stall.x = (_local1.x - stall.width);
                stall.y = _local1.y;
            } else {
                stall.x = ((GameCommonData.GameInstance.ScreenWidth / 2) - stall.width);
                stall.y = ((GameCommonData.GameInstance.ScreenHeight - UIConstData.BagHeight) / 2);
            };
            if ((stall.y + stall.height) > GameCommonData.GameInstance.ScreenHeight){
                stall.y = (GameCommonData.GameInstance.ScreenHeight - stall.height);
            };
            stall.centerFrame();
        }
        private function stallCloseHandler():void{
            if (GameCommonData.Player.Role.isStalling > 0){
                gcAll();
                if (dataProxy.BagIsOpen){
                    facade.sendNotification(EventList.CLOSEBAG);
                };
                return;
            };
            BagData.lockBtnCleanAndPage(true);
            clearItems();
            StallConstData.stallIdToQuery = 0;
            gcAll();
            if (dataProxy.BagIsOpen){
                facade.sendNotification(EventList.CLOSEBAG);
            };
        }
        private function get stall():StallView{
            return ((this.viewComponent as StallView));
        }
        public function cancelClose():void{
        }
        private function inputHandler(_arg1:Event):void{
            var _local2:String;
            var _local3:uint;
            switch (_arg1.currentTarget.name){
                case "txtStallName":
                    _local2 = stall.content.txtStallName.text.replace(/^\s*|\s*$""^\s*|\s*$/g, "").split(" ").join("");
                    if (_local2){
                        stall.content.txtStallName.text = UIUtils.getTextByCharLength(_local2, STALLNAME_MAX_CHAR);
                    };
                    break;
                case "txtInputNum":
                    if (StallConstData.SelectedItem == null){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择物品"),
                            color:0xFFFF00
                        });
                        stall.content.content13.txtInputNum.text = "0";
                        return;
                    };
                    _local2 = stall.content.content13.txtInputNum.text.replace(/^\s*|\s*$""^\s*|\s*$/g, "").split(" ").join("");
                    if (_local2){
                        stall.content.content13.txtInputNum.text = UIUtils.getTextByCharLength(_local2, 4);
                    };
                    if (uint(stall.content.content13.txtInputNum.text) > StallConstData.SelectedItem.Item.Num){
                        stall.content.content13.txtInputNum.text = String(StallConstData.SelectedItem.Item.Num);
                    };
                    facade.sendNotification(StallEvents.REFRESHMONEY);
                    break;
                case "txtInputSellNum":
                    if (StallConstData.SelectedDownItem == null){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择物品"),
                            color:0xFFFF00
                        });
                        stall.content.content23.txtInputSellNum.text = "0";
                        return;
                    };
                    _local2 = stall.content.content23.txtInputSellNum.text.replace(/^\s*|\s*$""^\s*|\s*$/g, "").split(" ").join("");
                    if (_local2){
                        stall.content.content23.txtInputSellNum.text = UIUtils.getTextByCharLength(_local2, 4);
                    };
                    _local3 = BagData.getCountsByTemplateId((StallConstData.SelectedDownItem.Item as UseItem).itemIemplateInfo.TemplateID);
                    if (_local3 > StallConstData.SelectedDownItem.Item.Num){
                        _local3 = StallConstData.SelectedDownItem.Item.Num;
                    };
                    if (uint(stall.content.content23.txtInputSellNum.text) > _local3){
                        stall.content.content23.txtInputSellNum.text = String(_local3);
                    };
                    if ((((GameCommonData.Player.Role.Id == StallConstData.stallIdToQuery)) || ((StallConstData.stallIdToQuery == 0)))){
                        StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    } else {
                        StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2, uint(stall.content.content23.txtInputSellNum.text));
                    };
                    break;
                case "txtInputCount":
                    _local2 = moneycontent.txtInputCount.text.replace(/^\s*|\s*$""^\s*|\s*$/g, "").split(" ").join("");
                    if (_local2){
                        moneycontent.txtInputCount.text = UIUtils.getTextByCharLength(_local2, 4);
                    };
                    if (int(moneycontent.txtInputCount.text) > maxCount){
                        moneycontent.txtInputCount.text = String(maxCount);
                    } else {
                        if (int(moneycontent.txtInputCount.text) <= 0){
                            moneycontent.txtInputCount.text = "1";
                        };
                    };
                    break;
                case "txtJin":
                    if (moneycontent.txtJin.text == ""){
                        moneycontent.txtJin.text = "0";
                    };
                    break;
                case "txtYin":
                    if (moneycontent.txtYin.text == ""){
                        moneycontent.txtYin.text = "0";
                    };
                    break;
                case "txtTong":
                    if (moneycontent.txtTong.text == ""){
                        if ((((moneycontent.txtJin.text == "0")) && ((moneycontent.txtYin.text == "0")))){
                            moneycontent.txtTong.text = "1";
                        } else {
                            moneycontent.txtTong.text = "0";
                        };
                    };
                    break;
            };
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            var _local17:FriendInfoStruct;
            var _local18:InventoryItemInfo;
            var _local19:BigMessageItem;
            var _local20:uint;
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local5:Number = 0;
            var _local6:String;
            var _local7:int;
            var _local8:uint;
            var _local9:int;
            var _local10:Object;
            var _local11:Object;
            var _local12:int;
            var _local13:Number = NaN;
            var _local14:String;
            var _local15:Number = NaN;
            var _local16:String;
            switch (_arg1.currentTarget.name){
                case "_btnPrivate":
                    _local17 = FriendConstData.searchFriend(FriendConstData.FriendList, 0, 0, StallConstData.stallOwnerName);
                    if (!_local17){
                        _local17 = FriendConstData.searchFriend(FriendConstData.TempFriendList, 0, 0, StallConstData.stallOwnerName);
                    };
                    if (!_local17){
                        _local17 = new FriendInfoStruct();
                        _local17.frendId = StallConstData.stallIdToQuery;
                        _local17.roleName = StallConstData.stallOwnerName;
                    };
                    this.sendNotification(FriendCommandList.SHOW_SEND_MSG, _local17);
                    break;
                case "_btnStartStall":
                    if (stall.content.txtStallName.text == ""){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摊位名称不能为空"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (!UIUtils.isPermitedName(stall.content.txtStallName.text)){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摊位名称不合法"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if ((((StallConstData.buyNum == 0)) && ((StallConstData.sellNum == 0)))){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摊位不能为空"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (dataProxy.TradeIsOpen){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("交易中不能摆摊"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (GameCommonData.Player.Role.HP == 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("死亡状态不能摆摊"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_RUN){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("移动时不能摆摊"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    if (!checkDistance()){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("距离其它摆摊玩家太近,不能摆摊"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    StallConstData.stallName = stall.content.txtStallName.text;
                    if (GameCommonData.Player.Role.MountSkinID == 0){
                        StallSend.beginStall(StallConstData.stallName, StallConstData.sellNum, StallConstData.goodUpList, StallConstData.buyNum, StallConstData.goodDownList);
                    } else {
                        _local18 = RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT];
                        if (_local18){
                            BagInfoSend.ItemUse(_local18.ItemGUID);
                        };
                        delayNumber = setInterval(delayBeginStall, 500);
                    };
                    break;
                case "_btnCloseStall":
                    facade.sendNotification(EventList.SHOWALERT, {
                        comfrim:closeStall,
                        cancel:cancelClose,
                        info:LanguageMgr.GetTranslation("是否要收摊"),
                        title:LanguageMgr.GetTranslation("提 示")
                    });
                    break;
                case "_btnClearStall":
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摆摊时不允许操作摊位物品"),
                            color:0xFFFF00
                        });
                        return;
                    };
                    StallConstData.buyNum = 0;
                    StallConstData.sellNum = 0;
                    StallConstData.idToPlace1 = -1;
                    StallConstData.idToPlace2 = -1;
                    clearItems();
                    StallConstData.copyGoodUpList = new Array(StallConstData.GRID_NUM);
                    StallConstData.copyGoodDownList = new Array(StallConstData.DOWN_GRID_NUM);
                    stallGridManager.removeAllItem();
                    StallConstData.SelectedItem = null;
                    stallGridManager.removeAllFrames();
                    stallGridManager.showItems(StallConstData.goodUpList);
                    stallDownGridManager.removeAllItem();
                    StallConstData.SelectedDownItem = null;
                    stallDownGridManager.removeAllFrames();
                    stallDownGridManager.showItems(StallConstData.goodDownList);
                    StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
                    StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    stallUIManager.showMoney(0);
                    stallUIManager.showMoney(2);
                    break;
                case "_btnInputSure":
                    _local2 = uint(moneycontent.txtJin.text);
                    _local3 = uint(moneycontent.txtYin.text);
                    _local4 = uint(moneycontent.txtTong.text);
                    _local5 = formatMoney(_local2, _local3, _local4);
                    if (_local5 > 0){
                        BagData.lockBagGridUnit(true);
                        gcMoneyPanel();
                        if (moneyOpType == 0){
                            StallConstData.goodUpList[StallConstData.idToPlace1].price = _local5;
                            StallConstData.goodUpList[StallConstData.idToPlace1].Count = uint(moneycontent.txtInputCount.text);
                            if (maxCount < StallConstData.goodUpList[StallConstData.idToPlace1].Count){
                                _local19 = new BigMessageItem(LanguageMgr.GetTranslation("你输入的数量有误"));
                                _local19.Jump();
                                closeMoneyPanel();
                                return;
                            };
                            if (checkMoneyOutRange()){
                                moneycontent.txtInputCount.text = "1";
                                return;
                            };
                            facade.sendNotification(EventList.STALLITEM);
                        } else {
                            StallConstData.goodDownList[StallConstData.idToPlace2].price = _local5;
                            StallConstData.goodDownList[StallConstData.idToPlace2].Count = uint(moneycontent.txtInputCount.text);
                            StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                            facade.sendNotification(EventList.STALLITEM);
                        };
                    };
                    moneycontent.txtInputCount.text = "1";
                    break;
                case "_btnInputCancel":
                    closeMoneyPanel();
                    break;
                case "_btnMax":
                    moneycontent.txtInputCount.text = String(maxCount);
                    break;
                case "btnAdd":
                    if (int(moneycontent.txtInputCount.text) < maxCount){
                        moneycontent.txtInputCount.text = String((int(moneycontent.txtInputCount.text) + 1));
                    };
                    break;
                case "btnSub":
                    if (int(moneycontent.txtInputCount.text) > 1){
                        moneycontent.txtInputCount.text = String((int(moneycontent.txtInputCount.text) - 1));
                    };
                    break;
                case "_btnBuy":
                    if (StallConstData.SelectIndex == 0){
                        if (((StallConstData.SelectedItem) && (StallConstData.SelectedItem.Item))){
                            _local11 = StallConstData.goodUpList[StallConstData.SelectedItem.Item.Pos];
                            _local12 = uint(stall.content.content13.txtInputNum.text);
                            if (_local12 == 0){
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("请输入需要购买的数量"),
                                    color:0xFFFF00
                                });
                                return;
                            };
                            _local13 = Number((_local11.price * _local12));
                            if (_local13 > GameCommonData.Player.Role.Gold){
                                UIFacade.GetInstance().LackofGold();
                                return;
                            };
                            _local14 = UIUtils.getMoneyInfo(_local13);
                            facade.sendNotification(EventList.SHOWALERT, {
                                comfrim:applyBuyGood,
                                cancel:cancelClose,
                                info:LanguageMgr.GetTranslation("是花费x买该物品", _local14),
                                title:LanguageMgr.GetTranslation("提 示")
                            });
                        } else {
                            facade.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("请先选择要购买的物品"),
                                color:0xFFFF00
                            });
                        };
                    };
                    break;
                case "_btnSell":
                    if (((StallConstData.SelectedDownItem) && (StallConstData.SelectedDownItem.Item))){
                        _local11 = StallConstData.goodDownList[StallConstData.SelectedDownItem.Item.Pos];
                        _local12 = uint(stall.content.content23.txtInputSellNum.text);
                        _local13 = Number((_local11.price * _local12));
                        _local14 = UIUtils.getMoneyInfo(_local13);
                        _local20 = BagData.getCountsByTemplateId(_local11.type);
                        if (_local20 == 0){
                            facade.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("背包无交易物品"),
                                color:0xFFFF00
                            });
                            return;
                        };
                        StallSend.sellStallGoods(StallConstData.stallIdToQuery, StallConstData.timeStamp, StallConstData.SelectedDownItem.Index, uint(stall.content.content23.txtInputSellNum.text));
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择出售的物品"),
                            color:0xFFFF00
                        });
                    };
                    break;
            };
        }
        private function gcMoneyPanel():void{
            stallGridManager.unLockGrids();
            stallDownGridManager.unLockGrids();
            stallUIManager.unLockBtns();
            if (GameCommonData.GameInstance.GameUI.contains(moneyPanel)){
                GameCommonData.GameInstance.GameUI.removeChild(moneyPanel);
            };
        }
        private function gcAll():void{
            StallConstData.idToPlace1 = -1;
            StallConstData.idToPlace2 = -1;
            stallGridManager.removeAllItem();
            stallDownGridManager.removeAllItem();
            StallConstData.SelectIndex = 0;
            StallConstData.SelectedItem = null;
            StallConstData.SelectedDownItem = null;
            StallConstData.stallInfo = "";
            StallConstData.stallIdToQuery = 0;
            StallConstData.stallMsg = [];
            StallConstData.moneyAll = [0, 0, 0];
            removeLis();
            if (stall.contains(gridSprite)){
                stall.removeChild(gridSprite);
            };
            if (stall.contains(gridDownSprite)){
                stall.removeChild(gridDownSprite);
            };
            dataProxy.StallIsOpen = false;
            gcMoneyPanel();
            if (((stallPanel) && (GameCommonData.GameInstance.GameUI.contains(stallPanel)))){
                EffectLib.checkTranslationByClose(stallPanel, GameCommonData.GameInstance.stage);
                GameCommonData.GameInstance.GameUI.removeChild(stallPanel);
            };
        }
        private function checkDistance():Boolean{
            var _local1:Boolean;
            var _local2 = "";
            for (_local2 in GameCommonData.SameSecnePlayerList) {
                if (GameCommonData.SameSecnePlayerList[_local2].Role.isStalling){
                    if (DistanceController.PlayerTargetAnimalDistance(GameCommonData.SameSecnePlayerList[_local2], 2)){
                        return (false);
                    };
                };
            };
            return (_local1);
        }
        private function initDownGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < StallConstData.DOWN_GRID_NUM) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = (_local1.width * (_local3 % 6));
                _local1.y = (_local1.height * int((_local3 / 6)));
                _local1.name = ("stalldown_" + _local3.toString());
                gridDownSprite.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = gridDownSprite;
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                StallConstData.GridDownUnitList.push(_local2);
                _local3++;
            };
            gridDownSprite.x = GRID_DOWN_STARTPOS.x;
            gridDownSprite.y = GRID_DOWN_STARTPOS.y;
            stall.addChild(gridDownSprite);
            stallDownGridManager = new StallDownGridManager(StallConstData.GridDownUnitList, gridDownSprite);
            facade.registerProxy(stallDownGridManager);
            stallDownGridManager.Initialize();
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local16:MovieClip;
            var _local17:String;
            var _local18:Array;
            var _local19:uint;
            var _local20:String;
            var _local21:DisplayObject;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:Object;
            var _local6:int;
            var _local7:GameElementPlayer;
            var _local8:MovieClip;
            var _local9:Array;
            var _local10:Object;
            var _local11:MovieClip;
            var _local12:String;
            var _local13:MovieClip;
            var _local14:String;
            var _local15:InventoryItemInfo;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.RESIZE_STAGE:
                    if (((!(stall)) || (!(dataProxy.StallIsOpen)))){
                        return;
                    };
                    setPos();
                    break;
                case EventList.CLOSESTALL:
                    stallCloseHandler();
                    break;
                case EventList.SHOWSTALL:
                    if (!stall){
                        initView();
                    };
                    if (GameCommonData.Player.Role.isStalling == 0){
                        if (((dataProxy.StallIsOpen) && ((StallConstData.stallIdToQuery == 0)))){
                            facade.sendNotification(EventList.SHOWBAG);
                            setPos();
                            return;
                        };
                        if (dataProxy.DepotIsOpen){
                            sendNotification(EventList.CLOSEDEPOTVIEW);
                        };
                        if (dataProxy.NPCShopIsOpen){
                            sendNotification(EventList.CLOSENPCSHOPVIEW);
                        };
                        gcAll();
                        readyStall();
                        facade.sendNotification(EventList.SHOWBAG);
                        setPos();
                    } else {
                        if (((dataProxy.StallIsOpen) && ((StallConstData.stallIdToQuery == GameCommonData.Player.Role.Id)))){
                            facade.sendNotification(EventList.SHOWBAG);
                            setPos();
                            return;
                        };
                        if (dataProxy.TradeIsOpen){
                            facade.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("交易中不能进行摊位操作"),
                                color:0xFFFF00
                            });
                            return;
                        };
                        StallConstData.goodUpList = new Array(StallConstData.GRID_NUM);
                        StallConstData.goodDownList = new Array(StallConstData.DOWN_GRID_NUM);
                        if (dataProxy.StallIsOpen){
                            gcAll();
                        };
                        StallConstData.stallMsg = [];
                        StallConstData.goodUpList = new Array(StallConstData.GRID_NUM);
                        StallConstData.goodDownList = new Array(StallConstData.DOWN_GRID_NUM);
                        StallSend.requestStallGoods(GameCommonData.Player.Role.Id);
                    };
                    break;
                case EventList.BEGINSTALL:
                    _local2 = int(_arg1.getBody());
                    if (_local2 != 0){
                        if (_local2 == GameCommonData.Player.Role.Id){
                            stallUIManager.setModel(1);
                            stallGridManager.removeMouseDown();
                            stallDownGridManager.removeMouseDown();
                            GameCommonData.Player.HideName();
                            GameCommonData.Player.HideTitle();
                            GameCommonData.Player.Role.StallId = _local2;
                            GameCommonData.Player.PlayerStall();
                            StallConstData.stallIdToQuery = _local2;
                            _local16 = StallSkinManager.getInstance().getStallSkin(_local2);
                            _local8 = (GameCommonData.Player.addChildAt(_local16, 0) as MovieClip);
                            _local16.name = ("stall_" + String(StallConstData.stallIdToQuery));
                            _local8.txtStallName.text = StallConstData.stallName;
                            stall.content.txtStallName.text = StallConstData.stallName;
                            GameCommonData.Player.Role.State = GameRole.STATE_STALL;
                            BagData.lockBagGridUnit(false);
                            BagData.lockBtnCleanAndPage(false);
                            stallUIManager.showMoney(3);
                            stallUIManager.showMoney(4);
                            if (dataProxy.BagIsOpen){
                                facade.sendNotification(EventList.CLOSEBAG);
                            };
                            if (NPCChatMediator.NPCChatIsOpen){
                                facade.sendNotification(EventList.CLOSE_NPC_ALL_PANEL);
                            };
                            if (dataProxy.StallIsOpen){
                                gcAll();
                            };
                            facade.sendNotification(EventList.SHOWBAG);
                            refreshSelfMoney();
                            initStall();
                            addLis();
                            StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
                            StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                            stallGridManager.showItems(StallConstData.goodUpList);
                            stallDownGridManager.showItems(StallConstData.goodDownList);
                            stallUIManager.showMoney(0);
                            stallUIManager.showMoney(2);
                            dataProxy.StallIsOpen = true;
                            UIConstData.KeyBoardCanUse = false;
                        } else {
                            if (GameCommonData.SameSecnePlayerList[_local2] != null){
                                if (uint(GameCommonData.GameInstance.GameScene.GetGameScene.MapId) != 1004){
                                    break;
                                };
                                GameCommonData.SameSecnePlayerList[_local2].HideName();
                                GameCommonData.SameSecnePlayerList[_local2].HideTitle();
                                GameCommonData.SameSecnePlayerList[_local2].Role.StallId = _local2;
                                GameCommonData.SameSecnePlayerList[_local2].PlayerStall();
                                _local16 = StallSkinManager.getInstance().getStallSkin(_local2);
                                _local8 = (GameCommonData.SameSecnePlayerList[_local2].addChildAt(_local16, 0) as MovieClip);
                                _local16.name = ("stall_" + String(_arg1.getBody()));
                                if (StallConstData.otherStallName[_local2]){
                                    _local8.txtStallName.text = StallConstData.otherStallName[_local2];
                                } else {
                                    _local8.txtStallName.text = GameCommonData.SameSecnePlayerList[_local2].Role.StallName;
                                };
                            };
                        };
                    };
                    break;
                case EventList.GETSTALLITEMS:
                    _local3 = int(_arg1.getBody());
                    if (GameCommonData.Player.Role.isStalling > 0){
                        if (_local3 != GameCommonData.Player.Role.Id){
                            facade.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("摆摊时无法查看他人摊位"),
                                color:0xFFFF00
                            });
                            return;
                        };
                    };
                    if (_local3 > 0){
                        if (dataProxy.StallIsOpen){
                            if (StallConstData.stallIdToQuery == 0){
                                clearItems();
                            };
                            gcAll();
                        };
                        StallConstData.goodUpList = new Array(StallConstData.GRID_NUM);
                        StallConstData.goodDownList = new Array(StallConstData.DOWN_GRID_NUM);
                        StallConstData.stallIdToQuery = _local3;
                        StallSend.requestStallGoods(_local3);
                    };
                    break;
                case StallEvents.SHOWSOMESTALL:
                    if (!stall){
                        initView();
                    };
                    if (StallConstData.stallIdToQuery == GameCommonData.Player.Role.Id){
                        stallUIManager.setModel(1);
                        stallGridManager.removeMouseDown();
                        stallDownGridManager.removeMouseDown();
                        stall.content.content13.txtInputNum.text = "0";
                        stall.content.txtStallName.text = StallConstData.stallName;
                        StallConstData.stallOwnerName = GameCommonData.Player.Role.Name.toString();
                        stall.content.txtOwerName.text = StallConstData.stallOwnerName;
                    } else {
                        stallUIManager.setModel(2);
                        stallGridManager.removeMouseDown();
                        stallDownGridManager.removeMouseDown();
                        stall.content.content13.txtInputNum.text = "0";
                        stall.content.content23.txtInputSellNum.text = "0";
                        if (GameCommonData.SameSecnePlayerList[StallConstData.stallIdToQuery] != null){
                            StallConstData.stallOwnerName = GameCommonData.SameSecnePlayerList[StallConstData.stallIdToQuery].Role.Name;
                            if (StallConstData.otherStallName[StallConstData.stallIdToQuery]){
                                _local17 = StallConstData.otherStallName[StallConstData.stallIdToQuery];
                            } else {
                                _local17 = GameCommonData.SameSecnePlayerList[StallConstData.stallIdToQuery].getChildByName(("stall_" + String(StallConstData.stallIdToQuery))).txtStallName.text;
                            };
                            stall.content.txtStallName.text = _local17;
                            stall.content.txtOwerName.text = StallConstData.stallOwnerName;
                        };
                    };
                    if (dataProxy.StallIsOpen){
                        gcAll();
                        if (dataProxy.BagIsOpen){
                            facade.sendNotification(EventList.CLOSEBAG);
                        };
                    };
                    refreshSelfMoney();
                    initStall();
                    addLis();
                    StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
                    StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    stallUIManager.showMoney(0);
                    stallUIManager.showMoney(2);
                    dataProxy.StallIsOpen = true;
                    facade.sendNotification(EventList.SHOWBAG);
                    break;
                case EventList.BAGTOSTALL:
                    idToAdd = uint(_arg1.getBody().ItemGUID);
                    if (StallConstData.sellNum >= StallConstData.GRID_NUM){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("出售摊位已满"),
                            color:0xFFFF00
                        });
                        facade.sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
                        break;
                    };
                    StallConstData.idToPlace1 = (StallConstData.idToPlace1 + 1);
                    _local2 = uint(_arg1.getBody().srcPlace);
                    StallConstData.goodUpList[StallConstData.idToPlace1] = new Object();
                    _local15 = BagData.getItemById(idToAdd);
                    StallConstData.goodUpList[StallConstData.idToPlace1].index = _local15.index;
                    StallConstData.goodUpList[StallConstData.idToPlace1].type = _local15.type;
                    StallConstData.goodUpList[StallConstData.idToPlace1].id = _local15.ItemGUID;
                    StallConstData.goodUpList[StallConstData.idToPlace1].Count = _local15.Count;
                    StallConstData.goodUpList[StallConstData.idToPlace1].Place = _local15.Place;
                    StallConstData.sellNum++;
                    maxCount = _local15.Count;
                    if ((((GameCommonData.Player.Role.isStalling == 0)) && ((StallConstData.stallOwnerName == GameCommonData.Player.Role.Name)))){
                        moneyOpType = 0;
                        showMoneyPanel();
                    } else {
                        sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
                    };
                    break;
                case EventList.BAGTODOWNSTALL:
                    idToAdd = uint(_arg1.getBody().ItemGUID);
                    if (StallConstData.buyNum >= StallConstData.DOWN_GRID_NUM){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("收购摊位已满"),
                            color:0xFFFF00
                        });
                        facade.sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
                        break;
                    };
                    BagData.lockBagGridUnit(false);
                    StallConstData.idToPlace2 = (StallConstData.idToPlace2 + 1);
                    _local2 = uint(_arg1.getBody().srcPlace);
                    StallConstData.goodDownList[StallConstData.idToPlace2] = new Object();
                    _local15 = BagData.AllItems[ItemConst.placeToPanel(_local2)][ItemConst.placeToOffset(_local2)];
                    StallConstData.goodDownList[StallConstData.idToPlace2].index = _local15.index;
                    StallConstData.goodDownList[StallConstData.idToPlace2].type = _local15.type;
                    StallConstData.goodDownList[StallConstData.idToPlace2].id = _local15.ItemGUID;
                    StallConstData.goodDownList[StallConstData.idToPlace2].Count = _local15.Count;
                    StallConstData.goodDownList[StallConstData.idToPlace2].Place = _local15.Place;
                    StallConstData.buyNum++;
                    maxCount = _local15.MaxCount;
                    if ((((GameCommonData.Player.Role.isStalling == 0)) && ((StallConstData.stallOwnerName == GameCommonData.Player.Role.Name)))){
                        moneyOpType = 1;
                        showMoneyPanel();
                        stallDownGridManager.lockGrids();
                        stallUIManager.lockBtns();
                    } else {
                        sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
                    };
                    break;
                case StallEvents.UPDATESTALLITEM:
                    _local2 = int(_arg1.getBody().param);
                    _local3 = int(_arg1.getBody().num);
                    _local4 = 0;
                    while (_local4 < StallConstData.goodUpList.length) {
                        if (((StallConstData.goodUpList[_local4]) && ((StallConstData.goodUpList[_local4].id == _local2)))){
                            StallConstData.goodUpList[_local4].Count = _local3;
                            if (StallConstData.goodUpList[_local4].Count <= 0){
                                resetCount(0);
                                StallConstData.goodUpList[_local4] = null;
                                stallGridManager.removeItem(_local4);
                                StallConstData.SelectedItem = null;
                            } else {
                                stallGridManager.refreshItemNum(_local4, _local3);
                            };
                            break;
                        };
                        _local4++;
                    };
                    break;
                case StallEvents.UPDATEDOWNSTALLITEM:
                    _local2 = int(_arg1.getBody().param);
                    _local3 = int(_arg1.getBody().num);
                    StallConstData.goodDownList[_local2].Count = _local3;
                    if (StallConstData.goodDownList[_local2].Count <= 0){
                        resetDownCount(0);
                        StallConstData.goodDownList[_local2] = null;
                        stallDownGridManager.removeItem(_local2);
                        StallConstData.SelectedDownItem = null;
                    } else {
                        stallDownGridManager.refreshItemNum(_local2, _local3);
                    };
                    break;
                case StallEvents.STALLNAME:
                    _local4 = _arg1.getBody().playerid;
                    if (GameCommonData.SameSecnePlayerList[_local4]){
                        StallConstData.otherStallName[_local4] = _arg1.getBody().name;
                        GameCommonData.SameSecnePlayerList[_local4].Role.isStalling = 1;
                    } else {
                        if (GameCommonData.Player.Role.Id == _local4){
                            StallConstData.stallName = _arg1.getBody().name;
                            GameCommonData.Player.Role.isStalling = 1;
                        };
                    };
                    break;
                case StallEvents.STALLRESULT:
                    _local4 = _arg1.getBody().place;
                    if (_arg1.getBody().upFlag == 0){
                        if (StallConstData.goodUpList[_local4] == null){
                            return;
                        };
                        StallConstData.goodUpList[_local4].Count = (StallConstData.goodUpList[_local4].Count - _arg1.getBody().num);
                        _local18 = stallUIManager.countMoney(StallConstData.goodUpList[_local4].price, _arg1.getBody().num);
                        StallConstData.moneyGet[2] = (StallConstData.moneyGet[2] + _local18[2]);
                        StallConstData.moneyGet[1] = ((StallConstData.moneyGet[1] + _local18[1]) + uint((StallConstData.moneyGet[2] / 100)));
                        StallConstData.moneyGet[2] = (StallConstData.moneyGet[2] % 100);
                        StallConstData.moneyGet[0] = ((StallConstData.moneyGet[0] + _local18[0]) + uint((StallConstData.moneyGet[1] / 100)));
                        StallConstData.moneyGet[1] = (StallConstData.moneyGet[1] % 100);
                        stallUIManager.showMoney(3);
                        if (StallConstData.goodUpList[_local4].Count <= 0){
                            _local6 = StallConstData.goodUpList[_local4].Place;
                            if ((((ItemConst.placeToPanel(_local6) == -1)) || ((ItemConst.placeToOffset(_local6) == -1)))){
                                return;
                            };
                            if (BagData.SelectIndex == ItemConst.placeToPanel(_local6)){
                                if (BagData.GridUnitList[BagData.SelectIndex][(ItemConst.placeToOffset(_local6) % BagData.MAX_GRIDS)].Item){
                                    BagData.GridUnitList[BagData.SelectIndex][(ItemConst.placeToOffset(_local6) % BagData.MAX_GRIDS)].Item.IsLock = false;
                                };
                            };
                            BagData.AllLocks[ItemConst.placeToPanel(_local6)][ItemConst.placeToOffset(_local6)] = false;
                            StallConstData.goodUpList[_local4] = null;
                        };
                    } else {
                        if (StallConstData.goodDownList[_local4] == null){
                            return;
                        };
                        StallConstData.goodDownList[_local4].Count = (StallConstData.goodDownList[_local4].Count - _arg1.getBody().num);
                        _local18 = stallUIManager.countMoney(StallConstData.goodDownList[_local4].price, _arg1.getBody().num);
                        StallConstData.moneyPay[2] = (StallConstData.moneyPay[2] + _local18[2]);
                        StallConstData.moneyPay[1] = ((StallConstData.moneyPay[1] + _local18[1]) + uint((StallConstData.moneyPay[2] / 100)));
                        StallConstData.moneyPay[2] = (StallConstData.moneyPay[2] % 100);
                        StallConstData.moneyPay[0] = ((StallConstData.moneyPay[0] + _local18[0]) + uint((StallConstData.moneyPay[1] / 100)));
                        StallConstData.moneyPay[1] = (StallConstData.moneyPay[1] % 100);
                        stallUIManager.showMoney(4);
                        if (StallConstData.goodDownList[_local4].Count <= 0){
                            _local6 = StallConstData.goodDownList[_local4].Place;
                            if ((((ItemConst.placeToPanel(_local6) == -1)) || ((ItemConst.placeToOffset(_local6) == -1)))){
                                return;
                            };
                            BagData.AllLocks[ItemConst.placeToPanel(_local6)][ItemConst.placeToOffset(_local6)] = false;
                            StallConstData.goodDownList[_local4] = null;
                        };
                    };
                    StallConstData.SelectedItem = null;
                    if (_arg1.getBody().upFlag == 0){
                        stallGridManager.removeAllItem();
                        StallConstData.SelectedItem = null;
                        stallGridManager.removeAllFrames();
                        stallGridManager.showItems(StallConstData.goodUpList);
                    } else {
                        stallDownGridManager.removeAllItem();
                        StallConstData.SelectedDownItem = null;
                        stallDownGridManager.removeAllFrames();
                        stallDownGridManager.showItems(StallConstData.goodDownList);
                    };
                    refreshSelfMoney();
                    break;
                case StallEvents.DELSTALLITEM:
                    _local6 = int(_arg1.getBody().index);
                    StallConstData.goodUpList[_local6] = null;
                    StallConstData.copyGoodUpList[_local6] = null;
                    stallGridManager.removeAllItem();
                    StallConstData.SelectedItem = null;
                    StallConstData.idToPlace1--;
                    StallConstData.sellNum--;
                    if (_local6 < StallConstData.sellNum){
                        sortGoods(_local6, 0);
                    };
                    stallGridManager.removeAllFrames();
                    stallGridManager.showItems(StallConstData.goodUpList);
                    StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
                    sendNotification(EventList.BAGITEMUNLOCK, int(_arg1.getBody().id));
                    break;
                case StallEvents.DELDOWNSTALLITEM:
                    _local6 = int(_arg1.getBody().index);
                    StallConstData.goodDownList[_local6] = null;
                    StallConstData.copyGoodDownList[_local6] = null;
                    stallDownGridManager.removeAllItem();
                    StallConstData.SelectedDownItem = null;
                    StallConstData.idToPlace2--;
                    StallConstData.buyNum--;
                    if (_local6 < StallConstData.buyNum){
                        sortGoods(_local6, 1);
                    };
                    stallDownGridManager.removeAllFrames();
                    stallDownGridManager.showItems(StallConstData.goodDownList);
                    StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    sendNotification(EventList.BAGITEMUNLOCK, int(_arg1.getBody().id));
                    break;
                case EventList.STALLITEM:
                    if (moneyOpType == 0){
                        stallGridManager.unLockGrids();
                        stallUIManager.unLockBtns();
                        stallGridManager.removeAllItem();
                        StallConstData.SelectedItem = null;
                        stallGridManager.removeAllFrames();
                        stallGridManager.showItems(StallConstData.goodUpList);
                        StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
                    } else {
                        stallDownGridManager.unLockGrids();
                        stallUIManager.unLockBtns();
                        stallDownGridManager.removeAllItem();
                        StallConstData.SelectedDownItem = null;
                        stallDownGridManager.removeAllFrames();
                        stallDownGridManager.showItems(StallConstData.goodDownList);
                        StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    };
                    break;
                case EventList.STALLALLITEM:
                    stallGridManager.unLockGrids();
                    stallDownGridManager.unLockGrids();
                    stallUIManager.unLockBtns();
                    stallGridManager.removeAllItem();
                    stallDownGridManager.removeAllItem();
                    StallConstData.SelectedItem = null;
                    StallConstData.SelectedDownItem = null;
                    stallGridManager.removeAllFrames();
                    stallDownGridManager.removeAllFrames();
                    stallGridManager.showItems(StallConstData.goodUpList);
                    StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
                    stallDownGridManager.showItems(StallConstData.goodDownList);
                    StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    break;
                case StallEvents.REFRESHMONEY:
                    if ((((GameCommonData.Player.Role.Id == StallConstData.stallIdToQuery)) || ((StallConstData.stallIdToQuery == 0)))){
                        StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, uint(stall.content.content13.txtInputNum.text));
                    } else {
                        StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0, uint(stall.content.content13.txtInputNum.text));
                    };
                    break;
                case StallEvents.REFRESHDOWNMONEY:
                    if (StallConstData.SelectedDownItem){
                        _local19 = BagData.getCountsByTemplateId((StallConstData.SelectedDownItem.Item as UseItem).itemIemplateInfo.TemplateID);
                        if (_local19 == 0){
                            stall.content.content23.txtInputSellNum.text = "0";
                        } else {
                            stall.content.content23.txtInputSellNum.text = "1";
                        };
                    };
                    if ((((GameCommonData.Player.Role.Id == StallConstData.stallIdToQuery)) || ((StallConstData.stallIdToQuery == 0)))){
                        StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
                    } else {
                        StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2, uint(stall.content.content23.txtInputSellNum.text));
                    };
                    break;
                case StallEvents.SELECTDOWNITEM:
                    break;
                case StallEvents.REFRESHMONEYSEFLSTALL:
                    refreshSelfMoney();
                    break;
                case StallEvents.REMOVESTALL:
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(EventList.SHOWALERT, {
                            comfrim:closeStall,
                            cancel:cancelClose,
                            info:LanguageMgr.GetTranslation("真要收摊否"),
                            title:LanguageMgr.GetTranslation("提 示")
                        });
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("你已不在摆摊状态"),
                            color:0xFFFF00
                        });
                    };
                    break;
                case StallEvents.ERRORSTALL:
                    if (_arg1.getBody().flag == 0){
                        stallGridManager.removeAllFrames();
                        stallGridManager.showItems(StallConstData.goodUpList);
                    } else {
                        stallDownGridManager.removeAllFrames();
                        stallDownGridManager.showItems(StallConstData.goodDownList);
                    };
                    break;
                case EventList.ENDSTALL:
                    _local20 = ("stall_" + String(_arg1.getBody()));
                    _local21 = GameCommonData.Player.getChildByName(_local20);
                    if (_arg1.getBody() == GameCommonData.Player.Role.Id){
                        if (((_local21) && (GameCommonData.Player.contains(_local21)))){
                            GameCommonData.Player.removeChild(_local21);
                        };
                    } else {
                        if (((_local21) && (GameCommonData.SameSecnePlayerList[int(_arg1.getBody)].contains(_local21)))){
                            GameCommonData.SameSecnePlayerList[int(_arg1.getBody)].removeChild(_local21);
                        };
                    };
                    if (GameCommonData.Player.Role.Id == _arg1.getBody()){
                        facade.sendNotification(EventList.UPDATEBAG);
                        StallConstData.buyNum = 0;
                        StallConstData.sellNum = 0;
                        UIConstData.KeyBoardCanUse = true;
                        BagData.lockBagGridUnit(true);
                        BagData.lockBtnCleanAndPage(true);
                        endStall();
                        BagData.clearLocks();
                    } else {
                        _local7 = GameCommonData.SameSecnePlayerList[_arg1.getBody()];
                        if (_local7){
                            _local7.removeChildAt(0);
                            _local7.Role.State = GameRole.STATE_NULL;
                            UIConstData.KeyBoardCanUse = true;
                            _local7.ShowName();
                            _local7.ShowTitle();
                            _local7.Role.StallId = 0;
                            _local7.PlayerStall();
                        };
                        if (StallConstData.stallIdToQuery == _arg1.getBody()){
                            StallConstData.stallIdToQuery = 0;
                            gcAll();
                            if (dataProxy.BagIsOpen){
                                facade.sendNotification(EventList.CLOSEBAG);
                            };
                        };
                    };
                    break;
                case StallEvents.RESETCOUNT:
                    resetCount(uint(_arg1.getBody()));
                    break;
            };
        }
        private function readyStall():void{
            var _local2:InventoryItemInfo;
            var _local3:uint;
            var _local4:*;
            if (dataProxy.DepotIsOpen){
                sendNotification(EventList.CLOSEDEPOTVIEW);
            };
            StallConstData.moneyGet = [0, 0, 0];
            StallConstData.moneyPay = [0, 0, 0];
            StallConstData.goodUpList = new Array(StallConstData.GRID_NUM);
            StallConstData.goodDownList = new Array(StallConstData.DOWN_GRID_NUM);
            StallConstData.stallName = StallConstData.copyStallName;
            StallConstData.sellNum = 0;
            StallConstData.buyNum = 0;
            var _local1:uint;
            _local1 = 0;
            while (_local1 < StallConstData.GRID_NUM) {
                if (StallConstData.copyGoodUpList[_local1]){
                    _local2 = BagData.getItemById(StallConstData.copyGoodUpList[_local1].id);
                    if ((((((_local2 == null)) || ((_local2.Flags & ItemConst.FlAGS_TRADE)))) || ((_local2.isBind == 1)))){
                    } else {
                        StallConstData.idToPlace1++;
                        StallConstData.goodUpList[StallConstData.idToPlace1] = new Object();
                        StallConstData.goodUpList[StallConstData.idToPlace1].index = StallConstData.idToPlace1;
                        StallConstData.goodUpList[StallConstData.idToPlace1].type = StallConstData.copyGoodUpList[_local1].type;
                        StallConstData.goodUpList[StallConstData.idToPlace1].price = StallConstData.copyGoodUpList[_local1].price;
                        StallConstData.goodUpList[StallConstData.idToPlace1].id = StallConstData.copyGoodUpList[_local1].id;
                        StallConstData.goodUpList[StallConstData.idToPlace1].Count = StallConstData.copyGoodUpList[_local1].Count;
                        StallConstData.goodUpList[StallConstData.idToPlace1].Place = _local2.Place;
                        if (StallConstData.goodUpList[StallConstData.idToPlace1].Count >= _local2.Count){
                            StallConstData.goodUpList[StallConstData.idToPlace1].Count = _local2.Count;
                        };
                        _local3 = _local2.Place;
                        if ((((BagData.SelectIndex == ItemConst.placeToPanel(_local3))) && ((BagData.currentPage == ((ItemConst.placeToOffset(_local3) / BagData.MAX_GRIDS) + 1))))){
                            BagData.GridUnitList[BagData.SelectIndex][(ItemConst.placeToOffset(_local3) % BagData.MAX_GRIDS)].Item.IsLock = true;
                        };
                        _local4 = ItemConst.placeToOffset(_local3);
                        BagData.AllLocks[ItemConst.placeToPanel(_local3)][ItemConst.placeToOffset(_local3)] = true;
                        StallConstData.sellNum++;
                    };
                };
                if (StallConstData.copyGoodDownList[_local1]){
                    _local2 = BagData.getItemById(StallConstData.copyGoodDownList[_local1].id);
                    if (_local2){
                        StallConstData.idToPlace2++;
                        StallConstData.goodDownList[StallConstData.idToPlace2] = new Object();
                        StallConstData.goodDownList[StallConstData.idToPlace2].index = StallConstData.idToPlace2;
                        StallConstData.goodDownList[StallConstData.idToPlace2].type = StallConstData.copyGoodDownList[_local1].type;
                        StallConstData.goodDownList[StallConstData.idToPlace2].price = StallConstData.copyGoodDownList[_local1].price;
                        StallConstData.goodDownList[StallConstData.idToPlace2].id = StallConstData.copyGoodDownList[_local1].id;
                        StallConstData.goodDownList[StallConstData.idToPlace2].Count = StallConstData.copyGoodDownList[_local1].Count;
                        StallConstData.goodDownList[StallConstData.idToPlace2].Place = _local2.Place;
                        _local3 = _local2.Place;
                        if (BagData.SelectIndex == ItemConst.placeToPanel(_local3)){
                            BagData.GridUnitList[BagData.SelectIndex][(ItemConst.placeToOffset(_local3) % BagData.MAX_GRIDS)].Item.IsLock = true;
                        };
                        BagData.AllLocks[ItemConst.placeToPanel(_local3)][ItemConst.placeToOffset(_local3)] = true;
                        StallConstData.buyNum++;
                    };
                };
                _local1++;
            };
            StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
            StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2);
            stallUIManager.setModel(0);
            stall.content.txtStallName.text = StallConstData.stallName;
            initStall();
            stallGridManager.addMouseDown();
            stallDownGridManager.addMouseDown();
            stallGridManager.removeAllItem();
            stallDownGridManager.removeAllItem();
            stallGridManager.showItems(StallConstData.goodUpList);
            stallDownGridManager.showItems(StallConstData.goodDownList);
            addLis();
            dataProxy.StallIsOpen = true;
            stall.content.txtOwerName.text = GameCommonData.Player.Role.Name.toString();
            refreshSelfMoney();
            StallConstData.stallIdToQuery = 0;
            StallConstData.stallOwnerName = GameCommonData.Player.Role.Name;
        }
        private function refreshSelfMoney():void{
            stall.content.txtMoney4.text = uint((GameCommonData.Player.Role.Gold / 10000));
            stall.content.txtMoney5.text = uint(((GameCommonData.Player.Role.Gold % 10000) / 100));
            stall.content.txtMoney6.text = uint((GameCommonData.Player.Role.Gold % 100));
        }
        private function closeMoneyPanel():void{
            stallGridManager.unLockGrids();
            stallDownGridManager.unLockGrids();
            stallUIManager.unLockBtns();
            BagData.lockBagGridUnit(true);
            sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
            if (moneyOpType == 0){
                StallConstData.goodUpList[StallConstData.idToPlace1] = null;
                StallConstData.idToPlace1--;
                StallConstData.sellNum--;
            } else {
                StallConstData.goodDownList[StallConstData.idToPlace2] = null;
                StallConstData.idToPlace2--;
                StallConstData.buyNum--;
            };
            gcMoneyPanel();
            moneycontent.txtInputCount.text = "1";
        }
        public function get stallPanel():StallView{
            return ((this.viewComponent as StallView));
        }
        private function setTextpos(_arg1:TextField, _arg2:int, _arg3:int):void{
            _arg1.x = _arg2;
            _arg1.y = _arg3;
            _arg1.width = ((_arg1.width > 30)) ? _arg1.width : 30;
            _arg1.height = 20;
        }
        private function addLis():void{
            if ((((StallConstData.stallIdToQuery == 0)) || ((GameCommonData.Player.Role.Id == StallConstData.stallIdToQuery)))){
                stall.content._btnStartStall.addEventListener(MouseEvent.CLICK, btnClickHandler);
                stall.content._btnCloseStall.addEventListener(MouseEvent.CLICK, btnClickHandler);
                stall.content._btnClearStall.addEventListener(MouseEvent.CLICK, btnClickHandler);
                stall.content.txtStallName.addEventListener(Event.CHANGE, inputHandler);
                stall.content.txtStallName.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
                stall.content.txtStallName.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
                moneycontent.txtInputCount.addEventListener(Event.CHANGE, inputHandler);
                moneycontent.txtJin.addEventListener(Event.CHANGE, inputHandler);
                moneycontent.txtYin.addEventListener(Event.CHANGE, inputHandler);
                moneycontent.txtTong.addEventListener(Event.CHANGE, inputHandler);
                stall.content._btnPrivate.visible = false;
            } else {
                if (StallConstData.stallIdToQuery != GameCommonData.Player.Role.Id){
                    stall.content._btnPrivate.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    stall.content._btnPrivate.visible = true;
                    stall.content.content13._btnBuy.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    stall.content.content23._btnSell.addEventListener(MouseEvent.CLICK, btnClickHandler);
                    stall.content.content13.txtInputNum.addEventListener(Event.CHANGE, inputHandler);
                    stall.content.content23.txtInputSellNum.addEventListener(Event.CHANGE, inputHandler);
                };
            };
            moneycontent._btnInputSure.addEventListener(MouseEvent.CLICK, btnClickHandler);
            moneycontent._btnInputCancel.addEventListener(MouseEvent.CLICK, btnClickHandler);
            moneycontent._btnMax.addEventListener(MouseEvent.CLICK, btnClickHandler);
            moneycontent.btnAdd.addEventListener(MouseEvent.CLICK, btnClickHandler);
            moneycontent.btnSub.addEventListener(MouseEvent.CLICK, btnClickHandler);
        }
        private function checkMoneyOutRange():Boolean{
            var _local1:Boolean;
            StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
            var _local2:uint = (StallConstData.moneyAll[0] + (GameCommonData.Player.Role.Money / 10000));
            if (_local2 >= 400000){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:"金币超出了上限",
                    color:0xFFFF00
                });
                _local1 = true;
            } else {
                if (_local2 >= 399999){
                    if ((((StallConstData.moneyAll[1] * 100) + StallConstData.moneyAll[2]) + (GameCommonData.Player.Role.Money % 10000)) > 10000){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:"金币超出了上限",
                            color:0xFFFF00
                        });
                        _local1 = true;
                    };
                };
            };
            if (_local1){
                facade.sendNotification(EventList.BAGITEMUNLOCK, idToAdd);
                StallConstData.goodUpList[StallConstData.idToPlace1] = null;
                StallConstData.sellNum--;
                StallConstData.idToPlace1--;
                StallConstData.moneyAll = stallUIManager.refreshMoney(StallConstData.goodUpList, 0);
            };
            return (_local1);
        }
        private function initView():void{
            setViewComponent(new StallView());
            stallPanel.closeCallBack = stallCloseHandler;
            moneycontent = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("StallOperator");
            gridSprite = new MovieClip();
            gridSprite.name = "stall";
            gridDownSprite = new MovieClip();
            gridDownSprite.name = "stall";
            stallUIManager = new StallUIManager((stall.content as MovieClip));
            moneyPanel = new HFrame();
            moneyPanel.titleText = LanguageMgr.GetTranslation("单价输入");
            moneyPanel.blackGound = true;
            moneyPanel.centerTitle = true;
            moneycontent.x = 20;
            moneycontent.y = 40;
            moneyPanel.closeCallBack = closeMoneyPanel;
            moneyPanel.addChild(moneycontent);
            moneyPanel.setSize((moneycontent.width + 40), (moneycontent.height + 50));
            moneyPanel.name = "MoneyInpu";
            moneyPanel.addEventListener(Event.CLOSE, moneyCloseHandler);
            moneyPanel.x = StallConstData.MONEY_DEFAULT_POS.x;
            moneyPanel.y = StallConstData.MONEY_DEFAULT_POS.y;
            UIUtils.ReplaceButtonNTextFieldToButton(moneycontent, LanguageMgr.GetTranslation("确定"), "btnInputSure");
            UIUtils.ReplaceButtonNTextFieldToButton(moneycontent, LanguageMgr.GetTranslation("取消"), "btnInputCancel");
            UIUtils.ReplaceButtonNTextFieldToButton(moneycontent, LanguageMgr.GetTranslation("最大"), "btnMax");
            moneycontent["txtInputCount"].text = "1";
            moneycontent.txtJin.restrict = "0-9";
            moneycontent.txtYin.restrict = "0-9";
            moneycontent.txtTong.restrict = "0-9";
            moneycontent.txtInputCount.restrict = "0-9";
            stall.content.content13.txtInputNum.restrict = "0-9";
            stall.content.content23.txtInputSellNum.restrict = "0-9";
            stall.content.content13.txtInputNum.text = "0";
            stall.content.content23.txtInputSellNum.text = "0";
            initGrid();
            initDownGrid();
        }
        private function delayBeginStall():void{
            clearInterval(delayNumber);
            StallSend.beginStall(StallConstData.stallName, StallConstData.sellNum, StallConstData.goodUpList, StallConstData.buyNum, StallConstData.goodDownList);
        }
        private function sortGoods(_arg1:uint, _arg2:uint):void{
        }
        private function alertBack():void{
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.RESIZE_STAGE, EventList.SHOWSTALL, EventList.CLOSESTALL, EventList.BEGINSTALL, EventList.GETSTALLITEMS, StallEvents.SHOWSOMESTALL, EventList.STALLITEM, EventList.STALLALLITEM, EventList.BAGTOSTALL, EventList.BAGTODOWNSTALL, StallEvents.UPDATESTALLITEM, StallEvents.UPDATEDOWNSTALLITEM, StallEvents.STALLRESULT, StallEvents.STALLNAME, StallEvents.REFRESHMONEY, StallEvents.REFRESHDOWNMONEY, StallEvents.SELECTDOWNITEM, StallEvents.REFRESHMONEYSEFLSTALL, StallEvents.DELSTALLITEM, StallEvents.DELDOWNSTALLITEM, StallEvents.REMOVESTALL, StallEvents.RESETCOUNT, EventList.ENDSTALL, StallEvents.ERRORSTALL]);
        }
        private function initStall():void{
            stall.addChild(gridSprite);
            stall.addChild(gridDownSprite);
            GameCommonData.GameInstance.GameUI.addChild(stallPanel);
            EffectLib.checkTranslationByShow(stallPanel, GameCommonData.GameInstance.stage);
        }
        private function clearItems():void{
            var _local1:int;
            var _local2:int;
            while (_local1 < StallConstData.goodUpList.length) {
                if (((StallConstData.goodUpList[_local1]) && (StallConstData.goodUpList[_local1].id))){
                    _local2 = StallConstData.goodUpList[_local1].id;
                    sendNotification(EventList.BAGITEMUNLOCK, _local2);
                    StallConstData.goodUpList[_local1] = null;
                };
                _local1++;
            };
            _local1 = 0;
            while (_local1 < StallConstData.goodDownList.length) {
                if (((StallConstData.goodDownList[_local1]) && (StallConstData.goodDownList[_local1].id))){
                    _local2 = StallConstData.goodDownList[_local1].id;
                    sendNotification(EventList.BAGITEMUNLOCK, _local2);
                    StallConstData.goodDownList[_local1] = null;
                };
                _local1++;
            };
        }
        private function focusInHandler(_arg1:FocusEvent):void{
            GameCommonData.isFocusIn = true;
            IME.enabled = true;
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < StallConstData.GRID_NUM) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = (_local1.width * (_local3 % 6));
                _local1.y = (_local1.height * int((_local3 / 6)));
                _local1.name = ("stall_" + _local3.toString());
                gridSprite.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = gridSprite;
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                StallConstData.GridUnitList.push(_local2);
                _local3++;
            };
            gridSprite.x = GRID_STARTPOS.x;
            gridSprite.y = GRID_STARTPOS.y;
            stallPanel.addChild(gridSprite);
            stallGridManager = new StallGridManager(StallConstData.GridUnitList, gridSprite);
            facade.registerProxy(stallGridManager);
            stallGridManager.Initialize();
        }
        private function removeLis():void{
            if (stall.content._btnPrivate.hasEventListener(MouseEvent.CLICK)){
                stall.content._btnPrivate.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content._btnStartStall.hasEventListener(MouseEvent.CLICK)){
                stall.content._btnStartStall.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content._btnCloseStall.hasEventListener(MouseEvent.CLICK)){
                stall.content._btnCloseStall.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content._btnClearStall.hasEventListener(MouseEvent.CLICK)){
                stall.content._btnClearStall.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content.content13._btnBuy.hasEventListener(MouseEvent.CLICK)){
                stall.content.content13._btnBuy.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content.content23._btnSell.hasEventListener(MouseEvent.CLICK)){
                stall.content.content23._btnSell.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content.txtStallName.hasEventListener(Event.CHANGE)){
                stall.content.txtStallName.removeEventListener(Event.CHANGE, inputHandler);
            };
            if (stall.content.txtStallName.hasEventListener(FocusEvent.FOCUS_IN)){
                stall.content.txtStallName.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
            };
            if (stall.content.txtStallName.hasEventListener(FocusEvent.FOCUS_OUT)){
                stall.content.txtStallName.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
            };
            if (moneycontent._btnInputSure.hasEventListener(MouseEvent.CLICK)){
                moneycontent._btnInputSure.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (moneycontent._btnInputCancel.hasEventListener(MouseEvent.CLICK)){
                moneycontent._btnInputCancel.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (moneycontent._btnMax.hasEventListener(MouseEvent.CLICK)){
                moneycontent.btnMax.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (moneycontent.btnAdd.hasEventListener(MouseEvent.CLICK)){
                moneycontent.btnAdd.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (moneycontent.btnSub.hasEventListener(MouseEvent.CLICK)){
                moneycontent.btnSub.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (stall.content.content13.txtInputNum.hasEventListener(Event.CHANGE)){
                stall.content.content13.txtInputNum.removeEventListener(Event.CHANGE, inputHandler);
            };
            if (stall.content.content23.txtInputSellNum.hasEventListener(Event.CHANGE)){
                stall.content.content23.txtInputSellNum.removeEventListener(Event.CHANGE, inputHandler);
            };
            if (moneycontent.txtInputCount.hasEventListener(Event.CHANGE)){
                moneycontent.txtInputCount.removeEventListener(Event.CHANGE, inputHandler);
            };
            if (moneycontent.txtJin.hasEventListener(Event.CHANGE)){
                moneycontent.txtJin.removeEventListener(Event.CHANGE, inputHandler);
            };
            if (moneycontent.txtYin.hasEventListener(Event.CHANGE)){
                moneycontent.txtYin.removeEventListener(Event.CHANGE, inputHandler);
            };
            if (moneycontent.txtTong.hasEventListener(Event.CHANGE)){
                moneycontent.txtTong.removeEventListener(Event.CHANGE, inputHandler);
            };
        }
        private function resetDownCount(_arg1:uint):void{
            stall.content.content23.txtInputSellNum.text = String(_arg1);
            StallConstData.moneyDownAll = stallUIManager.refreshMoney(StallConstData.goodDownList, 2, uint(stall.content.content23.txtInputSellNum.text));
        }

    }
}//package GameUI.Modules.Stall.Mediator 
