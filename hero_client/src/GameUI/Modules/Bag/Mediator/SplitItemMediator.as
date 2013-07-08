//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Bag.Datas.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.Modules.Bag.Mediator.DealItem.*;
    import GameUI.*;

    public class SplitItemMediator extends Mediator {

        public static const NAME:String = "SplitItemMediator";
        private static const textformat:TextFormat = new TextFormat(LanguageMgr.DEFAULT_FONT, 12, 0xFFFF00, null, null, null, null, null, TextFormatAlign.CENTER);

        private var grid:GridUnit = null;
        private var itemData:Object = null;
        private var curNum:int = 1;
        private var splitcontent:MovieClip;
        private var panelBase:PanelBase = null;

        public function SplitItemMediator(){
            super(NAME);
        }
        private function getSplitPos():Point{
            var _local1:Point = new Point();
            _local1.x = (GameCommonData.GameInstance.ScreenWidth / 2);
            _local1.y = (GameCommonData.GameInstance.ScreenHeight / 2);
            var _local2:Number = _local1.x;
            var _local3:Number = _local1.y;
            if (_local2 < 0){
                _local1.x = 0;
            } else {
                if (((_local2 + splitcontent.width) + 40) > GameCommonData.GameInstance.ScreenWidth){
                    _local1.x = (GameCommonData.GameInstance.ScreenWidth - splitcontent.width);
                };
            };
            if (_local3 < 0){
                _local1.y = 0;
            } else {
                if (((_local3 + splitcontent.height) + 50) > GameCommonData.GameInstance.ScreenHeight){
                    _local1.y = (GameCommonData.GameInstance.ScreenHeight - splitcontent.height);
                };
            };
            return (_local1);
        }
        private function initView():void{
            splitcontent.txtNum.restrict = "0-9";
            splitcontent.txtNum.addEventListener(Event.CHANGE, onTextInput);
            splitcontent.txtNum.text = curNum;
            UIUtils.addFocusLis(splitcontent.txtNum);
            splitView.stage.focus = splitcontent.txtNum;
            (splitcontent.txtNum as TextField).setSelection(splitcontent.txtNum.length, splitcontent.txtNum.length);
            splitcontent.btnAdd.addEventListener(MouseEvent.CLICK, addHandler);
            splitcontent.btnSub.addEventListener(MouseEvent.CLICK, subHandler);
            splitView.okFunction = comFirmHandler;
            splitView.cancelFunction = cancelHandler;
        }
        private function panelCloseHandler():void{
            GameCommonData.GameInstance.GameUI.removeChild(splitView);
            removeListener();
            panelBase = null;
            this.viewComponent = null;
            BagData.SplitIsOpen = false;
            facade.removeMediator(NAME);
            BagData.lockBagGridUnit(true);
            BagData.lockBtnCleanAndPage(true);
        }
        private function removeListener():void{
            splitcontent.btnAdd.removeEventListener(MouseEvent.CLICK, addHandler);
            splitcontent.btnSub.removeEventListener(MouseEvent.CLICK, subHandler);
            UIUtils.removeFocusLis(splitcontent.txtNum);
        }
        private function get splitView():HConfirmFrame{
            return ((this.viewComponent as HConfirmFrame));
        }
        override public function listNotificationInterests():Array{
            return ([BagEvents.SHOWSPLIT, BagEvents.REMOVE_SPLIT]);
        }
        private function addHandler(_arg1:MouseEvent):void{
            curNum = int(splitcontent.txtNum.text);
            curNum++;
            if (curNum > (itemData.Count - 1)){
                curNum = (itemData.Count - 1);
            };
            splitcontent.txtNum.text = curNum;
        }
        private function comFirmHandler(_arg1:MouseEvent=null):void{
            curNum = int(splitcontent.txtNum.text);
            if ((((curNum > (itemData.Count - 1))) || ((curNum < 1)))){
                facade.sendNotification(HintEvents.RECEIVEINFO, {
                    info:LanguageMgr.GetTranslation("请输入正确的拆分数字"),
                    color:0xFFFF00
                });
                return;
            };
            SplitItem.Split(grid, int(splitcontent.txtNum.text));
            panelCloseHandler();
        }
        private function cancelHandler(_arg1:MouseEvent=null):void{
            panelCloseHandler();
        }
        private function subHandler(_arg1:MouseEvent):void{
            curNum = int(splitcontent.txtNum.text);
            curNum--;
            if (curNum < 1){
                curNum = 1;
            };
            splitcontent.txtNum.text = curNum;
        }
        override public function handleNotification(_arg1:INotification):void{
            var _local2:Point;
            switch (_arg1.getName()){
                case BagEvents.SHOWSPLIT:
                    BagData.SplitIsOpen = true;
                    grid = (_arg1.getBody() as GridUnit);
                    itemData = BagData.AllItems[BagData.SelectIndex][grid.Index];
                    splitcontent = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SplitView");
                    setViewComponent(new HConfirmFrame());
                    splitcontent["txtNum"] = new TextField();
                    splitcontent["txtNum"].type = TextFieldType.INPUT;
                    splitcontent["txtNum"].defaultTextFormat = textformat;
                    splitcontent["txtNum"].x = 75;
                    splitcontent["txtNum"].y = 51;
                    splitcontent["txtNum"].autoSize = TextFieldAutoSize.CENTER;
                    splitcontent.addChild(splitcontent["txtNum"]);
                    splitView.addChild(splitcontent);
                    splitView.setSize((splitcontent.width + 8), (splitcontent.height + 64));
                    splitView.alphaGound = true;
                    splitView.centerTitle = true;
                    splitView.showCancel = true;
                    splitView.titleText = LanguageMgr.GetTranslation("拆 分");
                    splitcontent.x = 4;
                    splitcontent.y = 31;
                    splitView.closeCallBack = panelCloseHandler;
                    GameCommonData.GameInstance.GameUI.addChild(splitView);
                    _local2 = getSplitPos();
                    splitView.x = _local2.x;
                    splitView.y = _local2.y;
                    curNum = 1;
                    initView();
                    BagData.lockBagGridUnit(false);
                    BagData.lockBtnCleanAndPage(false);
                    break;
                case BagEvents.REMOVE_SPLIT:
                    if (BagData.SplitIsOpen){
                        panelCloseHandler();
                    };
                    break;
            };
        }
        private function onTextInput(_arg1:Event):void{
            var _local2:int = int(splitcontent.txtNum.text);
            if (_local2 > (itemData.Count - 1)){
                _local2 = (itemData.Count - 1);
            };
            if (_local2 < 1){
                _local2 = 1;
            };
            splitcontent.txtNum.text = _local2.toString();
        }

    }
}//package GameUI.Modules.Bag.Mediator 
