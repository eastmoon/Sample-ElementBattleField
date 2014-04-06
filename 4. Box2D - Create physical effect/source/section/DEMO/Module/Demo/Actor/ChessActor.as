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
	import flash.geom.Matrix;
	import flash.display.Sprite;
	
	/*external import：外部元件庫、開發人員自定元件庫*/
	import Box2D.Dynamics.b2Body;
	import org.gra.model.RuleModel.Core.*;
	import org.gra.model.RuleModel.Interface.*;
	import section.DEMO.Module.Demo.Space.Battlefield;
	import section.DEMO.Module.Demo.Space.variable.*;
	import Box2D.Common.Math.b2Vec2;

	/*external import*/
	public dynamic class ChessActor extends RMActor
	{
		/*static const variable : 靜態常數變數*/
		public static const NAME : String = "EBF_ChessActor";
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_radius : Number;
		private var m_isFocus : Boolean;
		private var m_commandWaitFor : Boolean;
		
		private var m_speed : Number;
		private var m_movePoint : IRMSpaceVar;
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_sprite : Sprite;
		private var mc_focusSprite : Sprite;
		private var mc_waitForSprite : Sprite;
		
		/*constructor：建構值*/
		public function ChessActor() : void
		{
			// 登記事件
			// 取得通告
			this.AddNotify( RMNotify.UPDATE , this.NotifyUpdate );
			// 處理指定來源者的通告
			// 注意：繪製時應指定繪製要求的Space為何，使物件能針對目標進行繪製。
			this.AddNotifyByNotifier( Battlefield.NAME, RMNotify.ADD_TO_SPACE, this.NotifyAddToSpace );
			this.AddNotifyByNotifier( Battlefield.NAME, RMNotify.DRAW, this.NotifyDraw );
			
			// 初始化數據
			this.m_radius = 20;
			this.m_isFocus = false;
			this.m_speed = 5;
			
			// 繪製圖件
			this.mc_sprite = new Sprite();
			this.mc_sprite.graphics.beginFill( 0xff0088, 1 );
			this.mc_sprite.graphics.drawCircle(0, 0, this.m_radius);
			this.mc_sprite.graphics.endFill();
			
			this.mc_focusSprite = new Sprite();
			this.mc_focusSprite.graphics.beginFill( 0x00ffff, 1 );
			this.mc_focusSprite.graphics.drawCircle(0, 0, this.m_radius);
			this.mc_focusSprite.graphics.endFill();
			
			this.mc_waitForSprite = new Sprite();
			this.mc_waitForSprite.graphics.beginFill( 0x0000ff, 1 );
			this.mc_waitForSprite.graphics.drawCircle(0, 0, this.m_radius);
			this.mc_waitForSprite.graphics.endFill();
		}
		
		/*public function：對外公開函數*/
		public function CommandWaitFor( a_isWait : Boolean = true ) : void
		{
			this.m_commandWaitFor = a_isWait;
		}
		
		public function CommandMoveTo( a_x : Number, a_y : Number, a_focusSpace : String ) : void
		{
			// 移動
			// 取回Notifier相關的座標儲存資料結構( SpaceVar )
			var local : B2DObject = this.RetrieveSpaceVar( a_focusSpace ) as B2DObject;
			if( local != null )
			{
				//local.body.SetPosition( new b2Vec2( a_x / 30, a_y / 30 ) );
				local.Destory();
				local.Initial({
							  "x" : a_x,
							  "y" : a_y,
							  "r" : this.m_radius,
							  "t" : b2Body.b2_dynamicBody
						  });
				/*
				if( this.m_movePoint == null )
					this.m_movePoint = new RMSpaceVar();
				this.m_movePoint.setX( a_x );
				this.m_movePoint.setY( a_y );
				*/
				// 解除等待命令
				this.CommandWaitFor( false );
			}
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
		private function NotifyAddToSpace( a_notification : RMNotification ) : void
		{
			// 1. 取回Notifier相關的座標儲存資料結構( SpaceVar )
			var local : B2DObject = this.RetrieveSpaceVar( a_notification.getNotifier().getName() ) as B2DObject;
			var space : RMSpace = local.getSpace() as RMSpace;
			
			// 2. 設定初值
			local.Initial({
							  "x" : Math.random() * space.getWidth() / 2 + space.getWidth() / 4,
							  "y" : Math.random() * space.getHeight() / 2 + space.getHeight() / 4,
							  "r" : this.m_radius,
							  "t" : b2Body.b2_dynamicBody,
							  "phy" : [ 1, 1, 1 ]
						  });
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
				if( this.m_commandWaitFor )
					panel.draw( this.mc_waitForSprite, new Matrix( 1, 0, 0, 1, local.getX(), local.getY() ) );
				else if( this.m_isFocus )
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
			var space : Battlefield = a_notification.getBody() as Battlefield;
			var local : B2DObject = this.RetrieveSpaceVar( a_notification.getBody().getName() ) as B2DObject;
			
			// 更新物理效果
			local.Update();
			// 移動
			if( this.m_movePoint != null && this.m_movePoint.getY() != local.getY() && this.m_movePoint.getX() != local.getX() )
			{
				// 依據目標點計算本次移動位置，此移動向量不可大於移動速度。
				// 0. 距差
				var diffX : Number = this.m_movePoint.getX() - local.getX();
				var diffY : Number = this.m_movePoint.getY() - local.getY();
				// 1. 計算斜率
				var slope : Number = diffY / diffX; 
				// 2. 計算角度 atan( slope )
				var angle : Number = Math.atan( slope );
				// 計算移動量，先以速度計算單次移動最大量，若最大量大於兩點距差，則等同達到目標；反之增加移動量。
				var distance : Number = 0;
				//trace( angle, Math.cos( angle ) * this.m_speed, Math.sin( angle ) * this.m_speed );
				// 3. 計算移動的 X 點
				distance = (Math.cos( angle ) * this.m_speed) * ((diffX >= 0) ? 1 : -1);
				if( Math.abs(distance) > Math.abs(diffX) )
					local.setX( this.m_movePoint.getX() );
				else
					local.setX( local.getX() + distance );
				
				// 4. 計算移動的 Y 點
				distance = Math.sin( angle ) * this.m_speed * ((diffX >= 0) ? 1 : -1);
				if( Math.abs(distance) > Math.abs(diffY) )
					local.setY( this.m_movePoint.getY() );
				else
					local.setY( local.getY() + distance );
			}
		}
		/*private function：私用函數*/
	}
}
/*end of package*/