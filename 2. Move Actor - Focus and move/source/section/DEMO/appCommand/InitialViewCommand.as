/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package section.DEMO.appCommand
{
	/*import：Flash內建元件庫*/
    import flash.display.DisplayObjectContainer;
	// PureMVC Import
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
	// Game rule architecture Import
    import org.gra.ApplicationFacade;
	import org.gra.view.WindowSection.Interface.ISection;
    import org.gra.view.WindowSection.Interface.IWindow;
    import org.gra.view.WindowSection.Core.Window;
	// DEMO
	import section.DEMO.SectionDemo;
	
    /**
     * Create and register <code>Proxy</code>s with the <code>Model</code>.
     */
    public class InitialViewCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            //facade.registerProxy(new StartupMonitorProxy());
			trace("Initial View Class：" , note.getBody());
			
			// 取得Stage
			var root : DisplayObjectContainer = note.getBody() as DisplayObjectContainer;
			
			// 取得Application Facade
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			
			trace("----- Initial Window-Section -----");
			
			// 設定視窗物件
			var DEMO : Window = new Window("DEMO_SPRITE_EVENT");
			DEMO.setViewport( root.stage.stageWidth, root.stage.stageHeight );
			
			// 登記視窗至舞臺
			root.addChild( DEMO );
			
			// 設定內容物件
			var section : ISection = new SectionDemo();
			DEMO.setSection( section );
			
			// 註冊視窗與內容至Application Facade
			app.registerWindow( DEMO );
			app.registerSection( section );
        }
    }
}