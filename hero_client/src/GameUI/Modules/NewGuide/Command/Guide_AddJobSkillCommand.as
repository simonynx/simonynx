//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class Guide_AddJobSkillCommand extends SimpleCommand {

        public static const NAME:String = "Guide_AddJobSkillCommand";

        override public function execute(_arg1:INotification):void{
            if (_arg1.getBody()){
                gideUI(int(_arg1.getBody()["step"]), _arg1.getBody()["data"]);
            };
        }
        public function gideUI(_arg1:int, _arg2:Object):void{
            var _local4:JianTouMc;
            var _local3:DataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            switch (_arg1){
                case 1:
                    if (!_local3.NewSkillIsOpen){
                        _local3.NewSkillIsOpen = true;
                        facade.sendNotification(EventList.SHOWSKILLVIEW);
                    };
                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_POINT);
                    break;
                case 2:
                    _local4 = JianTouMc.getInstance(JianTouMc.TYPE_SKILL).show(_arg2["target"], LanguageMgr.GetTranslation("此技能建议加点学习"), 4, _arg2["target"].getBounds(_arg2["target"].stage));
                    _local4.autoClickClean = true;
                    break;
                case 3:
                    JianTouMc.getInstance(JianTouMc.TYPE_SKILL).close();
                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_SHUTDOWN);
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
