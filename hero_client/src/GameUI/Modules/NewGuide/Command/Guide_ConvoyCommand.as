//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.FilterBag.Proxy.*;

    public class Guide_ConvoyCommand extends SimpleCommand {

        private static const GUIDE_CONVOYITEM:Array = [20210005, 20220005, 20230005, 20240005, 20250005, 20600001, 21000001, 20500001, 20600002, 20600003];
        public static const NAME:String = "Guide_ConvoyCommand";

        private static var curStep:int;

        private function guideUI(_arg1:int, _arg2:Object):void{
            var _local3:DataProxy;
            var _local4:UseItem;
            var _local5:int;
            var _local6:int;
            var _local7:JianTouMc;
            switch (_arg1){
                case 0:
                    if (((!((curStep == 0))) && (!((curStep == 3))))){
                        return;
                    };
                    curStep = 0;
                    _local6 = 0;
                    while (_local6 < GUIDE_CONVOYITEM.length) {
                        _local4 = FilterBagData.getUseItemByTemplateId(GUIDE_CONVOYITEM[_local6]);
                        if (_local4 == null){
                            GUIDE_CONVOYITEM.splice(_local6, 1);
                        };
                        _local6++;
                    };
                    _local3 = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    _local6 = 0;
                    while (_local6 < GUIDE_CONVOYITEM.length) {
                        _local5 = GUIDE_CONVOYITEM[_local6];
                        _local4 = FilterBagData.getUseItemByTemplateId(_local5);
                        if (_local4 != null){
                            break;
                        };
                        _local6++;
                    };
                    if (_local4){
                        if (!_local3.BagIsOpen){
                            facade.sendNotification(EventList.SHOWBAG, 0);
                        };
                        _local7 = JianTouMc.getInstance(JianTouMc.TYPE_CONVOY).show(_local4, "", 2);
                        _local7.autoClickClean = true;
                        return;
                    };
                    JianTouMc.getInstance(JianTouMc.TYPE_CONVOY).close();
                    facade.removeCommand(Guide_ConvoyCommand.NAME);
                    break;
                case 1:
                    if (curStep != 0){
                        return;
                    };
                    curStep = 1;
                    JianTouMc.getInstance(JianTouMc.TYPE_CONVOY).show((_arg2 as DisplayObject), "", 3);
                    break;
                case 2:
                    if (curStep != 1){
                        return;
                    };
                    curStep = 2;
                    JianTouMc.getInstance(JianTouMc.TYPE_CONVOY).show((_arg2 as DisplayObject), "", 3);
                    break;
                case 3:
                    curStep = 3;
                    JianTouMc.getInstance(JianTouMc.TYPE_CONVOY).close();
                    break;
            };
        }
        override public function execute(_arg1:INotification):void{
            var _local2:int = _arg1.getBody()["step"];
            var _local3:Object = _arg1.getBody()["data"];
            guideUI(_local2, _local3);
        }

    }
}//package GameUI.Modules.NewGuide.Command 
