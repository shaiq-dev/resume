FROM texlive/texlive:latest

# The default mirror used by TeX Live (https://mirror.apps.cam.ac.uk/...) is unreachable from GitHub Actions
RUN tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet

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
