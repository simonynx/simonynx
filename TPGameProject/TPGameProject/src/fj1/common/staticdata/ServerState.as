package fj1.common.staticdata
{

	/**
	 *服务器状态
	 * @author wushangkun
	 */
	public class ServerState
	{
		/**
		 * 流畅
		 * @default
		 */
		public static const FLOW:int = 0;
		/**
		 * 繁忙
		 * @default
		 */
		public static const BUSY:int = 1;
		/**
		 * 爆满
		 * @default
		 */
		public static const FULL:int = 2;
		/**
		 * 爆满
		 * @default
		 */
		public static const CLOSE:int = 3;

		/**
		 * 获取状态颜色
		 * @param state
		 * @return
		 */
		public static function getStateColor(state:int):uint
		{
			switch (state)
			{
				case FLOW: //流畅
					return 0x00CC00;
				case BUSY:
					return 0xFF3300;
				case FULL: //爆满
					return 0xFF0000;
				default: //未知
					return 0x999999;
			}
		}

		/**
		 * 获取状态颜色
		 * @param state
		 * @return
		 */
		public static function getStateStr(state:int):String
		{
			switch (state)
			{
				case FLOW: //流畅
					return "[FLOW]"; //#####
				case BUSY: //拥挤
					return "[BUSY]"; //#####
				case FULL: //爆满
					return "[FULL]"; //#####
				default: //未知
					return "[CLOSE]"; //#####
			}
		}
	}
}
