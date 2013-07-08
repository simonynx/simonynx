//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Mediator.RoleUtils {
    import flash.display.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.StrategyElement.*;
    import Manager.*;
    import Utils.*;

    public class RoleLevUp {

        private static var posFlag:Boolean;
        private static var currPlayer:GameElementAnimal;
        private static var loadswfTool:LoadSwfTool = null;
        private static var levelUpLoadComplete:Boolean;

        private static function sendShow(_arg1:DisplayObject):void{
            var _local2:MovieClip;
            if (levelUpLoadComplete == false){
                levelUpLoadComplete = true;
            };
            _local2 = loadswfTool.GetClassByMovieClip("McLevUp");
            _local2.alpha = 0.85;
            if (((currPlayer.IsLoadSkins) && ((currPlayer.golem == null)))){
                if (posFlag == true){
                    _local2.x = 58;
                    _local2.y = 105;
                } else {
                    _local2.x = currPlayer.PlayerHitX;
                    _local2.y = currPlayer.PlayerHitY;
                };
                currPlayer.addChild(_local2);
            } else {
                _local2.x = currPlayer.GameX;
                _local2.y = (currPlayer.GameY - 40);
                GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(_local2);
            };
        }
        public static function PlayLevUp(_arg1:int, _arg2:Boolean):void{
            var _local3:GameElementAnimal = PlayerController.GetPlayer(_arg1);
            if ((((_local3 == null)) || (((!((_local3.Role.Type == GameRole.TYPE_PLAYER))) && (!((_local3.Role.Type == GameRole.TYPE_OWNER))))))){
                return;
            };
            if (_local3.Role.Type == GameRole.TYPE_OWNER){
                SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "LevelUpSound");
            };
            currPlayer = _local3;
            posFlag = _arg2;
            if (loadswfTool == null){
                loadswfTool = new LoadSwfTool(GameConfigData.LevelUpSwf, false);
                loadswfTool.sendShow = sendShow;
            } else {
                if (levelUpLoadComplete){
                    sendShow(null);
                };
            };
        }

    }
}//package GameUI.Modules.RoleProperty.Mediator.RoleUtils 
