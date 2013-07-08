//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Achieve.Data {

    public class TitleInfo {

        public var Id:int;
        public var Type:int;
        public var Name:String;

        public function get Color():uint{
            var _local1:uint;
            switch (Type){
                case 0:
                    _local1 = 1521501;
                    break;
                case 1:
                    _local1 = 0xFF0000;
                    break;
                case 2:
                    _local1 = 0xFC0066;
                    break;
                case 3:
                    _local1 = 45296;
                    break;
                case 4:
                    _local1 = 6310267;
                    break;
                case 5:
                    _local1 = 0xFFC000;
                    break;
                default:
                    _local1 = 0;
            };
            return (_local1);
        }

    }
}//package GameUI.Modules.Achieve.Data 
