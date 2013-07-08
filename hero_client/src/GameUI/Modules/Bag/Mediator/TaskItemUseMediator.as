//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import OopsFramework.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import GameUI.View.*;
    import GameUI.Modules.Task.Model.*;
    import GameUI.View.BaseUI.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import Utils.*;
    import GameUI.Modules.Bag.Datas.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Hint.Events.*;
    import GameUI.*;

    public class TaskItemUseMediator extends Mediator implements IUpdateable {

        public static const NAME:String = "TaskItemUseMediator";

        private var localMS:Number = 0;
        private var itemInfo:InventoryItemInfo;
        private var itemGUID:uint;
        private var dataProxy:DataProxy;
        private var timeCounter:Number = 5000;

        public function TaskItemUseMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:"CollectProgressAsset"
                    });
                    view.mouseEnabled = false;
                    view.mouseChildren = false;
                    view.progressMc.mask = view.progressMask;
                    view.TargetNameTF.text = LanguageMgr.GetTranslation("正在使用");
                    view.load_txt.text = "";
                    proess(0);
                    break;
                case BagEvents.SHOW_TASKITEM_USE_UI:
                    itemGUID = uint(_arg1.getBody());
                    itemInfo = BagData.getItemById(itemGUID);
                    if (itemInfo == null){
                        return;
                    };
                    timeCounter = (itemInfo.CriticalDamage * 1000);
                    view.x = int(((GameCommonData.GameInstance.ScreenWidth - view.width) / 2));
                    view.y = int(((GameCommonData.GameInstance.ScreenHeight - view.height) / 2));
                    GameCommonData.GameInstance.GameUI.addChild(view);
                    GameCommonData.GameInstance.GameUI.Elements.Add(this);
                    dataProxy.IsUseTaskItem = true;
                    break;
                case BagEvents.CANCEL_TASKITEM_USE:
                    if (dataProxy.IsUseTaskItem){
                        cancelUse();
                    };
                    break;
            };
        }
        public function get UpdateOrderChanged():Function{
            return (null);
        }
        public function get EnabledChanged():Function{
            return (null);
        }
        private function completeUseHandler():void{
            cancelUse();
            var _local1:uint = itemInfo.Attack;
            var _local2:TaskInfoStruct = GameCommonData.TaskInfoDic[_local1];
            if (_local2){
                if (itemInfo.Defence != 0){
                    if (((!((GameCommonData.GameInstance.GameScene.GetGameScene.name == String(itemInfo.Defence)))) || (!(DistanceController.Distance(new Point(GameCommonData.Player.Role.TileX, GameCommonData.Player.Role.TileY), new Point(itemInfo.NormalHit, itemInfo.NormalDodge), 5))))){
                        MessageTip.popup("位置不对");
                        return;
                    };
                };
                showEffect(itemInfo);
                BagInfoSend.ItemUse(itemGUID);
            };
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, BagEvents.INIT_TASKITEM_USE_UI, BagEvents.SHOW_TASKITEM_USE_UI, BagEvents.CANCEL_TASKITEM_USE]);
        }
        public function get view():MovieClip{
            return ((getViewComponent() as MovieClip));
        }
        public function set EnabledChanged(_arg1:Function):void{
        }
        public function get Enabled():Boolean{
            return (true);
        }
        public function Update(_arg1:GameTime):void{
            localMS = (localMS + _arg1.ElapsedGameTime);
            proess(((localMS * 1) / timeCounter));
            if (localMS > timeCounter){
                completeUseHandler();
            };
        }
        public function get UpdateOrder():int{
            return (0);
        }
        private function cancelUse():void{
            if (GameCommonData.GameInstance.GameUI.contains(this.view)){
                localMS = 0;
                proess(0);
                GameCommonData.GameInstance.GameUI.removeChild(this.view);
            };
            dataProxy.IsUseTaskItem = false;
            GameCommonData.GameInstance.GameUI.Elements.Remove(this);
        }
        private function showEffect(_arg1:ItemTemplateInfo):void{
            if (ItemConst.IsFireworks(_arg1)){
                SpeciallyEffectController.getInstance().showSceneMovieEffect(SpeciallyEffectController.EFFECT_FIREWORKS, _arg1.Defence, _arg1.NormalHit, _arg1.NormalDodge);
            };
            if (BagData.getItemById(itemGUID).TemplateID == 60200002){
                SpeciallyEffectController.getInstance().showPotDropWaterMc(GameCommonData.Player.gameScene, 97, 204);
            };
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
        }
        private function proess(_arg1:Number):void{
            _arg1 = ((_arg1 > 1)) ? 1 : _arg1;
            view.load_txt.text = (int((100 * _arg1)) + "%");
            view.progressMask.width = (_arg1 * view.progressMc.width);
            view.lightAsset.x = (view.progressMask.x + view.progressMask.width);
        }

    }
}//package GameUI.Modules.Bag.Mediator 
