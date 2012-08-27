package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import z.core.GemScene;
	
	/**
	 * 1.增加自动掉落的检测
	 * 2.增加2个方向的检测
	 * 3.替换UI
	 * 4.优化算法
	 */ 
	[SWF(width=600,height=600,backgroundColor="0x000000",frameRate="30")]
	public class GemGame extends Sprite
	{
		private var scene:GemScene;
		
		public function GemGame()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			scene = new GemScene();
			scene.x = (this.stage.stageWidth - scene.width) >> 1;
			scene.y = (this.stage.stageHeight - scene.height) >> 1;
			this.addChild(scene);
		}
	}
}
