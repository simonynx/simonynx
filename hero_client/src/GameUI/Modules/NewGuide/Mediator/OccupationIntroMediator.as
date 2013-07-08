//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import GameUI.Modules.NewGuide.UI.*;
    import GameUI.Modules.Task.Model.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.NewGuide.Command.*;
    import GameUI.Modules.NewGuide.Data.*;

    public class OccupationIntroMediator extends Mediator {

        public static const NAME:String = "OccupationSelectMediator";

        private const DELAY:int = 100;

        private var xmlVersion:Number;
        private var timer:Timer;
        private var _addNum:int = 1;
        private var isInRandom:Boolean;
        private var isHasIntroTxt:Boolean;
        private var introTxtList:Dictionary;
        private var curNum:uint;
        private var curJobID:int = 0;

        public function OccupationIntroMediator(){
            super(NAME);
        }
        private function cancel():void{
        }
        private function togJob(_arg1:int):void{
            (viewUI.OccuList[_arg1] as MovieClip).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }
        private function removeListener():void{
            var _local1:String;
            var _local2:MovieClip;
            for (_local1 in viewUI.OccuList) {
                _local2 = viewUI.OccuList[_local1];
                _local2.removeEventListener(MouseEvent.CLICK, onMouseClick);
                _local2.removeEventListener(MouseEvent.MOUSE_OVER, viewUI.mouseOver);
                _local2.removeEventListener(MouseEvent.MOUSE_OUT, viewUI.mouseOut);
            };
            viewUI.randomBtn.removeEventListener(MouseEvent.CLICK, onRandomClick);
            viewUI.getJobBtn.removeEventListener(MouseEvent.CLICK, onGetJobBtnClick);
        }
        private function onClose():void{
            removeListener();
            GameCommonData.GameInstance.GameUI.removeChild(viewUI);
            JianTouMc.getInstance().setVisible(true);
            sendNotification(Guide_OccupationIntro_Command.NAME, {type:2});
        }
        private function sure():void{
            var _local1:String;
            onClose();
            for (_local1 in GameCommonData.SameSecnePlayerList) {
                if (GameCommonData.SameSecnePlayerList[_local1].Role.MonsterTypeID == TaskCommonData.LoopTaskCommitNpcArrTemp[curJobID]){
                    break;
                };
            };
            sendNotification(Guide_OccupationIntro_Command.NAME, {
                type:5,
                obj:{
                    npcId:uint(_local1),
                    linkId:0
                }
            });
        }
        private function get AddNum():int{
            if (curJobID == 5){
                _addNum = -1;
            };
            if (curJobID == 1){
                _addNum = 1;
            };
            return (_addNum);
        }
        override public function listNotificationInterests():Array{
            return ([NewGuideEvent.NEWOCCUPATIONINTRO_SHOW, NewGuideEvent.NEWOCCUPATIONINTRO_CLOSE, NewGuideEvent.NEWOCCUPATIONINTRO_REFRESH]);
        }
        private function onMouseClick(_arg1:MouseEvent):void{
            viewUI.mouseClick((_arg1.currentTarget as MovieClip));
            curJobID = String(_arg1.currentTarget.name).split("_")[1];
            if (isHasIntroTxt){
                viewUI.introTxt = introTxtList[curJobID.toString()];
            };
            viewUI.getJobBtnLabel = curJobID;
        }
        private function onRandomClick(_arg1:MouseEvent):void{
            if (isInRandom){
                return;
            };
            isInRandom = true;
            _addNum = 1;
            viewUI.reset();
            timer.repeatCount = ((3 * 5) + (Math.random() * 10));
            timer.reset();
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            timer.start();
        }
        private function parseXMLData():void{
            var _local1:XML;
            introTxtList = new Dictionary();
            for each (_local1 in GameCommonData.OccupationIntroXMLS.elements()) {
                introTxtList[_local1.@id.toString()] = _local1.toString();
            };
            isHasIntroTxt = true;
            viewUI.introTxt = introTxtList[curJobID.toString()];
        }
        private function onGetJobBtnClick(_arg1:MouseEvent=null):void{
            clearTimeout(curNum);
            var _local2:String = ((((LanguageMgr.GetTranslation("确定加入") + "<font color='#00ff00'>") + LanguageMgr.JobNameList[curJobID]) + "</font>") + LanguageMgr.GetTranslation("形象将对应改变"));
            sendNotification(Guide_OccupationIntro_Command.NAME, {
                type:4,
                obj:{
                    comfrim:sure,
                    info:_local2
                }
            });
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case NewGuideEvent.NEWOCCUPATIONINTRO_SHOW:
                    onShow();
                    curJobID = int(_arg1.getBody()["occupationId"]);
                    togJob(curJobID);
                    break;
                case NewGuideEvent.NEWOCCUPATIONINTRO_CLOSE:
                    onClose();
                    break;
                case NewGuideEvent.NEWOCCUPATIONINTRO_REFRESH:
                    curJobID = int(_arg1.getBody()["occupationId"]);
                    togJob(curJobID);
                    break;
            };
        }
        private function addListener():void{
            var _local1:String;
            var _local2:MovieClip;
            for (_local1 in viewUI.OccuList) {
                _local2 = viewUI.OccuList[_local1];
                _local2.addEventListener(MouseEvent.CLICK, onMouseClick);
                _local2.addEventListener(MouseEvent.MOUSE_OVER, viewUI.mouseOver);
                _local2.addEventListener(MouseEvent.MOUSE_OUT, viewUI.mouseOut);
            };
            viewUI.randomBtn.addEventListener(MouseEvent.CLICK, onRandomClick);
            viewUI.getJobBtn.addEventListener(MouseEvent.CLICK, onGetJobBtnClick);
        }
        private function initView():void{
            var _local1:OccupationIntroView = new OccupationIntroView();
            _local1.closeCallBack = onClose;
            setViewComponent(_local1);
        }
        public function get viewUI():OccupationIntroView{
            return ((getViewComponent() as OccupationIntroView));
        }
        private function onShow():void{
            if (!viewUI){
                initView();
                parseXMLData();
                timer = new Timer(DELAY);
            };
            viewUI.x = ((GameCommonData.GameInstance.ScreenWidth - viewUI.width) / 2);
            viewUI.y = ((GameCommonData.GameInstance.ScreenHeight - viewUI.height) / 2);
            GameCommonData.GameInstance.GameUI.addChild(viewUI);
            JianTouMc.getInstance().setVisible(false);
            addListener();
        }
        private function onTimer(_arg1:TimerEvent):void{
            viewUI.setLight(viewUI.OccuList[curJobID], false);
            curJobID = (curJobID + AddNum);
            viewUI.setLight(viewUI.OccuList[curJobID]);
        }
        private function onTimerComplete(_arg1:TimerEvent):void{
            timer.removeEventListener(TimerEvent.TIMER, onTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            isInRandom = false;
            togJob(curJobID);
            curNum = setTimeout(onGetJobBtnClick, 100);
        }

    }
}//package GameUI.Modules.NewGuide.Mediator 
