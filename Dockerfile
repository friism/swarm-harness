FROM docker as bench

ADD bench.sh .
ENTRYPOINT [ "/bench.sh" ]

FROM docker as runner

ADD runner.sh .
ENTRYPOINT [ "/runner.sh" ]