//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCExchange.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.MouseCursor.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Mediator.*;
    import GameUI.View.*;
    import GameUI.Modules.Maket.Data.*;
    import flash.filters.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCExchange.Data.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.NPCShop.Data.*;
    import GameUI.Modules.NPCExchange.Proxy.*;
    import GameUI.*;
    //import GameUI.Modules.NPCExchange.UI.*;

    public class NPCExchangeMediator extends Mediator {

        public static const NAME:String = "NPCExchangeMediator";

        private var srcGoodNumList:Array;
        private var gridManager:NPCExchangeGridManager = null;
        private var maxCount:uint;
        private var exchangeFaceItem:Array;
        private var npcId:int = 0;
        private var isReparing:Boolean = false;
        private var shopName:String = "";
        private var dataProxy:DataProxy = null;
        private var redFilter:GlowFilter = null;
        private var mosterId:int = 0;
        private var srcGoodList:Array;

        public function NPCExchangeMediator(){
            exchangeFaceItem = new Array(2);
            super(NAME);
        }
        private function clearItem(_arg1:uint):void{
            if (((exchangeFaceItem[_arg1]) && (exchangeFaceItem[_arg1].parent))){
                exchangeFaceItem[_arg1].parent.removeChild(exchangeFaceItem[_arg1]);
                exchangeFaceItem[_arg1] = null;
            };
            exchangeView.content[("txt_ExchangeName" + _arg1)].text = "";
            exchangeView.content[("txt_ExchangeCount" + _arg1)].text = "";
        }
        private function mouseOverHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.mcRed.visible = true;
        }
        private function removeAllFrames():void{
            if (NPCExchangeConstData.selectedIndex == -1){
                return;
            };
            gridManager.removeFrame();
        }
        private function inputHandler(_arg1:Event):void{
            var _local2:int;
            var _local3:Object;
            var _local4:Number;
            var _local5:Number;
            var _local6:String;
            if (NPCExchangeConstData.selectedIndex == -1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:"请先选择物品",
                    color:0xFFFF00
                });
                exchangeView.content.txtInputCount.text = "1";
                return;
            };
            _local2 = int(exchangeView.content.txtInputCount.text);
            if (_local2 <= 0){
                _local2 = 1;
                exchangeView.content.txtInputCount.text = "1";
            };
            if (NPCExchangeConstData.selectedIndex > -1){
                _local3 = NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][NPCExchangeConstData.selectedIndex];
                if (_local2 > maxCount){
                    exchangeView.content.txtInputCount.text = maxCount.toString();
                    _local2 = maxCount;
                };
            };
            refreshExchangeItem();
        }
        private function exchangeGood():void{
            var _local1:int;
            var _local2:int;
            var _local3:Object;
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            if (NPCExchangeConstData.selectedIndex > -1){
                _local1 = int(exchangeView.content.txtInputCount.text);
                _local4 = 0;
                _local4 = 0;
                while (_local4 < srcGoodList.length) {
                    _local6 = uint(srcGoodList[_local4]);
                    if (_local6 >= 10){
                        if (_local6 == 50400001){
                            _local5 = uint((GameCommonData.Player.Role.Gold / 10000));
                        } else {
                            if (_local6 == 50500001){
                                _local5 = uint((GameCommonData.Player.Role.Money / 100));
                            } else {
                                _local5 = BagData.getCountsByTemplateId(_local6, false);
                            };
                        };
                    } else {
                        _local5 = GameCommonData.Player.Role.OfferValue[(_local6 - 1)];
                    };
                    _local7 = (uint(srcGoodNumList[_local4]) * _local1);
                    if ((((uint(srcGoodList[_local4]) > 0)) && ((_local5 < _local7)))){
                        if (uint(srcGoodList[_local4]) > 9){
                            if (uint(srcGoodList[_local4]) == 50400001){
                                facade.sendNotification(HintEvents.RECEIVEINFO, {
                                    info:LanguageMgr.GetTranslation("金币不足够,无法兑换"),
                                    color:0xFFFF00
                                });
                            } else {
                                if (uint(srcGoodList[_local4]) == 50500001){
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:LanguageMgr.GetTranslation("金叶子不足够,无法兑换"),
                                        color:0xFFFF00
                                    });
                                } else {
                                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                                        info:LanguageMgr.GetTranslation("物品数量不足够,无法兑换"),
                                        color:0xFFFF00
                                    });
                                };
                            };
                        } else {
                            facade.sendNotification(HintEvents.RECEIVEINFO, {
                                info:LanguageMgr.GetTranslation("声望点数不足够,无法兑换"),
                                color:0xFFFF00
                            });
                        };
                        return;
                    };
                    _local4++;
                };
                _local2 = NPCExchangeConstData.selectedIndex;
                _local3 = NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][_local2];
                if ((_local3.SellFlag & ShopItemInfo.SELLING_FLAG_LIMIT) != 0){
                    if ((GameCommonData.activityData[72] & (1 << (_local3.SortVal - 1))) != 0){
                        MessageTip.popup("该物品每日仅能兑换1个");
                        return;
                    };
                };
                NPCShopSend.buyNPCItem(npcId, _local3.ShopId, _local1);
            } else {
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:"请先选择物品",
                    color:0xFFFF00
                });
            };
        }
        private function refreshExchangeItem():void{
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            if (NPCExchangeConstData.selectedIndex == -1){
                clearItem(0);
                clearItem(1);
                return;
            };
            var _local1:uint;
            _local1 = 0;
            while (_local1 < srcGoodList.length) {
                clearItem(_local1);
                if (uint(srcGoodList[_local1]) > 0){
                    _local2 = uint(srcGoodList[_local1]);
                    if (_local2 < 10){
                        exchangeFaceItem[_local1] = new FaceItem(("job" + String(_local2)), exchangeView.content[("mcExchangeGood_" + _local1)]);
                    } else {
                        exchangeFaceItem[_local1] = new FaceItem(UIConstData.ItemDic[_local2].img, exchangeView.content[("mcExchangeGood_" + _local1)]);
                    };
                    exchangeFaceItem[_local1].x = 0;
                    exchangeFaceItem[_local1].y = 0;
                    exchangeFaceItem[_local1].setEnable(true);
                    exchangeFaceItem[_local1].name = ("srcNPCExchangePhoto_" + uint(srcGoodList[_local1]));
                    _local3 = (uint(srcGoodNumList[_local1]) * uint(exchangeView.content.txtInputCount.text));
                    if (_local2 >= 10){
                        if (uint(srcGoodList[_local1]) == 50400001){
                            _local4 = uint((GameCommonData.Player.Role.Gold / 10000));
                        } else {
                            if (uint((srcGoodList[_local1] == 50500001))){
                                _local4 = uint((GameCommonData.Player.Role.Money / 100));
                            } else {
                                _local4 = BagData.getCountsByTemplateId(uint(srcGoodList[_local1]), false);
                            };
                        };
                        exchangeView.content[("txt_ExchangeName" + _local1)].text = UIConstData.ItemDic[uint(srcGoodList[_local1])].Name;
                        exchangeView.content[("txt_ExchangeCount" + _local1)].text = (((((LanguageMgr.GetTranslation("数量") + ":(") + _local4) + "/") + _local3) + ")");
                    } else {
                        _local4 = GameCommonData.Player.Role.OfferValue[(_local2 - 1)];
                        exchangeView.content[("txt_ExchangeName" + _local1)].text = LanguageMgr.GetTranslation(("声望" + (_local2 - 1).toString()));
                        exchangeView.content[("txt_ExchangeCount" + _local1)].text = (((((LanguageMgr.GetTranslation("点数") + ":(") + _local4) + "/") + _local3) + ")");
                    };
                    exchangeView.content[("mcExchangeGood_" + _local1)].addChild(exchangeFaceItem[_local1]);
                    if (_local4 < _local3){
                        exchangeView.content[("txt_ExchangeName" + _local1)].textColor = 0xFF0000;
                        exchangeView.content[("txt_ExchangeCount" + _local1)].textColor = 0xFF0000;
                    } else {
                        exchangeView.content[("txt_ExchangeName" + _local1)].textColor = 0xFF00;
                        exchangeView.content[("txt_ExchangeCount" + _local1)].textColor = 0xFF00;
                    };
                };
                _local1++;
            };
        }
        private function clearData():void{
            var _local1:int;
            var _local2:int;
            while (_local2 < 24) {
                _local1 = 0;
                while (_local1 < (exchangeView.getChildByName(("NPCExchange_" + _local2)) as MovieClip).numChildren) {
                    if (((exchangeView.getChildByName(("NPCExchange_" + _local2)) as MovieClip).getChildAt(_local1) is ItemBase)){
                        (exchangeView.getChildByName(("NPCExchange_" + _local2)) as MovieClip).removeChild((exchangeView.getChildByName(("NPCExchange_" + _local2)) as MovieClip).getChildAt(_local1));
                        break;
                    };
                    _local1++;
                };
                exchangeView.getChildByName(("NPCExchange_" + _local2)).removeEventListener(MouseEvent.CLICK, goodSelectHandler);
                _local2++;
            };
            _local2 = 0;
            while (_local2 < 2) {
                if (((exchangeFaceItem[_local2]) && (exchangeFaceItem[_local2].parent))){
                    exchangeFaceItem[_local2].parent.removeChild(exchangeFaceItem[_local2]);
                    exchangeFaceItem[_local2] = null;
                    exchangeView.content[("txt_ExchangeName" + _local2)].text = "";
                    exchangeView.content[("txt_ExchangeCount" + _local2)].text = "";
                };
                _local2++;
            };
            NPCExchangeConstData.selectedIndex = -1;
            exchangeView.content.txtInputCount.text = "1";
        }
        private function setPos():void{
            exchangeView.x = ((facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.x - exchangeView.frameWidth);
            exchangeView.y = (facade.retrieveMediator(BagMediator.NAME) as BagMediator).bag.y;
        }
        private function updateData():void{
            var _local1:FaceItem;
            var _local3:int;
            var _local2:Array = NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType];
            while (_local3 < _local2.length) {
                if (_local2[_local3]){
                    if (mosterId == NPCExchangeConstData.towerMosterID){
                        _local1 = new FaceItem(_local2[_local3].img, (exchangeView.getChildByName(("NPCExchange_" + _local3)) as MovieClip), "bagIcon", 1, _local2[_local3].curr_amount);
                        _local1.Num = _local2[_local3].curr_amount;
                    } else {
                        _local1 = new FaceItem(_local2[_local3].img, (exchangeView.getChildByName(("NPCExchange_" + _local3)) as MovieClip));
                        _local1.Num = _local2[_local3].SCount;
                    };
                    if ((_local2[_local3].SellFlag & ShopItemInfo.SELLING_FLAG_LIMIT) != 0){
                        if ((GameCommonData.activityData[72] & (1 << (_local2[_local3].SortVal - 1))) != 0){
                            _local1.setNum(0);
                        } else {
                            _local1.setNum(1);
                        };
                    };
                    _local1.x = 0;
                    _local1.y = 0;
                    _local1.setEnable(true);
                    _local1.name = ("dstNPCExchangePhoto_" + _local2[_local3].type);
                    (exchangeView.getChildByName(("NPCExchange_" + _local3)) as MovieClip).addChild(_local1);
                    exchangeView.getChildByName(("NPCExchange_" + _local3)).addEventListener(MouseEvent.CLICK, goodSelectHandler);
                };
                _local3++;
                if (_local3 >= 24){
                    break;
                };
            };
        }
        private function initView():void{
            var _local1:uint;
            setViewComponent(new NPCExchangeUIView(shopName));
            exchangeView.closeCallBack = panelCloseHandler;
            initGrid();
            GameCommonData.GameInstance.GameUI.addChild(exchangeView);
            if (((NPCExchangeConstData.goodList[mosterId][1][0]) && ((NPCExchangeConstData.goodList[mosterId][1][0].MainClass == ItemConst.ITEM_CLASS_EQUIP)))){
                _local1 = 0;
                while (_local1 < 5) {
                    NPCExchangeConstData.goodList[mosterId][_local1].sortOn(["Job", "RequiredLevel"], [Array.DESCENDING]);
                    exchangeView.content[("mcPage_" + _local1)].visible = true;
                    exchangeView.content[("txtPage_" + _local1)].visible = true;
                    exchangeView.content[("mcPage_" + _local1)].buttonMode = true;
                    exchangeView.content[("txtPage_" + _local1)].mouseEnabled = false;
                    exchangeView.content[("mcPage_" + _local1)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                    if (_local1 == 0){
                        exchangeView.content[("mcPage_" + _local1)].gotoAndStop(1);
                        exchangeView.content[("txtPage_" + _local1)].textColor = 16496146;
                        exchangeView.content[("mcPage_" + _local1)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                    } else {
                        exchangeView.content[("mcPage_" + _local1)].gotoAndStop(2);
                        exchangeView.content[("txtPage_" + _local1)].textColor = 250597;
                    };
                    _local1++;
                };
                if (NPCExchangeConstData.goodList[mosterId][1][0].SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_CLOTH){
                    exchangeView.content[("txtPage_" + 0)].text = LanguageMgr.GetTranslation("武器");
                    exchangeView.content[("txtPage_" + 1)].text = LanguageMgr.GetTranslation("衣服");
                    exchangeView.content[("txtPage_" + 2)].text = LanguageMgr.GetTranslation("帽子");
                    exchangeView.content[("txtPage_" + 3)].text = LanguageMgr.GetTranslation("鞋子");
                    exchangeView.content[("mcPage_" + 4)].visible = false;
                    exchangeView.content[("txtPage_" + 4)].visible = false;
                } else {
                    if (((((NPCExchangeConstData.goodList[mosterId][0][0]) && ((NPCExchangeConstData.goodList[mosterId][0][0].MainClass == ItemConst.ITEM_CLASS_EQUIP)))) && ((NPCExchangeConstData.goodList[mosterId][0][0].SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_NECKLACE)))){
                        exchangeView.content[("txtPage_" + 0)].text = LanguageMgr.GetTranslation("项链");
                        exchangeView.content[("txtPage_" + 1)].text = LanguageMgr.GetTranslation("戒指");
                        exchangeView.content[("txtPage_" + 2)].text = LanguageMgr.GetTranslation("圣契");
                        exchangeView.content[("txtPage_" + 3)].text = LanguageMgr.GetTranslation("徽记");
                        exchangeView.content[("txtPage_" + 4)].text = LanguageMgr.GetTranslation("徽章");
                    } else {
                        if ((((NPCExchangeConstData.goodList[mosterId][0][0].SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_AUXILIARY)) || ((NPCExchangeConstData.goodList[mosterId][1][0].SubClass == ItemConst.ITEM_SUBCLASS_EQUIP_SECRETBOOK)))){
                            exchangeView.content[("txtPage_" + 0)].text = LanguageMgr.GetTranslation("徽记");
                            exchangeView.content[("txtPage_" + 1)].text = LanguageMgr.GetTranslation("徽章");
                            exchangeView.content[("mcPage_" + 2)].visible = false;
                            exchangeView.content[("txtPage_" + 2)].visible = false;
                            exchangeView.content[("mcPage_" + 3)].visible = false;
                            exchangeView.content[("txtPage_" + 3)].visible = false;
                            exchangeView.content[("mcPage_" + 4)].visible = false;
                            exchangeView.content[("txtPage_" + 4)].visible = false;
                        };
                    };
                };
            } else {
                if (NPCExchangeConstData.goodList[mosterId][1][0] == null){
                    _local1 = 0;
                    while (_local1 < 5) {
                        exchangeView.content[("mcPage_" + _local1)].buttonMode = false;
                        exchangeView.content[("mcPage_" + _local1)].visible = false;
                        exchangeView.content[("txtPage_" + _local1)].visible = false;
                        _local1++;
                    };
                    exchangeView.content[("mcPage_" + 0)].visible = true;
                    exchangeView.content[("txtPage_" + 0)].visible = true;
                    exchangeView.content[("txtPage_" + 0)].text = LanguageMgr.GetTranslation("物品");
                    exchangeView.content[("txtPage_" + 0)].mouseEnabled = false;
                };
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWNPCEXCHANGEVIEW, EventList.UPDATENPCEXCHANGEVIEW, EventList.RESIZE_STAGE, EventList.CLOSENPCEXCHANGEVIEW, EventList.CLOSE_NPC_ALL_PANEL, EventList.UPDATE_ACTIVITY, NPCExchangeEvent.NPC_EXCHANGE_SUCESS]);
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            if (_arg1.target.parent.name == "btnExchange"){
                exchangeGood();
                return;
            };
            switch (_arg1.target.name){
                case "btnAdd":
                    if (NPCExchangeConstData.selectedIndex == -1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择物品"),
                            color:0xFFFF00
                        });
                        exchangeView.content.txtInputCount.text = "1";
                        return;
                    };
                    if (int(exchangeView.content.txtInputCount.text) < maxCount){
                        exchangeView.content.txtInputCount.text = String((uint(exchangeView.content.txtInputCount.text) + 1));
                    } else {
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("不能超过最大堆叠数量"),
                            color:0xFFFF00
                        });
                    };
                    refreshExchangeItem();
                    break;
                case "btnSub":
                    if (NPCExchangeConstData.selectedIndex == -1){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("请先选择物品"),
                            color:0xFFFF00
                        });
                        exchangeView.content.txtInputCount.text = "1";
                        return;
                    };
                    if (int(exchangeView.content.txtInputCount.text) > 1){
                        exchangeView.content.txtInputCount.text = String((int(exchangeView.content.txtInputCount.text) - 1));
                    };
                    refreshExchangeItem();
                    break;
            };
        }
        private function mouseOutHandler(_arg1:MouseEvent):void{
            _arg1.currentTarget.mcRed.visible = false;
        }
        private function gcAll():void{
            removLis();
            if (GameCommonData.GameInstance.GameUI.contains(exchangeView)){
                GameCommonData.GameInstance.GameUI.removeChild(exchangeView);
            };
            NPCExchangeConstData.SelectedItem = null;
            if (gridManager){
            };
            viewComponent = null;
            npcId = 0;
            shopName = "";
            NPCExchangeConstData.currType = 0;
            NPCExchangeConstData.GridUnitList = [];
            NPCExchangeConstData.selectedIndex = -1;
            NPCExchangeConstData.TmpIndex = 0;
            gridManager = null;
            dataProxy.NPCExchangeIsOpen = false;
            dataProxy = null;
            facade.removeMediator(NPCExchangeMediator.NAME);
            facade.sendNotification(Guide_EquipExchangeCommand.NAME, {step:4});
        }
        private function cancelClose():void{
        }
        private function panelCloseHandler():void{
            gcAll();
        }
        private function judge():Boolean{
            var _local1:Boolean;
            if (GameCommonData.Player.Role.ActionState == GameElementSkins.ACTION_DEAD){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("死亡状态不能打开兑换店"),
                    color:0xFFFF00
                });
                _local1 = false;
            } else {
                if (dataProxy.TradeIsOpen){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("交易中不能打开兑换店"),
                        color:0xFFFF00
                    });
                    _local1 = false;
                } else {
                    if (GameCommonData.Player.Role.isStalling > 0){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("摆摊中不能打开兑换店"),
                            color:0xFFFF00
                        });
                        _local1 = false;
                    } else {
                        if (dataProxy.DepotIsOpen){
                            sendNotification(EventList.CLOSEDEPOTVIEW);
                        };
                    };
                };
            };
            return (_local1);
        }
        private function goodSelectHandler(_arg1:MouseEvent):void{
            var _local2:Object;
            var _local3:String;
            var _local4:uint;
            var _local5:int;
            if (_arg1){
                _local5 = _arg1.currentTarget.name.split("_")[1];
            } else {
                _local5 = NPCExchangeConstData.selectedIndex;
            };
            if ((((_arg1 == null)) || (!((_local5 == NPCExchangeConstData.selectedIndex))))){
                _local2 = NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][_local5];
                if (_local2){
                    NPCExchangeConstData.selectedIndex = _local5;
                    maxCount = uint((_local2.MaxCount / _local2.SCount));
                    if (mosterId == NPCExchangeConstData.towerMosterID){
                        if (maxCount > _local2.curr_amount){
                            maxCount = _local2.curr_amount;
                        };
                    };
                    exchangeView.content.txtInputCount.text = "1";
                    srcGoodList = [uint(NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][_local5].exchangeGood1), uint(NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][_local5].exchangeGood2)];
                    srcGoodNumList = [uint(NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][_local5].exchangeNum1), uint(NPCExchangeConstData.goodList[mosterId][NPCExchangeConstData.currType][_local5].exchangeNum2)];
                    refreshExchangeItem();
                };
            };
            if (_arg1 == null){
                gridManager.onMouseDown(null);
            };
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local2:int;
            while (_local2 < 5) {
                exchangeView.content[("mcPage_" + _local2)].gotoAndStop(2);
                exchangeView.content[("txtPage_" + _local2)].textColor = 250597;
                exchangeView.content[("mcPage_" + _local2)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                _local2++;
            };
            var _local3:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            exchangeView.content[("mcPage_" + _local3)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
            exchangeView.content[("mcPage_" + _local3)].gotoAndStop(1);
            exchangeView.content[("txtPage_" + _local3)].textColor = 16496146;
            NPCExchangeConstData.currType = _local3;
            removeAllFrames();
            clearData();
            updateData();
        }
        private function addLis():void{
            var _local1:int;
            exchangeView.content.btnAdd.addEventListener(MouseEvent.CLICK, btnClickHandler);
            exchangeView.content.btnSub.addEventListener(MouseEvent.CLICK, btnClickHandler);
            exchangeView.btnExchange.addEventListener(MouseEvent.CLICK, btnClickHandler);
            exchangeView.content.txtInputCount.addEventListener(Event.CHANGE, inputHandler);
            UIUtils.addFocusLis(exchangeView.content.txtInputCount);
        }
        private function initGrid():void{
            var _local1:MovieClip;
            var _local2:GridUnit;
            var _local3:int;
            while (_local3 < 24) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local1.x = ((_local1.width * (_local3 % 6)) + 17);
                _local1.y = ((_local1.height * int((_local3 / 6))) + 84);
                _local1.name = ("NPCExchange_" + _local3.toString());
                exchangeView.addChild(_local1);
                _local2 = new GridUnit(_local1, true);
                _local2.parent = (exchangeView as MovieClip);
                _local2.Index = _local3;
                _local2.HasBag = true;
                _local2.IsUsed = false;
                _local2.Item = null;
                NPCExchangeConstData.GridUnitList.push(_local2);
                _local3++;
            };
            _local3 = 0;
            while (_local3 < 2) {
                exchangeFaceItem[_local3] = null;
                exchangeView.content[("txt_ExchangeName" + _local3)].text = "";
                exchangeView.content[("txt_ExchangeCount" + _local3)].text = "";
                _local3++;
            };
            gridManager = new NPCExchangeGridManager(NPCExchangeConstData.GridUnitList, (exchangeView as MovieClip));
            facade.registerProxy(gridManager);
            gridManager.Initialize();
        }
        private function get exchangeView():NPCExchangeUIView{
            return ((viewComponent as NPCExchangeUIView));
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:GridUnit;
            switch (_arg1.getName()){
                case EventList.UPDATENPCEXCHANGEVIEW:
                    updateData();
                    refreshExchangeItem();
                    break;
                case EventList.SHOWNPCEXCHANGEVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    if (dataProxy.NPCExchangeIsOpen){
                        setPos();
                        sendNotification(EventList.SHOWBAG);
                        facade.sendNotification(Guide_EquipExchangeCommand.NAME, {step:3});
                        return;
                    };
                    if (!judge()){
                        gcAll();
                        return;
                    };
                    npcId = _arg1.getBody().npcId;
                    mosterId = GameCommonData.SameSecnePlayerList[npcId].Role.MonsterTypeID;
                    NPCExchangeConstData.currMosterID = mosterId;
                    shopName = _arg1.getBody().shopName;
                    initView();
                    updateData();
                    addLis();
                    dataProxy.NPCExchangeIsOpen = true;
                    sendNotification(EventList.SHOWBAG);
                    setPos();
                    if ((((NewGuideData.curType == 20)) && ((NewGuideData.curStep == 1)))){
                        _local3 = NPCExchangeConstData.getGridById(NewGuideData.ITEMTEMPID_SSSP);
                        if (((_local3) && (_local3.Grid))){
                            NPCExchangeConstData.selectedIndex = _local3.Index;
                            goodSelectHandler(null);
                            facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_EXCHANGE, {
                                step:2,
                                data:{
                                    target:exchangeView.btnExchange,
                                    itemGridUnit:_local3.Grid
                                }
                            });
                        };
                    };
                    facade.sendNotification(Guide_EquipExchangeCommand.NAME, {step:3});
                    break;
                case EventList.CLOSENPCEXCHANGEVIEW:
                    gcAll();
                    break;
                case EventList.CLOSE_NPC_ALL_PANEL:
                    if (((dataProxy) && (dataProxy.NPCExchangeIsOpen))){
                        gcAll();
                    };
                    break;
                case NPCExchangeEvent.NPC_EXCHANGE_SUCESS:
                    if (!dataProxy.NPCExchangeIsOpen){
                        return;
                    };
                    refreshExchangeItem();
                    break;
                case EventList.RESIZE_STAGE:
                    setPos();
                    break;
                case EventList.UPDATE_ACTIVITY:
                    if (dataProxy.NPCExchangeIsOpen){
                        facade.sendNotification(EventList.UPDATENPCEXCHANGEVIEW, {
                            npcId:npcId,
                            shopName:shopName
                        });
                    };
                    break;
            };
        }
        private function removLis():void{
            var _local1:int;
            if (exchangeView){
                _local1 = 0;
                while (_local1 < 24) {
                    exchangeView.getChildByName(("NPCExchange_" + _local1)).removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
                    exchangeView.getChildByName(("NPCExchange_" + _local1)).removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
                    _local1++;
                };
                exchangeView.btnExchange.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                exchangeView.content.btnAdd.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                exchangeView.content.btnSub.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                exchangeView.content.txtInputCount.removeEventListener(Event.CHANGE, inputHandler);
                UIUtils.removeFocusLis(exchangeView.content.txtInputCount);
            };
        }

    }
}//package GameUI.Modules.NPCExchange.Mediator 
