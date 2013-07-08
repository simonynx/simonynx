//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.display.*;
    import GameUI.View.Components.*;

    public class ListComponent extends UISprite {

        public static const OFFSET_WIDTH:int = 6;
        public static const OFFSET_HEIGHT:int = 6;

        private var itemHeigth:Number = 0;
        private var itemCount:int = 0;
        private var isUseBack:Boolean = true;
        public var Offset:int = 2;
        public var ItemMax:int = 500;
        private var itemWidth:Number = 0;
        private var backMc:MovieClip = null;

        public function ListComponent(_arg1:Boolean=true){
            this.isUseBack = _arg1;
            if (this.isUseBack){
                backMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ListBack");
                this.addChild(backMc);
            };
            super();
            removeChild(iBackground);
        }
        public function SetChild(_arg1:DisplayObject):void{
            this.addChild(_arg1);
            itemCount++;
            itemWidth = _arg1.width;
            itemHeigth = _arg1.height;
            upDataPos();
        }
        public function upDataPos():void{
            var _local1:DisplayObject;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            if (this.isUseBack){
                _local3 = 1;
            };
            while (ItemMax < this.numChildren) {
                this.removeChildAt(0);
            };
            _local4 = this.numChildren;
            while (_local3 < _local4) {
                _local1 = getChildAt(_local3);
                _local1.y = (_local2 + Offset);
                _local1.x = Offset;
                _local2 = (_local2 + _local1.height);
                _local3++;
            };
            if (_local1){
                this.height = (_local1.y + _local1.height);
            } else {
                this.height = 0;
            };
            if (isUseBack){
                backMc.x = 0;
                backMc.y = 0;
                backMc.height = ((itemCount * itemHeigth) + OFFSET_HEIGHT);
                backMc.width = (itemWidth + OFFSET_WIDTH);
            };
        }
        public function setBackVisible(_arg1:Boolean):void{
            backMc.visible = _arg1;
        }

    }
}//package GameUI.View.BaseUI 
