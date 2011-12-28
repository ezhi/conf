cd && rm -rf conf && git clone git://github.com/ezhi/conf.git conf && \
    ln -sf `find conf -maxdepth 1 -mindepth 1 -name ".*" | grep -vw .git` .
