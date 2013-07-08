//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.StartMediator {
    import flash.events.*;
    import flash.display.*;
    import GameUI.UICore.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.View.*;
    import GameUI.Modules.Login.Model.*;

    public class RoleCellView extends Sprite {

        private var bgView:MovieClip;
        private var _info:RoleVo;
        private var faceItem:FaceItem;
        private var _type:uint;
        private var idx:int;
        public var addMcSelected:Boolean;

        public function RoleCellView(_arg1:int){
            this.idx = _arg1;
            initView();
            addEvents();
        }
        public function addRoleHandler(_arg1:MouseEvent):void{
            if (addMcSelected){
                bgView.addMc.gotoAndStop(1);
            } else {
                bgView.addMc.gotoAndStop(2);
            };
            addMcSelected = !(addMcSelected);
            dispatchEvent(new Event("change_hfAddRole"));
        }
        public function dispose():void{
        }
        private function createRoleHandler(_arg1:MouseEvent):void{
            UIFacade.GetInstance().sendNotification(EventList.REMOVESELECTROLE);
            UIFacade.GetInstance().sendNotification(EventList.SHOWCREATEROLE, idx);
        }
        private function addEvents():void{
            bgView["roleItem"].addEventListener(MouseEvent.CLICK, selectRoleHandler);
            bgView["createBtn"].addEventListener(MouseEvent.CLICK, createRoleHandler);
            bgView["addMc"].addEventListener(MouseEvent.CLICK, addRoleHandler);
        }
        public function get info():RoleVo{
            return (this._info);
        }
        private function initView():void{
            bgView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrarySelectRole).GetClassByMovieClip("RoleCellAsset");
            addChild(bgView);
            bgView.addMc.buttonMode = true;
            bgView.addMc.gotoAndStop(1);
        }
        public function set selected(_arg1:Boolean):void{
            bgView["roleItem"].selectAsset.visible = _arg1;
        }
        private function selectRoleHandler(_arg1:MouseEvent):void{
            dispatchEvent(new Event(Event.SELECT));
        }
        public function set type(_arg1:uint):void{
            this._type = _arg1;
            if (_type == SelectRoleWindow.TYPE_HEFU){
                bgView.addMc.gotoAndStop(1);
                bgView.addMc.visible = true;
            } else {
                bgView.addMc.visible = false;
            };
        }
        public function set info(_arg1:RoleVo):void{
            var _local2:int;
            this._info = _arg1;
            if (this._info){
                bgView["roleItem"].visible = true;
                bgView["createBtn"].visible = false;
                bgView["createBtn"].mouseEnabled = false;
                bgView["roleItem"].selectAsset.visible = false;
                bgView["roleItem"].nameTF.text = info.Name;
                bgView["roleItem"].nameTF.mouseEnabled = false;
                bgView["roleItem"].levelTF.text = info.Level;
                bgView["roleItem"].levelTF.mouseEnabled = false;
                bgView["roleItem"].jobTF.text = GameCommonData.RolesListDic[info.Carrer];
                bgView["roleItem"].jobTF.mouseEnabled = false;
                faceItem = new FaceItem(String(info.Photo), bgView["roleItem"].mclook, "face");
                bgView["roleItem"].mclook.addChild(faceItem);
                bgView["roleItem"].mclook.mouseEnabled = false;
                if (info.BannedTime == 1){
                    bgView["roleItem"].filters = [ColorFilters.BlackGoundFilter];
                    bgView["roleItem"].baned = true;
                    while (_local2 < bgView["roleItem"].numChildren) {
                        if ((bgView["roleItem"].getChildAt(_local2) is SimpleButton)){
                            bgView["roleItem"].getChildAt(_local2).mouseEnabled = false;
                        };
                        _local2++;
                    };
                    bgView["roleItem"].nameTF.text = (info.Name + LanguageMgr.GetTranslation("(角色被封)"));
                };
                bgView["roleItem"].visible = true;
                bgView["createBtn"].visible = false;
            } else {
                bgView["roleItem"].visible = false;
                bgView["createBtn"].visible = true;
            };
        }

    }
}//package GameUI.Modules.Login.StartMediator 
