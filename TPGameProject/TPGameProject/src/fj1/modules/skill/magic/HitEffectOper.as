package fj1.modules.skill.magic
{
	import flash.geom.Point;
	
	import fj1.modules.skill.model.SpellHelper;
	
	import ghostcat.operation.Oper;
	
	import tpm.magic.MagicEngine;
	import tpm.magic.entity.MagicInfo;
	import tpm.magic.entity.TargetObject;
	
	public class HitEffectOper extends Oper
	{
		private var magicInfo:MagicInfo;
		private var targetObject:TargetObject;
		
		public function HitEffectOper(magicInfo:MagicInfo, targetObject:TargetObject)
		{
			super();
			this.magicInfo = magicInfo;
			this.targetObject = targetObject;
		}
		
		override public function execute():void
		{
			var targetPoint:Point = targetObject.position.clone();
//			targetPoint.y -= MagicEngine.body_offset;
			SpellHelper.hitFuc(magicInfo, targetObject, targetPoint, function():void
			{
				result();
			});

		}
	}
}