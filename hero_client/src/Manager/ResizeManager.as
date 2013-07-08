//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.View.BaseUI.*;
    import OopsEngine.Scene.StrategyScene.*;

    public class ResizeManager {

        private static var _instance:ResizeManager;

        public static function getInstance():ResizeManager{
            if (!_instance){
                _instance = new (ResizeManager)();
            };
            return (_instance);
        }

        public function Resize(_arg1:Event=null):void{
            var _local2:HFrame;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:Point;
            var _local7:Point;
            var _local8:int;
            var _local9:int;
            var _local10:Number;
            var _local11:String;
            _local3 = 0;
            while (_local3 < GameCommonData.GameInstance.GameUI.numChildren) {
                _local2 = (GameCommonData.GameInstance.GameUI.getChildAt(_local3) as HFrame);
                if (_local2){
                    _local4 = ((GameCommonData.GameInstance.ScreenWidth - _local2.frameWidth) / 2);
                    _local4 = ((_local4 < 0)) ? 0 : _local4;
                    _local5 = ((GameCommonData.GameInstance.ScreenHeight - _local2.frameHeight) / 2);
                    _local5 = ((_local5 < 0)) ? 0 : _local5;
                    _local2.x = _local4;
                    _local2.y = _local5;
                    _local2.stopDrag();
                };
                _local3++;
            };
            _local3 = 0;
            while (_local3 < GameCommonData.GameInstance.WorldMap.numChildren) {
                _local2 = (GameCommonData.GameInstance.WorldMap.getChildAt(_local3) as HFrame);
                if (_local2){
                    _local4 = ((GameCommonData.GameInstance.ScreenWidth - _local2.frameWidth) / 2);
                    _local4 = ((_local4 < 0)) ? 0 : _local4;
                    _local5 = ((GameCommonData.GameInstance.ScreenHeight - _local2.frameHeight) / 2);
                    _local5 = ((_local5 < 0)) ? 0 : _local5;
                    _local2.x = _local4;
                    _local2.y = _local5;
                    _local2.stopDrag();
                };
                _local3++;
            };
            if ((GameCommonData.GameInstance.GameScene.GetGameScene is GameScenePlay)){
                _local6 = MapTileModel.GetTilePointToStage(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY);
                _local7 = (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).SceneMove(_local6.x, _local6.y, true);
                _local8 = (_local7.x - (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).x);
                _local9 = (_local7.y - (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).y);
                _local10 = (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).Scale;
                _local11 = (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).MapId;
                if ((((SmallConstData.getInstance().smallMapDic[_local11][10] == -999)) && ((SmallConstData.getInstance().smallMapDic[_local11][11] == -999)))){
                    SmallConstData.getInstance().smallMapDic[_local11][10] = (-(_local8) * _local10);
                    SmallConstData.getInstance().smallMapDic[_local11][11] = (-(_local9) * _local10);
                };
                SmallConstData.getInstance().smallMapDic[_local11][0] = (SmallConstData.getInstance().smallMapDic[_local11][0] + SmallConstData.getInstance().smallMapDic[_local11][10]);
                SmallConstData.getInstance().smallMapDic[_local11][1] = (SmallConstData.getInstance().smallMapDic[_local11][1] + SmallConstData.getInstance().smallMapDic[_local11][11]);
                SmallConstData.getInstance().smallMapDic[_local11][10] = -(SmallConstData.getInstance().smallMapDic[_local11][10]);
                SmallConstData.getInstance().smallMapDic[_local11][11] = -(SmallConstData.getInstance().smallMapDic[_local11][11]);
                (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).x = int(_local7.x);
                (GameCommonData.GameInstance.GameScene.GetGameScene as GameScenePlay).y = int(_local7.y);
            };
            if (GameCommonData.Tiao){
               // GameCommonData.Tiao.x = ((GameCommonData.GameInstance.ScreenWidth - GameCommonData.Tiao.width) / 2);
               // GameCommonData.Tiao.y = ((GameCommonData.GameInstance.ScreenHeight / 2) + 180);
                if (GameCommonData.BackGround){
                    GameCommonData.BackGround.x = ((GameCommonData.GameInstance.ScreenWidth - GameCommonData.BackGround.width) / 2);
                    GameCommonData.BackGround.y = ((GameCommonData.GameInstance.ScreenHeight / 2) + 250);
                };
            };
            if (SpeciallyEffectController.getInstance().autoMc){
                SpeciallyEffectController.getInstance().autoMc.x = ((GameCommonData.GameInstance.ScreenWidth - SpeciallyEffectController.getInstance().autoMc.width) / 2);
                SpeciallyEffectController.getInstance().autoMc.y = 100;
            };
            UIFacade.GetInstance().Resize();
        }

    }
}//package Manager 
