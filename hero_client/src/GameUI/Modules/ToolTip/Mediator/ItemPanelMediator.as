//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.ToolTip.Mediator.UI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.ToolTip.Const.*;

    public class ItemPanelMediator extends Mediator {

        public static const NAME:String = "ItemPanelMediator";

        private var itemToolTip:Sprite = null;
        private var setItemToolTip:IToolTip = null;

        public function ItemPanelMediator(){
            super(NAME);
        }
        private function changePos():void{
            if (itemToolTip.x > (1000 - itemToolTip.width)){
                itemToolTip.x = (itemToolTip.x - setItemToolTip.BackWidth());
            };
            if (itemToolTip.y > (580 - itemToolTip.height)){
                itemToolTip.y = (itemToolTip.y - itemToolTip.height);
            };
            if (itemToolTip.y < 0){
                itemToolTip.y = 0;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWITEMTOOLPANEL]);
        }
        private function closeHandler():void{
            if (itemToolTip){
                if (GameCommonData.GameInstance.TooltipLayer.contains(itemToolTip)){
                    GameCommonData.GameInstance.TooltipLayer.removeChild(itemToolTip);
                    itemToolTip = null;
                };
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            switch (_arg1.getName()){
                case EventList.SHOWITEMTOOLPANEL:
                    closeHandler();
                    itemToolTip = new Sprite();
                    itemToolTip.mouseEnabled = false;
                    itemToolTip.mouseChildren = false;
                    _local2 = BagData.TipShowItemDic[_arg1.getBody().GUID];
                    if (_local2){
                        if (((ItemConst.IsEquip((_local2 as ItemTemplateInfo))) || (ItemConst.IsPet((_local2 as ItemTemplateInfo))))){
                            setItemToolTip = new SetItemToolTip(itemToolTip, _local2, true, closeHandler);
                        } else {
                            setItemToolTip = new SetItemToolTip(itemToolTip, _arg1.getBody().data, true, closeHandler);
                        };
                    } else {
                        IntroConst.GlobalBind = uint(_arg1.getBody().BindFlag);
                        if (_arg1.getBody().data == null){
                            _local2 = UIConstData.ItemDic[_arg1.getBody().GUID];
                            setItemToolTip = new SetItemToolTip(itemToolTip, _local2, true, closeHandler);
                        } else {
                            setItemToolTip = new SetItemToolTip(itemToolTip, _arg1.getBody().data, true, closeHandler);
                        };
                    };
                    setValue();
                    break;
            };
        }
        private function setValue():void{
            setItemToolTip.Show();
            GameCommonData.GameInstance.TooltipLayer.addChild(itemToolTip);
            itemToolTip.x = GameCommonData.GameInstance.TooltipLayer.mouseX;
            itemToolTip.y = (GameCommonData.GameInstance.TooltipLayer.mouseY - itemToolTip.height);
            changePos();
        }

    }
}//package GameUI.Modules.ToolTip.Mediator 
