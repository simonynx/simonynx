//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.Modules.ScreenMessage.View.*;
    import GameUI.Modules.Trade.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Friend.view.mediator.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.PlayerInfo.Mediator.*;
    import GameUI.Modules.ToolTip.Const.*;
    import GameUI.Modules.Stall.Data.*;
    import GameUI.Modules.Depot.Data.*;
    import GameUI.Modules.NPCShop.Data.*;
    import GameUI.*;

    public class UseItemCommand extends SimpleCommand {

        public static const NAME:String = "UseItemCommand";

        private function processSaleToNPC(_arg1:DataProxy, _arg2:UseItem):void{
            if ((BagData.SelectedItem.Item.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("forbidsale1"),
                    color:0xFFFF00
                });
                return;
            };
            var _local3:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            if (BagData.petCanDeal(_local3) == false){
                MessageTip.popup(LanguageMgr.GetTranslation("forbidsale2"));
                return;
            };
            BagData.SelectedItem.Item.IsLock = true;
            BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
            facade.sendNotification(NPCShopEvent.BAGTONPCSHOP, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]);
        }
        private function processStall(_arg1:DataProxy, _arg2:UseItem):void{
            if (GameCommonData.Player.Role.isStalling > 0){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("stalllimit1"),
                    color:0xFFFF00
                });
                return;
            };
            if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].isBind == 1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("stalllimit2"),
                    color:0xFFFF00
                });
                return;
            };
            if ((BagData.SelectedItem.Item.itemIemplateInfo.Flags & ItemConst.FlAGS_TRADE)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("stalllimit3"),
                    color:0xFFFF00
                });
                return;
            };
            var _local3:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            if (BagData.petCanDeal(_local3) == false){
                MessageTip.popup(LanguageMgr.GetTranslation("stalllimit4"));
                return;
            };
            BagData.SelectedItem.Item.IsLock = true;
            BagData.AllLocks[BagData.SelectIndex][BagData.SelectedItem.Index] = true;
            facade.sendNotification(EventList.BAGTOSTALL, {
                ItemGUID:BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].ItemGUID,
                srcPlace:ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.TmpIndex)
            });
        }
        private function processDepot(_arg1:DataProxy, _arg2:UseItem):void{
            var _local3:int = DepotConstData.findEmptyPos();
            if (_local3 == -1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("depotfull"),
                    color:0xFFFF00
                });
                return;
            };
            var _local4:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            if (BagData.petCanDeal(_local4) == false){
                MessageTip.popup(LanguageMgr.GetTranslation("forbidtodepot"));
                return;
            };
            BagData.SelectedItem.Item.IsLock = true;
            BagInfoSend.ItemSwap(ItemConst.gridUnitToPlace(BagData.SelectIndex, BagData.SelectedItem.Index), (ItemConst.BANK_SLOT_START + _local3));
        }
        private function processEntrust(_arg1:DataProxy, _arg2:UseItem):void{
            if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].isBind == 1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("forbidtrade2"),
                    color:0xFFFF00
                });
                return;
            };
            if ((BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].Flags & ItemConst.FlAGS_TRADE)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("forbidtrade1"),
                    color:0xFFFF00
                });
                return;
            };
            var _local3:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            if (BagData.petCanDeal(_local3) == false){
                MessageTip.popup(LanguageMgr.GetTranslation("forbidtrade3"));
                return;
            };
            BagData.SelectedItem.Item.IsLock = true;
            BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
            facade.sendNotification(EventList.BAGTOENTRUST, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]);
        }
        private function isEnableUseTheItem(_arg1:UseItem):Boolean{
            var _local2:ItemTemplateInfo = UIConstData.ItemDic[_arg1.Type];
            if (((!((_local2.Job == 0))) && (!((GameCommonData.Player.Role.CurrentJobID == _local2.Job))))){
                MessageTip.popup(LanguageMgr.GetTranslation(LanguageMgr.GetTranslation("本职业不能使用提示句")));
                return (false);
            };
            return (true);
        }
        override public function execute(_arg1:INotification):void{
            var _local6:InventoryItemInfo;
            var _local7:BigMessageItem;
            if (GameCommonData.Player.Role.HP == 0){
                return;
            };
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            if (BagData.SelectedItem == null){
                return;
            };
            var _local3:UseItem = (BagData.SelectedItem.Item as UseItem);
            if (_local3 == null){
                return;
            };
            var _local4:Boolean;
            if (_local2.NPCShopIsOpen){
                processSaleToNPC(_local2, _local3);
                return;
            };
            if (_local2.DepotIsOpen){
                processDepot(_local2, _local3);
                return;
            };
            if (_local2.TradeIsOpen){
                processTrade(_local2, _local3);
                return;
            };
            if (((((_local2.StallIsOpen) && ((GameCommonData.Player.Role.isStalling == 0)))) && ((StallConstData.stallIdToQuery == 0)))){
                processStall(_local2, _local3);
                return;
            };
            if (_local2.EntrustPopIsOpen){
                processEntrust(_local2, _local3);
                return;
            };
            if (((_local2.IsCollecting) || (_local2.IsGrabPeting))){
                _local6 = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
                if (((BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]) && (ItemConst.IsMount(BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index])))){
                    MessageTip.popup(LanguageMgr.GetTranslation("mountlimit2"));
                    return;
                };
            };
            if (BagData.SelectedItem == null){
                return;
            };
            if (BagData.SelectedItem.Item == null){
                return;
            };
            if (BagData.SelectedItem.Item.itemIemplateInfo.RequiredLevel > GameCommonData.Player.Role.Level){
                MessageTip.popup(LanguageMgr.GetTranslation("levellimit"));
                return;
            };
            if (ItemConst.IsUsable(BagData.SelectedItem.Item.itemIemplateInfo)){
                if (this.isEnableUseTheItem((BagData.SelectedItem.Item as UseItem)) == false){
                    return;
                };
            };
            if (ItemConst.IsEquip(BagData.SelectedItem.Item.itemIemplateInfo)){
                if (UIConstData.useItemTimer.running){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("wait"),
                        color:0xFFFF00
                    });
                } else {
                    UIConstData.useItemTimer.reset();
                    UIConstData.useItemTimer.start();
                    if (this.isEnableUseTheItem((BagData.SelectedItem.Item as UseItem))){
                        SetFrame.RemoveFrame(BagData.SelectedItem.Item.ItemParent);
                        BagData.SelectedItem.Item.IsLock = true;
                        BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                        facade.sendNotification(RoleEvents.GETOUTFITBYCLICK, BagData.SelectedItem.Item);
                    };
                };
                return;
            };
            if (GameCommonData.Player.Role.canUseItem != true){
                MessageTip.popup(LanguageMgr.GetTranslation("itemuselimit"));
                return;
            };
            if (_local2.IsUseTaskItem){
                facade.sendNotification(BagEvents.CANCEL_TASKITEM_USE);
            };
            var _local5:ItemTemplateInfo = BagData.SelectedItem.Item.itemIemplateInfo;
            facade.sendNotification(NewGuideEvent.POINTBAGITEM_CLOSE, _local5.TemplateID);
            if (GameCommonData.Player.Role.IsAttack){
                if ((((_local5.TemplateID >= 10400001)) && ((_local5.TemplateID <= 10400100)))){
                    _local7 = new BigMessageItem(LanguageMgr.GetTranslation("mountlimit1"));
                    _local7.Jump();
                    return;
                };
            };
            if (_local5.TemplateID == 50700002){
                facade.sendNotification(EventList.SHOW_ACTIVITY_WELFARE, 1);
            };
            if (ItemConst.IsMedical(_local5)){
                if (ItemConst.IsMedicalExceptBAG(_local5)){
                    sendNotification(EventList.RECEIVE_CD_MEDICINAL);
                };
                BagInfoSend.ItemUse(BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].ItemGUID);
                return;
            };
            if (((ItemConst.IsUsable(_local5)) || (ItemConst.IsConsumable(_local5)))){
                BagInfoSend.ItemUse(BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].ItemGUID);
                return;
            };
            if (ItemConst.IsTaskCanUse(_local5)){
                facade.sendNotification(BagEvents.SHOW_TASKITEM_USE_UI, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].ItemGUID);
                return;
            };
            if (ItemConst.IsPet(_local5)){
                sendNotification(RoleEvents.FIT_PET, BagData.SelectedItem.Item);
                return;
            };
            if (ItemConst.IsOffer(_local5)){
                if (UnityConstData.contributeIsOpen){
                    SetFrame.RemoveFrame(BagData.SelectedItem.Item.ItemParent);
                    BagData.SelectedItem.Item.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(UnityEvent.BAGTOGUILDDONATE, BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index]);
                };
            } else {
                if (ItemConst.IsDailyTaskBook(_local5)){
                    facade.sendNotification(EventList.SHOWTASKDAILYBOOK);
                };
            };
        }
        private function processTrade(_arg1:DataProxy, _arg2:UseItem):void{
            if (BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].isBind == 1){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("forbidtrade2"),
                    color:0xFFFF00
                });
                return;
            };
            if ((BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index].Flags & ItemConst.FlAGS_TRADE)){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("forbidtrade1"),
                    color:0xFFFF00
                });
                return;
            };
            var _local3:InventoryItemInfo = BagData.AllItems[BagData.SelectIndex][BagData.SelectedItem.Index];
            if (BagData.petCanDeal(_local3) == false){
                MessageTip.popup(LanguageMgr.GetTranslation("forbidtrade3"));
                return;
            };
            var _local4:uint;
            _local4 = 0;
            while (_local4 < TradeConstData.goodSelfList.length) {
                if (TradeConstData.goodSelfList[_local4] == null){
                    BagData.SelectedItem.Item.IsLock = true;
                    BagData.LockItem(BagData.SelectIndex, BagData.SelectedItem.Index);
                    facade.sendNotification(EventList.GOTRADEVIEW, {
                        srcPlace:ItemConst.gridUnitToPlace(BagData.SelectIndex, (BagData.SelectedItem.Item as UseItem).Pos),
                        dstPlace:-1
                    });
                    break;
                };
                if (_local4 == (TradeConstData.goodSelfList.length - 1)){
                    facade.sendNotification(HintEvents.RECEIVEINFO, {
                        info:LanguageMgr.GetTranslation("tradefull"),
                        color:0xFFFF00
                    });
                };
                _local4++;
            };
        }

    }
}//package GameUI.Modules.Bag.Command 
