package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class Tower_vs_Invador extends Sprite
	{
		private var _tower:Tower = new Tower();
		private var _towers:Array = [];
		private var _invador:WalkingInvador;
		private var _invadors:Array = [];
		
		private var _left:uint;
		private var _right:uint;
		private var _top:uint;
		private var _bottom:uint;
		
		private var _friction:Number = 1;//0.99;

		// dev variables ADD THESE TO CONSTRUCTOR PARAMETERS.
		
		
		public function Tower_vs_Invador()
		{
			init();
			initTower();
			initInvaders();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler)
		}
		
		
		//####################################################
		//
		//                     INIT'S
		//
		//####################################################
		
		private function init ():void{
			//trace("Tower_vs_Invador::init");
			_left = 0;
			_right = stage.stageWidth;
			_top = 0;
			_bottom = stage.stageHeight;
		}
		
		private function initTower ():void{
			//trace("::init");
			_tower = new Tower();
			addChild(_tower);
			_tower.x = stage.stageWidth / 2;
			_tower.y = stage.stageHeight / 2;
			_towers.push(_tower);
		}
		private function initInvaders ():void{
			//trace("Rotation::initInvadors");
			var numInvadors:uint = 5;
			for ( var i:uint = 0; i<numInvadors; i++ ) {
				_invador = new WalkingInvador();
				addChild(_invador);
				_invador.vx = Math.random() * 4 - 2;
				_invador.vy = Math.random() * 4 - 2;
				_invador.x = Math.random() * (stage.stageWidth - 100) + 50;
				_invador.y = Math.random() * (stage.stageHeight - 100) + 50;

				_invadors.push(_invador);
			};
		}
		
		//####################################################
		//
		//                ENTER FRAME HANDLER
		//
		//####################################################
		
		private function onEnterFrameHandler (e:Event):void{
			for(var i:uint = 0; i< _invadors.length; i++)
			{
				brownianMotion(_invadors[i]);
			}
			outOfBoundsCheck(_invadors);
			
			for (var j:uint= 0; j < _towers.length; j++)
			{
				aimTowersAtEnemies(_towers[j]);
			}
			
		}
		//####################################################
		//
		//                ENTER FRAME SUB CALLS
		//
		//####################################################
		
		private function outOfBoundsCheck (_arr:Array):void{
			//trace("Tower_vs_Invador::outOfBoundsCheck");
			for ( var i=0; i<_arr.length; i++ ) {
				if(_arr[i].x - _arr[i].width / 2 > _right )
				{
					_arr[i].x = _left - _arr[i].width / 2;
				}
				else if (_arr[i].x + _arr[i].width / 2 < _left)
				{
					_arr[i].x = _right + _arr[i].width / 2;
				}
				if(_arr[i].y - _arr[i].height / 2 > _bottom )
				{
					_arr[i].y = _top - _arr[i].height / 2;
				}
				else if (_arr[i].y + _arr[i].height / 2 < _top)
				{
					_arr[i].y = _bottom + _arr[i].height / 2;
				}
				
			};
		}
		
		private function brownianMotion(_sprite:WalkingInvador):void
		{
			var oldLocationX:Number = _sprite.x;
			var oldLocationY:Number = _sprite.y;
			_sprite.vx += Math.random() * 0.2 - 0.1;
			_sprite.vy += Math.random() * 0.2 - 0.1;
			_sprite.x += _sprite.vx;
			_sprite.y += _sprite.vy;
			_sprite.rotation = Math.atan2((oldLocationY - _sprite.y), (oldLocationX - _sprite.x)) * (180 / Math.PI);
			
			_sprite.vy *= _friction;
			_sprite.vx *= _friction;			
		}
		
		private function aimTowersAtEnemies($thisTower:Tower):void
		{
			// locate enemies : 
			var invadorLength:uint = _invadors.length;
			var tempDX:Number = _invadors[0].x - $thisTower.x;
			var tempDY:Number= _invadors[0].y - $thisTower.y;
			var tempDistance:Number;
			var shortestLength:Array = [];
			shortestLength[0] = 0;
			shortestLength[1] = Math.sqrt(tempDX * tempDX + tempDY * tempDY);
			shortestLength[2] = tempDX;
			shortestLength[3] = tempDY;
//			shortestLength[1] = Math.atan2(dy, dx);
			for (var i:uint = 1 ; i < invadorLength ; i++ )
			{
				trace("invadors is " + i);
				tempDX = _invadors[i].x - $thisTower.x;
			 	tempDY = _invadors[i].y - $thisTower.y;
				tempDistance = Math.sqrt(tempDX * tempDX + tempDY * tempDY);
				if (shortestLength[1] > tempDistance)
				{
					shortestLength[0] = i;
					shortestLength[1] = tempDistance;
					shortestLength[2] = tempDX;
					shortestLength[3] = tempDY;
				}
//				var _invadors.x - $thisTower.x;
			}
			
			$thisTower.rotation = Math.atan2(shortestLength[3], shortestLength[2]) * (180 / Math.PI)
			// tower "pointing" at the invador
//			var dx:Number = _invador.x - _tower.x;
//			var dy:Number = _invador.y - _tower.y;
//			_tower  = Math.atan2(dy, dx) * (180 / Math.PI);
			
		}
		
	}
}