//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.SetView.Mediator {
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import Manager.*;
    import GameUI.ConstData.*;
    import GameUI.Proxy.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    import GameUI.Modules.SetView.Data.*;

    public class SetViewMediator extends Mediator {

        public static const NAME:String = "SetViewMediator";

        private var _oldShowSelfBlood:Boolean;
        private var _oldSoundVolumn:Number;
        private var _oldShowBI:Boolean;
        private var _oldAllowSound:Boolean;
        private var _oldShowGuildName:Boolean;
        private var _oldMusicVolumn:Number;
        private var _oldAllowMusic:Boolean;
        private var _oldShowOtherBlood:Boolean;
        private var _oldShowPlayerTitle:Boolean;
        private var dataProxy:DataProxy;
        private var _oldShowTI:Boolean;
        private var _oldAllowPK:Boolean;
        private var _oldShowSkillEffect:Boolean;

        public function SetViewMediator(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
        }
        private function removeEvents():void{
            view.defaultBtn.removeEventListener(MouseEvent.CLICK, __defaultHandler);
            view.saveBtn.removeEventListener(MouseEvent.CLICK, __saveHandler);
            view.musicHcb.removeEventListener(Event.CHANGE, __changeHandler);
            view.soundHcb.removeEventListener(Event.CHANGE, __changeHandler);
        }
        private function __musicSliderHandler(_arg1:Event):void{
            SharedManager.getInstance().musicVolumn = view.musicSlide.value;
            GameCommonData.GameInstance.GameScene.GetGameScene.SetVolume(_oldMusicVolumn);
        }
        override public function handleNotification(_arg1:INotification):void{
            switch (_arg1.getName()){
                case EventList.INITVIEW:
                    setViewComponent(new SetViewWindow());
                    view.closeFun = closePnael;
                    view.page = 0;
                    dataProxy = (facade.retrieveProxy(DataProxy.NAME) as DataProxy);
                    break;
                case SetViewEvent.SHOW_SETVIEW:
                    initSelect();
                    addEvents();
                    dataProxy.SetviewIsOpen = true;
                    view.x = ((GameCommonData.GameInstance.ScreenWidth - view.width) / 2);
                    view.y = ((GameCommonData.GameInstance.ScreenHeight - view.height) / 2);
                    GameCommonData.GameInstance.GameUI.addChild(view);
                    break;
                case SetViewEvent.HIDE_SETVIEW:
                    removeEvents();
                    dataProxy.SetviewIsOpen = false;
                    if (view.parent){
                        view.close();
                    };
                    GameCommonData.GameInstance.stage.focus = GameCommonData.GameInstance.stage;
                    break;
                case SetViewEvent.ALLSOUND_ALLOW:
                    SharedManager.getInstance().allowMusic = true;
                    SharedManager.getInstance().allowSound = true;
                    initSelect();
                    SharedManager.getInstance().save();
                    break;
                case SetViewEvent.ALLSOUND_FORBID:
                    SharedManager.getInstance().allowMusic = false;
                    SharedManager.getInstance().allowSound = false;
                    initSelect();
                    SharedManager.getInstance().save();
                    break;
            };
        }
        private function set allowSound(_arg1:Boolean):void{
            if (SharedManager.getInstance().allowSound != _arg1){
                SharedManager.getInstance().allowSound = _arg1;
            };
        }
        private function addEvents():void{
            view.page_0.addEventListener(MouseEvent.CLICK, __pageHandler);
            view.page_1.addEventListener(MouseEvent.CLICK, __pageHandler);
            view.defaultBtn.addEventListener(MouseEvent.CLICK, __defaultHandler);
            view.saveBtn.addEventListener(MouseEvent.CLICK, __saveHandler);
            view.musicHcb.addEventListener(Event.CHANGE, __changeHandler);
            view.soundHcb.addEventListener(Event.CHANGE, __changeHandler);
        }
        private function __pageHandler(_arg1:MouseEvent):void{
            var _local2:int = _arg1.currentTarget.name.split("_")[1];
            if (view.page != _local2){
                SoundManager.getInstance().playLoadSound(GameConfigData.GameCommonAudio, "toggleBtnSound");
                view.page = _local2;
            };
        }
        private function __soundSliderHandler(_arg1:Event):void{
            SharedManager.getInstance().soundVolumn = view.soundSlide.value;
        }
        private function closePnael():void{
            __defaultHandler(null);
            sendNotification(SetViewEvent.HIDE_SETVIEW);
        }
        private function __changeHandler(_arg1:Event):void{
            this.allowMusic = view.musicHcb.selected;
            this.allowSound = view.soundHcb.selected;
        }
        public function get view():SetViewWindow{
            return ((getViewComponent() as SetViewWindow));
        }
        override public function listNotificationInterests():Array{
            return ([EventList.INITVIEW, SetViewEvent.SHOW_SETVIEW, SetViewEvent.HIDE_SETVIEW, SetViewEvent.ALLSOUND_ALLOW, SetViewEvent.ALLSOUND_FORBID]);
        }
        private function __defaultHandler(_arg1:MouseEvent):void{
            view.refusedTeamInvateHcb.selected = !(_oldShowTI);
            view.refusedBusinessHcb.selected = !(_oldShowBI);
            view.refusedPkHcb.selected = !(_oldAllowPK);
            view.refusedEffect.selected = !(_oldShowSkillEffect);
            view.shieldGuildNameHcb.selected = !(_oldShowGuildName);
            view.shieldPlayerTitleHcb.selected = !(_oldShowPlayerTitle);
            view.musicHcb.selected = _oldAllowMusic;
            view.soundHcb.selected = _oldAllowSound;
            view.musicSlide.value = _oldMusicVolumn;
            view.soundSlide.value = _oldSoundVolumn;
            SharedManager.getInstance().allowMusic = _oldAllowMusic;
            SharedManager.getInstance().allowSound = _oldAllowSound;
            SharedManager.getInstance().musicVolumn = _oldMusicVolumn;
            SharedManager.getInstance().soundVolumn = _oldSoundVolumn;
            SoundManager.getInstance().setConfig(SharedManager.getInstance().allowMusic, SharedManager.getInstance().allowSound, SharedManager.getInstance().musicVolumn, SharedManager.getInstance().soundVolumn);
        }
        private function initSelect():void{
            this._oldShowTI = SharedManager.getInstance().showTI;
            this._oldShowBI = SharedManager.getInstance().showBI;
            this._oldAllowPK = SharedManager.getInstance().allowPK;
            this._oldShowSkillEffect = SharedManager.getInstance().showSkillEffect;
            this._oldShowGuildName = SharedManager.getInstance().showGuildName;
            this._oldShowPlayerTitle = SharedManager.getInstance().showPlayerTitle;
            this._oldAllowMusic = SharedManager.getInstance().allowMusic;
            this._oldAllowSound = SharedManager.getInstance().allowSound;
            this._oldMusicVolumn = SharedManager.getInstance().musicVolumn;
            this._oldSoundVolumn = SharedManager.getInstance().soundVolumn;
            this._oldShowSelfBlood = SharedManager.getInstance().showSelfBlood;
            this._oldShowOtherBlood = SharedManager.getInstance().showOtherBlood;
            view.refusedTeamInvateHcb.selected = !(_oldShowTI);
            view.refusedBusinessHcb.selected = !(_oldShowBI);
            view.refusedPkHcb.selected = !(_oldAllowPK);
            view.refusedEffect.selected = !(_oldShowSkillEffect);
            view.shieldGuildNameHcb.selected = !(_oldShowGuildName);
            view.shieldPlayerTitleHcb.selected = !(_oldShowPlayerTitle);
            view.refusedSelfBloodHcb.selected = !(_oldShowSelfBlood);
            view.refusedOtherBloodHcb.selected = !(_oldShowOtherBlood);
            view.musicHcb.selected = _oldAllowMusic;
            view.soundHcb.selected = _oldAllowSound;
            view.musicSlide.value = _oldMusicVolumn;
            view.soundSlide.value = _oldSoundVolumn;
        }
        private function __saveHandler(_arg1:MouseEvent):void{
            SharedManager.getInstance().allowMusic = view.musicHcb.selected;
            SharedManager.getInstance().allowSound = view.soundHcb.selected;
            SharedManager.getInstance().showTI = !(view.refusedTeamInvateHcb.selected);
            SharedManager.getInstance().showBI = !(view.refusedBusinessHcb.selected);
            SharedManager.getInstance().allowPK = !(view.refusedPkHcb.selected);
            SharedManager.getInstance().showSkillEffect = !(view.refusedEffect.selected);
            SharedManager.getInstance().showGuildName = !(view.shieldGuildNameHcb.selected);
            SharedManager.getInstance().showPlayerTitle = !(view.shieldPlayerTitleHcb.selected);
            SharedManager.getInstance().showSelfBlood = !(view.refusedSelfBloodHcb.selected);
            SharedManager.getInstance().showOtherBlood = !(view.refusedOtherBloodHcb.selected);
            SharedManager.getInstance().musicVolumn = view.musicSlide.value;
            SharedManager.getInstance().soundVolumn = view.soundSlide.value;
            initSelect();
            SharedManager.getInstance().save();
        }
        private function set allowMusic(_arg1:Boolean):void{
            if (SharedManager.getInstance().allowMusic != _arg1){
                SharedManager.getInstance().allowMusic = _arg1;
            };
            sendNotification(SetViewEvent.SETVIEW_ALLOWMUSIC);
        }

    }
}//package GameUI.Modules.SetView.Mediator 
