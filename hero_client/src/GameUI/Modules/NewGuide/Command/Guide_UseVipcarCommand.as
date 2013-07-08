//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class Guide_UseVipcarCommand extends SimpleCommand {

        public static const NAME:String = "Guide_UseVipcarCommand";

        override public function execute(_arg1:INotification):void{
            if (_arg1.getBody()){
                gideUI(int(_arg1.getBody()["step"]), _arg1.getBody()["data"]);
            };
        }
        public function gideUI(_arg1:int, _arg2:Object):void{
            var _local3:DataProxy;
            switch (_arg1){
                case 1:
                    _local3 = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    if (!_local3.BagIsOpen){
                        facade.sendNotification(EventList.SHOWONLY_CENTER_FIVE_PANEL, "bag");
                        facade.sendNotification(EventList.SHOWBAG, 0);
                    };
                    break;
                case 2:
                    facade.sendNotification(NewGuideEvent.POINTBAGITEM, {
                        itemId:"10700004",
                        tipsTxt:LanguageMgr.GetTranslation("双击使用VIP体验卡")
                    });
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
