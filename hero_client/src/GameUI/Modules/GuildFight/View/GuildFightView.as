//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.GuildFight.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.text.*;
    import GameUI.Modules.Chat.Data.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Chat.Mediator.*;

    public class GuildFightView extends Sprite {

        private var container:Sprite;
        private var page:TextField;
        private var pubMov:MovieClip;
        public var btnArray:Array;
        private var contentArray:Array;
        private var currentPage:uint;
        private var priMov:MovieClip;
        private var content:Sprite;

        public function GuildFightView(){
            btnArray = [];
            super();
            initView();
        }
        public function setInfos(_arg1:String, _arg2:String):void{
            content["guildname"].text = ((_arg1 == null)) ? "" : _arg1;
            content["rolename"].text = ((_arg2 == null)) ? "" : _arg2;
        }
        private function countMaxPage():uint{
            var _local1:uint = (contentArray.length / 6);
            if ((contentArray.length % 6) != 0){
                _local1 = (_local1 + 1);
            };
            return (_local1);
        }
        private function initBtns():void{
            var _local1:HLabelButton;
            _local1 = new HLabelButton();
            _local1.label = LanguageMgr.GetTranslation("报名城战");
            _local1.x = 25;
            _local1.y = 358;
            _local1.name = "1";
            this.addChild(_local1);
            btnArray.push(_local1);
            _local1 = new HLabelButton();
            _local1.label = LanguageMgr.GetTranslation("进入城战");
            _local1.x = 420;
            _local1.y = 358;
            _local1.name = "2";
            this.addChild(_local1);
            btnArray.push(_local1);
            _local1 = new HLabelButton();
            _local1.label = LanguageMgr.GetTranslation("规则介绍");
            _local1.x = 503;
            _local1.y = 358;
            _local1.name = "3";
            this.addChild(_local1);
            btnArray.push(_local1);
            _local1 = new HLabelButton(0);
            _local1.label = LanguageMgr.GetTranslation("上一页");
            _local1.x = 123;
            _local1.y = 311;
            this.addChild(_local1);
            _local1.addEventListener(MouseEvent.CLICK, onPrePage);
            _local1 = new HLabelButton(0);
            _local1.label = LanguageMgr.GetTranslation("下一页");
            _local1.x = 235;
            _local1.y = 311;
            this.addChild(_local1);
            _local1.addEventListener(MouseEvent.CLICK, onNextPage);
        }
        private function onPrePage(_arg1:MouseEvent):void{
            if (currentPage > 1){
                currentPage--;
                updateItem(contentArray);
                updatePages(currentPage);
            };
        }
        private function onSprClick(_arg1:MouseEvent):void{
            pubMov.y = 0;
            pubMov.x = 0;
            pubMov.height = 20;
            pubMov.width = 380;
            _arg1.currentTarget.addChildAt(pubMov, 0);
            var _local2:QuickSelectMediator = new QuickSelectMediator();
            UIFacade.GetInstance().registerMediator(_local2);
            UIFacade.GetInstance().sendNotification(ChatEvents.SHOWQUICKOPERATOR, {
                name:_arg1.currentTarget["guilder"],
                sendId:_arg1.currentTarget["roleid"],
                ownerItemId:_arg1.currentTarget["roleid"],
                model:["查看信息", "加为好友", "设为私聊", "复制姓名", "查看宠物"]
            });
        }
        private function onOver(_arg1:MouseEvent):void{
            priMov.y = 0;
            priMov.x = 0;
            priMov.height = 20;
            priMov.width = 380;
            _arg1.currentTarget.addChildAt(priMov, 0);
        }
        private function ClearContainer():void{
            var _local1:Sprite;
            while (container.numChildren > 0) {
                _local1 = (container.getChildAt(0) as Sprite);
                if (_local1 != null){
                    _local1.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
                    _local1.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
                    _local1.removeEventListener(MouseEvent.CLICK, onSprClick);
                    _local1 = null;
                };
                container.removeChildAt(0);
            };
        }
        private function initView():void{
            x = -5;
            y = -32;
            container = new Sprite();
            container.x = 15;
            container.y = 172;
            content = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFlashComponent("guildfight");
            content.x = 5;
            content.y = 32;
            page = content["page"];
            setInfos("", "");
            this.addChild(content);
            initBtns();
            this.addChild(container);
            pubMov = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Selection");
            pubMov.mouseEnabled = false;
            pubMov.mouseChildren = false;
            pubMov.stop();
            priMov = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Selection");
            priMov.mouseEnabled = false;
            priMov.mouseChildren = false;
            priMov.nextFrame();
            priMov.stop();
        }
        private function onNextPage(_arg1:MouseEvent):void{
            if (currentPage < countMaxPage()){
                currentPage++;
                updateItem(contentArray);
                updatePages(currentPage);
            };
        }
        private function SortContainer():void{
            var _local2:DisplayObject;
            var _local1:int;
            while (_local1 < container.numChildren) {
                _local2 = container.getChildAt(_local1);
                _local2.y = ((_local1 * 22) + 0);
                _local1++;
            };
        }
        private function onOut(_arg1:MouseEvent):void{
            if (((priMov) && (priMov.parent))){
                priMov.parent.removeChild(priMov);
            };
        }
        public function updatePages(_arg1:uint):void{
            if (_arg1 > 0){
                page.text = ((((currentPage < 1)) ? 1 : currentPage + "/") + countMaxPage());
            } else {
                page.text = "0/0";
            };
        }
        public function updateItem(_arg1:Array):void{
            var _local4:GuildFightItem;
            ClearContainer();
            contentArray = _arg1;
            if (_arg1.length > 0){
                if ((currentPage == 0)){
                    currentPage = 1;
                } else {
                    currentPage;
                };
                updatePages(currentPage);
            } else {
                updatePages(0);
                return;
            };
            var _local2:int = ((currentPage - 1) * 6);
            var _local3:int = _local2;
            while ((((_local3 < _arg1.length)) && ((_local3 < (_local2 + 6))))) {
                _local4 = _arg1[_local3];
                _local4.show();
                container.addChild(_local4);
                _local4.addEventListener(MouseEvent.MOUSE_OVER, onOver);
                _local4.addEventListener(MouseEvent.MOUSE_OUT, onOut);
                _local4.addEventListener(MouseEvent.CLICK, onSprClick);
                _local3++;
            };
            SortContainer();
        }

    }
}//package GameUI.Modules.GuildFight.View 
