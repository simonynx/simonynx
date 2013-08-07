package fj1.modules.skill.magic
{
	import fj1.modules.skill.model.SpellHelper;
	
	import ghostcat.operation.Oper;
	
	import tpm.magic.entity.MagicInfo;
	import tpm.magic.entity.TargetObject;
	
	public class HurtEffectOper extends Oper
	{
		
		private var magicInfo:MagicInfo;
        private var hurts:Vector.<TargetObject>;
		
		public function HurtEffectOper(hurts:Vector.<TargetObject>, magicInfo:MagicInfo)
		{
			super();
			this.hurts = hurts;
			this.magicInfo = magicInfo;
		}
		
		override public function execute():void
		{
			SpellHelper.hurtEffectFuc(hurts, magicInfo, function():void
			{
				result();
			});
		}
	}
}