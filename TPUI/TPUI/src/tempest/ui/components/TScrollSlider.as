package tempest.ui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="change", type="flash.events.Event")]
	public class TScrollSlider extends TSlider
	{
		protected var _pageSize:int = 1;

		/**
		 * Constructor
		 * @param orientation Whether this is a vertical or horizontal slider.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function TScrollSlider(constraints:Object = null, _proxy:*=null, orientation:String=TSlider.HORIZONTAL, defaultHandler:Function=null)
		{
			super(constraints, _proxy, orientation, defaultHandler);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onBackClick(event:MouseEvent):void
		{
			if(_orientation == HORIZONTAL)
			{
				if(mouseX < _handle.x)
				{
					if(_max > _min)
					{
						_value -= _pageSize;
					}
					else
					{
						_value += _pageSize;
					}
					correctValue();
				}
				else
				{
					if(_max > _min)
					{
						_value += _pageSize;
					}
					else
					{
						_value -= _pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			else
			{
				if(mouseY < _handle.y)
				{
					if(_max > _min)
					{
						_value -= _pageSize;
					}
					else
					{
						_value += _pageSize;
					}
					correctValue();
				}
				else
				{
					if(_max > _min)
					{
						_value += _pageSize;
					}
					else
					{
						_value -= _pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			dispatchEvent(new Event(Event.CHANGE));
		
		}
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_pageSize = value;
			invalidate();
		}
		
		public function get pageSize():int
		{
			return _pageSize;
		}
	}
}