# DOCKER-VERSION 0.3.4
FROM perl

LABEL MAINTAINER="dragos trif drd.trif@gmail.com" 

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN apt-get update && apt-get install apt-utils -y
RUN apt install build-essential -y --no-install-recommends

RUN cpanm --force URI::Fetch Net::Server Carton Starman

RUN cachebuster=b953b35 git clone https://github.com/DragosTrif/Dropzone-and-Mojolicious-Lite-Perl-.git
RUN cd Dropzone-and-Mojolicious-Lite-Perl- && cpanm -L local JavaScript::Minifier::XS && mkdir uploads && carton install --deployment

EXPOSE 8080

WORKDIR Dropzone-and-Mojolicious-Lite-Perl-

CMD carton exec starman --port 8080 upload_file.pl