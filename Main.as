package
{
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	import nl.funkymonkey.android.deviceinfo.*;
	
	public class Main extends Sprite
	{
		public var fpsText:TextField;
		public var mouseDown:Boolean = false;
		public var extraInfo:String;
		
		public function Main ()
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			fpsText = new TextField();
			fpsText.textColor = 0xFFFFFF;
			fpsText.x = 10;
			fpsText.y = 10;
			fpsText.autoSize = "left";
			
			addChild(fpsText);
			
			FPS.init(stage);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			//fixAndroidLag();
			
			var NativeApplication:Class = getDefinitionByName("flash.desktop.NativeApplication") as Class;
			var airRuntimeVersion:String = NativeApplication["nativeApplication"]["runtimeVersion"];
			
			var xml:XML = NativeApplication["nativeApplication"]["applicationDescriptor"];
			
			var ns:Namespace = xml.namespace();
			
			var appName:String = xml.ns::name;
			
			var airCompileVersion:String = ns.uri.substring(ns.uri.lastIndexOf("/") + 1);
			
			NativeDeviceInfo.parse();
			
			extraInfo = appName;
			
			extraInfo += "\n\n";
			
			extraInfo += "AIR " + airCompileVersion + " (compiled)\n";
			extraInfo += "AIR " + airRuntimeVersion + " (runtime)";
			
			extraInfo += "\n\n";
			
			extraInfo += "OS: " + NativeDeviceProperties.OS_NAME.value + " " + NativeDeviceProperties.OS_VERSION.value + "\n";
			extraInfo += "Device: " + NativeDeviceProperties.PRODUCT_MODEL.value;
			if (NativeDeviceProperties.PRODUCT_VERSION.value) {
				extraInfo += " " + NativeDeviceProperties.PRODUCT_VERSION.value;
			}
			extraInfo += " (" + NativeDeviceProperties.PRODUCT_BRAND.value + ")";
		}
		
		private function onEnterFrame(e:Event):void
		{
			fpsText.text = FPS.fps.toFixed(2) + "FPS\n\n" + extraInfo;
			
			graphics.clear();
			graphics.beginFill(mouseDown ? 0x800000 : 0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		private function onMouseDown (e:MouseEvent):void
		{
			mouseDown = true;
		}
		
		private function onMouseUp (e:MouseEvent):void
		{
			mouseDown = false;
		}
		
		private function fixAndroidLag ():void
		{
			if (Capabilities.manufacturer.toLowerCase().indexOf("android") != -1) {
				stage.frameRate = 4;
				
				var timer:Timer = new Timer(100, 5);
				timer.addEventListener(TimerEvent.TIMER, fixAndroidLagCallback);
				timer.start();
			}
		}
		
		private function fixAndroidLagCallback (e:*):void
		{
			if (stage.frameRate == 4) {
				stage.frameRate = 60;
			} else {
				stage.frameRate = 4;
			}
		}
	}
}
