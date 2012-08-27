package z.core
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GemScene extends Sprite implements IDispose
	{
		private var model:GameModel = GameModel.instance;
		
		public function GemScene()
		{
			super();
			model.initialize();
			this.createChildren();
			this.configEvent();
		}
		
		private function configEvent():void {
			this.addEventListener(MouseEvent.CLICK,checkCellHandler);
		}
		
		private function checkCellHandler(event:MouseEvent):void {
			var cell:GemCell = event.target as GemCell;
			if(cell){
				trace("cell.cellX : " + cell.cellX + ", cell.cellY : " + cell.cellY);
				cells = [];
				var vLineCells:Array = [];
				var hLineCells:Array = [];
				var items:Array = this.getAroundCell(cell);
				var item:CellItem;
				for each(item in items){
					if(item.direction == Config.DIRECTION_LEFT || item.direction == Config.DIRECTION_RIGHT){
						if(item.cell.cellY == cell.cellY && hLineCells.indexOf(item.cell) == -1){
							hLineCells.push(item.cell);
						}
					}else if(item.direction == Config.DIRECTION_TOP || item.direction == Config.DIRECTION_BOTTOM) {
						if(item.cell.cellX == cell.cellX && vLineCells.indexOf(item.cell) == -1){
							vLineCells.push(item.cell);
						}
					}
				}
				//this.rebuild(hLineCells,Config.H_DIRECTION);
				this.rebuild(vLineCells,Config.V_DIRECTION);
			}
		}
		
		private function rebuild(v:Array,direction:int):void {
			var cell:GemCell;
			if(v.length >= Config.MIN_REMOVED_COUNT){
				if(direction == Config.V_DIRECTION){
					v.sort(compareFunc);
				}
				for each(cell in v){
					model.setItem(cell.cellX,cell.cellY,null);
					cell.dispose();
				}
				this.relocation(v,direction);
			}
		}
		
		private function createChildren():void {
			var startY:Number = 0;
			for(var i:int = 0; i < Config.row; i++){
				startY = i * Config.H;
				var startX:Number = 0;
				for(var j:int = 0; j < Config.column; j++){
					var cell:GemCell = new GemCell();
					startX = j * Config.W;
					cell.x = startX;
					cell.y = startY;
					cell.cellX = j;
					cell.cellY = i;
					var s:String = j + "," + i;
					cell.addLabel(s);
					model.setItem(j,i,cell);
					this.addChild(cell);
				}
			}
		}
		
		public function hasObject(list:Array,cellItem:CellItem):Boolean {
			for(var i:int = 0; i < cells.length; i++){
				var item:CellItem = cells[i];
				if(item.equal(cellItem)){
					return true;
				}
			}
			return false;
		}
		
		public function compareFunc(cellA:GemCell,cellB:GemCell):int {
			if(cellA.cellY < cellB.cellY){
				return 1;
			}else if(cellA.cellY > cellB.cellY){
				return -1;
			}
			return 0;
		}
		
		private var cells:Array;
		
		private var directions:Array = [new WalkDirection(-1,0,Config.DIRECTION_LEFT),
											new WalkDirection(1,0,Config.DIRECTION_RIGHT),
											new WalkDirection(0,-1,Config.DIRECTION_TOP),
											new WalkDirection(0,1,Config.DIRECTION_BOTTOM)];
		public function getAroundCell(cell:GemCell):Array {
			var length:int = directions.length;
			for(var i:int = 0; i < length; i++){
				var walkDirection:WalkDirection = directions[i];
				var xIndex:int = cell.cellX + walkDirection.offsetX;
				var yIndex:int = cell.cellY + walkDirection.offsetY;
				var gemCell:GemCell = model.getItem(xIndex,yIndex);
				var cellItem:CellItem = new CellItem(walkDirection.direction,gemCell); 
				if(gemCell && !this.hasObject(this.cells,cellItem) && gemCell.color == cell.color){
					cells.push(cellItem);
					this.getAroundCell(gemCell);
				}
			}
			return cells;
		}
		
		public function dispose():void {
			this.removeAllChildren();
		}
		
		public function removeAllChildren():void {
			while(this.numChildren > 0){
				this.removeChildAt(0);
			} 
		}
		
		public function relocation(list:Array,direction:int):void {
			var newCell:GemCell;
			var i:int = 0;
			if(direction == Config.V_DIRECTION){
				var head:GemCell = list[0];
				var xIndex:int = head.cellX;
				var count:int = list.length;// 消除的个数
				for(i = head.cellY; i >= 0; i--){
					var yIndex:int = i;
					newCell = model.getItem(xIndex,yIndex - count);
					if(!newCell){
						newCell = new GemCell();
						newCell.x = xIndex * Config.W;
						this.addChild(newCell);
					}
					newCell.tween(xIndex,yIndex);
				}
			}else {
				for(; i < list.length; i++){
					var cell:GemCell = list[i];
					for(var j:int = cell.cellY; j >= 0; j--) {
						newCell = model.getItem(cell.cellX,j - 1);
						if(!newCell){
							newCell = new GemCell();
							newCell.x = cell.x;
							this.addChild(newCell);
						}
						newCell.tween(cell.cellX,j);
					}
				}
			}
		}
	}
}

import flash.geom.Point;
import z.core.GemCell;

class CellItem {
	
	public var direction:int;
	
	public var cell:GemCell;
	
	public function CellItem(direction:int,cell:GemCell) {
		super();
		this.direction = direction;
		this.cell = cell;
	}
	
	public function equal(cellItem:CellItem):Boolean {
		if(this.direction == cellItem.direction && this.cell == cellItem.cell){
			return true;
		}
		return false;
	}
}

class WalkDirection {
	
	public var offsetX:int;
	
	public var offsetY:int;
	
	public var direction:int;
	
	public function WalkDirection(offsetX:int,offsetY:int,diretion:int) {
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.direction = diretion;
	}
	
}