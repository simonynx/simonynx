package br.com.stimuli.loading
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import br.com.stimuli.loading.BulkLoader;


	/**
	 *	An event that holds information about the status of a <code>BulkLoader</code>.
	 *
	 *   As this event subclasses <code>ProgressEvent</code>, you can choose to listen to <code>BulkProgressEvent</code> or <code>ProgressEvent</code> instances, but this class provides more useful information about loading status.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Arthur Debert
	 *	@since  15.09.2007
	 */
	public class BulkProgressEvent extends ProgressEvent
	{
		/**
		 * 正在加载
		 * @default
		 */
		public static const PROGRESS:String="progress";
		/**
		 * 加载完成
		 * @default
		 */
		public static const COMPLETE:String="complete";

		/**
		 * 当前已经加载的字节
		 * How many bytes have loaded so far.*/
		public var bytesTotalCurrent:int;
		/** @private */
		private var _ratioLoaded:Number;
		/** @private */
		public var _percentLoaded:Number;
		/** @private */
		private var _weightPercent:Number;
		/**
		 * 已经加载的文件数
		 * Number of items already loaded */
		public var itemsLoaded:int;
		/**
		 * 加载的文件数
		 * Number of items to be loaded */
		public var itemsTotal:int;

		/**
		 * 名字
		 * @default
		 */
		public var name:String;

		/**
		 *
		 * @param name
		 * @param bubbles
		 * @param cancelable
		 */
		public function BulkProgressEvent(name:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(name, bubbles, cancelable);
			this.name=name;
		}

		/**
		 * 设置加载信息
		 * Sets loading information.*/
		public function setInfo(bytesLoaded:int, bytesTotal:int, bytesTotalCurrent:int, itemsLoaded:int, itemsTotal:int, weightPercent:Number):void
		{
			this.bytesLoaded=bytesLoaded;
			this.bytesTotal=bytesTotal;
			this.bytesTotalCurrent=bytesTotalCurrent;
			this.itemsLoaded=itemsLoaded;
			this.itemsTotal=itemsTotal;
			this.weightPercent=weightPercent;
			this.percentLoaded=bytesTotal > 0 ? (bytesLoaded / bytesTotal) : 0;
			ratioLoaded=itemsTotal == 0 ? 0 : itemsLoaded / itemsTotal;
		}

		/* Returns an identical copy of this object
		 *   @return A cloned instance of this object.
		 */
		override public function clone():Event
		{
			var b:BulkProgressEvent=new BulkProgressEvent(name, bubbles, cancelable);
			b.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, itemsLoaded, itemsTotal, weightPercent);
			return b;
		}

		/**
		 * 返回加载状态信息
		 *  Returns a <code>String</code> will all available information for this event.
		 * @return A <code>String</code> will loading information.
		 */
		public function loadingStatus():String
		{
			var names:Array=[];
			names.push("bytesLoaded: " + bytesLoaded);
			names.push("bytesTotal: " + bytesTotal);
			names.push("itemsLoaded: " + itemsLoaded);
			names.push("itemsTotal: " + itemsTotal);
			names.push("bytesTotalCurrent: " + bytesTotalCurrent);
			names.push("percentLoaded: " + BulkLoader.truncateNumber(percentLoaded));
			names.push("weightPercent: " + BulkLoader.truncateNumber(weightPercent));
			names.push("ratioLoaded: " + BulkLoader.truncateNumber(ratioLoaded));
			return "BulkProgressEvent " + names.join(", ") + ";";
		}

		/** 
		 * 获取权重比率
		 * A number between 0 - 1 that indicates progress regarding weights */
		public function get weightPercent():Number
		{
			return truncateToRange(_weightPercent);
		}


		/**
		 *设置权重比率
		 * @param value
		 */
		public function set weightPercent(value:Number):void
		{
			if (isNaN(value) || !isFinite(value))
			{
				value=0;
			}
			_weightPercent=value;
		}

		/** 
		 * 获取加载的百分比
		 * A number between 0 - 1 that indicates progress regarding bytes */
		public function get percentLoaded():Number
		{
			return truncateToRange(_percentLoaded);
		}

		/**
		 *设置加载的百分比
		 * @param value
		 */
		public function set percentLoaded(value:Number):void
		{
			if (isNaN(value) || !isFinite(value))
				value=0;
			_percentLoaded=value;
		}

		/** 
		 * 获取加载个数比率
		 * The ratio (0-1) loaded (number of items loaded / number of items total) */
		public function get ratioLoaded():Number
		{
			return truncateToRange(_ratioLoaded);
		}

		/**
		 *设置加载个数比率
		 * @param value
		 */
		public function set ratioLoaded(value:Number):void
		{
			if (isNaN(value) || !isFinite(value))
				value=0;
			_ratioLoaded=value;
		}

		/**
		 *
		 * @param value
		 * @return
		 */
		public function truncateToRange(value:Number):Number
		{
			if (value < 0)
			{
				value=0;
			}
			else if (value > 1)
			{
				value=1
			}
			else if (isNaN(value) || !isFinite(value))
			{
				value=0;
			}
			return value;
		}

		override public function toString():String
		{
			return super.toString();
		}

	}

}
