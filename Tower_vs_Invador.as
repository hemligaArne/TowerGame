package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.*;
	
	public class Tower_vs_Invador extends Sprite
	{
		var numInvadors:uint = 3;
		private var _victory:Boolean = false;
		
		private var _tower:Tower;
		private var _towers:Array = [];
		private var _invador:WalkingInvador;
		private var _invadors:Array = [];
		
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		
		private var _projectileShot:Projectile;
		private var _projectiles:Array = [];
		private var _friction:Number = 1;//0.99;

		// dev variables ADD THESE TO CONSTRUCTOR PARAMETERS.
		public function Tower_vs_Invador()
		{
			init();
			initTower();
			initInvaders();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler)
			devInits();// tools to help during build
			
		}
		//####################################################
		//
		//                     DEV INIT'S
		//
		//####################################################
		private function devInits ():void{
			trace("Tower_vs_Invador::devInits");
			createButtons();
		}
		
		public function createButtons():void
		{
			var butt:Sprite = new Sprite();
			butt.graphics.beginFill(0xbbbbbb);
			butt.graphics.drawRect(0, 0, 200, 30);
			butt.graphics.endFill();

			addChild(butt);
			var txt:TextField = new TextField();
			txt.text = "bullet Count";

			var alignedFormat:TextFormat = new TextFormat();
			alignedFormat.align = TextFormatAlign.CENTER;
			txt.defaultTextFormat = alignedFormat;
			butt.addChild(txt);
			
			butt.addEventListener(MouseEvent.CLICK, buttClick);
			butt.buttonMode = true;
			butt.mouseChildren = false;
		}

		private function buttClick(e:MouseEvent):void
		{
			trace("\t\t\tbullets are " + _projectiles.length);
			for ( var i=0; i<_projectiles.length; i++ ) {
				trace("\t_projectiles[i].x is: "+_projectiles[i].x);
				trace("\t_projectiles[i].y is: "+_projectiles[i].y);
			};
			trace("running out of bounds and delete text");
			outOfBoundsCheckDelete(_projectiles);
			trace("\t\t\tbullets are " + _projectiles.length);
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
			trace("::init -- init of tower CORRECT TOWER");
			_tower = new Tower();
			addChild(_tower);
			_tower.x = stage.stageWidth / 2;
			_tower.y = stage.stageHeight / 2;
			_towers.push(_tower);
		}
		private function initInvaders ():void{
			//trace("Rotation::initInvadors");
			var numInvadors:uint = 15;
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
			// this moves the invadors
			for(var i:uint = 0; i< _invadors.length; i++)
			{
				brownianMotion(_invadors[i]);
			}
			outOfBoundsCheck(_invadors);
			
			for (var j:uint= 0; j < _towers.length; j++)
			{
				
				aimTowersAtEnemies(_towers[j]);
			}
			
			for (var k:uint = 0; k < _projectiles.length; k++)
			{
				//_projectiles[k].getChildAt(0).x += _projectiles[k].speed;
				_projectiles[k].x += _projectiles[k].vx;
				_projectiles[k].y += _projectiles[k].vy;
			}
			if(_projectiles.length > 0)
			{
//				trace("\t_projectiles.length is: "+_projectiles.length);
				outOfBoundsCheckDelete(_projectiles);
				hitTests(_projectiles, _invadors);
				if(_invadors.length == 0)
				{
					_victory = true;
					trace("\t\t\t\t V * I * C * T * O * R * Y");
					//stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler)
				}
			}
			if ( _projectiles.length == 0 && _invadors.length == 0)
			{
				stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler)
				// dispatch BATTLE_WON event
			}
			
		}
		//####################################################
		//
		//                ENTER FRAME SUB CALLS
		//
		//####################################################
		
		private function outOfBoundsCheck (_arr:Array):void{
			//trace("Tower_vs_Invador::outOfBoundsCheck");
			for ( var i:uint =0; i<_arr.length; i++ ) {
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
		
		private function outOfBoundsCheckDelete (_arr:Array):void
		{
//			trace("Tower_vs_Invador::outOfBoundsCheckDelete");
			for ( var i:uint = _arr.length ; i > 0; i--) 
			{
				var j:uint = i - 1;
				var removeFlag:Boolean = false;
				if(_arr[j].x - _arr[j].width / 2 > _right || _arr[j].x + _arr[j].width / 2 < _left || _arr[j].y - _arr[j].height / 2 > _bottom  ||  _arr[j].y + _arr[j].height / 2 < _top)
				{
					removeFlag = true;
				}
				if (removeFlag == true) removeContent(j);
			};
			function removeContent(count:uint):void
			{
				removeChild(_arr[count]);
				_arr[count] = null;
				_arr.splice(count, 1);
			}
		}
		private function hitTests ($projectile:Array, $target:Array):void{
//			trace("Tower_vs_Invador::hitTests");
			var targetHit:Boolean = false;
			for(var i:uint = $projectile.length; i > 0 ; i--)
			{
				var i_index:uint = i - 1;
				for (var j:uint = $target.length; j > 0; j--)
				{
					var jindex:uint = j - 1;
					if($target[jindex].characterBmpData.hitTest (new Point ( $target[jindex].x, $target[jindex].y), 255, 					
					$projectile[i_index].projectileClipBmpData, new Point ( $projectile[i_index].x, $projectile[i_index].y ), 255 ))
					{
						var temp:WalkingInvador = $target[jindex];
						removeChild(temp);
						$target.splice(jindex, 1);
						temp = null;
						var temp2:Projectile = $projectile[i_index];
						removeChild(temp2);
						temp2 = null;
						$projectile.splice(i_index, 1);
					}
				}
			}
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
			for (var i:uint = 1 ; i < invadorLength ; i++ )
			{
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
			}
			
			$thisTower.rotation = Math.atan2(shortestLength[3], shortestLength[2]) * (180 / Math.PI);
			if(shortestLength[1] < $thisTower._fireRange)
			{
				//tower will fire :
				if ($thisTower.fireAtWill == true)
				{
					$thisTower.commenceFire();
					_projectileShot = new Projectile($thisTower.rotation, $thisTower.ammunitionType);
					addChild(_projectileShot);
					_projectileShot.x = $thisTower.x;
					_projectileShot.y = $thisTower.y;
					_projectiles.push(_projectileShot);
				}
			}
		}		
	}
}