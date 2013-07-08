//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class Guide_PetRaceCommand extends SimpleCommand {

        public static const NAME:String = "Guide_PetRaceCommand";

        override public function execute(_arg1:INotification):void{
            var _local2:uint = uint(_arg1.getBody());
            if ((((_local2 > 1)) && (!((NewGuideData.curType == 21))))){
                return;
            };
            var _local3:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local4:Object = (facade.retrieveMediator("PetRaceMediator") as Object);
            switch (_local2){
                case 1:
                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {step:1});
                    break;
                case 2:
                    if ((((((NewGuideData.curStep == 1)) && (_local3.PetRaceIsOpen))) && (!((TimeManager.Instance.Now().day == 6))))){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:2,
                            data:{target:_local4.panel1.signUpBtn}
                        });
                    };
                    break;
                case 3:
                    if (NewGuideData.curStep == 2){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:3,
                            data:{target:_local4.panel1.petTeamRenamePanel.okBtn}
                        });
                    };
                    break;
                case 4:
                    if (NewGuideData.curStep == 3){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:4,
                            data:{target:_local4.myTeamBtn}
                        });
                    };
                    break;
                case 5:
                    if (NewGuideData.curStep == 4){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:5,
                            data:{target:_local4.panel2.TopCell[0].button}
                        });
                    };
                    break;
                case 6:
                    if ((((NewGuideData.curStep == 5)) && ((_local4.panel2.petSelectPanel.cells.length > 0)))){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:6,
                            data:{target:_local4.panel2.petSelectPanel.cells[0].view.mcRadio}
                        });
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                    };
                    break;
                case 7:
                    if (NewGuideData.curStep == 6){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:7,
                            data:{target:_local4.panel2.petSelectPanel.okBtn}
                        });
                    };
                    break;
                case 8:
                    if (NewGuideData.curStep == 7){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:8,
                            data:{target:_local4.panel2.applyBtn}
                        });
                    };
                    break;
                case 9:
                    if (NewGuideData.curStep == 8){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:9,
                            data:{target:_local4.pointRaceBtn}
                        });
                    };
                    break;
                case 10:
                    if (NewGuideData.curStep == 9){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:10,
                            data:{target:_local4.panel1.teamBtn}
                        });
                    };
                    break;
                case 11:
                    if ((((NewGuideData.curStep == 10)) && (_local4.panel1.getCellByIdx(0)))){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETRACE, {
                            step:11,
                            data:{target:_local4.panel1.getCellByIdx(0).button}
                        });
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                    };
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
