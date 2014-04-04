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
	import org.gra.ApplicationFacade;
	import org.gra.model.RuleModel.Core.*;
	import org.gra.model.RuleModel.Interface.*;
	import section.DEMO.Module.OperatorModule;
	import section.DEMO.Module.Demo.Space.GeometrySpace;
	import section.DEMO.Module.Demo.Event.AvatorEvent;
	
	/*external import*/
	public dynamic class AvatorActor extends RMActor
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_radius : Number;
		private var m_rect : Rectangle;
		private var m_focusObjects : Array;
		private var m_focusSpace : IRMSpace;
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_sprite : Sprite;
		
		/*constructor：建構值*/
		public function AvatorActor() : void
		{
			// 登記事件
			// 登錄操作模組事件
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			var module : RMModule = null;
			if( app.hasModule( "OperatorModule" ) )
			{
				trace( "register operator" );
				module = app.retrieveModule("OperatorModule");
				module.AddNotify( OperatorModule.TARGET_MOVE, this.NotifyActionByOperatorModule );
				module.AddNotify( OperatorModule.TARGET_FOCUS, this.NotifyActionByOperatorModule );
			}
			
			// 取得通告
			this.AddNotify( RMNotify.UPDATE , this.NotifyUpdate );
			
			// 處理指定來源者的通告
			// 注意：繪製時應指定繪製要求的Space為何，使物件能針對目標進行繪製。
			this.AddNotifyByNotifier( "GeometrySpace", RMNotify.DRAW, this.NotifyDraw );
			
			// 初始化數據
			this.m_radius = 5;
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
		
		public function get focusActor() : Array
		{
			return this.m_focusObjects;
		}
		
		public function get focusSpace() : IRMSpace
		{
			return this.m_focusSpace;
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
			// 1. 取得對應空間
			this.m_focusSpace = a_notification.getBody() as IRMSpace;
			// 2. 計算對應空間關注的目標
			this.m_focusObjects = this.m_focusSpace.RetrieveObject( new RMSpaceVar( this.x, this.y, 0, this.m_radius, this.m_radius ) );
		}
		/*private function：私用函數*/
		private function NotifyActionByOperatorModule( a_notification : RMNotification ) : void
		{
			switch( a_notification.getType() )
			{
				case OperatorModule.TARGET_MOVE :
				{
					//trace( "DemoModuel target move" );
					this.x = (a_notification.getBody() as Point).x;
					this.y = (a_notification.getBody() as Point).y;
				}
				break;
				case OperatorModule.TARGET_FOCUS :
				{
					trace( "DemoModuel target focus" );
					this.getModule().ExecuteEvent( new RMEventVar( AvatorEvent.Touch, this.getModule() ) );
				}
				break;
			}
		}
	}
}
/*end of package*/