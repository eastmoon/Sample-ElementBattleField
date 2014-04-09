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
	import section.DEMO.Module.Demo.Actor.*;
	import section.DEMO.Module.Demo.Space.pattern.GeometrySpace;
	import section.DEMO.Module.Demo.Space.variable.B2DWorld;
	import Box2D.Dynamics.b2World;

	/*external import*/
	public dynamic class Battlefield extends GeometrySpace
	{
		/*static const variable : 靜態常數變數*/
		public static const NAME : String = "EBF_Battlefield";
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		// 物理世界
		private var m_world : B2DWorld;
		
		/*display object variable：顯示物件變數，如MovieClip等*/
		
		/*constructor：建構值*/
		public function Battlefield( a_width : Number, a_height : Number ) : void
		{
			// 初始空間資料
			super( a_width, a_height );
			// 登記事件
			this.AddNotify( RMNotify.DRAW , this.NotifyDraw );
			this.AddNotify( RMNotify.UPDATE , this.NotifyUpdate );
			
			// 初始化數據
			this.m_world = new B2DWorld( this, true );
			this.m_world.SetBoarder( this.getWidth(), this.getHeight() );
		}
		
		/*public function：對外公開函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public function get physicsWorld() : B2DWorld
		{
			return this.m_world;
		}
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		private function NotifyDraw( a_notification : RMNotification ) : void
		{
			var i : Number = 0, j : Number = 0, k : Number = 0;		
			var panel : BitmapData = a_notification.getBody() as BitmapData;
			
			// 1. Draw Panel
			if( this.m_world.debugStage != null )
				panel.draw( this.m_world.debugStage );
			else
				panel.fillRect( new Rectangle(this.getX(), this.getY(), this.getWidth(), this.getHeight()), 0xff00aaff & 0xffffffff );
				
			
			// 2. Draw Actor	
			for( i = 0 ; i < this.getActors().length ; i++ )
			{
				(this.getActors()[i] as RMActor).SendNotify( a_notification );
			}
		}
		
		private function NotifyUpdate( a_notification : IRMNotification ) : void
		{
			// 2. Update Space
			var i : Number = 0, j : Number = 0, k : Number = 0;
			// 2.1 Update phy world
			this.m_world.Update();
		}
		/*private function：私用函數*/
	}
}
/*end of package*/