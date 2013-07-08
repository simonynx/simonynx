//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.PetRace.Data {
    import GameUI.ConstData.*;
    import Net.*;

    public class PetRacingInfo {

        public var blood:Array;
        public var Winners:Array;
        public var entryid:Array;
        public var petName:Array;
        public var playerId:uint = 0;
        public var value0:Array;
        public var value1:Array;
        public var value2:Array;
        public var value3:Array;
        public var value4:Array;
        public var Level:uint = 0;
        public var value6:Array;
        public var value7:Array;
        public var TeamName:String = "队伍";
        public var value5:Array;
        public var MasterName:String = "";
        public var reportId:uint = 0;
        public var WinnerId:uint = 0;
        public var Face:uint = 0;

        public function PetRacingInfo(){
            entryid = [0, 0, 0];
            value0 = [0, 0, 0];
            blood = [0, 0, 0];
            value1 = [0, 0, 0];
            value2 = [0, 0, 0];
            value3 = [0, 0, 0];
            value4 = [0, 0, 0];
            value5 = [0, 0, 0];
            value6 = [0, 0, 0];
            value7 = [0, 0, 0];
            petName = ["", "", ""];
            Winners = [0, 0, 0];
            super();
        }
        public function ReadFromPacket(_arg1:NetPacket, _arg2:uint):void{
            resetValue();
            this.playerId = _arg2;
            Face = _arg1.readUnsignedInt();
            Level = _arg1.readUnsignedInt();
            MasterName = _arg1.ReadString();
            TeamName = _arg1.ReadString();
            var _local3:uint;
            _local3 = 0;
            while (_local3 < 3) {
                entryid[_local3] = _arg1.readUnsignedInt();
                if (entryid[_local3] > 0){
                    petName[_local3] = UIConstData.ItemDic[entryid[_local3]].Name;
                };
                if (entryid[_local3] > 0){
                    value0[_local3] = _arg1.readUnsignedInt();
                    value1[_local3] = _arg1.readUnsignedInt();
                    blood[_local3] = value1[_local3];
                    value2[_local3] = _arg1.readUnsignedInt();
                    value3[_local3] = _arg1.readUnsignedInt();
                    value4[_local3] = _arg1.readUnsignedInt();
                    value5[_local3] = _arg1.readUnsignedInt();
                    value6[_local3] = _arg1.readFloat();
                    value7[_local3] = _arg1.readFloat();
                };
                _local3++;
            };
        }
        public function resetValue():void{
            petName = ["", "", ""];
            blood = [0, 0, 0];
            value1 = [0, 0, 0];
        }
        public function ReadReportFromPacket(_arg1:NetPacket, _arg2:uint):void{
            entryid[_arg2] = _arg1.readUnsignedInt();
            if (entryid[_arg2] > 0){
                petName[_arg2] = UIConstData.ItemDic[entryid[_arg2]].Name;
            };
            if (entryid[_arg2] > 0){
                value0[_arg2] = _arg1.readUnsignedInt();
                value1[_arg2] = _arg1.readUnsignedInt();
                blood[_arg2] = _arg1.readUnsignedInt();
                value2[_arg2] = _arg1.readUnsignedInt();
                value3[_arg2] = _arg1.readUnsignedInt();
                value4[_arg2] = _arg1.readUnsignedInt();
                value5[_arg2] = _arg1.readUnsignedInt();
                value6[_arg2] = _arg1.readFloat();
                value7[_arg2] = _arg1.readFloat();
            };
        }

    }
}//package GameUI.Modules.PetRace.Data 
