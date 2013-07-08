//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Task.Mediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.utils.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.Modules.Task.View.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;
    import Net.RequestSend.*;
    import OopsEngine.Graphics.*;
    import GameUI.View.OhterUI.*;

    public class DailyBookTaskWindow extends HFrame {

        private static const NeedMoney:int = 200;
        private static const NeedGift:int = 2;
        private static const FreeCnt:int = 10;

        private var refreshBtn:HLabelButton;
        private var autoUseMoneyHC:HCheckBox;
        private var desTF:TextField;
        private var bg:Sprite;
        private var untilColorCB:MyCombox;
        private var bgBack:Sprite;
        private var freeCntTF:TextField;
        private var taskColorTF:TextField;
        private var otherRewardTF:TextField;
        private var rewardPanel:EquPanel;
        private var todayCntTF:TextField;
        private var accBtn:HLabelButton;
        private var taskColorTF1:TextField;
        private var rewardExpTF:TextField;
        private var lineMc:Bitmap;
        private var dbTaskReward:DailyBookTaskRewardListPanel;
        private var taskCon:TaskText;
        private var refreshUntilHC:HCheckBox;

        public function DailyBookTaskWindow(){
            initView();
            addEvents();
        }
        private function setCommboxData():void{
            var _local4:Array;
            var _local5:XML;
            var _local1:XML = new XML("<list></list>");
            var _local2:int;
            var _local3:int = TaskCommonData.dailyBOokQualityColor.length;
            while (_local2 < _local3) {
                if ((((_local2 > TaskCommonData.CurrentDialyBookQuality)) || ((_local2 == (TaskCommonData.dailyBOokQualityColor.length - 1))))){
                    _local4 = TaskCommonData.dailyBOokQualityColor[_local2];
                    _local5 = new XML((((((("<node label=\"" + _local4[0]) + "\" data=\"") + _local2) + "\" color=\"") + _local4[1]) + "\"/>"));
                    _local1.appendChild(_local5);
                };
                _local2++;
            };
            untilColorCB.listXml = _local1;
            untilColorCB.setSelectItemByIndex((untilColorCB.length - 1));
        }
        private function __btnClickHandler(_arg1:MouseEvent):void{
            var evt:* = _arg1;
            switch (evt.currentTarget){
                case refreshBtn:
                    if (TaskCommonData.CurrentDialyBookQuality == (TaskCommonData.dailyBOokQualityColor.length - 1)){
                        UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                            comfrim:new Function(),
                            info:LanguageMgr.GetTranslation("刷出最高品质提示")
                        });
                        return;
                    };
                    if (TaskCommonData.DBFreeRefreshRemainCnt >= FreeCnt){
                        if ((((GameCommonData.Player.Role.Gift < NeedGift)) && ((GameCommonData.Player.Role.Money < NeedMoney)))){
                            UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                comfrim:new Function(),
                                info:LanguageMgr.GetTranslation("金叶子和礼券不足")
                            });
                            return;
                        };
                        if (autoUseMoneyHC.selected){
                            confrimRefresh();
                        } else {
                            if (refreshUntilHC.selected){
                                if (GameCommonData.Player.Role.Gift >= NeedGift){
                                    DbAlert.show(LanguageMgr.GetTranslation("日常任务书提示1"), confrimRefresh, 2);
                                    return;
                                };
                                DbAlert.show(LanguageMgr.GetTranslation("日常任务书提示2"), function ():void{
                                    if (GameCommonData.Player.Role.Money < NeedMoney){
                                        UIFacade.GetInstance().sendNotification(EventList.SHOWALERT, {
                                            comfrim:new Function(),
                                            info:"金叶子不足"
                                        });
                                        return;
                                    };
                                    TaskSend.DailyBookRefreshQuality(0, true);
                                }, 1);
                                return;
                            };
                            if (GameCommonData.Player.Role.Gift >= NeedGift){
                                DbAlert.show(LanguageMgr.GetTranslation("日常任务书提示3"), confrimRefresh, 0);
                                return;
                            };
                            if (GameCommonData.Player.Role.Money >= NeedMoney){
                                DbAlert.show(LanguageMgr.GetTranslation("日常任务书提示2"), function ():void{
                                    TaskSend.DailyBookRefreshQuality(0, true);
                                }, 1);
                                return;
                            };
                        };
                        return;
                    };
                    confrimRefresh();
                    break;
                case accBtn:
                    if (taskInfo.IsAccept){
                        TaskSend.CompleteTask(0, taskInfo.taskId);
                    } else {
                        TaskSend.AcceptQuest(0, taskInfo.taskId);
                    };
                    break;
            };
        }
        public function updateData(_arg1:Boolean=false, _arg2:Object=null):void{
            var c:* = null;
            var preQ:* = 0;
            var cnt:* = 0;
            var isResult:Boolean = _arg1;
            var obj = _arg2;
            if (taskInfo == null){
                doLayout();
                return;
            };
            c = TaskCommonData.dailyBOokQualityColor[TaskCommonData.CurrentDialyBookQuality];
            if (c == null){
                return;
            };
            if (isResult){
                if (taskColorTF.textColor != c[1]){
                    preQ = obj[1];
                    cnt = 2;
                    setTimeout(function ():void{
                        taskColorTF.textColor = 0xFFFFFF;
                        taskColorTF1.textColor = 0xFFFFFF;
                        setTimeout(function ():void{
                            taskColorTF.textColor = c[1];
                            taskColorTF1.textColor = c[1];
                            setTimeout(function ():void{
                                taskColorTF.textColor = 0xFFFFFF;
                                taskColorTF1.textColor = 0xFFFFFF;
                                setTimeout(function ():void{
                                    taskColorTF.textColor = c[1];
                                    taskColorTF1.textColor = c[1];
                                }, 100);
                            }, 100);
                        }, 100);
                    }, 100);
                };
            } else {
                taskColorTF.textColor = c[1];
                taskColorTF1.textColor = c[1];
            };
            taskColorTF.text = (LanguageMgr.GetTranslation("任务等级") + "：");
            taskColorTF1.text = c[0];
            taskCon.tfText = (("<font color='#D6C29C'>" + (taskInfo.IsComplete) ? taskInfo.taskProcessFinish : taskInfo.getConditionDes().substring(2)) + "</font>");
            todayCntTF.htmlText = (((("<font color='#ffff99'>" + LanguageMgr.GetTranslation("本日次数")) + "：</font>") + TaskCommonData.DBTodayCompleteCnt) + "/10");
            freeCntTF.htmlText = (((("<font color='#ffff99'>" + LanguageMgr.GetTranslation("免费次数")) + "：</font>") + (FreeCnt - TaskCommonData.DBFreeRefreshRemainCnt)) + LanguageMgr.GetTranslation("次"));
            rewardExpTF.htmlText = ((("<font color='#ffff99'>" + LanguageMgr.GetTranslation("任务奖励")) + "：</font>") + taskInfo.rewardExp);
            if (!taskInfo.IsAccept){
                accBtn.enable = true;
                accBtn.label = LanguageMgr.GetTranslation("接受任务");
                refreshBtn.enable = true;
            } else {
                accBtn.enable = taskInfo.IsComplete;
                accBtn.label = LanguageMgr.GetTranslation("完成任务");
                refreshBtn.enable = false;
            };
            if (((rewardPanel) && (rewardPanel.parent))){
                rewardPanel.parent.removeChild(rewardPanel);
            };
            rewardPanel = null;
            if (taskInfo.ItemRewards.length > 0){
                rewardPanel = new EquPanel(taskInfo.ItemRewards, false);
                bg.addChild(rewardPanel);
            };
            setCommboxData();
            doLayout();
        }
        public function resetHC():void{
            refreshUntilHC.selected = false;
            autoUseMoneyHC.selected = false;
        }
        private function initView():void{
            titleText = LanguageMgr.GetTranslation("日常任务书");
            centerTitle = true;
            blackGound = false;
            setSize(325, 405);
            lineMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("PartinglineAsset");
            bgBack = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassBySprite("BlueBack2");
            bgBack.width = 317;
            bgBack.height = 370;
            desTF = UIUtils.createTextField(300, 130);
            desTF.multiline = true;
            desTF.wordWrap = true;
            desTF.filters = OopsEngine.Graphics.Font.Stroke();
            var _local1:TextFormat = desTF.defaultTextFormat;
            _local1.leading = 8;
            desTF.defaultTextFormat = _local1;
            taskColorTF = UIUtils.createTextField(170);
            taskColorTF.filters = OopsEngine.Graphics.Font.Stroke();
            taskColorTF1 = UIUtils.createTextField(110, 25);
            taskColorTF1.filters = OopsEngine.Graphics.Font.Stroke();
            _local1 = taskColorTF1.defaultTextFormat;
            _local1.size = 20;
            taskColorTF1.defaultTextFormat = _local1;
            taskCon = new TaskText(280);
            otherRewardTF = UIUtils.createTextField(115);
            otherRewardTF.textColor = 0xFFFF;
            otherRewardTF.filters = OopsEngine.Graphics.Font.Stroke();
            todayCntTF = UIUtils.createTextField(110);
            todayCntTF.filters = OopsEngine.Graphics.Font.Stroke();
            freeCntTF = UIUtils.createTextField(110);
            freeCntTF.filters = OopsEngine.Graphics.Font.Stroke();
            rewardExpTF = UIUtils.createTextField(110);
            rewardExpTF.filters = OopsEngine.Graphics.Font.Stroke();
            refreshUntilHC = new HCheckBox(LanguageMgr.GetTranslation("刷出质量为止"));
            refreshUntilHC.fireAuto = true;
            autoUseMoneyHC = new HCheckBox(LanguageMgr.GetTranslation("礼券不足自动使用金叶子"));
            autoUseMoneyHC.fireAuto = true;
            untilColorCB = new MyCombox(50, 100, 36);
            refreshBtn = new HLabelButton();
            refreshBtn.label = LanguageMgr.GetTranslation("刷新品质");
            accBtn = new HLabelButton();
            accBtn.label = LanguageMgr.GetTranslation("接受任务");
            bg = new Sprite();
            bg.addChild(bgBack);
            bg.addChild(lineMc);
            bg.addChild(desTF);
            bg.addChild(taskColorTF);
            bg.addChild(taskColorTF1);
            bg.addChild(taskCon);
            bg.addChild(otherRewardTF);
            bg.addChild(todayCntTF);
            bg.addChild(freeCntTF);
            bg.addChild(rewardExpTF);
            bg.addChild(refreshUntilHC);
            bg.addChild(autoUseMoneyHC);
            bg.addChild(untilColorCB);
            bg.addChild(refreshBtn);
            bg.addChild(accBtn);
            doLayout();
            desTF.htmlText = LanguageMgr.GetTranslation("日常任务书描述");
            otherRewardTF.htmlText = LanguageMgr.GetTranslation("查看其他星级奖励");
            setCommboxData();
            addContent(bg);
        }
        override public function show():void{
            updateData();
            super.show();
        }
        private function __showOtherRewardPanel(_arg1:TextEvent):void{
            if (dbTaskReward == null){
                dbTaskReward = new DailyBookTaskRewardListPanel();
            };
            dbTaskReward.X = (this.X + this.frameWidth);
            dbTaskReward.Y = (this.Y + 30);
            dbTaskReward.show();
        }
        private function addEvents():void{
            otherRewardTF.addEventListener(TextEvent.LINK, __showOtherRewardPanel);
            refreshBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
            accBtn.addEventListener(MouseEvent.CLICK, __btnClickHandler);
        }
        private function confrimRefresh():void{
            var _local1:int = (refreshUntilHC.selected) ? untilColorCB.selectItem.data : 0;
            TaskSend.DailyBookRefreshQuality(_local1, autoUseMoneyHC.selected);
        }
        private function doLayout():void{
            bgBack.x = 4;
            bgBack.y = 30;
            desTF.x = 17;
            desTF.y = 43;
            lineMc.x = 17;
            lineMc.y = 163;
            taskColorTF.x = 17;
            taskColorTF.y = 185;
            var _local1:Boolean = (((TaskCommonData.DBTodayCompleteCnt <= 10)) && (!((taskInfo == null))));
            if (_local1 == false){
                taskColorTF.htmlText = LanguageMgr.GetTranslation("日常任务已达上限提示");
            };
            taskColorTF1.x = 80;
            taskColorTF1.y = 178;
            taskColorTF1.visible = _local1;
            otherRewardTF.x = 195;
            otherRewardTF.y = 185;
            otherRewardTF.visible = _local1;
            taskCon.x = 17;
            taskCon.y = 206;
            taskCon.visible = _local1;
            todayCntTF.x = 17;
            todayCntTF.y = 230;
            todayCntTF.visible = _local1;
            freeCntTF.x = 195;
            freeCntTF.y = 230;
            freeCntTF.visible = _local1;
            rewardExpTF.x = 17;
            rewardExpTF.y = 253;
            rewardExpTF.visible = _local1;
            if (rewardPanel){
                rewardPanel.x = 20;
                rewardPanel.y = 280;
                rewardPanel.visible = _local1;
            };
            refreshUntilHC.x = 23;
            refreshUntilHC.y = 329;
            refreshUntilHC.visible = _local1;
            autoUseMoneyHC.x = 23;
            autoUseMoneyHC.y = 356;
            autoUseMoneyHC.visible = _local1;
            untilColorCB.x = 82;
            untilColorCB.y = 333;
            untilColorCB.visible = _local1;
            refreshBtn.x = 230;
            refreshBtn.y = 325;
            refreshBtn.visible = _local1;
            accBtn.x = 230;
            accBtn.y = 357;
            accBtn.visible = _local1;
        }
        private function get taskInfo():TaskInfoStruct{
            return (GameCommonData.TaskInfoDic[TaskCommonData.CurrentDialyBookTaskId]);
        }
        override public function close():void{
            super.close();
            if (dbTaskReward){
                dbTaskReward.close();
            };
        }

    }
}//package GameUI.Modules.Task.Mediator 

