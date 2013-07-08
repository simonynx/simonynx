//Created by Action Script Viewer - http://www.buraks.com/asv
package OopsEngine.Skill {
    import flash.utils.*;
    import GameUI.View.*;
    import OopsFramework.Content.Provider.*;

    public class GameSkillResource {

        public var EffectBR:BulkLoaderResourceProvider;
        public var EffectPath:String;
        public var isLoadComplete:Boolean;
        public var OnLoadEffect:Function;
        public var SkillID:int = 0;
        public var EffectName:String;
        public var geed:GameSkillData;

        public function GameSkillResource(){
            EffectBR = new BulkLoaderResourceProvider();
            super();
        }
        public function GetAnimation():SkillAnimation{
            var mc:* = null;
            var start:* = 0;
            var animationSkill:* = SkillAnimation.createSkillAnimation();
            animationSkill.IsPool = true;
            if (EffectPath != null){
                try {
                    if (geed == null){
                        start = getTimer();
                        trace(("开始分析: " + EffectPath));
                        mc = EffectBR.GetResource(EffectPath).GetMovieClip();
                        geed = new GameSkillData(animationSkill);
                        geed.Analyze(mc);
                        EffectBR = null;
                        trace((((("加载到" + EffectPath) + "并分析完,用了") + (getTimer() - start)) + "时间"));
                    } else {
                        geed.SetAnimationData(animationSkill);
                    };
                } catch(e:Error) {
                    MessageTip.show(((("EffectName  " + EffectName) + "类名称:") + getQualifiedClassName(mc)));
                };
            };
            return (animationSkill);
        }
        public function onEffectComplete():void{
            if (OnLoadEffect != null){
                OnLoadEffect(this);
            };
            isLoadComplete = true;
        }

    }
}//package OopsEngine.Skill 
