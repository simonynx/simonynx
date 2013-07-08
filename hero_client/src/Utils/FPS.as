//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.system.*;

    public class FPS extends Sprite {

        private static const tfDelayMax:int = 10;
        private static const maxMemory:uint = 41943000;
        private static const diagramHeight:uint = 40;
        private static const diagramWidth:uint = 60;

        private static var instance:FPS;

        private var currentY:int;
        private var fps:TextField;
        private var tfDelay:int = 0;
        private var diagramTimer:int;
        private var tfTimer:int;
        private var mem:TextField;
        private var skins:int = -1;
        private var diagram:BitmapData;
        private var skinsChanged:int = 0;

        public function FPS(){
            this.addEventListener(Event.ADDED_TO_STAGE, run);
        }
        private function run(_arg1:Event):void{
            var _local2:Bitmap;
            fps = new TextField();
            mem = new TextField();
            if (instance == null){
                mouseEnabled = false;
                mouseChildren = false;
                fps.defaultTextFormat = new TextFormat("Tahoma", 10, 4294967295);
                fps.autoSize = TextFieldAutoSize.LEFT;
                fps.text = ("FPS: " + Number(stage.frameRate).toFixed(2));
                fps.selectable = false;
                fps.x = (-(diagramWidth) - 2);
                addChild(fps);
                mem.defaultTextFormat = new TextFormat("Tahoma", 10, 0xCCCC00);
                mem.autoSize = TextFieldAutoSize.LEFT;
                mem.text = ("MEM: " + bytesToString(System.totalMemory));
                mem.selectable = false;
                mem.x = (-(diagramWidth) - 2);
                mem.y = 10;
                addChild(mem);
                currentY = 20;
                diagram = new BitmapData(diagramWidth, diagramHeight, true, 553648127);
                _local2 = new Bitmap(diagram);
                _local2.y = (currentY + 4);
                _local2.x = -(diagramWidth);
                addChildAt(_local2, 0);
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
                this.stage.addEventListener(Event.RESIZE, onResize);
                onResize();
                diagramTimer = getTimer();
                tfTimer = getTimer();
            };
        }
        private function onResize(_arg1:Event=null):void{
            var _local2:* = parent.globalToLocal(new Point(400, -3));
            x = _local2.x;
            y = _local2.y;
        }
        private function onEnterFrame(_arg1:Event):void{
            tfDelay++;
            if (tfDelay >= tfDelayMax){
                tfDelay = 0;
                fps.text = ("FPS: " + Number(((1000 * tfDelayMax) / (getTimer() - tfTimer))).toFixed(2));
                tfTimer = getTimer();
            };
            var _local2:* = (1000 / (getTimer() - diagramTimer));
            var _local3:* = ((_local2 > stage.frameRate)) ? 1 : (_local2 / stage.frameRate);
            diagramTimer = getTimer();
            diagram.scroll(1, 0);
            diagram.fillRect(new Rectangle(0, 0, 1, diagram.height), 553648127);
            diagram.setPixel32(0, (diagramHeight * (1 - _local3)), 4291611852);
            mem.text = ("MEM: " + bytesToString(System.totalMemory));
            var _local4:* = ((skins == 0)) ? 0 : (skinsChanged / skins);
            diagram.setPixel32(0, (diagramHeight * (1 - _local4)), 4294927872);
            var _local5:* = (System.totalMemory / maxMemory);
            diagram.setPixel32(0, (diagramHeight * (1 - _local5)), 4291611648);
        }
        private function bytesToString(_arg1:uint):String{
            var _local2:String;
            if (_arg1 < 0x0400){
                _local2 = (String(_arg1) + "b");
            } else {
                if (_arg1 < 0x2800){
                    _local2 = (Number((_arg1 / 0x0400)).toFixed(2) + "kb");
                } else {
                    if (_arg1 < 102400){
                        _local2 = (Number((_arg1 / 0x0400)).toFixed(1) + "kb");
                    } else {
                        if (_arg1 < 0x100000){
                            _local2 = (Math.round((_arg1 / 0x0400)) + "kb");
                        } else {
                            if (_arg1 < 0xA00000){
                                _local2 = (Number((_arg1 / 0x100000)).toFixed(2) + "mb");
                            } else {
                                if (_arg1 < 104857600){
                                    _local2 = (Number((_arg1 / 0x100000)).toFixed(1) + "mb");
                                } else {
                                    _local2 = (Math.round((_arg1 / 0x100000)) + "mb");
                                };
                            };
                        };
                    };
                };
            };
            return (_local2);
        }

    }
}//package Utils 
