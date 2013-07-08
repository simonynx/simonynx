//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Scene {
    import OopsFramework.*;
    import OopsEngine.Entity.*;

	/**
	 *游戏对象，有深度 
	 * @author wengliqiang
	 * 
	 */	
    public class GameElement extends EntityElement {

        public var Prams:String;
        protected var excursionX:int = 0;
        protected var excursionY:int = 0;

        public function GameElement(_arg1:Game){
            super(_arg1);
        }
        public function get Depth():Number{
            return ((this.Y + this.excursionY));
        }
        public function get ExcursionX():Number{
            return (this.excursionX);
        }
        public function get ExcursionY():Number{
            return (this.excursionY);
        }

    }
}//package OopsEngine.Scene 
