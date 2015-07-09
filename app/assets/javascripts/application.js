// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


$(document).ready(function ()
{
    $('button#byname').click(function ()
    {
        if ($('#keyword').val() != '')
        {
            sendValueToController($('#keyword').val());            
        }
        return false;
        
    });
    
    $('button#soluong').click(function ()
    {
        if ($('#keysoluong').val() != '')
        {
            sendValueToController1($('#keysoluong').val());            
        }
        return false;
        
    });
    $('button#buy').click(function ()
    {
        alert('Chức năng này đang hoàn thiện, quay lại sau');
        
    });
});


function sendValueToController(s)
{
	
    

    $.ajax({
        url: "/change_sanpham_ten",
        data: { keyword_string: s },        
        type: "POST",
                
        success: function(data) {
	        alert(s);
	        return false;
		},
	  	error: function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                },
    });
    
    // alert(s);
}

function sendValueToController1(s)
{
	
    

    $.ajax({
        url: "/search_relation_item",
        data: { keyword_string: s },        
        type: "POST",
                
        success: function(data) {
	        alert(s);
	        return false;
		},
	  	error: function(xhr, ajaxOptions, thrownError){
                    alert(xhr.status);
                },
    });
    
    // alert(s);
}
