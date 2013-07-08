//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Scene.StrategyElement.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NPCChat.Proxy.*;
    import GameUI.Modules.NPCExchange.Mediator.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.NPCChat.Command.*;
    import GameUI.Modules.NPCExchange.Data.*;

    public class Guide_EquipExchangeCommand extends SimpleCommand {

        public static const NAME:String = "Guide_EquipExchangeCommand";

        override public function execute(_arg1:INotification):void{
            var _local5:GameElementAnimal;
            var _local2:int = _arg1.getBody()["step"];
            var _local3:DisplayObject = _arg1.getBody()["target"];
            var _local4:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            switch (_local2){
                case 1:
                    _local5 = DialogConstData.getInstance().getNpcByMonsterId(1059);
                    if (_local5){
                        if (NPCExchangeConstData.goodList[_local5.Role.MonsterTypeID] == null){
                            sendNotification(NPCChatComList.SEND_NPC_MSG, {
                                npcId:_local5.Role.Id,
                                linkId:0
                            });
                        } else {
                            facade.registerMediator(new NPCExchangeMediator());
                            sendNotification(EventList.SHOWNPCEXCHANGEVIEW, {
                                npcId:_local5.Role.Id,
                                shopName:_local5.Role.Name
                            });
                        };
                    };
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
