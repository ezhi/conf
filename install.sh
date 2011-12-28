( (cd ~/conf && git pull --ff-only) \
    || (cd ~ && git clone https://ezhi@github.com/ezhi/conf.git conf) ) \
&& cd ~ && ln -sf `find conf -maxdepth 1 -mindepth 1 -name ".*" | grep -vw .git` .
