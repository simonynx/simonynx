//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.Team.Datas.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import com.greensock.*;
    import GameUI.Modules.Friend.command.*;
    import GameUI.Modules.Unity.Data.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Trade.Data.*;
    import GameUI.Modules.Equipment.command.*;
    import GameUI.Modules.AutoPlay.command.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import com.greensock.easing.*;

    public class NewInfoTipIIMediator extends Mediator {

        private static const MaxShowCnt:int = 8;
        public static const NAME:String = "NewInfoTipIIMediator";

        private var timer:Timer;
        private var infoTipsVosArr:Array;
        private var timeLimit:int = 60000;
        private var infoTipsMcsArr:Array;
        private var Visible:Boolean = true;

        public function NewInfoTipIIMediator(){
            infoTipsVosArr = [];
            infoTipsMcsArr = [];
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, NewInfoTipNotiName.ADD_INFOTIP, NewInfoTipNotiName.NEWINFOTIP_SKILL_SHOW, NewInfoTipNotiName.NEWINFOTIP_SKILL_HIDE, NewInfoTipNotiName.NEWINFOTIP_SHENBIN_SHOW, NewInfoTipNotiName.NEWINFOTIP_SHENBIN_HIDE, NewInfoTipNotiName.VISIBLE_NEWINFOTIP_UI, EventList.RESIZE_STAGE]);
        }
        private function addEvents():void{
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:NewInfoTipVo;
            var _local3:Boolean;
            var _local4:uint;
            var _local5:*;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    initView();
                    addEvents();
                    break;
                case NewInfoTipNotiName.ADD_INFOTIP:
                    _local2 = (_arg1.getBody() as NewInfoTipVo);
                    _local3 = false;
                    _local4 = 0;
                    _local4 = 0;
                    while (_local4 < infoTipsVosArr.length) {
                        if (_local2.type == infoTipsVosArr[_local4].type){
                            switch (infoTipsVosArr[_local4].type){
                                case NewInfoTipType.TYPE_ADD_ENEMY:
                                    if (infoTipsVosArr[_local4].data.playerId == _local2.data.playerId){
                                        infoTipsVosArr.splice(_local4, 1);
                                    };
                                    break;
                                case NewInfoTipType.TYPE_CHAT:
                                    if (infoTipsVosArr[_local4].data.sendId == _local2.data.sendId){
                                        infoTipsVosArr.splice(_local4, 1);
                                    };
                                    break;
                                case NewInfoTipType.TYPE_DUEL:
                                    if (infoTipsVosArr[_local4].data == _local2.data){
                                        infoTipsVosArr.splice(_local4, 1);
                                    };
                                    break;
                                case NewInfoTipType.TYPE_GUILDINVITE:
                                    if (infoTipsVosArr[_local4].data.guildId == _local2.data.guildId){
                                        infoTipsVosArr.splice(_local4, 1);
                                    };
                                    break;
                                case NewInfoTipType.TYPE_TEAMINVITE:
                                    if (infoTipsVosArr[_local4].data.teamId == _local2.data.teamId){
                                        infoTipsVosArr.splice(_local4, 1);
                                    };
                                    break;
                                case NewInfoTipType.TYPE_TRADEINVITE:
                                    _local5 = infoTipsVosArr[_local4];
                                    if (infoTipsVosArr[_local4].data.targetId == _local2.data.targetId){
                                        infoTipsVosArr.splice(_local4, 1);
                                    };
                                    break;
                                case NewInfoTipType.TYPE_STAR:
                                    _local7 = infoTipsVosArr.length;
                                    while (_local6 < _local7) {
                                        if (infoTipsVosArr[_local6].type == NewInfoTipType.TYPE_STAR){
                                            _local3 = true;
                                            break;
                                        };
                                        _local6++;
                                    };
                                    break;
                            };
                        };
                        _local4++;
                    };
                    if (_local3 == false){
                        infoTipsVosArr.push(_local2);
                        _local8 = ((((((GameCommonData.GameInstance.ScreenWidth - 1000) / 2) + 1000) - 723) + 90) + 400);
                        _local9 = (GameCommonData.GameInstance.ScreenHeight - 200);
                        if (infoTipsMcsArr[(infoTipsVosArr.length - 1)]){
                            infoTipsMcsArr[(infoTipsVosArr.length - 1)].x = (_local8 + (_local6 * 40));
                            infoTipsMcsArr[(infoTipsVosArr.length - 1)].y = _local9;
                        };
                    };
                    doPos();
                    break;
                case NewInfoTipNotiName.NEWINFOTIP_SKILL_SHOW:
                    _local2 = new NewInfoTipVo();
                    _local2.title = LanguageMgr.GetTranslation("获得新的技能点");
                    _local2.type = NewInfoTipType.TYPE_SKILL;
                    _local3 = false;
                    _local7 = infoTipsVosArr.length;
                    while (_local6 < _local7) {
                        if (infoTipsVosArr[_local6].type == NewInfoTipType.TYPE_SKILL){
                            _local3 = true;
                            break;
                        };
                        _local6++;
                    };
                    if (_local3 == false){
                        infoTipsVosArr.push(_local2);
                        _local8 = ((((((GameCommonData.GameInstance.ScreenWidth - 1000) / 2) + 1000) - 723) + 90) + 400);
                        _local9 = (GameCommonData.GameInstance.ScreenHeight - 200);
                        if (infoTipsMcsArr[(infoTipsVosArr.length - 1)]){
                            infoTipsMcsArr[(infoTipsVosArr.length - 1)].x = (_local8 + (_local6 * 40));
                            infoTipsMcsArr[(infoTipsVosArr.length - 1)].y = _local9;
                        };
                    };
                    doPos();
                    break;
                case NewInfoTipNotiName.NEWINFOTIP_SKILL_HIDE:
                    _local7 = infoTipsVosArr.length;
                    while (_local6 < _local7) {
                        if (infoTipsVosArr[_local6].type == NewInfoTipType.TYPE_SKILL){
                            infoTipsVosArr.splice(_local6, 1);
                            break;
                        };
                        _local6++;
                    };
                    doPos();
                    break;
                case NewInfoTipNotiName.NEWINFOTIP_SHENBIN_SHOW:
                    _local2 = new NewInfoTipVo();
                    _local2.title = "神兵可升级";
                    _local2.type = NewInfoTipType.TYPE_SB;
                    _local3 = false;
                    _local7 = infoTipsVosArr.length;
                    while (_local6 < _local7) {
                        if (infoTipsVosArr[_local6].type == NewInfoTipType.TYPE_SB){
                            _local3 = true;
                            break;
                        };
                        _local6++;
                    };
                    if (_local3 == false){
                        infoTipsVosArr.push(_local2);
                        _local8 = ((((((GameCommonData.GameInstance.ScreenWidth - 1000) / 2) + 1000) - 723) + 90) + 400);
                        _local9 = (GameCommonData.GameInstance.ScreenHeight - 200);
                        if (infoTipsMcsArr[(infoTipsVosArr.length - 1)]){
                            infoTipsMcsArr[(infoTipsVosArr.length - 1)].x = (_local8 + (_local6 * 40));
                            infoTipsMcsArr[(infoTipsVosArr.length - 1)].y = _local9;
                        };
                    };
                    doPos();
                    break;
                case NewInfoTipNotiName.NEWINFOTIP_SHENBIN_HIDE:
                    _local7 = infoTipsVosArr.length;
                    while (_local6 < _local7) {
                        if (infoTipsVosArr[_local6].type == NewInfoTipType.TYPE_SB){
                            infoTipsVosArr.splice(_local6, 1);
                            break;
                        };
                        _local6++;
                    };
                    doPos();
                    break;
                case NewInfoTipNotiName.VISIBLE_NEWINFOTIP_UI:
                    Visible = (_arg1.getBody() as Boolean);
                    doPos();
                    break;
                case EventList.RESIZE_STAGE:
                    doPos();
                    break;
            };
        }
        private function showInfo(_arg1:NewInfoTipVo):void{
            switch (((_arg1) && (_arg1.type))){
                case NewInfoTipType.TYPE_TEAMINVITE:
                    sendNotification(TeamEventName.MEMBERINVITESOMEONE, {
                        teamId:_arg1.data.teamId,
                        leaderName:_arg1.data.leaderName
                    });
                    break;
                case NewInfoTipType.TYPE_TRADEINVITE:
                    sendNotification(TradeEvent.SOMEONETRADEME, _arg1.data.targetId);
                    break;
                case NewInfoTipType.TYPE_GUILDINVITE:
                    facade.sendNotification(UnityEvent.INVITE_JOIN, [_arg1.data.guildId, _arg1.data.guildName]);
                    break;
                case NewInfoTipType.TYPE_ADD_ENEMY:
                    facade.sendNotification(FriendCommandList.ADD_ENEMY_FRIEND, {
                        playerId:_arg1.data.playerId,
                        playerName:_arg1.data.playerName
                    });
                    break;
                case NewInfoTipType.TYPE_CHAT:
                    this.sendNotification(FriendCommandList.SHOW_RECEIVE_MSG, _arg1.data.sendId);
                    break;
                case NewInfoTipType.TYPE_DUEL:
                    facade.sendNotification(EventList.SHOWALERT, {
                        comfrim:DuelController.AcceptDuel,
                        params:_arg1.data,
                        comfirmTxt:"同意",
                        cancelTxt:"拒绝",
                        cancel:DuelController.CancelDuel,
                        params_cancel:_arg1.data,
                        info:_arg1.title,
                        title:"提 示"
                    });
                    break;
                case NewInfoTipType.TYPE_FH:
                    facade.sendNotification(EquipCommandList.CLOSE_EQ_PANELS_CHANGE_SENCE);
                    facade.sendNotification(EquipCommandList.SHOW_TREASURESACRIFICE_UI);
                    break;
                case NewInfoTipType.TYPE_SKILL:
                    if (!(facade.retrieveProxy(DataProxy.NAME) as DataProxy).NewSkillIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "skill");
                        (facade.retrieveProxy(DataProxy.NAME) as DataProxy).NewSkillIsOpen = true;
                        facade.sendNotification(EventList.SHOWSKILLVIEW);
                    };
                    break;
                case NewInfoTipType.TYPE_STAR:
                    if (!(facade.retrieveProxy(DataProxy.NAME) as DataProxy).HeroPropIsOpen){
                        facade.sendNotification(EventList.SHOWONLY, "hero");
                        (facade.retrieveProxy(DataProxy.NAME) as DataProxy).HeroPropIsOpen = true;
                        facade.sendNotification(EventList.SHOWHEROPROP, 2);
                    };
                    break;
                case NewInfoTipType.TYPE_SB:
                    if (RolePropDatas.ItemList[ItemConst.ITEM_SUBCLASS_EQUIP_TREASURE]){
                        sendNotification(AutoPlayEventList.QUICK_AUTO_SET);
                    };
                    break;
            };
        }
        private function __loop(_arg1:TimerEvent):void{
            checkEndTime();
        }
        private function doPos():void{
            var targetMc:* = null;
            var toX:* = 0;
            var toY:* = 0;
            var xT:* = (((((GameCommonData.GameInstance.ScreenWidth - 1000) / 2) + 1000) - 723) + 90);
            var yT:* = (GameCommonData.GameInstance.ScreenHeight - 200);
            var i:* = 0;
            var len:* = infoTipsMcsArr.length;
            while ((((i < len)) && ((i < MaxShowCnt)))) {
                targetMc = infoTipsMcsArr[i];
                if (((targetMc) && (infoTipsVosArr[i]))){
                    targetMc["info"] = infoTipsVosArr[i];
                    targetMc.gotoAndStop((NewInfoTipType.McFrames.indexOf(infoTipsVosArr[i].type) + 1));
                    toX = (xT + (i * 40));
                    toY = yT;
                    TweenLite.to(targetMc, 1.5, {
                        x:toX,
                        y:toY
                    });
                    targetMc.visible = ((Visible) && (true));
                    if ((((infoTipsVosArr[i].type == NewInfoTipType.TYPE_CHAT)) && ((infoTipsVosArr[i].data.minimize == false)))){
                        targetMc.alpha = 1;
                        TweenMax.to(targetMc, 1, {
                            alpha:0.5,
                            yoyo:true,
                            repeat:5,
                            ease:Quad.easeInOut,
                            onComplete:function ():void{
                                targetMc.alpha = 1;
                            }
                        });
                    };
                } else {
                    targetMc["info"] = null;
                    targetMc.visible = false;
                };
                i = (i + 1);
            };
            if (!timer.running){
                if (infoTipsVosArr.length > 0){
                    timer.start();
                };
            } else {
                if (infoTipsVosArr.length == 0){
                    timer.stop();
                };
            };
        }
        private function createBtns():void{
            var _local1:MovieClip;
            var _local2:int;
            var _local3:int = MaxShowCnt;
            while (_local2 < _local3) {
                _local1 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("InfoIconBgAsset");
                _local1.buttonMode = true;
                _local1["info"] = null;
                _local1["name"] = ("newinfotips_" + _local2);
                _local1.visible = false;
                infoTipsMcsArr.push(_local1);
                _local1.addEventListener(MouseEvent.CLICK, __clickBtnHandler);
                GameCommonData.GameInstance.GameUI.addChild(infoTipsMcsArr[_local2]);
                _local2++;
            };
        }
        private function checkEndTime():void{
            var _local1:int;
            var _local2:Number = (TimeManager.Instance.Now().time - timeLimit);
            _local1 = 0;
            while (_local1 < infoTipsVosArr.length) {
                if ((((infoTipsVosArr[_local1].addTime > 0)) && ((infoTipsVosArr[_local1].addTime < _local2)))){
                    infoTipsVosArr.splice(_local1, 1);
                    doPos();
                    break;
                };
                _local1++;
            };
        }
        private function initView():void{
            createBtns();
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER, __loop);
        }
        private function __clickBtnHandler(_arg1:MouseEvent):void{
            TweenMax.killTweensOf(_arg1.currentTarget);
            var _local2:int = infoTipsVosArr.indexOf(_arg1.currentTarget["info"]);
            var _local3:NewInfoTipVo = infoTipsVosArr[_local2];
            if (((!((infoTipsVosArr[_local2].type == NewInfoTipType.TYPE_SKILL))) || (!((infoTipsVosArr[_local2].type == NewInfoTipType.TYPE_SB))))){
                infoTipsVosArr.splice(_local2, 1);
                doPos();
            };
            showInfo(_local3);
        }

    }
}//package GameUI.Modules.NewInfoTip.Mediator 
