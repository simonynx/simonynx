package tempest.ui.effects
{

	public interface IWindowEffect extends IEffect
	{
		function playOpenEffect():void;
		function playCloseEffect():void

		function get openEffect():IEffect;
		function get closeEffect():IEffect;
	}
}
