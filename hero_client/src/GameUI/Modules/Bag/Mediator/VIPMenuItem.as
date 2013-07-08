//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Friend.view.ui.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.Unity.Data.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;

    public class VIPMenuItem {

        private var items:Array;
        private var _parent:Sprite;
        protected var menu:MenuItem;

        public function VIPMenuItem(_arg1:Sprite):void{
            items = [];
            super();
            _parent = _arg1;
            menu = new MenuItem();
            var _local2:String = LanguageMgr.GetTranslation("远程仓库");
            var _local3:String = LanguageMgr.GetTranslation("远程药店");
            var _local4:String = LanguageMgr.GetTranslation("公会捐献");
            var _local5:String = LanguageMgr.GetTranslation("职业捐献");
            items.push({
                cellText:_local2,
                data:{type:"item0"}
            });
            items.push({
                cellText:_local3,
                data:{type:"item1"}
            });
            items.push({
                cellText:_local4,
                data:{type:"item2"}
            });
            items.push({
                cellText:_local5,
                data:{type:"item3"}
            });
            menu.dataPro = items;
            showMenu();
        }
        private function onClickHandler(_arg1:MenuEvent):void{
            this.menu.removeEventListener(MenuEvent.Cell_Click, onClickHandler);
            UIFacade.GetInstance().sendNotification(EventList.CLOSEHEROPROP);
            switch (String(_arg1.cell.data["type"])){
                case "item0":
                    if (GameCommonData.Player.Role.VIP <= 0){
                        MessageTip.popup(LanguageMgr.GetTranslation("周卡及以上VIP玩家才拥有此特权"));
                        return;
                    };
                    UIFacade.GetInstance().sendNotification(EventList.SHOWDEPOTVIEW);
                    break;
                case "item1":
                    if (GameCommonData.Player.Role.VIP <= 1){
                        MessageTip.popup(LanguageMgr.GetTranslation("月卡及以上VIP玩家才拥有此特权"));
                        return;
                    };
                    MarketSend.requestInventory(1);
                    break;
                case "item2":
                    if (GameCommonData.Player.Role.VIP <= 2){
                        MessageTip.popup(LanguageMgr.GetTranslation("半年卡VIP玩家才拥有此特权"));
                        return;
                    };
                    UIFacade.GetInstance().sendNotification(UnityEvent.SHOW_GUILDDONATEPANEL, OfferType.OFFER_GUILD);
                    break;
                case "item3":
                    if (GameCommonData.Player.Role.VIP <= 2){
                        MessageTip.popup(LanguageMgr.GetTranslation("半年卡VIP玩家才拥有此特权"));
                        return;
                    };
                    if (GameCommonData.Player.Role.CurrentJobID > 0){
                        UIFacade.GetInstance().sendNotification(UnityEvent.SHOW_GUILDDONATEPANEL, GameCommonData.Player.Role.CurrentJobID);
                    } else {
                        MessageTip.popup(LanguageMgr.GetTranslation("你尚未加入职业"));
                    };
                    break;
            };
        }
        private function onStageClickHandler(_arg1:MouseEvent):void{
            this.menu.removeEventListener(MenuEvent.Cell_Click, onClickHandler);
            GameCommonData.GameInstance.GameUI.stage.removeEventListener(MouseEvent.CLICK, onStageClickHandler);
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
            };
        }
        public function showMenu():void{
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
                this.menu.removeEventListener(MenuEvent.Cell_Click, onClickHandler);
                GameCommonData.GameInstance.GameUI.stage.removeEventListener(MouseEvent.CLICK, onStageClickHandler);
                return;
            };
            this.menu.x = (_parent.x + 148);
            this.menu.y = (_parent.y + 55);
            menu.dataPro = items;
            GameCommonData.GameInstance.GameUI.addChild(this.menu);
            this.menu.addEventListener(MenuEvent.Cell_Click, onClickHandler);
            GameCommonData.GameInstance.GameUI.stage.addEventListener(MouseEvent.CLICK, onStageClickHandler);
        }

    }
}//package GameUI.Modules.Bag.Mediator 
