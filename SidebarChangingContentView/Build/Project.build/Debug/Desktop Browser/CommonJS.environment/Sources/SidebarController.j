I;21;Foundation/CPObject.jI;22;AppKit/CPOutlineView.ji;18;SidebarColorItem.jc;4638;

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

