//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PetRace.Data {
    import Net.*;

    public class PetReportRef {

        public var SeasonId:int;
        public var list:Array;

        public function PetReportRef(){
            list = [];
            super();
        }
        public function isRecordExist(_arg1:uint):Boolean{
            var _local3:PetReportInfo;
            var _local2:uint;
            _local2 = 0;
            while (_local2 < list.length) {
                _local3 = list[_local2];
                if (_local3.ReportId == _arg1){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function ReadFromPacket(_arg1:NetPacket, _arg2:uint):void{
            var _local6:PetReportInfo;
            SeasonId = _arg2;
            var _local3:uint = _arg1.readUnsignedInt();
            var _local4:uint = _arg1.readUnsignedInt();
            var _local5:uint;
            _local5 = 0;
            while (_local5 < _local4) {
                _local6 = new PetReportInfo();
                _local6.ReadFromPacket(_arg1, _local3);
                _local6.Ref = this;
                if (isRecordExist(_local6.ReportId)){
                    trace("该记录已存在");
                } else {
                    list.push(_local6);
                };
                _local5++;
            };
            PetRaceConstData.TOTAL_REPORT_NUM = list.length;
        }

    }
}//package GameUI.Modules.PetRace.Data 
