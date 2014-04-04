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
	// DEMO
	import section.DEMO.Module.*;
	
    /**
     * Create and register <code>Proxy</code>s with the <code>Model</code>.
     */
    public class InitialModelCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            //facade.registerProxy(new StartupMonitorProxy());
			trace("Initial Model Class：" , note.getBody());
			
			// 取得Stage
			var root : DisplayObjectContainer = note.getBody() as DisplayObjectContainer;
			
			// 取得Application Facade
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			
			trace("----- Initial Module -----");
			
			// 建立與登記模組
			
			// 建立操作模組
			var dm : DemoModule = new DemoModule();
			// 註冊模組
			app.registerModule( dm );
			
			// 設定模組關係
        }
    }
}