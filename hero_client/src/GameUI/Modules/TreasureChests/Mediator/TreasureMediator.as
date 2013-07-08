//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.TreasureChests.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.TreasureChests.Data.*;
    import GameUI.Modules.TreasureChests.View.*;

    public class TreasureMediator extends Mediator {

        public static const NAME:String = "TreasureMediator";

        private var smallBox:TreasureChest;
        private var chectView:TreasureChestView;
        private var dataProxy:DataProxy = null;

        public function TreasureMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, TreasureEvent.NEW_TREASURE, TreasureEvent.SHOW_TREASURE, TreasureEvent.CLOSE_TREASURE, EventList.RESIZE_STAGE, TreasureEvent.ALL_TREASURE_GET]);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    init();
                    break;
                case TreasureEvent.NEW_TREASURE:
                    _local2 = _arg1.getBody();
                    smallBox.setNewTreasure(_local2.time);
                    chectView.setItem(_local2.idArray, _local2.countArray, _local2.time);
                    if (dataProxy.TreasureViewIsOpen){
                        chectView.hide();
                    };
                    break;
                case TreasureEvent.SHOW_TREASURE:
                    if (!dataProxy.TreasureViewIsOpen){
                        chectView.show();
                    };
                    break;
                case TreasureEvent.CLOSE_TREASURE:
                    if (dataProxy.TreasureViewIsOpen){
                        chectView.hide();
                    };
                    break;
                case TreasureEvent.ALL_TREASURE_GET:
                    smallBox.removeAll();
                    if (dataProxy.TreasureViewIsOpen){
                        chectView.hide();
                    };
                    BtnManager.RankBtnPos();
                    break;
                case EventList.RESIZE_STAGE:
                    smallBox.setPos();
                    chectView.setPos();
                    BtnManager.RankBtnPos();
                    break;
            };
        }
        private function init():void{
            smallBox = new TreasureChest();
            GameCommonData.GameInstance.GameUI.addChild(smallBox);
            smallBox.setPos();
            chectView = new TreasureChestView();
            GameCommonData.GameInstance.GameUI.addChild(chectView);
            chectView.setPos();
            BtnManager.treasureChest = smallBox;
            BtnManager.RankBtnPos();
        }

    }
}//package GameUI.Modules.TreasureChests.Mediator 
