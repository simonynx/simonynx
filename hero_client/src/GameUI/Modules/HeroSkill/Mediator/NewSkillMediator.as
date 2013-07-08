//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.HeroSkill.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.UICore.*;
    import OopsEngine.Role.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import flash.geom.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.Modules.NewInfoTip.Data.*;
    import com.greensock.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.HeroSkill.View.*;
    import flash.net.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.MainScene.Proxy.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.AutoPlay.Data.*;
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.*;

    public class NewSkillMediator extends Mediator {

        public static const NAME:String = "NewSkillMediator";

        private const CELLNUM:int = 18;

        private var descTaskText:TaskText;
        private var sharedObject:SharedObject;
        private var currentSkillList:Array;
        private var _JobList:Array;
        private var _currentJob:int;
        private var _skyNextBtn:HBaseButton;
        private var currentPage:int = 1;
        private var _closeBtn:HBaseButton;
        private var _nextBtn:HLabelButton;
        private var otherBtn:ToggleButton;
        private var _currentSkyPage:int = 1;
        private var _totalSkillPage:int;
        private var lifeBtn:ToggleButton;
        private var _skyPreBtn:HBaseButton;
        private var bg:HFrame;
        private var frameCellArrOhter:Array;
        private var _skillTwoLayer:Array;
        private var _preBtn:HLabelButton;
        private var yellowFrame:MovieClip;
        private var isInit:Boolean;
        private var _skillThreeLayer:Array;
        private var jobBtn:ToggleButton;
        private var dataProxy:DataProxy = null;
        private var _currentSkillPage:int = 1;
        private var frameCellArr:Array;
        private var isLoadBG:Boolean = false;
        private var _skillOneLayer:Array;

        public function NewSkillMediator(){
            super(NAME);
        }
        private function onClickFrame(_arg1:MouseEvent):void{
            _arg1.currentTarget.addChild(yellowFrame);
            if (_arg1.currentTarget.info != null){
                skillView.describe.text = _arg1.currentTarget.info.description;
                if (descTaskText){
                    descTaskText.visible = false;
                };
            } else {
                skillView.describe.text = "";
                if (descTaskText){
                    descTaskText.visible = true;
                };
            };
        }
        private function removeEvent():void{
            var _local1:Sprite;
            jobBtn.removeEventListener(MouseEvent.CLICK, updateMainBtn);
            otherBtn.removeEventListener(MouseEvent.CLICK, updateMainBtn);
            _skyPreBtn.removeEventListener(MouseEvent.CLICK, onSelectSkyBook);
            _skyNextBtn.removeEventListener(MouseEvent.CLICK, onSelectSkyBook);
            _preBtn.removeEventListener(MouseEvent.CLICK, updatePage);
            _nextBtn.removeEventListener(MouseEvent.CLICK, updatePage);
            for each (_local1 in frameCellArr) {
                _local1.removeEventListener(MouseEvent.CLICK, onClickFrame);
            };
            for each (_local1 in frameCellArrOhter) {
                _local1.removeEventListener(MouseEvent.CLICK, onClickFrame);
            };
        }
        private function init():void{
            var _local1:SKillCellPanel;
            var _local2:SKillCellPanel;
            var _local6:int;
            var _local9:NewSkillLearnCell;
            frameCellArr = [];
            frameCellArrOhter = [];
            currentSkillList = [];
            var _local3:uint;
            var _local4 = 10;
            var _local5 = 57;
            _local6 = 160;
            var _local7 = 57;
            var _local8:Boolean;
            _local3 = 0;
            while (_local3 < CELLNUM) {
                _local1 = new SKillCellPanel();
                _local2 = new SKillCellPanel();
                skillView.addChild(_local1);
                if (_local3 < 12){
                    if ((_local3 % 2) == 0){
                        _local1.x = _local4;
                        _local1.y = _local5;
                        _local2.x = _local4;
                        _local2.y = _local5;
                        _local5 = (_local5 + 50);
                    } else {
                        _local1.x = _local6;
                        _local1.y = _local7;
                        _local2.x = _local6;
                        _local2.y = _local7;
                        _local7 = (_local7 + 50);
                    };
                } else {
                    if (_local8){
                        _local5 = 57;
                        _local7 = 57;
                        _local8 = false;
                    };
                    if ((_local3 % 2) == 0){
                        _local1.x = _local4;
                        _local1.y = _local5;
                        _local2.x = _local4;
                        _local2.y = _local5;
                        _local5 = (_local5 + 50);
                    } else {
                        _local1.x = _local6;
                        _local1.y = _local7;
                        _local2.x = _local6;
                        _local2.y = _local7;
                        _local7 = (_local7 + 50);
                    };
                };
                frameCellArr.push(_local1);
                frameCellArrOhter.push(_local2);
                _local3++;
            };
            _skillOneLayer = [];
            _skillTwoLayer = [];
            _skillThreeLayer = [];
            _currentJob = GameCommonData.Player.Role.CurrentJobID;
            _local3 = 0;
            while (_local3 < 5) {
                _local9 = new NewSkillLearnCell(_currentJob, 1, (_local3 + 1));
                skillView.skillTree[("cell1" + _local3)].gotoAndStop(1);
                skillView.skillTree[("cell1" + _local3)].addChild(_local9);
                _local9.x = 8;
                _local9.y = 7;
                _skillOneLayer.push(_local9);
                _local3++;
            };
            _local3 = 0;
            while (_local3 < 9) {
                _local9 = new NewSkillLearnCell(_currentJob, 2, (_local3 + 1));
                skillView.skillTree[("cell2" + _local3)].gotoAndStop(1);
                skillView.skillTree[("cell2" + _local3)].addChild(_local9);
                _local9.x = 8;
                _local9.y = 7;
                _skillTwoLayer.push(_local9);
                _local3++;
            };
            _local3 = 0;
            while (_local3 < 4) {
                _local9 = new NewSkillLearnCell(_currentJob, 3, (_local3 + 1));
                skillView.skillTree[("cell3" + _local3)].gotoAndStop(1);
                skillView.skillTree[("cell3" + _local3)].addChild(_local9);
                _local9.x = 8;
                _local9.y = 7;
                _skillThreeLayer.push(_local9);
                _local3++;
            };
            bg = new HFrame();
            bg.blackGound = false;
            bg.showClose = true;
            bg.moveEnable = true;
            bg.closeCallBack = onClose;
            bg.setSize(562, 480);
            bg.titleText = LanguageMgr.GetTranslation("技 能");
            bg.centerTitle = true;
            bg.addContent(skillView);
            skillView.x = 5;
            _preBtn = new HLabelButton(2);
            _preBtn.label = LanguageMgr.GetTranslation("上页");
            _preBtn.x = 77;
            _preBtn.y = 371;
            skillView.addChild(_preBtn);
            _nextBtn = new HLabelButton(2);
            _nextBtn.label = LanguageMgr.GetTranslation("下页");
            _nextBtn.x = 190;
            _nextBtn.y = 371;
            skillView.addChild(_nextBtn);
            _skyPreBtn = new HBaseButton(skillView.skyPreBtn);
            _skyPreBtn.useBackgoundPos = true;
            skillView.addChild(_skyPreBtn);
            _skyNextBtn = new HBaseButton(skillView.skyNextBtn);
            _skyNextBtn.useBackgoundPos = true;
            skillView.addChild(_skyNextBtn);
            skillView.pageText.selectable = false;
            skillView.describe.selectable = false;
            jobBtn = new ToggleButton(0, LanguageMgr.GetTranslation("职业"));
            jobBtn.x = 8;
            jobBtn.y = 34;
            skillView.addChild(jobBtn);
            otherBtn = new ToggleButton(0, LanguageMgr.GetTranslation("星座"));
            otherBtn.x = ((jobBtn.x + jobBtn.width) + 2);
            otherBtn.y = 34;
            skillView.addChild(otherBtn);
            lifeBtn = new ToggleButton(0, LanguageMgr.GetTranslation("生活"));
            lifeBtn.x = ((otherBtn.x + otherBtn.width) + 2);
            lifeBtn.y = 34;
            skillView.addChild(lifeBtn);
            bg.x = 120;
            bg.y = 60;
            yellowFrame = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SkillYellowFrame");
            yellowFrame.width = 150;
            yellowFrame.height = 50;
        }
        private function setSkillTree(_arg1:int):void{
            var _local2:NewSkillCell;
            if ((((_arg1 < 1)) || ((_arg1 > 3)))){
                return;
            };
            var _local3:Array = [10, 20, 16];
            skillView.leftSkillsPoint.text = SkillManager.SkillCurrentPoint[(_arg1 - 1)];
            skillView.usePoint.text = (SkillManager.getNowPoint()[(_arg1 - 1)] - SkillManager.SkillCurrentPoint[(_arg1 - 1)]);
            skillView.totalPoint.text = _local3[(_arg1 - 1)];
            for each (_local2 in _skillOneLayer) {
                _local2.parent.visible = (_arg1 == 1);
            };
            for each (_local2 in _skillTwoLayer) {
                _local2.parent.visible = (_arg1 == 2);
            };
            for each (_local2 in _skillThreeLayer) {
                _local2.parent.visible = (_arg1 == 3);
            };
        }
        private function clearCellView():void{
            var _local1:SKillCellPanel;
            for each (_local1 in frameCellArr) {
                if (_local1.parent){
                    skillView.removeChild(_local1);
                };
            };
            for each (_local1 in frameCellArrOhter) {
                if (_local1.parent){
                    skillView.removeChild(_local1);
                };
            };
            skillView.describe.text = "";
            if (descTaskText){
                descTaskText.visible = true;
            };
            if (yellowFrame.parent){
                yellowFrame.parent.removeChild(yellowFrame);
            };
        }
        private function setSkillTreeInfo():void{
            var _local1:NewSkillLearnCell;
            var _local2:SkillInfo;
            _currentJob = GameCommonData.Player.Role.CurrentJobID;
            SkillManager.MySkillList = [];
            for each (_local1 in _skillOneLayer) {
                _local1.setData(_currentJob, 1);
                SkillManager.MySkillList.push(_local1.skillInfo);
            };
            for each (_local1 in _skillTwoLayer) {
                _local1.setData(_currentJob, 2);
                SkillManager.MySkillList.push(_local1.skillInfo);
            };
            for each (_local1 in _skillThreeLayer) {
                _local1.setData(_currentJob, 3);
                SkillManager.MySkillList.push(_local1.skillInfo);
            };
            for each (_local2 in SkillManager.MySkillList) {
                if (_local2 != null){
                    if (SkillManager.CanDragSkill(_local2)){
                        if (_local2.isLearn){
                            judgeAuto(_local2);
                        };
                    };
                };
            };
            if (SkillManager.getMyIdSkillInfo(900101)){
                judgeAuto(SkillManager.getMyIdSkillInfo(900101));
            };
            if (SkillManager.getMyIdSkillInfo(900501)){
                judgeAuto(SkillManager.getMyIdSkillInfo(900501));
            };
            if (SkillManager.getMyIdSkillInfo(900701)){
                judgeAuto(SkillManager.getMyIdSkillInfo(900701));
            };
        }
        public function get skillView():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function setSkillList():void{
            var _local3:Array;
            clearCellView();
            var _local1:int = ((_currentSkillPage - 1) * 12);
            var _local2:int = (_currentSkillPage * 12);
            if (currentPage == 1){
                _local3 = frameCellArr;
            } else {
                if (currentPage == 4){
                    _local3 = frameCellArrOhter;
                };
            };
            while (_local1 < _local2) {
                if (currentSkillList.length > 0){
                    if (currentSkillList[_local1]){
                        if (currentSkillList[_local1] != null){
                            if (_local3[_local1]){
                                _local3[_local1].info = currentSkillList[_local1];
                                skillView.addChild(_local3[_local1]);
                            };
                        };
                    };
                };
                _local1++;
            };
        }
        private function updateBtnInfo():void{
            clearCellView();
            skillView.describe.text = "";
            if (descTaskText){
                descTaskText.visible = true;
            };
            if (yellowFrame.parent){
                yellowFrame.parent.removeChild(yellowFrame);
            };
            updateListPage();
            setSkillList();
        }
        private function updateListPage(_arg1:int=1):void{
            _totalSkillPage = 1;
            _currentSkillPage = _arg1;
            _totalSkillPage = Math.ceil((currentSkillList.length / 10));
            if (_totalSkillPage == 0){
                _totalSkillPage = 1;
            };
            skillView.pageText.text = ((_currentSkillPage + "/") + _totalSkillPage);
        }
        private function onLoabdComplete():void{
            var _local1:* = ResourcesFactory.getInstance().getBitMapResourceByUrl((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/skillbg.jpg"));
            skillView.skillTree.bg_pos.addChild(_local1);
        }
        public function getCloseBtn():SimpleButton{
            if (bg){
                return (bg.closeBtn);
            };
            return (null);
        }
        override public function handleNotification(_arg1:INotification):void{
            var icon:* = null;
            var pos:* = null;
            var pos1:* = null;
            var spr:* = null;
            var _local2:* = null;
            var notification:* = _arg1;
            switch (notification.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.NEWSKILLVIEW
                    });
                    if (isInit == false){
                        init();
                        isInit = true;
                    };
                    setSkillTreeInfo();
                    break;
                case EventList.SHOWSKILLVIEW:
                    GameCommonData.GameInstance.GameUI.addChild(bg);
                    bg.centerFrame();
                    initView();
                    initEvent();
                    currentPage = 1;
                    if (GameCommonData.Player.Role.Level >= 70){
                        _currentSkyPage = 3;
                    } else {
                        if (GameCommonData.Player.Role.Level >= 30){
                            _currentSkyPage = 2;
                        } else {
                            _currentSkyPage = 1;
                        };
                    };
                    skillView.skyBook.gotoAndStop(_currentSkyPage);
                    skillView.skillTree.gotoAndStop(_currentSkyPage);
                    setSkillTreeInfo();
                    setSkillTree(_currentSkyPage);
                    updateSkillList();
                    jobBtn.selected = true;
                    otherBtn.selected = false;
                    lifeBtn.selected = false;
                    sendNotification(NewInfoTipNotiName.NEWINFOTIP_SKILL_HIDE);
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                    if (((((NewGuideData.newerHelpIsOpen) && ((NewGuideData.curType == 17)))) && ((NewGuideData.curStep == 1)))){
                        sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                            TYPE:17,
                            STEP:2,
                            POINT:((_skillOneLayer[0])!=null) ? _skillOneLayer[0].AddPointMc : null
                        });
                    };
                    if (!isLoadBG){
                        ResourcesFactory.getInstance().getResource((GameCommonData.GameInstance.Content.RootDirectory + "Resources/Img/skillbg.jpg"), onLoabdComplete);
                        isLoadBG = true;
                    };
                    break;
                case EventList.UPDATESKILLVIEW:
                    if (isInit){
                        setSkillTreeInfo();
                        setSkillTree(_currentSkyPage);
                        updateSkillList();
                    };
                    break;
                case EventList.MOVE_SKILLCELL:
                    icon = (_skillOneLayer[0] as NewSkillLearnCell).getIconBitmap();
                    pos = (_skillOneLayer[0] as NewSkillLearnCell).localToGlobal(new Point(0, 0));
                    spr = new Sprite();
                    spr.addChild(icon);
                    GameCommonData.GameInstance.GameUI.addChild(spr);
                    spr.x = pos.x;
                    spr.y = pos.y;
                    _local2 = (UIFacade.GetInstance().retrieveProxy(QuickSkillManager.NAME) as QuickSkillManager);
                    pos1 = _local2.getTheQuickPos(0);
                    TweenLite.to(spr, 1.5, {
                        x:(pos1.x + 2),
                        y:(pos1.y + 2),
                        onComplete:function ():void{
                            if (spr.parent){
                                spr.parent.removeChild(spr);
                                _local2.autoAddItem(1, _skillOneLayer[0]["skillInfo"]);
                            };
                        }
                    });
                    break;
                case EventList.CLOSESKILLVIEW:
                    removeEvent();
                    onClose(null);
                    break;
                case NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_POINT:
                    bg.x = 0;
                    facade.sendNotification(Guide_AddJobSkillCommand.NAME, {
                        step:2,
                        data:{target:_skillOneLayer[4].AddPointMc}
                    });
                    break;
            };
        }
        private function initView():void{
            skillView.skillTree.gotoAndStop(_currentSkyPage);
            skillView.describe.text = "";
            if (descTaskText == null){
                descTaskText = new TaskText(skillView.describe.width);
                descTaskText.tfText = LanguageMgr.GetTranslation("洗点提示");
                descTaskText.x = skillView.describe.x;
                descTaskText.y = (skillView.describe.y + 2);
                skillView.addChild(descTaskText);
            };
            descTaskText.visible = true;
            skillView.skyBook.gotoAndStop(_currentSkyPage);
        }
        private function updateSkillList():void{
            if (currentPage == 1){
                currentSkillList = SkillManager.MySkillList;
            } else {
                if (currentPage == 2){
                } else {
                    if (currentPage == 3){
                    } else {
                        currentSkillList = SkillManager.AllSkillList[9];
                    };
                };
            };
            setSkillList();
            updateListPage(_currentSkillPage);
        }
        private function onClose(_arg1:MouseEvent=null):void{
            if (dataProxy.NewSkillIsOpen == false){
                return;
            };
            if (NewGuideData.newerHelpIsOpen){
                sendNotification(NewGuideEvent.NEWPLAYER_GUILD_HIDE_HELP);
                if ((((NewGuideData.curType == 17)) && ((NewGuideData.curStep == 3)))){
                    sendNotification(NewGuideEvent.NEWPLAYER_GUILD_SHOW_HELP, {
                        TYPE:17,
                        STEP:4,
                        POINT:_skillOneLayer[0]
                    });
                };
                facade.sendNotification(Guide_AddJobSkillCommand.NAME, {step:3});
            };
            if (((bg) && (GameCommonData.GameInstance.GameUI.contains(bg)))){
                bg.close();
            };
            dataProxy.NewSkillIsOpen = false;
            GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
        }
        private function updateMainBtn(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == jobBtn){
                currentSkillList = [];
                currentSkillList = SkillManager.MySkillList;
                currentPage = 1;
                jobBtn.selected = true;
                otherBtn.selected = false;
                lifeBtn.selected = false;
                updateBtnInfo();
            } else {
                if (_arg1.currentTarget == otherBtn){
                    currentSkillList = [];
                    currentSkillList = SkillManager.AllSkillList[9];
                    currentPage = 4;
                    jobBtn.selected = false;
                    otherBtn.selected = true;
                    lifeBtn.selected = false;
                    updateBtnInfo();
                } else {
                    if (_arg1.currentTarget == lifeBtn){
                        currentSkillList = SkillManager.AllSkillList[11];
                        currentPage = 4;
                        jobBtn.selected = false;
                        otherBtn.selected = false;
                        lifeBtn.selected = true;
                        updateBtnInfo();
                    };
                };
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWSKILLVIEW, EventList.CLOSESKILLVIEW, EventList.UPDATESKILLVIEW, EventList.MOVE_SKILLCELL, NewGuideEvent.NEWPLAYER_GUILD_ADDJOBSKILL_POINT]);
        }
        private function onSelectSkyBook(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == _skyPreBtn){
                if (_currentSkyPage > 1){
                    _currentSkyPage--;
                    skillView.skillTree.gotoAndStop(_currentSkyPage);
                    skillView.skyBook.gotoAndStop(_currentSkyPage);
                    setSkillTree(_currentSkyPage);
                };
            } else {
                if (_currentSkyPage < 3){
                    _currentSkyPage++;
                    skillView.skillTree.gotoAndStop(_currentSkyPage);
                    skillView.skyBook.gotoAndStop(_currentSkyPage);
                    setSkillTree(_currentSkyPage);
                };
            };
        }
        private function initEvent():void{
            var _local1:Sprite;
            jobBtn.addEventListener(MouseEvent.CLICK, updateMainBtn);
            otherBtn.addEventListener(MouseEvent.CLICK, updateMainBtn);
            lifeBtn.addEventListener(MouseEvent.CLICK, updateMainBtn);
            _skyPreBtn.addEventListener(MouseEvent.CLICK, onSelectSkyBook);
            _skyNextBtn.addEventListener(MouseEvent.CLICK, onSelectSkyBook);
            _preBtn.addEventListener(MouseEvent.CLICK, updatePage);
            _nextBtn.addEventListener(MouseEvent.CLICK, updatePage);
            for each (_local1 in frameCellArr) {
                _local1.addEventListener(MouseEvent.CLICK, onClickFrame);
            };
            for each (_local1 in frameCellArrOhter) {
                _local1.addEventListener(MouseEvent.CLICK, onClickFrame);
            };
        }
        private function updatePage(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == _preBtn){
                if (_currentSkillPage > 1){
                    _currentSkillPage--;
                    setSkillList();
                    updateListPage(_currentSkillPage);
                };
            } else {
                if (_arg1.currentTarget == _nextBtn){
                    if (_currentSkillPage < _totalSkillPage){
                        _currentSkillPage++;
                        setSkillList();
                        updateListPage(_currentSkillPage);
                    };
                };
            };
        }
        private function judgeAuto(_arg1:SkillInfo):void{
            var _local2:Boolean = SharedManager.getInstance().GetSkillAutoInfo(_arg1.TypeID.toString());
            AutoPlayData.AutoCommonSkillIdList[_arg1.TypeID] = _local2;
            if (_local2){
                AutoPlayData.CommonSkillList[_arg1.TypeID] = _arg1;
            } else {
                if (AutoPlayData.CommonSkillList[_arg1.TypeID] != null){
                    delete AutoPlayData.CommonSkillList[_arg1.TypeID];
                };
            };
        }

    }
}//package GameUI.Modules.HeroSkill.Mediator 
