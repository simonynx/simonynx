//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.Login.StartMediator {
    import flash.display.*;
    import flash.text.*;

    public class CreateRoleSimpleWindow extends Sprite {

        public var currentSex:int;
        public var randomNameBtn:SimpleButton;
        public var mainMc:MovieClip;
        public var enterGameBtn:SimpleButton;
        public var nameTF:TextField;

        public function CreateRoleSimpleWindow(){
            initView();
        }
        public function setSex(_arg1:int=0):void{
            if (_arg1 == 0){
                mainMc.boy_checkBox.gotoAndStop(2);
                mainMc.girl_checkBox.gotoAndStop(1);
            } else {
                mainMc.boy_checkBox.gotoAndStop(1);
                mainMc.girl_checkBox.gotoAndStop(2);
            };
            currentSex = _arg1;
        }
        public function get btnBoy():MovieClip{
            return (mainMc.boy_checkBox);
        }
        public function resize():void{
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, 2000, 2000);
            graphics.endFill();
            mainMc.x = int(((GameCommonData.GameInstance.ScreenWidth - mainMc.width) / 2));
            mainMc.y = int(((GameCommonData.GameInstance.ScreenHeight - mainMc.height) / 2));
        }
        private function initView():void{
            graphics.beginFill(0);
            graphics.drawRect(0, 0, 2000, 2000);
            graphics.endFill();
            mainMc = (GameCommonData.GameInstance.Content.Load(GameConfigData.UILibraryCreateRoleSimple).GetClassByMovieClip("CreateRole_Simple") as MovieClip);
            addChild(mainMc);
            nameTF = mainMc.nameTF;
            nameTF.maxChars = 8;
            nameTF.text = "";
            nameTF.multiline = false;
            enterGameBtn = mainMc.enterGameBtn;
            randomNameBtn = mainMc.randomNameBtn;
            mainMc.boy_checkBox.buttonMode = true;
            mainMc.girl_checkBox.buttonMode = true;
            setSex(0);
        }
        public function get btnGirl():MovieClip{
            return (mainMc.girl_checkBox);
        }

    }
}//package GameUI.Modules.Login.StartMediator 
