//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Verification.Mediator {
    import org.puremvc.as3.multicore.interfaces.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.Verification.Proxy.*;
    import GameUI.Modules.Verification.Data.*;

    public class VerificationMediator extends Mediator {

        public static const NAME:String = "VerificationMediator";

        public function VerificationMediator(){
            super(NAME);
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, EventList.ENTERMAPCOMPLETE]);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    facade.registerMediator(new VerificationUIMediator());
                    break;
                case EventList.ENTERMAPCOMPLETE:
                    if (VerificationData.TimeLimitFlag == VerificationData.TIME_LIMIT_NEED_RECHARGE){
                        facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW3, {type:VerificationData.TimeLimitFlag});
                    } else {
                        if (VerificationData.VerificationType == VerificationData.ANTIWALLOW_CN){
                            if (!VerificationData.HasVerify){
                                facade.sendNotification(VerificationEvent.SHOW_VERIFICATION_VIEW1);
                            } else {
                                if (!VerificationData.VerifiySucess){
                                    facade.sendNotification(EventList.SHOWALERT, {
                                        comfrim:sure,
                                        cancel:null,
                                        isShowClose:false,
                                        info:LanguageMgr.GetTranslation("未成年玩家限时句"),
                                        title:LanguageMgr.GetTranslation("警 告"),
                                        comfirmTxt:LanguageMgr.GetTranslation("确定"),
                                        cancelTxt:LanguageMgr.GetTranslation("取消")
                                    });
                                };
                            };
                        };
                    };
                    break;
            };
        }
        private function sure():void{
        }

    }
}//package GameUI.Modules.Verification.Mediator 
