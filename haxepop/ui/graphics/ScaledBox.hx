package haxepop.ui.graphics;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxepop.HXP;
import haxepop.Graphic;
import haxepop.Camera;
import haxepop.graphics.Image;


class ScaledBox extends Graphic
{
	var ul:Image;
	var uc:Image;
	var ur:Image;
	var cl:Image;
	var cc:Image;
	var cr:Image;
	var ll:Image;
	var lc:Image;
	var lr:Image;

	public var width:Int = 0;
	public var height:Int = 0;
	public var scale:Float = 1;

	var wl:Int = 0;
	var wc:Int = 0;
	var wr:Int = 0;
	var ht:Int = 0;
	var hc:Int = 0;
	var hb:Int = 0;

	public function new(source:ImageType, width:Int, height:Int, widthLeft:Int, widthRight:Int, heightTop:Int, heightBottom:Int, ?scale:Float=1)
	{
		super();

		this.width = width;
		this.height = height;
		this.scale = scale;
		wl = widthLeft;
		wr = widthRight;
		wc = source.width - (widthLeft + widthRight);
		ht = heightTop;
		hb = heightBottom;
		hc = source.height - (heightTop + heightBottom);

		_rect = HXP.rect;

		_rect.x = 0;
		_rect.y = 0;
		_rect.width = wl;
		_rect.height = ht;
		ul = new Image(source, _rect);

		_rect.x = wl;
		_rect.y = 0;
		_rect.width = wc;
		_rect.height = ht;
		uc = new Image(source, _rect);

		_rect.x = wl + wc;
		_rect.y = 0;
		_rect.width = wr;
		_rect.height = ht;
		ur = new Image(source, _rect);

		_rect.x = 0;
		_rect.y = ht;
		_rect.width = wl;
		_rect.height = hc;
		cl = new Image(source, _rect);

		_rect.x = wl;
		_rect.y = ht;
		_rect.width = wc;
		_rect.height = hc;
		cc = new Image(source, _rect);

		_rect.x = wl + wc;
		_rect.y = ht;
		_rect.width = wr;
		_rect.height = hc;
		cr = new Image(source, _rect);

		_rect.x = 0;
		_rect.y = ht + hc;
		_rect.width = wl;
		_rect.height = hb;
		ll = new Image(source, _rect);

		_rect.x = wl;
		_rect.y = ht + hc;
		_rect.width = wc;
		_rect.height = hb;
		lc = new Image(source, _rect);

		_rect.x = wl + wc;
		_rect.y = ht + hc;
		_rect.width = wr;
		_rect.height = ht;
		lr = new Image(source, _rect);
	}

	override public function render(target:BitmapData, point:Point, camera:Camera)
		renderAll(false, 0, target, point, camera);

	override public function renderAtlas(layer:Int, point:Point, camera:Camera)
		renderAll(true, layer, null, point, camera);

	public inline function renderAll(hw:Bool, layer:Int, target:BitmapData, point:Point, camera:Camera)
	{
		var fsx = HXP.screen.fullScaleX,
			fsy = HXP.screen.fullScaleY;

		var swl = Std.int(wl * scale * fsx) / wl / fsx;
		var swc = Std.int((width - (wl + wr)*scale) * fsx) / wc / fsx;
		var swr = Std.int(wr * scale * fsx) / wr / fsx;
		var sht = Std.int(ht * scale * fsy) / ht / fsy;
		var shc = Std.int((height - (ht + hb)*scale) * fsy) / hc / fsy;
		var shb = Std.int(hb * scale * fsy) / hb / fsy;

		ul.x = x;
		ul.y = y;
		ul.scaleX = swl;
		ul.scaleY = sht;
		if (hw) ul.renderAtlas(layer, point, camera);
		else ul.render(target, point, camera);

		uc.x = x + Std.int(wl * swl * fsx) / fsx;
		uc.y = y;
		uc.scaleX = swc;
		uc.scaleY = sht;
		if (hw) uc.renderAtlas(layer, point, camera);
		else uc.render(target, point, camera);

		ur.x = x + Std.int((wl * swl + wc * swc) * fsx) / fsx;
		ur.y = y;
		ur.scaleX = swr;
		ur.scaleY = sht;
		if (hw) ur.renderAtlas(layer, point, camera);
		else ur.render(target, point, camera);

		cl.x = x;
		cl.y = y + Std.int(ht * sht * fsy) / fsy;
		cl.scaleX = swl;
		cl.scaleY = shc;
		if (hw) cl.renderAtlas(layer, point, camera);
		else cl.render(target, point, camera);

		cc.x = Std.int((x + Std.int(wl * swl)) * fsx) / fsx;
		cc.y = y + Std.int(ht * sht * fsy) / fsy;
		cc.scaleX = swc;
		cc.scaleY = shc;
		if (hw) cc.renderAtlas(layer, point, camera);
		else cc.render(target, point, camera);

		cr.x = x + Std.int((wl * swl + wc * swc) * fsx) / fsx;
		cr.y = y + Std.int(ht * sht * fsy) / fsy;
		cr.scaleX = swr;
		cr.scaleY = shc;
		if (hw) cr.renderAtlas(layer, point, camera);
		else cr.render(target, point, camera);

		ll.x = x;
		ll.y = y + Std.int((ht * sht + hc * shc) * fsy) / fsy;
		ll.scaleX = swl;
		ll.scaleY = shb;
		if (hw) ll.renderAtlas(layer, point, camera);
		else ll.render(target, point, camera);

		lc.x = Std.int((x + Std.int(wl * swl)) * fsx) / fsx;
		lc.y = y + Std.int((ht * sht + hc * shc) * fsy) / fsy;
		lc.scaleX = swc;
		lc.scaleY = shb;
		if (hw) lc.renderAtlas(layer, point, camera);
		else lc.render(target, point, camera);

		lr.x = x + Std.int((wl * swl + wc * swc) * fsx) / fsx;
		lr.y = y + Std.int((ht * sht + hc * shc) * fsy) / fsy;
		lr.scaleX = swr;
		lr.scaleY = shb;
		if (hw) lr.renderAtlas(layer, point, camera);
		else lr.render(target, point, camera);
	}

	var _rect:Rectangle;
}
