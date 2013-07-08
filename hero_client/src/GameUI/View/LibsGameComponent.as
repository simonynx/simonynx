//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.View {
    import OopsFramework.*;
    import GameUI.ConstData.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class LibsGameComponent extends DrawableGameComponent {

        public function LibsGameComponent(_arg1:Game){
            super(_arg1);
        }
        override public function Initialize():void{
        }
        override protected function LoadContent():void{
        }
        public function GetLibrary(_arg1:String, _arg2:Mediator, _arg3:String):void{
            switch (_arg1){
                case UIConfigData.MOVIECLIP:
                    _arg2.setViewComponent(this.Games.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(_arg3));
                    break;
                case UIConfigData.BUTTON:
                    _arg2.setViewComponent(this.Games.Content.Load(GameConfigData.UILibrary).GetClassByButton(_arg3));
                    break;
                case UIConfigData.BMD:
                    break;
            };
        }
        override public function Update(_arg1:GameTime):void{
        }

    }
}//package GameUI.View 
