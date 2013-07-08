//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.View {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import Utils.*;
    import OopsEngine.Graphics.*;

    public class RewardPanel extends Sprite {

        protected var money:TextField;
        protected var prestigeTT:TaskText;
        protected var moneySprite:Sprite;
        private var _info:TaskInfoStruct;
        public var goodsPanel:EquPanel;
        protected var taskObtain:TaskText;
        protected var exp:TaskText;

        public function RewardPanel(_arg1:TaskInfoStruct){
            this._info = _arg1;
            initView();
            addEvents();
            updateInfo();
        }
        private function doLayout():void{
            var _local1:Number = 10;
            var _local2:int = (this.taskObtain.y + this.taskObtain.height);
            if (((info) && ((info.rewardGold > 0)))){
                this.moneySprite.x = _local1;
                this.moneySprite.y = _local2;
                _local1 = (this.moneySprite.x + 120);
            };
            if (((info) && ((info.rewardExp > 0)))){
                this.exp.x = _local1;
                this.exp.y = _local2;
                _local1 = (this.exp.x + 120);
            };
            if (((info) && ((info.rewardPrestige > 0)))){
                this.prestigeTT.x = _local1;
                this.prestigeTT.y = _local2;
                _local1 = (this.prestigeTT.x + 120);
            };
            if (goodsPanel){
                this.goodsPanel.x = _local1;
                this.goodsPanel.y = _local2;
                _local1 = (this.goodsPanel.x + 120);
            };
        }
        private function addEvents():void{
        }
        private function textFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.size = 12;
            _local1.font = LanguageMgr.DEFAULT_FONT;
            return (_local1);
        }
        public function get info():TaskInfoStruct{
            return (_info);
        }
        private function initView():void{
            this.taskObtain = new TaskText(290);
            addChild(this.taskObtain);
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
            addChild(this.moneySprite);
            this.exp = new TaskText(290);
            addChild(this.exp);
            prestigeTT = new TaskText(290);
            addChild(this.prestigeTT);
        }
        private function updateInfo():void{
            if (info == null){
                return;
            };
            this.taskObtain.tfText = (("<font color=\"#FBB612\">" + LanguageMgr.GetTranslation("任务奖励")) + "</font>");
            this.money.htmlText = ((info.rewardGold > 0)) ? (((("<font color=\"#D6C29C\">&nbsp;&nbsp;" + LanguageMgr.GetTranslation("金币")) + ":") + UIUtils.getMoneyStandInfo(info.rewardGold, ["\\ce", "\\cs", "\\cc"])) + "</font>") : "";
            ShowMoney.ShowIcon(this.moneySprite, this.money, true);
            moneySprite.visible = true;
            this.exp.tfText = ((info.rewardExp > 0)) ? (((("<font color=\"#D6C29C\">&nbsp;&nbsp;" + LanguageMgr.GetTranslation("经验")) + ":") + String(info.rewardExp)) + "</font>") : "";
            this.prestigeTT.tfText = ((info.rewardPrestige > 0)) ? (((("<font color=\"#D6C29C\">&nbsp;&nbsp;" + LanguageMgr.GetTranslation("声望")) + ":") + String(info.rewardPrestige)) + "</font>") : "";
            if (info.ItemRewards.concat(info.ItemRewardsOptionals).length > 0){
                this.goodsPanel = new EquPanel(info.ItemRewards.concat(info.ItemRewardsOptionals), false);
                this.addChild(this.goodsPanel);
            };
            doLayout();
        }
        public function get expUI():TaskText{
            return (this.exp);
        }
        public function set info(_arg1:TaskInfoStruct):void{
            this._info = _arg1;
            updateInfo();
        }

    }
}//package GameUI.Modules.NPCChat.View 
