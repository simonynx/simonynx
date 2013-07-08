//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.*;
    import GameUI.View.HButton.*;
    import flash.filters.*;
    import Net.RequestSend.*;
    import GameUI.Modules.Activity.Command.*;

    public class GiftBagItem extends Sprite {

        private var view:Sprite;
        private var pic:Bitmap;
        public var getBtn:HLabelButton;
        private var picPath:String;
        private var _index:int;

        public function GiftBagItem(_arg1:int){
            _index = _arg1;
            init();
            initEvent();
        }
        private function onGetHandler(_arg1:MouseEvent):void{
            ActivitySend.sendAccumulativeCharge((_index + 1));
        }
        private function loadPic():void{
            ResourcesFactory.getInstance().getResource(picPath, onLoabdCompletePic);
        }
        public function openService():void{
            getBtn.label = LanguageMgr.GetTranslation("领取");
            view["goldTxt"].text = (ActivityConstants.ChargeGoldList[_index] + LanguageMgr.GetTranslation("金叶礼包"));
            picPath = (("Resources/icon/" + ActivityConstants.itemIdArr[_index]) + ".png");
            loadPic();
        }
        private function init():void{
            view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GiftBagItemAsset");
            this.addChild(view);
            getBtn = new HLabelButton();
            getBtn.x = 28;
            getBtn.y = 78;
            view.addChild(getBtn);
        }
        public function get index():int{
            return (_index);
        }
        private function onItemOver(_arg1:MouseEvent):void{
            var _local2:* = new Array();
            _local2 = _local2.concat([1, 0, 0, 0, 25]);
            _local2 = _local2.concat([0, 1, 0, 0, 25]);
            _local2 = _local2.concat([0, 0, 1, 0, 25]);
            _local2 = _local2.concat([0, 0, 0, 1, 0]);
            this.filters = [new ColorMatrixFilter(_local2)];
        }
        private function onLoabdCompletePic():void{
            pic = ResourcesFactory.getInstance().getBitMapResourceByUrl(picPath);
            if (pic){
                view.addChild(pic);
                pic.x = 26;
                pic.y = 5;
                pic.width = 50;
                pic.height = 51;
            };
        }
        private function initEvent():void{
            this.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, onItemOut);
            getBtn.addEventListener(MouseEvent.CLICK, onGetHandler);
        }
        private function onItemOut(_arg1:MouseEvent):void{
            this.filters = [];
        }
        public function closeService():void{
            getBtn.enable = false;
            getBtn.label = LanguageMgr.GetTranslation("关闭");
            view["goldTxt"].text = LanguageMgr.GetTranslation("未开放礼包");
            picPath = (("Resources/icon/" + "50200023") + ".png");
            loadPic();
        }

    }
}//package GameUI.Modules.Activity.UI 
