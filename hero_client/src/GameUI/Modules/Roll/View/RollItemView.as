//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Roll.View {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Modules.Roll.Data.*;
    import Net.RequestSend.*;

    public class RollItemView extends Sprite {

        private static const TIME_COUNT:int = 10;

        private var view:MovieClip;
        private var timer:Timer;
        private var info:RollInfo;
        private var fItem:FaceItem;

        public function RollItemView(){
            init();
            initEvent();
        }
        public function getRollInfo():RollInfo{
            return (this.info);
        }
        public function setItemInfo(_arg1:RollInfo):void{
            var _local3:uint;
            this.info = _arg1;
            var _local2:ItemTemplateInfo = UIConstData.ItemDic[info.itemId];
            if (_local2 == null){
                return;
            };
            switch (_local2.Color){
                case 1:
                    view["rollBg"].gotoAndStop(1);
                    _local3 = 0xFF00;
                    break;
                case 2:
                    view["rollBg"].gotoAndStop(2);
                    _local3 = 26367;
                    break;
                case 3:
                    view["rollBg"].gotoAndStop(3);
                    _local3 = 0x9800FF;
                    break;
                case 4:
                    view["rollBg"].gotoAndStop(4);
                    _local3 = 0xFF9900;
                    break;
                default:
                    _local3 = 0xFFFFFF;
            };
            view["itemName"].text = info.itemName;
            view["itemName"].textColor = _local3;
            var _local4:Sprite = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
            fItem = new FaceItem(_local2.img.toString(), _local4);
            fItem.mouseChildren = false;
            fItem.mouseEnabled = false;
            _local4.addChild(fItem);
            _local4.name = ("target_" + info.itemId);
            this.addChild(_local4);
            _local4.x = 6;
            _local4.y = 3;
            timer.start();
        }
        private function onTimerHandler(_arg1:TimerEvent):void{
            view["timeMc"].gotoAndStop((10 - (_arg1.currentTarget as Timer).currentCount));
        }
        private function onTimerCompleteHandler(_arg1:TimerEvent):void{
            timer.stop();
            view["timeMc"].visible = false;
            removeEvent();
        }
        private function init():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("RollItemViewAsset");
            view["rollBg"].stop();
            view["timeMc"].gotoAndStop(10);
            view["timeMc"].mouseEnabled = false;
            view["timeMc"].mouseChildren = false;
            this.addChild(view);
            timer = new Timer(1000, TIME_COUNT);
        }
        private function initEvent():void{
            view["rollBtn"].addEventListener(MouseEvent.CLICK, onRollHandler);
            view["cancelBtn"].addEventListener(MouseEvent.CLICK, onCancelHandler);
            timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
        }
        private function onRollHandler(_arg1:MouseEvent):void{
            view["rollBtn"].enabled = false;
            view["cancelBtn"].enabled = false;
            onTimerCompleteHandler(null);
            removeEvent();
            PlayerActionSend.sendRoll((info.index % 100), 0, uint((info.index / 100)));
        }
        private function removeEvent():void{
            view["rollBtn"].removeEventListener(MouseEvent.CLICK, onRollHandler);
            view["cancelBtn"].removeEventListener(MouseEvent.CLICK, onCancelHandler);
            timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
        }
        private function onCancelHandler(_arg1:MouseEvent):void{
            view["rollBtn"].enabled = false;
            view["cancelBtn"].enabled = false;
            onTimerCompleteHandler(null);
            removeEvent();
            PlayerActionSend.sendRoll((info.index % 100), 1, uint((info.index / 100)));
        }
        public function dispose():void{
            removeEvent();
            view = null;
            if (this.parent){
                this.parent.removeChild(this);
            };
        }

    }
}//package GameUI.Modules.Roll.View 
