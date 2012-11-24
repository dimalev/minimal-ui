package com.minimalui.base {
  import flash.events.EventDispatcher;
  import flash.events.Event;

  import com.minimalui.events.FieldChangeEvent;
  import com.minimalui.events.StyleNewParentEvent;

  public class Style extends EventDispatcher {
    public static var doTrace:Boolean = false;
    private var mFields:Vector.<String> = new Vector.<String>;
    private var mChangedFields:Vector.<String> = new Vector.<String>;
    private var mData:Object = new Object;
    private var mParent:Style;
    private var mDefault:Style;
    private var mLocks:uint = 0;
    private var mMutable:Boolean = true;

    public function get mutable():Boolean { return mMutable; }
    public function freeze():Style {
      if(mParent && mParent.mutable) throw new Error("Parent has to be frozen!");
      mMutable = false;
      return this;
    }

    public function set parent(p:Style):void {
      if(!mMutable) throw new Error("Cannot change parent. Style is frozen!");
      if(mParent == p) return;
      if(mParent) {
        mParent.removeEventListener(FieldChangeEvent.CHANGE, onParentChange);
        mParent.removeEventListener(StyleNewParentEvent.NEW_PARENT, onNewParent);
      }
      mParent = p;
      if(mParent) {
        mParent.addEventListener(FieldChangeEvent.CHANGE, onParentChange);
        mParent.addEventListener(StyleNewParentEvent.NEW_PARENT, onNewParent);
      }
      dispatchEvent(new StyleNewParentEvent);
    }

    public function set defaults(d:Style):void {
      mDefault = d;
    }

    private function onNewParent(e:StyleNewParentEvent):void {
      dispatchEvent(new StyleNewParentEvent);
    }

    private function onParentChange(e:FieldChangeEvent):void {
      if(doTrace) trace("parent values changed " + e.fields.join(", "));
      lock();
      for each(var f:String in e.fields) addChanged(f);
      lock(false);
    }

    public function Style(fields:Object = null, parent:Style = null, mutable:Boolean = true) {
      if(fields) setValues(fields);
      this.parent = parent;
    }

    public function setValues(fields:Object):void {
      lock();
      for(var name:String in fields) setValue(name, fields[name]);
      lock(false);
    }

    public function getValue(name:String):Object {
      if(!hasValue(name)) {
        if(!mDefault) return null;
        return mDefault.getValue(name);
      }
      return hasOwnValue(name) ? mData[name] : mParent.getValue(name);
    }

    public function getString(name:String):String { return getValue(name) as String; }
    public function getNumber(name:String):Number { return getValue(name) as Number; }

    public function setValue(name:String, value:Object):void {
      if(!mMutable) throw new Error("Cannot change " + name +". Style is frozen!");
      if(doTrace) trace("adding new style value " + name);
      if(!hasOwnValue(name)) addValue(name);
      else if(mDefault[name] == value) return;
      mData[name] = value;
      addChanged(name);
    }

    public function hasValue(name:String):Boolean {
      return hasOwnValue(name) || (mParent && mParent.hasValue(name));
    }

    public function hasOwnValue(name:String):Boolean {
      return mFields.indexOf(name) >= 0;
    }

    public function delValue(name:String):Boolean {
      if(!hasValue(name)) return false;
      delete mData[name];
      mFields.splice(mFields.indexOf(name), 1);
      addChanged(name);
      return true;
    }

    public function cleanChanged():void { mChangedFields.splice(0, mChangedFields.length); }

    public function lock(bb:Boolean = true):void {
      if(bb) ++mLocks;
      else --mLocks;
      if(mLocks != 0 ) return;
      onChange();
    }

    protected function addValue(name:String):void {
      mFields.push(name);
    }

    protected function addChanged(name:String):void {
      if(mChangedFields.indexOf(name) >= 0) return;
      mChangedFields.push(name);
      onChange();
    }

    private function onChange():void {
      if(mChangedFields.length == 0) return;
      dispatchEvent(new FieldChangeEvent(Vector.<String>(mChangedFields)));
      cleanChanged();
    }
  }
}
