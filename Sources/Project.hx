package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Assets;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import nape.shape.Circle;

class Project {
	var napeDebugDraw:NapeDebugDraw;
	var space:Space;
	var launcher:LaunchManager;
	var width:Int;
	var height:Int;
	var ball:Body;

	public function new() {
		Assets.loadEverything(assetsLoaded);
		// Screen dimensions aren't always accurate on start in HTML5, wait a bit to get real values		
		// https://github.com/KTXSoftware/Kha/issues/421
		Scheduler.addTimeTask(delayedInit, 0.1);
	}

	function assetsLoaded() {
		trace("Assets finished loading");
	}

	function delayedInit() {
		System.notifyOnRender(render);

		width = System.windowWidth();
		height = System.windowHeight();

		setUpNapeScene();

		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function setUpNapeScene() {
		var gravity = Vec2.weak(0, 600);
		space = new Space(gravity);
		napeDebugDraw = new NapeDebugDraw(space);

		var floor = new Body(BodyType.STATIC);
		floor.shapes.add(new Polygon(Polygon.rect(width / 2 - 256, height / 2, 512, 100)));
		floor.space = space;

		for (i in 0...16) {
			var box = new Body(BodyType.DYNAMIC);
			box.shapes.add(new Polygon(Polygon.box(16, 32)));
			box.position.setxy(width / 2, height / 2 - 50 - 32 * (i + 0.5));
			box.space = space;
		}

		ball = new Body(BodyType.DYNAMIC);
		ball.shapes.add(new Circle(50));
		var offset = Vec2.get(50, 50);
		ball.shapes.add(new Polygon(Polygon.box(16, 50)).translate(offset));
		offset.x = -50;
		ball.shapes.add(new Polygon(Polygon.box(16, 50)).translate(offset));
		offset.dispose();
		ball.position.setxy(width / 2 - 128, height / 2);
		// ball.angularVel = 10;
		ball.space = space;

		launcher = new LaunchManager(space);
	}

	function update(): Void {
		space.step(1 / 60);
	}

	function render(framebuffer: Framebuffer): Void {		
		var graphics = framebuffer.g2;
		graphics.begin();
		napeDebugDraw.draw(graphics);
		graphics.end();
	}
}
