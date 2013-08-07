package fj1.common.res.window.vo
{

	/**
	 *系统窗口配置
	 * @author zhangyong
	 *
	 */
	public class WindowTemplRes
	{
		/**
		 *窗口名称
		 */
		public var name:String;
		/**
		 *窗口编号 xx_xxx(功能编号_递增编号)
		 */
		public var id:int;
		/**
		 *皮肤id
		 */
		public var skinId:String;
		/**
		 *导出类
		 */
		public var symbol:String;
		/**
		 * 是否ESC关闭
		 */
		public var isEseClose:Boolean;
		/**
		 * 是否切换场景关闭
		 */
		public var isChangeSceneClose:Boolean;
		/**
		 * 是否切换线关闭
		 */
		public var isChangeLineClose:Boolean;
		/**
		 * 是否缓存位图
		 */
		public var isCacheAsBitmap:Boolean;
		/**
		 * 是否使用切换效果
		 */
		public var isUseEffect:Boolean;
		/**
		 *是否关闭后销毁窗口
		 */
		public var isCloseDispose:Boolean;

	}
}
