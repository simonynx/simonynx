//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.AutoPathFind {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.HTree.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.AutoPathFind.Datas.*;
    import GameUI.Modules.AutoPathFind.View.*;
    import GameUI.*;

    public class AutoPathMediator extends Mediator {

        public static const NAME:String = "AutoPathMediator";

        private var scroll:UIScrollPane = null;
        private var pathTree:HUITree;
        private var dataProxy:DataProxy = null;
        private var aRoleId:Array = null;
        private var panelBase:PanelBase = null;
        private var sceneName:String;
        private var cellContainer:Sprite = null;

        public function AutoPathMediator(){
            super(NAME);
        }
        private function closeUI(_arg1:Event):void{
            if (((dataProxy) && (!(dataProxy.AutoRoadIsOpen)))){
                return;
            };
            clearContainer();
            dataProxy.AutoRoadIsOpen = false;
            pathTree.removeAll();
            scroll.dispose();
            scroll.parent.removeChild(scroll);
            scroll = null;
            pathTree = null;
            if (cellContainer){
                cellContainer = null;
            };
        }
        private function creatCells():void{
            var _local1:AutoPathCell;
            var _local3:HTreeInfoStruct;
            var _local6:uint;
            var _local7:HGroupCellRenderer;
            cellContainer = new Sprite();
            var _local2:int;
            pathTree = new HUITree();
            while (_local2 < aRoleId.length) {
                _local3 = new HTreeInfoStruct(true, ((AutoPathData.autoPathDic[uint(aRoleId[_local2])].Remark + "_") + AutoPathData.autoPathDic[uint(aRoleId[_local2])].Name));
                _local3.Id = aRoleId[_local2];
                _local6 = uint(AutoPathData.autoPathDic[_local3.Id].NPCflags);
                _local3.type = _local6;
                pathTree.addMenu(_local3);
                _local2++;
            };
            pathTree.refresh();
            var _local4:int = pathTree.GroupCells.length;
            var _local5:int;
            while (_local5 < _local4) {
                _local7 = (pathTree.GroupCells[_local5] as HGroupCellRenderer);
                _local7.DesTf.textColor = 16770049;
                _local5++;
            };
            this.pathTree.addEventListener(HTreeEvent.CHANGE_SELECTED, onCurSelectedChange);
            this.pathTree.addEventListener(HTreeEvent.DOUBLE_CLICK_TREE, onDoubleClick);
            scroll = new UIScrollPane(pathTree);
            scroll.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            autoPathView.addChild(scroll);
            scroll.width = 145;
            scroll.height = 440;
            scroll.y = 10;
            scroll.refresh();
        }
        private function showUI():void{
            dataProxy.AutoRoadIsOpen = true;
            creatCells();
        }
        private function onDoubleClick(_arg1:HTreeEvent):void{
            if (GameCommonData.Player.IsAutomatism){
                PlayerController.EndAutomatism();
                facade.sendNotification(AutoPlayEventList.CANCEL_AUTOPLAY_EVENT);
            };
            GameCommonData.isAutoPath = true;
            GameCommonData.IsFollow = false;
            var _local2:Object = AutoPathData.autoPathDic[_arg1.id];
            if (_local2.Type != 1){
                GameCommonData.targetID = _arg1.id;
                GameCommonData.TaskTargetCommand = "";
                GameCommonData.Scene.MapPlayerTitleMove(new Point(_local2.X, _local2.Y), 2, sceneName);
            } else {
                GameCommonData.targetID = -1;
                GameCommonData.TaskTargetCommand = "";
                GameCommonData.Scene.MapPlayerTitleMove(new Point(_local2.X, _local2.Y), 0, GameCommonData.GameInstance.GameScene.GetGameScene.name);
            };
        }
        private function initData():void{
            var _local1:Object;
            var _local3:int;
            aRoleId = [];
            var _local2:XML = GameCommonData.MapConfigs[sceneName];
            while (_local3 < _local2.Location.length()) {
                _local1 = {};
                _local1.Id = _local2.Location[_local3].@Id;
                _local1.Name = _local2.Location[_local3].@Name;
                _local1.X = _local2.Location[_local3].@X;
                _local1.Y = _local2.Location[_local3].@Y;
                _local1.Type = _local2.Location[_local3].@Type;
                _local1.NPCflags = uint(_local2.Location[_local3].@NPCflags);
                _local1.Remark = _local2.Location[_local3].@Remark;
                _local1.ForbidTransmit = uint(_local2.Location[_local3].@ForbidTransmit);
                aRoleId.push(_local2.Location[_local3].@Id);
                AutoPathData.autoPathDic[uint(_local1.Id)] = _local1;
                _local3++;
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOW_AUTOPATH_UI, EventList.HIDE_AUTOPATH_UI, EventList.Reset_AUTOPATH_UI]);
        }
        protected function onCurSelectedChange(_arg1:HTreeEvent):void{
            if (_arg1.id != AutoPathData.currSelect){
                AutoPathData.currSelect = _arg1.id;
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    initUI();
                    break;
                case EventList.SHOW_AUTOPATH_UI:
                    sceneName = String(_arg1.getBody());
                    initData();
                    showUI();
                    break;
                case EventList.HIDE_AUTOPATH_UI:
                    closeUI(null);
                    break;
            };
        }
        private function clearContainer():void{
            var _local1:int;
            if (((cellContainer) && ((cellContainer.numChildren > 0)))){
                _local1 = (cellContainer.numChildren - 1);
                while (_local1 >= 0) {
                    cellContainer.removeChildAt(0);
                    _local1--;
                };
            };
        }
        public function get autoPathView():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function initUI():void{
            dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
            setViewComponent(new MovieClip());
            autoPathView.x = 568;
            autoPathView.y = 45;
        }

    }
}//package GameUI.Modules.AutoPathFind 
