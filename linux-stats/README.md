# Linux statistics - Physical LOC, Maintainers, and Commits across Linux versions

### :construction_worker: WIP :construction_worker: 

### How to run experiments

There are only two requirements:

1. Have `docker` and `docker compose` installed on your system;
2. Have a Linux mainline kernel tree cloned.

With the docker daemon running, and inside the `linux-stats/` directory, simple
run

```shell
LINUX_MAINLINE=<path-to-Linux-mainline> docker compose up
```

The `data.csv` and the plots in `.pdf` format will be created at
`linux-stats/output/`.

By default, the version span is from v3.19 to v6.13. Unfortunately, to customize
this, you will need to adjust the `CMD` directive in the `Dockerfile`.

### Note

Running the experiments is kind of CPU intensive and time-consuming, as it
involves counting lines with [`cloc`](https://github.com/AlDanial/cloc) and some
`git checkout` commands both of which, in a codebase as vast as the Linux
kernel, takes a long time and consumes resources.
