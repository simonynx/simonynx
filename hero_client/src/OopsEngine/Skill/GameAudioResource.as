//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Skill {
    import OopsFramework.Audio.*;
    import OopsFramework.Content.Provider.*;

    public class GameAudioResource {

        public var OnLoadAudio:Function;
        public var AudioBR:BulkLoaderResourceProvider;
        public var AudioName:String;
        public var AudioPath:String;

        public function GameAudioResource(){
            AudioBR = new BulkLoaderResourceProvider();
            super();
        }
        public function onAudioComplete():void{
            var _local1:AudioEngine;
            if (AudioBR.GetResource(AudioPath)){
                _local1 = new AudioEngine(AudioBR.GetResource(AudioPath).GetSound());
                if (OnLoadAudio != null){
                    OnLoadAudio(_local1, AudioName);
                };
            };
        }

    }
}//package OopsEngine.Skill 
