//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsFramework.Utils {
    import OopsFramework.*;

    public class Timer {

        private var distanceTime:int;
        private var frequency:uint = 12;
        private var elapsedRealTime:int;

        public function get DistanceTime():int{
            return (this.distanceTime);
        }
        public function IsNextTime(_arg1:GameTime):Boolean{
            this.elapsedRealTime = (this.elapsedRealTime + _arg1.ElapsedGameTime);
            if (this.elapsedRealTime >= this.distanceTime){
                this.elapsedRealTime = (this.elapsedRealTime - this.distanceTime);
                if (this.elapsedRealTime >= (this.distanceTime * 2)){
                    this.elapsedRealTime = (this.elapsedRealTime % this.distanceTime);
                };
                return (true);
            };
            return (false);
        }
        public function set DistanceTime(_arg1:int):void{
            this.distanceTime = _arg1;
        }
        public function get Frequency():uint{
            return (this.frequency);
        }
        public function set Frequency(_arg1:uint):void{
            this.frequency = _arg1;
            this.distanceTime = ((1 / frequency) * 1000);
        }

    }
}//package OopsFramework.Utils 
