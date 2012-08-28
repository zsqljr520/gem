package z.core
{
	public class Config
	{
		public function Config()
		{
		}
		
		public static const row:int = 9; 
		public static const column:int = 10;
		
		public static const W:Number = 32;
		public static const H:Number = 32;
		
		public static const DIRECTION_LEFT:int = 0;// 左
		
		public static const DIRECTION_RIGHT:int = 2;// 右
		
		public static const DIRECTION_TOP:int = 1;// 上
		
		public static const DIRECTION_BOTTOM:int = 3; // 下
		
		public static const DIRECTION_OWNER:int = 4;// 当前点击的
		
		public static const MIN_REMOVED_COUNT:int = 1;// N个才能消除
		
		public static const H_DIRECTION:int = 1 << 4;
		public static const V_DIRECTION:int = 2 << 4;
		
		public static const MIN_CLEAR_UP_LINE:int = 2;
		
		
		//public static var colors:Array = [0xFFFFFF,0x99FFBB,0x22CCAA,0xBBCC22,0xFFDDFF,0xFFFFFF,0xCCDDEE,0xFFBB22,0xEECCDD,0xAABB55,0xBBCCDD];
		public static var colors:Array = [0xFFFFFF,0x99FFBB,0x22CCAA];

	}
}