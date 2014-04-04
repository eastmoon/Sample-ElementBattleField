/*
	Info:
		
	Usage:(有開放public 讓外部使用)
		
	Date:
		- 9999.99.99
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/
package section.DEMO.Module.Demo.Space
{
	/*import*/
	/*import：Flash內建元件庫*/
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/*external import：外部元件庫、開發人員自定元件庫*/
	import org.gra.model.RuleModel.Core.*;
	import org.gra.model.RuleModel.Interface.*;
	import section.DEMO.Module.Demo.Actor.AvatorActor;
	import section.DEMO.Module.Demo.Actor.ChessActor;

	/*external import*/
	public dynamic class GeometrySpace extends RMSpace
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_color : uint;
		private var m_isFocus : Boolean;
		/*display object variable：顯示物件變數，如MovieClip等*/
		
		/*constructor：建構值*/
		public function GeometrySpace() : void
		{
			// 初始空間資料
			super( new RMSpaceVar( 0, 0, 0, 500, 500, 0 ) );
			// 登記事件
			this.AddNotify( RMNotify.DRAW , this.NotifyDraw );
			this.AddNotify( RMNotify.UPDATE , this.NotifySpaceUpdate );
			this.AddNotify( RMNotify.UPDATE , this.NotifyActorUpdate );
			
			// 初始化數據
			this.m_isFocus = false;
			this.m_color = 0xff00aaff;
		}
		
		/*public function：對外公開函數*/
		public override function RetrieveObject( a_spaceVar : IRMSpaceVar ) : Array
		{
			var i : Number = 0, j : Number = 0, k : Number = 0;
			var objects : Array = new Array();
			var actors : Array = this.getActors();
			var spaceVar : IRMSpaceVar = null;
			
			// check actor
			for( i = 0 ; i < actors.length ; i++ )
			{
				if( actors[i] is IRMActor )
				{
					// 取回角色對此空間相對的座標
					spaceVar = (actors[i] as IRMActor).RetrieveSpaceVar( this.getName() );
					
					// 若座標物件不為空
					if( spaceVar != null )
					{
						// 計算歐式距離
						j = a_spaceVar.getX() - spaceVar.getX();
						k = a_spaceVar.getY() - spaceVar.getY();
						j = Math.sqrt( j * j + k * k ) - spaceVar.getWidth();
						// 在範圍內取得目標物
						if( j <= a_spaceVar.getWidth())
						{
							objects.push( actors[i] );
						}
					}
				}
			}			
			return objects;
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		public function set isFocus( a_isFocus : Boolean ) : void
		{
			this.m_isFocus = a_isFocus;
		}
		public function get isFocus() : Boolean
		{
			return this.m_isFocus;
		}
		/*private event function：私用事件函數*/
		private function NotifyDraw( a_notification : RMNotification ) : void
		{
			var i : Number = 0, j : Number = 0, k : Number = 0;		
			var panel : BitmapData = a_notification.getBody() as BitmapData;
			var color : uint = this.m_color;
			
			// 1. Draw Panel
			if( this.m_isFocus )
				panel.fillRect( new Rectangle(this.getX(), this.getY(), this.getWidth(), this.getHeight()), color & 0xddffffff );
			else
				panel.fillRect( new Rectangle(this.getX(), this.getY(), this.getWidth(), this.getHeight()), color & 0xffffffff );
				
			// 2. Draw Actor	
			for( i = 0 ; i < this.getActors().length ; i++ )
			{
				(this.getActors()[i] as RMActor).SendNotify( a_notification );
			}
		}
		private function NotifyActorUpdate( a_notification : IRMNotification ) : void
		{
			// 1. Update Actor
			var i : Number = 0, j : Number = 0, k : Number = 0;			
			for( i = 0 ; i < this.getActors().length ; i++ )
			{
				(this.getActors()[i] as RMActor).SendNotify( new RMNotification( a_notification.getName(), this ) );
			}
			
			// 2. Focus Actor
			// 2.1 取回 Avator Actor
			var avator : AvatorActor = this.getModule().RetrieveActor( "AvatorActor" ) as AvatorActor;
			// 2.2 計算空間內角色
			var objects : Array = avator.focusActor;
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
		private function NotifySpaceUpdate( a_notification : IRMNotification ) : void
		{
			// 2. Update Space
			var i : Number = 0, j : Number = 0, k : Number = 0;
		}
		/*private function：私用函數*/
	}
}
/*end of package*/