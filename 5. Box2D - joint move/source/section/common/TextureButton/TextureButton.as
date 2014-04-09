/*
//////////////////////////
//// TextureButton ////
//////////////////////////
	Info:
		- TextureButton基本按鈕
		
	Useage:(有開放public 讓外部使用)
		- FunctionName1 : function describe
		
	Date:
		- 2011.08.29
		
	Author:
		- Name : EastMoon
		- Email : jacky_eastmoon@hotmail.com
*/

package section.common.TextureButton
{
	/*import：Flash內建元件庫*/
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/*external import：外部元件庫、開發人員自定元件庫*/
	import caurina.transitions.Tweener;
	import flash.display.Graphics;

	public class TextureButton extends TextureContainerButton
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		public var EventClickButton : Function;
		/*member variable：物件內部操作變數*/
		private var m_isFocus : Boolean;
		private var m_isChoose : Boolean;
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_unfocusBitmap : Bitmap;
		private var mc_focusBitmap : Bitmap;
		private var mc_choosBitmap : Bitmap;
		
		public var mc_eventRegion : Sprite;
		/*constructor：建構值*/
		public function TextureButton( a_texture : Array )
		{
			super(a_texture);
			
			// 初始參數
			this.m_isFocus = false;
			this.m_isChoose = false;
			// 初始畫面物件
			this.mc_unfocusBitmap = null;
			this.mc_focusBitmap = null;
			this.mc_choosBitmap = null;
			this.mc_eventRegion = null;
			
			// 初始函數
			this.EventClickButton = null;
		}
		/*protected function : 繼承函數*/
		protected override function InitialProgress( a_event : Event ) : void
		{
			// 如果有Pattern指定，建立按鈕圖檔，並ADD於物件
			// 0:普通狀態，unfocus、unchoose
			// 1:注視狀態，focus
			// 2:選擇狀態，choose
			if(this.m_textureContainer.length >= 1)
			{
				this.mc_unfocusBitmap = new Bitmap(this.m_textureContainer[0]);
				
				// 確認深度，將unfocus放於最下層
				this.addChild(this.mc_unfocusBitmap);
			}
			if(this.m_textureContainer.length >= 2)
			{
				this.mc_focusBitmap = new Bitmap(this.m_textureContainer[1]);
				this.addChild(this.mc_focusBitmap);		
				
				this.mc_focusBitmap.alpha = 0;
				this.mc_focusBitmap.visible = false;
			}
			if(this.m_textureContainer.length >= 3)
			{
				this.mc_choosBitmap = new Bitmap(this.m_textureContainer[2]);
				this.addChild(this.mc_choosBitmap);		
				
				// 交換choose和focus的層級
				this.swapChildren(this.mc_focusBitmap, this.mc_choosBitmap);
				
				this.mc_choosBitmap.alpha = 0;
				this.mc_choosBitmap.visible = false;
			}
			
			// 建立感應區
			this.mc_eventRegion = new Sprite();
			this.mc_eventRegion.alpha = 0;
			this.addChild(this.mc_eventRegion);
			// 繪製感應區
			var graphic : Graphics = this.mc_eventRegion.graphics;
			graphic.clear()
			graphic.beginFill(0x000000);
			graphic.drawRect(0,0,1,1);
			graphic.endFill();
			// 感應區寬度修改
			this.mc_eventRegion.width = this.width;
			this.mc_eventRegion.height = this.height;
			// 設定感應區事件
			this.mc_eventRegion.addEventListener(MouseEvent.MOUSE_UP, this.EventMouseUp);
			this.mc_eventRegion.addEventListener(MouseEvent.MOUSE_OVER, this.EventMouseOver);
			this.mc_eventRegion.addEventListener(MouseEvent.MOUSE_OUT, this.EventMouseOut);
			
			// 更新位置
			this.UpdateBrowser();
		}
		/*public function：對外公開函數*/
		public override function UpdateBrowser() : void
		{
			if( this.mc_unfocusBitmap != null )
			{
				this.mc_unfocusBitmap.x = -this.mc_unfocusBitmap.width/2;
				this.mc_unfocusBitmap.y = -this.mc_unfocusBitmap.height/2;
			}
			if( this.mc_focusBitmap != null )
			{
				this.mc_focusBitmap.x = -this.mc_focusBitmap.width/2;
				this.mc_focusBitmap.y = -this.mc_focusBitmap.height/2;
			}
			if( this.mc_choosBitmap != null )
			{
				this.mc_choosBitmap.x = -this.mc_choosBitmap.width/2;
				this.mc_choosBitmap.y = -this.mc_choosBitmap.height/2;
			}
			
			this.mc_eventRegion.x = -this.mc_eventRegion.width/2;
			this.mc_eventRegion.y = -this.mc_eventRegion.height/2;
		}
		
		public function Focus( a_isFocus : Boolean ) : void
		{
			if( this.m_isFocus == a_isFocus )
				return ;
			
			// 記錄注目狀態
			this.m_isFocus = a_isFocus;
			
			// 暫停動畫
			this.StopTween();
			
			// 執行動畫
			var tweenParam : Object = new Object();
			tweenParam.time = .5;
			
			if(this.m_isFocus)
			{
				tweenParam.alpha = 1;
				tweenParam.onStart = function() { this.visible = true; };
				tweenParam.onComplete = this.EventCheckState;
			}
			else
			{
				tweenParam.alpha = 0;
				tweenParam.onComplete = this.EventCheckState;
			}
			
			if( this.mc_focusBitmap != null )
				Tweener.addTween(this.mc_focusBitmap, tweenParam);
		}
		
		public function Choose( a_isChoose : Boolean ) : void
		{
			if( this.m_isChoose == a_isChoose )
				return ;
			
			// 記錄注目狀態
			this.m_isChoose = a_isChoose;
			
			// 暫停動畫
			this.StopTween();
			
			// 執行動畫
			var tweenParam : Object = new Object();
			tweenParam.time = .5;
			
			if(a_isChoose)
			{
				tweenParam.alpha = 1;
				tweenParam.onStart = this.EventCheckState;
				tweenParam.onComplete = this.EventCheckState;
			}
			else
			{
				tweenParam.alpha = 0;
				this.mc_unfocusBitmap.visible = true;
				this.mc_focusBitmap.visible = true;
				tweenParam.onComplete = this.EventCheckState;
			}
			
			if( this.mc_choosBitmap != null )
				Tweener.addTween(this.mc_choosBitmap, tweenParam);
		}
		
		public function EventRegion( a_width : Number, a_height : Number ) : void
		{
			this.mc_eventRegion.width = a_width;
			this.mc_eventRegion.height = a_height;
			this.UpdateBrowser();
		}
		/*private function：私用函數*/
		private function StopTween() : void
		{
			Tweener.removeTweens(this.mc_unfocusBitmap);
			Tweener.removeTweens(this.mc_focusBitmap);
			Tweener.removeTweens(this.mc_choosBitmap);
		}
		/*private event function：私用事件函數*/
		private function EventCheckState() : void
		{
			if(this.mc_unfocusBitmap != null )
				this.mc_unfocusBitmap.visible = !this.m_isChoose && this.mc_unfocusBitmap.alpha == 1;
			if(this.mc_focusBitmap != null )
				this.mc_focusBitmap.visible = !this.m_isChoose || this.mc_focusBitmap.alpha == 1;
			if(this.mc_choosBitmap != null)
				this.mc_choosBitmap.visible = this.m_isChoose;
		}
		private function EventMouseUp( a_event : MouseEvent )
		{
			this.Choose(!this.m_isChoose);
			if(this.EventClickButton != null)
				this.EventClickButton();
		}
		private function EventMouseOver( a_event : MouseEvent )
		{
			this.Focus(true);
		}
		private function EventMouseOut( a_event : MouseEvent )
		{
			this.Focus(false);
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		public function get isFocus() : Boolean
		{
			return this.m_isFocus;
		}
		public function get isChoose() : Boolean
		{
			return this.m_isChoose;
		}
		/*read/write：讀寫*/
	}
}