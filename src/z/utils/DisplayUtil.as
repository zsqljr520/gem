package z.utils
{
	import flash.display.DisplayObjectContainer;
	
	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		public static function removeAllChildren(v:DisplayObjectContainer):void {
			while(v.numChildren > 0){
				v.removeChildAt(0);
			} 
		}
	}
}