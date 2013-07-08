//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Task.Model.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.NPCChat.Command.*;

    public class Guide_OccupationIntro_Command extends SimpleCommand {

        public static const NAME:String = "Guide_OccupationSelect_Command";

        override public function execute(_arg1:INotification):void{
            var _local4:uint;
            var _local5:int;
            var _local6:Object;
            if (_arg1.getBody() == null){
                return;
            };
            var _local2:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local3:int = _arg1.getBody()["type"];
            switch (_local3){
                case 1:
                    _local4 = _arg1.getBody()["mosterId"];
                    switch (_local4){
                        case TaskCommonData.LoopTaskCommitNpcArrTemp[1]:
                            _local5 = 1;
                            break;
                        case TaskCommonData.LoopTaskCommitNpcArrTemp[2]:
                            _local5 = 2;
                            break;
                        case TaskCommonData.LoopTaskCommitNpcArrTemp[3]:
                            _local5 = 3;
                            break;
                        case TaskCommonData.LoopTaskCommitNpcArrTemp[4]:
                            _local5 = 4;
                            break;
                        case TaskCommonData.LoopTaskCommitNpcArrTemp[5]:
                            _local5 = 5;
                            break;
                    };
                    if (_local5 == 0){
                        return;
                    };
                    if (!facade.hasMediator(OccupationIntroMediator.NAME)){
                        facade.registerMediator(new OccupationIntroMediator());
                    };
                    _local6 = {occupationId:_local5};
                    if (_local2.occupationIntroIsOpen){
                        sendNotification(NewGuideEvent.NEWOCCUPATIONINTRO_REFRESH, _local6);
                    } else {
                        sendNotification(NewGuideEvent.NEWOCCUPATIONINTRO_SHOW, _local6);
                        _local2.occupationIntroIsOpen = true;
                    };
                    break;
                case 2:
                    _local2.occupationIntroIsOpen = false;
                    break;
                case 3:
                    _local2.occupationIntroIsOpen = false;
                    sendNotification(NewGuideEvent.NEWOCCUPATIONINTRO_CLOSE);
                    break;
                case 4:
                    sendNotification(EventList.SHOWALERT, _arg1.getBody()["obj"]);
                    break;
                case 5:
                    sendNotification(NPCChatComList.SEND_NPC_MSG, _arg1.getBody()["obj"]);
                    break;
                case 6:
                    facade.removeCommand(Guide_OccupationIntro_Command.NAME);
                    facade.removeMediator(OccupationIntroMediator.NAME);
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
