(function(){var a;a=function(a){return this.cid=_.uniqueId("backbone.shortcuts"),this.initialize.apply(this,arguments),this.delegateShortcuts()},_.extend(a.prototype,Backbone.Events,{initialize:function(){},delegateShortcuts:function(){var a,b,c,d,e,f,g,h;if(!this.shortcuts)return;g=this.shortcuts,h=[];for(e in g){a=g[e],_.isFunction(a)||(c=this[a]);if(!c)throw new Error("Method "+a+" does not exist");b=e.match(/^(\S+)\s*(.*)$/),f=b[1],d=b[2]===""?"all":b[2],c=_.bind(c,this),h.push(key(f,d,c))}return h}}),Backbone.Shortcuts=a,Backbone.Shortcuts.extend=Backbone.View.extend}).call(this);