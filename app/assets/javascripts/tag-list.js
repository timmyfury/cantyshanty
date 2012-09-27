(function($){

	$.fn.extend({
		textBoxList: function(opts){
            opts = $.extend({

			}, opts);

			return this.each(function(){
				var tbl = new TextBoxList(this, opts);
				window.tbl = tbl;
				return tbl;
			});
		}
	});

	var TextBoxList = function(el, opts){

        this.sourceNode = $(el);
		this.opts = opts;
        this.autoSuggestList = this.opts.autoSuggestList;

        var sourceListVal = this.sourceNode.val() || "";
        this.valueList = sourceListVal.split(',');

        this.setupDom();
        this.attachEvents();

        this.valueInputNodeFocused = false;

        this.sourceNode.data('textBoxList', this);

	}; TextBoxList.prototype = {

        setupDom: function(){
            var template = '<div class="tbl">' +
                                '<ul class="tbl-value-list"></ul>' +
                                // '<input class="tbl-input" type="text" autocapitalize="off" />' +
                                '<textarea class="tbl-input" autocapitalize="off" /></textarea>' +
                                '<ul class="tbl-suggest-list"></ul>' +
                            '</div>';

            this.rootNode = $(template);
            this.valueListNode = this.rootNode.find('.tbl-value-list');
            this.valueInputNode = this.rootNode.find('.tbl-input');
            this.suggestListNode = this.rootNode.find('.tbl-suggest-list');

            this.populateValueListNode();
            this.populateSuggestListNode();

            this.rootNode.insertAfter(this.sourceNode);
            this.sourceNode.hide();
        },

        attachEvents: function(){
            this.rootNode.on('click', '.tbl-value', jQuery.proxy(this, 'onValueNodeClick'));

            this.rootNode.on('focusin', '.tbl-input', jQuery.proxy(this, 'onInputNodeFocusin'));
            this.rootNode.on('focusout', '.tbl-input', jQuery.proxy(this, 'onInputNodeFocusout'));
            this.rootNode.on('keyup', '.tbl-input', jQuery.proxy(this, 'onInputNodeKey'));

            this.rootNode.on('click', '.tbl-suggest', jQuery.proxy(this, 'onSuggestNodeClick'));
            this.rootNode.on('hover', '.tbl-suggest', jQuery.proxy(this, 'onSuggestNodeHover'));
        },

        onSuggestNodeClick: function(evt){
            var target = $(evt.currentTarget),
                val = target.data('value');

            this.valueList.push(val);
            this.updateRootNode();
            this.valueInputNode.val("");
            this.suggestListNode.hide();
            this.valueInputNode.focus();
        },

        onSuggestNodeHover: function(evt){
            this.suggestListNode.find('.tbl-suggest').removeClass('tbl-suggest-active');
            $(evt.currentTarget).addClass('tbl-suggest-active');
        },

        onInputNodeFocusin: function(evt){
            this.valueInputNodeFocused = true;
            this.suggestListNode.show();
        },

        onInputNodeFocusout: function(evt){
            this.valueInputNodeFocused = false;

            setTimeout(jQuery.proxy(function(){
                if(!this.valueInputNodeFocused){
                    this.suggestListNode.hide();
                }
            }, this), 200);
        },

        onInputNodeKey: function(evt){
            if (evt.which == 13 || evt.which == 44) {
                evt.preventDefault();
                var val = jQuery.trim(this.valueInputNode.val());
                if(val){
                    this.valueList.push(val);
                    this.updateRootNode();
                    this.valueInputNode.val("");
                }
                this.suggestListNode.hide();
            } else if (evt.which == 27) {
                this.suggestListNode.hide();
            } else {
                this.suggestListNode.show();
            }
            this.filterSuggestList();
        },

        onValueNodeClick: function(evt){
            evt.preventDefault();
            var target = $(evt.currentTarget),
                targetVal = target.data('value');

            this.valueList = _.reject(this.valueList, function(v){ return v == targetVal; }, this);

            this.updateRootNode();
        },

        filterSuggestList: function(){
            var filterVal = jQuery.trim(this.valueInputNode.val()),
                suggestNodes = this.suggestListNode.find('.tbl-suggest'),
                re = new RegExp(filterVal);

            _.each(suggestNodes, function(node){
                $(node)[!filterVal || filterVal == '' || $(node).data('value').search(filterVal) > -1 ? 'show' : 'hide']();
            }, this);
        },

        populateSuggestListNode: function(){
            this.suggestListNode.empty();

            _.each(this.autoSuggestList, function(v){
                var valueNode = $('<li class="tbl-suggest">' + v + '</li>');
                valueNode.data('value', v);
                this.suggestListNode.append(valueNode);
            }, this);
        },

        populateValueListNode: function(){
            this.valueListNode.empty();

            _.each(this.valueList, function(v){
                var valueNode = $('<li class="tbl-value">' + v + '</li>');
                valueNode.data('value', v);
                this.valueListNode.append(valueNode);
            }, this);
        },

        updateRootNode: function(){
            this.valueList = _.uniq(_.reject(_.map(this.valueList, function(v){ return jQuery.trim(v); }), function(v){ return v == ""; }));
            this.sourceNode.val(this.valueList.join());
            this.populateValueListNode();
        }

	};

}(jQuery));