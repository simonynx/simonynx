//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pet.Mediator {
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Pet.view.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Pet.Data.*;

    public class PetRenameMediator extends Mediator {

        public static const NAME:String = "PetRenameMediator";

        private var itemInfo:InventoryItemInfo;

        public function PetRenameMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        override public function listNotificationInterests():Array{
            return ([PetEvent.PET_RENAMEVIEW_SHOW, PetEvent.PET_RENAMEVIEW_HIDE, EventList.RESIZE_STAGE]);
        }
        protected function get view():PetReNameView{
            if (viewComponent == null){
                setViewComponent(new PetReNameView());
            };
            return ((viewComponent as PetReNameView));
        }
        public function updatePetName(_arg1:uint, _arg2:uint, _arg3:String=""):void{
            view.txtpetNewname.text = "";
            var _local4:InventoryItemInfo = RolePropDatas.ItemList[_arg2];
            if (_local4 == null){
                return;
            };
            MessageTip.popup(LanguageMgr.GetTranslation("宠物改名成功感叹!"));
            _local4.PetInfo.PetName = _arg3;
            var _local5:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            if (((_local5) && (_local5.PetIsOpen))){
                (facade.retrieveMediator(PetViewMediator.NAME) as PetViewMediator).updatePetList();
            };
            sendNotification(PetEvent.PET_RENAMEVIEW_HIDE);
            sendNotification(PlayerInfoComList.UPDATE_PET_UI);
        }
        private function __createHandler(_arg1:MouseEvent=null):void{
            var _local2:String = view.txtpetNewname.text;
            _local2 = _local2.replace(/^\s*|\s*$/g, "").split(" ").join("");
            if ((((_local2 == null)) || ((_local2 == "")))){
                MessageTip.popup(LanguageMgr.GetTranslation("输入名称不能为空"));
                return;
            };
            if (((!(UIUtils.isPermitedName(_local2))) || (!(UIUtils.legalRoleName(_local2))))){
                MessageTip.show(LanguageMgr.GetTranslation("宠物名不合法感叹"));
                return;
            };
            PetSend.ReName(itemInfo.Place, _local2);
        }
        private function __cancelHandler(_arg1:MouseEvent=null):void{
            sendNotification(PetEvent.PET_RENAMEVIEW_HIDE);
        }
        private function removeEvent():void{
        }
        private function addEvent():void{
            view.okFunction = __createHandler;
            view.cancelFunction = __cancelHandler;
            view.closeCallBack = __cancelHandler;
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case PetEvent.PET_RENAMEVIEW_SHOW:
                    itemInfo = (_arg1.getBody() as InventoryItemInfo);
                    view.show();
                    view.x = ((GameCommonData.GameInstance.ScreenWidth - view.frameWidth) / 2);
                    view.y = ((GameCommonData.GameInstance.ScreenHeight - view.frameHeight) / 2);
                    addEvent();
                    view.center();
                    break;
                case PetEvent.PET_RENAMEVIEW_HIDE:
                    view.close();
                    removeEvent();
                    break;
                case EventList.RESIZE_STAGE:
                    view.x = ((GameCommonData.GameInstance.ScreenWidth - view.frameWidth) / 2);
                    view.y = ((GameCommonData.GameInstance.ScreenHeight - view.frameHeight) / 2);
                    break;
            };
        }

    }
}//package GameUI.Modules.Pet.Mediator 
