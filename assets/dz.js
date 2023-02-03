$(document).ready(function() {
  $('div#myDropZone').dropzone({
    url: '/upload',
    maxFilesize: 3.6, // max upload size
    resizeWidth: 1000, // resise witdh 
    resizeHeight: 1000, //   resize height:
    resizeMethod: 'contain',
    resizeQuality: 1.0, // resize method
    init: function() {
      this.on('success', function(file, resp) {
        this.on("success", window.setTimeout("window.location.href='/display'", 1000)); // redirect
      });
      this.on('thumbnail', function(file) {
        if (file.width < 640 || file.height < 480) {
          file.rejectDimensions();
        } else {
          file.acceptDimensions();
        }
      });
    },
    accept: function(file, done) {
      file.acceptDimensions = done;
      file.rejectDimensions = function() {
        done('The image must be at least 640 x 480px')
      };
    },
  });
});