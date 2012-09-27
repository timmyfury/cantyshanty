(function($){

	$(function(){
		$('#image-uploader').uploader({
			url: '/posts.json',
			name: 'post[image]'
		});

        var tagListNode = $('input.tag-list'),
            tagListVal = tagListNode.val() || "",
            tagList = tagListVal.split("|||");

        $('#post_tag_list').textBoxList({
            autoSuggestList: tagList
        });
	});

}(jQuery));