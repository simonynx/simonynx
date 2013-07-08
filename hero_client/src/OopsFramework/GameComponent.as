//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {
    import flash.display.*;

	/**
	 *游戏组件 Initialize 可更新 包含对game的引用
	 * @author wengliqiang
	 * 
	 */	
    public class GameComponent extends Sprite implements IGameComponent, IUpdateable {

        private var enabled:Boolean;
        private var updateOrder:int;
        private var updateOrderChanged:Function;
        private var game:Game;
        private var enabledChanged:Function;

        public function GameComponent(_arg1:Game){
            this.game = _arg1;
        }
        public function set Enabled(_arg1:Boolean):void{
            if (this.enabled != _arg1){
                this.enabled = _arg1;
                if (enabledChanged != null){
                    enabledChanged(this);
                };
            };
        }
        public function set UpdateOrder(_arg1:int):void{
            if (this.updateOrder != _arg1){
                this.updateOrder = _arg1;
                if (updateOrderChanged != null){
                    updateOrderChanged(this);
                };
            };
        }
        public function get EnabledChanged():Function{
            return (this.enabledChanged);
        }
        public function get UpdateOrderChanged():Function{
            return (this.updateOrderChanged);
        }
        public function get Games():Game{
            return (this.game);
        }
        public function get UpdateOrder():int{
            return (updateOrder);
        }
        public function get Enabled():Boolean{
            return (enabled);
        }
        public function Update(_arg1:GameTime):void{
        }
        public function set EnabledChanged(_arg1:Function):void{
            this.enabledChanged = _arg1;
        }
        public function Initialize():void{
            this.enabled = true;
        }
        public function set UpdateOrderChanged(_arg1:Function):void{
            this.updateOrderChanged = _arg1;
        }

    }
}//package OopsFramework 
