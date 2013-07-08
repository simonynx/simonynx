//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Map.SmallMap.SmallMapConst {
    import flash.events.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.MainScene.Mediator.*;
    import GameUI.Modules.Equipment.command.*;

    public class SmallConstData {

        private static var _instance:SmallConstData;

        public var mapItemKey:Array;
        public var smallMapDic:Dictionary;
        public var mapItemDic:Dictionary;

        public function SmallConstData(){
            var _local1:String;
            var _local2:XML;
            var _local3:uint;
            var _local4:String;
            smallMapDic = new Dictionary();
            mapItemDic = new Dictionary();
            super();
            mapItemKey = new Array();
            for (_local1 in GameCommonData.MapConfigs) {
                mapItemKey.push(_local1);
                mapItemDic[_local1] = new Object();
                smallMapDic[_local1] = [0, 0, 0, 0, 0, 0, true, 0, false, 0];
            };
            while (_local3 < mapItemKey.length) {
                _local2 = (GameCommonData.MapConfigs[uint(mapItemKey[_local3])] as XML);
                _local4 = mapItemKey[_local3];
                mapItemDic[uint(_local4)].name = String(_local2.@Name);
                mapItemDic[uint(_local4)].id = uint(_local2.SmallMapSetting.@MaskId);
                mapItemDic[uint(_local4)].levelNeed = 100;
                if (uint(_local2.SmallMapSetting.@LevelNeed) > 0){
                    mapItemDic[uint(_local4)].levelNeed = uint(_local2.SmallMapSetting.@LevelNeed);
                };
                mapItemDic[uint(_local4)].tileX = int(_local2.SmallMapSetting.@TileX);
                mapItemDic[uint(_local4)].tileY = int(_local2.SmallMapSetting.@TileY);
                smallMapDic[_local4][0] = -999;
                smallMapDic[_local4][1] = -999;
                smallMapDic[_local4][10] = -999;
                smallMapDic[_local4][11] = -999;
                smallMapDic[_local4][2] = 0;
                smallMapDic[_local4][3] = 0;
                smallMapDic[_local4][4] = 0;
                smallMapDic[_local4][5] = 0;
                smallMapDic[_local4][6] = true;
                smallMapDic[_local4][7] = int(_local2.SmallMapSetting.@EdgeX);
                if (smallMapDic[_local4][7] == 0){
                    smallMapDic[_local4][6] = false;
                };
                smallMapDic[_local4][8] = false;
                smallMapDic[_local4][9] = int(_local2.SmallMapSetting.@EdgeY);
                _local3++;
            };
        }
        public static function getInstance():SmallConstData{
            if (_instance == null){
                _instance = new (SmallConstData)();
            };
            return (_instance);
        }

        public function onShowEquipStreng(_arg1:MouseEvent):void{
            var _local2:DataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
            if (GameCommonData.Player.Role.isStalling > 0){
                MessageTip.show(LanguageMgr.GetTranslation("摆摊时无法进行铸造"), 0xFFFF00);
                return;
            };
            if (_local2.TradeIsOpen){
                MessageTip.show(LanguageMgr.GetTranslation("交易时无法进行铸造"), 0xFFFF00);
                return;
            };
            if (_local2.ConvoyIsOpen){
                MessageTip.show(LanguageMgr.GetTranslation("接运镖任务时无法进行铸造"));
                return;
            };
            var _local3:uint;
            if (_local2.ForgeOpenFlag >= DataProxy.FORGE_TREASURE_START){
                UIFacade.GetInstance().sendNotification(EquipCommandList.CLOSETREASURE_CMDLIST[(_local2.ForgeOpenFlag - DataProxy.FORGE_TREASURE_START)]);
                _local3 = 2;
            } else {
                if (_local2.ForgeOpenFlag >= DataProxy.FORGE_EQUIP_START){
                    UIFacade.GetInstance().sendNotification(EquipCommandList.CLOSEEQUIP_CMDLIST[(_local2.ForgeOpenFlag - DataProxy.FORGE_EQUIP_START)]);
                    _local3 = 1;
                };
            };
            if (compareStrengthenBtn(_arg1)){
                if (_local3 != 1){
                    UIFacade.GetInstance().sendNotification(EquipCommandList.SHOW_EQUIPSTRENGTHEN_UI, {iconClick:true});
                };
            } else {
                if (compareTreasureBtn(_arg1)){
                    if (_local3 != 2){
                        UIFacade.GetInstance().sendNotification(EquipCommandList.SHOW_TREASUREREBUILD_UI, {iconClick:true});
                    };
                };
            };
        }
        public function onCloseEquipStreng():Boolean{
            var _local1:DataProxy = (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy);
            if (_local1.ForgeOpenFlag >= DataProxy.FORGE_TREASURE_START){
                UIFacade.GetInstance().sendNotification(EquipCommandList.CLOSETREASURE_CMDLIST[(_local1.ForgeOpenFlag - DataProxy.FORGE_TREASURE_START)]);
                return (true);
            };
            if (_local1.ForgeOpenFlag >= DataProxy.FORGE_EQUIP_START){
                UIFacade.GetInstance().sendNotification(EquipCommandList.CLOSEEQUIP_CMDLIST[(_local1.ForgeOpenFlag - DataProxy.FORGE_EQUIP_START)]);
                return (true);
            };
            return (false);
        }
        private function compareTreasureBtn(_arg1:MouseEvent):Boolean{
            var _local2:Object = (UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getTreasureBtn();
            if (_arg1.currentTarget === _local2){
                return (true);
            };
            return (false);
        }
        public function getSceneNameById(_arg1:uint):String{
            var _local2:*;
            var _local3:Object;
            for (_local2 in mapItemDic) {
                _local3 = mapItemDic[_local2];
                if (_local3.id == _arg1){
                    return (_local2);
                };
            };
            return (null);
        }
        private function compareStrengthenBtn(_arg1:MouseEvent):Boolean{
            var _local2:Object = (UIFacade.GetInstance().retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getStrengthBtn();
            if (_arg1.currentTarget === _local2){
                return (true);
            };
            return (false);
        }

    }
}//package GameUI.Modules.Map.SmallMap.SmallMapConst 
