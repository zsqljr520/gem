package z.utils
{
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		public static function random(min:int,max:int):int {
			var r:int = Math.floor(Math.random() * max);
			if(r < min){
				r = min;
			}
			return r;
		}
	}
}