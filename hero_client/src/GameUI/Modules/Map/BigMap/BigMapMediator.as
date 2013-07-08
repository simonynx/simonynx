//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Map.BigMap {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Map.SenceMap.*;
    import flash.filters.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.*;

    public class BigMapMediator extends Mediator {

        public static const NAME:String = "BigMapMediator";

        private var bigMapView:MovieClip;
        private var container:Sprite;
        private var maxNumMap:uint = 10;
        private var loadswfTool:LoadSwfTool;
        private var dataProxy:DataProxy;
        private var bigMapLayer:MovieClip;

        public function BigMapMediator(){
            super(NAME);
        }
        private function closeMap():void{
            if (bigMap){
                if (GameCommonData.GameInstance.contains(bigMap)){
                    GameCommonData.GameInstance.WorldMap.removeChild(bigMap);
                    dataProxy.BigMapIsOpen = false;
                    dataProxy.MAP_POSX = bigMap.x;
                    dataProxy.MAP_POSY = bigMap.y;
                };
            };
        }
        private function onMapClickHandler(_arg1:MouseEvent):void{
            var _local2:String = _arg1.currentTarget.name;
            var _local3:Array = _local2.split("_");
            var _local4:String = SmallConstData.getInstance().getSceneNameById(uint(_local3[1]));
            if (_local4 == null){
                return;
            };
            if (_local4 == String(GameCommonData.GameInstance.GameScene.GetGameScene.name)){
                sendNotification(EventList.SHOWSENCEMAP);
            } else {
                sendNotification(EventList.SHOWSENCEMAP, _local4);
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.LOADBIGMAP:
                    if (bigMapView == null){
                        loadswfTool = new LoadSwfTool(GameConfigData.BigMapSwf);
                        loadswfTool.sendShow = sendShow;
                    } else {
                        facade.sendNotification(EventList.SHOWBIGMAP);
                    };
                    break;
                case EventList.SHOWBIGMAP:
                    if (bigMapView == null){
                        bigMapView = (_arg1.getBody() as MovieClip);
                        initBigMap();
                    };
                    showBigMap();
                    break;
                case EventList.CLOSEBIGMAP:
                    this.closeMap();
                    break;
                case EventList.RESIZE_STAGE:
                    dataProxy.MAP_POSX = 0;
                    dataProxy.MAP_POSY = 0;
                    break;
            };
        }
        private function onMouseMoveHandler(_arg1:MouseEvent):void{
        }
        private function setMc(_arg1:MovieClip):void{
            _arg1.addEventListener(MouseEvent.CLICK, onMapClickHandler);
            _arg1.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
            _arg1.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
            _arg1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
        }
        private function showBigMap():void{
            var _local1:MovieClip;
            var _local3:uint;
            var _local4:String;
            if (dataProxy.BigMapIsOpen){
                closeMap();
            } else {
                dataProxy.BigMapIsOpen = true;
                bigMap.x = dataProxy.MAP_POSX;
                bigMap.y = dataProxy.MAP_POSY;
                GameCommonData.GameInstance.WorldMap.addChild(bigMap);
            };
            var _local2:uint = 1;
            while (_local2 <= this.maxNumMap) {
                _local1 = (this.bigMapLayer[("map_" + _local2)] as MovieClip);
                _local3 = 100;
                _local4 = SmallConstData.getInstance().getSceneNameById(_local2);
                if (_local4){
                    _local3 = SmallConstData.getInstance().mapItemDic[uint(_local4)].levelNeed;
                };
                if (GameCommonData.Player.Role.Level >= _local3){
                    _local1.visible = true;
                } else {
                    _local1.visible = false;
                };
                _local2++;
            };
            bigMap.content.mcPage_0.gotoAndStop(2);
            bigMap.content.bg_back0.width = 710;
            bigMap.content.bg_back1.visible = false;
            bigMap.btnTran.visible = false;
            initPage();
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local2:int;
            while (_local2 < 2) {
                bigMap.content[("mcPage_" + _local2)].gotoAndStop(2);
                bigMap.content[("mcPage_" + _local2)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                _local2++;
            };
            var _local3:uint = uint(_arg1.target.name.split("_")[1]);
            bigMap.content[("mcPage_" + _local3)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
            bigMap.content[("mcPage_" + _local3)].gotoAndStop(1);
            if (_local3 == 0){
                this.closeMap();
                sendNotification(EventList.SHOWSENCEMAP);
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWBIGMAP, EventList.LOADBIGMAP, EventList.CLOSEBIGMAP]);
        }
        private function sendShow(_arg1:DisplayObject):void{
            facade.sendNotification(EventList.SHOWBIGMAP, _arg1);
        }
        private function initBigMap():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            setViewComponent(new SceneMapView());
            bigMap.closeCallBack = closeMap;
            bigMapLayer = bigMapView;
            bigMap.addChild(bigMapLayer);
            bigMapLayer.x = 16;
            bigMapLayer.y = 58;
            if ((((dataProxy.MAP_POSX == 0)) && ((dataProxy.MAP_POSY == 0)))){
                bigMap.x = int(((GameCommonData.GameInstance.ScreenWidth - bigMap.width) / 2));
                bigMap.y = int(((GameCommonData.GameInstance.ScreenHeight - bigMap.height) / 2));
                dataProxy.MAP_POSX = bigMap.x;
                dataProxy.MAP_POSY = bigMap.y;
            };
            (this.viewComponent as DisplayObjectContainer).mouseEnabled = true;
            bigMap.content.txt_curMapName.visible = false;
            bigMap.content.txt_Page0.mouseEnabled = false;
            bigMap.content.txt_Page1.mouseEnabled = false;
            bigMap.content.txt_Page1.textColor = 0xFFFF00;
            initSet();
        }
        private function initSet():void{
            var _local1:uint = 1;
            while (_local1 <= this.maxNumMap) {
                this.setMc(this.bigMapLayer[("map_" + _local1)]);
                _local1++;
            };
        }
        private function onRollOutHandler(_arg1:MouseEvent):void{
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            _local2.filters = null;
        }
        private function onRollOverHandler(_arg1:MouseEvent):void{
            var _local2:DisplayObject = (_arg1.currentTarget as DisplayObject);
            var _local3:GlowFilter = new GlowFilter(0xFF00, 1, 5, 5, 8, 1, true, false);
            _local2.filters = [_local3];
        }
        private function get bigMap():SceneMapView{
            return ((this.viewComponent as SceneMapView));
        }
        private function initPage():void{
            var _local1:int;
            while (_local1 < 2) {
                bigMap.content[("mcPage_" + _local1)].buttonMode = true;
                bigMap.content[("mcPage_" + _local1)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                if (_local1 == 1){
                    bigMap.content[("mcPage_" + _local1)].gotoAndStop(1);
                    bigMap.content[("mcPage_" + _local1)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                } else {
                    bigMap.content[("mcPage_" + _local1)].gotoAndStop(2);
                };
                _local1++;
            };
        }

    }
}//package GameUI.Modules.Map.BigMap 
