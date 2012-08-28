package z.utils
{
	public class ArrayUtil
	{
		public function ArrayUtil()
		{
		}
		
		/**
		 * 删除数组里重复的数据
		 * 需要测试
		 */ 
		public static function deleteRepeated(v:Array):void {
			for(var i:int = 0; i < v.length; i++){
				for(var j:int = 1; j < v.length; j++){
					if(v[i] == v[j]){
						v.splice(j,1);
					}
				}
			}
		}
	}
}