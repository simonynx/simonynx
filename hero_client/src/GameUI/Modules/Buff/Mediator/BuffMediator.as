//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Buff.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsEngine.Skill.*;
    import OopsFramework.*;
    import GameUI.ConstData.*;
    import OopsFramework.Utils.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Buff.Data.*;
    import GameUI.Modules.Buff.view.*;

    public class BuffMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "BuffMediator";

        private var lastTime:int;
        private var time:Timer;
        private var buffList:BuffListView;
        private var debuffList:BuffListView;

        public function BuffMediator(){
            super(NAME);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    time = new Timer();
                    time.DistanceTime = 1000;
                    buffList = new BuffListView(0);
                    buffList.mouseEnabled = false;
                    debuffList = new BuffListView(1);
                    debuffList.mouseEnabled = false;
                    GameCommonData.GameInstance.GameUI.addChild(buffList);
                    GameCommonData.GameInstance.GameUI.addChild(debuffList);
                    setPos();
                    break;
                case BuffEvent.ADDBUFF:
                    buffList.addItem((_arg1.getBody() as GameSkillBuff));
                    GameCommonData.GameInstance.GameUI.Elements.Add(this);
                    break;
                case BuffEvent.DELETEBUFF:
                    buffList.deleteItem((_arg1.getBody() as GameSkillBuff));
                    break;
                case BuffEvent.UPDATE_BUFF_TIME:
                    buffList.updateItem((_arg1.getBody() as GameSkillBuff));
                    break;
                case BuffEvent.UPDATE_DEBUFF_TIME:
                    debuffList.updateItem((_arg1.getBody() as GameSkillBuff));
                    break;
                case BuffEvent.ADDDEBUFF:
                    debuffList.addItem((_arg1.getBody() as GameSkillBuff));
                    GameCommonData.GameInstance.GameUI.Elements.Add(this);
                    break;
                case BuffEvent.DELETEDEBUFF:
                    debuffList.deleteItem((_arg1.getBody() as GameSkillBuff));
                    break;
                case BuffEvent.CLEAR_ALL_BUFF:
                    buffList.clearAllItem();
                    debuffList.clearAllItem();
                    GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                    break;
                case EventList.RESIZE_STAGE:
                    setPos();
                    break;
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        private function setPos():void{
            buffList.x = (GameCommonData.GameInstance.ScreenWidth - 210);
            buffList.y = 25;
            debuffList.x = (GameCommonData.GameInstance.ScreenWidth - 210);
            debuffList.y = 80;
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.SHOWBUFF, EventList.SHOWDEBUFF, BuffEvent.ADDBUFF, BuffEvent.DELETEBUFF, BuffEvent.ADDDEBUFF, BuffEvent.DELETEDEBUFF, BuffEvent.UPDATE_BUFF_TIME, EventList.RESIZE_STAGE, BuffEvent.CLEAR_ALL_BUFF]);
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function get UpdateOrder():int{
            return (0);
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function Update(_arg1:GameTime):void{
            if (time.IsNextTime(_arg1)){
                buffList.update();
                debuffList.update();
                if ((((buffList.getList().length == 0)) && ((debuffList.getList().length == 0)))){
                    GameCommonData.GameInstance.GameUI.Elements.Remove(this);
                };
            };
        }
        public function get EnabledChanged():Function{
            return (null);
        }

    }
}//package GameUI.Modules.Buff.Mediator 
