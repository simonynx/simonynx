//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Activity.UI {
    import flash.display.*;
    import flash.text.*;
    import GameUI.View.items.*;

    public class AIAwardItem extends Sprite {

        private var fi:FaceItem;
        private var tf:TextField;
        private var itemArr:Array;
        private var isEnabled:Boolean;
        private var _item:MovieClip;

        public function AIAwardItem(){
            _item = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ActivityEveryAskItem");
            super();
            itemArr = [];
            _item.askRate.mouseEnabled = false;
            _item.geted.mouseEnabled = false;
            _item.geted.visible = false;
            addChild(_item);
        }
        public function set Geted(_arg1:Boolean):void{
            _item.geted.visible = _arg1;
        }
        public function getItemEnable():Boolean{
            return (isEnabled);
        }
        public function setText(_arg1:String):void{
            _item.askRate.text = _arg1;
        }
        public function setItemEnable(_arg1:Boolean):void{
            fi.otherEnable = _arg1;
            isEnabled = _arg1;
        }
        public function setAward(_arg1:Array):void{
            var _local2:Sprite;
            _local2 = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
            fi = new FaceItem(_arg1[0], _local2, "bagIcon", 1, 1);
            fi.Num = _arg1[1];
            fi.mouseChildren = false;
            fi.mouseEnabled = false;
            _local2.x = 7;
            _local2.y = 7;
            _local2.addChild(fi);
            this.addChild(_local2);
            _local2.name = ("target_" + _arg1[0]);
        }

    }
}//package GameUI.Modules.Activity.UI 
