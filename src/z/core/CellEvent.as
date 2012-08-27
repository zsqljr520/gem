package z.core
{
	import flash.events.Event;

	public class CellEvent extends Event
	{
		public static const REMOVE_CELL_EVENT:String = "remove_cell_event";
		
		public function CellEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}