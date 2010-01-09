I;21;Foundation/CPObject.jc;1404;

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

