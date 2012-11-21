package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Tower_vs_Invador extends Sprite
	{
//		private var _tower:Tower = new Tower();
		private var _tower:Tower;
		private var _invador:WalkingInvador;
		private var _invadors:Array;
		
		private var _friction:Number = 0.99;
		
		public function Tower_vs_Invador()
		{
			initTower();
			initInvaders();
		}
		
		private function initTower ():void{
			trace("::init");
			_tower = new Tower();
			addChild(_tower);
			_tower.x = stage.stageWidth / 2;
			_tower.y = stage.stageHeight / 2;
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler)
		}
		private function initInvaders ():void{
			trace("Rotation::initInvadors");
			_invador = new WalkingInvador();
			addChild(_invador);
			_invador.vx = 2;
			_invador.vy = 2;
			_invador.x = Math.random() * (stage.stageWidth - 100) + 50;
			_invador.y = Math.random() * (stage.stageHeight - 100) + 50;
		}
		
		private function onEnterFrameHandler (e:Event):void{
//			brownianMotion(_invador);
			forwardRandomTurn(_invador);
			
			// tower "pointing" at the invador
			var dx:Number = _invador.x - _tower.x;
			var dy:Number = _invador.y - _tower.y;
			_tower.rotation  = Math.atan2(dy, dx) * (180 / Math.PI);
			//trace("\t angle is: "+ _tower.rotation);
		}
		
		private function brownianMotion(_sprite:WalkingInvador):void
		{
			_sprite.vx += Math.random() * 0.2 - 0.1;
			_sprite.vy += Math.random() * 0.2 - 0.1;
			_sprite.x += _sprite.vx;
			_sprite.y += _sprite.vy;
			
			_sprite.vy *= _friction;
			_sprite.vx *= _friction;			
		}
		private function forwardRandomTurn (_sprite:WalkingInvador):void{
			trace("Tower_vs_Invador::forwardRandomTurn");
			_sprite.y += _sprite.vy;
			_sprite.rotation += Math.random() * 10 - 5;
		}
	}
}