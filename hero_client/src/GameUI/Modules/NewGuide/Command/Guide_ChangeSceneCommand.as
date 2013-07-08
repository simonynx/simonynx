//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.AutoPlay.mediator.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class Guide_ChangeSceneCommand extends SimpleCommand {

        public static const NAME:String = "Guide_ChangeSceneCommand";

        private static var alertDialog:HAlertDialog;

        override public function execute(_arg1:INotification):void{
            var _local2:Array;
            var _local3:TaskInfoStruct;
            var _local4:DataProxy;
            if (NewGuideData.newerHelpIsOpen){
                _local2 = [];
                if ((((NewGuideData.curType == 6)) && ((NewGuideData.curStep == 1)))){
                    _local2 = TaskCommonData.GetTaskConPath(NewGuideData.TASK_6, 0);
                    if ((((((_local2.length >= 5)) && ((GameCommonData.GameInstance.GameScene.GetGameScene.name == _local2[0])))) && ((Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - _local2[1]), 2) + Math.pow((GameCommonData.Player.Role.TileY - _local2[2]), 2))) <= 5)))){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:6,
                            STEP:2
                        });
                    };
                } else {
                    if ((((NewGuideData.curType == 9)) && ((NewGuideData.curStep == 1)))){
                        _local2 = TaskCommonData.GetTaskConPath(NewGuideData.TASK_9, 0);
                        if ((((((_local2.length >= 5)) && ((GameCommonData.GameInstance.GameScene.GetGameScene.name == _local2[0])))) && ((Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - _local2[1]), 2) + Math.pow((GameCommonData.Player.Role.TileY - _local2[2]), 2))) <= 5)))){
                            facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                TYPE:9,
                                STEP:2
                            });
                        };
                    } else {
                        if ((((NewGuideData.curType == 13)) && ((NewGuideData.curStep <= 9)))){
                            if ((((((GameCommonData.GameInstance.GameScene.GetGameScene.name == "1004")) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_13]))) && (GameCommonData.TaskInfoDic[NewGuideData.TASK_13].IsComplete))){
                                facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                    TYPE:13,
                                    STEP:10
                                });
                            };
                        } else {
                            if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep <= 11)))){
                                _local2 = TaskCommonData.GetTaskConPath(1105, 0);
                                if ((((((_local2.length >= 5)) && ((GameCommonData.GameInstance.GameScene.GetGameScene.name == _local2[0])))) && ((Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - _local2[1]), 2) + Math.pow((GameCommonData.Player.Role.TileY - _local2[2]), 2))) <= 5)))){
                                    facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                        TYPE:19,
                                        STEP:12
                                    });
                                };
                            } else {
                                if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep <= 14)))){
                                    _local2 = TaskCommonData.GetTaskConPath(1109, 0);
                                    if ((((((_local2.length >= 5)) && ((GameCommonData.GameInstance.GameScene.GetGameScene.name == _local2[0])))) && ((Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - _local2[1]), 2) + Math.pow((GameCommonData.Player.Role.TileY - _local2[2]), 2))) <= 5)))){
                                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                            TYPE:19,
                                            STEP:15
                                        });
                                    };
                                } else {
                                    if ((((NewGuideData.curType == 19)) && ((NewGuideData.curStep <= 17)))){
                                        _local2 = TaskCommonData.GetTaskConPath(1112, 0);
                                        if ((((((_local2.length >= 5)) && ((GameCommonData.GameInstance.GameScene.GetGameScene.name == _local2[0])))) && ((Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - _local2[1]), 2) + Math.pow((GameCommonData.Player.Role.TileY - _local2[2]), 2))) <= 5)))){
                                            facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                                                TYPE:19,
                                                STEP:18
                                            });
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                switch (int(GameCommonData.GameInstance.GameScene.GetGameScene.name)){
                    case 2018:
                        _local3 = GameCommonData.TaskInfoDic[NewGuideData.TASK_SHENGYUAN_SINGLE];
                        if (((((_local3) && (_local3.IsAccept))) && (!(_local3.IsComplete)))){
                            if (!GameCommonData.Player.IsAutomatism){
                                if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                                    _local4 = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                                    if (!_local4.autoPlayIsOpen){
                                        sendNotification(AutoPlayEventList.SHOW_AUTOPLAY_UI);
                                    };
                                };
                                (facade.retrieveMediator(AutoPlayMediator.NAME) as AutoPlayMediator).shapAutoBtn();
                            };
                        };
                        break;
                };
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
