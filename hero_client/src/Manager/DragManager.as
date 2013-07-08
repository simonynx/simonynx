//Created by Action Script Viewer - http://www.buraks.com/asv
package Manager {
    import flash.display.*;

    public class DragManager {

        private static var dragItem:Sprite;

        public static function get DragItem():Sprite{
            if (dragItem == null){
                dragItem = new Sprite();
            };
            while (dragItem.numChildren) {
                dragItem.removeChildAt(0);
            };
            return (dragItem);
        }

    }
}//package Manager 
