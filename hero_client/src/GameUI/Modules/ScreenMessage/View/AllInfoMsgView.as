//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ScreenMessage.View {
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.Proxy.*;
    import GameUI.View.Components.*;
    import GameUI.View.BaseUI.*;

    public class AllInfoMsgView extends Sprite {

        private static var instance:AllInfoMsgView;

        private var listView:ListComponent;
        private var view:HFrame;
        private var menu:UIScrollPane;

        public function AllInfoMsgView(){
            init();
            super();
        }
        public static function get Instance():AllInfoMsgView{
            if (instance == null){
                instance = new (AllInfoMsgView)();
            };
            return (instance);
        }

        private function init():void{
            view = new HFrame();
            view.mouseEnabled = true;
            view.showClose = true;
            view.blackGound = false;
            view.titleText = LanguageMgr.GetTranslation("系统历史记录");
            view.closeCallBack = hide;
            view.centerTitle = true;
            view.setSize(310, 252);
            var _local1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("BlueBack2");
            _local1.width = 305;
            _local1.height = 220;
            view.addContent(_local1);
            _local1.x = 3;
            _local1.y = 31;
            listView = new ListComponent(false);
            listView.ItemMax = 70;
            listView.width = 298;
            listView.height = 212;
            menu = new UIScrollPane(listView);
            menu.x = 5;
            menu.y = 34;
            menu.width = 300;
            menu.height = 212;
            menu.scrollPolicy = UIScrollPane.SCROLLBAR_AS_NEEDED;
            menu.refresh();
            view.addContent(menu);
        }
        public function setPos():void{
            view.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 100);
        }
        public function addItem(_arg1:String):void{
            var _local2:HistoryItem = new HistoryItem(_arg1);
            listView.SetChild(_local2);
            menu.scrollBottom();
            menu.refresh();
        }
        public function hide():void{
            if (view.parent){
                view.parent.removeChild(view);
            };
            MsgButton.Instance.setVisible();
            (UIFacade.GetInstance().retrieveProxy(DataProxy.NAME) as DataProxy).AllInfoMsgIsOpen = false;
        }
        public function show():void{
            GameCommonData.GameInstance.GameUI.addChild(view);
            view.x = ((GameCommonData.GameInstance.ScreenWidth / 2) + 100);
            view.y = 120;
        }

    }
}//package GameUI.Modules.ScreenMessage.View 
