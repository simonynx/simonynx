//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import GameUI.View.*;
    import OopsEngine.Graphics.Tagger.*;
    import Net.RequestSend.*;

    public class DuelController {

        public static var IsDueling:Boolean = false;
        public static var clearId:int;
        public static var time:int;

        public static function BeginDuel(_arg1:int):void{
            clearInterval(clearId);
            time = _arg1;
            clearId = setInterval(showCountDown, 1000);
        }
        public static function DuelWin():void{
            IsDueling = false;
            GameCommonData.DuelAnimal = null;
            var _local1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("WinView");
            _local1.gotoAndPlay(1);
            GameCommonData.GameInstance.GameUI.addChild(_local1);
            _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
            _local1.y = 250;
        }
        public static function AcceptDuel(_arg1:int):void{
            PlayerActionSend.DuelResult(_arg1, 0);
        }
        public static function InitiateDuel(_arg1:GameElementAnimal):void{
            if (_arg1 == null){
                return;
            };
            if (!DistanceController.PlayerTargetAnimalDistance(_arg1, 7)){
                MessageTip.show(LanguageMgr.GetTranslation("切磋距离过远"));
                return;
            };
            if (!MapManager.IsMainCity()){
                MessageTip.show(LanguageMgr.GetTranslation("必须在主城内才能切磋"));
                return;
            };
            if (!(((GameCommonData.Player.Role.Level >= 30)) && ((_arg1.Role.Level >= 30)))){
                MessageTip.show(LanguageMgr.GetTranslation("双30级才切磋"));
                return;
            };
            if (GameCommonData.Player.Role.isStalling > 0){
                MessageTip.show(LanguageMgr.GetTranslation("摆摊时不能申请切磋"));
                return;
            };
            PlayerActionSend.InViteDuelSend(_arg1.Role.Id);
        }
        public static function CancelDuel(_arg1:int):void{
            PlayerActionSend.DuelResult(_arg1, 1);
        }
        public static function showCountDown():void{
            var _local1:MovieClip;
            GameCommonData.Player.showAttackFace(AttackFace.OTHERS_DUEL, time);
            time--;
            if (time <= -1){
                IsDueling = true;
                clearInterval(clearId);
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("StartView");
                _local1.gotoAndPlay(1);
                GameCommonData.GameInstance.GameUI.addChild(_local1);
                _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
                _local1.y = 250;
            };
        }
        public static function DuelLost():void{
            var _local1:MovieClip;
            IsDueling = false;
            GameCommonData.DuelAnimal = null;
            _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("LostView");
            _local1.gotoAndPlay(1);
            GameCommonData.GameInstance.GameUI.addChild(_local1);
            _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
            _local1.y = 250;
        }

    }
}//package Manager 
