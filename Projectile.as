package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class Projectile extends Sprite
	{
	
		[Embed (source="graphics/projectiles/pebble.png", mimeType="image/png")]
		private var ProjectilePebble:Class;
		
/*		[Embed (source="graphics/projectiles/arrow.png", mimeType="image/png")]
		private var ProjectileArrow:Class;
		
		[Embed (source="graphics/projectiles/fireArrow.png", mimeType="image/png")]
		private var ProjectileFireArrow:Class;
		
		[Embed (source="graphics/projectiles/stone.png", mimeType="image/png")]
		private var ProjectileStone:Class;
		
		[Embed (source="graphics/projectiles/flamingStone.png", mimeType="image/png")]
		private var ProjectileFlamingStone:Class;
		
		[Embed (source="graphics/projectiles/ballista.png", mimeType="image/png")]
		private var ProjectileStone:Class;
		
		[Embed (source="graphics/projectiles/catapult.png", mimeType="image/png")]
		private var ProjectileCatapult:Class;
*/		
		private var _projectileGraphic:Class;
		
		internal var vx:Number;
		internal var vy:Number;
		
		private var _angle:Number;
		private var _type:String;
		public var speed:Number = 10;
		private var _damage:Number = 5;
		public var projectileClipBmpData:BitmapData;
		
		
//		public function Projectile()		
		public function Projectile($angle:Number, $type:String)
		{
			trace("inside the projectile class")
			_angle = $angle;
			_type = $type;
			init();
		}
		private function init ():void
		{
			trace("Projectile::init");
			var _projectileGraphic:Bitmap = new ProjectilePebble();
			addChild(_projectileGraphic);
			_projectileGraphic.x -= _projectileGraphic.width;
			_projectileGraphic.y -= _projectileGraphic.height;
			
			vx = Math.cos(_angle * Math.PI / 180) * speed;
			vy = Math.sin(_angle * Math.PI / 180) * speed;
			
			var bulletRect:Rectangle = _projectileGraphic.getBounds(this);
			projectileClipBmpData = new BitmapData(bulletRect.width, bulletRect.height, true, 0);
			projectileClipBmpData.draw(_projectileGraphic);
//			trace("\tvx is: "+vx);
//			trace("\tvy is: "+vy);
//			_projectileGraphic.rotation = _angle;
			
		}
	}
}