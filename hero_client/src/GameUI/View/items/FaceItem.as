//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import GameUI.ConstData.*;
    import GameUI.View.*;
    import GameUI.View.BaseUI.*;
    import Utils.*;
    import OopsEngine.Graphics.*;

    public class FaceItem extends ItemBase {

        public var icon:Bitmap;
        private var scale:Number;
        public var offsetPoint:Point;

        public function FaceItem(_arg1:String, _arg2:DisplayObjectContainer=null, _arg3:String="bagIcon", _arg4:Number=1, _arg5:Number=1){
            var _local7:BitmapData;
            var _local6:ItemTemplateInfo = (UIConstData.ItemDic[uint(_arg1)] as ItemTemplateInfo);
            if (_local6){
                _arg1 = ("" + _local6.img);
            };
            if (_arg5 > 1){
                tf = new TextField();
                tf.filters = OopsEngine.Graphics.Font.Stroke(0);
                tf.mouseEnabled = false;
                tf.selectable = false;
            };
            offsetPoint = new Point(2, 2);
            _local7 = new BitmapData(1, 1);
            this.icon = new Bitmap(_local7);
            this.addChildAt(this.icon, 0);
            this.scale = _arg4;
            this.graphics.beginFill(1, 0);
            this.graphics.drawRect(0, 0, 32, 32);
            this.graphics.endFill();
            super(_arg1, _arg2, _arg3);
        }
        override protected function onLoabdComplete():void{
            var _local1:*;
            this.removeChild(this.icon);
            if (mkDir == "face"){
                icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + this.iconName) + ".jpg"));
            } else {
                if (mkDir == "NPCPic"){
                    _local1 = ResourcesFactory.getInstance().getswfResourceByUrl((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + this.iconName) + ".swf"));
                    if (_local1 != null){
                        _local1.scaleX = scale;
                        _local1.scaleY = scale;
                        this.addChildAt(_local1, 0);
                        _local1.x = offsetPoint.x;
                        _local1.y = offsetPoint.y;
                        this.dispatchEvent(new Event(Event.COMPLETE));
                        super.onLoabdComplete();
                        return;
                    };
                    icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
                } else {
                    icon = ResourcesFactory.getInstance().getBitMapResourceByUrl((((((GameCommonData.GameInstance.Content.RootDirectory + "Resources/") + mkDir) + "/") + this.iconName) + ".png"));
                };
            };
            if (icon == null){
                icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmap("NoResource");
            };
            if (icon){
                icon.scaleX = scale;
                icon.scaleY = scale;
                this.addChildAt(icon, 0);
                icon.x = offsetPoint.x;
                icon.y = offsetPoint.y;
                this.dispatchEvent(new Event(Event.COMPLETE));
                super.onLoabdComplete();
            };
        }
        public function setTextPos(_arg1:uint, _arg2:uint):void{
            textX = _arg1;
            textY = _arg2;
            tf.x = _arg1;
            tf.y = _arg2;
        }
        public function setEnable(_arg1:Boolean):void{
            this.mouseChildren = _arg1;
            this.mouseEnabled = _arg1;
        }
        public function setNum(_arg1:uint):void{
            this.num = _arg1;
            tf.visible = true;
            tf.text = _arg1.toString();
            if (scale > 1){
                tf.x = (5 * scale);
            } else {
                tf.x = 5;
            };
            tf.y = ((HEIGHT - TXTHEIGHT) + 5);
            tf.setTextFormat(UIUtils.getTextFormat());
        }
        override public function set Num(_arg1:int):void{
            this.num = _arg1;
            tf.visible = true;
            tf.text = _arg1.toString();
            if (_arg1 <= 1){
                tf.visible = false;
            };
            if (scale > 1){
                tf.x = (5 * scale);
            } else {
                tf.x = 5;
            };
            tf.y = ((HEIGHT - TXTHEIGHT) + 5);
            tf.setTextFormat(UIUtils.getTextFormat());
        }

    }
}//package GameUI.View.items 
