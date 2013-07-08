//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Entrust.Data {
    import GameUI.ConstData.*;

    public class EntrustInfo {

        public var priceType:uint;
        public var price:uint;
        public var num:uint;
        public var item:InventoryItemInfo;
        public var templateId:uint;
        public var itemguid:uint;

        public function EntrustInfo():void{
            item = new InventoryItemInfo();
        }
    }
}//package GameUI.Modules.Entrust.Data 
