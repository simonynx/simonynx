package fj1.common.data.interfaces
{
	import fj1.common.res.guide.vo.GuideConfig;

	public interface IGuideableItem
	{
		function set guideConfig(value:GuideConfig):void
		function get guideConfig():GuideConfig
	}
}
