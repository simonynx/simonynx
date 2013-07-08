//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Map.SenceMap {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.View.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import flash.filters.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Task.Commamd.*;
    import OopsFramework.Content.Provider.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.AutoPathFind.*;
    import GameUI.Modules.AutoPathFind.Datas.*;
    import GameUI.*;

    public class SenceMapMediator extends Mediator {

        public static const NAME:String = "SenceMapMediator";

        private const direction:Array = [0, -27, -90, -153, 0, 0, 180, 27, 90, 153];

        private var playerIcon:MovieClip;
        private var mapContainer:Sprite;
        private var txt_mapPos:TextField;
        private var loader:BulkLoaderResourceProvider;
        private var minWidth:Number = 462;
        public var teamDataProxy:TeamDataProxy;
        private var isProLoading:Boolean;
        private var initFlag:Boolean = false;
        private var sName:String;
        private var minHeight:Number = 336;
        private var mapLayerContainer:Sprite;
        private var isLoading:Boolean;
        private var m_smallmappath:String;
        private var mapImgDic:Dictionary;
        private var closeBtn:SimpleButton;
        private var scenceName:String;
        private var pathSprite:UISprite;
        private var mapLayer:Bitmap;
        private var isCurrentScene:Boolean = false;
        private var defaultGF:GlowFilter;
        private var mapControl:MovieClip;
        private var senceMapContainer:Sprite;
        private var mapMask:MovieClip;
        private var dataProxy:DataProxy;
        private var flag:Boolean;
        private var panelBase:PanelBase = null;
        private var format:TextFormat = null;
        private var defaultFilters:Array;
        private var symbolSprite:Sprite;

        public function SenceMapMediator(){
  //          direction = [0, -27, -90, -153, 0, 0, 180, 27, 90, 153];
            defaultGF = new GlowFilter(0, 1, 2, 2, 16);
            mapImgDic = new Dictionary();
            defaultFilters = new Array();
            defaultFilters.push(defaultGF);
            super(NAME);
        }
        protected function showArenaScale():void{
            var _local6:uint;
            if (teamDataProxy.arenaMemberList == null){
                return;
            };
            if (dataProxy.SenceMapIsOpen == false){
                return;
            };
            if (pathSprite == null){
                return;
            };
            if (GameCommonData.Player.Role.ArenaTeamId == 0){
                return;
            };
            var _local1:uint = pathSprite.numChildren;
            var _local2:uint = (_local1 - 1);
            while (_local2 > 0) {
                if (pathSprite.getChildAt(_local2).name.split("_")[0] == "SMALLMAP"){
                    pathSprite.removeChildAt(_local2);
                };
                _local2--;
            };
            var _local3:Array = teamDataProxy.arenaMemberList;
            var _local4:MovieClip;
            var _local5:Point;
            if (this.pathSprite == null){
                return;
            };
            _local2 = 0;
            while (_local2 < _local3.length) {
                _local6 = _local3[_local2].playerId;
                if (_local6 != GameCommonData.Player.Role.Id){
                    if (GameCommonData.Player.Role.ArenaTeamId == 1){
                        _local4 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ArenaRedPoint");
                    } else {
                        _local4 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ArenaBluePoint");
                    };
                    _local5 = MapTileModel.GetTilePointToStage(_local3[_local2].GameX, _local3[_local2].GameY);
                    this.pathSprite.addChild(_local4);
                    _local4.x = Math.floor((_local5.x * MapTileModel.SCENEMAN_SCALE));
                    _local4.y = Math.floor((_local5.y * MapTileModel.SCENEMAN_SCALE));
                    _local4.name = ("SMALLMAP_" + _local3[_local2].Name);
                };
                _local2 = (_local2 + 1);
            };
        }
        protected function drawPath():void{
            var _local1:Array;
            var _local2:uint;
            var _local3:uint;
            if (flag){
                _local1 = GameCommonData.Player.PathMap;
                if ((((_local1 == null)) || ((pathSprite == null)))){
                    return;
                };
                this.pathSprite.graphics.clear();
                this.pathSprite.graphics.beginFill(0xFF0000, 1);
                _local2 = _local1.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    pathSprite.graphics.drawCircle((_local1[_local3].x * MapTileModel.SCENEMAN_SCALE), (_local1[_local3].y * MapTileModel.SCENEMAN_SCALE), 1);
                    _local3++;
                };
                this.pathSprite.graphics.endFill();
            };
        }
        private function onPathSpriteMove(_arg1:MouseEvent):void{
            var _local6:Point;
            var _local2:Number = Number(GameCommonData.MapConfigs[scenceName].@SceneMapScale);
            var _local3:int = GameCommonData.MapConfigs[scenceName].@MapWidth;
            var _local4:int = GameCommonData.MapConfigs[scenceName].@MapHeight;
            var _local5:Point = new Point((_arg1.currentTarget.mouseX / _local2), (_arg1.currentTarget.mouseY / _local2));
            if (GameCommonData.GameInstance.GameScene.GetGameScene.name == scenceName){
                _local6 = MapTileModel.GetTileStageToPoint(_local5.x, _local5.y);
            } else {
                _local6 = GetTileStageToPoint(_local5.x, _local5.y, _local3, _local4);
            };
            txt_mapPos.visible = true;
            txt_mapPos.text = String((((("[" + _local6.x) + ",") + _local6.y) + "]"));
            txt_mapPos.x = (_arg1.currentTarget.mouseX + 10);
            txt_mapPos.y = (_arg1.currentTarget.mouseY + 5);
        }
        protected function getTeamPosAction():void{
        }
        private function loadMap():void{
            if (this.mapImgDic[scenceName] != null){
                this.processMap();
                return;
            };
            if ((((GameCommonData.GameInstance.GameScene.GetGameScene.name == scenceName)) && (this.isProLoading))){
                this.isProLoading = false;
            };
            loader = new BulkLoaderResourceProvider();
            var _local1 = "";
            if (GameCommonData.currentMapVersion != 0){
                _local1 = (_local1 + ("?v=" + GameCommonData.currentMapVersion.toString()));
            };
            m_smallmappath = ((((GameCommonData.GameInstance.Content.RootDirectory + "Scene/") + scenceName) + "/Small.jpg") + _local1);
            loader.Download.Add(m_smallmappath);
            loader.Download.Load();
            loader.LoadComplete = onLoaderComplete;
        }
        public function GetTileStageToPoint(_arg1:int, _arg2:int, _arg3:int, _arg4:int):Point{
            var _local5:int = (_arg1 - (_arg2 * 2));
            if (_local5 < 0){
                _local5 = (_local5 - 60);
            };
            var _local6:int = ((_arg2 * 2) + _arg1);
            var _local7:int = ((_local6 + 30) / 60);
            var _local8:int = ((_local5 + 30) / 60);
            return (new Point(_local7, ((_arg4 / 30) + _local8)));
        }
        private function onRollOutPathSprite(_arg1:MouseEvent):void{
            txt_mapPos.visible = false;
        }
        private function doLayout():void{
            var _local1:MovieClip;
            var _local2:Point;
            var _local4:Array;
            var _local5:*;
            var _local6:GameElementEnemy;
            this.mapContainer.x = -10;
            this.mapContainer.y = 62;
            mapLayer.x = (this.mapContainer.x + 20);
            mapLayer.y = this.mapContainer.y;
            this.pathSprite.x = (this.mapLayer.x + 10);
            this.pathSprite.width = this.mapLayer.width;
            this.pathSprite.height = this.mapLayer.height;
            symbolSprite.x = (mapLayer.x + 10);
            LoadingView.getInstance().removeLoading();
            GameCommonData.GameInstance.GameUI.addChild(SenceMap);
            this.isLoading = false;
            var _local3:int = int(GameCommonData.GameInstance.GameScene.GetGameScene.name);
            if (_local3 > 2000){
                _local4 = GameCommonData.GameInstance.GameScene.GetGameScene.MiddleLayer.Elements.Concat();
                for each (_local5 in _local4) {
                    if ((_local5 is GameElementEnemy)){
                        _local6 = _local5;
                        _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BigRedPoint");
                        _local2 = MapTileModel.GetTilePointToStage(_local6.GameX, _local6.GameY);
                        this.pathSprite.addChild(_local1);
                        trace(_local2);
                        _local1.x = Math.floor((_local6.GameX * MapTileModel.SCENEMAN_SCALE));
                        _local1.y = Math.floor((_local6.GameY * MapTileModel.SCENEMAN_SCALE));
                        _local1.name = ("" + _local6.Role.Name);
                    };
                };
            };
        }
        protected function showTeamerScale():void{
            var _local6:uint;
            if (teamDataProxy.memberPosList == null){
                return;
            };
            if (dataProxy.SenceMapIsOpen == false){
                return;
            };
            if (pathSprite == null){
                return;
            };
            if (GameCommonData.GameInstance.GameScene.GetGameScene.name != scenceName){
                return;
            };
            var _local1:uint = pathSprite.numChildren;
            var _local2:uint = (_local1 - 1);
            while (_local2 > 0) {
                if (pathSprite.getChildAt(_local2).name.split("_")[0] == "SMALLMAP"){
                    pathSprite.removeChildAt(_local2);
                };
                _local2--;
            };
            var _local3:Array = teamDataProxy.memberPosList;
            var _local4:MovieClip;
            var _local5:Point;
            if (this.pathSprite == null){
                return;
            };
            _local2 = 0;
            while (_local2 < _local3.length) {
                _local4 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BigBulePoint");
                _local6 = _local3[_local2].playerId;
                _local5 = MapTileModel.GetTilePointToStage(_local3[_local2].GameX, _local3[_local2].GameY);
                this.pathSprite.addChild(_local4);
                _local4.x = Math.floor((_local5.x * MapTileModel.SCENEMAN_SCALE));
                _local4.y = Math.floor((_local5.y * MapTileModel.SCENEMAN_SCALE));
                _local4.name = ("SMALLMAP_" + _local3[_local2].Name);
                _local2 = (_local2 + 1);
            };
        }
        private function onLoaderComplete():void{
            var _local1:Bitmap = loader.GetResource(m_smallmappath).GetBitmap();
            this.mapImgDic[scenceName] = {mapLayer:_local1};
            processMap();
        }
        protected function onSmallClickHandler(_arg1:MouseEvent):void{
            GameCommonData.isAutoPath = false;
            GameCommonData.IsMoveTargetAnimal = false;
            this.flag = true;
            this.pathSprite.graphics.clear();
            GameCommonData.Scene.MapPlayerMove(new Point((this.pathSprite.mouseX / MapTileModel.SCENEMAN_SCALE), (this.pathSprite.mouseY / MapTileModel.SCENEMAN_SCALE)), 0, scenceName);
            GameCommonData.Player.SMapPathUpdate = drawPath;
            if (GameCommonData.Player.IsAutomatism){
                PlayerController.EndAutomatism();
            };
        }
        protected function onPreLoadComplete():void{
            if (!this.isProLoading){
                return;
            };
            var _local1:Bitmap = loader.GetResource(m_smallmappath).GetBitmap();
            this.mapImgDic[sName] = {mapLayer:_local1};
            this.isProLoading = false;
        }
        private function initPage():void{
            var _local1:int;
            while (_local1 < 2) {
                SenceMap.content[("mcPage_" + _local1)].buttonMode = true;
                SenceMap.content[("mcPage_" + _local1)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                if (_local1 == 0){
                    SenceMap.content[("mcPage_" + _local1)].gotoAndStop(1);
                    SenceMap.content[("mcPage_" + _local1)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
                } else {
                    SenceMap.content[("mcPage_" + _local1)].gotoAndStop(2);
                };
                _local1++;
            };
            SenceMap.content.txt_curMapName.x = 250;
            SenceMap.content.txt_curMapName.text = ((LanguageMgr.GetTranslation("当前地图") + ":") + GameCommonData.GameInstance.GameScene.GetGameScene.MapName);
        }
        private function initMap():void{
            var _local1:Point;
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local7:String;
            var _local8:uint;
            var _local9:TextField;
            var _local10:MovieClip;
            var _local11:uint;
            var _local12:int;
            while (this.mapLayerContainer.numChildren > 0) {
                this.mapLayerContainer.removeChildAt(0);
            };
            while (this.mapContainer.numChildren > 0) {
                this.mapContainer.removeChildAt(0);
            };
            this.mapLayerContainer.addChild(mapLayer);
            mapMask = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BlueBack2");
            mapMask.x = 0;
            mapMask.y = 38;
            mapMask.width = 561;
            mapMask.height = 465;
            mapLayer.mask = mapMask;
            mapMask.visible = false;
            SenceMap.addChild(mapMask);
            symbolSprite = new Sprite();
            var _local2:XML = GameCommonData.MapConfigs[scenceName];
            var _local3:uint;
            while (_local3 < _local2.Location.length()) {
                _local4 = _local2.Location[_local3].@X;
                _local5 = _local2.Location[_local3].@Y;
                _local6 = _local2.Location[_local3].@Remark;
                _local7 = _local2.Location[_local3].@Name;
                _local8 = uint(_local2.Location[_local3].@Color);
                if (_local8 == 0){
                    _local8 = 0xFFFFFF;
                };
                _local9 = new TextField();
                if (_local2.Location[_local3].@NPCflags > 0){
                    _local10 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowPoint");
                } else {
                    _local10 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedPoint");
                };
                _local9.autoSize = TextFieldAutoSize.LEFT;
                if (_local6.substr((_local6.length - 2), 2) == LanguageMgr.GetTranslation("转职")){
                    _local6 = _local6.substr(0, (_local6.length - 2));
                };
                _local9.text = _local6;
                if (uint(_local2.Location[_local3].@NPCflags) == 0){
                    _local9.text = ((_local7 + " ") + _local6);
                };
                if ((((((_local9.text == "")) || ((_local9.text == LanguageMgr.GetTranslation("传送点"))))) || ((_local9.text == LanguageMgr.GetTranslation("场景传送"))))){
                    _local9.text = _local2.Location[_local3].@Name;
                };
                _local11 = ((_local2.@MapHeight / 30) + 1);
                _local10.x = ((30 * ((_local4 + _local5) - _local11)) * _local2.@SceneMapScale);
                _local10.y = ((15 * ((_local4 - _local5) + _local11)) * _local2.@SceneMapScale);
                _local9.x = (_local10.x - (_local9.width / 2));
                _local9.y = (_local10.y - 20);
                if ((_local9.x + _local9.width) > ((mapLayer.width + mapLayer.x) + 10)){
                    _local12 = (((mapLayer.width + mapLayer.x) + 10) - _local9.x);
                };
                _local9.filters = defaultFilters;
                _local9.textColor = _local8;
                _local9.mouseEnabled = false;
                symbolSprite.addChild(_local10);
                symbolSprite.addChild(_local9);
                _local3++;
            };
            this.mapContainer.addChild(symbolSprite);
            this.mapContainer.addChild(this.pathSprite);
            if (GameCommonData.Player.Role.idTeam > 0){
                this.getTeamPosAction();
            };
            _local1 = new Point(uint((GameCommonData.Player.GameX * MapTileModel.SCENEMAN_SCALE)), uint((GameCommonData.Player.GameY * MapTileModel.SCENEMAN_SCALE)));
            if (isCurrentScene){
                this.pathSprite.addChild(this.playerIcon);
                this.playerIcon.x = _local1.x;
                this.playerIcon.y = _local1.y;
            };
            this.pathSprite.addEventListener(MouseEvent.MOUSE_MOVE, onPathSpriteMove);
            this.pathSprite.addEventListener(MouseEvent.ROLL_OUT, onRollOutPathSprite);
            this.pathSprite.addEventListener(MouseEvent.CLICK, onSmallClickHandler);
            this.pathSprite.mouseEnabled = true;
            this.doLayout();
        }
        protected function onTranslationClick(_arg1:MouseEvent):void{
            var _local2:Object;
            var _local3:uint;
            var _local4:uint;
            if (AutoPathData.currSelect){
                _local3 = (AutoPathData.autoPathDic[AutoPathData.currSelect] as Object).X;
                _local4 = (AutoPathData.autoPathDic[AutoPathData.currSelect] as Object).Y;
                if ((AutoPathData.autoPathDic[AutoPathData.currSelect] as Object).ForbidTransmit == 1){
                    MessageTip.popup(LanguageMgr.GetTranslation("此场景无法传送"));
                    return;
                };
                MoveToCommon.FlyTo(uint(scenceName), _local3, _local4, 0, 0);
                return;
            };
            if (this.scenceName == GameCommonData.GameInstance.GameScene.GetGameScene.name){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("已经在当前场景中了无需传送"),
                    color:0xFFFF00
                });
            } else {
                _local2 = SmallConstData.getInstance().mapItemDic[this.scenceName];
                if (_local2 != null){
                    MoveToCommon.FlyTo(uint(this.scenceName), _local2.tileX, _local2.tileY, 0, 0);
                };
            };
        }
        protected function onBigMapChangeHandler(_arg1:MouseEvent):void{
            this.panelCloseHandler();
            sendNotification(EventList.SHOWBIGMAP);
        }
        private function choicePageHandler(_arg1:MouseEvent):void{
            var _local2:int;
            while (_local2 < 2) {
                SenceMap.content[("mcPage_" + _local2)].gotoAndStop(2);
                SenceMap.content[("mcPage_" + _local2)].addEventListener(MouseEvent.CLICK, choicePageHandler);
                _local2++;
            };
            var _local3:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            SenceMap.content[("mcPage_" + _local3)].removeEventListener(MouseEvent.CLICK, choicePageHandler);
            SenceMap.content[("mcPage_" + _local3)].gotoAndStop(1);
            if (_local3 == 1){
                this.panelCloseHandler();
                sendNotification(EventList.LOADBIGMAP);
            };
        }
        private function get SenceMap():SceneMapView{
            return ((this.viewComponent as SceneMapView));
        }
        private function panelCloseHandler():void{
            if (dataProxy.SenceMapIsOpen == false){
                return;
            };
            sendNotification(EventList.HIDE_AUTOPATH_UI);
            GameCommonData.Player.SMapPathUpdate = null;
            while (mapContainer.numChildren > 0) {
                mapContainer.removeChildAt(0);
            };
            this.mapLayer = null;
            if (((symbolSprite) && (symbolSprite.parent))){
                while (symbolSprite.numChildren > 0) {
                    symbolSprite.removeChildAt(0);
                };
                symbolSprite.parent.removeChild(symbolSprite);
            };
            symbolSprite = null;
            if (pathSprite){
                this.pathSprite.removeEventListener(MouseEvent.MOUSE_MOVE, onPathSpriteMove);
                this.pathSprite.removeEventListener(MouseEvent.ROLL_OUT, onRollOutPathSprite);
                this.pathSprite.removeEventListener(MouseEvent.CLICK, onSmallClickHandler);
            };
            while (pathSprite.numChildren > 0) {
                this.pathSprite.removeChildAt(0);
            };
            this.pathSprite = null;
            if (SenceMap){
                if (GameCommonData.GameInstance.GameUI.contains(SenceMap)){
                    SenceMap.removeChild((facade.retrieveMediator(AutoPathMediator.NAME).getViewComponent() as MovieClip));
                    SenceMap.removeChild(mapMask);
                    GameCommonData.GameInstance.GameUI.removeChild(SenceMap);
                    dataProxy.SenceMapIsOpen = false;
                };
            };
            dataProxy.MAP_POSX = SenceMap.x;
            dataProxy.MAP_POSY = SenceMap.y;
            GameCommonData.GameInstance.MainStage.focus = GameCommonData.GameInstance.MainStage;
        }
        private function changePlayerDirection():void{
            this.playerIcon.rotation = this.direction[GameCommonData.Player.Role.Direction];
        }
        protected function onForceCharClick(_arg1:MouseEvent):void{
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.RESIZE_STAGE, EventList.SHOWSENCEMAP, EventList.CLOSESCENEMAP, EventList.UPDATE_SMALLMAP_DATA, EventList.UPDATE_SMALLMAP_PATH, EventList.SHOW_TEAM_MEMBER_POS, EventList.SHOW_ARENA_MEMBER_POS, EventList.CHANGE_SCENEMAP_EVENT]);
        }
        private function changePlayerPos():void{
            this.playerIcon.x = uint((GameCommonData.Player.GameX * MapTileModel.SCENEMAN_SCALE));
            this.playerIcon.y = uint((GameCommonData.Player.GameY * MapTileModel.SCENEMAN_SCALE));
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            var _local6:String;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    teamDataProxy = (facade.retrieveProxy(TeamDataProxy.NAME) as TeamDataProxy);
                    break;
                case EventList.SHOWSENCEMAP:
                    if (!initFlag){
                        initFlag = true;
                        setViewComponent(new SceneMapView());
                        if (SenceMap.y < 0){
                            SenceMap.y = 15;
                        };
                        SenceMap.closeCallBack = panelCloseHandler;
                        (this.viewComponent as DisplayObjectContainer).mouseEnabled = false;
                        mapContainer = new Sprite();
                        mapLayerContainer = new Sprite();
                        mapLayerContainer.mouseEnabled = false;
                        mapContainer.mouseEnabled = false;
                        this.playerIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SelfPos");
                        this.SenceMap.addChild(mapLayerContainer);
                        this.SenceMap.addChild(this.mapContainer);
                        SenceMap.content.txt_Page0.mouseEnabled = false;
                        SenceMap.content.txt_Page0.textColor = 0xFFFF00;
                        SenceMap.content.txt_Page1.mouseEnabled = false;
                    };
                    if (this.isLoading){
                        return;
                    };
                    this.isLoading = true;
                    LoadingView.getInstance().showLoading();
                    if ((((dataProxy.MAP_POSX == 0)) && ((dataProxy.MAP_POSY == 0)))){
                        SenceMap.x = int(((GameCommonData.GameInstance.ScreenWidth - SenceMap.width) / 2));
                        SenceMap.y = int(((GameCommonData.GameInstance.ScreenHeight - SenceMap.height) / 2));
                        dataProxy.MAP_POSX = SenceMap.x;
                        dataProxy.MAP_POSY = SenceMap.y;
                    };
                    if (_arg1.getBody() == null){
                        this.isCurrentScene = true;
                        if (flag){
                            GameCommonData.Player.SMapPathUpdate = drawPath;
                        };
                        this.scenceName = GameCommonData.GameInstance.GameScene.GetGameScene.name;
                    } else {
                        this.isCurrentScene = false;
                        this.scenceName = _arg1.getBody().toString();
                    };
                    this.pathSprite = new UISprite();
                    format = new TextFormat();
                    format.size = 12;
                    txt_mapPos = new TextField();
                    pathSprite.addChild(txt_mapPos);
                    txt_mapPos.filters = defaultFilters;
                    txt_mapPos.textColor = 0xFFFFFF;
                    txt_mapPos.visible = false;
                    SenceMap.content.bg_back0.width = 561;
                    SenceMap.content.bg_back1.visible = true;
                    AutoPathData.currSelect = 0;
                    SenceMap.btnTran.visible = true;
                    SenceMap.btnTran.addEventListener(MouseEvent.CLICK, onTranslationClick);
                    if (dataProxy.BigMapIsOpen){
                        sendNotification(EventList.CLOSEBIGMAP);
                    };
                    SenceMap.x = dataProxy.MAP_POSX;
                    SenceMap.y = dataProxy.MAP_POSY;
                    dataProxy.SenceMapIsOpen = true;
                    loadMap();
                    sendNotification(EventList.SHOW_AUTOPATH_UI, scenceName);
                    SenceMap.addChild((facade.retrieveMediator(AutoPathMediator.NAME).getViewComponent() as MovieClip));
                    initPage();
                    if ((((GameCommonData.Player.Role.idTeam > 0)) && ((teamDataProxy.teamMemberList.length > 1)))){
                        if (GameCommonData.GameInstance.GameScene.GetGameScene.name == scenceName){
                            showTeamerScale();
                            TeamSend.getMemberPos(1);
                        };
                    };
                    if ((((GameCommonData.Player.Role.ArenaTeamId > 0)) && (MapManager.IsInArena()))){
                        TeamSend.getMemberPos(2);
                    };
                    break;
                case EventList.CLOSESCENEMAP:
                    if (this.isLoading){
                        return;
                    };
                    panelCloseHandler();
                    break;
                case EventList.UPDATE_SMALLMAP_DATA:
                    if ((((dataProxy.SenceMapIsOpen == false)) || ((this.isCurrentScene == false)))){
                        return;
                    };
                    _local2 = _arg1.getBody();
                    _local3 = _local2.type;
                    _local4 = _local2.id;
                    if ((((_local3 == 5)) && (!((this.playerIcon == null))))){
                        this.changePlayerPos();
                    };
                    if ((((_local3 == 6)) && (!((this.playerIcon == null))))){
                        this.changePlayerDirection();
                    };
                    break;
                case EventList.UPDATE_SMALLMAP_PATH:
                    if (this.isCurrentScene == false){
                        return;
                    };
                    _local5 = uint(_arg1.getBody());
                    if ((((_local5 == 0)) || ((_local5 == 1)))){
                        this.flag = false;
                        if (this.pathSprite != null){
                            pathSprite.graphics.clear();
                        };
                    } else {
                        if (_local5 == 2){
                            if (this.flag){
                                this.drawPath();
                            };
                        };
                    };
                    break;
                case EventList.CHANGE_SCENEMAP_EVENT:
                    if ((((this.mapImgDic[sName] == null)) && (!(this.isProLoading)))){
                        this.isProLoading = true;
                        sName = GameCommonData.GameInstance.GameScene.GetGameScene.name;
                        loader = new BulkLoaderResourceProvider();
                        _local6 = "";
                        if (GameCommonData.currentMapVersion != 0){
                            _local6 = (_local6 + ("?v=" + GameCommonData.currentMapVersion.toString()));
                        };
                        m_smallmappath = ((((GameCommonData.GameInstance.Content.RootDirectory + "Scene/") + scenceName) + "/Small.jpg") + _local6);
                        loader.Download.Add(m_smallmappath);
                        loader.LoadComplete = onPreLoadComplete;
                        loader.Download.Load();
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    dataProxy.MAP_POSX = 0;
                    dataProxy.MAP_POSY = 0;
                    break;
                case EventList.SHOW_TEAM_MEMBER_POS:
                    showTeamerScale();
                    break;
                case EventList.SHOW_ARENA_MEMBER_POS:
                    showArenaScale();
                    break;
            };
        }
        private function processMap():void{
            mapLayer = this.mapImgDic[scenceName].mapLayer;
            var _local1:int = GameCommonData.MapConfigs[scenceName].@MapWidth;
            var _local2:int = GameCommonData.MapConfigs[scenceName].@MapHeight;
            var _local3:Number = Number(GameCommonData.MapConfigs[scenceName].@SceneMapScale);
            mapLayer.width = (_local1 * _local3);
            mapLayer.height = (_local2 * _local3);
            mapLayer.smoothing = true;
            initMap();
        }

    }
}//package GameUI.Modules.Map.SenceMap 
