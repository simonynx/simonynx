//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.BaseUI {
    import flash.display.*;
    import GameUI.View.Components.*;

    public class UICoolDownView extends UISprite {

        public function UICoolDownView(_arg1:Number=32, _arg2:Number=32){
            var _local3:Shape = new Shape();
            _local3.graphics.beginFill(0xFF0000, 1);
            _local3.graphics.drawRect(0, 0, _arg1, _arg2);
            _local3.graphics.endFill();
            this.mask = _local3;
            this.addChild(_local3);
            this.width = _arg1;
            this.height = _arg2;
        }
        public function update(_arg1:int):void{
            var _local2:Number;
            this.graphics.clear();
            if (_arg1 > 240){
                return;
            };
            this.graphics.lineStyle(1, 16777113, 0.5);
            this.graphics.beginFill(0, 0.5);
            this.graphics.moveTo((width / 2), (height / 2));
            var _local3:int = _arg1;
            while (_local3 < 360) {
                _local3 = (_local3 + 120);
                if (_local3 > 360){
                    _local3 = 360;
                };
                _local2 = (((_local3 / 180) * Math.PI) - (Math.PI / 2));
                this.graphics.lineTo(((width / 2) + (Math.cos(_local2) * (width * 2))), ((height / 2) + (Math.sin(_local2) * (height * 2))));
                _local3++;
            };
            this.graphics.lineTo((width / 2), (height / 2));
        }

    }
}//package GameUI.View.BaseUI 
