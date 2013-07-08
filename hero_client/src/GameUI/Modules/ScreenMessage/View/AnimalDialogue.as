//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.display.*;
    import flash.utils.*;
    import GameUI.Modules.Friend.view.ui.*;

    public class AnimalDialogue extends Sprite {

        private var bg:Sprite;
        private var bgHeight:int;
        private var setTimeNum;
        private var chat:FriendChatCell;

        public function AnimalDialogue(){
            init();
            super();
        }
        private function hide():void{
            if (bg.parent){
                bg.parent.removeChild(bg);
            };
            if (((chat) && (chat.parent))){
                chat.parent.removeChild(chat);
                chat = null;
            };
        }
        public function dispose():void{
            clearTimeout(setTimeNum);
            if (((chat) && (chat.parent))){
                chat.parent.removeChild(chat);
                chat = null;
            };
            if (bg.parent){
                bg.parent.removeChild(bg);
                bg = null;
            };
        }
        public function showDialogue(_arg1:String):void{
            clearTimeout(setTimeNum);
            hide();
            chat = new FriendChatCell(190);
            chat.des = _arg1;
            chat.x = 14;
            chat.y = 9;
            if (chat.height > 28){
                bg.height = (chat.height + 30);
            } else {
                bg.height = bgHeight;
            };
            this.addChild(bg);
            this.addChild(chat);
            setTimeNum = setTimeout(hide, 5000);
        }
        private function init():void{
            this.mouseChildren = false;
            this.mouseEnabled = false;
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("PaopaoBg");
            bgHeight = bg.height;
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
