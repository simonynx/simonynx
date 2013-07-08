//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;
    import OopsEngine.Scene.*;
    import Utils.*;

    public class MapManager {

        private static var transferSceneLoadComplete:Boolean = false;
        private static var transferSceneLoader:LoadSwfTool = null;
        private static var _gameScene:GameScene;
        public static var IsInArenaDieoutBattle:Boolean = false;

        public static function getTransferSceneMC():MovieClip{
            var _local1:MovieClip = transferSceneLoader.GetClassByMovieClip("TransferScene_1");
            return (_local1);
        }
        public static function IsInFormation():Boolean{
            if (GameCommonData.Player.Role.ArenaTeamId > 0){
                return (true);
            };
            return (false);
        }
        public static function setCurrScene(_arg1:GameScene):void{
            _gameScene = _arg1;
            if (transferSceneLoader == null){
                transferSceneLoader = new LoadSwfTool(GameConfigData.TransferSceneSwf, false);
                transferSceneLoader.sendShow = sendShow;
            } else {
                if (transferSceneLoadComplete){
                    _gameScene.loadTransfer();
                };
            };
        }
        public static function IsCanMediationMap():Boolean{
            if (((((((((IsInCSBattleReadyScene) || (GameCommonData.IsInCrossServer))) || (MapManager.isInParty()))) || (IsInArena()))) || (IsInGuildFB))){
                return (false);
            };
            return (true);
        }
        private static function sendShow(_arg1:DisplayObject):void{
            transferSceneLoadComplete = true;
            if (_gameScene){
                _gameScene.loadTransfer();
            };
        }
        public static function IsInFuben():Boolean{
            var _local1:int = (int(GameCommonData.GameInstance.GameScene.GetGameScene.MapId) / 1000);
            if (_local1 != 1){
                if (!IsInTower()){
                    return (true);
                };
            };
            return (false);
        }
        public static function IsMainCity():Boolean{
            if (GameCommonData.GameInstance.GameScene.GetGameScene.MapId == "1004"){
                return (true);
            };
            return (false);
        }
        public static function get IsInCSBattleReadyScene():Boolean{
            return ((int(GameCommonData.GameInstance.GameScene.GetGameScene.MapId) == 8002));
        }
        public static function IsInGVG():Boolean{
            if (GameCommonData.GameInstance.GameScene.GetGameScene.MapId == "6001"){
                return (true);
            };
            return (false);
        }
        public static function isInParty():Boolean{
            var _local1:int = int(GameCommonData.GameInstance.GameScene.GetGameScene.MapId);
            if (_local1 == 3001){
                return (true);
            };
            return (false);
        }
        public static function canAllowPKScene(_arg1:int):Boolean{
            if (((((!((_arg1 == 1004))) && (!(IsInTower())))) && ((_arg1 < 2000)))){
                return (true);
            };
            return (false);
        }
        public static function get IsInGuildFB():Boolean{
            return ((int(GameCommonData.GameInstance.GameScene.GetGameScene.MapId) == 4001));
        }
        public static function IsInTower():Boolean{
            var _local1:int = int(GameCommonData.GameInstance.GameScene.GetGameScene.MapId);
            if ((((_local1 >= 2007)) && ((_local1 <= 2016)))){
                return (true);
            };
            return (false);
        }
        public static function IsInArena():Boolean{
            if ((((GameCommonData.GameInstance.GameScene.GetGameScene.MapId == "5001")) || ((GameCommonData.GameInstance.GameScene.GetGameScene.MapId == "5002")))){
                return (true);
            };
            return (false);
        }

    }
}//package Manager 
