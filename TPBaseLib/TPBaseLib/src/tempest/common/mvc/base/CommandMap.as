package tempest.common.mvc.base
{
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.ISignal;
	import tempest.common.mvc.TFacade;

	public class CommandMap
	{
		private var _facade:TFacade;
		private var _commands:Dictionary = new Dictionary(true);

		public function CommandMap(facade:TFacade)
		{
			_facade = facade;
		}

		public function get facade():TFacade
		{
			return _facade;
		}

		public function map(signals:Array, commandCls:Class, once:Boolean = false, priority:int = 0):void
		{
			if (signals && commandCls)
			{
				var command:Command = new commandCls();
				if (command == null)
				{
					throw new Error(commandCls + " is not ICommand Class");
				}
				if (command.getHandle() == null)
				{
					throw new Error(commandCls + " handle is null");
				}
				if (signals.length < 1)
				{
					throw new Error("must has more than one args");
				}
				signals.forEach(function(signal:ISignal, index:int, arr:Array):void
				{
					if (signal == null)
					{
						throw new Error("this is not ISignal");
					}
					unmap(signal);
					_commands[signal] = command;
					command.setFacade(_facade);
					command.setInject(_facade.inject);
					command.inject.injectInto(command);
					if (priority != 0 && signal is IPrioritySignal)
					{
						if (once)
						{
							IPrioritySignal(signal).addOnceWithPriority(command.getHandle(), priority);
							IPrioritySignal(signal).addOnceWithPriority(function(... args):void
							{
								unmap(signal);
							}, priority);
						}
						else
						{
							IPrioritySignal(signal).addWithPriority(command.getHandle(), priority);
						}
					}
					else
					{
						if (once)
						{
							signal.addOnce(command.getHandle());
							signal.addOnce(function(... args):void
							{
								unmap(signal);
							});
						}
						else
						{
							signal.add(command.getHandle());
						}
					}
				});
			}
		}

		public function unmap(signal:ISignal):void
		{
			if (signal)
			{
				var _command:Command = _commands[signal];
				if (_command)
				{
					_command.setFacade(null);
					_command.setInject(null);
					signal.remove(_command.getHandle());
					_commands[signal] = null;
					delete _commands[signal];
				}
			}
		}

		public function unmapAll():void
		{
			var _signal:Object;
			for (_signal in _commands)
			{
				unmap(ISignal(_signal));
			}
		}
	}
}
