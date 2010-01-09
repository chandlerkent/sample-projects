I;21;Foundation/CPObject.jc;1313;
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

