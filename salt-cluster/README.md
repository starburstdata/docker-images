# Simple salt cluster for test and development purpose

This is a really simple salt cluster with:
* `salt-master` service on single node named `salt`
* `salt-minion` services on 2 minion nodes running CentOS 7

Minions automatically connect to master. However, their keys need to be
accepted before master can send commands to them:
```
salt-key --accept-all
```

Minions can be targeted by `roles` grain. One minion has `master` role and
two minions have `slave` roles:
```
salt -G 'roles:master' test.ping
salt -G 'roles:slave' test.ping
```
