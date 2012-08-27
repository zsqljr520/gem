package z.core
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class GemCell extends Sprite implements IDispose
	{
		private var model:GameModel = GameModel.instance;
		
		public function GemCell() {
			super();
			this.createChildren();
			this.configEvent();
		}
		
		private function configEvent():void {
		}
		
		
		
		public function addLabel(value:*):void {
			if(this.getChildByName("textField")){
				this.removeChild(this.getChildByName("textField"));
			}
			var textField:TextField = new TextField();
			textField.width = 20;
			textField.name = "textField";
			this.addChild(textField);
			textField.mouseEnabled = false;
			textField.text = value.toString(); 
		}
		
		public var cellX:int;
		public var cellY:int;
		
		//private var colors:Array = [0xFFFFFF,0x99FFBB,0x22CCAA,0xBBCC22,0xFFDDFF,0xFFFFFF,0xCCDDEE];
		private var colors:Array = [0xFFFFFF,0x99FFBB,0x22CCAA];
		public var color:uint;
		private function createChildren():void {
			var index:int = Math.floor(Math.random() * colors.length);
			color = colors[index];
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(color);
			//g.lineStyle(3,color);
			g.drawRect(0,0,Config.W,Config.H);
			g.endFill();
		}
		
		public function dispose():void {
			while(this.numChildren > 0){
				this.removeChildAt(0);
			}
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		
		public function tween(cellX:int,cellY:int):void {
			this.cellX = cellX;
			this.cellY = cellY;
			if(this.cellY == 0) {
				this.y = -1 * Config.H;
			}
			TweenLite.to(this,0.25,{y:this.cellY * Config.H,ease:Cubic.easeIn});
			model.setItem(cellX,cellY,this);
		}
	}
}
