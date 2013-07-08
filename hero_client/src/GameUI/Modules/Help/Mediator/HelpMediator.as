//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Help.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import flash.net.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Utils.*;
    import GameUI.Modules.Help.Data.*;
    import GameUI.*;

    public class HelpMediator extends Mediator {

        public static const NAME:String = "HelpMediator";

        private var hframe:HFrame;
        private var helpView:MovieClip;
        private var page:uint = 0;
        private var normalMenuColor:String = "#FFAE00";
        private var _nextBtn:HLabelButton = null;
        private var commonQuestionBtn:ToggleButton;
        private var menuInfo:HelpInfo;
        private var greenServiceBtn:ToggleButton;
        private var currKey:String = "";
        private var helpVersion:Number;
        private var _preBtn:HLabelButton = null;
        private var commitQuestionBtn:ToggleButton;
        private var itemInfo:HelpInfo;
        private var dataProxy:DataProxy;
        private var normalItemColor:String = "#A2FF00";
        private var overColor:String = "#00FF00";
        private var totalPage:uint;
        private var backBtn:HLabelButton;
        private var pageNum:uint = 12;
        private var hotNum:uint = 9;
        private var serviceView:MovieClip;
        private var helpIsInit:Boolean = false;

        public function HelpMediator(){
            super(NAME);
        }
        private function removeHotEvent():void{
            var _local1:HelpInfo;
            var _local2:uint;
            if (currKey == ""){
                _local2 = 0;
                for each (_local1 in GameCommonData.GameHelpHotList) {
                    if (_local2 < hotNum){
                        _local1.hotMc.txtItem.removeEventListener(TextEvent.LINK, onClickHotLink);
                        _local1.hotMc.txtItem.removeEventListener(MouseEvent.MOUSE_OVER, onClickOver);
                        _local1.hotMc.txtItem.removeEventListener(MouseEvent.MOUSE_OUT, onClickOut);
                    };
                    _local2++;
                };
            };
        }
        private function addHelpMenu():void{
            var _local1:HelpInfo;
            var _local2:uint;
            for each (_local1 in GameCommonData.GameHelpClassList) {
                if (!_local1.mc){
                    _local1.mc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("HelpMenu");
                    _local2 = (_local1.index - 10);
                    _local1.mc.x = (20 + ((_local2 % 4) * 95));
                    _local1.mc.y = (30 + (uint((_local2 / 4)) * 24));
                    _local1.mc.txtMenu.htmlText = (((((("<font color=\"" + normalMenuColor) + "\"><a href=\"event:") + _local1.index) + "\">") + _local1.title) + "</font>");
                };
                helpView.addChild(_local1.mc);
            };
            helpView.mcHelpView.txt_page.visible = false;
            helpView.mcHelpView.gotoAndStop(1);
            helpView.mcHelpView.txtTitle.text = LanguageMgr.GetTranslation("帮助列表");
        }
        private function onClickLink(_arg1:TextEvent):void{
            var _local2:String = (_arg1.currentTarget as TextField).htmlText;
            _local2 = _local2.replace(overColor, normalMenuColor);
            (_arg1.currentTarget as TextField).htmlText = _local2;
            removeHelpMenu();
            removeMenuEvent();
            removeHotEvent();
            removeHotItem();
            currKey = _arg1.text;
            page = 1;
            helpView.mcHelpView.gotoAndStop(2);
            addHelpItem(currKey);
            menuInfo = GameCommonData.GameHelpClassList[currKey];
            helpView.mcHelpView.txtTitle.text = menuInfo.title;
        }
        private function removeMenuEvent():void{
            var _local1:HelpInfo;
            if (currKey == ""){
                for each (_local1 in GameCommonData.GameHelpClassList) {
                    _local1.mc.txtMenu.removeEventListener(TextEvent.LINK, onClickLink);
                    _local1.mc.txtMenu.removeEventListener(MouseEvent.MOUSE_OVER, onClickOver);
                    _local1.mc.txtMenu.removeEventListener(MouseEvent.MOUSE_OUT, onClickMenuOut);
                };
            };
        }
        private function addHotEvent():void{
            var _local1:HelpInfo;
            var _local2:uint;
            for each (_local1 in GameCommonData.GameHelpHotList) {
                if (_local2 < hotNum){
                    _local1.hotMc.txtItem.addEventListener(TextEvent.LINK, onClickHotLink);
                    _local1.hotMc.txtItem.addEventListener(MouseEvent.MOUSE_OVER, onClickOver);
                    _local1.hotMc.txtItem.addEventListener(MouseEvent.MOUSE_OUT, onClickOut);
                    if (_local2 == 0){
                        helpView.txtAsk.text = _local1.title;
                        helpView.txtAnswer.text = _local1.desc;
                    };
                };
                _local2++;
            };
            if (_local2 == 0){
                helpView.txtAsk.text = "";
                helpView.txtAnswer.text = "";
            };
        }
        private function removeHelpItem():void{
            var _local1:HelpInfo;
            var _local2:uint;
            if (currKey != ""){
                _local2 = 0;
                for each (_local1 in GameCommonData.GameHelpList[currKey]) {
                    if ((((_local2 >= ((page - 1) * pageNum))) && ((_local2 < (page * pageNum))))){
                        helpView.removeChild(_local1.mc);
                    };
                    _local2++;
                };
                helpView.removeChild(_preBtn);
                helpView.removeChild(_nextBtn);
                helpView.removeChild(backBtn);
            };
        }
        private function addHotItem():void{
            var _local1:HelpInfo;
            var _local3:uint;
            var _local2:uint;
            for each (_local1 in GameCommonData.GameHelpHotList) {
                if (_local2 < hotNum){
                    if (!_local1.hotMc){
                        _local1.hotMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("HelpItem");
                        _local3 = (_local1.index - 10);
                        _local1.hotMc.x = 20;
                        _local1.hotMc.y = (132 + (_local2 * 21));
                        _local1.hotMc.txtItem.htmlText = (((((("<font color=\"" + normalItemColor) + "\"><a href=\"event:") + _local1.index) + "\">") + _local1.title) + "</font>");
                    };
                    helpView.addChild(_local1.hotMc);
                };
                _local2++;
            };
        }
        private function onCom(_arg1:Event):void{
            var _local2:XML = new XML(_arg1.currentTarget.data);
            parseHelpData(_local2);
            GameCommonData.GameInstance.Content.UnLoad(((GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameData/GameHelp.xml?v=") + helpVersion));
            addHelpMenu();
            addMenuEvent();
            addHotItem();
            addHotEvent();
        }
        private function removeItemEvent():void{
            var _local1:HelpInfo;
            var _local2:uint;
            if (currKey != ""){
                _local2 = 0;
                for each (_local1 in GameCommonData.GameHelpList[currKey]) {
                    if ((((_local2 >= ((page - 1) * pageNum))) && ((_local2 < (page * pageNum))))){
                        _local1.mc.txtItem.removeEventListener(TextEvent.LINK, onClickItemLink);
                        _local1.mc.txtItem.removeEventListener(MouseEvent.MOUSE_OVER, onClickOver);
                        _local1.mc.txtItem.removeEventListener(MouseEvent.MOUSE_OUT, onClickOut);
                    };
                    _local2++;
                };
                backBtn.removeEventListener(MouseEvent.CLICK, backHandler);
                _preBtn.addEventListener(MouseEvent.CLICK, updatePage);
                _nextBtn.addEventListener(MouseEvent.CLICK, updatePage);
                backBtn.addEventListener(MouseEvent.CLICK, backHandler);
            };
        }
        private function btnClickHandler(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == commitQuestionBtn){
                closePanel();
                facade.sendNotification(EventList.SHOW_GMMAIL_UI, {
                    posX:hframe.x,
                    posY:hframe.y
                });
                return;
            };
            if (_arg1.currentTarget == greenServiceBtn){
                if (!serviceView){
                    serviceView = new MovieClip();
                    ResourcesFactory.getInstance().getResource((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GreenService), onLoabdComplete);
                } else {
                    hframe.addChild(serviceView);
                };
                helpView.visible = false;
                commonQuestionBtn.selected = false;
                greenServiceBtn.selected = true;
                hframe.addChild(greenServiceBtn);
                commonQuestionBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            } else {
                if (_arg1.currentTarget == commonQuestionBtn){
                    helpView.visible = true;
                    commonQuestionBtn.selected = true;
                    if (greenServiceBtn){
                        greenServiceBtn.selected = false;
                    };
                    if (((serviceView) && (hframe.contains(serviceView)))){
                        hframe.removeChild(serviceView);
                    };
                    commonQuestionBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
                };
            };
        }
        private function addItemEvent():void{
            var _local1:HelpInfo;
            var _local2:uint;
            for each (_local1 in GameCommonData.GameHelpList[currKey]) {
                if ((((_local2 >= ((page - 1) * pageNum))) && ((_local2 < (page * pageNum))))){
                    _local1.mc.txtItem.addEventListener(TextEvent.LINK, onClickItemLink);
                    _local1.mc.txtItem.addEventListener(MouseEvent.MOUSE_OVER, onClickOver);
                    _local1.mc.txtItem.addEventListener(MouseEvent.MOUSE_OUT, onClickOut);
                    if (_local2 == ((page - 1) * pageNum)){
                        itemInfo = _local1;
                        helpView.txtAsk.text = itemInfo.title;
                        helpView.txtAnswer.text = itemInfo.desc;
                    };
                };
                _local2++;
            };
            if (_local2 == 0){
                helpView.txtAsk.text = "";
                helpView.txtAnswer.text = "";
            };
            _preBtn.addEventListener(MouseEvent.CLICK, updatePage);
            _nextBtn.addEventListener(MouseEvent.CLICK, updatePage);
            backBtn.addEventListener(MouseEvent.CLICK, backHandler);
        }
        private function initViewUI():void{
            hframe = new HFrame();
            hframe.titleText = LanguageMgr.GetTranslation("联系GM");
            hframe.centerTitle = true;
            hframe.blackGound = false;
            hframe.closeCallBack = closePanel;
            commonQuestionBtn = new ToggleButton(1, LanguageMgr.GetTranslation("常见问题"));
            commonQuestionBtn.x = 15;
            commonQuestionBtn.y = 34;
            commonQuestionBtn.selected = true;
            commitQuestionBtn = new ToggleButton(1, LanguageMgr.GetTranslation("提交问题"));
            commitQuestionBtn.x = ((commonQuestionBtn.x + commonQuestionBtn.width) + 2);
            commitQuestionBtn.y = 34;
            commitQuestionBtn.selected = false;
            helpView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GameHelp");
            helpView.x = 4;
            helpView.y = 52;
            hframe.setSize((helpView.width + 8), 391);
            hframe.X = ((GameCommonData.GameInstance.ScreenWidth - hframe.width) / 2);
            hframe.Y = ((GameCommonData.GameInstance.ScreenHeight - hframe.height) / 2);
            helpView.txtAsk.text = "";
            helpView.txtAnswer.text = "";
            helpView.mcHelpView.txtTitle.mouseEnabled = false;
        }
        private function onClickOut(_arg1:MouseEvent):void{
            var _local2:String = (_arg1.currentTarget as TextField).htmlText;
            _local2 = _local2.replace(overColor, normalItemColor);
            (_arg1.currentTarget as TextField).htmlText = _local2;
        }
        private function addHelpItem(_arg1:String):void{
            var _local2:HelpInfo;
            var _local4:uint;
            var _local3:uint;
            for each (_local2 in GameCommonData.GameHelpList[_arg1]) {
                if ((((_local3 >= ((page - 1) * pageNum))) && ((_local3 < (page * pageNum))))){
                    if (!_local2.mc){
                        _local2.mc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("HelpItem");
                        _local4 = (_local2.index - 10);
                        _local2.mc.x = 20;
                        _local2.mc.y = (35 + ((_local3 - ((page - 1) * pageNum)) * 21));
                        _local2.mc.txtItem.htmlText = (((((("<font color=\"" + normalItemColor) + "\"><a href=\"event:") + _local2.index) + "\">") + _local2.title) + "</font>");
                    };
                    helpView.addChild(_local2.mc);
                };
                _local3++;
            };
            totalPage = (uint((_local3 / pageNum)) + (((_local3 % pageNum))>0) ? 1 : 0);
            if (totalPage == 0){
                totalPage = 1;
            };
            helpView.mcHelpView.txt_page.visible = true;
            helpView.mcHelpView.txt_page.text = ((String(page) + "/") + String(totalPage));
            if (_preBtn == null){
                _preBtn = new HLabelButton(2);
                _preBtn.label = LanguageMgr.GetTranslation("上页");
                _preBtn.x = 143;
                _preBtn.y = 300;
                _nextBtn = new HLabelButton(2);
                _nextBtn.label = LanguageMgr.GetTranslation("下页");
                _nextBtn.x = 243;
                _nextBtn.y = 300;
                backBtn = new HLabelButton();
                backBtn.x = 330;
                backBtn.y = 300;
                backBtn.label = LanguageMgr.GetTranslation("返回");
            };
            helpView.addChild(_preBtn);
            helpView.addChild(_nextBtn);
            helpView.addChild(backBtn);
            addItemEvent();
        }
        private function onClickItemLink(_arg1:TextEvent):void{
            itemInfo = GameCommonData.GameHelpList[menuInfo.index][_arg1.text];
            helpView.txtAsk.text = itemInfo.title;
            helpView.txtAnswer.text = itemInfo.desc;
        }
        private function initHelpData():void{
            var _local1:URLLoader = new URLLoader();
            helpVersion = Math.random();
            _local1.load(new URLRequest(((GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameData/GameHelp.xml?v=") + helpVersion)));
            _local1.addEventListener(Event.COMPLETE, onCom);
        }
        private function onLoabdComplete():void{
            serviceView = ResourcesFactory.getInstance().getswfResourceByUrl((GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GreenService));
            serviceView.x = 4;
            serviceView.y = 52;
            hframe.addChild(serviceView);
        }
        private function onClickHotLink(_arg1:TextEvent):void{
            itemInfo = GameCommonData.GameHelpHotList[_arg1.text];
            helpView.txtAsk.text = itemInfo.title;
            helpView.txtAnswer.text = itemInfo.desc;
        }
        private function onClickMenuOut(_arg1:MouseEvent):void{
            var _local2:String = (_arg1.currentTarget as TextField).htmlText;
            _local2 = _local2.replace(overColor, normalMenuColor);
            (_arg1.currentTarget as TextField).htmlText = _local2;
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:uint;
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    break;
                case EventList.SHOW_HELP_UI:
                    if (GameCommonData.IsInCrossServer){
                        return;
                    };
                    if (!hframe){
                        initViewUI();
                    } else {
                        if (((_arg1.getBody()) && (_arg1.getBody().hasOwnProperty("posX")))){
                            hframe.X = _arg1.getBody().posX;
                            hframe.Y = _arg1.getBody().posY;
                        } else {
                            hframe.X = ((GameCommonData.GameInstance.ScreenWidth / 2) - (hframe.width / 2));
                            hframe.Y = ((GameCommonData.GameInstance.ScreenHeight / 2) - (hframe.height / 2));
                        };
                    };
                    if (((((!(greenServiceBtn)) && (!((GameConfigData.GreenService == ""))))) && ((GameCommonData.totalPayMoney >= GameCommonData.goldenAccountNeed)))){
                        greenServiceBtn = new ToggleButton(1, LanguageMgr.GetTranslation("金牌客服"));
                        greenServiceBtn.x = ((commitQuestionBtn.x + commitQuestionBtn.width) + 2);
                        greenServiceBtn.y = 34;
                        greenServiceBtn.selected = false;
                    };
                    hframe.addChild(helpView);
                    hframe.addChild(commonQuestionBtn);
                    hframe.addChild(commitQuestionBtn);
                    GameCommonData.GameInstance.GameUI.addChild(hframe);
                    initEvent();
                    helpView.visible = true;
                    commonQuestionBtn.selected = true;
                    commitQuestionBtn.selected = false;
                    if (((!((GameConfigData.GreenService == ""))) && ((GameCommonData.totalPayMoney >= GameCommonData.goldenAccountNeed)))){
                        hframe.addChild(greenServiceBtn);
                        greenServiceBtn.selected = false;
                    };
                    dataProxy.HelpIsOpen = true;
                    if (((_arg1.getBody()) && (_arg1.getBody().hasOwnProperty("toggleGreenService")))){
                        greenServiceBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    };
                    if (!helpIsInit){
                        initHelpData();
                        helpIsInit = true;
                        removeHelp(_arg1);
                        return;
                    };
                    addHelpMenu();
                    addMenuEvent();
                    addHotItem();
                    addHotEvent();
                    removeHelp(_arg1);
                    break;
                case EventList.CLOSE_HELP_UI:
                    closePanel();
                    break;
            };
        }
        private function removeHotItem():void{
            var _local1:HelpInfo;
            var _local2:uint;
            if (currKey == ""){
                _local2 = 0;
                for each (_local1 in GameCommonData.GameHelpHotList) {
                    if (_local2 < hotNum){
                        helpView.removeChild(_local1.hotMc);
                    };
                    _local2++;
                };
            };
        }
        private function onClickOver(_arg1:MouseEvent):void{
            var _local2:String = (_arg1.currentTarget as TextField).htmlText;
            if (_local2.indexOf(normalMenuColor) != -1){
                _local2 = _local2.replace(normalMenuColor, overColor);
            } else {
                _local2 = _local2.replace(normalItemColor, overColor);
            };
            (_arg1.currentTarget as TextField).htmlText = _local2;
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.CLOSE_HELP_UI, EventList.SHOW_HELP_UI, EventList.ENTERMAPCOMPLETE]);
        }
        private function backHandler(_arg1:MouseEvent):void{
            removeItemEvent();
            removeHelpItem();
            currKey = "";
            addHelpMenu();
            addMenuEvent();
            addHotItem();
            addHotEvent();
        }
        private function removeHelp(_arg1:INotification):void{
            if (((_arg1.getBody()) && (_arg1.getBody().hasOwnProperty("toggleGreenService")))){
                helpView.visible = false;
            };
        }
        private function removeHelpMenu():void{
            var _local1:HelpInfo;
            if (currKey == ""){
                for each (_local1 in GameCommonData.GameHelpClassList) {
                    _local1.mc.parent.removeChild(_local1.mc);
                };
            };
        }
        private function closePanel():void{
            if (dataProxy.HelpIsOpen == false){
                return;
            };
            removeMenuEvent();
            removeHelpMenu();
            removeItemEvent();
            removeHotEvent();
            removeHotItem();
            removeHelpItem();
            removeEvent();
            hframe.removeChild(commonQuestionBtn);
            hframe.removeChild(commitQuestionBtn);
            if (greenServiceBtn){
                hframe.removeChild(greenServiceBtn);
            };
            hframe.removeChild(helpView);
            if (((serviceView) && (hframe.contains(serviceView)))){
                hframe.removeChild(serviceView);
            };
            hframe.close();
            currKey = "";
            dataProxy.HelpIsOpen = false;
        }
        private function parseHelpData(_arg1:XML):void{
            var _local4:Array;
            var _local5:Array;
            var _local6:HelpInfo;
            var _local2:int = _arg1.record.length();
            var _local3:int;
            while (_local3 < _local2) {
                _local6 = new HelpInfo();
                _local6.title = String(_arg1.record[_local3].@title);
                _local6.index = uint(_arg1.record[_local3].@index);
                _local6.hot = uint(_arg1.record[_local3].@hot);
                _local6.desc = String(_arg1.record[_local3].@desc);
                if (String(_local6.index).length == 2){
                    GameCommonData.GameHelpClassList[_local6.index] = _local6;
                } else {
                    if (GameCommonData.GameHelpList[String(_local6.index).substr(0, 2)] == null){
                        GameCommonData.GameHelpList[String(_local6.index).substr(0, 2)] = new Dictionary();
                    };
                    GameCommonData.GameHelpList[String(_local6.index).substr(0, 2)][String(_local6.index)] = _local6;
                    if (_local6.hot == 1){
                        GameCommonData.GameHelpHotList[_local6.index] = _local6;
                    };
                };
                _local3++;
            };
        }
        private function initEvent():void{
            commitQuestionBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            if (greenServiceBtn){
                greenServiceBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
            };
        }
        private function updatePage(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == _preBtn){
                if (page > 1){
                    removeItemEvent();
                    removeHelpItem();
                    page--;
                    addHelpItem(currKey);
                };
            } else {
                if (_arg1.currentTarget == _nextBtn){
                    if (page < totalPage){
                        removeItemEvent();
                        removeHelpItem();
                        page++;
                        addHelpItem(currKey);
                    };
                };
            };
        }
        private function addMenuEvent():void{
            var _local1:HelpInfo;
            for each (_local1 in GameCommonData.GameHelpClassList) {
                _local1.mc.txtMenu.addEventListener(TextEvent.LINK, onClickLink);
                _local1.mc.txtMenu.addEventListener(MouseEvent.MOUSE_OVER, onClickOver);
                _local1.mc.txtMenu.addEventListener(MouseEvent.MOUSE_OUT, onClickMenuOut);
            };
        }
        private function removeEvent():void{
            commitQuestionBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            if (greenServiceBtn){
                greenServiceBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
            if (commonQuestionBtn.hasEventListener(MouseEvent.CLICK)){
                commonQuestionBtn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
            };
        }

    }
}//package GameUI.Modules.Help.Mediator 
