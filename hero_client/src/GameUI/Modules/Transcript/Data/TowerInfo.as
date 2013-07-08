//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Transcript.Data {

    public class TowerInfo {

        public static var HoleX:int;
        public static var HoleY:int;
        public static var Info:TowerInfo;

        public var money:int;
        public var mapId:String;
        public var playerY:int;
        public var mapIdArr:Array;
        public var playerX:int;
        public var npcY:int;
        public var holeY:int;
        public var id:int;
        public var npcX:int;
        public var holeX:int;

        public function setMapArr():void{
            mapIdArr = [];
            mapIdArr = mapId.split(",");
        }

    }
}//package GameUI.Modules.Transcript.Data 
