//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import flash.display.*;
    import GameUI.View.*;

    public class ShopCostItem extends Sprite {

        public var iconName:String = "";
        public var icon:Bitmap;
        protected var mkDir:String = "icon";

        public function ShopCostItem(_arg1:String, _arg2:String="icon"){
            this.cacheAsBitmap = true;
            this.iconName = _arg1;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.mkDir = _arg2;
            loadIcon();
        }
        private function loadIcon():void{
            ResourcesFactory.getInstance().getResource(((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".png?v=") + GameConfigData.ItemIconVersion), onLoabdComplete);
        }
        protected function onLoabdComplete():void{
            icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + iconName) + ".png"));
            if (icon){
                icon.scaleX = 0.5;
                icon.scaleY = 0.5;
                this.addChild(icon);
            };
        }

    }
}//package GameUI.View.items 
