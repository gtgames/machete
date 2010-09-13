/*!
 * Galleria Frenzart Theme
 * http://frenzart.com
 */

(function($) {

Galleria.addTheme({
    name: 'frenz',
    author: 'aliem',
    version: '0.1',
    css: 'theme.css',
    defaults: {
        transition: 'none',
        image_crop: true,
        thumb_crop: 'height'
    },
    init: function(options) {
        this.appendChild('thumbnails-container');
        
        var loader = this.$('loader');
        var thumbs = this.$('thumbnails-container');
        var list = this.$('thumbnails-list');
        var infotext = this.$('info-text');
        var info = this.$('info');
        
        var POS = 0;
        
        if (Galleria.IE) {
            this.addElement('iefix');
            this.appendChild('container','iefix');
            this.setStyle(this.get('iefix'), {
                zIndex:3,
                position:'absolute',
                backgroundColor: '#000',
                opacity:.4
            })
        }
        
        if (options.thumbnails === false) {
            thumbs.hide();
        }
        
        var fixCaption = this.proxy(function(img) {
            if (!(img || img.width)) {
                return;
            }
            var w = Math.min(img.width, $(window).width());
            infotext.width(w-40);
            if (Galleria.IE && this.options.show_caption) {
                this.$('iefix').width(info.outerWidth()).height(info.outerHeight());
            }
        });
        
        this.bind(Galleria.RESCALE, function() {
            POS = this.stageHeight;
            thumbs.css('top', POS - list.outerHeight() - 16);
            var img = this.getActiveImage();
            if (img) {
                fixCaption(img);
            }
        });
        
        this.bind(Galleria.LOADSTART, function(e) {
            if (!e.cached) {
                loader.show().fadeTo(100, 1);
            }
            $(e.thumbTarget).css('opacity',1).parent().siblings('.active').children().css('opacity',.5);
        });

        this.bind(Galleria.LOADFINISH, function(e) {
            loader.fadeOut(300);
            this.$('info,iefix').toggle(this.hasInfo());
        });
        
        this.bind(Galleria.IMAGE, function(e) {
            fixCaption(e.imageTarget);
        });
        
        this.trigger(Galleria.RESCALE);
        
        this.addIdleState(thumbs, { opacity:0 });
        this.addIdleState(this.get('info'), { opacity:0 });
        this.addIdleState($('#menu'), { opacity:0 });
        
        if (Galleria.IE) {
            this.addIdleState(this.get('iefix'), { opacity:0 });
        }
        
        this.$('image-nav-left, image-nav-right').css('opacity',0.01).hover(function() {
            $(this).animate({opacity:1},100);
        }, function() {
            $(this).animate({opacity:0});
        }).show();
        
        this.$('thumbnails').children().hover(function() {
            $(this).not('.active').children().css('opacity', 1);
        }, function() {
            $(this).not('.active').children().fadeTo(200, .5);
        }).children().css('opacity',.5)
        
        $('#menu').hover(function() {
            $(this).css('opacity', 1);
        }, function() {
            $(this).fadeTo(200, .7);
        }).children().css('opacity',.7)
        
        
        this.enterFullscreen();
    }
});

})(jQuery);