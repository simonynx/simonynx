//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Constellation.View {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Constellation.Vo.*;

    public class StarView extends Sprite {

        private var container:Sprite;
        private var level:TextField;
        private var skillDes:TextField;
        private var effect:TextField;
        private var moneyParent:Sprite;
        public var studyingNode:int;
        private var skillFrame:Array;
        private var sName:TextField;
        public var starInfo:Object;
        private var progress:Sprite;
        private var moneyPoint:Point;
        public var levelArray:Array;
        private var studyTime:TextField;
        private var progressMask:Sprite;
        private var money:TextField;
        private var twinkle:MovieClip;
        private var starObj:Object;
        public var currentSelectStar:MovieClip;
        private var chip:TextField;
        public var aStarArray:Array;
        private var starContainer:Sprite;
        private var _leftTime:int;
        private var skillOne:Sprite;
        public var currentIndex:int = 0;
        private var backLoaded:Object;
        private var btnArray:Array;
        private var menu:Sprite;
        private var prop:Sprite;
        private var oneViewSkillCell:NewSkillCell;
        public var studyBtn:HLabelButton;
        public var quickstudyBtn:HLabelButton;
        private var btnFrame:Bitmap;
        private var tps:TextField;
        private var progressText:TextField;

        public function StarView(){
            btnArray = [];
            starObj = {};
            aStarArray = [];
            levelArray = [];
            skillFrame = [];
            backLoaded = {};
            super();
            fuck();
            x = -9;
            y = -31;
        }
        public function setTwinklStar(_arg1:int):void{
            var _local2:int;
            var _local3:int;
            var _local4:MovieClip;
            if (_arg1 == 0){
                if (((twinkle) && (twinkle.parent))){
                    twinkle.parent.removeChild(twinkle);
                };
            } else {
                _local2 = (_arg1 / 100);
                _local3 = (_arg1 % 100);
                _local4 = starObj[("star_" + _local2)][("astar_" + _local3)];
                if (_local4 != null){
                    _local4.addChild(twinkle);
                    twinkle.scaleX = 2;
                    twinkle.scaleY = 2;
                    twinkle.x = -18;
                    twinkle.y = -18;
                };
            };
        }
        private function onBtnMouseOut(_arg1:MouseEvent):void{
            if (((!((btnFrame == null))) && (!((btnFrame.parent == null))))){
                btnFrame.parent.removeChild(btnFrame);
            };
        }
        private function onBtnClick(_arg1:MouseEvent):void{
            var _local2:MovieClip;
            for each (_local2 in btnArray) {
                _local2.prevFrame();
            };
            _arg1.currentTarget.nextFrame();
        }
        private function initMenu():void{
            var _local2:MovieClip;
            var _local3:Sprite;
            var _local4:int;
            var _local5:MovieClip;
            var _local1:int;
            while (_local1 < menu.numChildren) {
                _local2 = (menu.getChildAt(_local1) as MovieClip);
                if (((_local2) && ((_local2.name.split("_")[0] == "star")))){
                    _local2.stop();
                    btnArray.push(_local2);
                    _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent(_local2.name);
                    starObj[_local2.name] = _local3;
                    _local4 = 0;
                    while (_local4 < _local3.numChildren) {
                        _local5 = _local3[("astar_" + _local4)];
                        if (((!((_local5 == null))) && (!((_local2.name == "star_0"))))){
                            _local5.stop();
                            aStarArray.push(_local5);
                        };
                        _local4++;
                    };
                    _local3.x = 5;
                    _local3.y = 4;
                    _local2.addEventListener(MouseEvent.CLICK, onMenuClick);
                    _local2.addEventListener(MouseEvent.MOUSE_OVER, onBtnMouseOver);
                    _local2.addEventListener(MouseEvent.MOUSE_OUT, onBtnMouseOut);
                    _local2.addEventListener(MouseEvent.CLICK, onBtnClick);
                };
                _local1++;
            };
            starObj["star_0"].x = 4;
            starObj["star_0"].y = 2;
            container.addChild(starObj["star_0"]);
        }
        private function countProp(_arg1:Array):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:Number;
            var _local2:Object = new Object();
            _local2.attack = 0;
            _local2.life = 0;
            _local2.def = 0;
            _local2.magic = 0;
            _local2.normalhit = 0;
            _local2.dodge = 0;
            _local2.cri = 0;
            _local2.cridmg = 0;
            _local2.skillhit = 0;
            _local2.skilldodge = 0;
            _local2.re1 = 0;
            _local2.re2 = 0;
            _local2.re3 = 0;
            _local2.re4 = 0;
            _local2.re5 = 0;
            var _local3:int;
            while (_local3 < _arg1.length) {
                _local4 = _arg1[_local3];
                _local5 = (_local4 / 100);
                _local6 = (_local4 % 100);
                if (_local4 == 0){
                } else {
                    _local2.attack = (_local2.attack + uint((starInfo[("star_" + _local5)] as StarInfo).attackAdd[_local6]));
                    _local2.life = (_local2.life + uint((starInfo[("star_" + _local5)] as StarInfo).hpAdd[_local6]));
                    _local2.def = (_local2.def + uint((starInfo[("star_" + _local5)] as StarInfo).defAdd[_local6]));
                    _local2.magic = (_local2.magic + uint((starInfo[("star_" + _local5)] as StarInfo).mpAdd[_local6]));
                    _local2.normalhit = (_local2.normalhit + uint((starInfo[("star_" + _local5)] as StarInfo).normalHitAdd[_local6]));
                    _local2.dodge = (_local2.dodge + uint((starInfo[("star_" + _local5)] as StarInfo).normalDodgeAdd[_local6]));
                    _local7 = (starInfo[("star_" + _local5)] as StarInfo).criticalAdd[_local6];
                    _local2.cri = (_local2.cri + (_local7 / 100));
                    _local2.cridmg = (_local2.cridmg + uint((starInfo[("star_" + _local5)] as StarInfo).criDmgAdd[_local6]));
                    _local2.skillhit = (_local2.skillhit + uint((starInfo[("star_" + _local5)] as StarInfo).skillHitAdd[_local6]));
                    _local2.skilldodge = (_local2.skilldodge + uint((starInfo[("star_" + _local5)] as StarInfo).skillDodogeAdd[_local6]));
                    _local2.re1 = (_local2.re1 + uint((starInfo[("star_" + _local5)] as StarInfo).resistance_1[_local6]));
                    _local2.re2 = (_local2.re2 + uint((starInfo[("star_" + _local5)] as StarInfo).resistance_2[_local6]));
                    _local2.re3 = (_local2.re3 + uint((starInfo[("star_" + _local5)] as StarInfo).resistance_3[_local6]));
                    _local2.re4 = (_local2.re4 + uint((starInfo[("star_" + _local5)] as StarInfo).resistance_4[_local6]));
                    _local2.re5 = (_local2.re5 + uint((starInfo[("star_" + _local5)] as StarInfo).resistance_5[_local6]));
                    setTextFields(_local2);
                };
                _local3++;
            };
        }
        public function updateProgress(_arg1:int):void{
            if ((_arg1 > 74)){
                _arg1 = 74;
            };
            progressText.text = (_arg1 + " / 74");
            progressMask.x = progress.x;
            progressMask.y = progress.y;
            progressMask.graphics.beginFill(0, 1);
            progressMask.graphics.drawRect(0, 0, ((_arg1 / 74) * progress.width), progress.height);
        }
        private function clearStarContainer():void{
            var _local1:*;
            for each (_local1 in starObj) {
                if (_local1.parent){
                    _local1.parent.removeChild(_local1);
                };
            };
        }
        private function onlyShow2():void{
            sName.text = "--";
            effect.text = "--";
            level.text = "--";
            money.text = "--";
            chip.text = "--";
        }
        private function onBtnMouseOver(_arg1:MouseEvent):void{
            if (btnFrame != null){
                _arg1.currentTarget.addChild(btnFrame);
            };
            btnFrame.x = -3;
            btnFrame.y = -5;
        }
        public function reFreshClipOnly():void{
            if (!starInfo){
                return;
            };
            if (!currentSelectStar){
                return;
            };
            if (currentIndex == 0){
                return;
            };
            var _local1:uint = BagData.getCountsByTemplateId(50700004, false);
            var _local2:int = currentSelectStar.name.split("_")[1];
            var _local3:uint = (starInfo[("star_" + currentIndex)] as StarInfo).costClip[_local2];
            if (_local1 >= _local3){
                chip.textColor = 16760397;
                studyBtn.name = "";
            } else {
                chip.textColor = 0xFF0000;
                studyBtn.name = "clip";
            };
            chip.text = ((_local1 + "/") + _local3);
        }
        private function reFreshSkillIcon():void{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local1 = 1;
            while (_local1 < 8) {
                _local2 = starInfo[("star_" + _local1)].num;
                _local3 = 0;
                _local4 = 0;
                while (_local4 < _local2) {
                    if (starObj[("star_" + _local1)][("astar_" + _local4)].currentFrame == 3){
                        _local3++;
                    };
                    _local4++;
                };
                if (_local3 == _local2){
                    skillFrame[(_local1 - 1)].filters = [];
                };
                _local1++;
            };
        }
        public function reFreshMoneyOnly():void{
            if (!starInfo){
                return;
            };
            if (!currentSelectStar){
                return;
            };
            if (currentIndex == 0){
                return;
            };
            var _local1:int = currentSelectStar.name.split("_")[1];
            var _local2:int = (starInfo[("star_" + currentIndex)] as StarInfo).costGold[_local1];
            if (_local2 > GameCommonData.Player.Role.Gold){
                money.textColor = 0xFF0000;
                studyBtn.name = "money";
            } else {
                money.textColor = 16760397;
                studyBtn.name = "";
            };
        }
        private function initBtn():void{
            quickstudyBtn = new HLabelButton();
            quickstudyBtn.label = LanguageMgr.GetTranslation("快速学习");
            quickstudyBtn.x = 166;
            quickstudyBtn.y = 303;
            quickstudyBtn.enable = false;
            studyBtn = new HLabelButton();
            studyBtn.label = LanguageMgr.GetTranslation("学习");
            studyBtn.x = 300;
            studyBtn.y = 187;
            btnFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("RankFrame");
        }
        public function reFreshByLevel(_arg1:int):void{
            var _local6:Boolean;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local2:int = aStarArray.length;
            var _local3:Array = [0, 7, 15, 27, 38, 49, 61];
            var _local4:int;
            var _local5:int;
            while (_local5 < _local2) {
                _local6 = true;
                if (_local5 >= 7){
                    if (_local5 == _local3[(_local4 + 1)]){
                        _local4++;
                    };
                    _local7 = _local3[(_local4 - 1)];
                    while (_local7 < _local3[_local4]) {
                        if (aStarArray[_local7].currentFrame != 3){
                            _local6 = false;
                            break;
                        };
                        _local7++;
                    };
                };
                aStarArray[_local5].buttonMode = true;
                if (_arg1 >= levelArray[_local5]){
                    if ((((aStarArray[_local5].currentFrame == 1)) && (_local6))){
                        aStarArray[_local5].nextFrame();
                    };
                };
                aStarArray[_local5].addEventListener(MouseEvent.CLICK, onAstarClick);
                _local5++;
            };
            if (((((!((currentSelectStar == null))) && (!((starInfo == null))))) && (!((currentIndex == 0))))){
                _local8 = getAstarID(currentSelectStar);
                if (_local8 != 0){
                    _local9 = (_local8 / 100);
                    _local10 = (_local8 % 100);
                    _local11 = (starInfo[("star_" + _local9)] as StarInfo).needLevel[_local10];
                    if (_local11 <= _arg1){
                        this.level.textColor = 16760397;
                        studyBtn.name = "";
                    } else {
                        this.level.textColor = 0xFF0000;
                        studyBtn.name = "level";
                    };
                };
            };
            checkBtnEnable();
        }
        private function changeMoneyText():void{
            if (((moneyParent) && (moneyParent.parent))){
                moneyParent.parent.removeChild(moneyParent);
            };
            moneyParent = new Sprite();
            moneyParent.x = moneyPoint.x;
            moneyParent.y = moneyPoint.y;
            money.x = 0;
            money.y = 0;
            prop.addChild(moneyParent);
            moneyParent.addChild(money);
        }
        private function onlyShow(_arg1:MouseEvent):void{
            var _local2:Sprite;
            var _local3:int;
            var _local4:int;
            var _local5:uint;
            var _local6:uint;
            for each (_local2 in aStarArray) {
                _local2.filters = null;
            };
            _arg1.currentTarget.filters = [new GlowFilter(0x3200FF, 1, 2, 2, 5, 1)];
            _local3 = currentIndex;
            _local4 = _arg1.currentTarget.name.split("_")[1];
            sName.text = (starInfo[("star_" + _local3)] as StarInfo).name;
            effect.text = LanguageMgr.starArray[(_local3 - 1)][_local4];
            level.text = (starInfo[("star_" + _local3)] as StarInfo).needLevel[_local4];
            _local5 = BagData.getCountsByTemplateId(50700004, false);
            _local6 = (starInfo[("star_" + _local3)] as StarInfo).costClip[_local4];
            if (_local5 >= _local6){
                chip.textColor = 16760397;
                studyBtn.name = "";
            } else {
                chip.textColor = 0xFF0000;
                studyBtn.name = "clip";
            };
            chip.text = ((_local5 + "/") + _local6);
            var _local7:int = (starInfo[("star_" + _local3)] as StarInfo).costGold[_local4];
            var _local8:int = (_local7 / 10000);
            var _local9:int = ((_local7 / 100) % 100);
            var _local10:int = (_local7 % 100);
            changeMoneyText();
            money.text = (((((_local8 + "金币") + _local9) + "银币") + _local10) + "铜币");
            money.text = money.text.replace("金币", "\\ce");
            money.text = money.text.replace("银币", "\\cs");
            money.text = money.text.replace("铜币", "\\cc");
            ShowMoney.ShowIcon2(moneyParent, money);
            if (_local7 > GameCommonData.Player.Role.Gold){
                money.textColor = 0xFF0000;
                studyBtn.name = "money";
            } else {
                money.textColor = 16760397;
                studyBtn.name = "";
            };
            if (GameCommonData.Player.Role.Level < (starInfo[("star_" + _local3)] as StarInfo).needLevel[_local4]){
                level.textColor = 0xFF0000;
                studyBtn.name = "level";
            } else {
                level.textColor = 16760397;
                studyBtn.name = "";
            };
            checkBtnEnable();
        }
        private function onMenuClick(_arg1:MouseEvent):void{
            var _local2:int;
            var _local3:int;
            var _local4:Sprite;
            var _local5:MovieClip;
            var _local6:int;
            clearStarContainer();
            currentIndex = _arg1.currentTarget.name.split("_")[1];
            if (backLoaded[_arg1.currentTarget.name] != true){
                UIUtils.initBackPicContainer(starObj[_arg1.currentTarget.name], _arg1.currentTarget.name);
                backLoaded[_arg1.currentTarget.name] = true;
            };
            if (currentIndex == 0){
                if (prop.parent){
                    prop.parent.removeChild(prop);
                };
                skillDes.text = "";
                menu["skillframe"].visible = false;
            } else {
                if (oneViewSkillCell){
                    oneViewSkillCell.dispose();
                };
                container.addChild(starContainer);
                container.addChild(prop);
                container.addChild(quickstudyBtn);
                container.addChild(studyBtn);
                skillDes.htmlText = (("<TEXTFORMAT LEADING=\"6\"><P ALIGN=\"LEFT\"><FONT FACE=\"SimSun\" SIZE=\"12\" COLOR=\"#FFBE4D\" LETTERSPACING=\"0\" KERNING=\"1\">点亮本守护所有星星将能领悟到守护特有技能【<FONT COLOR=\"#00FF00\">" + GameCommonData.SkillList[(("900" + currentIndex) + "01")].Name) + "</FONT>】</FONT></P></TEXTFORMAT>");
                menu["skillframe"].visible = true;
                while (skillOne.numChildren > 0) {
                    skillOne.removeChildAt(0);
                };
                oneViewSkillCell = new NewSkillCell();
                oneViewSkillCell.setLearnSkillInfo(GameCommonData.SkillList[(("900" + currentIndex) + "01")]);
                oneViewSkillCell.filters = [];
                oneViewSkillCell.x = 2;
                oneViewSkillCell.y = 2;
                skillOne.addChild(oneViewSkillCell);
                starObj[_arg1.currentTarget.name].astar_0.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                if (studyingNode != 0){
                    _local2 = (studyingNode / 100);
                    if (_local2 == currentIndex){
                        _local3 = (studyingNode % 100);
                        starObj[_arg1.currentTarget.name][("astar_" + _local3)].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    } else {
                        _local4 = starObj[_arg1.currentTarget.name];
                        _local6 = 0;
                        while (_local6 < _local4.numChildren) {
                            _local5 = (_local4[("astar_" + _local6)] as MovieClip);
                            if (((!((_local5 == null))) && ((_local5.currentFrame == 2)))){
                                _local5.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                                break;
                            };
                            _local6++;
                        };
                    };
                } else {
                    _local4 = starObj[_arg1.currentTarget.name];
                    _local6 = 0;
                    while (_local6 < _local4.numChildren) {
                        _local5 = (_local4[("astar_" + _local6)] as MovieClip);
                        if (((!((_local5 == null))) && ((_local5.currentFrame == 2)))){
                            _local5.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                            break;
                        };
                        _local6++;
                    };
                };
                if (currentIndex > 1){
                    tps.htmlText = (("<TEXTFORMAT LEADING=\"2\"><P ALIGN=\"LEFT\"><FONT FACE=\"SimSun\" SIZE=\"12\" COLOR=\"#00FF00\" LETTERSPACING=\"0\" KERNING=\"1\">" + starInfo[("star_" + (currentIndex - 1))].name) + "必须全部点亮</FONT></P></TEXTFORMAT>");
                } else {
                    tps.htmlText = "";
                };
            };
            container.addChild(starObj[_arg1.currentTarget.name]);
        }
        private function onAstarClick(_arg1:MouseEvent):void{
            studyBtn.label = LanguageMgr.GetTranslation("学习");
            currentSelectStar = (_arg1.currentTarget as MovieClip);
            onlyShow(_arg1);
        }
        private function setTextFields(_arg1:Object):void{
            starObj["star_0"].attack.text = ("+" + _arg1.attack);
            starObj["star_0"].life.text = ("+" + _arg1.life);
            starObj["star_0"].def.text = ("+" + _arg1.def);
            starObj["star_0"].magic.text = ("+" + _arg1.magic);
            starObj["star_0"].normalhit.text = ("+" + _arg1.normalhit);
            starObj["star_0"].dodge.text = ("+" + _arg1.dodge);
            starObj["star_0"].cri.text = (("+" + _arg1.cri.toFixed(2)) + "%");
            starObj["star_0"].cridmg.text = (("+" + (_arg1.cridmg / 100).toFixed(2)) + "%");
            starObj["star_0"].skillhit.text = ("+" + _arg1.skillhit);
            starObj["star_0"].skilldodge.text = ("+" + _arg1.skilldodge);
            starObj["star_0"].re1.text = ("+" + _arg1.re1);
            starObj["star_0"].re2.text = ("+" + _arg1.re2);
            starObj["star_0"].re3.text = ("+" + _arg1.re3);
            starObj["star_0"].re4.text = ("+" + _arg1.re4);
            starObj["star_0"].re5.text = ("+" + _arg1.re5);
        }
        public function checkBtnEnable():void{
            if (currentSelectStar == null){
                return;
            };
            if (_leftTime < 2){
                if (currentSelectStar.currentFrame == 3){
                    studyBtn.label = LanguageMgr.GetTranslation("已学习");
                    studyBtn.enable = false;
                } else {
                    if (currentSelectStar.currentFrame == 2){
                        studyBtn.label = LanguageMgr.GetTranslation("学习");
                        if (studyBtn.name == "level"){
                            studyBtn.enable = false;
                        } else {
                            studyBtn.enable = true;
                        };
                    } else {
                        if (currentSelectStar.currentFrame == 1){
                            studyBtn.label = LanguageMgr.GetTranslation("学习");
                            studyBtn.enable = false;
                        };
                    };
                };
            } else {
                studyBtn.enable = false;
                if (currentSelectStar.currentFrame == 3){
                    studyBtn.label = LanguageMgr.GetTranslation("已学习");
                } else {
                    if (currentSelectStar.currentFrame == 2){
                        studyBtn.label = LanguageMgr.GetTranslation("学习");
                    } else {
                        if (currentSelectStar.currentFrame == 1){
                            studyBtn.label = LanguageMgr.GetTranslation("学习");
                        };
                    };
                };
                if (((twinkle) && ((twinkle.parent == currentSelectStar)))){
                    studyBtn.label = LanguageMgr.GetTranslation("学习中");
                };
            };
        }
        public function updateStatus(_arg1:Object):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            if (_arg1 == null){
                return;
            };
            var _local2:Array = _arg1.finish;
            if (_local2 == null){
                return;
            };
            updateProgress(_local2.length);
            var _local3:int;
            while (_local3 < _local2.length) {
                _local4 = _local2[_local3];
                _local5 = (_local4 / 100);
                _local6 = (_local4 % 100);
                starObj[("star_" + _local5)][("astar_" + _local6)].gotoAndStop(3);
                _local3++;
            };
            if (starInfo != null){
                countProp(_arg1.finish);
                reFreshSkillIcon();
            };
        }
        private function initProgress():void{
            progressMask = new Sprite();
            progress.parent.addChild(progressMask);
            progress.mask = progressMask;
        }
        public function removeEvents():void{
            var _local1:int;
            while (_local1 < aStarArray.length) {
                aStarArray[_local1].removeEventListener(MouseEvent.CLICK, onAstarClick);
                _local1++;
            };
        }
        public function getAstarID(_arg1:MovieClip):int{
            var _local3:Sprite;
            var _local4:int;
            var _local2:int;
            while (_local2 < 7) {
                _local3 = starObj[("star_" + _local2)];
                _local4 = 0;
                while (_local4 < _local3.numChildren) {
                    if (_arg1 == _local3.getChildAt(_local4)){
                        return (((_local2 * 100) + uint(_local3.getChildAt(_local4).name.split("_")[1])));
                    };
                    _local4++;
                };
                _local2++;
            };
            return (0);
        }
        public function set leftTime(_arg1:int):void{
            _leftTime = _arg1;
            if (_leftTime < 1){
                quickstudyBtn.enable = false;
            };
        }
        public function clickStar0(_arg1:int=0):void{
            var _local2:int;
            var _local3:Sprite;
            var _local4:int;
            var _local5:MovieClip;
            if (_arg1 != 0){
                _local2 = 1;
                while (_local2 < 7) {
                    _local3 = starObj[("star_" + _local2)];
                    _local4 = 0;
                    while (_local4 < _local3.numChildren) {
                        _local5 = _local3[("astar_" + _local4)];
                        if (_local5 != null){
                            if (_local5.currentFrame == 2){
                                btnArray[_local2].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                                _local5.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                                return;
                            };
                        };
                        _local4++;
                    };
                    _local2++;
                };
            } else {
                btnArray[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }
        private function initSkillFrame():void{
            var _local2:MovieClip;
            var _local3:NewSkillCell;
            var _local1:int;
            while (_local1 < 7) {
                _local2 = starObj["star_0"][("skill_" + _local1)];
                skillFrame.push(_local2);
                _local2.filters = [ColorFilters.BlackGoundFilter];
                _local3 = new NewSkillCell();
                _local3.setLearnSkillInfo(GameCommonData.SkillList[(("900" + (_local1 + 1)) + "01")]);
                _local3.x = 9;
                _local3.y = 7;
                _local3.filters = [];
                _local2.addChild(_local3);
                _local1++;
            };
        }
        public function setStudyTime(_arg1:String):void{
            studyTime.htmlText = (((("<TEXTFORMAT LEADING=\"6\"><P ALIGN=\"LEFT\"><FONT FACE=\"SimSun\" SIZE=\"12\" COLOR=\"#FFBE4D\" LETTERSPACING=\"0\" KERNING=\"1\">" + LanguageMgr.GetTranslation("学习剩余时间")) + ":<FONT COLOR=\"#00FF00\">") + _arg1) + "</FONT></FONT></P></TEXTFORMAT>");
            quickstudyBtn.enable = true;
        }
        private function fuck():void{
            menu = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("starmenu");
            prop = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("starprop");
            sName = prop["sname"];
            effect = prop["effect"];
            effect.wordWrap = true;
            level = prop["level"];
            money = prop["money"];
            skillDes = menu["skilldes"];
            skillOne = new Sprite();
            menu["skillframe"].addChild(skillOne);
            skillOne.x = 7;
            skillOne.y = 5;
            tps = prop["tps"];
            moneyPoint = new Point();
            moneyPoint.x = money.x;
            moneyPoint.y = money.y;
            chip = prop["chip"];
            container = new Sprite();
            starContainer = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("starcontainer");
            studyTime = starContainer["study"];
            twinkle = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("startwin");
            this.addChild(menu);
            menu.x = 5;
            menu.y = 32;
            prop.x = 250;
            container.x = 122;
            container.y = 32;
            this.addChild(container);
            initMenu();
            progressText = starObj["star_0"].progresstext;
            progress = starObj["star_0"].progress;
            initBtn();
            initProgress();
            initSkillFrame();
        }

    }
}//package GameUI.Modules.Constellation.View 
