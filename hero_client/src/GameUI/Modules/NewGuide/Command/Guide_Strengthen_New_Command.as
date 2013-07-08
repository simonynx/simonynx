//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Equipment.model.*;
    import GameUI.Modules.Task.Commamd.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.FilterBag.Mediator.*;
    import GameUI.Modules.FilterBag.Proxy.*;

    public class Guide_Strengthen_New_Command extends SimpleCommand {

        public static const NAME:String = "Guide_StrengthenCommand_New";

        private static var strengthStep:int = 0;

        private var sefItemId:int = 10100004;
        private var StrengItem2Id:int = 11010002;

        override public function execute(_arg1:INotification):void{
            var _local3:Object;
            var _local4:DisplayObject;
            var _local5:Array;
            var _local6:JianTouMc;
            if (_arg1.getBody() == null){
                return;
            };
            var _local2:int = _arg1.getBody()["type"];
            _local3 = _arg1.getBody()["data"];
            switch (_local2){
                case 1:
                    if (FilterBagData.getUseItemByTemplateId(equipId)){
                        _local4 = FilterBagData.getUseItemByTemplateId(equipId);
                    } else {
                        _local4 = (facade.retrieveMediator(FilterBagMediator.NAME).getViewComponent() as DisplayObject);
                    };
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local4, LanguageMgr.GetTranslation("强化引导_选择武器"), 3);
                    strengthStep = 0;
                    break;
                case 2:
                    _local4 = FilterBagData.getUseItemByTemplateId(StrengItem2Id);
                    if (_local4){
                        if (strengthStep == 0){
                            JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local4, LanguageMgr.GetTranslation("强化引导_使用12强"), 3, _local4.getBounds(_local4.stage));
                        } else {
                            if (strengthStep == 1){
                                JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local4, LanguageMgr.GetTranslation("强化引导_使用32强"), 3, _local4.getBounds(_local4.stage));
                            };
                        };
                    };
                    break;
                case 3:
                    _local5 = (_local3 as Array);
                    if (strengthStep == 1){
                        if ((((((_local5[1] == 0)) || ((_local5[2] == 0)))) || ((_local5[3] == 0)))){
                            facade.sendNotification(Guide_Strengthen_New_Command.NAME, {type:2});
                            return;
                        };
                        if (_local5[4] == 0){
                            facade.sendNotification(Guide_Strengthen_New_Command.NAME, {type:4});
                            return;
                        };
                        if (((((((!((_local5[1] == 0))) && (!((_local5[2] == 0))))) && (!((_local5[3] == 0))))) && (!((_local5[4] == 0))))){
                            facade.sendNotification(Guide_Strengthen_New_Command.NAME, {type:5});
                            return;
                        };
                    };
                    _local4 = (EquipDataConst.EquipStrengthenMediator.getViewComponent()["btn_commit"] as DisplayObject);
                    if (_local4){
                        _local6 = JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local4, "", 4);
                        _local6.autoClickClean = true;
                    };
                    break;
                case 4:
                    _local4 = FilterBagData.getUseItemByTemplateId(sefItemId);
                    if (_local4){
                        JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local4, LanguageMgr.GetTranslation("强化引导_使用神恩"), 3, _local4.getBounds(_local4.stage));
                    };
                    break;
                case 5:
                    _local4 = (EquipDataConst.EquipStrengthenMediator.getViewComponent()["btn_commit"] as DisplayObject);
                    if (_local4){
                        _local6 = JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).show(_local4, "", 3);
                        _local6.autoClickClean = true;
                    };
                    break;
                case 6:
                    if (strengthStep == 0){
                        strengthStep = 1;
                        facade.sendNotification(Guide_Strengthen_New_Command.NAME, {type:2});
                    } else {
                        if (strengthStep == 1){
                            facade.sendNotification(EquipCommandList.CLOSE_EQUIP_STRENGTH);
                            facade.sendNotification(Guide_Strengthen_New_Command.NAME, {type:7});
                            facade.sendNotification(TaskCommandList.AUTOPATH_TASK, GameCommonData.TaskInfoDic[1301]);
                        };
                    };
                    break;
                case 7:
                    JianTouMc.getInstance(JianTouMc.TYPE_STRENGTHEN).close();
                    facade.removeCommand(Guide_Strengthen_New_Command.NAME);
                    break;
            };
        }
        private function get equipId():int{
            var _local1:Array = [20410006, 20420006, 20430006, 20440006, 20450006];
            return (_local1[(GameCommonData.Player.Role.CurrentJobID - 1)]);
        }

    }
}//package GameUI.Modules.NewGuide.Command 
