@STATIC;1.0;u;21;Resources/spinner.gif54;mhtml:IE7.environment/Project.sj!Resources/spinner.gifp;15;AppController.jI;21;Foundation/CPObject.jc;1313;
{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("theWindow"), new objj_ivar("scrollView")]);
objj_registerClassPair(the_class);
objj_addClassForBundle(the_class, objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(the_class, [new objj_method(sel_getUid("theWindow"), function $AppController__theWindow(self, _cmd)
{ with(self)
{
return theWindow;
}
},["id"]),
new objj_method(sel_getUid("setTheWindow:"), function $AppController__setTheWindow_(self, _cmd, newValue)
{ with(self)
{
theWindow = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("scrollView"), function $AppController__scrollView(self, _cmd)
{ with(self)
{
return scrollView;
}
},["id"]),
new objj_method(sel_getUid("setScrollView:"), function $AppController__setScrollView_(self, _cmd, newValue)
{ with(self)
{
scrollView = newValue;
}
},["void","id"]), new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{ with(self)
{
}
},["void","CPNotification"]), new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{ with(self)
{
    objj_msgSend(scrollView, "setAutohidesScrollers:", YES);
}
},["void"])]);
}

p;6;main.jI;23;Foundation/Foundation.jI;15;AppKit/AppKit.ji;15;AppController.jc;78;
main= function(args, namedArgs)
{
    CPApplicationMain(args, namedArgs);
}

p;18;SidebarColorItem.jI;21;Foundation/CPObject.jc;1404;

{var the_class = objj_allocateClassPair(CPObject, "SidebarColorItem"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("name"), new objj_ivar("color")]);
objj_registerClassPair(the_class);
objj_addClassForBundle(the_class, objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(the_class, [new objj_method(sel_getUid("name"), function $SidebarColorItem__name(self, _cmd)
{ with(self)
{
return name;
}
},["id"]),
new objj_method(sel_getUid("setName:"), function $SidebarColorItem__setName_(self, _cmd, newValue)
{ with(self)
{
name = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("color"), function $SidebarColorItem__color(self, _cmd)
{ with(self)
{
return color;
}
},["id"]),
new objj_method(sel_getUid("setColor:"), function $SidebarColorItem__setColor_(self, _cmd, newValue)
{ with(self)
{
color = newValue;
}
},["void","id"]), new objj_method(sel_getUid("init"), function $SidebarColorItem__init(self, _cmd)
{ with(self)
{
    return objj_msgSend(self, "initWithName:color:", "", nil);
}
},["id"]), new objj_method(sel_getUid("initWithName:color:"), function $SidebarColorItem__initWithName_color_(self, _cmd, aName, aColor)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("CPObject") }, "init"))
    {
        name = aName;
        color = aColor;
    }
    return self;
}
},["id","CPString","CPColor"])]);
}

p;19;SidebarController.jI;21;Foundation/CPObject.jI;22;AppKit/CPOutlineView.ji;18;SidebarColorItem.jc;4638;

