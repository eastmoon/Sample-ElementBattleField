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

package section.DEMO.Module.Operator
{	

	/*import：Flash內建元件庫*/
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/*external import：外部元件庫、開發人員自定元件庫*/
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;
	// Game rule architecture Import
	import org.gra.model.RuleModel.Core.RMModule;
	import org.gra.model.RuleModel.Core.RMNotification;
	
	public class OperatorModule extends RMModule
	{		
		/*static const variable : 靜態常數變數*/
		public static const MOVE_IN : String = "OperatorModule_Move_in";
		public static const MOVE_OUT : String = "OperatorModule_Move_out";
		public static const TARGET_MOVE : String = "OperatorModule_Target_move";
		public static const TARGET_FOCUS : String = "OperatorModule_Target_focus";
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		private var mc_stage : Stage;
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function OperatorModule( a_stage : Stage = null ) : void
		{
			super( "OperatorModule" );
			// 儲存資訊來源
			this.stage = a_stage;
		}
		/*public function：對外公開函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		public function get stage() : Stage
		{
			return this.mc_stage;
		}
		public function set stage( a_stage : Stage ) : void
		{
			// 儲存
			this.mc_stage = a_stage;
			// 若資訊來源不為空，登記事件
			if( this.mc_stage != null )
			{
				// 鍵盤事件
				this.mc_stage.addEventListener( KeyboardEvent.KEY_DOWN, this.EventKeyboardNotify );
				this.mc_stage.addEventListener( MouseEvent.MOUSE_MOVE, this.EventMouseNotify );
				this.mc_stage.addEventListener( MouseEvent.CLICK, this.EventMouseNotify );
			}
		}
		/*private event function：私用事件函數*/
		private function EventKeyboardNotify( a_event : KeyboardEvent = null ) : void
		{
			if( a_event.keyCode < 78 )
				//this.SendNotify( new RMNotification( OperatorModule.MOVE_IN ) );
				this.SendNotify( new RMNotification( OperatorModule.TARGET_MOVE, new Point( 50, 50 ) ) );
			else
				this.SendNotify( new RMNotification( OperatorModule.MOVE_OUT ) );
		}
		private function EventMouseNotify( a_event : MouseEvent = null ) : void
		{
			switch( a_event.type )
			{
				case MouseEvent.MOUSE_MOVE :
					this.SendNotify( new RMNotification( OperatorModule.TARGET_MOVE, new Point( this.mc_stage.mouseX, this.mc_stage.mouseY ) ) );
				break;
				case MouseEvent.CLICK :
					this.SendNotify( new RMNotification( OperatorModule.TARGET_FOCUS, new Point( this.mc_stage.mouseX, this.mc_stage.mouseY ) ) );
				break;
			}
		}
		/*private function：私用函數*/
	}
}