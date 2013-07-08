//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.Maket.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.*;

    public class PetBatchRebuildMediator extends Mediator {

        public static const NAME:String = "PetBatchRebuildMediator";

        private var hAlertFrame:HFrame;
        private var optimal:uint;
        private var hframe:HFrame;
        private var faceItem:FaceItem;
        private var dealItemDelayTime:Number = 0;
        private var saveBtn:HLabelButton;
        private var alertView:MovieClip;
        private var view:MovieClip;
        private var templateId:uint;
        private var batchBtn:HLabelButton;
        private var currSelect:int;
        private var autoBuy:Boolean = false;
        private var itemInfo:InventoryItemInfo;
        private var dataProxy:DataProxy;

        public function PetBatchRebuildMediator(){
            super(NAME);
        }
        private function onAlertCancel(_arg1:MouseEvent):void{
            closeAlert();
        }
        private function Cancel():void{
        }
        private function onBatch(_arg1:MouseEvent):void{
            var _local2:uint = getTimer();
            if ((_local2 - this.dealItemDelayTime) < 500){
                MessageTip.show(LanguageMgr.GetTranslation("请稍候"));
                return;
            };
            this.dealItemDelayTime = _local2;
            if (optimal >= 4){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:alertBatch,
                    cancel:Cancel,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("已洗炼出极品宠物询问是否洗炼")
                });
                return;
            };
            alertBatch();
        }
        private function noSelect():void{
            var _local1:uint;
            var _local2:uint;
            _local1 = 0;
            while (_local1 < 10) {
                view[("item_" + _local1)].mcRadio.gotoAndStop(2);
                _local2 = 0;
                while (_local2 < 7) {
                    view[("item_" + _local1)][("Value_" + _local2)].mouseEnabled = false;
                    view[("item_" + _local1)][("Value_" + _local2)].textColor = 0xFFFFFF;
                    _local2++;
                };
                view[("item_" + _local1)].bg.visible = false;
                view[("item_" + _local1)].buttonMode = true;
                _local1++;
            };
        }
        private function refreshItems():void{
            var _local3:uint;
            var _local4:uint;
            currSelect = -1;
            optimal = 0;
            noSelect();
            var _local1:uint;
            var _local2:uint;
            _local1 = 0;
            while (_local1 < 10) {
                _local2 = 0;
                while (_local2 < 5) {
                    if (_local2 == 0){
                        _local3 = EquipDataConst.petBatchRebuilds[_local1][_local2];
                        if (_local3 > 0){
                            view[("item_" + _local1)][("Value_" + 0)].text = GamePetRole.PET_TYPE_DIC[uint((_local3 / 10000))];
                            view[("item_" + _local1)][("Value_" + 1)].text = GamePetRole.PET_TYPE_DIC[uint((_local3 % 10000))];
                            view[("item_" + _local1)][("Value_" + 2)].text = (GameCommonData.SkillList[(600001 + uint((_local3 / 100)))] as SkillInfo).Name;
                            view[("item_" + _local1)].visible = true;
                            saveBtn.visible = true;
                            batchBtn.x = uint(((view.width / 2) - 10));
                        } else {
                            view[("item_" + _local1)][("Value_" + 0)].text = "";
                            view[("item_" + _local1)][("Value_" + 1)].text = "";
                            view[("item_" + _local1)][("Value_" + 2)].text = "";
                            view[("item_" + _local1)].visible = false;
                        };
                    } else {
                        _local3 = EquipDataConst.petBatchRebuilds[_local1][_local2];
                        if (_local3 > 600000){
                            view[("item_" + _local1)][("Value_" + String((_local2 + 2)))].text = (GameCommonData.SkillList[_local3] as SkillInfo).Name;
                        } else {
                            view[("item_" + _local1)][("Value_" + String((_local2 + 2)))].text = "";
                        };
                        if (view[("item_" + _local1)][("Value_" + 1)].text == LanguageMgr.GetTranslation("攻击")){
                            view[("item_" + _local1)][("Value_" + 1)].textColor = 5955899;
                        };
                        if (view[("item_" + _local1)][("Value_" + 0)].text == LanguageMgr.GetTranslation("攻击")){
                            if (_local2 == 1){
                                view[("item_" + _local1)][("Value_" + 0)].textColor = 231930;
                            };
                            _local4 = 0;
                            if (EquipDataConst.petBatchRebuilds[_local1][4] > 0){
                                _local4 = 5;
                                if (_local4 > optimal){
                                    optimal = 5;
                                    selectOptimal(_local1, 16478724);
                                };
                            } else {
                                if (EquipDataConst.petBatchRebuilds[_local1][3] > 0){
                                    _local4 = 4;
                                    if (_local4 > optimal){
                                        optimal = 4;
                                        selectOptimal(_local1, 14498500);
                                    };
                                };
                            };
                        };
                        if (optimal < 4){
                            if (EquipDataConst.petBatchRebuilds[_local1][4] > 0){
                                view[("item_" + _local1)][("Value_" + String((_local2 + 2)))].textColor = 14498500;
                                view[("item_" + _local1)][("Value_" + 2)].textColor = 14498500;
                            } else {
                                if (EquipDataConst.petBatchRebuilds[_local1][3] > 0){
                                    view[("item_" + _local1)][("Value_" + String((_local2 + 2)))].textColor = 231930;
                                    view[("item_" + _local1)][("Value_" + 2)].textColor = 231930;
                                } else {
                                    if (EquipDataConst.petBatchRebuilds[_local1][2] > 0){
                                        view[("item_" + _local1)][("Value_" + String((_local2 + 2)))].textColor = 5955899;
                                        view[("item_" + _local1)][("Value_" + 2)].textColor = 5955899;
                                    } else {
                                        view[("item_" + _local1)][("Value_" + String((_local2 + 2)))].textColor = 0xFFFFFF;
                                        view[("item_" + _local1)][("Value_" + 2)].textColor = 0xFFFFFF;
                                    };
                                };
                            };
                        };
                    };
                    view[("item_" + _local1)][("Value_" + _local2)].mouseEnabled = false;
                    _local2++;
                };
                _local1++;
            };
        }
        protected function closeHandler():void{
            var func:* = function ():void{
                var _local1:uint;
                var _local2:uint;
                _local1 = 0;
                while (_local1 < 10) {
                    _local2 = 0;
                    while (_local2 < 5) {
                        EquipDataConst.petBatchRebuilds[_local1][_local2] = 0;
                        _local2++;
                    };
                    _local1++;
                };
                removeLis();
                if (GameCommonData.GameInstance.GameUI.contains(hframe)){
                    GameCommonData.GameInstance.GameUI.removeChild(hframe);
                };
                (facade.retrieveProxy(DataProxy.NAME) as DataProxy).petBatchIsOpen = false;
            };
            if (EquipDataConst.petBatchRebuilds[0][0] > 0){
                UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                    comfrim:func,
                    cancel:Cancel,
                    isShowClose:false,
                    info:LanguageMgr.GetTranslation("退出批量洗炼将不保存")
                });
                return;
            };
            func();
        }
        private function addLis():void{
        }
        private function onAlertRadio(_arg1:MouseEvent):void{
            if (alertView.mcRadio.currentFrame == 1){
                alertView.mcRadio.gotoAndStop(2);
            } else {
                alertView.mcRadio.gotoAndStop(1);
            };
        }
        private function closeAlert():void{
            if (GameCommonData.GameInstance.GameUI.contains(hAlertFrame)){
                GameCommonData.GameInstance.GameUI.removeChild(hAlertFrame);
            };
        }
        private function alertBatch(_arg1:Boolean=true):void{
            var _local3:ShopItemInfo;
            var _local4:uint;
            var _local5:uint;
            if (((_arg1) && (!((SharedManager.getInstance().petBatchRebuildAlert == TimeManager.Instance.Now().day))))){
                hAlertFrame.x = int(((GameCommonData.GameInstance.ScreenWidth - hAlertFrame.frameWidth) / 2));
                hAlertFrame.y = int(((GameCommonData.GameInstance.ScreenHeight - hAlertFrame.frameHeight) / 2));
                hAlertFrame.show();
                return;
            };
            var _local2:uint = BagData.getCountsByTemplateId(70200001, false);
            if (_local2 < 10){
                if (!autoBuy){
                    MessageTip.popup(LanguageMgr.GetTranslation("宠物秘纹数量不足"));
                } else {
                    _local3 = MarketConstData.getShopItemByTemplateID(70200001, true);
                    _local4 = _local3.ShopId;
                    _local5 = (10 - _local2);
                    if (GameCommonData.Player.Role.Money >= (_local5 * _local3.APriceArr[2])){
                        MarketSend.buyItemForMarket(_local4, _local5);
                    } else {
                        UIFacade.GetInstance().LackofGoldLeaf();
                    };
                };
                return;
            };
            requestBatch();
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            var _local3:HLabelButton;
            var _local4:HLabelButton;
            var _local5:uint;
            var _local6:uint;
            var _local7:InventoryItemInfo;
            var _local8:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    this.dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EquipCommandList.SHOW_PET_BATCHREBUILD_UI:
                    if (hframe == null){
                        view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BatchPetRebuild");
                        hframe = new HFrame();
                        hframe.titleText = LanguageMgr.GetTranslation("批量洗炼");
                        hframe.centerTitle = true;
                        hframe.setSize(482, 374);
                        hframe.addChild(view);
                        view.x = 4;
                        view.y = 30;
                        hframe.blackGound = true;
                        hframe.closeCallBack = closeHandler;
                        saveBtn = new HLabelButton();
                        saveBtn.y = 307;
                        saveBtn.label = LanguageMgr.GetTranslation("保存结果");
                        saveBtn.x = uint((((view.width / 2) - 20) - saveBtn.width));
                        saveBtn.visible = false;
                        batchBtn = new HLabelButton();
                        batchBtn.label = LanguageMgr.GetTranslation("批量洗炼");
                        batchBtn.x = uint((((view.width / 2) - (batchBtn.width / 2)) - 5));
                        batchBtn.y = 307;
                        batchBtn.name = "PetBatchRebuild";
                        view.addChild(saveBtn);
                        view.addChild(batchBtn);
                        saveBtn.addEventListener(MouseEvent.CLICK, onSave);
                        batchBtn.addEventListener(MouseEvent.CLICK, onBatch);
                        view.mcRadio.addEventListener(MouseEvent.CLICK, onAutoBuy);
                        view.txtRadio.selectable = false;
                        view.txtRadio.addEventListener(MouseEvent.CLICK, onAutoBuy);
                        view.mcRadio.gotoAndStop(1);
                        _local2 = 0;
                        _local2 = 0;
                        while (_local2 < 10) {
                            EquipDataConst.petBatchRebuilds[_local2] = new Array();
                            _local2++;
                        };
                        hAlertFrame = new HFrame();
                        alertView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BatchRebuildAlert");
                        hAlertFrame.addChild(alertView);
                        alertView.x = 4;
                        alertView.y = 30;
                        hAlertFrame.blackGound = true;
                        hAlertFrame.closeCallBack = closeAlert;
                        hAlertFrame.titleText = LanguageMgr.GetTranslation("提示");
                        hAlertFrame.centerTitle = true;
                        hAlertFrame.setSize(228, 136);
                        _local3 = new HLabelButton();
                        _local3.label = LanguageMgr.GetTranslation("确定");
                        _local3.x = uint((((alertView.width / 2) - 10) - _local3.width));
                        _local3.y = 105;
                        _local4 = new HLabelButton();
                        _local4.x = uint(((alertView.width / 2) + 10));
                        _local4.y = 105;
                        _local4.label = LanguageMgr.GetTranslation("取消");
                        hAlertFrame.addChild(_local3);
                        hAlertFrame.addChild(_local4);
                        _local3.addEventListener(MouseEvent.CLICK, onAlertBatch);
                        _local4.addEventListener(MouseEvent.CLICK, onAlertCancel);
                        alertView.txtBatchRebuild.gotoAndStop(1);
                        alertView.mcRadio.gotoAndStop(1);
                        alertView.mcRadio.addEventListener(MouseEvent.CLICK, onAlertRadio);
                        alertView.txtRadio.selectable = false;
                        alertView.txtRadio.addEventListener(MouseEvent.CLICK, onAlertRadio);
                    };
                    if (GameCommonData.GameInstance.GameUI.contains(hframe)){
                        GameCommonData.GameInstance.GameUI.removeChild(hframe);
                        return;
                    };
                    hframe.x = int(((GameCommonData.GameInstance.ScreenWidth - hframe.frameWidth) / 2));
                    hframe.y = int(((GameCommonData.GameInstance.ScreenHeight - hframe.frameHeight) / 2));
                    (facade.retrieveProxy(DataProxy.NAME) as DataProxy).petBatchIsOpen = true;
                    itemInfo = (_arg1.getBody() as InventoryItemInfo);
                    initView();
                    GameCommonData.GameInstance.GameUI.addChild(hframe);
                    refreshItems();
                    break;
                case EquipCommandList.REFRESH_PET_BATCH:
                    if (((hframe) && (GameCommonData.GameInstance.GameUI.contains(hframe)))){
                        refreshItems();
                    };
                    break;
                case EquipCommandList.SAVE_PET_BATCH:
                    if (((hframe) && (GameCommonData.GameInstance.GameUI.contains(hframe)))){
                        if (uint(_arg1.getBody()) == 1){
                            _local5 = 0;
                            _local6 = 0;
                            _local5 = 0;
                            while (_local5 < 10) {
                                _local6 = 0;
                                while (_local6 < 5) {
                                    EquipDataConst.petBatchRebuilds[_local5][_local6] = 0;
                                    _local6++;
                                };
                                _local5++;
                            };
                            refreshProperty();
                            refreshItems();
                        };
                        saveBtn.visible = false;
                        batchBtn.x = uint((((view.width / 2) - (batchBtn.width / 2)) - 5));
                    };
                    break;
                case EquipCommandList.UPDATE_QUICKBUY_ITEM:
                    if (((hframe) && (GameCommonData.GameInstance.GameUI.contains(hframe)))){
                        _local7 = BagData.getItemByType(uint(_arg1.getBody()));
                        if (_local7 == null){
                            return;
                        };
                        _local8 = _local7.Place;
                        if (uint(_arg1.getBody()) == 70200001){
                            alertBatch(false);
                        };
                    };
                    break;
            };
        }
        private function clickOne(_arg1:MouseEvent):void{
            var _local2:uint = _arg1.currentTarget.name.split("_")[1];
            var _local3:uint;
            var _local4:uint;
            _local3 = 0;
            while (_local3 < 10) {
                view[("item_" + _local3)].bg.visible = false;
                view[("item_" + _local3)].mcRadio.gotoAndStop(2);
                _local3++;
            };
            view[("item_" + _local2)].mcRadio.gotoAndStop(1);
            view[("item_" + _local2)].bg.visible = true;
            currSelect = _local2;
        }
        private function refreshProperty():void{
            var _local2:uint;
            var _local1:uint;
            _local1 = 0;
            while (_local1 < 7) {
                if (_local1 == 0){
                    view[("Value_" + _local1)].text = itemInfo.PetInfo.MainType;
                } else {
                    if (_local1 == 1){
                        view[("Value_" + _local1)].text = itemInfo.PetInfo.SubType;
                    } else {
                        if (_local1 == 2){
                            _local2 = itemInfo.PetInfo.SpecialSkill;
                        } else {
                            _local2 = itemInfo.PetInfo.CommonSkills[(_local1 - 3)];
                        };
                        if (_local2 > 600000){
                            view[("Value_" + _local1)].text = (GameCommonData.SkillList[_local2] as SkillInfo).Name;
                        } else {
                            view[("Value_" + _local1)].text = "";
                        };
                    };
                };
                view[("Value_" + _local1)].mouseEnabled = false;
                _local1++;
            };
        }
        private function initView():void{
            if (((faceItem) && (faceItem.parent))){
                faceItem.parent.removeChild(faceItem);
            };
            faceItem = new FaceItem(String(itemInfo.img));
            faceItem.x = (view.EquipFrame.x + 1);
            faceItem.y = (view.EquipFrame.y + 1);
            faceItem.setEnable(true);
            view.addChild(faceItem);
            faceItem.name = ("PetBatchRebuildT_" + itemInfo.ItemGUID);
            refreshProperty();
            var _local1:uint;
            _local1 = 0;
            while (_local1 < 10) {
                view[("item_" + _local1)].visible = false;
                view[("item_" + _local1)].mcRadio.gotoAndStop(1);
                view[("item_" + _local1)].addEventListener(MouseEvent.CLICK, clickOne);
                _local1++;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EquipCommandList.REFRESH_PET_BATCH, EquipCommandList.SAVE_PET_BATCH, EquipCommandList.UPDATE_QUICKBUY_ITEM, EquipCommandList.SHOW_PET_BATCHREBUILD_UI]);
        }
        private function selectOptimal(_arg1:uint, _arg2:uint):void{
            currSelect = _arg1;
            var _local3:uint;
            var _local4:uint;
            _local3 = 0;
            while (_local3 < 10) {
                view[("item_" + _local3)].mcRadio.gotoAndStop(2);
                _local4 = 0;
                while (_local4 < 7) {
                    _local4++;
                };
                view[("item_" + _local3)].bg.visible = false;
                _local3++;
            };
            view[("item_" + _arg1)].mcRadio.gotoAndStop(1);
            _local4 = 0;
            while (_local4 < 7) {
                view[("item_" + _arg1)][("Value_" + _local4)].textColor = _arg2;
                _local4++;
            };
            view[("item_" + _arg1)].bg.visible = true;
        }
        private function requestBatch():void{
            EquipSend.BatchRebuild(1, itemInfo.ItemGUID, 0);
        }
        private function removeLis():void{
        }
        private function onAutoBuy(_arg1:MouseEvent):void{
            if (view.mcRadio.currentFrame == 1){
                view.mcRadio.gotoAndStop(2);
                autoBuy = true;
            } else {
                view.mcRadio.gotoAndStop(1);
                autoBuy = false;
            };
        }
        private function onSave(_arg1:MouseEvent):void{
            if (currSelect == -1){
                MessageTip.popup(LanguageMgr.GetTranslation("请先选择要保存的结果"));
                return;
            };
            EquipSend.BatchRebuild(0, itemInfo.ItemGUID, currSelect);
        }
        private function onAlertBatch(_arg1:MouseEvent):void{
            if (((!((SharedManager.getInstance().petBatchRebuildAlert == TimeManager.Instance.Now().day))) && ((alertView.mcRadio.currentFrame == 2)))){
                SharedManager.getInstance().petBatchRebuildAlert = TimeManager.Instance.Now().day;
            };
            alertBatch(false);
            closeAlert();
        }

    }
}//package GameUI.Modules.Pet.Mediator 
