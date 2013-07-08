//Created by Action Script Viewer - http://www.buraks.com/asv
package Net {
    import GameUI.UICore.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;

    public class GameAction extends Proxy {

        public function GameAction(_arg1:Boolean=true){
            if (_arg1){
                this.initializeNotifier(UIFacade.FACADEKEY);
                facade.registerProxy(this);
            };
        }
        public function Processor(_arg1:NetPacket):void{
        }

    }
}//package Net 
