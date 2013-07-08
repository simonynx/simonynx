//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.GameComponents {
    import OopsFramework.*;
    import OopsFramework.Collections.*;

	/**
	 *UI组件 
	 * @author wengliqiang
	 * 
	 */	
    public class UIComponent extends DrawableGameComponent {

        private var drawableElements:Array;
        private var elements:ArrayCollection;

        public function UIComponent(_arg1:Game){
            super(_arg1);
            this.name = "UILayer";
            this.mouseEnabled = false;
            this.elements = new ArrayCollection();
        }
        public function get Elements():ArrayCollection{
            return (this.elements);
        }
        override public function Update(_arg1:GameTime):void{
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
        }

    }
}//package OopsEngine.GameComponents 
