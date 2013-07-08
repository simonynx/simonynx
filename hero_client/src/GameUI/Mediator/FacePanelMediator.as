//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Mediator {
    import flash.events.*;
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.geom.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.Modules.Friend.command.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.*;

    public class FacePanelMediator extends Mediator {

        public static const NAME:String = "FacePanelMediator";

        private var type:String = "chat";
        private var defaultPos:Point;

        public function FacePanelMediator(){
            defaultPos = new Point(320, 460);
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.SHOWFACEVIEW, EventList.HIDESELECTFACE]);
        }
        private function removeList(_arg1:MouseEvent):void{
            var _local2:String;
            var _local3:* = 1;
            while (_local3 <= ChatData.FACE_NUM) {
                if (faceView){
                    _local2 = _local3.toString();
                    if (_local3 < 10){
                        _local2 = ("00" + _local3);
                    } else {
                        _local2 = ("0" + _local3);
                    };
                    if (_arg1.target.name == faceView[("btn_" + _local2)].name){
                        return;
                    };
                };
                _local3++;
            };
            if (_arg1.target.name == "btnFace"){
                return;
            };
            GameCommonData.GameInstance.TooltipLayer.removeEventListener(MouseEvent.MOUSE_DOWN, removeList);
            if (faceView){
                if (GameCommonData.GameInstance.GameUI.contains(faceView)){
                    UIConstData.SelectFaceIsOpen = false;
                    GameCommonData.GameInstance.GameUI.removeChild(faceView);
                    this.viewComponent = null;
                    facade.removeMediator(NAME);
                };
            };
        }
        private function get faceView():MovieClip{
            return ((this.viewComponent as MovieClip));
        }
        private function closeHandler():void{
            if (GameCommonData.GameInstance.GameUI.contains(faceView)){
                UIConstData.SelectFaceIsOpen = false;
                GameCommonData.GameInstance.GameUI.removeChild(faceView);
                this.viewComponent = null;
                facade.removeMediator(NAME);
            };
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.SHOWFACEVIEW:
                    facade.sendNotification(EventList.GETRESOURCE, {
                        type:UIConfigData.MOVIECLIP,
                        mediator:this,
                        name:UIConfigData.SELECTFACE
                    });
                    if (_arg1.getBody()){
                        faceView.x = _arg1.getBody().x;
                        faceView.y = _arg1.getBody().y;
                        type = _arg1.getBody().type;
                    } else {
                        faceView.x = defaultPos.x;
                        faceView.y = defaultPos.y;
                    };
                    GameCommonData.GameInstance.GameUI.addChild(faceView);
                    UIConstData.SelectFaceIsOpen = true;
                    initView();
                    break;
                case EventList.HIDESELECTFACE:
                    closeHandler();
                    break;
            };
        }
        private function selectFace(_arg1:MouseEvent):void{
            var _local2:String = _arg1.currentTarget.name.split("_")[1];
            if (type == "chat"){
                facade.sendNotification(ChatEvents.SELECTEDFACETOCHAT, _local2);
            } else {
                if (type == "friend"){
                    facade.sendNotification(FriendCommandList.GET_FACE_NAME, _local2);
                };
            };
            closeHandler();
        }
        private function initView():void{
            var _local1:String;
            var _local2:* = 1;
            while (_local2 <= ChatData.FACE_NUM) {
                _local1 = _local2.toString();
                if (_local2 < 10){
                    _local1 = ("00" + _local2);
                } else {
                    _local1 = ("0" + _local2);
                };
                faceView[("btn_" + _local1)].addEventListener(MouseEvent.CLICK, selectFace);
                _local2++;
            };
            GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_DOWN, removeList);
        }

    }
}//package GameUI.Mediator 
