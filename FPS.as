package
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class FPS
	{
		public static var fps:Number = 0.0;
		
		public static function init (stage:Stage):void
		{
			lastTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private static var lastTime:int;
		private static var frameTimes:Vector.<int> = new Vector.<int>(10);
		private static var frameIndex:int;
		private static var frameTimeSum:int;
		
		private static function onEnterFrame(e:Event):void
		{
			var time:int = getTimer();
			var dt:int = time - lastTime;
			lastTime = time;
			
			frameTimeSum -= frameTimes[frameIndex];
			frameTimeSum += dt;
			frameTimes[frameIndex] = dt;
			
			frameIndex = (frameIndex + 1) % frameTimes.length;
			
			fps = 1000 * frameTimes.length / frameTimeSum;
		}
	}
}