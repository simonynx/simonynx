//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.items.*;
    import GameUI.View.HButton.*;

    public class ActivityRewardList extends Sprite {

        public const COUNT:int = 12;

        private var easyBtn:ToggleButton;
        private var pageDownBtn:HLabelButton;
        private var infoArr:Array;
        private var currentInfoArr:Array;
        private var currentBtn:ToggleButton;
        private var view:Sprite;
        private var currentPage:int = 1;
        private var hardBtn:ToggleButton;
        private var pageUpBtn:HLabelButton;
        private var normalBtn:ToggleButton;
        private var totalPage:int = 1;

        public function ActivityRewardList(){
            init();
            initEvent();
        }
        private function setPageText():void{
            totalPage = Math.ceil((currentInfoArr.length / COUNT));
            if (totalPage == 0){
                totalPage = 1;
            };
            currentPage = 1;
            view["pageTxt"].text = ((currentPage + "/") + totalPage);
        }
        private function init():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ActivityRewardListAsset");
            this.addChild(view);
            easyBtn = new ToggleButton(0, LanguageMgr.GetTranslation("简单"));
            easyBtn.x = 5;
            easyBtn.y = 1;
            view.addChildAt(easyBtn, 0);
            normalBtn = new ToggleButton(0, LanguageMgr.GetTranslation("普通"));
            normalBtn.x = 59;
            normalBtn.y = 1;
            view.addChildAt(normalBtn, 0);
            hardBtn = new ToggleButton(0, LanguageMgr.GetTranslation("困难"));
            hardBtn.x = 112;
            hardBtn.y = 1;
            view.addChildAt(hardBtn, 0);
            pageUpBtn = new HLabelButton();
            pageUpBtn.label = LanguageMgr.GetTranslation("上页");
            pageUpBtn.x = 5;
            pageUpBtn.y = 149;
            this.addChild(pageUpBtn);
            pageDownBtn = new HLabelButton();
            pageDownBtn.label = LanguageMgr.GetTranslation("下页");
            pageDownBtn.x = 118;
            pageDownBtn.y = 149;
            this.addChild(pageDownBtn);
            easyBtn.visible = false;
            normalBtn.visible = false;
            hardBtn.visible = false;
            currentInfoArr = [];
            setReward();
            view["pageTxt"].text = ((currentPage + "/") + totalPage);
        }
        private function onPageHandler(_arg1:MouseEvent):void{
            if (_arg1.currentTarget == pageUpBtn){
                if (currentPage > 1){
                    currentPage--;
                    view["pageTxt"].text = ((currentPage + "/") + totalPage);
                    setReward();
                };
            } else {
                if (currentPage < totalPage){
                    currentPage++;
                    view["pageTxt"].text = ((currentPage + "/") + totalPage);
                    setReward();
                };
            };
        }
        private function removeEvent():void{
            easyBtn.removeEventListener(MouseEvent.CLICK, onToggleHandler);
            normalBtn.removeEventListener(MouseEvent.CLICK, onToggleHandler);
            hardBtn.removeEventListener(MouseEvent.CLICK, onToggleHandler);
            pageUpBtn.removeEventListener(MouseEvent.CLICK, onPageHandler);
            pageDownBtn.removeEventListener(MouseEvent.CLICK, onPageHandler);
        }
        private function onToggleHandler(_arg1:MouseEvent):void{
            if (currentBtn){
                currentBtn.selected = false;
            };
            if (_arg1.currentTarget == easyBtn){
                currentInfoArr = infoArr[0];
            } else {
                if (_arg1.currentTarget == normalBtn){
                    if (infoArr[1]){
                        currentInfoArr = infoArr[1];
                    };
                } else {
                    if (_arg1.currentTarget == hardBtn){
                        if (infoArr[2]){
                            currentInfoArr = infoArr[2];
                        };
                    };
                };
            };
            currentBtn = (_arg1.currentTarget as ToggleButton);
            currentBtn.selected = true;
            setPageText();
            setReward();
        }
        private function setReward():void{
            var _local5:Sprite;
            var _local6:FaceItem;
            var _local1:int = ((currentPage - 1) * COUNT);
            var _local2:int = (currentPage * COUNT);
            var _local3:int;
            var _local4:int;
            while (_local1 < _local2) {
                _local5 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
                _local5.x = ((_local3 * 40) + 5);
                _local5.y = ((_local4 * 40) + 26);
                this.addChild(_local5);
                if (currentInfoArr[_local1]){
                    _local6 = new FaceItem(currentInfoArr[_local1], _local5);
                    _local6.mouseChildren = false;
                    _local6.mouseEnabled = false;
                    _local5.name = ("activitytarget_" + currentInfoArr[_local1]);
                    _local5.addChild(_local6);
                };
                _local3++;
                _local1++;
                if ((_local3 % 4) == 0){
                    _local3 = 0;
                    _local4++;
                };
            };
        }
        private function initEvent():void{
            easyBtn.addEventListener(MouseEvent.CLICK, onToggleHandler);
            normalBtn.addEventListener(MouseEvent.CLICK, onToggleHandler);
            hardBtn.addEventListener(MouseEvent.CLICK, onToggleHandler);
            pageUpBtn.addEventListener(MouseEvent.CLICK, onPageHandler);
            pageDownBtn.addEventListener(MouseEvent.CLICK, onPageHandler);
        }
        public function setRewardListInfo(_arg1:Array):void{
            infoArr = _arg1;
            if (infoArr.length <= 1){
                easyBtn.visible = false;
                normalBtn.visible = false;
                hardBtn.visible = false;
            } else {
                if (infoArr.length > 1){
                    easyBtn.visible = true;
                    normalBtn.visible = true;
                    hardBtn.visible = true;
                };
            };
            easyBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

    }
}//package GameUI.Modules.Activity.UI 
