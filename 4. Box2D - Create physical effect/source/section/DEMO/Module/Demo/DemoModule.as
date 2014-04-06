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

package section.DEMO.Module.Demo
{	

	/*import：Flash內建元件庫*/
	/*external import：外部元件庫、開發人員自定元件庫*/
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;
	// Game rule architecture Import
	import org.gra.ApplicationFacade;
	import org.gra.model.RuleModel.Core.RMModule;
	import org.gra.model.RuleModel.Core.RMNotify;
	import org.gra.model.RuleModel.Core.RMNotification;
	import section.DEMO.Module.Demo.Space.Battlefield;
	import section.DEMO.Module.Demo.Actor.AvatorActor;
	import section.DEMO.Module.Demo.Actor.ChessActor;
	import section.DEMO.Module.Demo.Event.AvatorEvent;
	
	public class DemoModule extends RMModule
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var tf_title : TextField;
		/*constructor：建構值*/
		public function DemoModule() : void
		{
			super( "DemoModule" );
			
			this.tf_title = new TextField();
			this.tf_title.width = 500;
			this.tf_title.text = "Click A ~ M to move left, Click N ~ Z to move right.";
		}
		/*public function：對外公開函數*/
		public override function onRegister() : void
		{
			var i : Number = 0, j : Number = 0, k : Number = 0;
			// Initial model notify relationship
			/*
			本範例的Module註冊是在內部完成，但實際上註冊也可在InitialModelCommand中完成。
			在ApplicationFacade的關係是屬於同管理層，但在執行期間仍需依據Module關係設定階層式架構的Module樹。
			*/
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			var module : RMModule = null;
			if( app.hasModule( "OperatorModule" ) )
			{
				module = app.retrieveModule("OperatorModule");
			}
			
			/*
			Initial Model content.
			*/
			// 建立Space
			// 螢幕尺寸
			// trace( flash.system.Capabilities.screenResolutionX, flash.system.Capabilities.screenResolutionY);
			var bf : Battlefield = new Battlefield(950, 550);
			this.RegisterSpace( Battlefield.NAME, bf );
			
			// 建立游標Actor
			var aa : AvatorActor = new AvatorActor;
			this.RegisterActor( AvatorActor.NAME, aa );
			
			// 建立移動Actor
			for( i = 1 ; i <= 5 ; i++ )
			{
				this.RegisterActor( ChessActor.NAME + i.toString(), new ChessActor() );
			}
			
			// 將角色放入舞臺
			bf.AddActor( this.RetrieveActor( AvatorActor.NAME ) );
			for( i = 1 ; i <= 5 ; i++ )
			{
				bf.AddActor( this.RetrieveActor( ChessActor.NAME + i.toString() ), bf.physicsWorld.CreateCircle() );
				//bf.AddActor( this.RetrieveActor( ChessActor.NAME + i.toString() ) );
			}
			
			// 登入事件
			this.RegisterEvent( AvatorEvent.TOUCH, new AvatorEvent() );
			
			// 登記Application事件
			//this.AddNotify( RMNotify.UPDATE, this.Update );
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		/*private function：私用函數*/
	}
}