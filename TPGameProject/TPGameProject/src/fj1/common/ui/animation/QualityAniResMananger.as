package fj1.common.ui.animation
{

	import flash.utils.Dictionary;

	/**
	 * 品质相关动画资源管理
	 * @author linxun
	 *
	 */
	public class QualityAniResMananger
	{
		private var _resDic:Dictionary;
		private var _frameCtrl:IAnimationFrameController;

		private static var _instance:QualityAniResMananger;

		public static function getInstance():QualityAniResMananger
		{
			return _instance ||= new QualityAniResMananger();
		}

		public function QualityAniResMananger()
		{
			_resDic = new Dictionary();
			_frameCtrl = new AnimationFrameController(30);
		}

		public function setRes(id:String, res:IBitmapAnimationRes):void
		{
			_resDic[id] = res;
		}

		public function getRes(id:String):IBitmapAnimationRes
		{
			return _resDic[id];
		}

		/**
		 * 品质动画使用相同的帧率控制器
		 * @return
		 *
		 */
		public function get frameCtrl():IAnimationFrameController
		{
			return _frameCtrl;
		}
	}
}
