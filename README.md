# Dropzone-and-Mojolicious-Lite-Perl


Here we used [Dropzone](https://www.dropzonejs.com/) api and [Perl Mojolicious](https://mojolicious.org/) web framework to upload and resize pictures.
Too see how we configured the drop zone api take a look a this code sinppet:
```javascript
( document ).ready(function() {
    console.log( "ready!" );
    $('div#myDropZone').dropzone({
  url:'/upload',
  maxFilesize: 3.6, // max upload size
  resizeWidth:  1000,// resise witdh 
  resizeHeight: 1000, //   resize height:
  resizeMethod: 'contain', resizeQuality: 1.0, // resize method
  init: function() {
    this.on('success', function( file, resp ){
      this.on("success", window.setTimeout("window.location.href='/display'", 1000)); // redirect
      console.log( file );
      console.log( resp );
    });
    this.on('thumbnail', function(file) {
      if ( file.width < 640 || file.height < 480 ) {
        file.rejectDimensions();
      }
      else {
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

```
