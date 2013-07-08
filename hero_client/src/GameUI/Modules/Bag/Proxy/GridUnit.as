//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Bag.Proxy {
    import flash.display.*;

    public class GridUnit {

        public var Grid:MovieClip = null;
        public var IsUsed:Boolean = false;
        public var parent:MovieClip = null;
        public var HasBag:Boolean = true;
        public var Index:int = -1;
        public var Item = null;

        public function GridUnit(_arg1:MovieClip, _arg2:Boolean=false){
            this.Grid = _arg1;
            if (this.Grid){
                this.Grid.doubleClickEnabled = _arg2;
            };
        }
    }
}//package GameUI.Modules.Bag.Proxy 
