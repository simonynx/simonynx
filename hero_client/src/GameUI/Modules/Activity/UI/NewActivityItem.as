//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.Task.Commamd.*;
    import GameUI.Modules.Activity.VO.*;

    public class NewActivityItem extends Sprite {

        private var picPath:String;
        private var pic:Bitmap;
        private var starContainer:Sprite;
        private var goBtn:HLabelButton;
        private var view:Sprite;
        private var flyBtn:HLabelButton;
        private var info:ActivityVO;

        public function NewActivityItem(_arg1:ActivityVO){
            info = _arg1;
            picPath = (("Resources/ActivityPic/" + info.picPath) + "_h.png");
            init();
            initEvent();
        }
        private function goHandler(_arg1:MouseEvent):void{
            if (info.targetNPC == "dailybook"){
                UIFacade.GetInstance().sendNotification(EventList.SHOWTASKDAILYBOOK);
                _arg1.stopImmediatePropagation();
                return;
            };
            MoveToCommon.MoveTo(info.sceneID, info.tileX, info.tileY, 0, 0);
            _arg1.stopImmediatePropagation();
        }
        private function loadPic():void{
            ResourcesFactory.getInstance().getResource(picPath, onLoabdCompletePic);
        }
        public function setCount():void{
            if (info.attend > 0){
                view["count"].text = (((((info.current + "/(") + info.total) + "+") + info.attend) + ")");
            } else {
                view["count"].text = ((info.current + "/") + info.total);
            };
            if (info.total == 500){
                view["count"].text = "---";
            };
        }
        private function init():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("NewActivityAsset");
            this.addChild(view);
            goBtn = new HLabelButton();
            goBtn.label = LanguageMgr.GetTranslation("前往");
            goBtn.x = 328;
            goBtn.y = 8;
            view.addChild(goBtn);
            flyBtn = new HLabelButton();
            flyBtn.label = LanguageMgr.GetTranslation("传送");
            flyBtn.x = (348 + goBtn.width);
            flyBtn.y = 8;
            view.addChild(flyBtn);
            starContainer = new Sprite();
            starContainer.x = 368;
            starContainer.y = 50;
            addChild(starContainer);
            setItemInfo();
            loadPic();
            setBtnEnable();
        }
        public function addChildSelect(_arg1:DisplayObject):void{
            this.view.addChildAt(_arg1, 1);
        }
        public function dispose():void{
            removeEvent();
            if (goBtn){
                goBtn.dispose();
                goBtn = null;
            };
            if (flyBtn){
                flyBtn.dispose();
                flyBtn = null;
            };
            if (this.parent){
                this.parent.removeChild(this);
            };
        }
        public function getData():ActivityVO{
            return (info);
        }
        public function setItemInfo():void{
            var _local1:int;
            var _local2:int;
            var _local3:MovieClip;
            view["actName"].text = info.name;
            view["level"].text = ((info.level + "-") + info.maxLevel);
            if (info.teamType == 0){
                view["level"].text = (view["level"].text + LanguageMgr.GetTranslation("括号单人"));
            } else {
                if (info.teamType == 1){
                    view["level"].text = (view["level"].text + LanguageMgr.GetTranslation("括号组队"));
                } else {
                    view["level"].text = (view["level"].text + LanguageMgr.GetTranslation("括号单人组队"));
                };
            };
            view["time"].text = info.timePrompt;
            view["exp"].text = info.reward.slice(0, 3);
            if (starContainer){
                while (starContainer.numChildren) {
                    starContainer.removeChildAt(0);
                };
                _local1 = info.rewardCnt;
                _local2 = 0;
                while (_local2 < _local1) {
                    _local3 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("UpGradeBibleStar");
                    starContainer.addChild(_local3);
                    _local3.y = 3;
                    _local3.x = (_local2 * 16);
                    _local2++;
                };
            };
            setCount();
        }
        private function flyHandler(_arg1:MouseEvent):void{
            MoveToCommon.FlyTo(info.sceneID, info.tileX, info.tileY, 0, 0);
            _arg1.stopImmediatePropagation();
        }
        private function initEvent():void{
            goBtn.addEventListener(MouseEvent.CLICK, goHandler);
            flyBtn.addEventListener(MouseEvent.CLICK, flyHandler);
        }
        private function onLoabdCompletePic():void{
            pic = ResourcesFactory.getInstance().getBitMapResourceByUrl(picPath);
            if (pic){
                view.addChild(pic);
                pic.x = 10;
                pic.y = 8;
                if (info.currentType == 1){
                    pic.filters = [ColorFilters.BWFilter];
                };
            };
        }
        private function removeEvent():void{
            goBtn.removeEventListener(MouseEvent.CLICK, goHandler);
            flyBtn.removeEventListener(MouseEvent.CLICK, flyHandler);
        }
        private function setBtnEnable():void{
            if (info.currentType == 1){
                goBtn.enable = false;
                flyBtn.enable = false;
            };
            if (info.targetNPC == ""){
                goBtn.visible = false;
                flyBtn.visible = false;
            } else {
                if (info.targetNPC == "dailybook"){
                    goBtn.label = LanguageMgr.GetTranslation("领取");
                    if ((((GameCommonData.Player.Role.Level >= 32)) && (!((info.currentType == 1))))){
                        goBtn.enable = true;
                    } else {
                        goBtn.enable = false;
                    };
                    flyBtn.visible = false;
                };
            };
        }

    }
}//package GameUI.Modules.Activity.UI 
