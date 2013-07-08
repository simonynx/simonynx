//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Friend.view.ui {
    import flash.display.*;
    import GameUI.View.Components.*;

    public class UIFriendListPanel extends Sprite {

        private var scrollPane:UIScrollPane;
        private var friendList:UIFriendsList;

        public function UIFriendListPanel(){
            initView();
        }
        protected function initView():void{
            this.friendList = new UIFriendsList();
            this.friendList.width = 198;
            this.friendList.height = 350;
            this.scrollPane = new UIScrollPane(friendList);
            this.scrollPane.scrollPolicy = UIScrollPane.SCROLLBAR_ALWAYS;
            this.scrollPane.width = 201;
            this.scrollPane.height = 350;
            this.scrollPane.refresh();
            this.addChild(this.scrollPane);
        }
        public function setData(_arg1:Array):void{
            this.friendList.dataPro = _arg1;
            this.scrollPane.refresh();
        }

    }
}//package GameUI.Modules.Friend.view.ui 
