//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.HeroSkill.View {
    import flash.events.*;
    import flash.display.*;
    import GameUI.Modules.HeroSkill.SkillConst.*;
    import Manager.*;
    import GameUI.View.HButton.*;
    import GameUI.Modules.AutoPlay.Data.*;

    public class SKillCellPanel extends Sprite {

        private var cell:NewSkillCell;
        private var bg:MovieClip;
        private var AutoSkillBox:HCheckBox;
        private var _info:SkillInfo;

        public function SKillCellPanel(){
            init();
            initEvent();
            super();
        }
        private function setAutoSkill(_arg1:Event):void{
            if (AutoSkillBox.selected){
                if (AutoPlayData.CommonSkillList[_info.TypeID] == null){
                    AutoPlayData.CommonSkillList[_info.TypeID] = _info;
                    AutoPlayData.AutoCommonSkillIdList[_info.TypeID] = true;
                    SharedManager.getInstance().SetSkillAutoInfo(true, _info.TypeID.toString());
                };
            } else {
                if (AutoPlayData.CommonSkillList[_info.TypeID] != null){
                    delete AutoPlayData.CommonSkillList[_info.TypeID];
                    AutoPlayData.AutoCommonSkillIdList[_info.TypeID] = false;
                    SharedManager.getInstance().SetSkillAutoInfo(false, _info.TypeID.toString());
                };
            };
        }
        public function get info():SkillInfo{
            return (_info);
        }
        private function init():void{
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SkillCellPanelAsset");
            this.addChild(bg);
            this.bg.skillName.mouseEnabled = false;
            this.bg.level.mouseEnabled = false;
            this.bg.needLevel.mouseEnabled = false;
            this.bg.skillType.mouseEnabled = false;
            cell = new NewSkillCell();
            this.bg.skillIcon.addChild(cell);
            cell.x = 1;
            AutoSkillBox = new HCheckBox("");
            AutoSkillBox.fireAuto = true;
            AutoSkillBox.x = 122;
            AutoSkillBox.y = 24;
            this.bg.addChild(AutoSkillBox);
        }
        private function initEvent():void{
            AutoSkillBox.addEventListener(Event.CHANGE, setAutoSkill);
        }
        public function set info(_arg1:SkillInfo):void{
            var _local2:Boolean;
            _info = _arg1;
            this.cell.setLearnSkillInfo(_info);
            this.bg.skillName.text = _info.Name;
            this.bg.level.text = ("Lv:" + _info.Level);
            if (this.cell.isLearn == false){
                this.bg.level.text = LanguageMgr.GetTranslation("未学习");
                this.AutoSkillBox.enable = false;
                this.AutoSkillBox.tips = LanguageMgr.GetTranslation("尚未学习无法选择");
            } else {
                this.AutoSkillBox.tips = LanguageMgr.GetTranslation("挂机自动使用该技能");
                this.AutoSkillBox.enable = true;
            };
            this.bg.needLevel.text = _info.NeedLevel;
            if (_info.Type == 2){
                this.bg.skillType.visible = true;
                this.AutoSkillBox.visible = false;
            } else {
                this.bg.skillType.visible = false;
                if ((((_info.Job == 9)) && ((((((_info.Id == 900201)) || ((_info.Id == 900401)))) || ((_info.Id == 900601)))))){
                    this.AutoSkillBox.visible = false;
                } else {
                    this.AutoSkillBox.visible = true;
                };
            };
            if ((((this.AutoSkillBox.enable == true)) && ((this.AutoSkillBox.visible == true)))){
                _local2 = SharedManager.getInstance().GetSkillAutoInfo(_info.TypeID.toString());
                AutoSkillBox.selected = _local2;
                AutoPlayData.AutoCommonSkillIdList[_info.TypeID] = _local2;
                if (_local2){
                    AutoPlayData.CommonSkillList[_info.TypeID] = _info;
                } else {
                    if (AutoPlayData.CommonSkillList[_info.TypeID] != null){
                        delete AutoPlayData.CommonSkillList[_info.TypeID];
                    };
                };
            };
        }

    }
}//package GameUI.Modules.HeroSkill.View 
