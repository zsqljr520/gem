package z.core
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import z.utils.DisplayUtil;

	public class GemScene extends Sprite implements IDispose
	{
		private var model:GameModel = GameModel.instance;
		
		private var dictionary:Dictionary = new Dictionary(true);// 检测死局的数据
		
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
				this.checkCell(cell);
			}
		}
		
		public function checkCell(cell:GemCell):void {
			trace("cell.cellX : " + cell.cellX + ",cell.cellY : " + cell.cellY);
			var object:Object = this.getLineCells(cell);
			var hLineCells:Array = object.h;
			var vLineCells:Array = object.v;
			var buildable:Boolean;
			if(hLineCells.length >= Config.MIN_REMOVED_COUNT && vLineCells.length >= Config.MIN_REMOVED_COUNT){// 会有同样的一个数据在里面
				buildable = true;
				for(var i:int = 0; i < hLineCells.length; i++){
					var target:GemCell = hLineCells[i];
					if(target == cell){
						hLineCells.splice(i,1);
					}
				}
			}
			this.rebuild(vLineCells,Config.V_DIRECTION);
			this.rebuild(hLineCells,Config.H_DIRECTION);
			this.replace();
			trace("this.numChildren : " + this.numChildren);
		}
		
		private function getLineCells(cell:GemCell):Object {
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
			return {h:hLineCells,v:vLineCells};
		}
		
		private function rebuild(v:Array,direction:int,buildable:Boolean = false):void {
			if(v.length >= Config.MIN_REMOVED_COUNT || buildable){
				var cell:GemCell;
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
			var cell:GemCell;
			for(var i:int = 0; i < Config.row; i++){
				startY = i * Config.H;
				var startX:Number = 0;
				for(var j:int = 0; j < Config.column; j++){
					cell = this.generateGemCell();
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
			this.replace();
		}
		
		public function hasObject(cellItem:CellItem):Boolean {
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
		
		private var cells:Array = [];
		
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
				if(gemCell && !this.hasObject(cellItem) && gemCell.color == cell.color){
					cells.push(cellItem);
					this.getAroundCell(gemCell);
				}
			}
			return cells;
		}
		
		public function dispose():void {
			this.removeEventListener(MouseEvent.CLICK,checkCellHandler);
			DisplayUtil.removeAllChildren(this);
		}
		
		private function generateGemCell():GemCell {
			var cell:GemCell = new GemCell();
			var index:int = Math.floor(Math.random() * Config.colors.length);
			cell.color = Config.colors[index];
			return cell;
		}
		
		/**
		 * 生成新的数据
		 */ 
		public function replace():void {
			/* if(this.checkIsStalemate(0,0)){
				var cell:GemCell;
				for(var i:int = 0; i < Config.MIN_CLEAR_UP_LINE; i++){
					var cellX:int = MathUtil.random(1,Config.column - 1);
					var cellY:int = MathUtil.random(1,Config.row - 1);
					cell = model.getItem(cellX,cellY);
					var leftCell:GemCell = model.getItem(cellX - 1,cellY);
					if(leftCell){
						leftCell.color = cell.color;
					}
					var rightCell:GemCell = model.getItem(cellX + 1,cellY);
					if(rightCell){
						rightCell.color = cell.color;
					}
				}
			} */
		}
		
		/**
		 * 检测是否是死局
		 */ 
		public function checkIsStalemate(cellX:int,cellY:int):Boolean {
			for(var i:int = 0; i < model.items.length; i++){// 先把数据分组
				var list:Array = model.items[i];
				for(var j:int = 0; j < list.length; j++){
					var item:GemCell = list[i];
					if(this.dictionary[item.color] == null){
						this.dictionary[item.color] = new Group(item.color);
					}
					Group(this.dictionary[item.color]).addItem(item);
				}
			}
			for(var key:* in dictionary){
				var group:Group = dictionary[key];
				if(group.checkEnabled){
					for each(var cell:GemCell in group.list){
						var object:Object = this.getLineCells(cell);
						if(object.h.length >= Config.MIN_REMOVED_COUNT ||
							object.v.length >= Config.MIN_REMOVED_COUNT){
							return false;
						}
					}
				}
			}
			return true;
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
						newCell = this.generateGemCell();
						newCell.x = xIndex * Config.W;
						this.addChild(newCell);
					}
					if(newCell){
						newCell.tween(xIndex,yIndex);
					}
					 
				}
			}else { 
				for(; i < list.length; i++){
					var cell:GemCell = list[i];
					for(var j:int = cell.cellY; j >= 0; j--) { 
						newCell = model.getItem(cell.cellX,j - 1);
						if(!newCell){
							newCell = this.generateGemCell();
							newCell.x = cell.x;
							this.addChild(newCell);
						}
						if(newCell){
							newCell.tween(cell.cellX,j);
						}
					}
				}
			}
		}
	}
}

import flash.geom.Point;
import z.core.GemCell;
import z.core.Config;

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

class Group {
	public var key:*;
	
	public var list:Array = [];
	
	public function Group(key:*) {
		this.key = key;
	}
	
	public function addItem(value:*):void {
		list.push(value);
	}
	
	public function get checkEnabled():Boolean {
		return this.list.length >= Config.MIN_REMOVED_COUNT;
	}
}