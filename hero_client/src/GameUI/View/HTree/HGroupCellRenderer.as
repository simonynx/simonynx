//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.HTree {
    import flash.display.*;
    import flash.text.*;
    import flash.filters.*;
    import GameUI.View.Components.*;
    import OopsEngine.Graphics.*;

    public class HGroupCellRenderer extends UISprite {

        private var icon:MovieClip;
        private var isExpand:Boolean;
        private var textFormat:TextFormat;
        private var desTf:TextField;
        private var textSize:int;
        private var des:String;
        private var type:uint;

        public function HGroupCellRenderer(_arg1:String, _arg2:int, _arg3:uint, _arg4:Boolean=false){
            this.des = _arg1;
            this.textSize = _arg2;
            this.type = _arg3;
            this.isExpand = _arg4;
            this.cacheAsBitmap = true;
            textFormat = new TextFormat();
            textFormat.size = _arg2;
            this.createChildren();
        }
        public function Update():void{
        }
        public function get DesTf():TextField{
            return (desTf);
        }
        protected function doLayout():void{
            this.width = 214;
            this.height = 16;
            this.icon.width = 13;
            this.icon.height = 13;
            this.icon.x = 5;
            this.icon.y = 3;
            this.desTf.x = 25;
        }
        protected function createChildren():void{
            this.desTf = new TextField();
            this.desTf.filters = OopsEngine.Graphics.Font.Stroke();
            this.desTf.autoSize = TextFieldAutoSize.LEFT;
            this.desTf.type = TextFieldType.DYNAMIC;
            this.desTf.selectable = false;
            this.desTf.textColor = 16770049;
            this.desTf.defaultTextFormat = textFormat;
            this.desTf.text = this.des;
            this.addChild(this.desTf);
            this.desTf.filters = [new GlowFilter(0, 1)];
            if (isExpand){
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("expand");
            } else {
                this.icon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("unExpand");
            };
            icon.name = "icon";
            icon.buttonMode = true;
            this.addChild(this.icon);
            this.doLayout();
        }

    }
}//package GameUI.View.HTree 
