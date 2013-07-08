//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class Guide_BagCommand extends SimpleCommand {

        public static const NAME:String = "Guide_BagCommand";

        private var dataProxy:DataProxy;

        private function closeBag():void{
            sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
            if ((((NewGuideData.curType == 8)) && ((NewGuideData.curStep == 3)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:8,
                    STEP:4
                });
            };
        }
        override public function execute(_arg1:INotification):void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            var _local2:uint = _arg1.getBody()["state"];
            switch (_local2){
                case 0:
                    updateBag();
                    break;
                case 1:
                    showBag();
                    break;
                case 2:
                    closeBag();
                    break;
            };
        }
        private function showBag():void{
            if ((((NewGuideData.curType == 8)) && ((NewGuideData.curStep == 1)))){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                    TYPE:8,
                    STEP:2
                });
            };
            facade.sendNotification(Guide_UseVipcarCommand.NAME, {step:2});
        }
        private function updateBag():void{
            if ((((NewGuideData.curType == 1)) && ((NewGuideData.curStep <= 10)))){
                if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_WEAPON]){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:1,
                        STEP:11
                    });
                };
            } else {
                if ((((NewGuideData.curType == 4)) && ((NewGuideData.curStep == 3)))){
                    if (BagData.getCountsByTemplateId(30100001, false) > 0){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:4,
                            STEP:4
                        });
                    };
                } else {
                    if ((((NewGuideData.curType == 6)) && ((NewGuideData.curStep <= 2)))){
                        if (BagData.getCountsByTemplateId(60300009, false) >= 1){
                            sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                TYPE:6,
                                STEP:3
                            });
                        };
                    } else {
                        if ((((NewGuideData.curType == 8)) && ((NewGuideData.curStep == 1)))){
                            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_PET0]){
                                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                    TYPE:8,
                                    STEP:4
                                });
                            };
                        } else {
                            if ((((NewGuideData.curType == 11)) && ((NewGuideData.curStep == 1)))){
                                if (BagData.getCountsByTemplateId(30100101, false) > 0){
                                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                        TYPE:11,
                                        STEP:2
                                    });
                                };
                            } else {
                                if ((((NewGuideData.curType == 13)) && ((NewGuideData.curStep <= 3)))){
                                    if (((RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_WEAPON]) && ((RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_WEAPON].TemplateID == 20102003)))){
                                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                            TYPE:13,
                                            STEP:5
                                        });
                                    };
                                } else {
                                    if (((((GameCommonData.TaskInfoDic[NewGuideData.TASK_13]) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsAccept))) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsComplete))){
                                        if (BagData.getCountsByTemplateId(60300014, false) >= 5){
                                            sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                                TYPE:13,
                                                STEP:7
                                            });
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (facade.hasCommand(Guide_PointJewelry.NAME)){
                facade.sendNotification(Guide_PointJewelry.NAME);
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
