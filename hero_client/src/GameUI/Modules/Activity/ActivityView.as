//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import flash.net.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Activity.VO.*;
    import Utils.*;
    import Net.RequestSend.*;
    import GameUI.Modules.ScreenMessage.Date.*;
    import GameUI.Modules.TreasureChests.Mediator.*;
    import GameUI.Modules.Activity.Command.*;
    import GameUI.Modules.Activity.UI.*;

    public class ActivityView extends HFrame {

        private const LIMITCOUNT:int = 10;
        private const DELAYTIME:int = 300;

        private var des:TextField;
        private var picContainer:Sprite;
        private var ClearNum:int;
        private var multiple:TextField;
        private var exp:TextField;
        private var chargeContainer:Sprite;
        public var mcSelect:Bitmap;
        private var textParent:Sprite;
        private var activityContainer:Sprite;
        private var welfareBtns:Array;
        private var eiAwardScroll:UIScrollPane;
        private var ruleText:TextField;
        public var actList:Array;
        private var newDes:TextField;
        public var eiBtns:Array;
        private var eiAwardContainer:Sprite;
        public var togArray:Object;
        private var btnFrame:Bitmap;
        private var content:MovieClip;
        private var everyDay:Sprite;
        public var welfare:Sprite;
        private var desContainer:UISprite;
        private var eiScroll:UIScrollPane;
        private var newArray:Array;
        private var childArray:Array;
        private var backPicContainer:Sprite;
        private var awardContainer:Sprite;
        public var RewardID:int;
        private var isLimit:Boolean;
        private var eiAwardInit:Boolean = false;
        private var describe:TextField;
        private var scroll:UIScrollPane;
        private var loginObj:Object;
        private var time:TextField;
        private var welMov:MovieClip;
        private var activityRewardList:ActivityRewardList;
        private var awardpos:uint = 0;
        private var leftAccuDay:int = 0;
        private var back:Sprite;
        private var frameArray:Array;
        public var isIconFlash:Boolean;
        private var everydayCount:int;
        private var updateScroll:UIScrollPane;
        public var getExp:HLabelButton;
        private var chargeBtn:HLabelButton;
        private var continuous:TextField;
        private var leftInter:uint;
        private var _curToggleType:int;
        private var FruitTFList:Dictionary;
        public var awardItemArr:Array;
        public var radioMaskGroup:Array;
        public var radioGroup:Array;
        private var isShowWelfare:Boolean;
        private var everyItemContainer:UISprite;
        private var fiArray:Array;
        public var quickBuy:HLabelButton;
        private var textformat:TextFormat;
        private var acculefttime:TextField;
        private var glowFilter:GlowFilter;
        private var leftTime:uint = 0;
        private var bagIsInit:Boolean = false;
        private var firstArray:Array;
        private var fruitTimer:Timer;
        private var awardBtns:Array;
        private var everydayFin:int;
        private var eiAwardArray:Array;
        private var timeOffset:uint = 0;
        private var firstShow:Boolean = true;
        private var _tryTime:uint = 0;
        public var gridUnit:Sprite;
        public var aiaiA:Array;

        public function ActivityView(){
            textformat = new TextFormat(null, 12, 14074524);
            togArray = {};
            welfareBtns = [];
            awardBtns = [];
            newArray = [11010001, 2, 50100002, 5, 30100002, 99, 30100102, 99, 50700002, 1, 30200001, 1];
            firstArray = [10100004, 3, 70300007, 5, 70200002, 5, 70200001, 2, 70100004, 1, 11010001, 5, 30200009, 3, 10100032, 2];
            awardContainer = new Sprite();
            childArray = [];
            frameArray = [];
            fruitTimer = new Timer(500, 0);
            eiAwardArray = [[50200128, 1], [50200129, 1], [50200130, 1], [50200131, 1], [50200132, 1]];
            eiBtns = [];
            awardItemArr = [];
            FruitTFList = new Dictionary();
            radioGroup = [];
            radioMaskGroup = [];
            glowFilter = new GlowFilter(0xFFCC00, 1, 12, 12, 4);
            fiArray = [];
            aiaiA = [10, 40, 70, 100, 120];
            super();
            fuckView();
        }
        public function setMul(_arg1:Number):void{
            multiple.text = ("X" + _arg1);
        }
        private function showWelFareIcon(_arg1:String, _arg2:uint):void{
            if (((((!((_arg1 == ""))) || ((_arg2 > 0)))) || ((awardBtns[0].label == LanguageMgr.GetTranslation("领取奖励"))))){
                isShowWelfare = true;
            } else {
                isShowWelfare = false;
            };
        }
        public function showGetNewGiftEffect():void{
            if (childArray[1]){
                EffectLib.foodsMove([childArray[1].newGiftBag]);
            };
        }
        private function onActivityClick(_arg1:MouseEvent):void{
            var _local2:NewActivityItem = (_arg1.currentTarget as NewActivityItem);
            updateRule(_local2.getData().rule);
            updateAward(_local2.getData().award);
            _local2.addChildSelect(mcSelect);
        }
        public function toggleFit():void{
            if (!eiAwardInit){
                initEIAwards();
            };
            isLimit = true;
            if (firstShow){
                this.visible = false;
                ClearNum = setTimeout(showDelayPanel, DELAYTIME);
            } else {
                togArray["8"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }
        public function updateEveryProgress(_arg1:uint=0, _arg2:int=0):void{
            var _local3:int;
            var _local4:int;
            everydayCount = _arg1;
            everydayFin = _arg2;
            everyDay["currentFin"].text = ("" + everydayFin);
            var _local5:int = awardItemArr.length;
            _local3 = 0;
            while (_local3 < aiaiA.length) {
                if (everydayFin < aiaiA[_local3]){
                    _local4 = _local3;
                    break;
                };
                _local3++;
            };
            switch (_local4){
                case 0:
                case 1:
                    everyDay["tips"].text = LanguageMgr.GetTranslation("Act15");
                    RewardID = 1;
                    break;
                case 2:
                    everyDay["tips"].text = LanguageMgr.GetTranslation("Act16");
                    RewardID = 2;
                    break;
                case 3:
                    everyDay["tips"].text = LanguageMgr.GetTranslation("Act17");
                    RewardID = 3;
                    break;
                case 4:
                    everyDay["tips"].text = LanguageMgr.GetTranslation("Act18");
                    RewardID = 4;
                    break;
            };
            if (everydayFin >= 120){
                everyDay["tips"].text = LanguageMgr.GetTranslation("Act19");
                RewardID = 5;
            };
            _local3 = 0;
            while (_local3 < _local5) {
                if ((((_local3 < _local4)) || ((everydayCount >= 12)))){
                    awardItemArr[_local3].setItemEnable(true);
                } else {
                    awardItemArr[_local3].setItemEnable(false);
                };
                _local3++;
            };
        }
        public function updateAccuLeft(_arg1:int):void{
            leftAccuDay = _arg1;
            clearInterval(leftInter);
            leftInter = setInterval(updateAccuLeftFun, 1000);
        }
        private function clearFilter():void{
            var _local1:int;
            while (_local1 < frameArray.length) {
                frameArray[_local1].filters = [];
                _local1++;
            };
        }
        public function setTime(_arg1:String):void{
            _arg1 = _arg1.replace(LanguageMgr.GetTranslation("离线"), "");
            time.text = _arg1;
            time.textColor = 0xFF0000;
            showWelFareIcon(time.text, leftTime);
        }
        private function handleActivityVO(_arg1:ActivityVO):void{
            var _local7:int;
            var _local2:ActivityVO = _arg1;
            var _local3:Date = TimeManager.Instance.ServerData();
            var _local4:uint = _local3.getHours();
            var _local5:uint = _local3.getMinutes();
            var _local6:uint = ((_local4 * 60) + _local5);
            _local2.currentType = 1;
            if ((((_local6 <= uint(_local2.endArr[(_local2.endArr.length - 1)]))) && ((_local2.current < _local2.total)))){
                _local2.currentType = 0;
            };
        }
        public function setDes(_arg1:String, _arg2:Boolean=false):void{
            if (describe.parent){
                describe.parent.removeChild(describe);
            };
            if (textParent){
                while (textParent.numChildren > 0) {
                    textParent.removeChildAt(0);
                };
                if (textParent.parent){
                    textParent.parent.removeChild(textParent);
                };
            };
            textParent = new Sprite();
            content.addChild(textParent);
            newDes = new TextField();
            newDes.x = describe.x;
            newDes.y = describe.y;
            newDes.width = describe.width;
            newDes.height = describe.height;
            newDes.mouseEnabled = false;
            newDes.wordWrap = true;
            newDes.multiline = true;
            newDes.defaultTextFormat = content.describe.getTextFormat();
            textParent.addChild(newDes);
            newDes.text = _arg1;
            if (_arg2){
                ShowMoney.ShowIcon2(textParent, newDes, false);
            };
        }
        public function setExp(_arg1:String):void{
            exp.text = _arg1;
            if (UIUtils.TrimString(exp.text, 3) == "0"){
                getExp.enable = false;
                setExpEffect(false);
            } else {
                getExp.enable = true;
                setExpEffect(true);
            };
        }
        public function toggleOne(_arg1:uint):void{
            togArray[String(ActivityConstants.toggleIndexs[(_arg1 - 1)])].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        private function clearElements(_arg1:DisplayObjectContainer):void{
            var _local2:int;
            while (_arg1.numChildren > 0) {
                _arg1.removeChildAt(0);
            };
            _arg1.height = 1;
        }
        public function EnableChargeBtns():void{
            childArray[3].EnableChargeBtns();
        }
        public function set tryTime(_arg1:uint):void{
            _tryTime = _arg1;
            updateLoginDays(_arg1);
        }
        private function fun3(_arg1:uint):void{
            firstShow = false;
            autoClickItem(_arg1);
            this.visible = true;
        }
        private function onWBtnMouseOver(_arg1:MouseEvent):void{
            if (btnFrame != null){
                _arg1.currentTarget.addChild(btnFrame);
            };
            btnFrame.x = -3;
            btnFrame.y = -5;
        }
        public function updateLoginDays(_arg1:int):void{
            if (_arg1 != -1){
                _tryTime = _arg1;
            };
            var _local2:uint = GameCommonData.LoginDays;
            if (_local2 == 0){
                _local2 = 1;
            };
            var _local3:int = ((_local2 > 3)) ? 3 : _local2;
            leftTime = (_local3 - _tryTime);
            continuous.htmlText = leftTime.toString();
            continuous.textColor = 0xFFFFFF;
            if (leftTime <= 0){
                UIFacade.GetInstance().sendNotification(GetRewardEvent.HIDE_LOGINREWARD_BTN);
            };
            if (time){
                showWelFareIcon(time.text, leftTime);
            } else {
                showWelFareIcon("", leftTime);
            };
        }
        public function toggleWelfare(_arg1:uint):void{
            togArray["4"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            welfareBtns[(_arg1 - 1)].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        private function fun2(_arg1:int):void{
            firstShow = false;
            this.visible = true;
            welfareBtns[_arg1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        public function onTogClick(_arg1:MouseEvent=null):void{
            var _local2:String;
            if (firstShow){
                clearTimeout(ClearNum);
                setTimeout(fun1, (DELAYTIME + 1), _arg1.currentTarget.name);
                return;
            };
            for (_local2 in togArray) {
                togArray[_local2].selected = false;
            };
            if (((((((((!(isIconFlash)) && (isLimit))) && (isShowWelfare))) && (_arg1))) && (!((_arg1.currentTarget.name == 4))))){
                toggleWelfare(1);
                return;
            };
            if (_arg1 != null){
                _arg1.currentTarget.selected = true;
                setExpEffect(false);
                _curToggleType = int(_arg1.currentTarget.name);
                updateActivity();
                if (_arg1.currentTarget.name == 4){
                    setExpEffect(true);
                    welfare.visible = true;
                    everyDay.visible = false;
                    scroll.visible = false;
                    back.visible = false;
                    activityRewardList.visible = false;
                    picContainer.visible = false;
                    awardContainer.visible = true;
                    welfareBtns[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                } else {
                    if (_arg1.currentTarget.name == 8){
                        welfare.visible = false;
                        everyDay.visible = true;
                        scroll.visible = false;
                        back.visible = false;
                        activityRewardList.visible = false;
                        picContainer.visible = false;
                        awardContainer.visible = false;
                        if (!eiAwardInit){
                            initEIAwards();
                        };
                    } else {
                        welfare.visible = false;
                        everyDay.visible = false;
                        scroll.visible = true;
                        back.visible = true;
                        activityRewardList.visible = true;
                        picContainer.visible = true;
                        awardContainer.visible = false;
                    };
                };
            } else {
                welfare.visible = false;
                everyDay.visible = false;
                scroll.visible = true;
                back.visible = true;
                activityRewardList.visible = true;
                picContainer.visible = true;
                awardContainer.visible = false;
                welMov.gotoAndStop(1);
            };
            isLimit = false;
        }
        private function fun1(_arg1:String):void{
            firstShow = false;
            togArray[_arg1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            this.visible = true;
        }
        private function initEIAwards():void{
            var _local2:Array;
            var _local3:AIAwardItem;
            eiAwardInit = true;
            awardItemArr = [];
            var _local1:int;
            while (_local1 < eiAwardArray.length) {
                _local2 = eiAwardArray[_local1];
                _local3 = new AIAwardItem();
                _local3.setText((LanguageMgr.GetTranslation("需要活跃度") + aiaiA[_local1]));
                _local3.setAward(_local2);
                eiAwardContainer.addChild(_local3);
                awardItemArr.push(_local3);
                _local1++;
            };
            updateEveryProgress(everydayCount, everydayFin);
            showElements2(eiAwardContainer);
        }
        private function initTogBtn():void{
            var _local1:uint = 12;
            var _local2:ToggleButton = new ToggleButton(1, LanguageMgr.GetTranslation("每日必做"));
            this.addChild(_local2);
            _local2.x = _local1;
            _local1 = ((_local2.width + _local2.x) + 2);
            _local2.y = 36;
            _local2.name = "8";
            _local2.addEventListener(MouseEvent.CLICK, onTogClick);
            togArray[_local2.name] = _local2;
            _local2 = new ToggleButton(0, LanguageMgr.GetTranslation("经 验"));
            this.addChild(_local2);
            _local2.x = _local1;
            _local1 = ((_local2.width + _local2.x) + 2);
            _local2.y = 36;
            _local2.name = "2";
            _local2.addEventListener(MouseEvent.CLICK, onTogClick);
            togArray[_local2.name] = _local2;
            _local2 = new ToggleButton(0, LanguageMgr.GetTranslation("赚 钱"));
            this.addChild(_local2);
            _local2.x = _local1;
            _local1 = ((_local2.width + _local2.x) + 2);
            _local2.y = 36;
            _local2.name = "3";
            _local2.addEventListener(MouseEvent.CLICK, onTogClick);
            togArray[_local2.name] = _local2;
            _local2 = new ToggleButton(0, LanguageMgr.GetTranslation("装 备"));
            this.addChild(_local2);
            _local2.x = _local1;
            _local1 = ((_local2.width + _local2.x) + 2);
            _local2.y = 36;
            _local2.name = "5";
            _local2.addEventListener(MouseEvent.CLICK, onTogClick);
            togArray[_local2.name] = _local2;
            _local2 = new ToggleButton(0, LanguageMgr.GetTranslation("道 具"));
            this.addChild(_local2);
            _local2.x = _local1;
            _local1 = ((_local2.width + _local2.x) + 2);
            _local2.y = 36;
            _local2.name = "7";
            _local2.addEventListener(MouseEvent.CLICK, onTogClick);
            togArray[_local2.name] = _local2;
            _local2 = new ToggleButton(0, LanguageMgr.GetTranslation("福 利"));
            this.addChild(_local2);
            _local2.x = _local1;
            _local1 = ((_local2.width + _local2.x) + 2);
            _local2.y = 36;
            _local2.name = "4";
            _local2.addEventListener(MouseEvent.CLICK, onTogClick);
            togArray[_local2.name] = _local2;
            var _local3:HLabelButton = new HLabelButton();
            _local3.label = LanguageMgr.GetTranslation("试试手气");
            _local3.x = 250;
            _local3.y = 350;
            _local3.name = "all";
            _local3.addEventListener(MouseEvent.CLICK, onGetAward);
            childArray[0].addChild(_local3);
            awardBtns.push(_local3);
            FruitTFList["dayaward"] = _local3;
            var _local4:HLabelButton = new HLabelButton();
            _local4.label = LanguageMgr.GetTranslation("全部完成");
            _local4.x = 495;
            _local4.y = 374;
            _local4.name = "quickfin";
            everyDay.addChild(_local4);
            eiBtns.push(_local4);
            var _local5:HLabelButton = new HLabelButton();
            _local5.label = LanguageMgr.GetTranslation("领取奖励");
            _local5.x = 580;
            _local5.y = 374;
            _local5.name = "quickget";
            _local5.container.name = "quickget";
            everyDay.addChild(_local5);
            eiBtns.push(_local5);
            _local3 = new HLabelButton();
            _local3.label = LanguageMgr.GetTranslation("领取礼包");
            _local3.x = 300;
            _local3.y = 150;
            _local3.name = "new";
            _local3.addEventListener(MouseEvent.CLICK, onGetAward);
            childArray[1].addChild(_local3);
            awardBtns.push(_local3);
            _local3 = new HLabelButton();
            _local3.label = LanguageMgr.GetTranslation("领取礼包");
            _local3.x = (227 - 57);
            _local3.y = 130;
            _local3.name = "first";
            _local3.addEventListener(MouseEvent.CLICK, onGetAward);
            childArray[2].addChild(_local3);
            awardBtns.push(_local3);
            _local3 = new HLabelButton();
            _local3.label = LanguageMgr.GetTranslation("领取激活码");
            _local3.x = 156;
            _local3.y = 150;
            _local3.name = "getCode";
            _local3.addEventListener(MouseEvent.CLICK, onGetAward);
            childArray[1].addChild(_local3);
            awardBtns.push(_local3);
        }
        private function initOffline():void{
            var _local1 = 1;
            while (_local1 < 4) {
                content[("offbtn" + _local1)].stop();
                radioGroup.push(content[("offbtn" + _local1)]);
                content[("offbtn" + _local1)].nextFrame();
                content[("offbtn" + _local1)].prevFrame();
                _local1++;
            };
            radioGroup[2].nextFrame();
            _local1 = 1;
            while (_local1 < 4) {
                radioMaskGroup.push(content[("mask_" + _local1)]);
                _local1++;
            };
            describe = content.describe;
            describe.mouseEnabled = false;
            describe.text = LanguageMgr.GetTranslation("使用离线经验卡");
            exp = content.exp;
            multiple = content.multiple;
            exp.text = "0";
            getExp = new HLabelButton();
            getExp.label = LanguageMgr.GetTranslation("领取");
            getExp.x = 498;
            getExp.y = 132;
            content.addChild(getExp);
            setExp(exp.text);
            quickBuy = new HLabelButton();
            quickBuy.label = LanguageMgr.GetTranslation("购 买");
            quickBuy.x = 498;
            quickBuy.y = 340;
            content.addChild(quickBuy);
            time = new TextField();
            time.setTextFormat(describe.getTextFormat());
            time.x = 442;
            time.y = 82;
            content.addChild(time);
            time.width = 119;
            time.autoSize = TextFieldAutoSize.CENTER;
            time.selectable = false;
        }
        public function onTestStop(_arg1:int):void{
            var _local2:int;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            if (fruitTimer.running){
                _local2 = 1;
                _local3 = fruitTimer.currentCount;
                _local4 = (_arg1 - 1);
                awardpos = (((_arg1 + 22) - 1) % 22);
                _local5 = ((_local4 + (22 * _local2)) - (_local3 % 22));
                timeOffset = _local5;
                if (timeOffset < LIMITCOUNT){
                    timeOffset = (timeOffset + 22);
                };
                fruitTimer.removeEventListener(TimerEvent.TIMER, onFruitTimer);
                fruitTimer.stop();
                fruitTimer.addEventListener(TimerEvent.TIMER, onFruitStop);
                fruitTimer.start();
            } else {
                awardpos = (((_arg1 + 22) - 1) % 22);
                clearFilter();
                frameArray[awardpos].filters = [glowFilter];
                awardBtns[0].removeEventListener(MouseEvent.CLICK, onGetAward);
                awardBtns[0].enable = true;
                awardBtns[0].addEventListener(MouseEvent.CLICK, onGetAward2);
                awardBtns[0].label = LanguageMgr.GetTranslation("领取奖励");
                centerOne();
            };
        }
        private function updateAccuLeftFun():void{
            var _local1:Date;
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            if (leftAccuDay > 0){
                _local1 = TimeManager.Instance.Now();
                _local2 = (leftAccuDay - 1);
                _local3 = (23 - _local1.hours);
                _local4 = (59 - _local1.minutes);
                _local5 = (59 - _local1.seconds);
                acculefttime.htmlText = LanguageMgr.GetTranslation("活动剩余时间", _local2, _local3, _local4, _local5);
            } else {
                acculefttime.text = LanguageMgr.GetTranslation("已结束");
            };
        }
        private function fuckView():void{
            var _local4:MovieClip;
            var _local5:DisplayObject;
            var _local6:int;
            showClose = true;
            titleText = LanguageMgr.GetTranslation("活 动");
            centerTitle = true;
            blackGound = false;
            chargeContainer = new Sprite();
            back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("ActivityBack");
            this.addChild(back);
            back.x = 4;
            back.y = 28;
            everyDay = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("ActivityEvery");
            everyDay["tips"].mouseEnabled = false;
            everyDay.x = 4;
            everyDay.y = 54;
            welfare = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("activitywelfare");
            welfare.x = 4;
            welfare.y = 54;
            backPicContainer = welfare["backPicContainer"];
            btnFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("RankFrame");
            var _local1:int;
            while (_local1 < 5) {
                _local4 = welfare[("abtn_" + _local1)];
                welfareBtns.push(_local4);
                _local4.stop();
                _local4.addEventListener(MouseEvent.MOUSE_OVER, onWBtnMouseOver);
                _local4.addEventListener(MouseEvent.MOUSE_OUT, onWBtnMouseOut);
                _local4.addEventListener(MouseEvent.CLICK, onWBtnClick);
                _local1++;
            };
            welMov = welfare["activitymov"];
            var _local2 = 1;
            while (_local2 < 6) {
                _local5 = welMov.getChildByName(("child" + _local2));
                if (_local5.parent){
                    _local5.parent.removeChild(_local5);
                };
                if (_local2 == 1){
                    _local6 = 0;
                    while (_local6 < 4) {
                        FruitTFList[("child" + _local6)] = _local5[("child" + _local6)];
                        _local6++;
                    };
                    FruitTFList["child3"].htmlText = (("<u><a href=\"event:detailLink\">" + LanguageMgr.GetTranslation("详情点击")) + "</a></u>");
                };
                if (_local2 == 4){
                    _local5 = new TopUpTotalView();
                    _local5.x = 7;
                    _local5.y = 7;
                };
                childArray.push(_local5);
                _local2++;
            };
            welMov.addChild(childArray[0]);
            content = childArray[0];
            var _local3:int;
            while (_local3 < 22) {
                frameArray.push(childArray[0][("aframe_" + _local3)]);
                _local3++;
            };
            childArray[3].addChild(chargeContainer);
            chargeContainer.x = 7;
            chargeContainer.y = 340;
            chargeBtn = new HLabelButton();
            chargeBtn.label = LanguageMgr.GetTranslation("快速充值");
            chargeBtn.x = (247 + 53);
            chargeBtn.y = 130;
            childArray[2].addChild(chargeBtn);
            chargeBtn.addEventListener(MouseEvent.CLICK, onChargeBtnClick);
            acculefttime = childArray[3].acculefttime;
            frameArray.push(childArray[0]["awardframe"]);
            this.addChild(welfare);
            welfare.visible = false;
            this.addChild(everyDay);
            everyDay.visible = false;
            continuous = new TextField();
            continuous.x = 80;
            continuous.y = 337;
            continuous.width = 40;
            continuous.height = 20;
            childArray[0].addChild(continuous);
            continuous.selectable = false;
            FruitTFList["continuous"] = continuous;
            activityContainer = new UISprite();
            activityContainer.width = 475;
            activityContainer.height = 1;
            scroll = new UIScrollPane(activityContainer);
            scroll.x = 13;
            scroll.y = 58;
            scroll.width = 490;
            scroll.height = 406;
            scroll.scrollPolicy = UIScrollPane.SCROLLBAR_ALWAYS;
            scroll.refresh();
            this.addChild(scroll);
            scroll.MouseWheel = true;
            ruleText = new TextField();
            ruleText.x = (450 + 63);
            ruleText.y = (75 - 28);
            ruleText.width = 170;
            ruleText.height = 140;
            ruleText.wordWrap = true;
            ruleText.multiline = true;
            back.addChild(ruleText);
            updateRule(LanguageMgr.GetTranslation("点击活动可以查看活动详细规则"));
            picContainer = new Sprite();
            picContainer.x = (446 + 63);
            picContainer.y = 60;
            this.addChild(picContainer);
            activityRewardList = new ActivityRewardList();
            activityRewardList.x = 518;
            activityRewardList.y = 270;
            this.addChild(activityRewardList);
            initEvery();
            initMcSelect();
            initTogBtn();
            gridUnit = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
            initOffline();
            if (GameCommonData.openServerDate > 10){
                welfare["rewardTxt"].text = LanguageMgr.GetTranslation("充值反馈礼包");
            } else {
                welfare["rewardTxt"].text = LanguageMgr.GetTranslation("新服充值反馈");
            };
            welfare["rewardTxt"].mouseEnabled = false;
            setSize(702, 472);
        }
        public function startFruit():void{
            if (!fruitTimer.running){
                fruitTimer.repeatCount = 0;
                fruitTimer.addEventListener(TimerEvent.TIMER, onFruitTimer);
                fruitTimer.delay = 1000;
                fruitTimer.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
                fruitTimer.start();
            };
        }
        public function setTit(_arg1:String):void{
        }
        private function onFruitTimer(_arg1:TimerEvent):void{
            clearFilter();
            var _local2:Timer = (_arg1.currentTarget as Timer);
            var _local3:uint = _local2.currentCount;
            _local3 = (_local3 % 22);
            frameArray[_local3].filters = [glowFilter];
            _local2.delay = (uint((_local2.delay / 2)) + 15);
        }
        public function openWelfare(_arg1:uint):void{
            if (!welfareBtns[_arg1]){
                _arg1 = 0;
            };
            welfareBtns[_arg1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        public function updateUpdate(_arg1:XML):void{
            var _local4:*;
            var _local5:TextFormat;
            desContainer = new UISprite();
            desContainer.width = 510;
            des = new TextField();
            var _local2 = 1;
            var _local3 = "";
            for each (_local4 in _arg1.elements()) {
                _local3 = (_local3 + _local4);
                _local3 = (_local3 + "\n");
                _local2 = (_local2 + 18);
            };
            des.autoSize = TextFieldAutoSize.LEFT;
            des.selectable = false;
            des.multiline = true;
            des.wordWrap = true;
            des.textColor = 0xFFFFFF;
            des.htmlText = _local3;
            des.width = 510;
            des.height = _local2;
            _local5 = des.getTextFormat();
            _local5.leading = 3;
            des.setTextFormat(_local5);
            desContainer.height = des.height;
            desContainer.addChild(des);
            updateScroll = new UIScrollPane(desContainer);
            updateScroll.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            updateScroll.x = 15;
            updateScroll.y = 35;
            updateScroll.width = 548;
            updateScroll.height = 342;
            updateScroll.refresh();
            updateScroll.scrollTop();
            childArray[4].addChild(updateScroll);
        }
        public function get CurToggleType():int{
            return (_curToggleType);
        }
        public function updateActivity():Array{
            var _local3:NewActivityItem;
            var _local4:ActivityVO;
            clearElements(activityContainer);
            disposeActList();
            updateRule(LanguageMgr.GetTranslation("点击活动可以查看活动详细规则"));
            activityRewardList.setRewardListInfo([new Array()]);
            var _local1:Array = [];
            var _local2:Array = [];
            for each (_local4 in GameCommonData.ActivityList) {
                if (((!((_curToggleType == 0))) && ((_local4.type == _curToggleType)))){
                    handleActivityVO(_local4);
                    if (_local4.currentType == 0){
                        _local1.push(_local4);
                    } else {
                        _local2.push(_local4);
                    };
                };
            };
            while (_local2.length > 0) {
                _local1.push(_local2.shift());
            };
            for each (_local4 in _local1) {
                _local3 = new NewActivityItem(_local4);
                _local3.addEventListener(MouseEvent.CLICK, onActivityClick);
                actList.push(_local3);
                activityContainer.addChild(_local3);
            };
            showElements(activityContainer);
            scroll.refresh();
            return (actList);
        }
        public function get EveryDayCount():int{
            return (everydayCount);
        }
        public function clearCenter():void{
            var _local2:DisplayObjectContainer;
            var _local3:DisplayObject;
            var _local1:int;
            while (_local1 < childArray[0].numChildren) {
                _local2 = (childArray[0] as DisplayObjectContainer);
                _local3 = childArray[0].getChildAt(_local1);
                if (((_local3) && ((_local3 is FaceItem)))){
                    if (_local3.parent){
                        EffectLib.foodsMove([_local3]);
                        _local3.parent.removeChild(_local3);
                    };
                };
                _local1++;
            };
        }
        private function onWBtnClick(_arg1:MouseEvent):void{
            var _local2:MovieClip;
            if (firstShow){
                clearTimeout(ClearNum);
                setTimeout(fun2, (DELAYTIME + 2), int(_arg1.currentTarget.name.split("_")[1]));
                return;
            };
            for each (_local2 in welfareBtns) {
                _local2.prevFrame();
            };
            _arg1.currentTarget.nextFrame();
            while (welMov.numChildren > 0) {
                welMov.removeChildAt(0);
            };
            var _local3:uint = uint(_arg1.currentTarget.name.split("_")[1]);
            welMov.addChild(childArray[_local3]);
            setExpEffect(false);
            if (_local3 == 0){
                initAward([]);
                setExpEffect(true);
                setLeftTimeVisible();
            } else {
                if (_local3 == 1){
                    initAward(newArray);
                } else {
                    if (_local3 == 2){
                        initAward(firstArray);
                    } else {
                        if (_local3 == 3){
                            initAward([]);
                            if (GameCommonData.accuChargeId == 0){
                                welMov.removeChild(childArray[_local3]);
                            };
                        } else {
                            if (_local3 == 4){
                                initAward([]);
                            };
                        };
                    };
                };
            };
        }
        public function updateGoldView():void{
            childArray[3].updateGoldView();
        }
        private function updateAward(_arg1:Array):void{
            activityRewardList.setRewardListInfo(_arg1);
        }
        private function onFruitStop(_arg1:TimerEvent):void{
            if (timeOffset == 0){
                fruitTimer.removeEventListener(TimerEvent.TIMER, onFruitStop);
                fruitTimer.stop();
                awardBtns[0].removeEventListener(MouseEvent.CLICK, onGetAward);
                awardBtns[0].enable = true;
                awardBtns[0].addEventListener(MouseEvent.CLICK, onGetAward2);
                centerOne();
                return;
            };
            timeOffset--;
            clearFilter();
            var _local2:Timer = (_arg1.currentTarget as Timer);
            var _local3:uint = _local2.currentCount;
            _local3 = (_local3 % 22);
            frameArray[_local3].filters = [glowFilter];
            if (timeOffset <= LIMITCOUNT){
                _local2.delay = (_local2.delay + 50);
            };
        }
        private function showElements(_arg1:DisplayObjectContainer):void{
            var _local2:DisplayObject;
            var _local4:int;
            var _local6:int;
            var _local3:Number = 5;
            var _local5:Array = [];
            while (_local6 < _arg1.numChildren) {
                _local5.push(_arg1.getChildAt(_local6));
                _local6++;
            };
            while (_local4 < _local5.length) {
                _local2 = _local5[_local4];
                _local2.y = _local3;
                _local3 = (_local3 + 81);
                _arg1.height = _local3;
                _local4++;
            };
            this.addChild(scroll);
        }
        private function onChargeBtnClick(_arg1:MouseEvent):void{
            if (GameConfigData.GamePay != ""){
                navigateToURL(new URLRequest(GameConfigData.GamePay), "_blank");
            };
        }
        private function showDelayPanel():void{
            firstShow = false;
            togArray["8"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            this.visible = true;
        }
        private function initAward(_arg1:Array):void{
            var _local3:Sprite;
            var _local4:FaceItem;
            while (awardContainer.numChildren > 0) {
                awardContainer.removeChildAt(0);
            };
            var _local2:int;
            while (_local2 < _arg1.length) {
                _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local4 = new FaceItem(_arg1[_local2], _local3);
                _local4.setNum(_arg1[(_local2 + 1)]);
                _local4.mouseChildren = false;
                _local4.mouseEnabled = false;
                _local3.x = ((_local2 * 25) + 170);
                _local3.y = 380;
                _local3.addChild(_local4);
                _local3.name = ("target_" + _arg1[_local2]);
                awardContainer.addChild(_local3);
                _local2 = (_local2 + 2);
            };
            this.addChild(awardContainer);
        }
        public function toggleCharge():void{
            togArray["4"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            welfareBtns[3].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        private function disposeActList():void{
            var _local1:NewActivityItem;
            for each (_local1 in actList) {
                _local1.removeEventListener(MouseEvent.CLICK, onActivityClick);
                _local1.dispose();
            };
            actList = [];
        }
        public function enableTry():void{
            awardBtns[0].enable = true;
            awardBtns[0].label = LanguageMgr.GetTranslation("试试手气");
            awardBtns[0].addEventListener(MouseEvent.CLICK, onGetAward);
            awardBtns[0].enable = true;
            awardBtns[0].removeEventListener(MouseEvent.CLICK, onGetAward2);
            setLeftTimeVisible();
        }
        private function onGetAward2(_arg1:MouseEvent):void{
            ActivitySend.sendActivityTry(3);
        }
        public function updateLoginDay(_arg1:Object):void{
            var _local4:FaceItem;
            loginObj = _arg1;
            var _local2:int;
            while (_local2 < fiArray.length) {
                if (fiArray[_local2].parent){
                    fiArray[_local2].parent.removeChild(fiArray[_local2]);
                };
                _local2++;
            };
            var _local3:int;
            while (_local3 < 22) {
                _local4 = new FaceItem(_arg1[_local3].itemid, null, "bagIcon", 1, _arg1[_local3].itemcount);
                _local4.setNum(_arg1[_local3].itemcount);
                _local4.x = 1;
                _local4.y = 1;
                _local4.mouseEnabled = true;
                _local4.mouseChildren = true;
                _local4.name = ("target_" + _arg1[_local3].itemid);
                frameArray[_local3].addChild(_local4);
                fiArray.push(_local4);
                _local3++;
            };
        }
        public function updateRule(_arg1:String):void{
            this.ruleText.htmlText = (("<font color='#d6c29c'>" + _arg1) + "</font>");
            ruleText.selectable = false;
        }
        private function initMcSelect():void{
            mcSelect = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("ItemSelect");
            mcSelect.y = 0;
            mcSelect.x = -1;
        }
        private function onWBtnMouseOut(_arg1:MouseEvent):void{
            if (((!((btnFrame == null))) && (!((btnFrame.parent == null))))){
                btnFrame.parent.removeChild(btnFrame);
            };
        }
        private function showElements2(_arg1:DisplayObjectContainer):void{
            var _local2:DisplayObject;
            var _local4:int;
            var _local3:Number = 1;
            while (_local4 < _arg1.numChildren) {
                _local2 = _arg1.getChildAt(_local4);
                _local2.y = _local3;
                if (_arg1 == everyItemContainer){
                    _local3 = (_local3 + 40);
                } else {
                    if (_arg1 == eiAwardContainer){
                        _local3 = (_local3 + 55);
                    };
                };
                _arg1.height = _local3;
                _local4++;
            };
        }
        private function setLeftTimeVisible():void{
            var _local1:String;
            for (_local1 in FruitTFList) {
                FruitTFList[_local1].visible = false;
            };
            if ((((leftTime > 0)) || ((awardBtns[0].label == LanguageMgr.GetTranslation("领取奖励"))))){
                FruitTFList["child0"].visible = true;
                FruitTFList["child1"].visible = true;
                FruitTFList["continuous"].visible = true;
                FruitTFList["dayaward"].visible = true;
                FruitTFList["child3"].removeEventListener(TextEvent.LINK, detailLink);
            } else {
                FruitTFList["child2"].visible = true;
                FruitTFList["child3"].visible = true;
                FruitTFList["child3"].addEventListener(TextEvent.LINK, detailLink);
            };
        }
        private function onGetAward(_arg1:MouseEvent):void{
            var obj:* = null;
            var event:* = _arg1;
            switch (event.currentTarget.name){
                case "day":
                    break;
                case "all":
                    if (((!(fruitTimer.running)) && ((leftTime > 0)))){
                        setTimeout(ActivitySend.sendActivityTry, 2000, 2);
                        startFruit();
                        event.currentTarget.label = LanguageMgr.GetTranslation("领取奖励");
                        event.currentTarget.enable = false;
                    };
                    if (leftTime == 0){
                        UIFacade.GetInstance().sendNotification(ScreenMessageEvent.ADD_BIGMESSAGE, LanguageMgr.GetTranslation("当天激活码用完"));
                    };
                    break;
                case "new":
                    obj = new Object();
                    obj.boxMessage = LanguageMgr.GetTranslation("请输入活动激活码");
                    obj.linkId = 0;
                    obj.npcID = 0;
                    UIFacade.GetInstance().registerMediator(new XinShouLiBaoMediator());
                    UIFacade.GetInstance().sendNotification(EventList.SHOW_NEW_GIFT, obj);
                    break;
                case "first":
                    if (((!((GameCommonData.NewAndCharge == 0))) && (((GameCommonData.NewAndCharge & 2) == 0)))){
                        CharacterSend.GetReward(3000);
                    } else {
                        if ((GameCommonData.NewAndCharge & 1) == 0){
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:function ():void{
                                    navigateToURL(new URLRequest(GameConfigData.GamePay));
                                },
                                cancel:function ():void{
                                },
                                info:LanguageMgr.GetTranslation("未充值无法领取大包"),
                                title:LanguageMgr.GetTranslation("提 示")
                            });
                        };
                    };
                    if (childArray[2]){
                        EffectLib.foodsMove([childArray[2].firstGiftBag]);
                    };
                    break;
                case "getCode":
                    navigateToURL(new URLRequest(GameConfigData.ActivityCodePath));
                    break;
            };
        }
        public function handleBtnEnable():void{
            if ((GameCommonData.NewAndCharge & 3) == 1){
                awardBtns[2].enable = true;
            } else {
                if ((GameCommonData.NewAndCharge & 3) == 0){
                    awardBtns[2].enable = false;
                } else {
                    if ((GameCommonData.NewAndCharge & 3) == 3){
                        awardBtns[2].enable = false;
                        awardBtns[2].label = LanguageMgr.GetTranslation("已领取");
                        UIFacade.GetInstance().sendNotification(EventList.SHOW_CHARGE_CHEST, false);
                    };
                };
            };
            if ((GameCommonData.NewAndCharge & 4) != 0){
                awardBtns[1].enable = false;
                awardBtns[1].label = LanguageMgr.GetTranslation("已领取");
            } else {
                awardBtns[1].enable = true;
            };
            if ((GameCommonData.activityData[50] & 8) != 0){
            };
        }
        public function autoClickItem(_arg1:uint):void{
            if (firstShow){
                clearTimeout(ClearNum);
                setTimeout(fun3, (DELAYTIME + 2), _arg1);
                return;
            };
            if (((((actList) && (actList[(_arg1 - 1)]))) && (actList[(_arg1 - 1)]))){
                (actList[(_arg1 - 1)] as NewActivityItem).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
            if (_arg1 > 5){
                scroll.scrollBottom();
                scroll.refresh();
            };
        }
        private function centerOne():void{
            var _local1:FaceItem;
            if ((((awardpos >= 0)) && (!((loginObj == null))))){
                _local1 = new FaceItem(loginObj[awardpos].itemid, null, "bagIcon", 1, loginObj[awardpos].itemcount);
                _local1.setNum(loginObj[awardpos].itemcount);
                _local1.x = (frameArray[awardpos].x + 1);
                _local1.y = (frameArray[awardpos].y + 1);
                _local1.mouseEnabled = true;
                _local1.mouseChildren = true;
                _local1.name = ("target_" + loginObj[awardpos].itemid);
                childArray[0].addChild(_local1);
                TweenLite.to(_local1, 0.5, {
                    x:149,
                    y:119,
                    scaleX:1.1,
                    scaleY:1.1
                });
                fiArray.push(_local1);
            };
        }
        public function setExpEffect(_arg1:Boolean):void{
            if (getExp){
                if (((((_arg1) && (getExp.enable))) && (welMov.contains(childArray[0])))){
                    getExp.playEffect();
                } else {
                    getExp.stopEffect();
                };
            };
        }
        public function updateEvery(_arg1:Object):void{
            var _local2:int;
            var _local3:ActivityMustDoItem;
            clearElements(everyItemContainer);
            for each (_local3 in _arg1) {
                if ((((_local3.actId == 1)) && ((GameCommonData.Player.Role.Level >= 50)))){
                } else {
                    if ((((_local3.actId == 6)) && ((GameCommonData.Player.Role.Level < 50)))){
                    } else {
                        if (!_local3.IsFinish){
                            everyItemContainer.addChildAt(_local3, _local2);
                            _local2++;
                        } else {
                            this.everyItemContainer.addChild(_local3);
                        };
                    };
                };
            };
            showElements2(everyItemContainer);
            if (eiScroll.updateFlag){
                eiScroll.refresh();
                eiScroll.scrollTop();
            };
        }
        public function set CurToggleType(_arg1:int):void{
            _curToggleType = CurToggleType;
        }
        private function detailLink(_arg1:TextEvent):void{
            toggleOne(1);
        }
        private function initEvery():void{
            everyItemContainer = new UISprite();
            everyItemContainer.width = 490;
            everyItemContainer.height = 327;
            eiScroll = new UIScrollPane(everyItemContainer);
            eiScroll.scrollPolicy = UIScrollPane.SCROLLBAR_ALWAYS;
            eiScroll.x = 10;
            eiScroll.y = 34;
            eiScroll.width = 460;
            eiScroll.height = 360;
            everyDay.addChild(eiScroll);
            eiScroll.refresh();
            eiAwardContainer = new Sprite();
            eiAwardContainer.x = 481;
            eiAwardContainer.y = 36;
            everyDay.addChild(eiAwardContainer);
        }

    }
}//package GameUI.Modules.Activity 
