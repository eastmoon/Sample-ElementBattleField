/*
	Info:
		
	Date:
		- 9999.99.99
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/
package section.DEMO.Module.Demo.Event
{
	/*import*/
	/*import：Flash內建元件庫*/
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/*external import：外部元件庫、開發人員自定元件庫*/
	import org.gra.ApplicationFacade;
	import org.gra.model.RuleModel.Core.*;
	import org.gra.model.RuleModel.Interface.*;
	import section.DEMO.Module.OperatorModule;
	import section.DEMO.Module.Demo.Space.GeometrySpace;
	import section.DEMO.Module.Demo.Actor.AvatorActor;
	import section.DEMO.Module.Demo.Actor.ChessActor;
	
	/*external import*/
	public dynamic class AvatorEvent extends RMEvent
	{
		/*static const variable : 靜態常數變數*/
		public static const Touch : String = "AvatorTouchBattleField";
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_waitForActor : Array;
		/*display object variable：顯示物件變數，如MovieClip等*/
		
		/*constructor：建構值*/
		public function AvatorEvent() : void
		{
		}
		
		/*public function：對外公開函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public override function Execute( a_vars : IRMEventVar ) : void
		{
			var i : Number = 0, j : Number = 0, k : Number = 0;	
			
			switch( a_vars.getName() )
			{
				case AvatorEvent.Touch:
				{
					// 點擊事件
					// 1 取回 Avator Actor
					var avator : AvatorActor = a_vars.getModule().RetrieveActor( "AvatorActor" ) as AvatorActor;
					var chess : ChessActor = null;
					// 2 取回 space
					var space : RMSpace = avator.focusSpace as RMSpace;
					
					// 3. 計算是否有角色在點擊區內
					if( avator != null && space != null )
					{
						var objects : Array = avator.focusActor;
						if( objects.length )
						{
							// 3.1 存有角色，設角色為等待命令
							// 3.1.1 解除之前角色的等待
							for( i = 0 ; this.m_waitForActor != null && i < this.m_waitForActor.length ; i++ )
							{
								chess = this.m_waitForActor[i] as ChessActor;
								if( chess != null )
								{
									chess.CommandWaitFor( false );
								}
							}
							
							this.m_waitForActor = objects;
							
							// 3.1.2 設定新角色的等待
							for( i = 0 ; i < this.m_waitForActor.length ; i++ )
							{
								chess = this.m_waitForActor[i] as ChessActor;
								if( chess != null )
								{
									chess.CommandWaitFor( true );
								}
							}
						}
						else
						{
							// 3.2 不存有角色，若再空間區域內，且有角色等待命令，移動角色。
							// 在空間範圍內
							if( avator.x >= 0 && avator.x <= space.getWidth() && avator.y >= 0 && avator.y <= space.getHeight() )
							{
								for( i = 0 ; i < this.m_waitForActor.length ; i++ )
								{
									chess = this.m_waitForActor[i] as ChessActor;
									if( chess != null )
									{
										chess.CommandMoveTo( avator.x, avator.y, avator.focusSpace.getName() );
									}
								}
							}
						}
					
					}
				}
			}
		}
		/*private event function：私用事件函數*/
		/*
		private function NotifyUpdate( a_notification : RMNotification ) : void
		{			
			var i : Number = 0, j : Number = 0, k : Number = 0;
			var space : GeometrySpace = a_notification.getBody() as GeometrySpace;
			// 若存在於空間內才計算
			if( this.x >= space.getX() && this.x <= space.getX() + space.getWidth() &&
			   this.y >= space.getY() && this.y <= space.getY() + space.getHeight() )
			{
				var objects : Array = space.RetrieveObject( new RMSpaceVar( this.x, this.y, 0, this.m_radius, this.m_radius ) );
				
				var target : ChessActor = null;
				for( i = 0 ; objects != null && i < objects.length ; i++ )
				{
					if( objects[i] is ChessActor )
					{
						target = objects[i] as ChessActor;
						if( target != null )
							target.isFocus = true;
					}
				}
			}
		}
		*/
		/*private function：私用函數*/
		
	}
}
/*end of package*/