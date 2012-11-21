package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class Tower extends Sprite
	{
		[Embed (source="Tower.png", mimeType="image/png")]
		private var ImageAsset:Class;
		
		private var _towerGraphic:Class;
		
		private var _aimDistance:Number;
		public var _fireRange:Number;
		
		public function Tower()
		{
			var towerGraphic:Bitmap = new ImageAsset();
			addChild(towerGraphic);
			towerGraphic.x = (towerGraphic.width / 2) * -1;
			towerGraphic.y = (towerGraphic.height / 2) * -1;			
			
			init();
			drawPointer();
		}
		
		private function init ():void{
			trace("Tower::init");
			_fireRange = 200;
		}
		
		private function drawPointer ():void{
			trace("Tower::drawPointer");
			graphics.lineStyle(1);
			graphics.moveTo(0, 0);
			graphics.lineTo(50, 0);
		}
	}
}