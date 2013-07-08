//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene.StrategyElement {
    import flash.events.*;
    import flash.display.*;
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import OopsEngine.Role.*;
    import OopsEngine.Scene.*;
    import flash.geom.*;
    import OopsEngine.Graphics.Animation.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import OopsEngine.Utils.*;
    import OopsEngine.Scene.StrategyElement.Person.*;
    import GameUI.Modules.ScreenMessage.View.*;
    import OopsEngine.AI.PathFinder.*;
    import OopsEngine.*;
    import OopsEngine.Graphics.*;

	/**
	 *有动作的游戏对象 
	 * @author wengliqiang
	 * 
	 */	
    public class GameElementAnimal extends GameElement {

        protected var personTitle:TextField;
        public var isUpdateEffect:Boolean;
        private var paopaoView:AnimalDialogue;
        public var ActionPlayComplete:Function;
        public var showContainer:Sprite;
        protected var previousDepth:Number = 0;
        private var isActionPlaying:Boolean = true;
        protected var missionPrompt:Sprite;
        protected var golemSprite:Sprite;
        public var PetDistance:Function;
        public var PlayerGap:int;
        protected var _isDispose:Boolean = false;
        private var vipicon:Bitmap;
        public var isUseMount:Boolean = false;
        public var IsLoadSkins:Boolean = false;
        public var shadow:Bitmap;
        private var elementWidth:int = 132;
        public var golem:Bitmap;
        public var isUpdateBlood:Boolean = true;
        public var skillAnimation:Array;
        public var SMapPathUpdate:Function;
        protected var smallBlood:MovieClip;
        protected var playerStall:Bitmap;
        public var _gameScene:GameScene;
        private var stateEffectList:Dictionary;
        protected var personGuildName:TextField;
        public var handler:Handler;
        public var MoveComplete:Function;
        private var textFieldHeight:int = 20;
        private var isInitialize:Boolean = false;
        public var MoveStep:Function;
        protected var ispooled:Boolean = false;
        public var IsStall:Boolean = false;
        public var MouseOutTarger:Function;
        private var _offsetHeight:int;
        protected var targetPoint:Point;
        protected var personName:TextField;
        public var MountHeight:int;
        private var stateEffectLoad:Dictionary;
        public var MoveNode:Function;
        public var Role:GameRole;
        public var UpdateSkillEffect:Function;
        public var skins:GameElementSkins;
        protected var smoothMove:SmoothMove;
        public var ChooseTarger:Function;
        public var MapPathUpdate:Function;
        public var OnChangeSkin:Function;
        protected var teamLeaderSign:Bitmap;
        public var Offset:Point;
        protected var teamMemberSign:Bitmap;
        protected var currentDepth:Number = 0;
        public var EffectOffect:Point;
        public var ActionPlayFrame:Function;
        public var MouseOverTarger:Function;
        public var MountOffset:Point;

        public function GameElementAnimal(_arg1:Game, _arg2:GameElementSkins){
            golemSprite = new Sprite();
            skillAnimation = [];
            stateEffectList = new Dictionary();
            stateEffectLoad = new Dictionary();
            super(_arg1);
            this.skins = _arg2;
            if (this.skins != null){
                this.skins.ActionPlayComplete = onActionPlayComplete;
                this.skins.ActionPlayFrame = onActionPlayFrame;
                this.skins.BodyLoadComplete = onBodyLoadComplete;
                this.skins.MouseOutTarger = onMouseOutTarger;
                this.skins.MouseOverTarger = onMouseOverTarger;
                this.skins.SkinLoadComplete = onSkinLoadComplete;
            };
            this.mouseChildren = true;
            this.golemSprite.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.golemSprite.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.golemSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
        protected function onChangeEquip(_arg1:String):void{
        }
        private function onMouseOver(_arg1:MouseEvent):void{
            if (this.golem != null){
                this.golemSprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            };
        }
        private function onMissMouseOut(_arg1:MouseEvent):void{
            onMouseOutTarger();
            this.skins.DeleteHighlight();
        }
        private function onMouseOutTarger():void{
            if (MouseOutTarger != null){
                MouseOutTarger(this);
            };
        }
        public function PlayerStall():void{
            if ((((((this.Role.Type == GameRole.TYPE_PLAYER)) || ((this.Role.Type == GameRole.TYPE_OWNER)))) && (!((this.Role.isStalling == 0))))){
                if ((((this.playerStall == null)) && ((this.IsStall == false)))){
                    this.IsStall = true;
                    this.playerStall = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("PlayerStall");
                    this.playerStall.name = "PlayerStall";
                    this.playerStall.x = ((this.elementWidth - this.playerStall.width) / 2);
                    if (this.personName.visible == false){
                        this.playerStall.y = 0;
                    } else {
                        this.playerStall.y = 0;
                    };
                    this.addChild(this.playerStall);
                    if (((!((this.skins == null))) && (this.contains(this.skins)))){
                        this.removeChild(this.skins);
                    };
                    if (((!((this.shadow == null))) && (this.contains(this.shadow)))){
                        this.removeChild(this.shadow);
                    };
                    if (GameCommonData.Player.Role.Id == this.Role.Id){
                        this.mouseEnabled = true;
                        this.mouseChildren = true;
                    };
                };
            } else {
                if (this.IsStall){
                    this.IsStall = false;
                    this.removeChild(this.playerStall);
                    this.playerStall = null;
                    if (((this.shadow) && (this.skins))){
                        this.addChildAt(this.shadow, 0);
                        this.addChildAt(this.skins, 1);
                    } else {
                        this.ShowSkin();
                    };
                    if (GameCommonData.Player.Role.Id == this.Role.Id){
                        this.mouseEnabled = false;
                        this.mouseChildren = false;
                    };
                };
            };
        }
        private function onActionPlayFrame(_arg1:AnimationEventArgs):void{
            if (ActionPlayFrame != null){
                _arg1.Sender = this;
                ActionPlayFrame(_arg1);
            };
        }
        public function HideName():void{
            this.personName.visible = false;
            doTopTitlePos();
        }
        private function onMouseOverTarger():void{
            if (MouseOverTarger != null){
                MouseOverTarger(this);
            };
        }
        public function reSet(_arg1:Array):void{
            IsLoadSkins = false;
            skillAnimation = [];
            stateEffectList = new Dictionary();
            stateEffectLoad = new Dictionary();
            elementWidth = 132;
            golemSprite = new Sprite();
            this.golemSprite.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.golemSprite.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.golemSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.golem = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("Golem");
            this.golem.x = ((this.elementWidth - this.golem.width) / 2);
            this.golem.y = 40;
            this.golemSprite.addChild(this.golem);
            this.addChild(this.golemSprite);
        }
        public function SetAction(_arg1:String, _arg2:int=0):void{
            if (isDispose){
                return;
            };
            if (this.Role.MountSkinID != 0){
                if (_arg1 == GameElementSkins.ACTION_STATIC){
                    SetAction(GameElementSkins.ACTION_MOUNT_STATIC, _arg2);
                    return;
                };
                if (_arg1 == GameElementSkins.ACTION_RUN){
                    SetAction(GameElementSkins.ACTION_MOUNT_RUN, _arg2);
                    return;
                };
            };
            if (_arg2 != 0){
                this.Role.Direction = _arg2;
            };
            this.Role.ActionState = _arg1;
            if (this.skins != null){
                this.skins.ChangeAction(this.Role.ActionState);
            };
            this.isActionPlaying = true;
            if (this.shadow != null){
                if (_arg1 != GameElementSkins.ACTION_DEAD){
                    this.shadow.visible = true;
                } else {
                    this.shadow.visible = false;
                };
            };
        }
        public function SetTitle(_arg1:String):void{
            var _local2:TextFormat;
            if (this.Role.Title != null){
                this.Role.Title = _arg1;
            };
            if (((((this.personTitle) && (this.personTitle.text))) && (_arg1))){
                _local2 = personTitle.defaultTextFormat;
                _local2.color = this.Role.TitleColor;
                personTitle.defaultTextFormat = _local2;
                this.personTitle.text = _arg1;
            };
        }
        public function onBodyLoadComplete():void{
            if (this.golem != null){
                this.golemSprite.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
                this.golemSprite.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                this.golemSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                this.removeChild(this.golemSprite);
                this.golem = null;
                this.golemSprite = null;
                this.mouseEnabled = false;
            };
            if (this.skins != null){
                createShadow();
                if (!(this is GameElementPet)){
                    if (this.Role.HP == 0){
                        if (this.Role.Type == GameRole.TYPE_OWNER){
                            this.skins.InitActionDead(2);
                        } else {
                            if (this.Role.Type == GameRole.TYPE_PLAYER){
                                this.skins.InitActionDead(2);
                            } else {
                                if (this.Role.Type == GameRole.TYPE_ENEMY){
                                    this.skins.InitActionDead(0);
                                };
                            };
                        };
                    };
                };
                if (this.Role.HP > 0){
                    if (this.Role.MountSkinID != 0){
                        this.skins.ChangeAction(GameElementSkins.ACTION_MOUNT_STATIC, true);
                    } else {
                        if (this.Role.IsMediation){
                            this.skins.ChangeAction(GameElementSkins.ACTION_MEDITATION, true);
                        } else {
                            this.skins.ChangeAction(GameElementSkins.ACTION_STATIC, true);
                        };
                    };
                    doTopTitlePos();
                };
                if (this.Offset != null){
                    this.skins.x = (this.Offset.x - 95);
                    this.skins.y = (this.Offset.y + this.OffsetHeight);
                };
                EffectOffect = new Point((this.shadow.x - 15), (this.shadow.y - 12));
                this.addChildAt(this.skins, 1);
                setEffectVisible();
                if (this.missionPrompt != null){
                    this.removeChild(this.missionPrompt);
                    removeMissevent();
                    this.missionPrompt = null;
                };
                this.excursionX = (this.elementWidth / 2);
                this.excursionY = (this.shadow.y + 30);
                this.SetPosition();
                this.SetMissionPrompt(this.Role.MissionState);
            };
            this.IsLoadSkins = true;
        }
        protected function onMoveStep():void{
            if (MoveStep != null){
                MoveStep(this);
            };
        }
        private function Translucence():void{
            var _local1:Point = MapTileModel.GetTileStageToPoint(this.GameX, this.GameY);
            if (((((this.gameScene) && (this.gameScene.Map))) && ((this.gameScene.Map.IsBlock(0, 0, _local1.x, _local1.y) == MapTileModel.PATH_TRANSLUCENCE)))){
                this.alpha = 0.5;
            } else {
                this.alpha = 1;
            };
        }
        private function ShowSkin():void{
            this.golem = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("Golem");
            this.golem.x = ((this.elementWidth - this.golem.width) / 2);
            this.golem.y = 40;
            this.golemSprite.addChild(this.golem);
            this.addChild(this.golemSprite);
            this.skins.ChangeEquip = onChangeEquip;
            this.skins.ChooseTarger = ChooseTarger;
            this.skins.LoadSkin();
        }
        public function HideTitle():void{
            this.personTitle.visible = false;
            doTopTitlePos();
        }
        public function get HitX():Number{
            return (GameX);
        }
        public function RemoveSkin(_arg1:String):void{
        }
        public function get HitY():Number{
            if (this.Role.MountSkinName != null){
                return (((GameY - ((Math.abs((this.excursionY - this.MountHeight)) * 2) / 5)) - this.MountHeight));
            };
            return ((GameY - ((Math.abs(this.excursionY) * 2) / 5)));
        }
        private function onActionPlayComplete(_arg1:AnimationEventArgs):void{
            if ((((this.Role.ActionState.indexOf(GameElementSkins.ACTION_RUN) == -1)) && ((this.Role.ActionState.indexOf(GameElementSkins.ACTION_STATIC) == -1)))){
                this.isActionPlaying = false;
            };
            if ((((this.Role.ActionState == GameElementSkins.ACTION_NEAR_ATTACK)) || ((this.Role.ActionState == GameElementSkins.ACTION_AFTER)))){
                this.SetAction(GameElementSkins.ACTION_STATIC);
            };
            if (this.Role.ActionState == GameElementSkins.ACTION_DEAD){
                if (this.Role.Type != GameRole.TYPE_PLAYER){
                    this.mouseChildren = false;
                } else {
                    this.mouseChildren = true;
                };
                if (this.Role.Type == GameRole.TYPE_ENEMY){
                    this.HideName();
                    this.HideTitle();
                };
            };
            if (ActionPlayComplete != null){
                ActionPlayComplete(this);
            };
        }
        public function get IsMoving():Boolean{
            if (this.smoothMove){
                return (this.smoothMove.IsMoving);
            };
            return (null);
        }
        public function setNameColor():void{
            if (this.personName){
                this.personName.textColor = this.Role.NameColor;
            };
        }
        public function ShowName():void{
            this.SetName(this.Role.Name);
            this.personName.visible = true;
            doTopTitlePos();
        }
        public function getShadow():Bitmap{
            return (this.shadow);
        }
        public function setBloodViewVisble(_arg1:Boolean):void{
            if (_arg1){
                this.addChild(this.smallBlood);
                isUpdateBlood = true;
            } else {
                if (this.contains(this.smallBlood)){
                    this.removeChild(this.smallBlood);
                };
                isUpdateBlood = false;
            };
            doTopTitlePos();
        }
        public function SetParentScene(_arg1:GameScene):void{
            this._gameScene = _arg1;
        }
        public function UpdatePersonName():void{
            this.personName.filters = OopsEngine.Graphics.Font.Stroke(this.Role.NameBorderColor);
            this.SetName(this.Role.Name);
        }
        private function onSkinLoadComplete(_arg1:String, _arg2:GameElementData):void{
            if (((this.gameScene) && (this.gameScene.CacheResource))){
                if (_arg1.toLowerCase().indexOf("player") == -1){
                    this.gameScene.CacheResource[_arg1] = _arg2;
                };
            };
            if (_arg1.toLowerCase().indexOf("player") != -1){
                GameCommonData.GameInstance.Content.CacheResource[_arg1] = _arg2;
            };
        }
        public function SetDirection(_arg1:int):void{
            this.Role.Direction = _arg1;
            if (this.skins){
                this.skins.ChangeAction(this.Role.ActionState);
            };
        }
        public function createShadow():void{
            if (this.shadow == null){
                this.shadow = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("Shadow");
                this.shadow.name = "Shadow";
                this.shadow.x = ((this.elementWidth - this.shadow.width) / 2);
                this.shadow.y = (((this.skins.MaxBodyHeight + this.textFieldHeight) - 15) + this.OffsetHeight);
                this.addChildAt(this.shadow, 0);
            } else {
                this.shadow.x = ((this.elementWidth - this.shadow.width) / 2);
                this.shadow.y = (((this.skins.MaxBodyHeight + this.textFieldHeight) - 15) + this.OffsetHeight);
            };
        }
        public function get FootPos():Point{
            return (new Point((this.elementWidth / 2), ((this.skins.MaxBodyHeight + this.textFieldHeight) + this.OffsetHeight)));
        }
        public function setGuildColor():void{
            if (personGuildName){
                this.personGuildName.textColor = this.Role.GuildColor;
            };
        }
        private function onMouseOut(_arg1:MouseEvent):void{
            if (this.golem != null){
                this.golemSprite.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                this.golemSprite.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseDown);
                if (MouseOutTarger != null){
                    MouseOutTarger(this);
                };
            };
        }
        private function effectLoadComplete(_arg1:GameEffectResource):void{
            _arg1.GetAnimation().StartClip("jn");
            _arg1.GetAnimation().isLoop = true;
            stateEffectLoad[_arg1.EffectName] = _arg1.GetAnimation();
        }
        protected function onMoveNode(_arg1:int):Boolean{
            this.Translucence();
            this.gameScene.MiddleLayer.depthSortMark();
            return (true);
        }
        public function IsVip():void{
        }
        public function ShowTitle():void{
            if (this.Role.Title){
                this.personTitle.text = this.Role.Title;
                this.personTitle.visible = true;
            };
            doTopTitlePos();
        }
        public function setEffectVisible():void{
            var _local1:String;
            for (_local1 in this.Role.StateList) {
                if (stateEffectLoad[_local1]){
                    if (this.Role.StateList[_local1] == true){
                        if (stateEffectLoad[_local1].parent == null){
                            this.skins.addChild(stateEffectLoad[_local1]);
                        };
                    } else {
                        if (stateEffectLoad[_local1].parent != null){
                            this.skins.removeChild(stateEffectLoad[_local1]);
                        };
                    };
                };
            };
        }
        public function SetVIP():void{
			return;//geoffyan
            var _local1:Rectangle;
            this.personName.htmlText = (((("<font color='" + this.Role.NameColor) + "'>") + ((this.Role.Name)==null) ? "" : this.Role.Name) + "</font>");
            if ((((GameCommonData.Player.Role.GMFlag > 0)) && ((Role.Type == GameRole.TYPE_NPC)))){
                this.personName.htmlText = (((((("<font color='" + this.Role.NameColor) + "'>") + ((this.Role.Name)==null) ? "" : this.Role.Name) + "[") + Role.Id) + "]</font>");
            };
            if (this.Role.Type == GameRole.TYPE_ENEMY){
                if ((GameCommonData.Player.Role.Level - this.Role.Level) > 10){
                    this.personName.htmlText = (("<font color ='#999999'>" + this.Role.Name) + "</font>");
                } else {
                    this.personName.htmlText = (((("<font color='" + this.Role.NameColor) + "'>") + this.Role.Name) + "</font>");
                };
            };
            if (((vipicon) && (vipicon.parent))){
                vipicon.parent.removeChild(vipicon);
            };
            if (this.Role.VIP != 0){
                vipicon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap(("vip" + this.Role.VIP));
            };
            if (this.Role.VIP == 1){
                vipicon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap(("vip" + this.Role.VIP));
                this.Role.VIPColor = "#16776960";
                _local1 = personName.getCharBoundaries(0);
                if (this.personName.parent){
                    this.addChild(vipicon);
                    vipicon.x = (((_local1.x + personName.x) - 23) - 15);
                } else {
                    vipicon.x = ((_local1.x + personName.x) - 23);
                };
                vipicon.y = (personName.y - 1);
            } else {
                if (this.Role.VIP == 2){
                    this.Role.VIPColor = "#00ff00";
                    _local1 = personName.getCharBoundaries(0);
                    if (this.personName.parent){
                        this.addChild(vipicon);
                        vipicon.x = (((_local1.x + personName.x) - 23) - 15);
                    } else {
                        vipicon.x = ((_local1.x + personName.x) - 23);
						
                    };
                    vipicon.y = (personName.y - 1);
                } else {
                    if (this.Role.VIP == 3){
                        this.Role.VIPColor = "#ff0000";
                        _local1 = personName.getCharBoundaries(0);
                        if (this.personName.parent){
                            this.addChild(vipicon);
                            vipicon.x = (((_local1.x + personName.x) - 23) - 15);
                        } else {
                            vipicon.x = ((_local1.x + personName.x) - 23);
                        };
                        vipicon.y = (personName.y - 1);
                    } else {
                        this.Role.VIPColor = null;
                    };
                };
            };
        }
        public function set OffsetHeight(_arg1:int):void{
            _offsetHeight = _arg1;
        }
        private function addMissevent():void{
            this.missionPrompt.addEventListener(MouseEvent.MOUSE_OVER, onMissMouseOver);
            this.missionPrompt.addEventListener(MouseEvent.MOUSE_OUT, onMissMouseOut);
            this.missionPrompt.addEventListener(MouseEvent.MOUSE_DOWN, onMissMouseDown);
        }
        public function MoveTile(_arg1:Point, _arg2:int=0):void{
        }
        public function get GameX():Number{
            return ((this.X + this.excursionX));
        }
        protected function SetPosition():void{
            var _local1:Point;
            if (this.Role != null){
                _local1 = MapTileModel.GetTilePointToStage(this.Role.TileX, this.Role.TileY);
                this.X = _local1.x;
                this.Y = _local1.y;
                this.Translucence();
            };
        }
        public function get Skins():GameElementSkins{
            return (this.skins);
        }
        public function Stop():void{
            if (this.smoothMove){
                this.smoothMove.IsMoving = false;
            };
        }
        public function AllDispose():void{
            Dispose();
            if (this != GameCommonData.Player){
                _isDispose = true;
                skillAnimation = null;
                golem = null;
                if (this.handler){
                    this.handler.Clear();
                };
                this.handler = null;
                if (this.skins){
                    this.skins.dispose();
                    this.skins = null;
                };
                this.ActionPlayFrame = null;
                this.smoothMove = null;
                this.teamLeaderSign = null;
                this.smallBlood = null;
                this.teamMemberSign = null;
                this.stateEffectList = null;
                if (this.shadow){
                    if (this.shadow.parent){
                        this.shadow.parent.removeChild(this.shadow);
                    };
                    this.shadow = null;
                };
                if (this.paopaoView){
                    if (this.paopaoView.parent){
                        this.paopaoView.parent.removeChild(this.paopaoView);
                    };
                    paopaoView.dispose();
                    paopaoView = null;
                };
                if (this.golemSprite){
                    this.golemSprite.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
                    this.golemSprite.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
                    this.golemSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                    this.golemSprite = null;
                };
            };
        }
        public function getSmoothMove():SmoothMove{
            return (this.smoothMove);
        }
        public function get PersonName():TextField{
            return (personName);
        }
        public function showGuildName():void{
            if (((personGuildName) && (!((this.Role.GuildName == ""))))){
                this.personGuildName.text = this.Role.GuildName;
                this.personGuildName.visible = true;
            };
            doTopTitlePos();
        }
        public function showAttackFace(_arg1:String="", _arg2:Number=0, _arg3:String="", _arg4:uint=0, _arg5:uint=0):void{
            FightMessageController.showAttackFace(this, _arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function get isDispose():Boolean{
            return (_isDispose);
        }
        public function get GameY():Number{
            return ((this.Y + this.excursionY));
        }
        public function SetTeamLeader(_arg1:Boolean):void{
            if (((_arg1) && (!((this.personName == null))))){
                if (((teamMemberSign) && (this.contains(teamMemberSign)))){
                    this.removeChild(teamMemberSign);
                    teamMemberSign = null;
                };
                if (((teamLeaderSign) && (this.contains(teamLeaderSign)))){
                    return;
                };
                if (this.personName.text.length == 0){
                    this.personName.text = LanguageMgr.GetTranslation("名字缺失");
                };
                this.teamLeaderSign = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("TeamLeaderSign");
                this.addChild(teamLeaderSign);
                doTopTitlePos();
            } else {
                if (((teamLeaderSign) && (this.contains(teamLeaderSign)))){
                    this.removeChild(this.teamLeaderSign);
                    teamLeaderSign = null;
                };
            };
        }
        public function updateBlood():void{
            if (this.smallBlood){
                this.smallBlood.blood.scaleX = (this.Role.HP / this.Role.MaxHp);
            };
        }
        override public function Initialize():void{
            var _local1:TextFormat;
            var _local2:TextFormat;
            var _local3:TextFormat;
            if (this.skins != null){
                if (this.isInitialize == false){
                    this.SetMoveSpend(5);
                    this.personGuildName = new TextField();
                    _local3 = new TextFormat();
                    _local3.align = TextFormatAlign.CENTER;
                    _local3.size = 12;
                    _local3.font = LanguageMgr.DEFAULT_FONT;
                    this.personGuildName.defaultTextFormat = _local3;
                    this.personGuildName.cacheAsBitmap = true;
                    this.personGuildName.mouseEnabled = false;
                    this.personGuildName.selectable = false;
                    this.personGuildName.type = TextFieldType.DYNAMIC;
                    this.personGuildName.textColor = this.Role.GuildColor;
                    setGuildName(this.Role.GuildName);
                    this.personGuildName.filters = OopsEngine.Graphics.Font.Stroke(0);
                    this.personGuildName.x = -15;
                    this.personGuildName.y = 0;
                    this.personGuildName.width = (this.elementWidth + 30);
                    this.personGuildName.height = this.textFieldHeight;
                    this.addChild(this.personGuildName);
                    this.personTitle = new TextField();
                    _local1 = new TextFormat();
                    _local1.align = TextFormatAlign.CENTER;
                    _local1.color = this.Role.TitleColor;
                    _local1.size = 12;
                    _local1.font = LanguageMgr.DEFAULT_FONT;
                    this.personTitle.defaultTextFormat = _local1;
                    this.personTitle.cacheAsBitmap = true;
                    this.personTitle.mouseEnabled = false;
                    this.personTitle.selectable = false;
                    this.personTitle.type = TextFieldType.DYNAMIC;
                    this.personTitle.text = ((this.Role.Title == null)) ? "" : this.Role.Title;
                    this.personTitle.filters = OopsEngine.Graphics.Font.Stroke(this.Role.TitleBorderColor);
                    this.personTitle.x = 0;
                    this.personTitle.y = 0;
                    this.personTitle.width = this.elementWidth;
                    this.personTitle.height = this.textFieldHeight;
                    this.addChild(this.personTitle);
                    this.personName = new TextField();
                    this.personName.text = LanguageMgr.GetTranslation("未设置");
                    _local2 = new TextFormat();
                    _local2.align = TextFormatAlign.CENTER;
                    _local2.color = this.Role.NameColor;
                    _local2.size = 12;
                    _local2.font = LanguageMgr.DEFAULT_FONT;
                    this.personName.defaultTextFormat = _local2;
                    this.personName.cacheAsBitmap = true;
                    this.personName.mouseEnabled = false;
                    this.personName.selectable = false;
                    this.personName.type = TextFieldType.DYNAMIC;
                    this.SetName(this.Role.Name);
                    this.personName.filters = OopsEngine.Graphics.Font.Stroke(this.Role.NameBorderColor);
                    this.personName.x = 0;
                    this.personName.y = 0;
                    this.personName.width = this.elementWidth;
                    this.personTitle.height = this.textFieldHeight;
                    this.addChild(this.personName);
                    if (vipicon != null){
                        this.addChild(this.vipicon);
                    };
                    this.smallBlood = this.Games.Content.Load(Engine.UILibrary).GetClassByMovieClip("BloodBar");
                    this.smallBlood.x = ((this.elementWidth / 2) - (this.smallBlood.width / 2));
                    this.smallBlood.y = 0;
                    this.addChild(this.smallBlood);
                    this.showContainer = new Sprite();
                    this.addChild(showContainer);
                    this.paopaoView = new AnimalDialogue();
                    showContainer.addChild(paopaoView);
                    paopaoView.y = -55;
                    updateBlood();
                    if ((((((this.Role.Type == GameRole.TYPE_PLAYER)) || ((this.Role.Type == GameRole.TYPE_OWNER)))) && (!((this.Role.isStalling == 0))))){
                        this.PlayerStall();
                    } else {
                        if (this.IsLoadSkins != true){
                            this.golem = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("Golem");
                            this.golem.x = ((this.elementWidth - this.golem.width) / 2);
                            this.golem.y = 40;
                            this.golemSprite.addChild(this.golem);
                            this.addChild(this.golemSprite);
                        };
                    };
                    if (this.Role.isStalling != 0){
                        this.HideName();
                        this.HideTitle();
                    };
                    if (this.Role.Type == GameRole.TYPE_OWNER){
                        this.mouseEnabled = false;
                        this.mouseChildren = false;
                    };
                    this.excursionX = (this.elementWidth / 2);
                    this.excursionY = this.height;
                } else {
                    this.Stop();
                    if (ispooled){
                        this.SetAction(GameElementSkins.ACTION_STATIC, this.Role.Direction);
                    } else {
                        this.SetAction(GameElementSkins.ACTION_STATIC, GameElementSkins.DIRECTION_DOWN);
                    };
                    if (ispooled){
                        this.personGuildName.textColor = this.Role.GuildColor;
                        setGuildName(this.Role.GuildName);
                        _local1 = new TextFormat();
                        _local1.align = TextFormatAlign.CENTER;
                        _local1.color = this.Role.TitleColor;
                        _local1.size = 12;
                        _local1.font = LanguageMgr.DEFAULT_FONT;
                        this.personTitle.defaultTextFormat = _local1;
                        this.personTitle.text = ((this.Role.Title == null)) ? "" : this.Role.Title;
                        this.personTitle.filters = OopsEngine.Graphics.Font.Stroke(this.Role.TitleBorderColor);
                        _local2 = new TextFormat();
                        _local2.align = TextFormatAlign.CENTER;
                        _local2.color = this.Role.NameColor;
                        _local2.size = 12;
                        _local2.font = LanguageMgr.DEFAULT_FONT;
                        this.personName.defaultTextFormat = _local2;
                        this.SetName(this.Role.Name);
                        this.personName.filters = OopsEngine.Graphics.Font.Stroke(this.Role.NameBorderColor);
                        if ((((((this.Role.Type == GameRole.TYPE_PLAYER)) || ((this.Role.Type == GameRole.TYPE_OWNER)))) && (!((this.Role.isStalling == 0))))){
                            this.PlayerStall();
                        } else {
                            if (this.IsLoadSkins != true){
                                this.golem = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("Golem");
                                this.golem.x = ((this.elementWidth - this.golem.width) / 2);
                                this.golem.y = 40;
                                this.golemSprite.addChild(this.golem);
                                this.addChild(this.golemSprite);
                            };
                        };
                        if (this.Role.isStalling != 0){
                            this.HideName();
                            this.HideTitle();
                        };
                        if (this.Role.Type == GameRole.TYPE_OWNER){
                            this.mouseEnabled = false;
                            this.mouseChildren = false;
                        };
                        this.excursionX = (this.elementWidth / 2);
                        this.excursionY = this.height;
                        this.smallBlood.blood.scaleX = 1;
                    };
                };
            };
            this.SetPosition();
            this.doTopTitlePos();
            if (this.skins != null){
                if ((((((this.Role.Type == GameRole.TYPE_PLAYER)) || ((this.Role.Type == GameRole.TYPE_OWNER)))) && (!((this.Role.isStalling == 0))))){
                } else {
                    if (this.isInitialize == false){
                        this.skins.ChangeEquip = onChangeEquip;
                        this.skins.ChooseTarger = ChooseTarger;
                        this.skins.LoadSkin();
                        this.isInitialize = true;
                    } else {
                        if (this.Role.wantLoadPerson){
                            this.skins.LoadSkin(GameElementSkins.EQUIP_PERSON);
                        };
                        if (this.Role.wantLoadMount){
                            this.skins.LoadSkin(GameElementSkins.EQUIP_MOUNT);
                        };
                        if (this.Role.wantLoadWeapon){
                            this.skins.LoadSkin(GameElementSkins.EQUIP_WEAOIB);
                        };
                        if (this.Role.wantLoadWeaponEffect){
                            this.skins.LoadSkin(GameElementSkins.EQUIP_WEAPONE_EFFECT);
                        };
                        this.Role.wantLoadPerson = false;
                        this.Role.wantLoadMount = false;
                        this.Role.wantLoadWeapon = false;
                        this.Role.wantLoadWeaponEffect = false;
                    };
                };
            };
            super.Initialize();
        }
        protected function onMoveComplete():void{
            this.Translucence();
            this.gameScene.MiddleLayer.depthSortMark();
        }
        override public function set Y(_arg1:Number):void{
            this.y = (_arg1 - this.excursionY);
        }
        private function loadStateEffect(_arg1:String):void{
            var _local2:* = new GameEffectResource();
            _local2.EffectName = _arg1;
            _local2.EffectPath = (((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameEffectSWF) + _arg1) + ".swf");
            _local2.OnLoadEffect = effectLoadComplete;
            _local2.EffectBR.LoadComplete = _local2.onEffectComplete;
            _local2.EffectBR.Download.Add(_local2.EffectPath);
            _local2.EffectBR.Load();
            this.stateEffectList[_arg1] = _local2;
        }
        public function get gameScene():GameScene{
            return (_gameScene);
        }
        private function onMissMouseDown(_arg1:MouseEvent):void{
            ChooseTarger(this);
        }
        public function get PlayerHitY():Number{
            if (this.skins == null){
                return (0);
            };
            return ((((this.skins.MaxBodyHeight / 2) + this.textFieldHeight) + 5));
        }
        private function onMouseDown(_arg1:MouseEvent):void{
            if (this.golem != null){
                if (ChooseTarger != null){
                    ChooseTarger(this);
                };
            };
        }
        public function get OffsetHeight():int{
            return (_offsetHeight);
        }
        public function get PlayerHitX():Number{
            return ((elementWidth / 2));
        }
        public function SetTeam(_arg1:Boolean):void{
            if (_arg1){
                if (((teamLeaderSign) && (this.contains(teamLeaderSign)))){
                    this.removeChild(teamLeaderSign);
                    teamLeaderSign = null;
                };
                if (((teamMemberSign) && (this.contains(teamMemberSign)))){
                    return;
                };
                if (((!((this.personName == null))) && (!((this.personName.text == ""))))){
                    this.teamMemberSign = this.Games.Content.Load(Engine.UILibrary).GetClassByBitmap("TeamMemberSign");
                    this.addChild(teamMemberSign);
                    doTopTitlePos();
                };
            } else {
                if (((teamMemberSign) && (this.contains(teamMemberSign)))){
                    this.removeChild(this.teamMemberSign);
                    teamMemberSign = null;
                };
            };
        }
        override public function set X(_arg1:Number):void{
            this.x = (_arg1 - this.excursionX);
        }
        protected function doTopTitlePos():void{
            var topTF:* = null;
            var yT:* = 0;
            if (this.Role.MountSkinName != null){
                if ((((this.Role.MountSkinID == 10400004)) || ((this.Role.MountSkinID == 10400009)))){
                    yT = -10;
                } else {
                    if ((((this.Role.MountSkinID == 10400006)) || ((this.Role.MountSkinID == 10400001)))){
                        yT = -25;
                    } else {
                        if ((((this.Role.MountSkinID == 10400005)) || ((this.Role.MountSkinID == 10400010)))){
                            yT = -20;
                        } else {
                            yT = 0;
                        };
                    };
                };
            } else {
                yT = 15;
            };
            if (((((this.smallBlood) && (this.smallBlood.visible))) && (this.smallBlood.parent))){
                this.smallBlood.y = yT;
                yT = (yT - 15);
            } else {
                yT = (yT - 5);
            };
            if (((this.personName) && (this.personName.visible))){
                this.personName.y = yT;
                if (vipicon){
                    this.vipicon.y = (yT - 1);
                };
                yT = (yT - 15);
                topTF = this.personName;
            };
            if (((((this.personGuildName) && (this.personGuildName.visible))) && (!((personGuildName.text == ""))))){
                this.personGuildName.y = yT;
                yT = (yT - 15);
                topTF = this.personGuildName;
            };
            if (((this.personTitle) && (this.personTitle.visible))){
                this.personTitle.y = yT;
                yT = (yT - 15);
                topTF = this.personTitle;
            };
            setTimeout(function ():void{
                if (((topTF) && (topTF.getCharBoundaries(0)))){
                    if (((teamLeaderSign) && (teamLeaderSign.parent))){
                        teamLeaderSign.x = (topTF.getCharBoundaries(0).x - teamLeaderSign.width);
                        teamLeaderSign.y = ((topTF.y - teamLeaderSign.height) + 15);
                        if (topTF == personName){
                            teamLeaderSign.y = (teamLeaderSign.y - 18);
                        } else {
                            if (topTF == personGuildName){
                                teamLeaderSign.x = (teamLeaderSign.x - 15);
                            };
                        };
                    };
                    if (((teamMemberSign) && (teamMemberSign.parent))){
                        teamMemberSign.x = (topTF.getCharBoundaries(0).x - teamMemberSign.width);
                        teamMemberSign.y = ((topTF.y - teamMemberSign.height) + 15);
                        if (topTF == personName){
                            teamMemberSign.y = (teamMemberSign.y - 18);
                        } else {
                            if (topTF == personGuildName){
                                teamMemberSign.x = (teamMemberSign.x - 15);
                            };
                        };
                    };
                };
            }, 500);
        }
        public function setGuildName(_arg1:String):void{
            if (this.personGuildName){
                this.personGuildName.text = ((_arg1)==null) ? "" : _arg1;
            };
        }
        private function onMissMouseOver(_arg1:MouseEvent):void{
            onMouseOverTarger();
            this.skins.AddHighlight();
        }
        public function SetSkin(_arg1:String, _arg2:String):void{
        }
        override public function Update(_arg1:GameTime):void{
            var _local2:int;
            var _local3:GameSkillEffect;
            var _local4:String;
            if (this.skins != null){
                if (this.isActionPlaying){
                    this.skins.Update(_arg1);
                };
                if (((skillAnimation) && ((skillAnimation.length > 0)))){
                    _local2 = (skillAnimation.length - 1);
                    while (_local2 >= 0) {
                        if (skillAnimation[_local2].IsPlayComplete){
                            skillAnimation[_local2] = null;
                            skillAnimation.splice(_local2, 1);
                        } else {
                            skillAnimation[_local2].Update(_arg1);
                        };
                        _local2--;
                    };
                };
                if (((!((this.handler == null))) && (this.handler.IsSmoothMoving))){
                    for each (_local3 in this.handler.SkillEffectList) {
                        if (_local3.smoothMove != null){
                            _local3.smoothMove.Update(_arg1);
                        };
                    };
                    if (UpdateSkillEffect != null){
                        UpdateSkillEffect(this);
                    };
                };
                if (PetDistance != null){
                    PetDistance();
                };
                if (((this.smoothMove) && (this.smoothMove.IsMoving))){
                    this.smoothMove.Update(_arg1);
                };
                for (_local4 in this.Role.StateList) {
                    if (this.Role.StateList[_local4] == true){
                        if (this.stateEffectList[_local4] == null){
                            loadStateEffect(_local4);
                        } else {
                            if (stateEffectLoad[_local4]){
                                stateEffectLoad[_local4].Update(_arg1);
                            };
                        };
                    };
                };
            };
            super.Update(_arg1);
        }
        public function SetMoveSpend(_arg1:int):void{
            if (this.smoothMove == null){
                this.smoothMove = new SmoothMove(this, this.Role.Speed);
                this.smoothMove.MoveNode = onMoveNode;
                this.smoothMove.MoveStep = onMoveStep;
                this.smoothMove.MoveComplete = onMoveComplete;
            };
            if (this.Role.Speed == _arg1){
                return;
            };
            this.Role.Speed = _arg1;
            this.smoothMove.MoveStepLength = this.Role.Speed;
        }
        public function IsSelect(_arg1:Boolean):void{
            var _local2:* = _arg1;
            if (((this.shadow) && ((this.Role.HP > 0)))){
                if (_local2){
                    if (this.Role.MountSkinName != null){
                        this.shadow.y = ((((this.skins.MaxBodyHeight + this.textFieldHeight) - 15) + this.OffsetHeight) + this.MountHeight);
                    };
                    SpeciallyEffectController.getInstance().SetTargetLight(this);
                } else {
                    if (this.Role.MountSkinName == null){
                        this.shadow.y = (((this.skins.MaxBodyHeight + this.textFieldHeight) - 15) + this.OffsetHeight);
                    };
                };
            };
        }
        public function SetMissionPrompt(_arg1:int):void{
            var _local2:Sprite;
            if ((((this.Role.Type == GameRole.TYPE_NPC)) || ((this.Role.Type == GameRole.TYPE_OWNER)))){
                if (this.missionPrompt != null){
                    this.removeChild(this.missionPrompt);
                    removeMissevent();
                    this.missionPrompt = null;
                };
                if (_arg1 == 0){
                    this.Role.MissionState = _arg1;
                } else {
                    if (_arg1 <= 3){
                        this.Role.MissionState = _arg1;
                        if (_arg1 == 3){
                            this.missionPrompt = this.Games.Content.Load(Engine.UILibrary).GetClassByMovieClip("task_finish");
                        };
                        if (_arg1 == 2){
                            this.missionPrompt = this.Games.Content.Load(Engine.UILibrary).GetClassByMovieClip("task_unfinish");
                        };
                        if (_arg1 == 1){
                            this.missionPrompt = this.Games.Content.Load(Engine.UILibrary).GetClassByMovieClip("task_unAccpet");
                        };
                    };
                    this.missionPrompt.x = (this.elementWidth / 2);
                    this.missionPrompt.y = -25;
                    _local2 = new Sprite();
                    _local2.graphics.beginFill(0xFFFF, 0);
                    _local2.graphics.drawRect(-28, -28, 56, 56);
                    _local2.graphics.endFill();
                    this.missionPrompt.addChild(_local2);
                    this.addChild(this.missionPrompt);
                    addMissevent();
                };
            };
        }
        public function Move(_arg1:Point, _arg2:int=0):void{
        }
        public function SetName(_arg1:String):void{
            if (this.Role.Name != null){
                this.Role.Name = _arg1;
                this.SetVIP();
            };
        }
        public function showDialogue(_arg1:String):void{
            this.paopaoView.showDialogue(_arg1);
            this.paopaoView.x = ((this.elementWidth / 2) - (this.paopaoView.width / 2));
        }
        private function onMouseMove(_arg1:MouseEvent):void{
            var _local2:uint;
            var _local3:uint;
            if (this.golem != null){
                _local2 = this.golem.bitmapData.getPixel32(Math.abs((this.golemSprite.mouseX - this.golem.x)), Math.abs((this.golemSprite.mouseY - this.golem.y)));
                _local3 = ((_local2 >> 24) & 0xFF);
                if (((!((_local3 == 0))) && (!((MouseOverTarger == null))))){
                    MouseOverTarger(this);
                } else {
                    if (MouseOutTarger != null){
                        MouseOutTarger(this);
                    };
                };
            };
        }
        private function removeMissevent():void{
            this.missionPrompt.removeEventListener(MouseEvent.MOUSE_OVER, onMissMouseOver);
            this.missionPrompt.removeEventListener(MouseEvent.MOUSE_OUT, onMissMouseOut);
            this.missionPrompt.removeEventListener(MouseEvent.MOUSE_DOWN, onMissMouseDown);
        }
        public function hideGuildName():void{
            if (this.personGuildName != null){
                this.personGuildName.visible = false;
            };
            doTopTitlePos();
        }
        override public function Dispose():void{
            var _local1:int;
            if (((this.skillAnimation) && ((this.skillAnimation.length > 0)))){
                _local1 = (this.skillAnimation.length - 1);
                while (_local1 >= 0) {
                    if (this.skillAnimation[_local1].parent){
                        this.skillAnimation[_local1].parent.removeChild(this.skillAnimation[_local1]);
                    };
                    this.skillAnimation[_local1] = null;
                    _local1--;
                };
                this.skillAnimation = [];
            };
            if (this.handler){
                this.handler.Clear();
            };
            this.handler = null;
            super.Dispose();
        }

    }
}//package OopsEngine.Scene.StrategyElement 
