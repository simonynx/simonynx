//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.View.items.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.NPCChat.Command.*;

    public class ChangeJobFrame extends Sprite {

        private var cancelBtn:HLabelButton;
        private var faceItem:FaceItem;
        private var frameWidth:int;
        private var npcId:int;
        private var linkStr:String;
        private var _bg:MovieClip;
        private var okBtn:HLabelButton;
        private var frameHeight:int;
        private var linkId:int;

        public function ChangeJobFrame(_arg1:int, _arg2:int, _arg3:String){
            this.npcId = _arg1;
            this.linkId = _arg2;
            this.linkStr = _arg3;
            init();
            addEvents();
        }
        private function removeEvents():void{
            okBtn.removeEventListener(MouseEvent.CLICK, __okHandler);
            cancelBtn.removeEventListener(MouseEvent.CLICK, __cancelHandler);
        }
        private function __faceLoadCompleteHandler(_arg1:Event):void{
            _arg1.currentTarget.removeEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
            faceItem.x = -32;
            faceItem.y = -189;
        }
        public function show():void{
            GameCommonData.GameInstance.GameUI.addChild(this);
            this.x = ((GameCommonData.GameInstance.ScreenWidth - frameWidth) / 2);
            this.y = ((GameCommonData.GameInstance.ScreenHeight - frameHeight) / 2);
        }
        private function __cancelHandler(_arg1:MouseEvent):void{
            close();
        }
        private function addEvents():void{
            okBtn.addEventListener(MouseEvent.CLICK, __okHandler);
            cancelBtn.addEventListener(MouseEvent.CLICK, __cancelHandler);
        }
        private function init():void{
            var _local1:String;
            _bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ChangejobFrameAsset");
            frameWidth = _bg.width;
            frameHeight = _bg.height;
            faceItem = new FaceItem("newguide", _bg, "NPCPic");
            faceItem.x = -32;
            faceItem.y = -189;
            faceItem.addEventListener(Event.COMPLETE, __faceLoadCompleteHandler);
            _bg.addChildAt(faceItem, 0);
            for each (_local1 in GameCommonData.RolesListDic) {
                if (linkStr.indexOf(_local1) != -1){
                    break;
                };
            };
            _bg.jobTF.text = _local1;
            okBtn = new HLabelButton();
            okBtn.label = "确定";
            okBtn.x = 160;
            okBtn.y = 83;
            _bg.addChild(okBtn);
            cancelBtn = new HLabelButton();
            cancelBtn.label = "取消";
            cancelBtn.x = 265;
            cancelBtn.y = 83;
            _bg.addChild(cancelBtn);
            addChild(_bg);
        }
        private function __okHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(NPCChatComList.SEND_NPC_MSG, {
                npcId:npcId,
                linkId:linkId
            });
            close();
        }
        public function close():void{
            removeEvents();
            if (this.parent){
                this.parent.removeChild(this);
            };
        }

    }
}//package GameUI.Modules.NPCChat.View 
