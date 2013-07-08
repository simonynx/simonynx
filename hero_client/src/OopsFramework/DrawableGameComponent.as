//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {
    import OopsFramework.Content.Provider.*;

	/**
	 *可被绘制的游戏组件 
	 * @author wengliqiang
	 * 
	 */	
    public class DrawableGameComponent extends GameComponent implements IDrawable {

        protected var ResourceProviderEntity:ResourceProvider = null;
        private var isLocalContent:Boolean = false;
        private var visibleChanged:Function;
        private var drawOrderChanged:Function;
        private var initialized:Boolean = false;

        public function DrawableGameComponent(_arg1:Game){
            super(_arg1);
        }
        public function get DrawOrderChanged():Function{
            return (this.drawOrderChanged);
        }
        public function get DrawOrder():int{
            if (this.parent != null){
                return (this.parent.getChildIndex(this));
            };
            return (-1);
        }
        public function set DrawOrder(_arg1:int):void{
            var _local2:int;
            if (this.parent != null){
                _local2 = (this.parent.numChildren - 1);
                if (_arg1 >= _local2){
                    _arg1 = _local2;
                };
                this.parent.setChildIndex(this, _arg1);
                if (drawOrderChanged != null){
                    drawOrderChanged(this);
                };
            };
        }
        public function get Visible():Boolean{
            return (this.visible);
        }
        protected function LoadContent():void{
            this.Enabled = true;
        }
        public function set VisibleChanged(_arg1:Function):void{
            this.visibleChanged = _arg1;
        }
        public function set DrawOrderChanged(_arg1:Function):void{
            this.drawOrderChanged = _arg1;
        }
        public function get VisibleChanged():Function{
            return (this.visibleChanged);
        }
        public function set Visible(_arg1:Boolean):void{
            if (this.visible != _arg1){
                this.visible = _arg1;
                if (visibleChanged != null){
                    visibleChanged(this);
                };
            };
        }
        override public function Initialize():void{
            if (!this.initialized){
                if (this.ResourceProviderEntity == null){
                    this.LoadContent();
                } else {
                    this.ResourceProviderEntity.LoadComplete = LoadContent;
                    this.ResourceProviderEntity.Load();
                };
            };
            this.initialized = true;
        }

    }
}//package OopsFramework 
