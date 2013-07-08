//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import flash.display.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;

    public class BuffItem extends FaceItem {

        private var _skillInfo:SkillInfo;

        public function BuffItem(_arg1:String, _arg2:DisplayObjectContainer=null, _arg3:String="bagIcon", _arg4:Number=1){
            super(_arg1, _arg2, _arg3, _arg4);
        }
        public function set skillInfo(_arg1:SkillInfo):void{
            _skillInfo = _arg1;
        }
        public function get skillInfo():SkillInfo{
            return (_skillInfo);
        }

    }
}//package GameUI.View.items 
