//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PlayerIcon.UI {
    import flash.display.*;

    public class CursorIcon extends Sprite {

        protected var cursorName:String;

        public function CursorIcon(_arg1:String){
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.cursorName = _arg1;
            if (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary) == null){
                return;
            };
            var _local2:BitmapData = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByBitmapData(_arg1);
            var _local3:Bitmap = new Bitmap();
            _local3.bitmapData = _local2;
            this.addChild(_local3);
        }
    }
}//package GameUI.Modules.PlayerIcon.UI 
