//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Roll.View {
    import flash.display.*;
    import GameUI.Modules.Roll.Data.*;

    public class RollListView extends Sprite {

        private var listArr:Array;

        public function RollListView(){
            listArr = [];
            super();
        }
        public function UpdatePosition():void{
            var _local1:int;
            while (_local1 < listArr.length) {
                listArr[_local1].y = ((40 * _local1) + 2);
                _local1++;
            };
            if ((((listArr.length == 0)) && (this.parent))){
                this.parent.removeChild(this);
            };
        }
        public function addItem(_arg1:RollInfo, _arg2:Boolean=true):void{
            var _local3:RollItemView = new RollItemView();
            _local3.setItemInfo(_arg1);
            this.addChild(_local3);
            listArr.push(_local3);
            if (_arg2){
                UpdatePosition();
            };
        }
        public function deleteItem(_arg1:int, _arg2:Boolean=true):void{
            var _local3:int;
            while (_local3 < listArr.length) {
                if ((listArr[_local3] as RollItemView).getRollInfo().index == _arg1){
                    (listArr[_local3] as RollItemView).dispose();
                    listArr.splice(_local3, 1);
                    break;
                };
                _local3++;
            };
            if (_arg2){
                UpdatePosition();
            };
        }

    }
}//package GameUI.Modules.Roll.View 
