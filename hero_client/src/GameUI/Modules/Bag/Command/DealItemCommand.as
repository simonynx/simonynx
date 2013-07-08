//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.*;

    public class DealItemCommand extends SimpleCommand {

        public static const NAME:String = "DealItemCommand";

        public var comfrim:Function;
        private var parent:MovieClip = null;

        public function DealItemCommand(){
            comfrim = comfrimFn;
            super();
        }
        override public function execute(_arg1:INotification):void{
            parent = (_arg1.getBody() as MovieClip);
            var _local2:int;
            while (_local2 < BagData.GridUnitList[BagData.SelectIndex].length) {
                if (BagData.GridUnitList[BagData.SelectIndex][_local2].Item){
                    if (BagData.GridUnitList[BagData.SelectIndex][_local2].Item.IsLock){
                        facade.sendNotification(HintEvents.RECEIVEINFO, {
                            info:LanguageMgr.GetTranslation("deallimit"),
                            color:0xFFFF00
                        });
                        return;
                    };
                };
                _local2++;
            };
            SetFrame.RemoveFrame(parent);
            BagData.TmpIndex = -1;
            BagData.SelectedItem = null;
            BagInfoSend.ItemDeal(BagData.SelectIndexList[BagData.SelectIndex]);
        }
        public function comfrimFn():void{
        }

    }
}//package GameUI.Modules.Bag.Command 
