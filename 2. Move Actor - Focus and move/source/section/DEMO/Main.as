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
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	// PureMVC Import
	// Game rule architecture Import
	import org.gra.ApplicationFacade;
	// Box2D
	import Box2D.Dynamics.b2World;
	// DEMO
	import section.DEMO.appCommand.*;
		
	public class Main extends MovieClip
	{
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function Main()
		{
			trace("It is RM_OperatorModule Main Page");
			
			// 初始系統
			this.addEventListener( Event.ADDED_TO_STAGE, this.DEMO_INITIAL );
		}
		/*public function：對外公開函數*/
		public function LogOut( a_str : String ) : void
		{
			trace( a_str );
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		private function DEMO_INITIAL( a_event : Event = null ) : void
		{
			this.LogOut("----- Initial Application Facade -----");
			// 宣告ApplicationFacade指標
			var app : ApplicationFacade = null;
			// 初始ApplicationFacade
			app = ApplicationFacade.getInstance();
			// 登記啟動命令
            app.registerCommand( ApplicationFacade.EVENT_STARTUP, ApplicationStartupCommand );
			// 起動應用程式
			ApplicationFacade.Startup(this);
			// 修改FPS
			ApplicationFacade.setFPS( 30 );
		}
		/*private function：私用函數*/
	}
}