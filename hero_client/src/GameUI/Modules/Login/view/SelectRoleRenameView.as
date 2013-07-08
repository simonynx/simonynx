//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.view {
    import flash.events.*;
    import flash.display.*;
    import GameUI.View.HButton.*;
    import GameUI.View.BaseUI.*;
    import GameUI.Modules.Login.Model.*;
    import Utils.*;
    import Net.RequestSend.*;

    public class SelectRoleRenameView extends HFrame {

        public static var RenameGuid:uint;

        private var bg:MovieClip;
        private var _info:RoleVo;
        private var renameBtn:HLabelButton;

        public function SelectRoleRenameView(){
            initView();
            addEvents();
        }
        private function __renameHandler(_arg1:MouseEvent):void{
            var _local2:String = bg.tf_newName.text;
            if (_local2.length < 2){
                HAlertDialog.show(LanguageMgr.GetTranslation("提示"), LanguageMgr.GetTranslation("角色名必须是2~8字符"));
                return;
            };
            if (((!(UIUtils.isPermitedName(_local2))) || (!(UIUtils.legalRoleName(_local2))))){
                HAlertDialog.show(LanguageMgr.GetTranslation("提示"), LanguageMgr.GetTranslation("角色姓名不合法"));
                return;
            };
            RenameGuid = info.UserId;
            CharacterSend.CharRename(info.UserId, _local2);
            renameBtn.enable = false;
        }
        private function initView():void{
            setSize(300, 190);
            titleText = LanguageMgr.GetTranslation("角色名修改");
            centerTitle = true;
            bg = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole).GetClassByMovieClip("RenameAssets");
            bg.x = 8;
            bg.y = 28;
            addContent(bg);
            renameBtn = new HLabelButton();
            renameBtn.label = LanguageMgr.GetTranslation("修改");
            renameBtn.x = 118;
            renameBtn.y = 130;
            bg.addChild(renameBtn);
            bg.tf_newName.maxChars = 8;
            bg.tf_newName.text = "";
            bg.tf_newName.multiline = false;
            RenameGuid = 0;
        }
        public function get info():RoleVo{
            return (this._info);
        }
        private function addEvents():void{
            renameBtn.addEventListener(MouseEvent.CLICK, __renameHandler);
        }
        public function set info(_arg1:RoleVo):void{
            this._info = _arg1;
            bg.tf_tips.htmlText = LanguageMgr.GetTranslation("提示角色名已存在", _arg1.Name);
            bg.tf_newName.text = "";
            RenameGuid = 0;
            renameBtn.enable = true;
        }

    }
}//package GameUI.Modules.Login.view 
