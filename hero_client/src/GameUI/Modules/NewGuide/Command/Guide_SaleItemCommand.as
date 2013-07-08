//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.NPCShop.Mediator.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;
    import GameUI.Modules.NPCShop.Data.*;

    public class Guide_SaleItemCommand extends SimpleCommand {

        public static const NAME:String = "Guide_SaleItemCommand";

        override public function execute(_arg1:INotification):void{
            var _local5:int;
            var _local6:GameElementNPC;
            var _local7:String;
            var _local2:int = _arg1.getBody()["step"];
            var _local3:DisplayObject = _arg1.getBody()["target"];
            var _local4:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            switch (_local2){
                case 0:
                    _local4.Guide_SaleItem_Started = true;
                    _local5 = 1052;
                    for (_local7 in GameCommonData.SameSecnePlayerList) {
                        if ((((GameCommonData.SameSecnePlayerList[_local7] is GameElementNPC)) && ((GameCommonData.SameSecnePlayerList[_local7].Role.MonsterTypeID == _local5)))){
                            _local6 = GameCommonData.SameSecnePlayerList[_local7];
                            break;
                        };
                    };
                    if (_local6 == null){
                        return;
                    };
                    if (NPCShopConstData.goodList[_local5] == null){
                        sendNotification(NPCChatComList.SEND_NPC_MSG, {
                            npcId:_local6.Role.Id,
                            linkId:0
                        });
                    } else {
                        facade.registerMediator(new NPCShopMediator());
                        sendNotification(EventList.SHOWNPCSHOPVIEW, {
                            npcId:_local6.Role.Id,
                            shopType:1,
                            shopName:_local6.Role.Name
                        });
                    };
                    break;
                case 1:
                    facade.sendNotification(NewGuideEvent.POINTBAGITEM, {
                        itemIdArr:NewGuideData.CANSALEITEMS,
                        tipsTxt:"<font color='#FFFF00'>双击</font>出售物品"
                    });
                    break;
                case 2:
                    facade.sendNotification(NewGuideEvent.POINTBAGITEM_CLOSE);
                    JianTouMc.getInstance().show(_local3, "", 3).autoClickClean = true;
                    _local4.Guide_SaleItem_Started = false;
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
