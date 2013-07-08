//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Buff.view {
    import flash.display.*;
    import GameUI.UICore.*;
    import OopsEngine.Skill.*;
    import GameUI.ConstData.*;

    public class BuffListView extends Sprite {

        private var list:Array;
        private var type:int;

        public function BuffListView(_arg1:int){
            this.type = _arg1;
            init();
        }
        public function addItem(_arg1:GameSkillBuff):void{
            var _local2:BuffCell = new BuffCell(_arg1);
            this.addChild(_local2);
            list.push(_local2);
            setListPos();
        }
        public function clearAllItem():void{
            var _local1:BuffCell;
            for each (_local1 in list) {
                this.removeChild(_local1);
            };
            list = [];
        }
        public function update():void{
            var _local1:BuffCell;
            var _local2:int = list.length;
            while (_local2 > 0) {
                _local2--;
                list[_local2].updateTime();
                if (list[_local2].theBuffTime == 0){
                    if (list[_local2].buffType == 306){
                        UIFacade.GetInstance().sendNotification(EventList.ATTACK_STOP);
                    };
                    if (type == 0){
                        GameCommonData.Player.Role.DelteBuff(list[_local2].buff);
                    } else {
                        GameCommonData.Player.Role.DelteDot(list[_local2].buff);
                    };
                    this.removeChild(list[_local2]);
                    list.splice(_local2, 1);
                    UIFacade.GetInstance().sendNotification(EventList.ALLROLEINFO_UPDATE, {
                        id:GameCommonData.Player.Role.Id,
                        type:1001
                    });
                    setListPos();
                };
            };
        }
        public function getList():Array{
            return (list);
        }
        private function init():void{
            list = [];
        }
        private function setListPos():void{
            var _local1:BuffCell;
            var _local2:int;
            for each (_local1 in list) {
                _local1.x = (-35 * _local2);
                _local2++;
            };
        }
        public function updateItem(_arg1:GameSkillBuff):void{
            var _local2:BuffCell;
            for each (_local2 in list) {
                if (_local2.buffType == _arg1.TypeID){
                    _local2.theBuffTime = _arg1.BuffTime;
                    return;
                };
            };
        }
        public function deleteItem(_arg1:GameSkillBuff):void{
            var _local2:BuffCell;
            var _local3:int;
            for each (_local2 in list) {
                if (_local2.buffType == _arg1.TypeID){
                    this.removeChild(_local2);
                    list.splice(_local3, 1);
                    setListPos();
                    return;
                };
                _local3++;
            };
        }

    }
}//package GameUI.Modules.Buff.view 
