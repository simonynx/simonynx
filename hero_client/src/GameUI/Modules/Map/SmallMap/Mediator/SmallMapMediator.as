//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Map.SmallMap.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Map.SmallMap.SmallMapConst.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import OopsEngine.AI.PathFinder.*;
    import flash.net.*;
    import GameUI.View.Components.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.SetView.Data.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.Mail.Data.*;
    import GameUI.*;

    public class SmallMapMediator extends Mediator {

        public static const NAME:String = "SmallMapMediator";

        private const direction:Array = [0, -27, -90, -153, 0, 0, 180, 27, 90, 153];

        private var mapDic:Dictionary;
        private var mapContainer:Sprite;
        private var showMap:Boolean = true;
        private var date:Date = null;
        private var timer:Timer;
        private var pathSprite:UISprite;
        private var map:Bitmap;
        private var animalDic:Dictionary;
        private var dataProxy:DataProxy;
        private var doFirst:Boolean = false;
        private var flag:Boolean = false;
        private var playerIcon:MovieClip;

        public function SmallMapMediator(){
   //         direction = [0, -27, -90, -153, 0, 0, 180, 27, 90, 153];
            timer = new Timer(1000);
            animalDic = new Dictionary();
            mapDic = new Dictionary();
            super(NAME, viewComponent);
        }
        protected function onSceneMapClickHandler(_arg1:MouseEvent):void{
            if (this.dataProxy.SenceMapIsOpen){
                this.sendNotification(EventList.CLOSESCENEMAP);
            } else {
                this.sendNotification(EventList.SHOWSENCEMAP);
            };
        }
        protected function showMailFlash():void{
            SmallMap.mcSmallElment.btns.btn_mail.mcFlash.play();
            SmallMap.mcSmallElment.btns.btn_mail.mcFlash.visible = true;
        }
        private function onQuickChargeClick(_arg1:MouseEvent):void{
            if (GameConfigData.GamePay != ""){
                navigateToURL(new URLRequest(GameConfigData.GamePay), "_blank");
            };
        }
        public function hideGmFlash():void{
            this.SmallMap.mcSmallElment.btns.btn_gm.mcFlash.stop();
            this.SmallMap.mcSmallElment.btns.btn_gm.mcFlash.visible = false;
        }
        protected function drawPath():void{
            var _local1:Array;
            var _local2:Number;
            var _local3:uint;
            var _local4:uint;
            if (flag){
                _local1 = GameCommonData.Player.PathMap;
                this.mapContainer.addChild(this.pathSprite);
                if (_local1 == null){
                    return;
                };
                this.pathSprite.graphics.clear();
                this.pathSprite.graphics.beginFill(0xFF0000, 1);
                _local2 = GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
                _local3 = _local1.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    pathSprite.graphics.drawCircle((_local1[_local4].x * _local2), (_local1[_local4].y * _local2), 1);
                    _local4++;
                };
                this.pathSprite.graphics.endFill();
            };
        }
        protected function onGMHandler(_arg1:MouseEvent):void{
            if (((!((GameConfigData.GMUrl == null))) && (!((GameConfigData.GMUrl == ""))))){
                navigateToURL(new URLRequest(GameConfigData.GMUrl), "_blank");
                hideGmFlash();
                return;
            };
            if (dataProxy.HelpIsOpen){
                facade.sendNotification(EventList.CLOSE_HELP_UI);
            } else {
                if (((GameConfigData.GreenService) && ((GameCommonData.totalPayMoney >= GameCommonData.goldenAccountNeed)))){
                    facade.sendNotification(EventList.SHOW_HELP_UI, {toggleGreenService:true});
                } else {
                    facade.sendNotification(EventList.SHOW_HELP_UI);
                };
            };
            hideGmFlash();
        }
        protected function onClickRanKHandler(_arg1:MouseEvent):void{
            if (dataProxy.RankIsOpen){
                facade.sendNotification(EventList.CLOSE_RANK);
            } else {
                facade.sendNotification(EventList.SHOW_RANK);
            };
        }
        public function hideActivityFlash():void{
            this.SmallMap.mcSmallElment.btns.btn_activity.mcFlash.stop();
            this.SmallMap.mcSmallElment.btns.btn_activity.mcFlash.visible = false;
        }
        private function onChangeMap(_arg1:MouseEvent):void{
            showMap = !(showMap);
            SmallMap.mcSmallElment.visible = showMap;
        }
        protected function onBigMapClickHanler(_arg1:MouseEvent):void{
            sendNotification(EventList.SHOWBIGMAP);
        }
        private function onActivityClick(_arg1:MouseEvent):void{
            hideActivityFlash();
            if (dataProxy.ActivityViewIsOpen){
                facade.sendNotification(EventList.CLOSE_ACTIVITY);
            } else {
                facade.sendNotification(EventList.SHOW_ACTIVITY);
            };
        }
        private function removeAnimal(_arg1:uint):void{
            var _local2:MovieClip = (this.animalDic[_arg1] as MovieClip);
            if (((!((_local2 == null))) && (this.mapContainer.contains(_local2)))){
                delete this.animalDic[_arg1];
                this.mapContainer.removeChild(_local2);
            };
        }
        public function showActivityFlash():void{
            this.SmallMap.mcSmallElment.btns.btn_activity.mcFlash.play();
            this.SmallMap.mcSmallElment.btns.btn_activity.mcFlash.visible = true;
        }
        private function onTaskHandler(_arg1:MouseEvent):void{
            if (!dataProxy.TaskIsOpen){
                facade.sendNotification(EventList.SHOWONLY, "task");
                facade.sendNotification(EventList.SHOWTASKVIEW);
            } else {
                facade.sendNotification(EventList.CLOSETASKVIEW);
            };
        }
        private function changeMapPos():void{
            var _local3:Number;
            var _local1:Number = GameCommonData.GameInstance.GameScene.GetGameScene.x;
            var _local2:Number = GameCommonData.GameInstance.GameScene.GetGameScene.y;
            _local3 = GameCommonData.GameInstance.GameScene.GetGameScene.Scale;
            var _local4:Number = GameCommonData.GameInstance.GameScene.GetGameScene.MapHeight;
            var _local5:Number = GameCommonData.GameInstance.GameScene.GetGameScene.MapWidth;
            var _local6:Number = (1 / _local3);
            mapContainer.x = ((_local1 * _local3) + SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name][0]);
            mapContainer.y = ((_local2 * _local3) + SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name][1]);
            if (mapContainer.x > 26.4){
                mapContainer.x = 26.4;
            } else {
                if ((((mapContainer.x - 150) - SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name][2]) * _local6) < -(_local5)){
                    mapContainer.x = Math.floor((((-(_local5) * _local3) + 150) + SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name][4]));
                };
            };
            if (mapContainer.y > 0){
                mapContainer.y = 0;
            } else {
                if ((((mapContainer.y - 140) - SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name][3]) * _local6) <= -(_local4)){
                    mapContainer.y = Math.floor((((-(_local4) * _local3) + 140) + SmallConstData.getInstance().smallMapDic[GameCommonData.GameInstance.GameScene.GetGameScene.name][3]));
                };
            };
            SmallMap.txtCurPoint.text = ((GameCommonData.Player.Role.TileX + ",") + GameCommonData.Player.Role.TileY);
        }
        protected function onSmallClickHandler(_arg1:MouseEvent):void{
            if (GameCommonData.Player.IsAutomatism){
                return;
            };
            GameCommonData.isAutoPath = false;
            GameCommonData.IsMoveTargetAnimal = false;
            this.flag = true;
            GameCommonData.Scene.MapPlayerMove(new Point((this.mapContainer.mouseX / GameCommonData.GameInstance.GameScene.GetGameScene.Scale), (this.mapContainer.mouseY / GameCommonData.GameInstance.GameScene.GetGameScene.Scale)));
            GameCommonData.Player.MapPathUpdate = drawPath;
            PlayerController.EndAutomatism();
        }
        private function changeTeam():void{
            var _local1:*;
            var _local2:MovieClip;
            for (_local1 in GameCommonData.TeamPlayerListOld) {
                _local2 = this.animalDic[_local1];
                if (_local2 != null){
                    this.mapContainer.removeChild(_local2);
                    this.animalDic[_local1] = null;
                };
                this.updateAnimalPos(_local1);
            };
            _local1 = 0;
            for (_local1 in GameCommonData.TeamPlayerList) {
                _local2 = this.animalDic[_local1];
                if (_local2 != null){
                    this.mapContainer.removeChild(_local2);
                    this.animalDic[_local1] = null;
                };
                this.updateAnimalPos(_local1);
            };
        }
        private function onSoundClickHandler(_arg1:MouseEvent):void{
            if (SharedManager.getInstance().allowMusic == true){
                sendNotification(SetViewEvent.ALLSOUND_FORBID);
            } else {
                sendNotification(SetViewEvent.ALLSOUND_ALLOW);
            };
            this.SmallMap.mcSmallElment.btns.btn_sound.gotoAndStop(((SharedManager.getInstance().allowMusic == true)) ? 1 : 2);
        }
        private function addLis():void{
            SmallMap.mcSmallElment.btns.btn_fullMoney.addEventListener(MouseEvent.CLICK, onLinkButtonClickHandler);
            SmallMap.btnForbid.addEventListener(MouseEvent.CLICK, onLinkButtonClickHandler);
            SmallMap.txtForbid.mouseEnabled = false;
        }
        private function onEntrustHandler(_arg1:MouseEvent):void{
            if (!dataProxy.EntrustIsOpen){
                facade.sendNotification(EventList.SHOW_ENTRUST_UI);
            } else {
                facade.sendNotification(EventList.CLOSE_ENTRUST_UI);
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Object;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.SMALLMAP
                    });
                    this.SmallMap.mouseEnabled = false;
                    this.SmallMap.mcSmallElment.btns.mouseEnabled = false;
                    this.SmallMap.mcSmallElment.btns.smallMapTTT.mouseEnabled = false;
                    this.SmallMap.mcSmallElment.btns.smallMapTTT.mouseChildren = false;
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    SmallMap.x = (GameCommonData.GameInstance.ScreenWidth - 328);
                    SmallMap.y = 0;
                    GameCommonData.GameInstance.GameUI.addChild(SmallMap);
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    addLis();
                    initView();
                    break;
                case PlayerInfoComList.UPDATE_TEAM:
                    this.changeTeam();
                    break;
                case PlayerInfoComList.UPDATE_TEAM_SMALLMAP:
                    this.changeTeam();
                    break;
                case EventList.UPDATE_SMALLMAP_DATA:
                    _local2 = _arg1.getBody();
                    _local3 = _local2.type;
                    _local4 = _local2.id;
                    switch (_local3){
                        case 1:
                            this.changeMapPos();
                            break;
                        case 2:
                            this.updateAnimalPos(_local4);
                            break;
                        case 3:
                            this.addAnimal(_local4);
                            break;
                        case 4:
                            this.removeAnimal(_local4);
                            break;
                        case 5:
                            this.changePlayerPos();
                            break;
                        case 6:
                            this.changePlayerDirection();
                            break;
                        case 7:
                            this.changeSence();
                            break;
                    };
                    break;
                case EventList.UPDATE_SMALLMAP_PATH:
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
                case EventList.SHOW_SMALL_MAP:
                    if (!showMap){
                        onChangeMap(null);
                    };
                    break;
                case EventList.SHOW_TIME:
                    break;
                case EventList.RESIZE_STAGE:
                    SmallMap.x = (GameCommonData.GameInstance.ScreenWidth - 328);
                    SmallMap.y = 0;
                    break;
                case MailEvent.MAILMESSAGE:
                    showMailFlash();
                    break;
                case PlayerInfoComList.SCREEN_ALL_NAME:
                    SmallMap.txtForbid.text = String(_arg1.getBody());
                    break;
                case SetViewEvent.SETVIEW_ALLOWMUSIC:
                    this.SmallMap.mcSmallElment.btns.btn_sound.gotoAndStop(((SharedManager.getInstance().allowMusic == true)) ? 1 : 2);
                    break;
            };
        }
        private function onOffLineClick(_arg1:MouseEvent):void{
        }
        protected function onLinkButtonClickHandler(_arg1:MouseEvent):void{
            var _local2:URLRequest;
            if (_arg1.currentTarget === SmallMap.btnForbid){
                if (dataProxy.screenAll){
                    ScreenController.ScreenAll();
                    dataProxy.screenAll = false;
                    SmallMap.txtForbid.text = LanguageMgr.GetTranslation("显示玩家");
                } else {
                    ScreenController.ScreenNone();
                    dataProxy.screenAll = true;
                    SmallMap.txtForbid.text = LanguageMgr.GetTranslation("屏蔽玩家");
                };
                facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
            };
            if (_local2){
                navigateToURL(_local2);
            };
        }
        protected function onAutoPalyClickHandler(_arg1:MouseEvent):void{
            if (this.dataProxy.autoPlayIsOpen){
                sendNotification(AutoPlayEventList.HIDE_AUTOPLAY_UI);
                sendNotification(EventList.PLAY_SOUND_OPEN_PANEL);
            } else {
                sendNotification(AutoPlayEventList.SHOW_AUTOPLAY_UI);
            };
        }
        public function showGmFlash():void{
            this.SmallMap.mcSmallElment.btns.btn_gm.mcFlash.play();
            this.SmallMap.mcSmallElment.btns.btn_gm.mcFlash.visible = true;
        }
        private function changePlayerDirection():void{
            if (this.playerIcon == null){
                return;
            };
            this.playerIcon.rotation = this.direction[GameCommonData.Player.Role.Direction];
        }
        protected function hideMailFlash():void{
            SmallMap.mcSmallElment.btns.btn_mail.mcFlash.stop();
            SmallMap.mcSmallElment.btns.btn_mail.mcFlash.visible = false;
        }
        private function showAnimal(_arg1:Object):void{
            var _local2:MovieClip;
            if (!this.mapContainer){
                return;
            };
            clearInterval(_arg1.delayID);
            if (this.animalDic[_arg1.id] != null){
                this.removeAnimal(_arg1.id);
            };
            if (GameCommonData.SameSecnePlayerList == null){
                return;
            };
            var _local3:GameElementAnimal = (GameCommonData.SameSecnePlayerList[_arg1.id] as GameElementAnimal);
            if (_local3 == null){
                return;
            };
            if (_local3.Role.Type == GameRole.TYPE_PLAYER){
                if (_local3.Role.idTeam == 0){
                    _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GreenPoint");
                } else {
                    if (GameCommonData.Player.Role.idTeam == _local3.Role.idTeam){
                        _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BulePoint");
                    } else {
                        _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GreenPoint");
                    };
                };
            } else {
                if (_local3.Role.Type == GameRole.TYPE_ENEMY){
                    _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RedPoint");
                } else {
                    if (_local3.Role.Type == GameRole.TYPE_NPC){
                        _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("YellowPoint");
                    };
                };
            };
            if (_local2 == null){
                return;
            };
            this.animalDic[_arg1.id] = _local2;
            _local2.name = ("SMALLMAP_" + _local3.Role.Name);
            this.mapContainer.addChild(_local2);
            var _local4:Point = MapTileModel.GetTilePointToStage(_local3.Role.TileX, _local3.Role.TileY);
            _local2.x = (_local4.x * GameCommonData.GameInstance.GameScene.GetGameScene.Scale);
            _local2.y = (_local4.y * GameCommonData.GameInstance.GameScene.GetGameScene.Scale);
        }
        private function setMapPos():void{
            var _local1:uint;
            mapContainer = new Sprite();
            mapContainer.addChild(map);
            SmallMap.txtMapName.text = GameCommonData.GameInstance.GameScene.GetGameScene.MapName;
            mapContainer.addEventListener(MouseEvent.CLICK, onSmallClickHandler);
            mapContainer.addChild(this.playerIcon);
            this.changePlayerPos();
            this.changeMapPos();
            this.changePlayerDirection();
            pathSprite = new UISprite();
            pathSprite.width = map.width;
            pathSprite.height = map.height;
            (SmallMap.mcSmallElment as MovieClip).mouseEnabled = false;
            mapContainer.mask = SmallMap.mcSmallElment.mcMapMask;
            SmallMap.mcSmallElment.addChild(mapContainer);
            SmallMap.mcSmallElment.addChild(SmallMap.mcSmallElment.btns);
            var _local2:uint = SmallConstData.getInstance().mapItemDic[GameCommonData.GameInstance.GameScene.GetGameScene.name].id;
            GameCommonData.BigMapMaskLow = (GameCommonData.BigMapMaskLow | Math.pow(2, (_local2 - 1)));
            if (!this.doFirst){
                this.doFirst = true;
                return;
            };
            sendNotification(EventList.SEND_QUICKBAR_MSG);
            sendNotification(EventList.CLOSESCENEMAP);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE, EventList.UPDATE_SMALLMAP_DATA, EventList.UPDATE_SMALLMAP_PATH, EventList.SHOW_SMALL_MAP, EventList.SHOW_TIME, PlayerInfoComList.UPDATE_TEAM, PlayerInfoComList.UPDATE_TEAM_SMALLMAP, EventList.RESIZE_STAGE, PlayerInfoComList.SCREEN_ALL_NAME, MailEvent.MAILMESSAGE, SetViewEvent.SETVIEW_ALLOWMUSIC]);
        }
        private function updateTeamMemberPointById(_arg1:int):void{
            removeAnimal(_arg1);
            addAnimal(_arg1);
        }
        private function changePlayerPos():void{
            var _local4:int;
            var _local5:int;
            var _local6:Point;
            var _local7:Number;
            var _local8:Number;
            this.mapContainer.addChild(this.playerIcon);
            var _local1:GameScene = GameCommonData.GameInstance.GameScene.GetGameScene;
            this.playerIcon.x = (GameCommonData.Player.GameX * _local1.Scale);
            this.playerIcon.y = (GameCommonData.Player.GameY * _local1.Scale);
            var _local2:String = _local1.name;
            var _local3:Array = (SmallConstData.getInstance().smallMapDic[_local2] as Array);
            if ((((_local3[0] == -999)) && ((_local3[1] == -999)))){
                _local4 = 0;
                _local5 = 0;
                _local6 = MapTileModel.GetTilePointToStage(uint((_local1.Floor.Row / 2)), uint((_local1.Floor.Col / 2)));
                _local4 = ((GameCommonData.GameInstance.ScreenWidth / 2) - _local6.x);
                _local5 = ((GameCommonData.GameInstance.ScreenHeight / 2) - _local6.y);
                _local7 = (_local6.x * _local1.Scale);
                _local8 = (_local6.y * _local1.Scale);
                SmallConstData.getInstance().smallMapDic[_local2][0] = -((((_local7 + (_local4 * _local1.Scale)) - 62.5) - 26.4));
                SmallConstData.getInstance().smallMapDic[_local2][1] = -((((_local8 + (_local5 * _local1.Scale)) - 62.5) - 2));
            };
            if (this.playerIcon.x < 26.4){
                this.playerIcon.x = 26.4;
            };
            if (_local3[6] == true){
                if (this.playerIcon.x > _local3[7]){
                    this.playerIcon.x = _local3[7];
                };
            };
        }
        private function initView():void{
            (this.SmallMap.mcSmallElment.btns.btn_rank as SimpleButton).addEventListener(MouseEvent.CLICK, onClickRanKHandler);
            (this.SmallMap.mcSmallElment.btns.btn_sceneMap as SimpleButton).addEventListener(MouseEvent.CLICK, onSceneMapClickHandler);
            this.SmallMap.mcSmallElment.btns.btn_mail.mcFlash.mouseEnabled = false;
            this.SmallMap.mcSmallElment.btns.btn_mail.mcFlash.mouseChildren = false;
            hideMailFlash();
            this.SmallMap.mcSmallElment.btns.btn_mail.addEventListener(MouseEvent.CLICK, onMailClickHandler);
            this.SmallMap.mcSmallElment.btns.btn_gm.addEventListener(MouseEvent.CLICK, onGMHandler);
            this.SmallMap.mcSmallElment.btns.btn_gm.mcFlash.mouseEnabled = false;
            this.SmallMap.mcSmallElment.btns.btn_gm.mcFlash.mouseChildren = false;
            hideGmFlash();
            if (GameCommonData.ModuleCloseConfig[5] == 1){
                this.SmallMap.mcSmallElment.btns.btn_help.visible = false;
            };
            (this.SmallMap.mcSmallElment.btns.btn_help as SimpleButton).addEventListener(MouseEvent.CLICK, onHelpHandler);
            (this.SmallMap.mcSmallElment.btns.btn_fullMoney as SimpleButton).addEventListener(MouseEvent.CLICK, onQuickChargeClick);
            (this.SmallMap.mcSmallElment.btns.btn_task as SimpleButton).addEventListener(MouseEvent.CLICK, onTaskHandler);
            if (GameCommonData.ModuleCloseConfig[11] == 1){
                this.SmallMap.mcSmallElment.btns.btn_entrust.visible = false;
            };
            (this.SmallMap.mcSmallElment.btns.btn_entrust as SimpleButton).addEventListener(MouseEvent.CLICK, onEntrustHandler);
            timer.start();
            this.playerIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SelfPos");
            this.SmallMap.mcSmallElment.btns.btn_sound.gotoAndStop(((SharedManager.getInstance().allowMusic == true)) ? 1 : 2);
            SmallMap.mcSmallElment.btns.btn_sound.buttonMode = true;
            SmallMap.mcSmallElment.btns.btn_sound.addEventListener(MouseEvent.CLICK, onSoundClickHandler);
            this.SmallMap.mcSmallElment.btns.btn_activity.addEventListener(MouseEvent.CLICK, onActivityClick);
            this.SmallMap.mcSmallElment.btns.btn_activity.mcFlash.mouseEnabled = false;
            this.SmallMap.mcSmallElment.btns.btn_activity.mcFlash.mouseChildren = false;
            hideActivityFlash();
        }
        private function changeSence():void{
            this.animalDic = new Dictionary();
            if (this.mapContainer){
                while (mapContainer.numChildren > 0) {
                    mapContainer.removeChildAt(0);
                };
                mapContainer.removeEventListener(MouseEvent.CLICK, onSmallClickHandler);
                SmallMap.mcSmallElment.removeChild(mapContainer);
                mapContainer = null;
            };
            this.playerIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SelfPos");
            this.map = GameCommonData.GameInstance.GameScene.GetGameScene.RealSmallMap;
            this.setMapPos();
        }
        private function updateAnimalPos(_arg1:uint):void{
            var _local2:GameElementAnimal;
            var _local3:MovieClip;
            if (GameCommonData.SameSecnePlayerList != null){
                _local2 = (GameCommonData.SameSecnePlayerList[_arg1] as GameElementAnimal);
                _local3 = (this.animalDic[_arg1] as MovieClip);
                if (((((!((_local2 == null))) && ((_local3 == null)))) && ((_local2.Role.Type == GameRole.TYPE_PLAYER)))){
                    if (_local2.Role.idTeam == 0){
                        _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GreenPoint");
                    } else {
                        if (GameCommonData.Player.Role.idTeam == _local2.Role.idTeam){
                            _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BulePoint");
                        } else {
                            _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GreenPoint");
                        };
                    };
                    this.mapContainer.addChild(_local3);
                    this.animalDic[_arg1] = _local3;
                    _local3.name = ("SMALLMAP_" + _local2.Role.Name);
                };
            };
            if ((((_local2 == null)) || ((_local3 == null)))){
                return;
            };
            var _local4:Point = MapTileModel.GetTilePointToStage(_local2.Role.TileX, _local2.Role.TileY);
            _local3.x = (_local4.x * GameCommonData.GameInstance.GameScene.GetGameScene.Scale);
            _local3.y = (_local4.y * GameCommonData.GameInstance.GameScene.GetGameScene.Scale);
        }
        protected function onHelpHandler(_arg1:MouseEvent):void{
            if (GameCommonData.ModuleCloseConfig[5] == 1){
                return;
            };
            if (dataProxy.GoldLeafViewIsOpen){
                facade.sendNotification(EventList.CLOSE_GOLDLEAFVIEW);
            } else {
                facade.sendNotification(EventList.SHOW_GOLDLEAFVIEW);
            };
        }
        private function get SmallMap():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        protected function onMailClickHandler(_arg1:MouseEvent):void{
            if (this.dataProxy.MailIsOpen){
                this.sendNotification(EventList.CLOSEMAIL);
            } else {
                this.sendNotification(EventList.SHOWMAIL);
                hideMailFlash();
            };
        }
        protected function onPkClickHandler(_arg1:MouseEvent):void{
            sendNotification(EventList.SHOWPKVIEW);
            _arg1.stopPropagation();
        }
        private function addAnimal(_arg1:uint):void{
            var _local2:Object = new Object();
            _local2.id = _arg1;
            _local2.delayID = setInterval(showAnimal, 20, _local2);
        }

    }
}//package GameUI.Modules.Map.SmallMap.Mediator 
