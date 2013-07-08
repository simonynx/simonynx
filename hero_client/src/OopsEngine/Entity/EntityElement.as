//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Entity {
    import OopsFramework.*;

	/**
	 *实体对象 
	 * @author wengliqiang
	 * 
	 */	
    public class EntityElement extends DrawableGameComponent implements IDisposable {

        public var Disposed:Function;

        public function EntityElement(_arg1:Game){
            super(_arg1);
            this.mouseEnabled = false;
            this.mouseChildren = false;
        }
        public function set X(_arg1:Number):void{
            this.x = _arg1;
        }
        public function set Y(_arg1:Number):void{
            this.y = _arg1;
        }
        public function get X():Number{
            return (this.x);
        }
        public function get Y():Number{
            return (this.y);
        }
        public function set Rotation(_arg1:Number):void{
            this.rotation = _arg1;
        }
        public function get Rotation():Number{
            return (this.rotation);
        }
        public function Dispose():void{
            if (this.parent != null){
                this.parent.removeChild(this);
                if (Disposed != null){
                    Disposed(this);
                };
            };
        }

    }
}//package OopsEngine.Entity 