{var the_class = objj_allocateClassPair(CPObject, "SidebarController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("sidebarScrollView"), new objj_ivar("outlineView"), new objj_ivar("items")]);
objj_registerClassPair(the_class);
objj_addClassForBundle(the_class, objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(the_class, [new objj_method(sel_getUid("sidebarScrollView"), function $SidebarController__sidebarScrollView(self, _cmd)
{ with(self)
{
return sidebarScrollView;
}
},["id"]),
new objj_method(sel_getUid("setSidebarScrollView:"), function $SidebarController__setSidebarScrollView_(self, _cmd, newValue)
{ with(self)
{
sidebarScrollView = newValue;
}
},["void","id"]), new objj_method(sel_getUid("awakeFromCib"), function $SidebarController__awakeFromCib(self, _cmd)
{ with(self)
{
    items = objj_msgSend(self, "defaultSidebarItems");

    var column = objj_msgSend(objj_msgSend(CPTableColumn, "alloc"), "initWithIdentifier:", "column");
    objj_msgSend(column, "setWidth:", 400.0);
    objj_msgSend(column, "setDataView:", objj_msgSend(objj_msgSend(SidebarItemView, "alloc"), "initWithFrame:", CGRectMakeZero()));

    outlineView = objj_msgSend(objj_msgSend(CPOutlineView, "alloc"), "initWithFrame:", objj_msgSend(objj_msgSend(sidebarScrollView, "contentView"), "bounds"));
    objj_msgSend(outlineView, "setAutoresizingMask:", CPViewWidthSizable | CPViewHeightSizable);
    objj_msgSend(outlineView, "setHeaderView:", nil);
    objj_msgSend(outlineView, "setCornerView:", nil);
    objj_msgSend(outlineView, "addTableColumn:", column);
    objj_msgSend(outlineView, "setOutlineTableColumn:", column);

    objj_msgSend(outlineView, "setDataSource:", self);

    objj_msgSend(sidebarScrollView, "setDocumentView:", outlineView);

    var allItems = objj_msgSend(items, "allKeys");
    for (var i = 0; i < objj_msgSend(allItems, "count"); i++)
    {
        objj_msgSend(outlineView, "expandItem:", objj_msgSend(allItems, "objectAtIndex:", i));
    }
}
},["void"]), new objj_method(sel_getUid("defaultSidebarItems"), function $SidebarController__defaultSidebarItems(self, _cmd)
{ with(self)
{
    var redColor = objj_msgSend(objj_msgSend(SidebarColorItem, "alloc"), "initWithName:color:", "Red", objj_msgSend(CPColor, "redColor"));
    var blueColor = objj_msgSend(objj_msgSend(SidebarColorItem, "alloc"), "initWithName:color:", "Blue", objj_msgSend(CPColor, "blueColor"));
    var greenColor = objj_msgSend(objj_msgSend(SidebarColorItem, "alloc"), "initWithName:color:", "Green", objj_msgSend(CPColor, "greenColor"));

    var colorItem = objj_msgSend(objj_msgSend(SidebarColorItem, "alloc"), "initWithName:color:", "Colors", nil);

    return objj_msgSend(CPDictionary, "dictionaryWithObjectsAndKeys:", [redColor, greenColor, blueColor], colorItem);
}
},["CPDictionary"])]);
}

{
var the_class = objj_getClass("SidebarController")
if(!the_class) objj_exception_throw(new objj_exception(OBJJClassNotFoundException, "*** Could not find definition for class \"SidebarController\""));
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("outlineView:child:ofItem:"), function $SidebarController__outlineView_child_ofItem_(self, _cmd, outlineView, child, item)
{ with(self)
{
    if (item === nil)
    {
        var keys = objj_msgSend(items, "allKeys");
        return objj_msgSend(keys, "objectAtIndex:", child);
    }
    else
    {
        var values = objj_msgSend(items, "objectForKey:", item);
        return objj_msgSend(values, "objectAtIndex:", child);
    }
}
},["id","CPOutlineView","int","id"]), new objj_method(sel_getUid("outlineView:isItemExpandable:"), function $SidebarController__outlineView_isItemExpandable_(self, _cmd, outlineView, item)
{ with(self)
{
    var values = objj_msgSend(items, "objectForKey:", item);
    return (objj_msgSend(values, "count") > 0);
}
},["BOOL","CPOutlineView","id"]), new objj_method(sel_getUid("outlineView:numberOfChildrenOfItem:"), function $SidebarController__outlineView_numberOfChildrenOfItem_(self, _cmd, outlineView, item)
{ with(self)
{
    if (item === nil)
    {
        return objj_msgSend(items, "count");
    }
    else
    {
        var values = objj_msgSend(items, "objectForKey:", item);
        return objj_msgSend(values, "count");
    }
}
},["int","CPOutlineView","id"]), new objj_method(sel_getUid("outlineView:objectValueForTableColumn:byItem:"), function $SidebarController__outlineView_objectValueForTableColumn_byItem_(self, _cmd, outlineView, tableColumn, item)
{ with(self)
{
    return objj_msgSend(item, "name");
}
},["id","CPOutlineView","CPTableColumn","id"])]);
}

e;/*
Content-Type: multipart/related; boundary="_ANY_STRING_WILL_DO_AS_A_SEPARATOR"

--_ANY_STRING_WILL_DO_AS_A_SEPARATOR
Content-Location:Resources/spinner.gif
Content-Transfer-Encoding:base64

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
*/