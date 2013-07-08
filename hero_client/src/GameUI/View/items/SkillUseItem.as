//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View.items {
    import GameUI.Modules.HeroSkill.View.*;

    public class SkillUseItem extends NewSkillCell {

        private var _itemIndex:int;

        public function SkillUseItem(_arg1:int=0){
            _itemIndex = _arg1;
            super();
        }
        public function set itemIndex(_arg1:int){
            _itemIndex = _arg1;
        }
        public function get itemIndex():int{
            return (_itemIndex);
        }

    }
}//package GameUI.View.items 
