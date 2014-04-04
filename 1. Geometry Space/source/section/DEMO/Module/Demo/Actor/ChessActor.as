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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	/*external import：外部元件庫、開發人員自定元件庫*/
	import org.gra.model.RuleModel.Core.RMActor;
	import org.gra.model.RuleModel.Core.RMNotify;
	import org.gra.model.RuleModel.Core.RMNotification;
	import org.gra.model.RuleModel.Core.RMSpace;
	import org.gra.model.RuleModel.Core.RMSpaceContainer;
	import org.gra.model.RuleModel.Core.RMSpaceVar;
	import org.gra.model.RuleModel.Interface.IRMSpaceVar;
	import section.DEMO.Module.Demo.Space.GeometrySpace;
	import flash.geom.Matrix;
	import org.gra.model.RuleModel.Interface.IRMSpace;

	/*external import*/
	public dynamic class ChessActor extends RMActor
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_radius : Number;
		private var m_speed : Number;
		private var m_isFocus : Boolean;
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_sprite : Sprite;
		private var mc_focusSprite : Sprite;
		
		/*constructor：建構值*/
		public function ChessActor() : void
		{
			// 登記事件
			// 取得通告
			this.AddNotify( RMNotify.UPDATE , this.NotifyUpdate );
			// 處理指定來源者的通告
			// 注意：繪製時應指定繪製要求的Space為何，使物件能針對目標進行繪製。
			this.AddNotifyByNotifier( "GeometrySpace", RMNotify.ADD_TO_SPACE, this.NotifyAddToSpace );
			this.AddNotifyByNotifier( "GeometrySpace", RMNotify.DRAW, this.NotifyDraw );
			
			// 初始化數據
			this.m_radius = 20;
			this.m_speed = 10;
			this.m_isFocus = false;
			
			// 繪製圖件
			this.mc_sprite = new Sprite();
			this.mc_sprite.graphics.beginFill( 0xff0088, 1 );
			this.mc_sprite.graphics.drawCircle(0, 0, this.m_radius);
			this.mc_sprite.graphics.endFill();
			
			this.mc_focusSprite = new Sprite();
			this.mc_focusSprite.graphics.beginFill( 0x00ffff, 1 );
			this.mc_focusSprite.graphics.drawCircle(0, 0, this.m_radius);
			this.mc_focusSprite.graphics.endFill();
		}
		
		/*public function：對外公開函數*/
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
		private function NotifyAddToSpace( a_notification : RMNotification ) : void
		{
			// 1. 取回Notifier相關的座標儲存資料結構( SpaceVar )
			var local : IRMSpaceVar = this.RetrieveSpaceVar( a_notification.getNotifier().getName() );
			var space : RMSpace = local.getSpace() as RMSpace;
			
			// 2. 設定初值
			local.setX( Math.random() * space.getWidth() / 2 + space.getWidth() / 4 );
			local.setY( Math.random() * space.getHeight() / 2 + space.getHeight() / 4 );
			local.setZ( Math.floor(Math.random() * 360) );
			local.setWidth( this.m_radius );
			local.setHeight( this.m_radius );
			//local.setZ( 95 );
		}
		private function NotifyDraw( a_notification : RMNotification ) : void
		{
			// 1. 指定為特定Space為Notifier時執行。
			// 2. 取得繪製區域
			var panel : BitmapData = a_notification.getBody() as BitmapData;
			// 3. 取回Notifier相關的座標儲存資料結構( SpaceVar )
			var local : IRMSpaceVar = this.RetrieveSpaceVar( a_notification.getNotifier().getName() );
			// 4. 繪製
			if( local != null )
			{
				if( this.m_isFocus )
					panel.draw( this.mc_focusSprite, new Matrix( 1, 0, 0, 1, local.getX(), local.getY() ) );
				else
					panel.draw( this.mc_sprite, new Matrix( 1, 0, 0, 1, local.getX(), local.getY() ) );
			}
			//trace(" draw targetActor ");
			
			this.m_isFocus = false;
		}
		private function NotifyUpdate( a_notification : RMNotification ) : void
		{			
			var i : Number = 0, j : Number = 0, k : Number = 0;
			var space : GeometrySpace = a_notification.getBody() as GeometrySpace;
			var local : IRMSpaceVar = this.RetrieveSpaceVar( a_notification.getBody().getName() );
			// 若存在於空間內才計算
			var newPoint : Point = new Point( local.getX() + Math.cos( (local.getZ() - 90) * Math.PI / 180 ) * this.m_speed, 
											 local.getY() + Math.sin( (local.getZ() - 90) * Math.PI / 180 ) * this.m_speed );
			// 若碰觸邊界，切換角度
			
			if( newPoint.y < 0 || newPoint.y > space.getHeight() )
			{					
				if( local.getZ() <= 180  )
					local.setZ(180 - local.getZ());
				else
					local.setZ(270 - local.getZ() + 270 );
			}
			if( newPoint.x < 0 || newPoint.x > space.getWidth() )
			{					
				if( local.getZ() >= 90 && local.getZ() <= 270  )
					local.setZ( 180 - local.getZ() + 180 );
				else
					local.setZ( 360 - local.getZ() );
			}
			// 移動
			local.setX( local.getX() + Math.cos( (local.getZ() - 90) * Math.PI / 180 ) * this.m_speed );
			local.setY( local.getY() + Math.sin( (local.getZ() - 90) * Math.PI / 180 ) * this.m_speed );
			
		}
		/*private function：私用函數*/
	}
}
/*end of package*/