import flash.events.*;
import Manager.*;
import flash.text.*;
import GameUI.View.HButton.*;
import GameUI.View.BaseUI.*;
import Utils.*;

class DbAlert extends HFrame {

    private var okBtn:HLabelButton;
    private var cancelBtn:HLabelButton;
    private var neverAlertHC:HCheckBox;
    private var tf:TextField;
    public var confirm:Function;
    public var type:int;

    public function DbAlert(){
        initView();
        addEvents();
    }
    public static function show(_arg1:String, _arg2:Function, _arg3:int=-1):DbAlert{
        var _local4:int;
        switch (_arg3){
            case 0:
                _local4 = SharedManager.getInstance().DbneverTipsDay_Gift;
                break;
            case 1:
                _local4 = SharedManager.getInstance().DbneverTipsDay_Money;
                break;
            case 2:
                _local4 = SharedManager.getInstance().DbneverTipsDay_AutoGift;
                break;
        };
        if (_local4 == TimeManager.Instance.Now().date){
            _arg2();
            return (null);
        };
        var _local5:DbAlert = new (DbAlert)();
        _local5.confirm = _arg2;
        _local5.tips = _arg1;
        _local5.type = _arg3;
        _local5.show();
        _local5.centerFrame();
        return (_local5);
    }

    private function addEvents():void{
        okBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
        cancelBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
        neverAlertHC.addEventListener(MouseEvent.CLICK, __clickHandler);
    }
    private function __clickHandler(_arg1:MouseEvent):void{
        switch (_arg1.currentTarget){
            case okBtn:
                if (confirm){
                    confirm();
                };
                close();
                if (neverAlertHC.selected){
                    switch (type){
                        case 0:
                            SharedManager.getInstance().DbneverTipsDay_Gift = TimeManager.Instance.Now().date;
                            break;
                        case 1:
                            SharedManager.getInstance().DbneverTipsDay_Money = TimeManager.Instance.Now().date;
                            break;
                        case 2:
                            SharedManager.getInstance().DbneverTipsDay_AutoGift = TimeManager.Instance.Now().date;
                            break;
                    };
                };
                break;
            case cancelBtn:
                close();
                break;
            case neverAlertHC:
                neverAlertHC.selected = !(neverAlertHC.selected);
                break;
        };
    }
    public function set tips(_arg1:String):void{
        tf.htmlText = _arg1;
    }
    private function initView():void{
        titleText = LanguageMgr.GetTranslation("提示");
        centerTitle = true;
        setSize(250, 130);
        tf = new TextField();
        var _local1:TextFormat = UIUtils.textformat;
        _local1.color = 0xFFFFFF;
        tf.defaultTextFormat = _local1;
        addContent(tf);
        tf.width = 200;
        tf.height = 36;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.x = 25;
        tf.y = 40;
        neverAlertHC = new HCheckBox(LanguageMgr.GetTranslation("今天不再提示"));
        addContent(neverAlertHC);
        neverAlertHC.x = 70;
        neverAlertHC.y = 70;
        okBtn = new HLabelButton();
        okBtn.label = LanguageMgr.GetTranslation("确定");
        addContent(okBtn);
        okBtn.x = (((this.frameWidth / 2) - okBtn.width) - 10);
        okBtn.y = 100;
        cancelBtn = new HLabelButton();
        cancelBtn.label = LanguageMgr.GetTranslation("cancel");
        addContent(cancelBtn);
        cancelBtn.x = ((this.frameWidth / 2) + 10);
        cancelBtn.y = 100;
    }

}
