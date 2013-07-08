//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerInfo.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import OopsEngine.Role.*;
    import flash.geom.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Friend.view.ui.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.PlayerInfo.Command.*;
    import OopsEngine.Graphics.*;

    public class TeamCell extends Sprite {

        private const MPMaxW:int = 78;
        private const HPMaxW:int = 87;

        protected var buffs:HeadImgList;
        private var timer:Timer;
        private var des_hp_w:Number;
        protected var face:int = -1;
        protected var onlineMask:Shape;
        public var menu:MenuItem;
        private var des_mp_w:Number;
        public var contentMc:MovieClip;
        public var role:GameRole;
        protected var lineDes:TextField;

        public function TeamCell(_arg1:GameRole){
            this.addEventListener(Event.ADDED_TO_STAGE, onaddToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
            this.contentMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TeamCell");
            this.contentMc.mouseEnabled = false;
            this.buffs = new HeadImgList(2);
            this.buffs.x = (46 + 22);
            this.buffs.y = (43 - 3);
            this.role = _arg1;
            (this.contentMc.txt_userName as TextField).text = _arg1.Name;
            (this.contentMc.txt_userName as TextField).mouseEnabled = false;
            (this.contentMc.txt_level as TextField).text = String(_arg1.Level);
            (this.contentMc.txt_level as TextField).mouseEnabled = false;
            this.contentMc["mc_redOne"].mask = this.contentMc["mc_redOneMask"];
            this.contentMc["mc_buleOne"].mask = this.contentMc["mc_buleOneMask"];
            (this.contentMc.mc_redOneMask as MovieClip).width = (Math.min((_arg1.HP / (_arg1.MaxHp + _arg1.AdditionAtt.MaxHP)), 1) * 87);
            (this.contentMc.mc_buleOneMask as MovieClip).width = (Math.min((_arg1.MP / (_arg1.MaxMp + _arg1.AdditionAtt.MaxMP)), 1) * 78);
            (this.contentMc.mc_headImg as MovieClip).addEventListener(MouseEvent.CLICK, onSelectRole);
            (this.contentMc.menuBtn as SimpleButton).addEventListener(MouseEvent.CLICK, onMouseClickHandler);
            onlineMask = new Shape();
            onlineMask.graphics.beginFill(0, 0.4);
            onlineMask.graphics.drawRect(3, 0, 32, 32);
            onlineMask.graphics.endFill();
            onlineMask.visible = false;
            this.contentMc.addChild(onlineMask);
            this.lineDes = new TextField();
            this.lineDes.autoSize = TextFieldAutoSize.LEFT;
            this.lineDes.mouseEnabled = false;
            this.lineDes.filters = OopsEngine.Graphics.Font.Stroke();
            this.contentMc.addChild(this.lineDes);
            this.lineDes.x = 10;
            this.lineDes.y = 16;
            this.setBuffs(_arg1);
            this.setFace(_arg1.Face);
            this.menu = new MenuItem();
            this.menu.addEventListener(MenuEvent.Cell_Click, onClickHandler);
            contentMc.mc_headImg.mask = contentMc.faceMask;
            contentMc.faceMask.visible = false;
            contentMc.farTeamTF.visible = false;
            this.addChild((this.contentMc as DisplayObject));
        }
        protected function onaddToStage(_arg1:Event):void{
            this.stage.addEventListener(MouseEvent.CLICK, onMouseClick);
        }
        public function setLevel(_arg1:uint):void{
            (this.contentMc.txt_level as TextField).text = String(_arg1);
        }
        protected function showBuffs(_arg1:Array):void{
            this.buffs.dataPro = _arg1;
            this.contentMc.addChild(this.buffs);
        }
        public function removeTimerLis():void{
            if (timer){
                timer.removeEventListener(TimerEvent.TIMER, updateTimerHandler);
                timer.stop();
                timer = null;
            };
        }
        public function updateTimerHandler(_arg1:TimerEvent):void{
            var _local2:MovieClip = (this.contentMc.mc_redOneMask as MovieClip);
            var _local3:MovieClip = (this.contentMc.mc_buleOneMask as MovieClip);
            var _local4:Number = 0.1;
            var _local5:Number = (des_hp_w - _local2.width);
            var _local6:Number = (des_mp_w - _local3.width);
            if (Math.abs(_local5) >= 5){
                _local2.width = Math.min((_local2.width + (_local5 * _local4)), HPMaxW);
            } else {
                if ((((_local2.width <= 0)) || ((_local2.width == HPMaxW)))){
                    timer.stop();
                } else {
                    _local2.width = des_hp_w;
                    timer.stop();
                };
            };
            trace(_local2.width);
            if (Math.abs(_local6) >= 5){
                _local3.width = Math.min((_local3.width + (_local6 * _local4)), MPMaxW);
            } else {
                if (_local3.width <= 0){
                    timer.stop();
                } else {
                    _local3.width = des_mp_w;
                };
            };
        }
        protected function onMouseClickHandler(_arg1:MouseEvent):void{
            UIFacade.UIFacadeInstance.selectTeam(this.role);
            var _local2:Array = [];
            var _local3:GameRole = GameCommonData.Player.Role;
            if (_local3.isTeamLeader){
                _local2.push({
                    cellText:LanguageMgr.GetTranslation("提升为队长"),
                    data:{type:"提升为队长"}
                });
                _local2.push({
                    cellText:LanguageMgr.GetTranslation("移出队伍"),
                    data:{type:"移出队伍"}
                });
            };
            _local2.push({
                cellText:LanguageMgr.GetTranslation("交易"),
                data:{type:"交易"}
            });
            _local2.push({
                cellText:LanguageMgr.GetTranslation("设为私聊"),
                data:{type:"设为私聊"}
            });
            _local2.push({
                cellText:LanguageMgr.GetTranslation("复制姓名"),
                data:{type:"复制姓名"}
            });
            _local2.push({
                cellText:LanguageMgr.GetTranslation("加为好友"),
                data:{type:"加为好友"}
            });
            _local2.push({
                cellText:LanguageMgr.GetTranslation("查看信息"),
                data:{type:"查看信息"}
            });
            this.menu.dataPro = _local2;
            var _local4:Point = new Point(this.mouseX, this.mouseY);
            var _local5:Point = this.localToGlobal(_local4);
            var _local6:DisplayObject = GameCommonData.GameInstance.GameUI.getChildByName("MENU");
            if (_local6 != null){
                GameCommonData.GameInstance.GameUI.removeChild(_local6);
            };
            GameCommonData.GameInstance.GameUI.addChild(this.menu);
            this.menu.x = _local5.x;
            this.menu.y = _local5.y;
            _arg1.stopPropagation();
        }
        public function setTeamLeader():void{
            var _local1:DisplayObject;
            var _local2:BitmapData;
            var _local3:Bitmap;
            _local1 = this.contentMc.getChildByName("TeamLeader");
            if (((_local1) && (this.contentMc.contains(_local1)))){
                this.contentMc.removeChild(_local1);
            };
            if (role.Id == GameCommonData.Player.Role.idTeamLeader){
                _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData("TeamLeaderSign");
                _local3 = new Bitmap();
                _local3.name = "TeamLeader";
                _local3.bitmapData = _local2;
                _local3.x = 14;
                _local3.y = -20;
                this.contentMc.addChild(_local3);
            };
        }
        public function setHp(_arg1:uint, _arg2:uint):void{
            des_hp_w = ((_arg1 / _arg2) * HPMaxW);
            if (timer == null){
                timer = new Timer(40);
            };
            if (!timer.hasEventListener(TimerEvent.TIMER)){
                timer.addEventListener(TimerEvent.TIMER, updateTimerHandler);
            };
            timer.start();
        }
        public function setFarTeam(_arg1:Boolean):void{
            contentMc.farTeamTF.visible = _arg1;
        }
        private function onSelectRole(_arg1:MouseEvent):void{
            TargetController.SetTarget(this.role.CurrentPlayer);
            UIFacade.GetInstance().sendNotification(PlayerInfoComList.SELECT_ELEMENT, this.role);
        }
        public function setBuffs(_arg1:GameRole):void{
            var _local2:GameSkillBuff;
            var _local3:GameSkillBuff;
            var _local5:uint;
            this.role = _arg1;
            var _local4:Array = [];
            for each (_local2 in _arg1.DotBuff) {
                ++_local5;
                if (_local5 > 7){
                    break;
                };
                _local4.push({
                    info:_local2,
                    isDeBuff:true
                });
            };
            for each (_local3 in _arg1.PlusBuff) {
                ++_local5;
                if (_local5 > 7){
                    break;
                };
                _local4.push({
                    info:_local3,
                    isDeBuff:false
                });
            };
            this.showBuffs([_local4]);
        }
        protected function onClickHandler(_arg1:MenuEvent):void{
            var _local2:TeamEvent = new TeamEvent(TeamEvent.CELL_CLICK, false, false);
            _local2.flagStr = _arg1.cell.data["type"];
            _local2.role = role;
            this.dispatchEvent(_local2);
        }
        protected function onMouseClick(_arg1:MouseEvent):void{
            if (GameCommonData.GameInstance.GameUI.contains(this.menu)){
                GameCommonData.GameInstance.GameUI.removeChild(this.menu);
            };
        }
        public function setMp(_arg1:uint, _arg2:uint):void{
            des_mp_w = ((_arg1 / _arg2) * 78);
            if (timer == null){
                timer = new Timer(40);
            };
            if (!timer.hasEventListener(TimerEvent.TIMER)){
                timer.addEventListener(TimerEvent.TIMER, updateTimerHandler);
            };
            timer.start();
        }
        public function setFace(_arg1:uint):void{
            if (this.face == _arg1){
                return;
            };
            this.face = _arg1;
            var _local2:FaceItem = new FaceItem(String(_arg1), null, "face", (47 / 50));
            _local2.offsetPoint = new Point(0, 0);
            var _local3:MovieClip = (this.contentMc.mc_headImg as MovieClip);
            while (_local3.numChildren > 0) {
                _local3.removeChildAt(0);
            };
            _local3.addChild(_local2);
            _local2.x = (_local2.y = -1);
            setTeamLeader();
        }
        protected function onRemoveFromStage(_arg1:Event):void{
            this.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
            this.menu.removeEventListener(MenuEvent.Cell_Click, onClickHandler);
            this.menu.dataPro = [];
            if (this.menu.parent != null){
                this.menu.parent.removeChild(this.menu);
            };
            (this.contentMc.mc_headImg as MovieClip).removeEventListener(MouseEvent.CLICK, onSelectRole);
            (this.contentMc.menuBtn as SimpleButton).removeEventListener(MouseEvent.CLICK, onMouseClickHandler);
            this.stage.removeEventListener(Event.ADDED_TO_STAGE, onaddToStage);
            this.stage.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
            removeTimerLis();
        }
        public function updateLineDes(_arg1:String, _arg2:uint=0):void{
        }

    }
}//package GameUI.Modules.PlayerInfo.UI 
