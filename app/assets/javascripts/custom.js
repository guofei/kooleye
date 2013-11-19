//FIXME change to coffee

$(function(){
    var $container = $('#masonry-container');
    $container.imagesLoaded( function(){
	$container.masonry({
	    itemSelector : '.masonry-item'
	});
    });
});
