//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PetRace.Data {
    import Net.*;

    public class PetReportInfo {

        public var WinnerFlag:Boolean;
        public var StartTime:uint;
        public var DefenseName:String;
        public var ReportId:uint;
        public var AttackName:String;
        public var typeStr:String = "";
        public var StageId:uint;
        public var Ref:PetReportRef;

        public function PetReportInfo():void{
        }
        public function ReadFromPacket(_arg1:NetPacket, _arg2:uint):void{
            ReportId = _arg1.readUnsignedInt();
            StartTime = _arg1.readUnsignedInt();
            AttackName = _arg1.ReadString();
            DefenseName = _arg1.ReadString();
            WinnerFlag = _arg1.readBoolean();
            StageId = _arg2;
            if (_arg2 == 0){
                typeStr = "积分赛";
            } else {
                typeStr = "淘汰赛";
            };
        }

    }
}//package GameUI.Modules.PetRace.Data 
