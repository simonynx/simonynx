//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;

    public class GetRewardPreviewPanel extends HConfirmFrame {

        private var itemInfo:ItemTemplateInfo;
        private var bg:Sprite;
        private var gridUnit:MovieClip;
        private var content:Sprite;
        private var useItem:UseItem;

        public function GetRewardPreviewPanel(_arg1:int=0){
            itemInfo = UIConstData.ItemDic[20600008];
            initView();
            addEvents();
        }
        private function __clickHandler(_arg1:MouseEvent=null):void{
            if (BagData.getPanelEmptyNum(0) <= 0){
                MessageTip.show(LanguageMgr.GetTranslation("背包已满"));
                return;
            };
            CharacterSend.GetRewardReward(GetRewardType.TYPE_RING);
            close();
        }
        private function addEvents():void{
            okFunction = __clickHandler;
        }
        private function initView():void{
            setSize(282, 224);
            blackGound = true;
            titleText = LanguageMgr.GetTranslation("提示");
            centerTitle = true;
            showCancel = false;
            content = new Sprite();
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySprite("GetMountViewAsset");
            bg["tipsTF"].htmlText = ((("<font color=\"" + (GetRewardConstData.IsCanGet(GetRewardType.TYPE_RING)) ? "#0FFFFF" : "#FF0000") + "\">") + LanguageMgr.GetTranslation("33级可领取的物品提示句", itemInfo.Name));
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
            okBtn.enable = GetRewardConstData.IsCanGet(GetRewardType.TYPE_RING);
            content.x = 4;
            content.y = 31;
            this.addContent(content);
        }

    }
}//package GameUI.Modules.NewInfoTip.UI 
