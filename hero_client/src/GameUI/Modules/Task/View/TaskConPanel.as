//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.Components.*;
    import Utils.*;
    import OopsEngine.Graphics.*;
    import GameUI.Modules.Task.Interface.*;

    public class TaskConPanel extends UIScrollPane implements ITaskTimeUpdate {

        protected var money:TextField;
        protected var prestigeTT:TaskText;
        private var bg:MovieClip;
        private var acceptNnpTT:TaskText;
        protected var taskObtain:TaskText;
        private var _height:int;
        protected var goodsPanel:EquPanel;
        public var selectedGoodType:int = -1;
        private var taskInfo:TaskInfoStruct;
        private var finishNpcTT:TaskText;
        private var _width:int;
        protected var goodsDes:TaskText;
        protected var exp:TaskText;
        protected var moneySprite:Sprite;
        protected var taskProcessTT:TaskText;
        private var content:UISprite;
        private var itemCellsArray:Array;

        public function TaskConPanel(_arg1:int, _arg2:int){
            content = new UISprite();
            content.width = _arg1;
            content.height = _arg2;
            super(content);
            this._width = _arg1;
            this._height = _arg2;
            init();
        }
        private function textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            return (_local1);
        }
        private function update():void{
            var _local1:String;
            removeItemReward();
            this.taskObtain.tfText = (("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("任务奖励")) + ":</font>");
            this.money.htmlText = ((taskInfo.rewardGold > 0)) ? (((("<font color=\"#D6C29C\">&nbsp;&nbsp;" + LanguageMgr.GetTranslation("金币")) + ":") + UIUtils.getMoneyStandInfo(taskInfo.rewardGold, ["\\ce", "\\cs", "\\cc"])) + "</font>") : "";
            ShowMoney.ShowIcon(this.moneySprite, this.money, true);
            moneySprite.visible = true;
            this.exp.tfText = ((taskInfo.rewardExp > 0)) ? (((("<font color=\"#D6C29C\">&nbsp;&nbsp;" + LanguageMgr.GetTranslation("经验")) + ":") + String(taskInfo.rewardExp)) + "</font>") : "";
            this.prestigeTT.tfText = ((taskInfo.rewardPrestige > 0)) ? (((("<font color=\"#D6C29C\">&nbsp;&nbsp;" + LanguageMgr.GetTranslation("声望")) + ":") + String(taskInfo.rewardPrestige)) + "</font>") : "";
            if (taskInfo.IsAccept){
                if (!taskInfo.IsComplete){
                    this.finishNpcTT.tfText = "";
                    this.acceptNnpTT.tfText = "";
                    _local1 = taskInfo.getConditionDes();
                    _local1 = _local1.replace(/<u>/gi, "").replace(/<\/u>/gi, "");
                    this.taskProcessTT.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("完成条件")) + ":</font><br><font color=\"#D6C29C\">") + _local1) + "</font>");
                } else {
                    this.finishNpcTT.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("完成NPC")) + ":</font><br><font color=\"#D6C29C\">&nbsp;&nbsp;") + taskInfo.taskCommitNPCAndPoint) + "</font>");
                    this.acceptNnpTT.tfText = "";
                    this.taskProcessTT.tfText = "";
                };
            } else {
                this.finishNpcTT.tfText = "";
                this.acceptNnpTT.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("接受任务NPC")) + "</font><br><font color=\"#D6C29C\">&nbsp;&nbsp;") + taskInfo.taskNPCAndPoint) + "</font>");
                this.taskProcessTT.tfText = "";
            };
            if ((((taskInfo.ItemRewards.length > 0)) || ((taskInfo.ItemRewardsOptionals.length > 0)))){
                this.goodsDes = new TaskText(290);
                this.goodsDes.tfText = "";
                this.goodsPanel = new EquPanel(taskInfo.ItemRewardsOptionals.concat(taskInfo.ItemRewards), false);
                content.addChild(this.goodsDes);
                content.addChild(this.goodsPanel);
            };
            doLayout();
        }
        protected function changeSelectedGood(_arg1:uint):void{
            this.selectedGoodType = _arg1;
        }
        private function init():void{
            this.width = _width;
            this.height = _height;
            this.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            itemCellsArray = [];
            this.taskObtain = new TaskText(290);
            content.addChild(this.taskObtain);
            this.moneySprite = new Sprite();
            this.money = new TextField();
            this.money.filters = OopsEngine.Graphics.Font.Stroke();
            this.money.defaultTextFormat = this.textFormat();
            this.money.width = 600;
            this.money.autoSize = TextFieldAutoSize.LEFT;
            this.money.wordWrap = false;
            this.money.mouseEnabled = false;
            this.money.selectable = false;
            this.moneySprite.addChild(this.money);
            content.addChild(this.moneySprite);
            this.exp = new TaskText(290);
            content.addChild(this.exp);
            prestigeTT = new TaskText(290);
            content.addChild(this.prestigeTT);
            finishNpcTT = new TaskText(290);
            content.addChild(finishNpcTT);
            acceptNnpTT = new TaskText(290);
            content.addChild(acceptNnpTT);
            taskProcessTT = new TaskText(290);
            content.addChild(taskProcessTT);
        }
        private function removeItemReward():void{
            if (((goodsDes) && (goodsDes.parent))){
                goodsDes.parent.removeChild(goodsDes);
            };
            if (((goodsPanel) && (goodsPanel.parent))){
                goodsPanel.parent.removeChild(goodsPanel);
            };
        }
        public function Update():void{
            var _local1:String;
            if (((taskInfo) && (taskInfo.IsAccept))){
                if (!taskInfo.IsComplete){
                    this.finishNpcTT.tfText = "";
                    this.acceptNnpTT.tfText = "";
                    _local1 = taskInfo.getConditionDes();
                    _local1 = _local1.replace(/<u>/gi, "").replace(/<\/u>/gi, "");
                    this.taskProcessTT.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("完成条件")) + ":</font><br><font color=\"#D6C29C\">") + _local1) + "</font>");
                } else {
                    this.finishNpcTT.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("完成NPC")) + ":</font><br><font color=\"#D6C29C\">&nbsp;&nbsp;") + taskInfo.taskCommitNPCAndPoint) + "</font>");
                    this.acceptNnpTT.tfText = "";
                    this.taskProcessTT.tfText = "";
                };
            } else {
                this.finishNpcTT.tfText = "";
                this.acceptNnpTT.tfText = (((("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("接受任务NPC")) + "</font><br><font color=\"#D6C29C\">&nbsp;&nbsp;") + taskInfo.taskNPCAndPoint) + "</font>");
                this.taskProcessTT.tfText = "";
            };
        }
        public function clearContent():void{
            removeItemReward();
            this.taskProcessTT.tfText = "";
            this.taskObtain.tfText = "";
            this.money.htmlText = "";
            this.exp.tfText = "";
            this.prestigeTT.tfText = "";
            finishNpcTT.tfText = "";
            acceptNnpTT.tfText = "";
            moneySprite.visible = false;
            doLayout();
        }
        protected function doLayout():void{
            var _local1:int;
            if (this.taskProcessTT.tfText != ""){
                this.taskProcessTT.y = _local1;
                _local1 = ((this.taskProcessTT.y + this.taskProcessTT.height) + 10);
            };
            if (this.acceptNnpTT.tfText != ""){
                this.acceptNnpTT.y = _local1;
                _local1 = ((this.acceptNnpTT.y + this.acceptNnpTT.height) + 10);
            };
            if (finishNpcTT.tfText != ""){
                this.finishNpcTT.y = _local1;
                _local1 = ((this.finishNpcTT.y + this.finishNpcTT.height) + 10);
            };
            this.taskObtain.y = _local1;
            _local1 = (this.taskObtain.y + this.taskObtain.height);
            if (((taskInfo) && ((taskInfo.rewardGold > 0)))){
                this.moneySprite.y = _local1;
                _local1 = (this.moneySprite.y + this.moneySprite.height);
            };
            if (((taskInfo) && ((taskInfo.rewardExp > 0)))){
                this.exp.y = _local1;
                _local1 = (this.exp.y + this.exp.height);
            };
            if (((taskInfo) && ((taskInfo.rewardPrestige > 0)))){
                this.prestigeTT.y = _local1;
                _local1 = (this.prestigeTT.y + this.prestigeTT.height);
            };
            if (((goodsDes) && (goodsPanel))){
                this.goodsDes.y = (_local1 - 8);
                _local1 = (this.goodsDes.y + this.goodsDes.height);
                this.goodsPanel.y = _local1;
                _local1 = (this.goodsPanel.y + this.goodsPanel.height);
            };
            content.height = (_local1 + 10);
            refresh();
        }
        public function get info():TaskInfoStruct{
            return (taskInfo);
        }
        public function set info(_arg1:TaskInfoStruct):void{
            this.taskInfo = _arg1;
            update();
        }

    }
}//package GameUI.Modules.Task.View 
