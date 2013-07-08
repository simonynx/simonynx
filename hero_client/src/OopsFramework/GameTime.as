//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework {

    public class GameTime {

        public var TotalGameTime:int;
        public var ElapsedGameTime:int;

        public function toString():String{
            return (((("ElapsedGameTime:" + ElapsedGameTime) + "---TotalGameTime:") + TotalGameTime));
        }

    }
}//package OopsFramework 
