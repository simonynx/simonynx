//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.AutoPlay.Data {
    import flash.utils.*;
    import Utils.*;

    public class AutoFbInfo {

        public var countArr:Array;
        public var mapId:int;
        public var posYArr:Array;
        public var posXArr:Array;

        public function ReadFromPacket(_arg1:ByteArray){
            mapId = _arg1.readInt();
            posXArr = UIUtils.ReadString(_arg1).split(",");
            posYArr = UIUtils.ReadString(_arg1).split(",");
            countArr = UIUtils.ReadString(_arg1).split(",");
            if (!GameCommonData.autoListDic[mapId]){
                GameCommonData.autoListDic[mapId] = this;
            };
        }

    }
}//package GameUI.Modules.AutoPlay.Data 
