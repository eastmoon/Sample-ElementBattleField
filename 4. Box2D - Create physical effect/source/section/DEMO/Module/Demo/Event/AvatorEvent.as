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
	import section.DEMO.Module.Demo.Space.pattern.GeometrySpace;
	import section.DEMO.Module.Demo.Actor.AvatorActor;
	import section.DEMO.Module.Demo.Actor.ChessActor;
	
	/*external import*/
	public dynamic class AvatorEvent extends RMEvent
	{
		/*static const variable : 靜態常數變數*/
		public static const TOUCH : String = "AvatorTouchBattleField";
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
				case AvatorEvent.TOUCH:
				{
					// 點擊事件
					// 1 取回 Avator Actor
					var avator : AvatorActor = a_vars.getModule().RetrieveActor( AvatorActor.NAME ) as AvatorActor;
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
							// 3.1.2 釋放單位
							if( this.m_waitForActor != null )
							{
								this.m_waitForActor.splice( 0, this.m_waitForActor.length );
								this.m_waitForActor = null;
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
						else if( this.m_waitForActor != null )
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
										this.m_waitForActor[i] = null;
									}
								}
								// 完成動作，釋放等待單位
								this.m_waitForActor.splice( 0, this.m_waitForActor.length );
								this.m_waitForActor = null;
							}
						}
					
					}
				}
			}
		}
		/*private event function：私用事件函數*/
		
		/*private function：私用函數*/
		
	}
}
/*end of package*/