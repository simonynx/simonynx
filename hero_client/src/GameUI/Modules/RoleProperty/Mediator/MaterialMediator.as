//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.RoleProperty.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import Net.RequestSend.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.View.OhterUI.*;
    import GameUI.Modules.Achieve.Data.*;

    public class MaterialMediator extends Mediator {

        public static const TYPE:int = 3;
        public static const NAME:String = "MaterialMediator";

        private var parentView:Sprite;
        private var commbox:MyCombox;

        public function MaterialMediator(_arg1:Sprite){
            this.parentView = _arg1;
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([RoleEvents.INITROLEVIEW, RoleEvents.SHOWPROPELEMENT, RoleEvents.UPDATE_PKVALUE, RoleEvents.UPDATE_ACHIEVETITLE]);
        }
        private function addEvents():void{
            commbox.addEventListener(Event.CHANGE, __changeCommboxHandler);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case RoleEvents.INITROLEVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.MATERIALMPANEL
                    });
                    this.view.mouseEnabled = false;
                    initView();
                    addEvents();
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
                    updateInfo();
                    break;
                case RoleEvents.UPDATE_PKVALUE:
					
                   // view.killValueTF.text = ((GameCommonData.Player.Role.PkTime >= 10)) ? GameCommonData.Player.Role.PkTime : "0";//geoffyan
                    break;
                case RoleEvents.UPDATE_ACHIEVETITLE:
                    updateInfo();
                    break;
            };
        }
        private function get view():MovieClip{
            return ((getViewComponent() as MovieClip));
        }
        private function initView():void{
            view.x = 5;
            view.y = 10;
            commbox = new MyCombox(125, 100, 125);
            commbox.x = 90;
            commbox.y = 55;
            view.addChild(commbox);
        }
        private function updateInfo():void{
            var _local1:int;
            var _local2:TitleInfo;
            var _local5:String;
            var _local6:XML;
            view.jobTF.text = GameCommonData.RolesListDic[GameCommonData.Player.Role.CurrentJobID];
            view.levelTF.text = GameCommonData.Player.Role.Level;
            view.guildNameTF.text = GameCommonData.Player.Role.GuildName;
            view.killValueTF.text = ((GameCommonData.Player.Role.PkTime >= 10)) ? GameCommonData.Player.Role.PkTime : "0";
            var _local3:XML = new XML("<list></list>");
            var _local4:int;
            while (_local4 < GameCommonData.Player.Role.OwnTitles.length) {
                _local2 = GameCommonData.TitleDic[GameCommonData.Player.Role.OwnTitles[_local4]];
                _local5 = (((("<node label=\"" + _local2.Name) + "\" data=\"") + _local2.Id) + "\"/>");
                _local6 = new XML(_local5);
                _local3.appendChild(_local6);
                if (GameCommonData.Player.Role.CurrentTitleId == _local2.Id){
                    _local1 = _local4;
                };
                _local4++;
            };
            commbox.listXml = _local3;
            if (GameCommonData.Player.Role.OwnTitles.length > 0){
                commbox.setSelectItemByIndex(_local1);
            };
        }
        private function __changeCommboxHandler(_arg1:Event):void{
            var _local2:int = uint(commbox.selectItem.data);
            if (GameCommonData.Player.Role.CurrentTitleId != _local2){
                CharacterSend.chooseUseTitle(_local2);
            };
        }

    }
}//package GameUI.Modules.RoleProperty.Mediator 
