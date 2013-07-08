//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.OhterUI.dragAndDrop {

    public class SourceData {

        private var data;
        private var name:String;

        public function SourceData(_arg1:String, _arg2){
            this.name = _arg1;
            this.data = _arg2;
        }
        public function getData(){
            return (this.data);
        }
        public function getName():String{
            return (this.name);
        }

    }
}//package GameUI.View.OhterUI.dragAndDrop 
