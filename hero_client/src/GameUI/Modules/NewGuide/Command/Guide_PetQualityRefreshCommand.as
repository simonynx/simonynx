//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NewGuide.Command {
    import flash.display.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import GameUI.Modules.NewGuide.Mediator.*;
    import GameUI.Modules.Bag.Proxy.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    import GameUI.Modules.MainScene.Mediator.*;
    import GameUI.Modules.RoleProperty.Datas.*;
    import GameUI.Modules.Pet.Data.*;

    public class Guide_PetQualityRefreshCommand extends SimpleCommand {

        public static const NAME:String = "Guide_PetQualityRefreshCommand";

        override public function execute(_arg1:INotification):void{
            if (_arg1.getBody()){
                gideUI(int(_arg1.getBody()["step"]), _arg1.getBody()["data"]);
            };
        }
        public function gideUI(_arg1:int, _arg2:Object):void{
            var _local6:*;
            var _local7:InventoryItemInfo;
            var _local8:DisplayObject;
            var _local3:Boolean;
            var _local4:* = 0;
            var _local5:Boolean;
            while (_local4 < PetPropConstData.EQUIP_NUM) {
                if (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local4)]]){
                    _local6 = 0;
                    while (_local6 < RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local4)]].PetInfo.UpgradeValue.length) {
                        if (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local4)]].PetInfo.UpgradeValue[_local6] != 0){
                            _local3 = false;
                        };
                        _local6++;
                    };
                    _local5 = true;
                };
                _local4++;
            };
            if (_local5 == false){
                _local3 = false;
            };
            _local4 = 0;
            while (_local4 < BagData.AllItems[0].length) {
                _local7 = BagData.AllItems[0][_local4];
                if (((_local7) && ((((_local7.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_local7.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))){
                    _local6 = 0;
                    while (_local6 < _local7.PetInfo.UpgradeValue.length) {
                        if (_local7.PetInfo.UpgradeValue[_local6] != 0){
                            _local3 = false;
                        };
                        _local6++;
                    };
                };
                _local4++;
            };
            switch (_arg1){
                case 1:
                    if (_local3 == false){
                        facade.removeCommand(Guide_PetQualityRefreshCommand.NAME);
                    } else {
                        _local8 = ((facade.retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_2"].pet_btn;
                        JianTouMc.getInstance(JianTouMc.TYPE_PETREQUALITY).show(_local8, LanguageMgr.GetTranslation("点击打开宠物面板"), 3);
                    };
                    break;
                case 2:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETREQUALITY).show(_arg2["target"], LanguageMgr.GetTranslation("点击打开资质面板"), 3, _arg2["target"].getBounds(_arg2["target"].stage));
                    break;
                case 3:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETREQUALITY).show(_arg2["target"], LanguageMgr.GetTranslation("点击刷新资质"), 3, _arg2["target"].getBounds(_arg2["target"].stage));
                    break;
                case 4:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETREQUALITY).show(_arg2["target"], LanguageMgr.GetTranslation("点击替换"), 3, _arg2["target"].getBounds(_arg2["target"].stage));
                    break;
                case 5:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETREQUALITY).close();
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
