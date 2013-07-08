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
    import GameUI.Modules.NewGuide.Data.*;
    import GameUI.Modules.Pet.Data.*;

    public class Guide_PetUpstarCommand extends SimpleCommand {

        public static const NAME:String = "Guide_PetUpstarCommand";

        private static var targetTemp:DisplayObject;
        private static var UPCNT:int = 5;

        override public function execute(_arg1:INotification):void{
            if (_arg1.getBody()){
                gideUI(int(_arg1.getBody()["step"]), _arg1.getBody()["data"]);
            };
        }
        public function gideUI(_arg1:int, _arg2:Object):void{
            var _local6:InventoryItemInfo;
            var _local7:DisplayObject;
            var _local3:Boolean;
            var _local4:int;
            var _local5:Boolean;
            while (_local4 < PetPropConstData.EQUIP_NUM) {
                if (RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local4)]]){
                    if ((RolePropDatas.ItemList[ItemConst[("EQUIPMENT_SLOT_PET" + _local4)]] as InventoryItemInfo).PetInfo.Start > 0){
                        _local3 = false;
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
                _local6 = BagData.AllItems[0][_local4];
                if (((_local6) && ((((_local6.MainClass == ItemConst.ITEM_CLASS_PET)) && ((_local6.SubClass == ItemConst.ITEM_SUBCLASS_PET_SELF)))))){
                    if (_local6.PetInfo.Start > 0){
                        _local3 = false;
                    };
                };
                _local4++;
            };
            switch (_arg1){
                case 1:
                    if (_local3 == false){
                        facade.removeCommand(Guide_PetUpstarCommand.NAME);
                    } else {
                        _local7 = ((facade.retrieveMediator(MainSceneMediator.NAME) as MainSceneMediator).getViewComponent() as MovieClip)["btn_2"].pet_btn;
                        JianTouMc.getInstance(JianTouMc.TYPE_PETUPSTAR).show(_local7, LanguageMgr.GetTranslation("点击打开宠物面板"), 3);
                    };
                    break;
                case 2:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETUPSTAR).show(_arg2["target"], LanguageMgr.GetTranslation("点击打开属性提升面板"), 3, _arg2["target"].getBounds(_arg2["target"].stage));
                    break;
                case 3:
                    targetTemp = _arg2["target"];
                    if (targetTemp){
                        JianTouMc.getInstance(JianTouMc.TYPE_PETUPSTAR).show(_arg2["target"], (((LanguageMgr.GetTranslation("提升攻击属性") + "(") + UPCNT) + ")"), 3, _arg2["target"].getBounds(_arg2["target"].stage));
                        UPCNT--;
                    };
                    if (UPCNT < 0){
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_SHUTDOWN);
                    };
                    break;
                case 4:
                    if (UPCNT > 0){
                        facade.sendNotification(Guide_PetUpstarCommand.NAME, {
                            step:3,
                            data:{target:targetTemp}
                        });
                    } else {
                        facade.sendNotification(NewGuideEvent.NEWPLAYER_GUILD_PETUPSTAR_SHUTDOWN);
                    };
                    break;
                case 5:
                    JianTouMc.getInstance(JianTouMc.TYPE_PETUPSTAR).close();
                    break;
            };
        }

    }
}//package GameUI.Modules.NewGuide.Command 
