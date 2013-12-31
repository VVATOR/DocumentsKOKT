//   Copyright 2010 Marc BUILS
//
//   This file is part of Kamak.
//
//    Kamak is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Lesser General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Kamak is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser General Public License for more details.
//
//    You should have received a copy of the GNU Lesser General Public License
//    along with Kamak.  If not, see <http://www.gnu.org/licenses/>.

(function($){
    $.loading = function(){}
    $.loading.defaultOptions = {
            src: 	'images/loading.gif',
            alt: 	'Loading...',
            css: 	{
                		textAlign:  'center',
                		display:    'inline'
            		}
    };
    
    // constructor
    $.fn.loading = function(p_options) {
        var _options = $.extend({}, $.loading.defaultOptions, p_options);
        
        return this.each(function(){
            var $this = $(this);
            var _div = $('<div></div>');
            var _img = $('<img />');
            
            // div style
            _div.css(_options.css);
            
            // Load image
            _img.attr('src', _options.src);
            _img.attr('alt', _options.title);
            
            _div.append(_img);
            $this.html(_div);
        });
    }
})(jQuery)