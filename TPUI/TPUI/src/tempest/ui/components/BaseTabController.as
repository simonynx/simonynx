package tempest.ui.components
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import tempest.common.staticdata.MovieClipResModel;
	import tempest.ui.events.TabControllerEvent;

	[Event(name = "change", type = "tempest.ui.events.TabControllerEvent")]
	[Event(name = "tabDispose", type = "tempest.ui.events.TabControllerEvent")]
	[Event(name = "tabInit", type = "tempest.ui.events.TabControllerEvent")]
	public class BaseTabController extends EventDispatcher //extends TComponent
	{
		protected var _tabGroup:TGroup;

		protected var tabList:Array = [];

		protected var _selectedIndex:int = -1;

		private var _tabEnableStateArray:Array = []; //选项卡可用状态容器

		public function BaseTabController()
		{
			super(this);
			_tabGroup = new TGroup();
		}

		/**
		 *
		 * @param head 选项卡头，需要对应radioButton格式的资源
		 * @param headText 选项卡头文本
		 * @param containers 选项卡对应的容器
		 * @param model 选项卡头帧数类型
		 * @return
		 *
		 */
		protected function addTabInternal(radioBt:TRadioButton, tabViewArray:Array):TRadioButton
		{
			radioBt.addEventListener(Event.CHANGE, onTabChange);
			radioBt.addEventListener(Event.SELECT, onTabSelect);
			var containerDataArr:Array = tabViewArrToTabViewDataArr(tabViewArray);
			tabList.push(new TabData(radioBt, containerDataArr));
			_tabEnableStateArray.push(true);
			for each (var cantainerData:TabViewData in containerDataArr)
			{
				if (cantainerData.tabView.parent)
				{
					cantainerData.parent.removeChild(cantainerData.tabView);
				}
			}
			return radioBt;
		}

		/**
		 * 设置选项卡页的可选状态
		 * 不可选的选项卡页被选中时，将抛出TabControllerEvent.CHANGE_FAILED事件
		 * @param value
		 * @param index
		 *
		 */
		public function setTabEnabled(value:Boolean, index:int):void
		{
			_tabEnableStateArray[index] = value;
		}

		private function tabViewArrToTabViewDataArr(tabViewArray:Array):Array
		{
			var tabViewDataArr:Array = [];
			for each (var tabView:DisplayObject in tabViewArray)
			{
				if (!tabView.parent)
				{
					var oldParent:DisplayObjectContainer = findParent(tabView);
					if (oldParent)
					{
						tabViewDataArr.push(new TabViewData(oldParent, tabView));
					}
				}
				else
				{
					tabViewDataArr.push(new TabViewData(tabView.parent, tabView));
				}
			}
			return tabViewDataArr;
		}

		private function findParent(tabView:DisplayObject):DisplayObjectContainer
		{
			for each (var tabData:TabData in tabList)
			{
				for each (var tabViewData:TabViewData in tabData.tabViewDataArray)
				{
					if (tabViewData.tabView == tabView)
					{
						return tabViewData.parent;
					}
				}
			}
			return null;
		}

		/**
		 * 更改选项卡头对应的容器
		 * @param _tabButton 选项卡头按钮
		 * @param containers
		 *
		 */
		public function setTab2(tabButton:TRadioButton, containers:Array):void
		{
			var index:int = findTabHead(tabButton);
			if (index < 0)
			{
				return;
			}
			setTab(index, containers);
		}

		/**
		 * 更改选项卡头对应的容器
		 * @param index 选项卡头索引
		 * @param containers
		 *
		 */
		public function setTab(index:int, tabViewArray:Array):void
		{
			var tabData:TabData = tabList[index];
			if (tabData.tabViewDataArray)
			{
				setTabViewsVisible(tabData.tabViewDataArray, false);
			}
			tabData.tabViewDataArray = tabViewArrToTabViewDataArr(tabViewArray);
			if (index == _selectedIndex)
			{
				setTabViewsVisible(tabData.tabViewDataArray, true);
			}
			else
			{
				setTabViewsVisible(tabData.tabViewDataArray, false);
			}
		}

		/**
		 * 或显示选项卡
		 * @param index
		 *
		 */
		public function setTabUseable(index:int, useable:Boolean):void
		{
			var tabData:TabData = tabList[index];
			(tabData.head as DisplayObject).visible = useable;
			if (!useable)
				setTabViewsVisible(tabData.tabViewDataArray, false);
		}

		/**
		 *
		 * @param index
		 * @return
		 *
		 */
		public function getTabHead(index:int):TRadioButton
		{
			if (index < 0)
				return null;
			return tabList[index].head;
		}

		/**
		 * 获取当前可用的选项卡
		 * @return
		 *
		 */
		public function getUseableTabs():Array
		{
			var ret:Array = [];
			for (var i:int = 0; i < tabList.length; ++i)
			{
				var tabData:TabData = tabList[i];
				if (tabData.head.visible && _tabEnableStateArray[i])
				{
					ret.push(tabData);
				}
			}
			return ret;
		}

		/**
		 *
		 * @param index
		 * @return
		 *
		 */
		public function getTabViews(index:int):Array
		{
			if (index < 0)
				return null;
			var tabViewArray:Array = [];
			var tabViewDataArray:Array = TabData(tabList[index]).tabViewDataArray;
			for each (var containerData:TabViewData in tabViewDataArray)
			{
				tabViewArray.push(containerData.tabView);
			}
			return tabViewArray;
		}

		public function get currentTabViews():Array
		{
			if (_selectedIndex < 0)
				return null;
			var tabViewArray:Array = [];
			var tabViewDataArray:Array = TabData(tabList[_selectedIndex]).tabViewDataArray;
			for each (var containerData:TabViewData in tabViewDataArray)
			{
				tabViewArray.push(containerData.tabView);
			}
			return tabViewArray;
		}

		private function get currentTabViewDataArr():Array
		{
			if (_selectedIndex < 0)
				return null;

			return TabData(tabList[_selectedIndex]).tabViewDataArray;
		}

		public function get currentTabHead():TRadioButton
		{
			if (_selectedIndex < 0)
				return null;
			return TabData(tabList[_selectedIndex]).head;
		}

		private function onTabChange(event:Event):void
		{
			var chgButton:TRadioButton = event.currentTarget as TRadioButton;
			var containers:Array = null;

			if (chgButton.selected)
			{
				//查找RadioButton对应的选中索引
				var newIndex:int = -1;
				for (var j:int = 0; j < tabList.length; ++j)
				{
					var tabData2:TabData = tabList[j];
					if (tabData2.head == chgButton)
					{
						newIndex = j;
						break;
					}
				}

				internalSelect(newIndex);
			}
		}

		private function setTabViewsVisible(tabViewDataArray:Array, value:Boolean):void
		{
			for each (var tabViewData:TabViewData in tabViewDataArray)
			{
				if (value)
				{
					if (!tabViewData.tabView.parent)
					{
						tabViewData.parent.addChild(tabViewData.tabView);
						tabViewData.tabView.dispatchEvent(new TabControllerEvent(TabControllerEvent.TAB_INIT, _selectedIndex));
					}
				}
				else
				{
					if (tabViewData.tabView.parent)
					{
						tabViewData.parent.removeChild(tabViewData.tabView);
						tabViewData.tabView.dispatchEvent(new TabControllerEvent(TabControllerEvent.TAB_DISPOSE, _selectedIndex));
					}
				}
			}
		}

		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value)
				return;

			for (var i:int = 0; i < tabList.length; ++i)
			{
				if (i == value)
				{
					//选中tab
					var head:TRadioButton = tabList[i].head as TRadioButton;
					head.removeEventListener(Event.SELECT, onTabSelect);
					head.removeEventListener(Event.CHANGE, onTabChange);
					head.select();
					head.addEventListener(Event.CHANGE, onTabChange);
					head.addEventListener(Event.SELECT, onTabSelect);
					internalSelect(i, false);
					break;
				}
			}
			if (i == tabList.length)
			{
				internalSelect(-1, false);
			}
		}

		private function onTabSelect(event:Event):void
		{
			var index:int = findTabHead(TRadioButton(event.currentTarget));
			if (index < 0)
			{
				return;
			}
			if (!_tabEnableStateArray[index])
			{
				//该选项卡页被禁用
				event.preventDefault();
				dispatchEvent(new TabControllerEvent(TabControllerEvent.CHANGE_FAILED, index));
			}
		}

		private function findTabHead(tabHead:TRadioButton):int
		{
			for (var i:int = 0; i < tabList.length; ++i)
			{
				var tabData:Object = tabList[i];
				if (tabData.head == tabHead)
				{
					return i;
				}
			}
			return -1;
		}

		private function internalSelect(newIndex:int, dispatch:Boolean = true):void
		{
			if (_selectedIndex != -1)
			{
				setTabViewsVisible(currentTabViewDataArr, false);
				dispatchEvent(new TabControllerEvent(TabControllerEvent.TAB_DISPOSE, _selectedIndex));
			}

			_selectedIndex = newIndex;

			if (_selectedIndex != -1)
			{
				setTabViewsVisible(currentTabViewDataArr, true);
				dispatchEvent(new TabControllerEvent(TabControllerEvent.TAB_INIT, _selectedIndex));
			}

			if (dispatch)
			{
				dispatchEvent(new TabControllerEvent(TabControllerEvent.CHANGE, _selectedIndex));
			}
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function get tabCount():int
		{
			return tabList.length;
		}
	}
}
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import tempest.ui.components.TRadioButton;

class TabViewData
{
	public var tabView:DisplayObject;
	public var parent:DisplayObjectContainer;

	public function TabViewData(parent:DisplayObjectContainer, tabView:DisplayObject)
	{
		this.tabView = tabView;
		this.parent = parent;
	}
}

class TabData
{
	public var head:TRadioButton;
	public var tabViewDataArray:Array;

	public function TabData(head:TRadioButton, tabViewArray:Array)
	{
		this.head = head;
		this.tabViewDataArray = tabViewArray;
	}
}
