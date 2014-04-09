/*
////////////////////////////////
////	AnimationTexture	////
////////////////////////////////
	Info:
		- 
		
	Useage:(有開放public 讓外部使用)
		- isLoop		: [read-write]動畫播放是否為輪播
		- loopTime		: [read-write]動畫輪播次數，若isLoop為False才依此判斷
		- drawTime		: [read-write]動畫繪製次數，若isLoop為False才依此判斷
		
	Date:
		- 2010.01.04
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/

package section.common.GraphicsTexture
{
	/*import：Flash內建元件庫*/
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	/*external import：外部元件庫、開發人員自定元件庫*/
		
	public class AnimationTexture extends Texture
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		// 動畫圖源，採用MovieClip為輸入源
		private var m_patternMovieClip : MovieClip;
		private var m_patternArray : Array;
		// 動畫操作變數
		private var m_maxPage : Number;
		private var m_step : Number;
		private var m_viewRect : Rectangle;
		private var m_viewClipRect : Rectangle;
		private var m_view : BitmapData;
		
		// 繪製控制
		private var m_isLoop : Boolean;
		private var m_loopTime : Number;
		private var m_drawTime : Number;
		private var m_curDraw : Number;
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function AnimationTexture( a_pattern : Object = null, a_viewRect : Rectangle = null ) : void
		{
			// 確認可視範圍
			if( a_viewRect == null )
				this.m_viewRect = new Rectangle();
			else
				this.m_viewRect = a_viewRect;
			
			// 初始化父物件
			super(this.m_viewRect);
			
			this.m_viewClipRect = new Rectangle(0,0,this.m_viewRect.width, this.m_viewRect.height);
			
			this.m_step = 0;
			
			// 依照輸入類型執行動作
			if( a_pattern != null && a_pattern is BitmapData )
			{
				this.m_bitmapData = a_pattern as BitmapData;
				this.m_patternMovieClip = null;
				this.m_patternArray = null;
				this.m_view = new BitmapData(this.m_viewRect.width, this.m_viewRect.height, true, 0x00000000);
				// 計算最大Page數量
				this.m_maxPage = Math.floor(this.m_bitmapData.width / this.m_viewRect.width);
			}
			else if( a_pattern != null && a_pattern is MovieClip )
			{
				this.m_bitmapData = null;
				this.m_patternMovieClip = a_pattern as MovieClip;
				this.m_patternArray = new Array();
				this.m_view = null;
				
				// 將MovieClip內容拍照儲存在列表中
				for( var i = 1 ; i != this.m_patternMovieClip.totalFrames ; i++ )
				{
					this.m_patternMovieClip.gotoAndStop(i);
					//trace( this.mc_animationMovieClip.width, this.m_patternMovieClip.height );
					var newPattern : BitmapData = new BitmapData(this.m_patternMovieClip.width, this.m_patternMovieClip.height, true, 0x00000000);
					newPattern.draw(this.m_patternMovieClip);
					this.m_patternArray.push(newPattern);
				}
				// 計算最大Page數量
				this.m_maxPage = this.m_patternArray.length - 1;
			}
			else
			{
				this.m_bitmapData = null;
				this.m_patternMovieClip = null;
				this.m_patternArray = null;
				this.m_view = null;
				this.m_maxPage = 0;
			}
			
			// 預設播放為true
			this.m_isLoop = true;
			this.m_loopTime = this.m_drawTime = this.m_curDraw = 0;		
		}
		/*public function：對外公開函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		public function set isLoop( a_value : Boolean ) : void
		{
			this.m_isLoop = a_value;
			if( this.m_isLoop )
				this.m_curDraw = 0;
		}
		
		public function get isLoop() : Boolean
		{
			return this.m_isLoop;
		}
		
		public function set loopTime( a_value : Number ) : void
		{
			if( a_value > 0 )
			{
				this.m_isLoop = false;
				this.m_loopTime = a_value;
				this.m_curDraw = 0;
			}
			else
			{
				this.m_isLoop = true;
				this.m_loopTime = this.m_curDraw = 0;
			}
		}
		public function get loopTime() : Number
		{
			return this.m_loopTime;
		}
		
		public function set drawTime( a_value : Number ) : void
		{
			if( a_value > 0 )
			{
				this.m_isLoop = false;
				this.m_drawTime = a_value;
				this.m_curDraw = 0;
			}
			else
			{
				this.m_isLoop = true;
				this.m_drawTime = this.m_curDraw = 0;
			}
		}
		public function get drawTime() : Number
		{
			return this.m_drawTime;
		}
		
		/*private function：私用函數*/
		/*private event function：私用事件函數*/
		protected override function EventDrawBitmap( a_panel : BitmapData ) : void
		{
			// 判斷播放狀態
			// 目前播放幾輪
			var curLoop : Number = (this.m_curDraw + 1) / this.m_maxPage;
			if( this.m_isLoop || ( !this.m_isLoop && (this.m_curDraw <= this.m_drawTime || curLoop <= this.m_loopTime )))
			{
				if( this.m_bitmapData != null )
				{
					// 計算擷取空間
					this.m_viewClipRect.x = this.m_step * this.m_viewRect.width;
					// 清除擷取影像
					this.m_view.fillRect(this.m_viewRect, 0x00000000);
					// 複製擷取影像
					this.m_view.copyPixels(this.m_bitmapData, this.m_viewClipRect, new Point(0,0), null, null, true);
				}
				else if( this.m_patternMovieClip != null )
				{
					this.m_view = this.m_patternArray[this.m_step];
				}
			
				// 跳至下個區塊
				if( ++this.m_step >= this.m_maxPage )
					this.m_step = 0;
				
				// 增加目前繪製次數
				if( !this.m_isLoop )
					this.m_curDraw++;
			}
			// 繪製影像
			if( this.m_bitmapData != null || this.m_patternMovieClip != null )
				a_panel.draw( this.m_view, this.m_matrix, this.m_color, this.m_blend, this.m_clipRect, this.m_isSmoothing);
			
		}
	}
}