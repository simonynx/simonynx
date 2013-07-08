//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement.Person {
    import GameUI.UICore.*;
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import OopsEngine.Scene.StrategyElement.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import OopsFramework.Utils.*;
    import OopsEngine.Graphics.Treasure.*;
    import OopsEngine.AI.PathFinder.*;
    import GameUI.Modules.Transcript.Data.*;
    import Net.RequestSend.*;
    import GameUI.Modules.RoleProperty.Datas.*;

	/**
	 *游戏玩家显示对象 
	 * @author wengliqiang
	 * 
	 */	
    public class GameElementPlayer extends GameElementAnimal {

        private var _currentTreasure:Treasure;
        private var pkTimer:OopsFramework.Utils.Timer;
        private var pathDirArray:Array;
        public var PathMap:Array;
        private var _IsAutomatism:Boolean = false;
        public var IsRushing:Boolean = false;
        public var prepPoint:Point;
        private var pathFinder:PathFinder;
        public var Automatism:Function;
        private var endPoint:Point;
        private var isAStarMoving:Boolean = false;

        public function GameElementPlayer(_arg1:Game){
            pkTimer = new OopsFramework.Utils.Timer();
            pkTimer.DistanceTime = 2000;
            super(_arg1, new GameElementPlayerSkin(this));
        }
        override protected function onChangeEquip(_arg1:String):void{
            var _local2:String = _arg1;
            if (_local2 == GameElementSkins.EQUIP_MOUNT){
                doTopTitlePos();
            };
        }
        override protected function onMoveStep():void{
            var _local1:int;
            super.onMoveStep();
            if ((((this.Role.ConvoyFlag > 0)) && (this.Role.ConvoyCarAnimal))){
                this.Role.ConvoyCarAnimal.onConvoyCarMoveToMaster();
            };
            if (((this.Role.UsingPetAnimal) && (!(this.Role.UsingPetAnimal.Role.IsBattling)))){
                _local1 = MapTileModel.Distance(this.Role.TileX, this.Role.TileY, this.Role.UsingPetAnimal.Role.TileX, this.Role.UsingPetAnimal.Role.TileY);
                if (_local1 > 15){
                    this.Role.UsingPetAnimal.ToMasterMove();
                };
            };
        }
        public function afterAttackMove():void{
            if (this.Role.MountSkinID != 0){
                return;
            };
            if (this.Role.PersonSkinID == 101){
                return;
            };
            if (this.Role.IsAttack){
                setTimeout(afterAttackMove, 5500);
                return;
            };
            var _local1:int = int(GameCommonData.GameInstance.GameScene.GetGameScene.name);
            if ((((((_local1 >= 2000)) && ((_local1 <= 5001)))) || (MapManager.isInParty()))){
                return;
            };
            BagInfoSend.ItemUse((RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT] as InventoryItemInfo).ItemGUID);
        }
        public function get Path():Array{
            return (this.smoothMove.getPath());
        }
        public function set IsAutomatism(_arg1:Boolean):void{
            _IsAutomatism = _arg1;
            if (((_IsAutomatism) || (AutoFbManager.IsAutoFbing))){
                SpeciallyEffectController.getInstance().showAutoMc(1);
            } else {
                SpeciallyEffectController.getInstance().showAutoMc(0);
            };
        }
        override public function RemoveSkin(_arg1:String):void{
            this.skins.RemovePersonSkin(_arg1);
        }
        public function get IsAutomatism():Boolean{
            return (_IsAutomatism);
        }
        override public function Dispose():void{
            super.Dispose();
            SetParentScene(null);
        }
        override public function onBodyLoadComplete():void{
            super.onBodyLoadComplete();
            if (this.Role.IsMediation){
                this.Role.IsMediation = true;
            };
        }
        public function set CurrentTreasure(_arg1:Treasure):void{
            if (((_currentTreasure) && (this.contains(_currentTreasure)))){
                _currentTreasure.dispose();
                _currentTreasure = null;
            };
            if (_arg1 != null){
                if (((MapManager.IsInArena()) || (MapManager.isInParty()))){
                } else {
                    this._currentTreasure = _arg1;
                    this.addChild(this._currentTreasure);
                };
            };
        }
        override public function Move(_arg1:Point, _arg2:int=0):void{
            if (this.gameScene == null){
                return;
            };
            this.targetPoint = _arg1;
            this.endPoint = MapTileModel.GetTileStageToPoint(this.targetPoint.x, this.targetPoint.y);
            this.AStarMove(_arg2);
            if (RolePropDatas.ItemList[ItemConst.EQUIPMENT_SLOT_MOUNT]){
                if (((((Math.abs((endPoint.x - this.Role.TileX)) * 60) > GameCommonData.GameInstance.ScreenWidth)) || (((Math.abs((endPoint.y - this.Role.TileY)) * 30) > GameCommonData.GameInstance.ScreenHeight)))){
                    afterAttackMove();
                };
            };
        }
        private function transmit():void{
            var _local1:XML;
            var _local2:XML;
            _local1 = GameCommonData.GameInstance.GameScene.GetGameScene.ConfigXml;
            for each (_local2 in _local1.Element) {
                if ((((this.Role.TileX == _local2.@X)) && ((this.Role.TileY == _local2.@Y)))){
                    if (((!((GameCommonData.MapConfigs[(int(_local2.@To) % 10000)].SmallMapSetting.@LevelNeed == null))) && ((GameCommonData.Player.Role.Level < GameCommonData.MapConfigs[(int(_local2.@To) % 10000)].SmallMapSetting.@LevelNeed)))){
                        MessageTip.popup(LanguageMgr.GetTranslation("场景到x级才可进句", GameCommonData.MapConfigs[(int(_local2.@To) % 10000)].SmallMapSetting.@LevelNeed));
                    } else {
                        if ((((((GameCommonData.Player.Role.Level >= 30)) && (MapManager.canAllowPKScene((int(_local2.@To) % 10000))))) && (!(SharedManager.getInstance().enterPKSceneTips)))){
                            UIFacade.GetInstance().showPksceneTips(this.Role.TileX, this.Role.TileY);
                        } else {
                            if ((((int(_local2.@To) == 1015)) && ((GameCommonData.ModuleCloseConfig[10] == 1)))){
                                return;
                            };
                            PlayerActionSend.trainmitChange(this.Role.TileX, this.Role.TileY, 0);
                        };
                    };
                };
            };
            if (MapManager.IsInTower()){
                if ((((this.Role.TileX == TowerInfo.HoleX)) && ((this.Role.TileY == TowerInfo.HoleY)))){
                    UIFacade.GetInstance().sendNotification(TranscriptEvent.GO_NEXT_TOWER);
                    TowerInfo.HoleX = -1;
                    TowerInfo.HoleY = -1;
                };
            };
        }
        override public function AllDispose():void{
            CurrentTreasure = null;
            super.AllDispose();
        }
        override public function SetSkin(_arg1:String, _arg2:String):void{
            switch (_arg1){
                case GameElementSkins.EQUIP_PERSON:
                    GameElementPlayerSkin(this.skins).ChangePerson(true);
                    break;
                case GameElementSkins.EQUIP_WEAOIB:
                    GameElementPlayerSkin(this.skins).ChangeWeapon(true);
                    break;
                case GameElementSkins.EQUIP_MOUNT:
                    GameElementPlayerSkin(this.skins).ChangeMount(true);
                    break;
                case GameElementSkins.EQUIP_PERSON_MOUNT:
                    GameElementPlayerSkin(this.skins).ChangePerson_Mount(true);
                    break;
                case GameElementSkins.EQUIP_WEAPONE_EFFECT:
                    GameElementPlayerSkin(this.skins).ChangeWeaponEffect(true);
                    break;
            };
        }
        override public function SetParentScene(_arg1:GameScene):void{
            super.SetParentScene(_arg1);
            if (_arg1 != null){
                this.pathFinder = new PathFinder(this.gameScene.Map.Map);
            } else {
                this.pathFinder = null;
            };
        }
        override public function Update(_arg1:GameTime):void{
            super.Update(_arg1);
            if (this.skins != null){
                if (((!((this.Automatism == null))) && (((this.IsAutomatism) || (AutoFbManager.IsAutoFbing))))){
                    Automatism();
                };
            };
            if (_currentTreasure){
                _currentTreasure.Update(_arg1);
            };
        }
        override public function Stop():void{
            this.pathDirArray = null;
            this.isAStarMoving = false;
            if (this.Role.MountSkinID != 0){
                this.SetAction(GameElementSkins.ACTION_MOUNT_STATIC);
            } else {
                if (this.Role.IsMediation){
                    this.SetAction(GameElementSkins.ACTION_MEDITATION);
                } else {
                    this.SetAction(GameElementSkins.ACTION_STATIC);
                };
            };
            if (this.Role.UsingPetAnimal != null){
                this.prepPoint = new Point(this.Role.TileX, this.Role.TileY);
            };
            super.Stop();
        }
        public function set PathDirection(_arg1:Array):void{
            if (_arg1 == null){
                this.pathDirArray = _arg1;
            };
        }
        override protected function onMoveComplete():void{
            super.onMoveComplete();
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))) && (!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                this.Stop();
                this.PathMap = null;
                if (this == GameCommonData.Player){
                    this.transmit();
                };
            };
            if (MoveComplete != null){
                MoveComplete();
            };
        }
        override protected function onMoveNode(_arg1:int):Boolean{
            super.onMoveNode(_arg1);
            var _local2:Boolean;
            if (((!((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK))) && (!((this.Role.ActionState == GameElementSkins.ACTION_DEAD))))){
                this.Role.Direction = _arg1;
                if (this.Role.MountSkinID != 0){
                    this.SetAction(GameElementSkins.ACTION_MOUNT_RUN, this.Role.Direction);
                } else {
                    this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);
                };
            };
            if (((((this.Role.UsingPetAnimal) && (!(this.Role.UsingPetAnimal.IsMoving)))) && (!(this.Role.UsingPetAnimal.Role.IsBattling)))){
                if (((((this.Role.UsingPetAnimal.PetMovePath) && ((this.Role.UsingPetAnimal.PetMovePath.length > 3)))) && (!(DistanceController.Distance(new Point(this.Role.TileX, this.Role.TileY), new Point(this.Role.UsingPetAnimal.Role.TileX, this.Role.UsingPetAnimal.Role.TileY), 3))))){
                    this.Role.UsingPetAnimal.MoveAStar(this.Role.UsingPetAnimal.PetMovePath);
                };
            };
            if (MoveNode != null){
                _local2 = MoveNode(_arg1);
            };
            return (_local2);
        }
        public function get PathDirection():Array{
            return (this.pathDirArray);
        }
        private function AStarMove(_arg1:int=0):void{
            var _local3:Point;
            var _local4:Point;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:Point;
            var _local9:int;
            var _local15:Point;
            var _local16:Array;
            var _local2:int = getTimer();
            this.isAStarMoving = true;
            var _local10:Point = new Point(this.Role.TileX, this.Role.TileY);
            this.pathDirArray = new Array();
            var _local11:Array = new Array();
            PathMap = new Array();
            var _local12:Array = this.pathFinder.findpath(_local10.x, _local10.y, this.endPoint.x, this.endPoint.y);
            var _local13:Array = new Array();
            if ((((((((((this.Role.Type == GameRole.TYPE_OWNER)) || ((this.Role.Type == GameRole.TYPE_PLAYER)))) && (this.Role.UsingPetAnimal))) && (this.Role.UsingPetAnimal.isWalk))) && (!(this.Role.UsingPetAnimal.Role.IsBattling)))){
                _local3 = new Point(this.Role.TileX, this.Role.TileY);
                _local4 = new Point(this.Role.UsingPetAnimal.Role.TileX, this.Role.UsingPetAnimal.Role.TileY);
                if (((((((_local3) && (!((_local3.x == 0))))) && (!((_local3.y == 0))))) && ((this == GameCommonData.Player)))){
                    _local13 = this.Role.UsingPetAnimal.pathFinder.findpath(_local4.x, _local4.y, _local3.x, _local3.y);
                    if (_local13 == null){
                        _local13 = [];
                    };
                } else {
                    _local13.push(new Point(_local4.x, _local4.y));
                };
            };
            if (((_local12) && ((_local12.length > 1)))){
                _local5 = 1;
                while (_local5 <= _arg1) {
                    if (_local12.length > 0){
                        _local12.pop();
                    };
                    _local5++;
                };
                if (_local12.length > 1){
                    prepPoint = new Point(_local12[(_local12.length - 1)].x, _local12[(_local12.length - 1)].y);
                    _local6 = 1;
                    while (_local6 < _local12.length) {
                        _local7 = MapTileModel.Direction(_local12[(_local6 - 1)].x, _local12[(_local6 - 1)].y, _local12[_local6].x, _local12[_local6].y);
                        this.pathDirArray.push(_local7);
                        _local8 = MapTileModel.GetTilePointToStage(_local12[_local6].x, _local12[_local6].y);
                        if ((((((((((this.Role.Type == GameRole.TYPE_OWNER)) || ((this.Role.Type == GameRole.TYPE_PLAYER)))) && (this.Role.UsingPetAnimal))) && (this.Role.UsingPetAnimal.isWalk))) && (!(this.Role.UsingPetAnimal.Role.IsBattling)))){
                            if (_local6 < (_local12.length - 5)){
                                _local13.push(new Point(_local12[_local6].x, _local12[_local6].y));
                            };
                        };
                        _local11.push(_local8.add(new Point(-(this.excursionX), -(this.excursionY))));
                        this.PathMap.push(_local8.clone());
                        _local6++;
                    };
                    if (MapPathUpdate != null){
                        MapPathUpdate();
                    };
                    if (SMapPathUpdate != null){
                        SMapPathUpdate();
                    };
                    if (this.smoothMove.IsMoving){
                        _local9 = 0;
                        while (_local9 < _local11.length) {
                            this.smoothMove.AddPath((_local11[_local9] as Point));
                            _local9++;
                        };
                    } else {
                        this.smoothMove.Move(_local11);
                    };
                    if ((((((((this.Role.Type == GameRole.TYPE_OWNER)) || ((this.Role.Type == GameRole.TYPE_PLAYER)))) && (this.Role.UsingPetAnimal))) && (this.Role.UsingPetAnimal.isWalk))){
                        if (this.Role.UsingPetAnimal.isWalk){
                            if ((((((this.Role.Type == GameRole.TYPE_OWNER)) && (!(this.Role.IsAttack)))) || (!(this.Role.UsingPetAnimal.Role.IsBattling)))){
                                if (((((_local13) && ((_local13.length > 0)))) && (pathDirArray))){
                                    _local15 = GameElementPet.GetPetPoint(_local12[(_local12.length - 1)], this.pathDirArray[(pathDirArray.length - 1)], new Point(_local13[(_local13.length - 1)].x, _local13[(_local13.length - 1)].y));
                                    if (((((_local15) && (!((_local15.x == 0))))) && (!((_local15.y == 0))))){
                                        _local16 = this.Role.UsingPetAnimal.pathFinder.findpath(_local13[(_local13.length - 1)].x, _local13[(_local13.length - 1)].y, _local15.x, _local15.y);
                                        if (((_local16) && ((_local16.length > 1)))){
                                            _local16.shift();
                                            _local13 = _local13.concat(_local16);
                                        };
                                    };
                                    if (this.Role.UsingPetAnimal.Role.ActionState == GameElementSkins.ACTION_RUN){
                                        this.Role.UsingPetAnimal.MoveAStar(_local13);
                                    } else {
                                        if ((((_local13.length > 2)) && (!(DistanceController.Distance(_local12[0], new Point(this.Role.UsingPetAnimal.Role.TileX, this.Role.UsingPetAnimal.Role.TileY), 2))))){
                                            this.Role.UsingPetAnimal.MoveAStar(_local13);
                                        } else {
                                            this.Role.UsingPetAnimal.PetMovePath = _local13;
                                            this.Role.UsingPetAnimal.SetDirection(this.Role.Direction);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            } else {
                this.Stop();
            };
            var _local14:int = (getTimer() - _local2);
        }
        override public function MoveTile(_arg1:Point, _arg2:int=0):void{
            this.endPoint = _arg1;
            this.AStarMove(_arg2);
        }

    }
}//package OopsEngine.Scene.StrategyElement.Person 
