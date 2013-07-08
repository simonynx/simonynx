//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import flash.display.*;
    import OopsFramework.*;
    import GameUI.View.*;
    import OopsEngine.Entity.*;

	/**
	 *游戏场景层 
	 * @author wengliqiang
	 * 
	 */	
    public class GameSceneLayer extends Sprite implements IDisposable {

        private var depthCount:int;
        private var canDepthSort:Boolean = true;
        private var drawableElements:Array;
        private var elements:GameElementCollection;

        public function GameSceneLayer(){
            this.mouseEnabled = false;
            this.elements = new GameElementCollection();
            this.elements.Added = onGameElementAdded;
            this.elements.AddAddChild = onGameElementAddAddchild;
            this.drawableElements = [];
            trace(("new gamescenelayer()" + this));
        }
        private function onGameElementAddAddchild(_arg1:GameElement):void{
            this.addChild(_arg1);
            this.DepthSort();
        }
        public function DepthSort(_arg1:GameElement=null):void{
            var _local3:int;
            var _local2:int;
            if (((canDepthSort) || ((_arg1 == null)))){
                canDepthSort = false;
                _local3 = this.elements.Count;
                if (((this.elements) && ((_local3 > 1)))){
                    this.elements.SortOn("Depth", Array.NUMERIC);
                    while (_local2 < _local3) {
                        if (this.elements[_local2].parent == this){
                            if (this.getChildIndex(this.elements[_local2]) != _local2){
                                this.setChildIndex(this.elements[_local2], _local2);
                            };
                        } else {
                            MessageTip.show(((("Element位置错误，已经被移除" + this.elements[_local2].parent) + (this.elements[_local2] as GameElement).X) + (this.elements[_local2] as GameElement).Y));
                        };
                        _local2++;
                    };
                };
            };
        }
        public function get Elements():GameElementCollection{
            return (this.elements);
        }
        public function Update(_arg1:GameTime):void{
            var _local2:IUpdateable;
            var _local3:int;
            this.drawableElements = this.elements.Concat();
            while (_local3 < this.drawableElements.length) {
                _local2 = (this.drawableElements[_local3] as IUpdateable);
                if (_local2.Enabled){
                    _local2.Update(_arg1);
                };
                _local3++;
            };
            this.drawableElements = [];
            if (depthCount < 6){
                depthCount++;
            } else {
                depthCount = 0;
                if (canDepthSort == true){
                    DepthSort();
                };
            };
        }
        public function depthSortMark():void{
            canDepthSort = true;
        }
        public function ClearElement():void{
            var _local1:IDisposable;
            var _local2:int;
            while (_local2 < this.elements.Count) {
                _local1 = (this.elements[_local2] as IDisposable);
                _local1.Dispose();
                _local1 = null;
                _local2++;
            };
            this.elements = new GameElementCollection();
            this.elements.Added = onGameElementAdded;
            this.drawableElements = [];
            while (this.numChildren != 0) {
                this.removeChildAt((this.numChildren - 1));
            };
        }
        private function onItemDisposed(_arg1:EntityElement):void{
            if (this.Elements.Remove(_arg1) == false){
                trace("移除失败");
            };
        }
        private function onGameElementAdded(_arg1:GameElement):void{
            _arg1.Initialize();
            _arg1.Disposed = onItemDisposed;
            this.addChild(_arg1);
            this.DepthSort();
        }
        public function Dispose():void{
            var _local1:IDisposable;
            var _local2:int;
            while (_local2 < this.elements.Count) {
                _local1 = (this.elements[_local2] as IDisposable);
                _local1.Dispose();
                _local2++;
            };
            while (this.numChildren != 0) {
                this.removeChildAt((this.numChildren - 1));
            };
            if (this.parent != null){
                this.parent.removeChild(this);
            };
            this.elements = null;
            this.drawableElements = null;
            trace(("Dispose gamescenelayer" + this));
        }

    }
}//package OopsEngine.Scene 
