//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Pk.view {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import flash.geom.*;
    import Manager.*;
    import flash.text.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Pk.Data.*;
    import Net.RequestSend.*;

    public class PkSceneTipsView extends HFrame {

        private var okBtn:HLabelButton;
        private var cancelBtn:HLabelButton;
        private var box:HCheckBox;
        private var _targetPoint:Point;
        private var contentSprite:Sprite;

        public function PkSceneTipsView(){
            initView();
            addEvents();
        }
        public function set targetPoint(_arg1:Point):void{
            _targetPoint = _arg1;
        }
        public function get targetPoint():Point{
            return (_targetPoint);
        }
        private function __okHandler(_arg1:MouseEvent):void{
            if (box.selected){
                SharedManager.getInstance().enterPKSceneTips = true;
            };
            UIFacade.GetInstance().sendNotification(PkEvent.PKSCENETIPS_HIDE);
            PlayerActionSend.trainmitChange(targetPoint.x, targetPoint.y, 0);
        }
        private function __cancelHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(PkEvent.PKSCENETIPS_HIDE);
        }
        private function initView():void{
            var _local1:TextField;
            setSize(250, 150);
            titleText = LanguageMgr.GetTranslation("PK场景提示");
            centerTitle = true;
            contentSprite = new Sprite();
            _local1 = new TextField();
            _local1.text = LanguageMgr.GetTranslation("此场景为可强制PK句");
            _local1.x = 42;
            _local1.y = 40;
            _local1.width = 200;
            _local1.height = 20;
            _local1.textColor = 0xFFFFFF;
            _local1.selectable = false;
            contentSprite.addChild(_local1);
            box = new HCheckBox(LanguageMgr.GetTranslation("记住我的选择"));
            box.name = "pkscenetips_checkBox";
            box.fireAuto = true;
            box.x = 80;
            box.y = 70;
            contentSprite.addChild(box);
            okBtn = new HLabelButton();
            okBtn.label = LanguageMgr.GetTranslation("确认");
            okBtn.x = 60;
            okBtn.y = 110;
            contentSprite.addChild(okBtn);
            cancelBtn = new HLabelButton();
            cancelBtn.label = LanguageMgr.GetTranslation("取消");
            cancelBtn.x = 150;
            cancelBtn.y = 110;
            contentSprite.addChild(cancelBtn);
            addContent(contentSprite);
        }
        private function addEvents():void{
            okBtn.addEventListener(MouseEvent.CLICK, __okHandler);
            cancelBtn.addEventListener(MouseEvent.CLICK, __cancelHandler);
        }
        private function removeEvents():void{
            okBtn.removeEventListener(MouseEvent.CLICK, __okHandler);
            cancelBtn.removeEventListener(MouseEvent.CLICK, __cancelHandler);
        }
        override public function dispose():void{
            removeEvents();
            if (parent){
                this.parent.removeChild(this);
            };
            if (box){
                box.dispose();
                box = null;
            };
            if (okBtn){
                okBtn.dispose();
                okBtn = null;
            };
            if (cancelBtn){
                cancelBtn.dispose();
                cancelBtn = null;
            };
        }

    }
}//package GameUI.Modules.Pk.view 
