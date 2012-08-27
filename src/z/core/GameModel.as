package z.core
{
	public class GameModel
	{
		public function GameModel()
		{
		}
		
		private static var _instance:GameModel;
		
		public static function get instance():GameModel {
			if(_instance == null){
				_instance = new GameModel();
			}
			return _instance;
		}
		
		public function get items():Array {
			return this._items;
		}
		
		private var _items:Array = [];
		
		public function initialize():void {
			var startY:Number = 0;
			for(var i:int = 0; i < Config.row; i++){
				_items[i] = [];
				for(var j:int = 0; j < Config.column; j++){
					_items[i][j] = null;
				}
			}
		}
		
		public function setItem(xIndex:int,yIndex:int,item:*):void {
			this._items[yIndex][xIndex] = item;
		}
		
		public function getItem(xIndex:int,yIndex:int):* {
			if(this._items[yIndex] == null){
				return null; 
			}
			return this._items[yIndex][xIndex];
		}
	}
}