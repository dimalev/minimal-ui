package com.minimalui.base {
  import flash.events.EventDispatcher;
  import flash.events.Event;

  import com.minimalui.events.FieldChangeEvent;
  import com.minimalui.events.StyleNewParentEvent;

  public class Style extends EventDispatcher {
    private var mFields:Vector.<String> = new Vector.<String>;
    private var mChangedFields:Vector.<String> = new Vector.<String>;
    private var mInheritableFields:Vector.<String> = new Vector.<String>;
    private var mData:Object = new Object;
    private var mParent:Style;
    private var mMutable:Boolean = true;
    private var mHasNewParent:Boolean = false;

    public function get mutable():Boolean { return mMutable; }
    public function freeze():Style {
      if(mParent && mParent.mutable) throw new Error("Parent has to be frozen!");
      mMutable = false;
      return this;
    }

    public function get hasNewParent():Boolean { return mHasNewParent; }

    public function set parent(p:Style):void {
      if(!mMutable) throw new Error("Cannot change parent. Style is frozen!");
      if(mParent == p) return;
      mParent = p;
      mHasNewParent = true;
    }

    public function Style(fields:Object = null) {
      if(fields is String) setCSS(fields as String);
    }

    public function addInheritable(...names):void {
      for each(var name:String in names) {
        if(isInheritable(name)) continue;
        mInheritableFields.push(name);
      }
    }

    public function removeInheritable(name:String):void {
      if(!isInheritable(name)) return;
      mInheritableFields.splice(mInheritableFields.indexOf(name), 1);
    }

    public function isInheritable(name:String):Boolean { return mInheritableFields.indexOf(name) >= 0; }

    public function setValues(fields:Object):void {
      for(var name:String in fields) setValue(name, fields[name]);
    }

    public function setCSS(css:String):void {
      var pairs:Array = css.split(";");
      for each(var p:String in pairs) {
        var spl:Array = p.split(":");
        if(spl.length != 2) continue;
        var name:String = spl[0].replace(/(^\s+|\s+$)/g, "");
        var value:String = spl[1].replace(/(^\s+|\s+$)/g, "");
        if(value.match(/^\s*(0x[0-9a-fA-F]+?|\d+)\s*$/)) setValue(name, Number(value));
        else setValue(name, value);
      }
    }

    public function getValue(name:String):Object {
      if(!hasValue(name)) return null;
      return hasOwnValue(name) ? mData[name] : (isInheritable(name) ? mParent.getValue2(name) : null);
    }

    protected function getValue2(name:String):Object {
      return hasOwnValue(name) ? mData[name] : mParent.getValue2(name);
    }

    public function getString(name:String):String { return hasValue(name) ? (getValue(name) as String) : ""; }
    public function getNumber(name:String):Number { return hasValue(name) ? (getValue(name) as Number) : 0; }

    public function setValue(name:String, value:Object):void {
      if(!mMutable) throw new Error("Cannot change " + name +". Style is frozen!");
      if(!hasOwnValue(name)) addValue(name);
      else if(mData[name] == value) return;
      mData[name] = value;
      addChanged(name);
    }

    public function hasValue(name:String):Boolean {
      return hasOwnValue(name) || (isInheritable(name) && mParent && mParent.hasValue2(name));
    }

    protected function hasValue2(name:String):Boolean {
      return hasOwnValue(name) || (mParent && mParent.hasValue2(name));
    }

    public function hasOwnValue(name:String):Boolean {
      return mFields.indexOf(name) >= 0;
    }

    public function delValue(name:String):Boolean {
      if(!hasOwnValue(name)) return false;
      delete mData[name];
      mFields.splice(mFields.indexOf(name), 1);
      addChanged(name);
      return true;
    }

    public function get changed():Vector.<String> {
      if(!mParent) return mChangedFields;
      var all:Vector.<String> = mParent.allChanged.filter(
                                                          function(elem:String, i:int, a:Vector.<String>):Boolean {
                                                            return mInheritableFields.indexOf(elem) >= 0;
                                                          }
                                                          );
      return all.concat(mChangedFields).sort(Array.CASEINSENSITIVE).filter(
                                                    function(value:String, i:int, a:Vector.<String>):Boolean {
                                                      var prev:String = this.prev;
                                                      this.prev = value;
                                                      return prev != value;
                                                    }, { prev: null });
    }

    protected function get allChanged():Vector.<String> {
      if(!mParent) return changed;
      var res:Vector.<String> = mParent.allChanged;
      return res.concat(mChangedFields).sort(Array.CASEINSENSITIVE)
        .filter(function(value:String, i:int, a:Vector.<String>):Boolean {
            var prev:String = this.prev;
            this.prev = value;
            return prev != value;
          }, { prev: null });
    }

    public function cleanChanged():void {
      mChangedFields.splice(0, mChangedFields.length);
      mHasNewParent = false;
    }

    protected function addValue(name:String):void {
      mFields.push(name);
    }

    protected function addChanged(name:String):void {
      if(mChangedFields.indexOf(name) >= 0) return;
      mChangedFields.push(name);
    }
  }
}
