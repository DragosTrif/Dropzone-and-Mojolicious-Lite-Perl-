#!/usr/bin/env perl
use Mojolicious::Lite;
use File::Spec;

plugin 'RenderFile';
plugin AssetPack => { pipes => [qw(Vuejs JavaScript Css)] };

my $dir = './uploads';

# define asset
app->asset->process(
  # virtual name of the asset
  "dropzone" => (
    "dz.js",
    'https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js',
    'https://unpkg.com/dropzone@5/dist/min/dropzone.min.js',
    'https://unpkg.com/dropzone@5/dist/min/dropzone.min.css',
    'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css',
    'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js',
  ),
);


any '/' => sub {
  my $c = shift;
  $c->render( template => 'index' );
};

post '/upload' => sub {
  my $c = shift;
  
  foreach my $file ( @{ $c->req->uploads('files') } ) {
    my $full_path = File::Spec->catfile( 'uploads', $file->filename() );
    $file->move_to($full_path);;
  }

  return $c->redirect_to('/display');
};

get '/display' => sub {
  my $c = shift;

  foreach my $pic ( @{ get_images() } ) {
    $c->render_file(
      'filepath' => "uploads/$pic", 
      'filename' => $pic,
      'format'   => 'jpeg',
      'content_disposition' => 'inline',
     );
  }
};


sub get_images {
  my $dir = 'uploads';

  opendir ( my $dh, $dir ) 
    or die "can not open $dir: $!";
  my @images = grep { !/^\./ } readdir( $dh );
  closedir $dh
    or die "can not close $dir: $!";

  return \@images;

}

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to Perl Mojolicious and Dropzonejs !</h1>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head>
    %= asset "dropzone"
    <title><%= title %></title>
  </head>
  <body><%= content %>
    <div id='myDropZone' class="dropzone bp-3 bg-info bg-opacity-10 border border-1 border-info border-start-0 rounded-end">
    <div class="dz-message" data-dz-message><span>upload file</span></div>
    </div>
  </body>
</html>