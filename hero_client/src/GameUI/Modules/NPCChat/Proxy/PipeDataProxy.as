//Created by Action Script Viewer - http://www.buraks.com/asv
package GameUI.Modules.NPCChat.Proxy {
    import org.puremvc.as3.multicore.patterns.proxy.*;

    public class PipeDataProxy extends Proxy {

        public static const NAME:String = "PipeDataProxy";

        public var desText:String = "";
        public var linkArr:Array;

        public function PipeDataProxy(_arg1:String=null, _arg2:Object=null){
            super(NAME, _arg2);
            this.linkArr = [];
        }
        public function reset():void{
            this.desText = "";
            this.linkArr = [];
        }

    }
}//package GameUI.Modules.NPCChat.Proxy 
