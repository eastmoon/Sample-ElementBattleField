/*
	Info:
		
	Date:
		- 9999.99.99
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/
package section.DEMO.Module.Demo.Actor
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
	import org.gra.model.RuleModel.Core.RMActor;
	import org.gra.model.RuleModel.Core.RMNotify;
	import org.gra.model.RuleModel.Core.RMNotification;
	import org.gra.model.RuleModel.Core.RMSpace;
	import org.gra.model.RuleModel.Core.RMSpaceContainer;
	import org.gra.model.RuleModel.Core.RMSpaceVar;
	import org.gra.model.RuleModel.Interface.IRMSpaceVar;
	import section.DEMO.Module.Demo.Space.GeometrySpace;
	import org.gra.model.RuleModel.Interface.IRMActor;

	/*external import*/
	public dynamic class AvatorActor extends RMActor
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_radius : Number;
		private var m_rect : Rectangle;
		private var m_isFocus : Boolean;
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_sprite : Sprite;
		
		/*constructor：建構值*/
		public function AvatorActor() : void
		{
			// 登記事件
			// 取得通告
			this.AddNotify( RMNotify.UPDATE , this.NotifyUpdate );
			// 處理指定來源者的通告
			// 注意：繪製時應指定繪製要求的Space為何，使物件能針對目標進行繪製。
			this.AddNotifyByNotifier( "GeometrySpace", RMNotify.DRAW, this.NotifyDraw );
			
			// 初始化數據
			this.m_radius = 50;
			this.m_rect = new Rectangle( 0, 0, this.m_radius, this.m_radius );
			this.m_isFocus = false;
			
			// 繪製圖件
			this.mc_sprite = new Sprite();
			this.mc_sprite.graphics.beginFill( 0x000000, .25 );
			this.mc_sprite.graphics.drawCircle(0, 0, this.m_radius);
			this.mc_sprite.graphics.endFill();
		}
		
		/*public function：對外公開函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public function get width() : Number
		{
			return this.m_rect.width;
		}
		public function get height() : Number
		{
			return this.m_rect.height;
		}
		/*read/write：讀寫*/
		public function set x( a_x : Number ) : void
		{
			this.m_rect.x = a_x;
		}
		public function get x() : Number
		{
			return this.m_rect.x;
		}
		
		public function set y( a_y : Number ) : void
		{
			this.m_rect.y = a_y;
		}
		public function get y() : Number
		{
			return this.m_rect.y;
		}
		
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
			// 1. 指定為特定Space為Notifier時執行。
			// 2. 取得繪製區域
			var panel : BitmapData = a_notification.getBody() as BitmapData;
			// 3. 取回Notifier相關的座標儲存資料結構( SpaceVar )
			// 4. 繪製
			panel.draw( this.mc_sprite, new Matrix( 1, 0, 0, 1, this.x, this.y) );
			//trace(" draw targetActor ");
		}
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
		/*private function：私用函數*/
	}
}
/*end of package*/