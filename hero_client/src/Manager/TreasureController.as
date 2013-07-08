//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.utils.*;
    import OopsFramework.Content.Loading.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import OopsEngine.Graphics.Treasure.*;

    public class TreasureController {

        private static var _instance:TreasureController;

        private var resLoader:BulkLoader;
        private var resourceLoadingQueue:Dictionary;
        private var effectResDic:Dictionary;

        public function TreasureController(){
            effectResDic = new Dictionary();
            resourceLoadingQueue = new Dictionary();
            resLoader = GameCommonData.playerResourceLoader;
            super();
        }
        public static function getInstance():TreasureController{
            if (_instance == null){
                _instance = new (TreasureController)();
            };
            return (_instance);
        }

        private function addTreasure(_arg1:GameElementAnimal, _arg2:int):void{
            var _local3:Treasure = new Treasure(_arg1, _arg2);
            (_arg1 as GameElementPlayer).CurrentTreasure = _local3;
        }
        public function RemoveComFun(_arg1:String, _arg2:Function):void{
            var _local3:int;
            if (resourceLoadingQueue[_arg1] != null){
                _local3 = resourceLoadingQueue[_arg1].indexOf(_arg2);
                if (_local3 != -1){
                    resourceLoadingQueue[_arg1].slice(_local3, 1);
                };
            };
        }
        public function updateTreasure(_arg1:GameElementAnimal, _arg2:int):void{
            removeTreasure(_arg1);
            if (_arg2 > 0){
                addTreasure(_arg1, _arg2);
            };
        }
        public function GetEffectRes(_arg1:String, _arg2:Function):void{
            var loadCompleteHandler:* = null;
            var effectRes:* = null;
            var name:* = null;
            var path:* = null;
            var treasureId:* = _arg1;
            var completeCallBack:* = _arg2;
            loadCompleteHandler = function (_arg1):void{
                var _local2:MovieClip;
                var _local3:Function;
                if ((_arg1 is Event)){
                    _arg1.currentTarget.removeEventListener(Event.COMPLETE, loadCompleteHandler);
                    _local2 = _arg1.currentTarget.loader.content;
                } else {
                    _local2 = _arg1;
                };
                if (effectResDic[treasureId] == true){
                    effectResDic[treasureId] = _local2;
                };
                completeCallBack(effectResDic[treasureId]);
                if (resourceLoadingQueue[treasureId] != null){
                    _local3 = resourceLoadingQueue[treasureId].shift();
                    while (_local3 != null) {
                        _local3(effectResDic[treasureId]);
                        _local3 = resourceLoadingQueue[treasureId].shift();
                    };
                };
            };
            if (effectResDic[treasureId] == null){
                effectResDic[treasureId] = true;
                name = ("treasure_" + treasureId);
                path = ((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/TreasureRes/") + treasureId) + ".swf?v=") + GameConfigData.PlayerVersion);
                resLoader.Add(path, false, null, 1, 3);
                effectRes = resLoader.GetLoadingItem(path);
                effectRes.name = name;
                effectRes.addEventListener(Event.COMPLETE, loadCompleteHandler);
                resLoader.Load();
            } else {
                if (effectResDic[treasureId] != true){
                    loadCompleteHandler(effectResDic[treasureId]);
                } else {
                    if (resourceLoadingQueue[treasureId] == null){
                        resourceLoadingQueue[treasureId] = [];
                    };
                    if (resourceLoadingQueue[treasureId].indexOf(completeCallBack) == -1){
                        resourceLoadingQueue[treasureId].push(completeCallBack);
                    };
                };
            };
        }
        private function removeTreasure(_arg1:GameElementAnimal):void{
            (_arg1 as GameElementPlayer).CurrentTreasure = null;
        }

    }
}//package Manager 
