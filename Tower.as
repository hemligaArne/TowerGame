package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	public class Tower extends Sprite
	{
		[Embed (source="Tower.png", mimeType="image/png")]
		private var ImageAsset:Class;
		
//		private var _towerGraphic:Class; // IS THIS NEEDED really?
		
		private var _aimDistance:Number;
		public var _fireRange:Number;
		private var _reloadTimer:Timer;
		private var _reloadTime:Number = 500;
		public var fireAtWill:Boolean = true;
		
		internal var ammunitionType:String = "SLING_SHOT";
		
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
//			trace("Tower::init");
			_fireRange = 500;
		}
		
		public function commenceFire():void
		{
			fireAtWill = false;
			_reloadTimer = new Timer(_reloadTime, 1);
			_reloadTimer.addEventListener(TimerEvent.TIMER, towerReloaded);
			_reloadTimer.start();
		}
		
		private function towerReloaded (e:TimerEvent):void{
//			trace("Tower::towerReloaded");
			e.currentTarget.stop();
			e.currentTarget.removeEventListener(TimerEvent.TIMER, towerReloaded);
			fireAtWill = true;
		}
		private function drawPointer ():void{
//			trace("Tower::drawPointer");
			graphics.lineStyle(1);
			graphics.moveTo(0, 0);
			graphics.lineTo(50, 0);
		}
	}
}