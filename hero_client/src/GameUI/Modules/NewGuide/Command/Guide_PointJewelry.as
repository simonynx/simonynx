//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class Guide_PointJewelry extends SimpleCommand {

        public static const NAME:String = "Guide_PointJewelry";

        private static var equipArr:Array = [20600004, 20500003, 21000002, 20900001, 20600003];
        private static var placeArr:Array = [5, 4, 10, 9, 6];

        override public function execute(_arg1:INotification):void{
            var _local3:InventoryItemInfo;
            var _local7:int;
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local4:Array = RolePropDatas.ItemList;
            var _local5:int;
            while (_local5 < equipArr.length) {
                _local3 = BagData.getItemByType(equipArr[_local5]);
                _local7 = placeArr[_local5];
                if (((_local3) && (RolePropDatas.ItemList[_local7]))){
                    if ((((RolePropDatas.ItemList[_local7].TemplateID == _local3.TemplateID)) || (((RolePropDatas.ItemList[_local7]) && ((RolePropDatas.ItemList[_local7].RequiredLevel > _local3.RequiredLevel)))))){
                        equipArr.splice(_local5, 1);
                        placeArr.splice(_local5, 1);
                    };
                };
                _local5++;
            };
            var _local6:int;
            _local3 = null;
            while ((((_local6 < equipArr.length)) && ((_local3 == null)))) {
                _local3 = BagData.getItemByType(equipArr[_local6]);
                _local6++;
            };
            if (_local3){
                if (!_local2.BagIsOpen){
                    facade.sendNotification(EventList.SHOWBAG, 0);
                };
                facade.sendNotification(NewGuideEvent.POINTBAGITEM, {itemId:_local3.TemplateID});
                return;
            };
            facade.sendNotification(NewGuideEvent.POINTBAGITEM_CLOSE);
            facade.removeCommand(Guide_PointJewelry.NAME);
        }

    }
}//package GameUI.Modules.NewGuide.Command 
