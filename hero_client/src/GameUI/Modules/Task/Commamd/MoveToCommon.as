//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Commamd {
    import flash.events.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Net.RequestSend.*;
    import GameUI.Modules.QuickBuy.Command.*;

    public class MoveToCommon extends EventDispatcher {

        public function MoveToCommon(_arg1:IEventDispatcher=null){
            super(_arg1);
        }
        private static function clearUIPanels():void{
            UIFacade.UIFacadeInstance.sendNotification(EventList.CLOSE_NPC_ALL_PANEL);
        }
        public static function MoveTo(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint):void{
            var _local6:TaskInfoStruct;
            var _local8:Point;
            var _local9:Point;
            var _local10:Point;
            if (!GameCommonData.Scene.IsFirstLoad){
                return;
            };
            if (_arg4 != 0){
                _local6 = GameCommonData.TaskInfoDic[_arg4];
                if (_local6 == null){
                    return;
                };
                if (((((!((TaskCommonData.taskPathPointdic[_arg4] == null))) && (_local6.IsAccept))) && (!(_local6.IsComplete)))){
                    _local8 = TaskCommonData.getNewGuideTaskPointWithFixed(_arg4);
                    if (_local8){
                        _arg2 = _local8.x;
                        _arg3 = _local8.y;
                    };
                };
            };
            var _local7:String = GameCommonData.GameInstance.GameScene.GetGameScene.name;
            switch (_local7){
                case "2002":
                    if ((((((_arg1 == 1004)) && ((_arg5 == 1035)))) && ((_arg4 == 1014)))){
                        _arg1 = 2002;
                        _arg2 = 38;
                        _arg3 = 42;
                        _arg5 = 1031;
                    };
                    break;
            };
            if (GameCommonData.Player.IsAutomatism){
                PlayerController.EndAutomatism();
            };
            GameCommonData.isAutoPath = true;
            GameCommonData.targetID = _arg5;
            if (checkHasTaskTarget()){
                if (_arg4 > 0){
                    if (TaskCommonData.checkHaveProgress(_arg4)){
                        UIFacade.GetInstance().changeNpcWin(1);
                        return;
                    };
                } else {
                    UIFacade.GetInstance().changeNpcWin(1);
                    return;
                };
            };
            if (_arg1 == int(GameCommonData.Scene.gameScenePlay.name)){
                _local9 = new Point(_arg2, _arg3);
                if (!GameCommonData.Scene.gameScenePlay.Map.IsPass(_local9.x, _local9.y)){
                    _local10 = GameCommonData.Scene.gameScenePlay.Map.FindNearPassPoint(_local9);
                    _arg2 = _local10.x;
                    _arg3 = _local10.y;
                };
            };
            GameCommonData.Scene.MapPlayerTitleMove(new Point(_arg2, _arg3), 0, String(_arg1));
        }
        public static function sendFlyToCommand(_arg1:Object):void{
            var _local2:uint = BagData.getCountsByTemplateId(50100002, false);
            if (_local2 > 0){
                GameCommonData.Player.Stop();
                if (GameCommonData.Player.Role.UsingPetAnimal){
                    GameCommonData.Player.Role.UsingPetAnimal.Stop();
                };
                clearUIPanels();
                PlayerActionSend.trainmitChange(_arg1.tileX, _arg1.tileY, _arg1.mapId);
            } else {
                UIFacade.GetInstance().sendNotification(QuickBuyCommandList.SHOW_QUICKBUY_UI, {TemplateID:50100002});
            };
        }
        public static function FlyTo(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:Boolean=false):void{
            var _local8:TaskInfoStruct;
            var _local9:Point;
            if (!GameCommonData.Scene.IsFirstLoad){
                return;
            };
            if (GameCommonData.Player.IsAutomatism){
                MessageTip.show(LanguageMgr.GetTranslation("任务提示1"));
                return;
            };
            if (_arg4 != 0){
                _local8 = GameCommonData.TaskInfoDic[_arg4];
                if (_local8 == null){
                    return;
                };
                if (((((!((TaskCommonData.taskPathPointdic[_arg4] == null))) && (_local8.IsAccept))) && (!(_local8.IsComplete)))){
                    _local9 = TaskCommonData.getNewGuideTaskPointWithFixed(_arg4);
                    if (_local9){
                        _arg2 = _local9.x;
                        _arg3 = _local9.y;
                    };
                };
            };
            if (((GameCommonData.Player.Role.IsAttack) && ((GameCommonData.Player.Role.Level > 35)))){
                MessageTip.show(LanguageMgr.GetTranslation("任务提示2"));
                return;
            };
            if ((((String(_arg1) == GameCommonData.GameInstance.GameScene.GetGameScene.name)) && ((Math.sqrt((Math.pow((GameCommonData.Player.Role.TileX - _arg2), 2) + Math.pow((GameCommonData.Player.Role.TileY - _arg3), 2))) <= 5)))){
                GameCommonData.Scene.MapPlayerTitleMove(new Point(_arg2, _arg3), 0, String(_arg1));
                return;
            };
            if (GameCommonData.Player.IsAutomatism){
                PlayerController.EndAutomatism();
            };
            GameCommonData.isAutoPath = true;
            GameCommonData.targetID = _arg5;
            GameCommonData.TargetScene = "";
            var _local7:String = GameCommonData.GameInstance.GameScene.GetGameScene.name;
            if ((((((GameCommonData.Player.Role.VIP > 0)) || ((GameCommonData.Player.Role.Level < 4)))) || (_arg6))){
                GameCommonData.Player.Stop();
                if (GameCommonData.Player.Role.UsingPetAnimal){
                    GameCommonData.Player.Role.UsingPetAnimal.Stop();
                };
                clearUIPanels();
                PlayerActionSend.trainmitChange(_arg2, _arg3, _arg1);
                return;
            };
            sendFlyToCommand({
                mapId:_arg1,
                tileX:_arg2,
                tileY:_arg3,
                taskId:_arg4,
                npcId:_arg5
            });
        }
        private static function checkHasTaskTarget():Boolean{
            var _local1:String;
            for (_local1 in GameCommonData.SameSecnePlayerList) {
                if (((((((GameCommonData.SameSecnePlayerList[_local1]) && (!((GameCommonData.SameSecnePlayerList[_local1].Role.Type == GameRole.TYPE_OWNER))))) && (!((GameCommonData.SameSecnePlayerList[_local1].Role.Type == GameRole.TYPE_PLAYER))))) && ((GameCommonData.SameSecnePlayerList[_local1].Role.MonsterTypeID == GameCommonData.targetID)))){
                    if (GameCommonData.SameSecnePlayerList[_local1].Role.Type == GameRole.TYPE_NPC){
                        if (DistanceController.PlayerTargetAnimalDistance(GameCommonData.SameSecnePlayerList[_local1], 3)){
                            return (true);
                        };
                        return (false);
                    };
                    return (true);
                };
            };
            return (false);
        }

    }
}//package GameUI.Modules.Task.Commamd 
