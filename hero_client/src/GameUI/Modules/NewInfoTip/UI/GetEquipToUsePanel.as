//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.BaseUI.*;
    import Net.RequestSend.*;
    import GameUI.Modules.NPCChat.Command.*;

    public class GetEquipToUsePanel extends HConfirmFrame {

        private var itemInfo:InventoryItemInfo;
        private var bg:Sprite;
        private var gridUnit:MovieClip;
        private var tipsText:StaticText;
        private var nameText:TextField;
        private var content:Sprite;
        private var useItem:UseItem;

        public function GetEquipToUsePanel(_arg1:InventoryItemInfo){
            this.itemInfo = _arg1;
            if (this.itemInfo){
                initView();
                addEvents();
            };
        }
        public function get ItemInfo():InventoryItemInfo{
            return (this.itemInfo);
        }
        private function addEvents():void{
            okFunction = __okHandler;
        }
        private function __okHandler(_arg1:MouseEvent=null):void{
            if (GameCommonData.Player.Role.Level < 5){
                CharacterSend.sendCurrentStep((((LanguageMgr.GetTranslation("领取并使用") + "(") + ItemInfo.Name) + ")"));
            };
            close();
        }
        private function initView():void{
            setSize(278, 226);
            blackGound = false;
            titleText = LanguageMgr.GetTranslation("提示");
            centerTitle = true;
            showCancel = false;
            content = new Sprite();
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySprite("GetEquipToUseViewAsset");
            content.addChild(bg);
            bg["itemNameTF"].text = itemInfo.Name;
            bg["itemNameTF"].selectable = false;
            var _local1:String = LanguageMgr.GetTranslation("物品");
            if (ItemConst.IsEquipTreasure(itemInfo)){
                _local1 = LanguageMgr.GetTranslation("神兵");
            } else {
                if (ItemConst.IsEquip(itemInfo)){
                    _local1 = LanguageMgr.GetTranslation("装备");
                } else {
                    if (ItemConst.IsPet(itemInfo)){
                        _local1 = LanguageMgr.GetTranslation("宠物");
                    } else {
                        if (ItemConst.IsBox(itemInfo)){
                            _local1 = LanguageMgr.GetTranslation("宝箱");
                        } else {
                            if (ItemConst.IsUsable(itemInfo)){
                                _local1 = LanguageMgr.GetTranslation("物品");
                            };
                        };
                    };
                };
            };
            bg["tipsTF"].text = (LanguageMgr.GetTranslation("恭喜你获得新") + _local1);
            bg["tipsTF"].selectable = false;
            okLabel = LanguageMgr.GetTranslation("领取并使用");
            gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
            useItem = new UseItem(0, itemInfo.TemplateID, content);
            useItem.Num = 1;
            useItem.x = 2;
            useItem.y = 2;
            gridUnit.addChildAt(useItem, 1);
            gridUnit.name = ("GetReward_" + itemInfo.TemplateID);
            gridUnit.index = 0;
            gridUnit.x = 120;
            gridUnit.y = 30;
            content.addChild(gridUnit);
            content.x = 4;
            content.y = 31;
            this.addContent(content);
        }
        override public function show():void{
            super.show();
            if (((GameCommonData.NPCDialogIsOpen) && (!((GetRewardConstData.BOX10ITEMGUID_ARR.indexOf(itemInfo.TemplateID) == -1))))){
                this.x = (this.x - 343);
            } else {
                UIFacade.GetInstance().sendNotification(NPCChatComList.NPCCHAT_VISIBLE, false);
            };
        }
        override public function close():void{
            if (((ItemConst.IsEquip(itemInfo)) || (ItemConst.IsPet(itemInfo)))){
                BagInfoSend.ItemSwap(itemInfo.Place, -1);
            } else {
                BagInfoSend.ItemUse(itemInfo.ItemGUID);
            };
            UIFacade.GetInstance().sendNotification(NPCChatComList.NPCCHAT_VISIBLE, true);
            super.close();
        }

    }
}//package GameUI.Modules.NewInfoTip.UI 
