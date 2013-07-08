//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.MainScene.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import flash.utils.*;
    import GameUI.ConstData.*;
    import GameUI.View.items.*;
    import GameUI.Proxy.*;
    import GameUI.Modules.MainScene.Data.*;
    import GameUI.Modules.HeroSkill.View.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.AutoPlay.mediator.*;
    import GameUI.Modules.Bag.Command.*;

    public class ItemCdCommand extends SimpleCommand {

        private const SKILL_TYPE:int = 0;
        private const BAG_TYPE:int = 1;

        private function setGuildSkillCd(_arg1:Object):void{
            var _local2:UseItem;
            var _local3:NewSkillCell;
            _local3 = QuickBarData.getInstance().getGuildSkillItemById(_arg1.magicid);
            if (_local3){
                this.startUseItemCd(_local3, _arg1.privateTotalCdTime, (240 - ((_arg1.privateCdTime / _arg1.privateTotalCdTime) * 360)));
            };
        }
        private function setMedicinalCd():void{
            var _local1:GridUnit;
            var _local2:UseItem;
            var _local3:Array;
            var _local4:Array;
            for each (_local1 in BagData.GridUnitList[0]) {
                if (_local1.Item){
                    _local2 = _local1.Item;
                    if (ItemConst.IsMedicalExceptBAG(_local2.itemIemplateInfo)){
                        startUseItemCd(_local2, 1000);
                    };
                };
            };
            _local3 = QuickBarData.getInstance().getQuickUseItemByCd();
            for each (_local2 in _local3) {
                this.startUseItemCd(_local2, 1000);
            };
            _local4 = this.getItemsFromAutoPlay();
            for each (_local2 in _local4) {
                this.startUseItemCd(_local2, 1000);
            };
        }
        private function setPrivateCd(_arg1):void{
            var _local2:UseItem;
            var _local3:Array;
            var _local4:NewSkillCell;
            var _local5:Object = _arg1;
            if (_local5.infotype == BAG_TYPE){
            } else {
                _local3 = QuickBarData.getInstance().getSameSkillItemById(_local5.magicid);
                for each (_local4 in _local3[0]) {
                    this.startUseItemCd(_local4, _local5.privateTotalCdTime, (240 - ((_local5.privateCdTime / _local5.privateTotalCdTime) * 360)));
                };
            };
        }
        private function setPublicCd(_arg1:int):void{
            var _local3:NewSkillCell;
            var _local2:Array = QuickBarData.getInstance().getSkillItemByNoCd();
            for each (_local3 in _local2) {
                this.startUseItemCd(_local3, _arg1, -120);
            };
        }
        private function getItemsFromAutoPlay():Array{
            var _local2:UseItem;
            var _local1:AutoPlayMediator = (facade.retrieveMediator(AutoPlayMediator.NAME) as AutoPlayMediator);
            var _local3:Array = [];
            for each (_local2 in _local1.dataDic) {
                if (_local2 != null){
                    if (ItemConst.IsMedicalExceptBAG(_local2.itemIemplateInfo)){
                        _local3.push(_local2);
                    };
                };
            };
            return (_local3);
        }
        private function startUseItemCd(_arg1:Sprite, _arg2:uint, _arg3:int=-120):void{
            if ((_arg1 is UseItem)){
                (_arg1 as UseItem).startCd(_arg2, _arg3);
            };
            if ((_arg1 is NewSkillCell)){
                (_arg1 as NewSkillCell).startCd(_arg2, _arg3);
            };
        }
        override public function execute(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.RECEIVE_COOLDOWN_MSG:
                    setPrivateCd(_arg1.getBody());
                    break;
                case EventList.RECEIVE_CD_PUBLIC_MSG:
                    setPublicCd(int(_arg1.getBody()));
                    break;
                case EventList.RECEIVE_CD_MEDICINAL:
                    setMedicinalCd();
                    break;
                case EventList.RECEIVE_CD_GUILDSKILL:
                    setGuildSkillCd(_arg1.getBody());
                    break;
            };
        }

    }
}//package GameUI.Modules.MainScene.Command 
