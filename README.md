A basic UI framework for HaxePop (https://github.com/bendmorris/haxepop) with an 
XML layout engine.


XML Layouts
-----------

You can use UIScene's `layout` function to specify your entities' relative 
positions in XML instead of mixing it in with other logic in the scene's code.

A few entity types are built-in (img, sizers) and custom parsers can be 
registered for your own entities using `haxepop.ui.UI`'s `registerEntityType` 
method.



`src/MyScene.hx`:

    import haxepop.HXP;
    import haxepop.graphics.Image;
    import haxepop.graphics.BitmapText;
    import haxepop.UI;
    import haxepop.ui.UIEntity;
    import haxepop.ui.UIScene;
    import haxepop.ui.Color;
    import haxepop.ui.graphics.RichText;
    
    
    class MainMenuScene extends UIScene
    {
        var startLabel:BitmapText;
        var loadImage:Image;
    
        public static function parseLabel(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
        {
            var text = fast.has.text ? fast.att.text : "";
            var color = fast.has.color ? Color.colors[fast.att.color] : Color.Black;
            var wordWrap = fast.has.wordWrap ? fast.att.wordWrap == 'true' : false;
            var size = fast.has.size ? Unit.value(fast.att.size) : 1;
            var width = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : 0,
                height = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : 0;
    
            var label = new RichText(text, 0, 0, width, height);
            label.computeTextSize();
    
            var e = new haxepop.ui.UIEntity(label);
            if (!fast.has.width)
                e.width = label.textWidth;
            if (!fast.has.height)
                e.height = label.textHeight;
    
            return e;
        }
    
        public function new()
        {
            super();
    
            UI.registerEntityType("label", parseLabel);
    
            layout("data/layouts/main_menu.xml");
    
            startLabel = cast(get("startLabel").graphic, BitmapText);
            loadImage = cast(get("loadImage").graphic, Image);
        }
    }


`assets/data/layouts/main_scene.xml`:

    <scene padding="16px" transition="fade" transitionTime="1">
        <img src="graphics/logo.png" x="2%" y="2%" width="96%"/>
        <img id="loadImage" src="graphics/loading.png" x="50%" y="50%" center="true" visible="false"/>
        <vsizer width="100%" height="100%" center="true" spacing="8px" paddingTop="25%">
            <label id="startLabel"
                text-ouya="Press O to start"
                text-flash="CLICK to start"
                text-desktop="Press ENTER to start"
                text-ios="TAP to start"
                text-android="TAP to start"
                />
        </vsizer>
    </scene>
