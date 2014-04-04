/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

/*
//////////////////////////
////	 Main		 ////
//////////////////////////
	Info:
		- 各Section的程式進入點與主要Section內的物件管理
		
	Useage:(有開放public 讓外部使用)
		- FunctionName1 : function describe
		
	Date:
		- 9999.99.99
		
	Author:
		- Name : Author
		- Email : Author@email.com
*/

package section.DEMO
{	

	/*import：Flash內建元件庫*/
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import org.gra.ApplicationFacade;
	import org.gra.view.WindowSection.Core.SectionBitmap;
	import org.gra.controller.Progress.IProgressController;
	import org.gra.model.RuleModel.Core.RMModule;
	import org.gra.model.RuleModel.Core.RMNotify;
	import org.gra.model.RuleModel.Core.RMNotification;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;

	public class SectionDemo extends SectionBitmap
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var m_demoModule : RMModule;
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function SectionDemo() : void
		{
			super("SectionDemo");
			
			trace("SectionDemo Initial");
			// 初始繪圖區
			this.bitmap = new BitmapData( 1, 1, true, 0xffff0000 );
			// 取得DemoModule
			this.m_demoModule = ApplicationFacade.getInstance().retrieveModule("DemoModule");
		}
		/*public function：對外公開函數*/
		public override function Active() : void
		{
			trace( "SectionDemo Active" );
		}
		public override function Unactive() : void
		{
			trace( "SectionDemo Unactive" );
		}
		public override function Update() : void
		{
			//trace( "SectionDemo Update" );
			// 若存有Window，建立相對應的繪圖區
			if( this.getWindow() != null )
			{
				// 取得視窗寬度
				var stageRect : Rectangle = this.getWindow().getCurrentViewport();
				// 若目前繪圖區不等於視窗當前大小，重新指定繪圖區大小
				if( this.getViewComponent().width != stageRect.width && this.getViewComponent().height != stageRect.height )
					this.bitmap = new BitmapData( stageRect.width, stageRect.height, true, 0xffff0000 );
			}
			
			// 更新模組，模組更新主要來自於Application Facade，對此，除非需要並不會特別下答下命令來更新。
			//this.m_demoModule.Update( null, "MatrixSpace" );
		}
		public override function Draw() : void
		{
			// 重置繪板
			this.bitmap.fillRect( new Rectangle(0, 0, this.bitmap.width, this.bitmap.height), 0xffaaaaaa );
			
			// 模組繪製，Section對Module主要下達繪製。
		}
		
		// 顯示內容進場，Progress Flow 控制函數
		public override function Display( a_flow : IProgressController = null ) : void
		{
		}
		// 顯示內容退場，Progress Flow 控制函數
		public override function Disappear( a_flow : IProgressController = null ) : void
		{
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		/*private function：私用函數*/
	}
}