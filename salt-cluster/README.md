# Simple salt cluster for test and development purpose

This is a really simple salt cluster with:
* `salt-master` service on single node named `salt`
* `salt-minion` service on single node named `salt-minion`
* cluster minion services on 2 nodes running CentOS 7

Minions automatically connect to master. However, their keys need to be
accepted before master can send commands to them:
```
salt-key --accept-all
```

Minions can be targeted by `roles` or `cluster` grain. Cluster minions have either
`master` or `slave` roles:
```
salt -G 'roles:master' test.ping
salt -G 'roles:slave' test.ping
```
