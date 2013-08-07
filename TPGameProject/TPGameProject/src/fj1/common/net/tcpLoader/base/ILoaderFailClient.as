package fj1.common.net.tcpLoader.base
{

	public interface ILoaderFailClient
	{
		/**
		 * 加载失败时默认返回的结果
		 * @return
		 *
		 */
		function get contentWhenFail():Object;

		/**
		 * 加载失败超时时默认返回的结果
		 * @return
		 *
		 */
		function get contentWhenTimeOut():Object;
	}
}
