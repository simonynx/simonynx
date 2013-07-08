//Created by Action Script Viewer - http://www.buraks.com/asv
package Utils {
    import OopsEngine.Utils.*;

    public class XmlUtils {

        public static function CreateModelOffsetMount():void{
            var _local1:XML;
            var _local2:XML = GameCommonData.GameInstance.Content.Load(GameConfigData.ModelOffsetMount).GetXML();
            for each (_local1 in _local2.M) {
                GameCommonData.ModelOffsetMount[_local1.@Id.toString()] = _local1;
            };
        }
        public static function CreateModelOffsetPlayer():void{
            var _local1:XML;
            var _local2:ModelOffset;
            var _local3:XML = GameCommonData.GameInstance.Content.Load(GameConfigData.ModelOffsetPlayer).GetXML();
            for each (_local1 in _local3.P) {
                _local2 = new ModelOffset();
                _local2.Id = uint(_local1.@Id);
                _local2.X = int(_local1.@X);
                _local2.Y = int(_local1.@Y);
                _local2.H = int(_local1.@H);
                _local2.avatar = String(_local1.@avatar);
                _local2.noseeWeapon = int(_local1.@noseeWeapon);
                GameCommonData.ModelOffsetPlayer[_local1.@Id.toString()] = _local2;
            };
        }
        public static function createXml():void{
            CreateModelOffsetPlayer();
            CreateModelOffsetNpcEnemy();
            CreateMapTree();
        }
        public static function CreateMapTree():void{
            var _local1:XML;
            var _local2:XML = GameCommonData.GameInstance.Content.Load(GameConfigData.MapTree).GetXML();
            for each (_local1 in _local2.Map) {
                GameCommonData.MapTree[_local1.@Id.toString()] = _local1.@NodeList.toString();
            };
        }
        public static function CreateModelOffsetNpcEnemy():void{
            var _local1:XML;
            var _local2:ModelOffset;
            var _local3:XML = GameCommonData.GameInstance.Content.Load(GameConfigData.ModelOffsetNpcEnemy).GetXML();
            for each (_local1 in _local3.E) {
                _local2 = new ModelOffset();
                _local2.Id = uint(_local1.@Id);
                _local2.Swf = String(_local1.@Swf);
                _local2.X = int(_local1.@X);
                _local2.Y = int(_local1.@Y);
                _local2.H = int(_local1.@H);
                _local2.Title = String(_local1.@Title);
                _local2.frameRate = int(_local1.@frameRate);
                _local2.frameRate1 = int(_local1.@frameRate1);
                _local2.NotTurn = int(_local1.@NotTurn);
                GameCommonData.ModelOffsetNpcEnemy[_local2.Id] = _local2;
            };
            GameCommonData.GameInstance.Content.UnLoad(GameConfigData.ModelOffsetNpcEnemy);
        }

    }
}//package Utils 
