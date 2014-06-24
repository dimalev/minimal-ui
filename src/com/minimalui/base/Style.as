package com.minimalui.base {
  import flash.events.EventDispatcher;
  import flash.events.Event;

  /**
   * Holds and manages styling values.
   */
  public class Style extends EventDispatcher {
    public static const DEFAULT_NAMESPACE:String = "default";

    private var mFields:Vector.<String> = new Vector.<String>;
    private var mFieldsByNamespace:Object = new Object;
    private var mChangedFields:Vector.<String> = new Vector.<String>;
    private var mInheritableFields:Vector.<String> = new Vector.<String>;
    private var mData:Object = new Object;
    private var mDataByNamespace:Object = new Object;
    private var mParent:Style;
    private var mMutable:Boolean = true;
    private var mHasNewParent:Boolean = false;
    private var mNameSpace:String = DEFAULT_NAMESPACE;

    private var mTarget:Element;
    private var mInvalidateSizeList:Vector.<String> = new Vector.<String>();
    private var mChangeList:Vector.<String> = new Vector.<String>();

    public function get namespace():String { return mNameSpace; }
    public function set namespace(ns:String):void {
      if(mNameSpace == ns) return;
      var nsf:String;
      var fields:Vector.<String> = mFieldsByNamespace[DEFAULT_NAMESPACE].slice();
      if(DEFAULT_NAMESPACE != ns && mFieldsByNamespace.hasOwnProperty(ns)) {
        var nsfields:Vector.<String> = mFieldsByNamespace[ns];
        for each(nsf in nsfields)
          if(fields.indexOf(nsf) <= 0) fields.push(nsf);
      }
      var oldFields:Vector.<String> = new Vector.<String>;
      for each(nsf in mFields) if(fields.indexOf(nsf) < 0) oldFields.push(nsf);
      for each(nsf in oldFields) delValue(nsf);
      setCurrentValues(mDataByNamespace[DEFAULT_NAMESPACE]);
      if(DEFAULT_NAMESPACE != ns && mFieldsByNamespace.hasOwnProperty(ns))
        setCurrentValues(mDataByNamespace[ns]);
      mNameSpace = ns;
    }

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

    public function Style(target:Element, fields:Object = null) {
      mTarget = target;
      if(fields is String) setCSS(fields as String);
    }

    public function addInvalidateSize(...names):void {
      mInvalidateSizeList = mInvalidateSizeList.concat(Vector.<String>(names));
    }

    public function addChange(...names):void {
      mChangeList = mChangeList.concat(Vector.<String>(names));
    }

    public function addInheritable(...names):void {
      var count:uint = names.length;
      var deleteOwn:Boolean = false;
      if(names[count - 1] is Boolean) {
        deleteOwn = true;
        names.splice(count - 1, 1);
      }
      for each(var name:String in names) {
        if(isInheritable(name)) continue;
        if(deleteOwn) delValue(name);
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
      // var pairs:Array = css.split(/(?:[^\\]);/);
      var i:int = 0;
      var j:int = 0;
      var x:int;
      while(i < css.length) {
        while(true) {
          x = css.indexOf(";", j);
          if(x < 0) break;
          if(css.charAt(x - 1) == "\\") j = x + 1;
          else break;
        }
        if(x < 0) x = css.length;
        var p:String = css.substr(i, x - i);
        i = j = x + 1;
        var d:int = p.indexOf(":");
        if(d < 0) continue;
        var name:String = p.substr(0, d).replace(/(^\s+|\s+$)/g, "");
        var value:String = p.substr(d+1).replace(/(^\s+|\s+$)/g, "").replace(/\\:/g, ":").replace(/\\;/g, ";");
        if(value.match(/^\s*(0x[0-9a-fA-F]+?|\d+(\.\d+)?)\s*$/)) setValue(name, Number(value));
        else setValue(name, value);
      }
    }

    public function getValue(name:String):Object {
      if(!hasValue(name)) return null;
      return hasOwnValue(name) ? mData[name] : (isInheritable(name) ? mParent.getValue2(name) : null);
    }

    public function getString(name:String):String { return hasValue(name) ? String(getValue(name)) : ""; }
    public function getNumber(name:String):Number { return hasValue(name) ? Number(getValue(name)) : 0; }

    public function setValue(nsname:String, value:Object):void {
      if(!mMutable) throw new Error("Cannot change " + name +". Style is frozen!");
      var parts:Array = nsname.split(":");
      var name:String = parts[0];
      var ns:String = parts.length > 1 ? parts[1] : DEFAULT_NAMESPACE;
      if(namespace == ns || !mFieldsByNamespace.hasOwnProperty(namespace) || mFieldsByNamespace[namespace].indexOf(name) < 0)
        setCurrentValue(name, value);
      setNSValue(ns, name, value);
    }

    public function hasValue(name:String):Boolean {
      return hasOwnValue(name) || (isInheritable(name) && mParent && mParent.hasValue2(name));
    }

    public function hasOwnValue(name:String):Boolean {
      return mFields.indexOf(name) >= 0;
    }

    public function delValue(nsname:String):Boolean {
      if(!mMutable) throw new Error("Cannot change " + name +". Style is frozen!");
      var parts:Array = nsname.split(":");
      var name:String = parts[0];
      var ns:String = parts.length > 1 ? parts[1] : namespace;
      delNSValue(ns, name);
      if(namespace == ns) return delCurrentValue(name);
      return false;
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

    public function get allChanged():Vector.<String> {
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

    protected function getValue2(name:String):Object {
      return hasOwnValue(name) ? mData[name] : mParent.getValue2(name);
    }

    protected function setCurrentValues(fields:Object):void {
      for(var name:String in fields) setCurrentValue(name, fields[name]);
    }

    protected function setCurrentValue(name:String, value:Object):void {
      if(!hasOwnValue(name)) addValue(name);
      else if(mData[name] == value) return;
      mData[name] = value;
      addChanged(name);
      mTarget.setDirty();
      if(mInvalidateSizeList.indexOf(name) >= 0) mTarget.invalidateSize();
      if(mChangeList.indexOf(name) >= 0) mTarget.setChanged();
    }

    protected function setNSValue(ns:String, name:String, value:Object):void {
      if(!mFieldsByNamespace.hasOwnProperty(ns)) mFieldsByNamespace[ns] = new Vector.<String>;
      if(mFieldsByNamespace[ns].indexOf(name) < 0) mFieldsByNamespace[ns].push(name);
      if(!mDataByNamespace.hasOwnProperty(ns)) mDataByNamespace[ns] = {};
      mDataByNamespace[ns][name] = value;
    }

    protected function hasValue2(name:String):Boolean {
      return hasOwnValue(name) || (mParent && mParent.hasValue2(name));
    }

    protected function addValue(name:String):void {
      mFields.push(name);
    }

    protected function delCurrentValue(name:String):Boolean {
      if(!hasOwnValue(name)) return false;
      delete mData[name];
      mFields.splice(mFields.indexOf(name), 1);
      addChanged(name);
      mTarget.setDirty();
      if(mInvalidateSizeList.indexOf(name) >= 0) mTarget.invalidateSize();
      if(mChangeList.indexOf(name) >= 0) mTarget.setChanged();
      return true;
    }

    protected function delNSValue(ns:String, name:String):void {
      if(!mFieldsByNamespace.hasOwnProperty(ns)) return;
      if(mFieldsByNamespace[ns].indexOf(name) < 0) return;
      delete mDataByNamespace[ns][name];
      mFieldsByNamespace[ns].splice(mFieldsByNamespace[ns].indexOf(name), 1);
    }

    protected function addChanged(name:String):void {
      if(mChangedFields.indexOf(name) >= 0) return;
      mChangedFields.push(name);
    }
  }
}
