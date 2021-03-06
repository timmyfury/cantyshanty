(function($){

	$.fn.extend({
		uploader: function(opts){
			opts = $.extend({
				url: null,
				name: null
			}, opts);

			return this.each(function(){
				var uuuploader = new Uploader(this, opts);
				window.uuuploader = uuuploader;
				return uuuploader;
			});
		}
	});

	var UploaderItem = function(file){

		this.status = "queued";
		this.file = file;
		this.name = file.name;
		this.id = null;

		var template = '<div class="file-item">' +
		                    '<a class="file-link">' +
    							'<div><img class="file-image" /></div>' +
    							'<div><span class="file-status">' + this.status + '</span></div>' +
							'</a>' +
						'</div>';

		this.node = $(template);
		this.linkNode = this.node.find('.file-link');
		this.imageNode = this.node.find('.file-image');
		this.statusNode = this.node.find('.file-status');

	}; UploaderItem.prototype = {

		updateStatus: function(status){
			this.status = status;
			this.statusNode.html(status);
		},

		setImage: function(image){
			this.image = image;
			this.imageNode.attr('src', image);
			this.imageNode.css('height', 'auto');
		},

		setID: function(id){
			this.id = id;
			this.linkNode.attr('href', '/posts/' + this.id);
		},

		toString: function(){
			return "UploaderItem: " + this.name;
		}

	};

	var Uploader = function(el, opts){
		this.rootNode = $(el);
		this.opts = opts;
		this.queueing = false;
		this.queue = [];

		this.setupDom();
		this.attachEvents();
		
	}; Uploader.prototype = {

		setupDom: function(){
			var template = '<div class="uploader">' +
								'<div class="target">' +
									'<div class="instructions">' +
										'<span class="not-mobile">Drag and drop images here to upload them or </span>' +
										'<a href="#" class="select">select files to upload</a>.' +
									'</div>' +
									'<div class="status"></div>' +
									'<input class="file" type="file" multiple="true" accept="image/*" />' +
								'</div>' +
								'<div class="file-list"></div>' +
							'</div>';

			this.node = $(template);
			this.node.appendTo(this.rootNode);

			this.targetNode = this.node.find('.target');
			this.instructionsNode = this.node.find('.instructions');
			this.selectNode = this.node.find('.select');
			this.statusNode = this.node.find('.status');
			this.fileNode = this.node.find('.file');
			this.filelistNode = this.node.find('.file-list');

			this.updateStatus();
		},

		attachEvents: function(){
			// dragstart
			// drag
			// dragenter
			// dragleave
			// dragover
			// drop
			// dragend
		    
			this.targetNode[0].addEventListener("dragleave", jQuery.proxy(this, 'onDragleave'), true);
			this.targetNode[0].addEventListener("dragover", jQuery.proxy(this, 'onDragover'), true);
			this.targetNode[0].addEventListener("drop", jQuery.proxy(this, 'onDrop'), false);

			this.selectNode.click(jQuery.proxy(this, 'onSelectClick'));

			this.fileNode[0].addEventListener("change", jQuery.proxy(this, 'onFileNodeChange'), false);
			// this.fileNode.change();
		},

		onSelectClick: function(evt){
			this.fileNode.click();
			evt.preventDefault();
		},

		onFileNodeChange: function(evt){
			_.each(this.fileNode[0].files, function(file){
				this.process(file);
			}, this);
		},

		onDragleave: function(evt){
			this.node.removeClass('uploader-over');
		},

		onDragover: function(evt){
			evt.stopPropagation(); 
			evt.preventDefault();
			this.node.addClass('uploader-over');
		},

		onDrop: function(evt){
			evt.preventDefault();

			this.node.removeClass('uploader-over');

			this.queueing = true;

			_.each(evt.dataTransfer.files, function(file){
				this.process(file);
			}, this);

			this.queueing = false;
			this.upload();
		},

		process: function(file){
			var item = new UploaderItem(file);

			this.filelistNode.append(item.node);

			this.queue.push(item);
			this.upload();
		},

		updateStatus: function(){
			var template = this.getCompletedItems().length + ' images uploaded <span>&bull;</span> ' + 
							this.getQueuedItems().length + ' images remaining <span>&bull;</span> ' +
							(this.uploading ? '1' : '0') + ' images uploading';
			this.statusNode.html(template);
		},

		upload: function(){
			if(!this.queueing && !this.uploading && this.getQueuedItems().length > 0){
				this.uploading = true;

				this.updateStatus();

				var item = this.getNextItem(),
					data = new FormData();

				item.updateStatus('uploading');
				data.append(this.opts.name, item.file);
				data.append('uploadPosition',  this.getPositionByItem(item));

				$.ajax({
				    url: this.opts.url,
				    data: data,
				    cache: false,
				    contentType: false,
				    processData: false,
				    type: 'POST',
				    success: jQuery.proxy(this, 'success')
				});
			}
		},

		success: function(data){
			var item = this.getItemByPosition(data.queue_position);
			item.updateStatus("complete");
			item.setImage(data.image_sizes.medium);
			item.setID(data.id);

			this.updateStatus();
			this.uploading = false;
			this.upload();
		},

		getQueuedItems: function(){
			return _.filter(this.queue, function(item){ return item.status == 'queued'; }, this);
		},

		getCompletedItems: function(){
			return _.filter(this.queue, function(item){ return item.status == 'complete'; }, this);
		},

		getNextItem: function(){
			return _.find(this.queue, function(item){ return item.status == 'queued'; }, this);
		},

        getPositionByItem: function(item){
            return _.indexOf(this.queue, item);
        },

		getItemByPosition: function(position){
			return this.queue[position];
		}

	};

}(jQuery));