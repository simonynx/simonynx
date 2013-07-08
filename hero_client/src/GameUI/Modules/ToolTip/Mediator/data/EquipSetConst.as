//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.ToolTip.Mediator.data {
    import flash.utils.*;
    import Utils.*;
    import GameUI.Modules.ToolTip.Mediator.VO.*;

    public class EquipSetConst {

        public static var EquipSetLocList:Dictionary = new Dictionary();
        public static var EquipSetIdList:Dictionary = new Dictionary();
        public static var EquipInfoList:Dictionary = new Dictionary();

        public static function GetEquipSetFromFile(_arg1:ByteArray):void{
            var _local3:uint;
            var _local4:EquipSetInfo;
            var _local5:int;
            var _local6:int;
            _arg1.endian = "littleEndian";
            var _local2:uint = _arg1.readUnsignedInt();
            while (_local3 < _local2) {
                _local4 = new EquipSetInfo();
                _local4.setId = _arg1.readUnsignedInt();
                _local4.setName = UIUtils.ReadString(_arg1);
                _local5 = _arg1.readUnsignedInt();
                _local6 = 1;
                while (_local6 <= _local5) {
                    _local4.collectInfoList[_local6] = [_arg1.readUnsignedInt(), _arg1.readUnsignedInt(), _arg1.readUnsignedInt()];
                    _local6++;
                };
                EquipInfoList[_local4.setId] = _local4;
                _local3++;
            };
        }

    }
}//package GameUI.Modules.ToolTip.Mediator.data 
