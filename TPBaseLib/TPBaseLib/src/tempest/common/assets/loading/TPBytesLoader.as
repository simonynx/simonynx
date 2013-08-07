package tempest.common.assets.loading
{
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class TPBytesLoader extends TPURLLoader
	{
		public function TPBytesLoader(request:URLRequest = null, maxTries:int = 3)
		{
			super(request, maxTries);
			dataFormat = URLLoaderDataFormat.BINARY;
		}
	}
}