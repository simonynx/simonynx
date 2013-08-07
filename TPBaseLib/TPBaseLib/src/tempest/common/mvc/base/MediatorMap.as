package tempest.common.mvc.base
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import tempest.common.mvc.TFacade;

	public class MediatorMap
	{
		private var _facade:TFacade;
		private var _mediators:Dictionary = new Dictionary(true);

		public function MediatorMap(facade:TFacade)
		{
			_facade = facade;
		}

		public function get facade():TFacade
		{
			return _facade;
		}

		public function map(obj:InteractiveObject, mediatorCls:Class):void
		{
			if (obj && mediatorCls)
			{
				var mediator:Mediator = new mediatorCls();
				if (mediator == null)
				{
					throw new Error(mediatorCls + " is not IMediator Class");
				}
				unmap(obj);
				mediator.setFacade(_facade);
				mediator.setInject(_facade.inject);
				mediator.inject.mapValue(Class(getDefinitionByName(getQualifiedClassName(obj))), obj);
				mediator.inject.injectInto(mediator);
				mediator.setViewComponet(obj);
				_mediators[obj] = mediator;
			}
		}

		public function unmap(obj:InteractiveObject):void
		{
			if (obj)
			{
				var mediator:Mediator = _mediators[obj];
				if (mediator)
				{
					mediator.inject.unmap(getDefinitionByName(getQualifiedClassName(obj)) as Class);
					mediator.onPreRemove(null);
					mediator.setFacade(null);
					mediator.setInject(null);
					mediator.setViewComponet(null);
					_mediators[obj] = null;
					delete _mediators[obj];
				}
			}
		}

		public function unmapAll():void
		{
			var obj:Object;
			for (obj in _mediators)
			{
				unmap(InteractiveObject(obj));
			}
		}
	}
}
