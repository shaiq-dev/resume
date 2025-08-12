FROM texlive/texlive:latest

# To add new packages, append to the tlmgr (TeX Live Manager) install line below.
RUN tlmgr update --self && \
    tlmgr install \
    titlesec \
    marvosym \
    enumitem \
    fancyhdr \
    hyperref \
    xcolor \
    collection-fontsrecommended \
    collection-latexrecommended


# To build the resume, mount the LaTeX source folder to /data:
#   docker run --rm -v $(pwd)/src:/data latex-builder pdflatex resume.tex
WORKDIR /data
