//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import Net.RequestSend.*;

    public class GetMountPanel extends HConfirmFrame {

        private var itemInfo:ItemTemplateInfo;
        private var bg:Sprite;
        private var useItem:UseItem;
        private var gridUnit:MovieClip;
        private var MountIdArr:Array;
        private var content:Sprite;

        public function GetMountPanel(){
            MountIdArr = [10400001, 10400002, 10400003, 10400004, 10400005];
            super();
            if (GameCommonData.Player.Role.CurrentJobID > 0){
                itemInfo = UIConstData.ItemDic[MountIdArr[(GameCommonData.Player.Role.CurrentJobID - 1)]];
                initView();
                addEvents();
            };
        }
        private function __clickHandler(_arg1:MouseEvent=null):void{
            if (BagData.getPanelEmptyNum(0) <= 0){
                MessageTip.show(LanguageMgr.GetTranslation("背包已满"));
                return;
            };
            EffectLib.foodsMove([useItem]);
            CharacterSend.GetReward(GetRewardType.LEVEL_ITEM_HORSE);
            UIFacade.GetInstance().sendNotification(HelpTipsNotiName.HELPTIPS_MMSHOW, {
                content:LanguageMgr.GetTranslation("使用快捷键z用坐骑"),
                align:TextFormatAlign.CENTER,
                title:LanguageMgr.GetTranslation("提示")
            });
            close();
        }
        private function initView():void{
            setSize(278, 224);
            blackGound = true;
            titleText = LanguageMgr.GetTranslation("提示");
            centerTitle = true;
            showCancel = false;
            content = new Sprite();
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySprite("GetMountViewAsset");
            bg["tipsTF"].htmlText = ((("<font color=\"" + (GetRewardConstData.IsCanGetMount) ? "#0FFFFF" : "#FF0000") + "\">") + LanguageMgr.GetTranslation("18级领取坐骑提示句", itemInfo.Name));
            bg["tipsTF"].selectable = false;
            content.addChild(bg);
            okLabel = LanguageMgr.GetTranslation("领取并使用");
            gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
            useItem = new UseItem(0, itemInfo.TemplateID, content);
            useItem.Num = 1;
            useItem.x = 2;
            useItem.y = 2;
            gridUnit.addChildAt(useItem, 1);
            gridUnit.name = ("GetMountReward_" + itemInfo.TemplateID);
            gridUnit.index = 0;
            gridUnit.x = 120;
            gridUnit.y = 30;
            content.addChild(gridUnit);
            okBtn.enable = GetRewardConstData.IsCanGetMount;
            content.x = 4;
            content.y = 31;
            this.addContent(content);
        }
        private function addEvents():void{
            okFunction = __clickHandler;
        }

    }
}//package GameUI.Modules.NewInfoTip.UI 
