//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Unity.Data {
    import Net.*;

    public class GuildInfo {

        public var BuildValue:int;
        public var IsApply:Boolean;
        public var ChairmanName:String = "";
        public var GuildId:int;
        public var Placard:String = "";
        public var BuildDate:String = "";
        public var Description:String;
        public var Level:int;
        public var CreatorID:int;
        public var ChairmanJob:int;
        public var MaxCount:int;
        public var Count:int;
        public var ChairmanID:int;
        public var CreatorName:String = "";
        public var GuildName:String = "";

        public function ReadFromNetPacket(_arg1:NetPacket):void{
            GuildId = _arg1.readUnsignedInt();
            ChairmanJob = _arg1.readUnsignedInt();
            BuildDate = _arg1.ReadString();
            ChairmanID = _arg1.readUnsignedInt();
            ChairmanName = _arg1.ReadString();
            GuildName = _arg1.ReadString();
            CreatorID = _arg1.readUnsignedInt();
            Description = _arg1.ReadString();
            Level = _arg1.readUnsignedInt();
            MaxCount = _arg1.readUnsignedInt();
            Count = _arg1.readUnsignedInt();
            Placard = _arg1.ReadString();
            BuildValue = _arg1.readUnsignedInt();
            IsApply = _arg1.readBoolean();
        }

    }
}//package GameUI.Modules.Unity.Data 
