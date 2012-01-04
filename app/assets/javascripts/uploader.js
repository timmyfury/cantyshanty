(function($){

	$.fn.extend({
		uploader: function(opts){
			opts = $.extend({
				url: null,
				name: null
			}, opts);

			return this.each(function(){
				return new Uploader(this, opts);
			});
		}
	});

	var Uploader = function(el, opts){
		this.rootNode = $(el);
		this.opts = opts;
		this.uploadQueue = [];
		this.completeQueue = [];

		this.setupDom();
		this.attachEvents();
		
	}; Uploader.prototype = {

		setupDom: function(){
			var template = '<div class="uploader">' +
								'<div class="uploader-instructions">' +
									'Drag and drop images here to upload them or ' +
									'<a href="#" class="uploader-select">select files to upload</a>.' +
								'</div>' +
								'<div class="uploader-status"></div>' +
								'<input class="uploader-file" type="file" multiple="true" accept="image/*" />' +
							'</div>';
			
			this.targetNode = $(template).appendTo(this.rootNode);
			this.instructionsNode = this.targetNode.find('.uploader-instructions');
			this.selectNode = this.targetNode.find('.uploader-select');
			this.statusNode = this.targetNode.find('.uploader-status');
			this.fileNode = this.targetNode.find('.uploader-file');

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
			this.targetNode.removeClass('uploader-over');
		},

		onDragover: function(evt){
			evt.stopPropagation(); 
			evt.preventDefault();
			this.targetNode.addClass('uploader-over');
		},

		onDrop: function(evt){
			evt.preventDefault();

			this.targetNode.removeClass('uploader-over');

			_.each(evt.dataTransfer.files, function(file){
				this.process(file);
			}, this);
		},

		process: function(file){
			this.uploadQueue.push(file);
			this.upload();
		},

		updateStatus: function(){
			var template = this.completeQueue.length + ' images uploaded <span>&bull;</span> ' + 
							this.uploadQueue.length + ' images remaining <span>&bull;</span> ' +
							(this.uploading ? '1' : '0') + ' images uploading';
			this.statusNode.html(template);
		},

		upload: function(){
			if(!this.uploading && this.uploadQueue.length > 0){
				this.uploading = true;

				this.updateStatus();

				var file = _.first(this.uploadQueue),
					data = new FormData();

				data.append(this.opts.name, file);

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
			console.log(this, data);
			this.completeQueue.push(data);
			this.uploadQueue = _.rest(this.uploadQueue);
			this.uploading = false;
			this.updateStatus();
			this.upload();
		}

	};

}(jQuery));