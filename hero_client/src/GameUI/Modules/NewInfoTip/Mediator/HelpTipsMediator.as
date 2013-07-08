//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewInfoTip.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.Modules.NewGuide.UI.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.Map.SmallMap.Mediator.*;
    import com.greensock.easing.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class HelpTipsMediator extends Mediator {

        public static const NAME:String = "HelpTipsMediator";
        public static const TYPE_REDNAME:String = "TYPE_REDNAME";

        private var tipsQueue:Array;
        private var tf:TaskText;
        private var remindBox:HCheckBox;
        private var _closeBtn:SimpleButton;
        private var titleTf:TextField;
        private var _bg:Bitmap;
        private var tipsMcIsShowing:Boolean;
        private var content:Sprite;
        private var timeOutId:uint;

        public function HelpTipsMediator(){
            tipsQueue = [];
            super(NAME);
        }
        private function __clickCloseHandler(_arg1:MouseEvent=null):void{
            var e = _arg1;
            if (e){
                e.stopImmediatePropagation();
            };
            tipsMcIsShowing = false;
            tipsQueue.shift();
            if (((content) && (content.parent))){
                clearTimeout(timeOutId);
                TweenLite.to(content, 1, {
                    y:GameCommonData.GameInstance.ScreenHeight,
                    ease:Quad.easeIn,
                    onComplete:function ():void{
                        if (((content) && (content.parent))){
                            content.parent.removeChild(content);
                        };
                        if (((!(tipsMcIsShowing)) && ((tipsQueue.length > 0)))){
                            show(tipsQueue[0]);
                        };
                    }
                });
            };
        }
        private function __textClickLink(_arg1:TextEvent):void{
            __clickCloseHandler(null);
        }
        private function pushQueue(_arg1:Object):void{
            tipsQueue.push(_arg1);
            if (((!(tipsMcIsShowing)) && ((tipsQueue.length > 0)))){
                show(tipsQueue[0]);
            };
        }
        private function __contentClickHandler(_arg1:MouseEvent):void{
            var _local2:String = tf.Tf.htmlText.replace(/.*<a href="event:(.*)" TARGET="".*/gi, "$1").replace(/([ ]{1})/g, "");
            if (_local2){
                tf.Tf.dispatchEvent(new TextEvent(TextEvent.LINK, false, false, _local2));
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, HelpTipsNotiName.HELPTIPS_SHOW, HelpTipsNotiName.HELPTIPS_STARCANLEVELUP_SHOW, HelpTipsNotiName.HELPTIPS_MMSHOW, EventList.RESIZE_STAGE]);
        }
        private function getCenterFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.leading = 5;
            _local1.size = 13;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            return (_local1);
        }
        private function checkCanPush(_arg1:Object):Boolean{
            if (_arg1.type == TYPE_REDNAME){
                if (TimeManager.Instance.Now().date == SharedManager.getInstance().rednameTipsDay){
                    return (false);
                };
            };
            return (true);
        }
        private function __reminBoxClickHandler(_arg1:MouseEvent):void{
            SharedManager.getInstance().rednameTipsDay = TimeManager.Instance.Now().date;
            remindBox.selected = true;
            __clickCloseHandler(null);
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:TextFormat;
            var _local3:String;
            var _local4:String;
            var _local5:NewInfoTipVo;
            var _local6:String;
            var _local7:DisplayObject;
            var _local8:String;
            var _local9:String;
            var _local10:String;
            var _local11:String;
            var _local12:Object;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    _bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("LevelUpHelpTipsAsset");
                    _closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseBtn");
                    _closeBtn.x = 199;
                    _closeBtn.y = 150;
                    titleTf = new TextField();
                    _local2 = new TextFormat();
                    _local2.size = 14;
                    _local2.font = LanguageMgr.DEFAULT_FONT;
                    titleTf.defaultTextFormat = _local2;
                    titleTf.text = LanguageMgr.GetTranslation("温馨提示");
                    titleTf.selectable = false;
                    titleTf.x = 10;
                    titleTf.y = 156;
                    titleTf.width = 130;
                    titleTf.textColor = 0xFFB400;
                    tf = new TaskText(215);
                    tf.mouseEnabled = false;
                    tf.x = 10;
                    tf.y = 180;
                    remindBox = new HCheckBox(LanguageMgr.GetTranslation("今天不再提示"));
                    remindBox.x = 110;
                    remindBox.y = 220;
                    content = new Sprite();
                    content.addChild(_bg);
                    content.addChild(_closeBtn);
                    content.addChild(titleTf);
                    content.addChild(tf);
                    content.addChild(remindBox);
                    tf.Tf.addEventListener(TextEvent.LINK, __textClickLink);
                    content.addEventListener(MouseEvent.CLICK, __contentClickHandler);
                    _closeBtn.addEventListener(MouseEvent.CLICK, __clickCloseHandler);
                    remindBox.addEventListener(MouseEvent.CLICK, __reminBoxClickHandler);
                    break;
                case HelpTipsNotiName.HELPTIPS_SHOW:
                    _local3 = _arg1.getBody()["TYPE"];
                    _local4 = _arg1.getBody()["VALUE"];
                    if (((GameCommonData.LevelHelpTipsDic[_local3]) && (GameCommonData.LevelHelpTipsDic[_local3][_local4]))){
                        _local6 = (("<font color=\"#FEE9BA\">" + GameCommonData.LevelHelpTipsDic[_local3][_local4]) + "</font>");
                        pushQueue({
                            title:LanguageMgr.GetTranslation("温馨提示"),
                            text:_local6,
                            align:TextFormatAlign.LEFT
                        });
                    };
                    if (_local3 == "Level"){
                        sendNotification(GetRewardEvent.UPDATE_REWARD_RECORD);
                        sendNotification(GetRewardEvent.UPDATE_REWARDRECORD);
                        switch (int(_local4)){
                            case 13:
                                if (BagData.getCountsByTemplateId(NewGuideData.ITEMTEMPID_NEWBOX10, false) >= 1){
                                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_OPENBOX10);
                                };
                                break;
                            case 28:
                                facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_STARTUP);
                                facade.sendNotification(Guide_AddJobSkillCommand.NAME, {step:1});
                                break;
                            case 35:
                                facade.sendNotification(EventList.SHOW_MAINSENCE_BTN_FLASH, 9);
                                facade.sendNotification(Guide_PetRaceCommand.NAME, 1);
                                break;
                            case 33:
                                if (!((!((GameConfigData.GMUrl == null))) && (!((GameConfigData.GMUrl == ""))))){
                                    (facade.retrieveMediator(SmallMapMediator.NAME) as SmallMapMediator).showGmFlash();
                                    _local7 = (facade.retrieveMediator(SmallMapMediator.NAME) as SmallMapMediator).getViewComponent().mcSmallElment.btns.btn_gm;
                                    JianTouMc.getInstance().show(_local7, LanguageMgr.GetTranslation("点击此处提交问题"), 2).autoClickClean = true;
                                };
                                GuidePicFrame.show(GuidePicFrame.TYPE_PETRACE);
                                break;
                        };
                    } else {
                        if (_local3 == TYPE_REDNAME){
                            facade.sendNotification(HelpTipsNotiName.HELPTIPS_MMSHOW, {
                                content:LanguageMgr.GetTranslation("你红名了哦句"),
                                align:TextFormatAlign.LEFT,
                                title:LanguageMgr.GetTranslation("温馨提示"),
                                type:_local3
                            });
                        };
                    };
                    break;
                case HelpTipsNotiName.HELPTIPS_STARCANLEVELUP_SHOW:
                    _local5 = new NewInfoTipVo();
                    _local5.type = NewInfoTipType.TYPE_STAR;
                    _local5.title = LanguageMgr.GetTranslation("守护学习完成");
                    facade.sendNotification(NewInfoTipNotiName.ADD_INFOTIP, _local5);
                    break;
                case HelpTipsNotiName.HELPTIPS_MMSHOW:
                    if (_arg1.getBody() != null){
                        _local8 = _arg1.getBody()["type"];
                        _local9 = _arg1.getBody()["title"];
                        _local10 = _arg1.getBody()["content"];
                        _local11 = _arg1.getBody()["align"];
                        _local12 = {
                            title:String(_local9),
                            text:String(_local10),
                            align:_local11,
                            type:_local8
                        };
                        if (checkCanPush(_local12)){
                            pushQueue(_local12);
                        };
                    };
                    break;
                case EventList.RESIZE_STAGE:
                    content.x = (GameCommonData.GameInstance.ScreenWidth - content.width);
                    content.y = ((GameCommonData.GameInstance.ScreenHeight - content.height) - 65);
                    break;
            };
        }
        private function show(_arg1:Object):void{
            var _local2:String = _arg1["type"];
            var _local3:TextFormat = getCenterFormat();
            _local3.align = ((_arg1["align"])!=null) ? _arg1["align"] : TextFormatAlign.LEFT;
            tf.Tf.defaultTextFormat = _local3;
            tf.tfText = (("<font color='#ffff00'>" + _arg1.text) + "</font>");
            titleTf.text = _arg1.title;
            content.x = (GameCommonData.GameInstance.ScreenWidth - content.width);
            content.y = GameCommonData.GameInstance.ScreenHeight;
            if (_local2 == TYPE_REDNAME){
                this.remindBox.visible = true;
            } else {
                this.remindBox.visible = false;
            };
            GameCommonData.GameInstance.TooltipLayer.addChild(content);
            TweenLite.to(content, 2, {
                y:(GameCommonData.GameInstance.ScreenHeight - content.height),
                ease:Quad.easeOut
            });
            timeOutId = setTimeout(__clickCloseHandler, 30000);
            tipsMcIsShowing = true;
        }

    }
}//package GameUI.Modules.NewInfoTip.Mediator 
