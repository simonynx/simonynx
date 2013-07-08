//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import GameUI.UICore.*;
    import flash.geom.*;
    import flash.utils.*;
    import GameUI.View.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.Modules.Pk.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.AutoPlay.Data.*;

    public class AutoFbManager {

        private static var _instance:AutoFbManager;
        private static var _IsAutoFbing:Boolean;

        public var isComplete:Boolean;
        private var infoLen:int;
        private var preTime:uint;
        private var isFirstStep:Boolean;
        public var isOpen:Boolean;
        private var currentAutoInfo:AutoFbInfo;
        public var FBRobotPoint:Point;
        public var currentStep:int;
        private var initStep:int;
        private var initTime:uint;

        public function AutoFbManager(){
            FBRobotPoint = new Point();
            super();
        }
        public static function instance():AutoFbManager{
            if (_instance == null){
                _instance = new (AutoFbManager)();
            };
            return (_instance);
        }
        public static function set IsAutoFbing(_arg1:Boolean):void{
            _IsAutoFbing = _arg1;
            if (((_IsAutoFbing) || (GameCommonData.Player.IsAutomatism))){
                SpeciallyEffectController.getInstance().showAutoMc(1);
            } else {
                SpeciallyEffectController.getInstance().showAutoMc(0);
            };
        }
        public static function get IsAutoFbing():Boolean{
            return (_IsAutoFbing);
        }

        public function beginAutoPlay(_arg1:int=0):void{
            var _local2:Point;
            if (PkData.PkStateList[0] == false){
                PlayerActionSend.SendPkState(true, 0);
            };
            if (PkData.PkStateList[1] == false){
                PlayerActionSend.SendPkState(true, 1);
            };
            UIFacade.GetInstance().sendNotification(AutoPlayEventList.START_AUTOPLAY_EVENT);
            if (checkMap()){
                if (_arg1 == 0){
                    findNearestStep();
                    initTime = getTimer();
                    initStep = currentStep;
                    isFirstStep = true;
                    preTime = initTime;
                } else {
                    if (_arg1 == 1){
                        if ((getTimer() - preTime) < 2000){
                        } else {
                            preTime = getTimer();
                            currentStep++;
                        };
                        if (currentStep < initStep){
                            currentStep = initStep;
                        };
                    };
                };
                FBRobotPoint.x = currentAutoInfo.posXArr[currentStep];
                FBRobotPoint.y = currentAutoInfo.posYArr[currentStep];
                _local2 = MapTileModel.GetTilePointToStage(currentAutoInfo.posXArr[currentStep], currentAutoInfo.posYArr[currentStep]);
                if (GameCommonData.Player.Role.GMFlag > 0){
                    MessageTip.show(((((((((LanguageMgr.GetTranslation("目前节点") + ":") + currentStep) + ",") + LanguageMgr.GetTranslation("移动位置")) + ":") + currentAutoInfo.posXArr[currentStep]) + ",") + currentAutoInfo.posYArr[currentStep]));
                    MessageTip.show(((LanguageMgr.GetTranslation("怪物数量") + ":") + currentAutoInfo.countArr[currentStep]));
                };
                if (isFirstStep){
                    isFirstStep = false;
                    IsAutoFbing = true;
                    if (TargetController.GetTargetDistance(TargetController.TargetExtent)){
                        currentStep--;
                        return;
                    };
                };
                if ((((GameCommonData.Player.Role.TileX == int(currentAutoInfo.posXArr[currentStep]))) && ((GameCommonData.Player.Role.TileY == int(currentAutoInfo.posYArr[currentStep]))))){
                    PlayerController.BeginAutomatism();
                } else {
                    IsAutoFbing = true;
                    GameCommonData.Scene.playerdistance = 0;
                    GameCommonData.Scene.PlayerMove(_local2);
                };
            } else {
                PlayerController.BeginAutomatism();
            };
        }
        public function reset():void{
            currentStep = 0;
            infoLen = 0;
            currentAutoInfo = null;
            isOpen = false;
            IsAutoFbing = false;
            isComplete = false;
        }
        public function findNearestStep():void{
            var _local1:int;
            var _local3:Point;
            var _local2:int = currentAutoInfo.posXArr.length;
            while (_local1 < _local2) {
                _local3 = new Point(currentAutoInfo.posXArr[_local1], currentAutoInfo.posYArr[_local1]);
                if (DistanceController.AnimalTargetDistance(GameCommonData.Player, _local3, 6)){
                    if (((((_local1 - currentStep) > 2)) || (((_local1 - currentStep) < -2)))){
                        currentStep = _local1;
                    };
                };
                _local1++;
            };
        }
        public function isEnd():Boolean{
            if (currentStep > (infoLen - 1)){
                isComplete = true;
                return (true);
            };
            return (false);
        }
        public function stopAutoPlay():void{
            IsAutoFbing = false;
        }
        public function checkMap():Boolean{
            var _local1:String;
            if (isComplete){
                return (false);
            };
            if (!isOpen){
                _local1 = GameCommonData.GameInstance.GameScene.GetGameScene.MapId;
                if (GameCommonData.autoListDic[_local1]){
                    currentAutoInfo = GameCommonData.autoListDic[_local1];
                    currentStep = 0;
                    infoLen = currentAutoInfo.countArr.length;
                    isOpen = true;
                    isComplete = false;
                    return (true);
                };
            } else {
                if (isEnd()){
                    return (false);
                };
                return (true);
            };
            return (false);
        }

    }
}//package Manager 
