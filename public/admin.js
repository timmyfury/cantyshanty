(function($){

	$(function(){

		var toggle = $('.cloud-toggle'),
			cloud = $('.tag-cloud'),
			tags = $('.tag-cloud li a'),
			tagListInput = $('input[name="post[tag_list]"]'),
			
			usedTags = $.map(tagListInput.val().split(','), function(v, i){
					return $.trim(v);
				});

		/*
			toggle visibility of the tag cloud
		**********************************************************************/
		toggle.click(function(evt){
			evt.preventDefault();

			if(cloud.is(':visible')){
				toggle.text('Show tag cloud');
				cloud.hide();
			} else {
				toggle.text('Hide tag cloud');
				cloud.show();
			}
		});

		/*
			Highlight tags that are already in the taglist 
		**********************************************************************/
		var highlightUsedTags = function(){
				tags.each(function(i, tag){
					$(tag)[$.inArray($(tag).text(), usedTags) > -1 ? 'addClass' : 'removeClass']('tag-used');
				});
			};

		highlightUsedTags();

		/*
			tag clicks
		**********************************************************************/
		tags.click(function(evt){
			evt.preventDefault();

			var text = $(this).text(),
				position = $.inArray(text, usedTags);

			if(position > -1){
				usedTags.splice(position, 1);
			} else {
				usedTags.push(text);
			}
			usedTags.sort();
			tagListInput.val(usedTags.join(', '));
			highlightUsedTags();
		});

	});

}(jQuery));