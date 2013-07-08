//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Utils {
    import flash.net.*;

    public class System {

        public static function CollectEMS():void{
            try {
                new LocalConnection().connect("MoonSpirit");
                new LocalConnection().connect("MoonSpirit");
            } catch(error:Error) {
            };
        }

    }
}//package OopsEngine.Utils 
