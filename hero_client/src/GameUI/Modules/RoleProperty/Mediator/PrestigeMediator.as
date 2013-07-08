//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Mediator {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.RoleProperty.Datas.*;

    public class PrestigeMediator extends Mediator {

        public static const TYPE:int = 1;
        public static const NAME:String = "PrestigeMediator";

        private var parentView:Sprite;

        public function PrestigeMediator(_arg1:Sprite){
            this.parentView = _arg1;
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([RoleEvents.INITROLEVIEW, RoleEvents.SHOWPROPELEMENT, RoleEvents.UPDATE_ROLEOFFER]);
        }
        private function get view():MovieClip{
            return ((getViewComponent() as MovieClip));
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case RoleEvents.INITROLEVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.PRESTIGEPANEL
                    });
                    this.view.mouseEnabled = false;
                    initView();
                    break;
                case RoleEvents.SHOWPROPELEMENT:
                    if ((_arg1.getBody() as int) != TYPE){
                        facade.sendNotification(RoleEvents.HIDE_ATTRIBUTE);
                        if (parentView.contains(view)){
                            parentView.removeChild(view);
                        };
                        return;
                    };
                    parentView.addChildAt(view, 4);
                    updateData();
                    break;
                case RoleEvents.UPDATE_ROLEOFFER:
                    updateData();
                    break;
            };
        }
        private function updateData():void{
            view.tf_0.text = RolePropDatas.OfferTile[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[0])];
            view.tf_1.text = RolePropDatas.OfferTile[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[1])];
            view.tf_2.text = RolePropDatas.OfferTile[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[2])];
            view.tf_3.text = RolePropDatas.OfferTile[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[3])];
            view.tf_4.text = RolePropDatas.OfferTile[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[4])];
            view.tf_5.text = GameCommonData.Player.Role.OfferValue[5];
            view.tf_6.text = RolePropDatas.OfferTile[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.PlayerGuildOffer)];
            var _local1:Array = GameCommonData.Player.Role.OfferValue;
            var _local2:int;
            while (_local2 < 5) {
                RolePropDatas.OfferTipsArr[_local2] = ((GameCommonData.Player.Role.OfferValue[_local2] + "/") + RolePropDatas.OfferLevelDef[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[_local2])]);
                view[("OfferProgressBarMask_" + _local2)].width = ((GameCommonData.Player.Role.OfferValue[_local2] / RolePropDatas.OfferLevelDef[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.OfferValue[_local2])]) * view[("OfferProgressBar_" + _local2)].width);
                _local2++;
            };
            RolePropDatas.OfferTipsArr[5] = GameCommonData.Player.Role.OfferValue[_local2];
            RolePropDatas.OfferTipsArr[6] = ((GameCommonData.Player.Role.PlayerGuildOffer + "/") + RolePropDatas.OfferLevelDef[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.PlayerGuildOffer)]);
            view["OfferProgressBarMask_6"].width = ((GameCommonData.Player.Role.PlayerGuildOffer / RolePropDatas.OfferLevelDef[RolePropDatas.GetOfferLevel(GameCommonData.Player.Role.PlayerGuildOffer)]) * view["OfferProgressBar_6"].width);
        }
        private function initView():void{
            var _local1:Sprite;
            view.x = 5;
            view.y = 10;
            var _local2:int;
            while (_local2 < 7) {
                view[("OfferProgressBar_" + _local2)].mask = view[("OfferProgressBarMask_" + _local2)];
                view[("OfferProgressBar_" + _local2)].mouseEnabled = false;
                view[("tf_" + _local2)].mouseEnabled = false;
                view[("OfferProgressBarMask_" + _local2)].visible = false;
                _local1 = new Sprite();
                _local1.name = ("OfferProgressBarShape_" + _local2);
                _local1.graphics.beginFill(1, 0);
                _local1.graphics.drawRect(0, 0, 163, 13);
                _local1.graphics.endFill();
                _local1.x = view[("OfferProgressBar_" + _local2)].x;
                _local1.y = view[("OfferProgressBar_" + _local2)].y;
                view.addChild(_local1);
                if (_local2 == 5){
                    view["OfferProgressBar_5"].alpha = 0;
                    view["OfferProgressBarMask_5"].alpha = 0;
                    _local1.alpha = 0;
                };
                _local2++;
            };
        }

    }
}//package GameUI.Modules.RoleProperty.Mediator 
